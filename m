Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33455 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdHRLTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 07:19:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 4/4] v4l: async: add comment about re-probing to v4l2_async_notifier_unregister()
Date: Fri, 18 Aug 2017 14:20:08 +0300
Message-ID: <2865661.SePdnx8dyz@avalon>
In-Reply-To: <20170815160932.fizwqqkaivtz3nqu@valkosipuli.retiisi.org.uk>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se> <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se> <20170815160932.fizwqqkaivtz3nqu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 15 Aug 2017 19:09:33 Sakari Ailus wrote:
> On Mon, Jul 31, 2017 at 12:31:58AM +0200, Niklas S=F6derlund wrote:
> > The re-probing of subdevices when unregistering a notifier is trick=
y to
> > understand, and implemented somewhat as a hack. Add a comment tryin=
g to
> > explain why the re-probing is needed in the first place and why exi=
sting
> > helper functions can't be used in this situation.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnate=
ch.se>
> > ---
> >=20
> >  drivers/media/v4l2-core/v4l2-async.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >=20
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index
> > d91ff0a33fd3eaff..a3c5a1f6d4d2ab03 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -234,6 +234,23 @@ void v4l2_async_notifier_unregister(struct
> > v4l2_async_notifier *notifier)>=20
> >  =09mutex_unlock(&list_lock);
> >=20
> > +=09/*
> > +=09 * Try to re-probe the subdevices which where part of the notif=
ier.
> > +=09 * This is done so subdevices which where part of the notifier =
will
> > +=09 * be re-probed to a pristine state and put back on the global
> > +=09 * list of subdevices so they can once more be found and associ=
ated
> > +=09 * with a new notifier.
>=20
> Instead of tweaking the code trying to handle unhandleable error cond=
itions
> in notifier unregistration and adding lengthy stories on why this is =
done
> the way it is, could we simply get rid of the driver re-probing?
>=20
> I can't see why drivers shouldn't simply cope with the current interf=
aces
> without re-probing to which I've never seen any reasoned cause. When =
a
> sub-device driver is unbound, simply return the sub-device node to th=
e list
> of async sub-devices.

I agree, this is a hack that we should get rid of. Reprobing has been t=
here=20
from the very beginning, it's now 4 years and a half old, let's allow i=
t to=20
retire :-)

> Or can someone come up with a valid reason why the re-probing code sh=
ould
> stay? :-)
>=20
> > +=09 *
> > +=09 * One might be tempted to use device_reprobe() to handle the r=
e-
> > +=09 * probing. Unfortunately this is not possible since some video=

> > +=09 * device drivers call v4l2_async_notifier_unregister() from
> > +=09 * there remove function leading to a dead lock situation on
> > +=09 * device_lock(dev->parent). This lock is held when video devic=
e
> > +=09 * drivers remove function is called and device_reprobe() also
> > +=09 * tries to take the same lock, so using it here could lead to =
a
> > +=09 * dead lock situation.
> > +=09 */
> > +
> >  =09for (i =3D 0; i < count; i++) {
> >  =09
> >  =09=09/* If we handled USB devices, we'd have to lock the parent t=
oo=20
*/
> >  =09=09device_release_driver(dev[i]);

--=20
Regards,

Laurent Pinchart
