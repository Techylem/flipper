import { Injectable } from '@angular/core'
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router'
import { CurrentUser } from './current-user'
import { FlipperEventBusService } from '@enexus/flipper-event'
import { filter } from 'rxjs/internal/operators'
import { UserLoggedEvent } from '@enexus/flipper-components'

@Injectable({
  providedIn: 'root',
})
export class GuestGuard implements CanActivate {
  constructor(private eventBus: FlipperEventBusService, private currentUser: CurrentUser, private router: Router) {
    this.eventBus
      .of<UserLoggedEvent>(UserLoggedEvent.CHANNEL)
      .pipe(filter(e => e.user && (e.user.id !== null || e.user.id !== undefined)))
      .subscribe(res => (this.currentUser.currentUser = res.user))
  }

  async canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    await this.currentUser.user()

    if (!this.currentUser.currentUser) {
      return true
    }
    this.router.navigate([this.currentUser.getRedirectUri()])

    return false
  }
}
