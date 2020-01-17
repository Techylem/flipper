import { app, BrowserWindow, Tray, Menu, ipcMain, dialog } from "electron";
import * as path from "path";
import * as url from "url";
//update
import { windowStateKeeper } from "./win-state-keeper";

// import { DB } from './db/db';
// import { Sync } from './sync/sync'

//TODO: make sure to fix icon thing it is not building

let win, serve;
const args = process.argv.slice(1); 
serve = args.some(val => val === "--serve");
if (process.mas) app.setName("Flipper");
const debug = /--debug/.test(process.argv[2]);
const log = require("electron-log");
const { autoUpdater } = require("electron-updater");
autoUpdater.logger = log;
autoUpdater.logger.transports.file.level = "info";

let iconName;
if (serve) {
  if(process.platform === "win32"){
    iconName ='/app-icon/win/icon.ico';
  }else
  if(process.platform === "darwin"){
    iconName ='/app-icon/mac/icon.icns';
  }else{
    iconName ='/app-icon/png/icon.png';
  }
 
} else {
  if(process.platform === "win32"){
    iconName ='/app-icon/win/icon.ico';
  }else
  if(process.platform === "darwin"){
    iconName ='/app-icon/mac/icon.icns';
  }else{
    iconName ='/app-icon/png/icon.png';
  }
}
//init a sync...
//new Sync();
const isDev = require("electron-is-dev");
function sendStatusToWindow(text) {
  log.info(app.getVersion() + "::" + text);
  win.webContents.send("message", text);
}


//Events listerns
ipcMain.on("iWantDataWith", (event, dataType) => {
  if (dataType == "customers") {
    // DB.select('users').subscribe(users => {
    //   event.sender.send("hereIsYourData", users);
    // });
  }
});
ipcMain.on("iWantToSaveDataOf", (event, args) => {

  // DB.insert(args.table, args.data).subscribe(users => {
  //   event.sender.send("hereIsYourData", users);
  // });

});
ipcMain.on('main-send', function(event, sender_name) {

  var arr = BrowserWindow.getAllWindows();
  for(var i = 0; i < arr.length; i++){
      const toWindow = arr[i];
      toWindow.webContents.send('picker-list-update');
  }

});
ipcMain.on("version-ping", (event, arg) => {
  event.sender.send("version-pong", app.getVersion());
});
// End of events listers
if (!isDev) {
  autoUpdater.on("checking-for-update", () => {
    sendStatusToWindow("Checking for update...");
    // tag
  });
  autoUpdater.on("update-available", info => {
    sendStatusToWindow("Update available.");
  });
  autoUpdater.on("update-not-available", info => {
    sendStatusToWindow("Update not available.");
  });
  autoUpdater.on("error", err => {
    sendStatusToWindow("Error in auto-updater. " + err);
  });
  autoUpdater.on("download-progress", progressObj => {
    let log_message = "Download speed: " + progressObj.bytesPerSecond;
    log_message = log_message + " - Downloaded " + progressObj.percent + "%";
    log_message =
      log_message +
      " (" +
      progressObj.transferred +
      "/" +
      progressObj.total +
      ")";
    sendStatusToWindow(log_message);
  });
  autoUpdater.on("update-downloaded", info => {

    const dialogOpts = {
      type: "info",
      buttons: ["Restart", "Later"],
      title: "Application Update",
      // message: process.platform === 'win32' ? info : info,
      message: "updated the app",
      detail:
        "A new version has been downloaded. Restart the application to apply the updates."
    };

    dialog.showMessageBox(dialogOpts, response => {
      if (response === 0) autoUpdater.quitAndInstall();
    });

    sendStatusToWindow("Update downloaded");
    
  });
}

makeSingleInstance();

