import { Injectable } from '@angular/core'

import { FlipperEventBusService } from '@enexus/flipper-event'
import {
  MenuEntries,
  Business,
  Branch,
  Subscription,
  PouchDBService,
  PouchConfig,
  Tables,
  Menu,
  UserLoggedEvent,
  UserSubscriptionEvent,
  CurrentBusinessEvent,
  User,
} from '@enexus/flipper-components'

import { CurrentBranchEvent } from '@enexus/flipper-components'
import { ModelService } from '@enexus/flipper-offline-database'
import { HttpClient } from '@angular/common/http'
import { environment } from '../../../environments/environment'
import { Router } from '@angular/router'

@Injectable({
  providedIn: 'root',
})
export class CurrentUser {
  public redirectUri?: string
  public userInfo = null
  public current: MenuEntries
  currentUser: User = null
  currentBusiness: Business = null
  currentBranch: Branch = null
  currentSubscription: Subscription = null

  constructor(
    private http: HttpClient,
    private router: Router,
    private eventBus: FlipperEventBusService,
    private model: ModelService,
    private database: PouchDBService
  ) {
    this.database.connect(PouchConfig.bucket, window.localStorage.getItem('channel'))
  }

  public get<K extends keyof User>(prop: K): User[K] {
    return this.currentUser && this.currentUser[prop]
  }

  public set(key: string, value: any): void {
    this.currentUser[key] = value
  }

  public async user() {
    await this.http
    .get<User>(environment.url + '/api/user')
    .toPromise()
    .then(user => {
      this.eventBus.publish(new UserLoggedEvent(user))
    }).catch(err => {
      this.eventBus.publish(new UserLoggedEvent(null))
    })
  }

  public async subscription() {
    await this.database.get(PouchConfig.Tables.subscription).then(
      (res: Subscription) => {
        this.eventBus.publish(new UserSubscriptionEvent(res))
      },
      (error: { error: any; status: string | number }) => {
        if ((error.error && error.status === '404') || error.status === 404) {
          this.eventBus.publish(new UserSubscriptionEvent(null))
        }
      }
    )
  }
  public async configAuthUser(userId){
    await this.http
      .post(environment.url + '/auth', {
        userId: userId,
      })
      .toPromise()
      .then(async (user)=>{
        await this.defaultBusiness(userId)
      })
  }
  public async defaultBusiness(userId:string) {
    await this.http
      .get<Business>(environment.url + '/api/business')
      .toPromise()
      .then(business => {
        localStorage.setItem('userId',userId)
        this.eventBus.publish(new CurrentBusinessEvent(business))
        this.router.navigate(['/analytics']);
      })
  }
  public async defaultBranch() {
    if (this.currentBusiness) {
      await this.http
        .get<Business>(environment.url + '/api/branches/' + this.currentBusiness.id)
        .toPromise()
        .then(business => {
          this.eventBus.publish(new CurrentBusinessEvent(business))
        })
    }
  }
  public userHasBusiness() {
    return this.model.active<Business>(Tables.business)
  }

  public activeMenu() {
    return this.model.active<Menu>(Tables.menu)
  }

  public insertUser(user: User) {
    return this.model.create<User>(Tables.user, [user])
  }

  public updateUser(user: User, id: number) {
    return this.model.update<User>(Tables.user, user, id)
  }

  public getRedirectUri(): string {
    let uri = null
    uri = this.redirectUri
    this.redirectUri = null
    return uri
  }
}
