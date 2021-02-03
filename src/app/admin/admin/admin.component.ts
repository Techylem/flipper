import { Component, OnInit, OnDestroy } from '@angular/core'
import { CurrentUser } from '../../core/guards/current-user'
import { PouchConfig, PouchDBService } from '@enexus/flipper-components'

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.scss'],
})
export class AdminComponent implements OnInit, OnDestroy {
  userToggledMenu: any

  constructor(private database: PouchDBService, public currentUser: CurrentUser) {}

  ngOnDestroy() {}

  async ngOnInit() {
    // await this.currentUser.user()
  }
  isMenuToggled(event) {
    this.userToggledMenu = event
  }

  displaySwitchedBranch(event) {}

  async didUserLoggedOut(event) {
    // await this.currentUser.user()

    // if (this.currentUser.currentUser) {
    //   this.currentUser.currentUser.active = false
    //   await this.database.put(this.currentUser.currentUser.id, this.currentUser.currentUser)
    // }
    // window.localStorage.setItem('channel', this.currentUser.currentUser.id)

    // return (window.location.href = '/login')
  }
}