function createWindow() {
  const mainWindowStateKeeper = windowStateKeeper("main");
  const windowOptions = {
    x: mainWindowStateKeeper.x,
    y: mainWindowStateKeeper.y,
    width: mainWindowStateKeeper.width,
    height: mainWindowStateKeeper.height,
    frame: false,
    webPreferences: {
      nodeIntegration: true
      },
      icon: path.join(__dirname, iconName)
  };


  win = new BrowserWindow(windowOptions);

  if (serve) {
    //customTitlebar.updateIcon('src/assets/logo/icon.ico');
    require("electron-reload")(__dirname, {
      electron: require(`${__dirname}/node_modules/electron`)
    });
    win.loadURL("http://localhost:4200");
  } else {
   // customTitlebar.updateIcon('dist/src/assets/logo/icon.ico');
    win.loadURL(
      url.format({
        pathname: path.join(__dirname, "dist/index.html"),
        protocol: "file:",
        slashes: true
      })
    );
  }
  //win.localStorage.setItem("version", app.getVersion());
  // win.webContents.openDevTools();
  if (debug) {
    win.webContents.openDevTools();

    win.maximize();
    require("devtron").install();
  }
  //win.setMenu(null);
  win.on("closed", () => {
    win = null;
  });

  let appIcon = null;



  const iconPath = path.join(__dirname, iconName);
  appIcon = new Tray(iconPath);

  const contextMenu = Menu.buildFromTemplate([
    
    {
    label: "Create Account",
        click() {
          require("electron").shell.openExternal("https://yegobox.com/register");
        }
      },
      {
        label: "Help Center",
        click() {
          require("electron").shell.openExternal("https://flipper.rw");
        }
      },
      {
        label: "About Flipper",
        click() {
          const modalPath = path.join('file://', __dirname, 'about.html')
          let wins = new BrowserWindow({frame: false, alwaysOnTop: true,transparent: true, width: 450, height: 250,
             webPreferences: {
            nodeIntegration: true
            },
            icon: path.join(__dirname, iconName) })
          wins.on('close', function () { wins = null })
          wins.loadURL(modalPath)
          wins.setMenu(null)
          wins.show();
        }
      },
      { 
        role: "Quit",
        click: () => {
            if (process.platform !== "darwin") {
              app.quit();
              win = null;
            }
          }
       }
  ]);

  appIcon.setToolTip("Flipper");
  appIcon.setContextMenu(contextMenu);

  
  ipcMain.on("remove-tray", () => {
    appIcon.destroy();
  });
  
  app.on("window-all-closed", () => {
    if (appIcon) appIcon.destroy();
  });

}

function makeSingleInstance() {
  if (process.mas) return;

  app.requestSingleInstanceLock();

  app.on("second-instance", () => {
    if (win) {
      if (win.isMinimized()) win.restore();
      win.focus();
    }
  });
}


try {
  app.on("ready", createWindow);

  app.on("ready", function () {
    if (!isDev) {
      autoUpdater.checkForUpdatesAndNotify();
    }
  });
  app.on("window-all-closed", () => {
    if (process.platform !== "darwin") {
      app.quit();
    }
  });

  app.on("activate", () => {
    if (win === null) {
      createWindow();
    }
  });
} catch (e) { }


/////////////////////////////////////////  MENU

const menu = Menu.buildFromTemplate([
  {
    label: 'Flipper',
    submenu: [
      { 
        role: "Quit",
        click: () => {
            if (process.platform !== "darwin") {
              app.quit();
              win = null;
            }
          }
       }
    ]
  },

  {
    label: "View",
    submenu: [
      { role: "reload" },
      { role: "forcereload" },
      { role: "toggledevtools" },
      { type: "separator" },
      { role: "resetzoom" },
      { role: "zoomin" },
      { role: "zoomout" },
      { type: "separator" },
      { role: "togglefullscreen" }
    ]
  },

  {
    role: "Help",
    submenu: [
      {
        label: "Help Center",
        click() {
          require("electron").shell.openExternal("https://flipper.rw");
        }
      },
      {
        label: "About Flipper",
        click() {
          const modalPath = path.join('file://', __dirname, 'about.html')
          let wins = new BrowserWindow({frame: false, alwaysOnTop: true,transparent: true, width: 450, height: 250, 
            webPreferences: {
            nodeIntegration: true
            },
            icon: path.join(__dirname, iconName) })
          wins.on('close', function () { wins = null })
          wins.loadURL(modalPath)
          wins.setMenu(null)
          wins.show();
        }
      }
    ]
  }
]);
Menu.setApplicationMenu(menu);
