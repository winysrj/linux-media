Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33436 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdHRLPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 07:15:02 -0400
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
Subject: Re: [PATCH 1/4] v4l: async: fix unbind error in v4l2_async_notifier_unregister()
Date: Fri, 18 Aug 2017 14:15:26 +0300
Message-ID: <2638355.RUWT87hFr5@avalon>
In-Reply-To: <20170815161604.5qjrd3eas4tlvrt6@valkosipuli.retiisi.org.uk>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se> <20170730223158.14405-2-niklas.soderlund+renesas@ragnatech.se> <20170815161604.5qjrd3eas4tlvrt6@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 15 Aug 2017 19:16:14 Sakari Ailus wrote:
> On Mon, Jul 31, 2017 at 12:31:55AM +0200, Niklas S=F6derlund wrote:
> > The call to v4l2_async_cleanup() will set sd->asd to NULL so passin=
g it
> > to notifier->unbind() have no effect and leaves the notifier confus=
ed.
> > Call the unbind() callback prior to cleaning up the subdevice to av=
oid
> > this.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnate=
ch.se>
>=20
> This is a bugfix and worthy without any other patches and so should b=
e
> applied separately.
>=20
> I think it'd be safer to store sd->asd locally and call the notifier =
unbind
> with that. Now you're making changes to the order in which things wor=
k, and
> that's not necessary to achieve the objective of passing the async su=
bdev
> pointer to the notifier.

But on the other hand I think the unbind notification should be called =
before=20
the subdevice gets unbound, the same way the bound notification is call=
ed=20
after it gets bound. One of the purposes of the unbind notification is =
to=20
allow drivers to prepare for subdev about to be unbound, and they can't=
=20
prepare if the unbind happened already.

> With that changed,
>=20
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>=20
> > ---
> >=20
> >  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index
> > 851f128eba2219ad..0acf288d7227ba97 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -226,14 +226,14 @@ void v4l2_async_notifier_unregister(struct
> > v4l2_async_notifier *notifier)>=20
> >  =09=09d =3D get_device(sd->dev);
> >=20
> > +=09=09if (notifier->unbind)
> > +=09=09=09notifier->unbind(notifier, sd, sd->asd);
> > +
> >=20
> >  =09=09v4l2_async_cleanup(sd);
> >  =09=09
> >  =09=09/* If we handled USB devices, we'd have to lock the parent t=
oo=20
*/
> >  =09=09device_release_driver(d);
> >=20
> > -=09=09if (notifier->unbind)
> > -=09=09=09notifier->unbind(notifier, sd, sd->asd);
> > -
> >=20
> >  =09=09/*
> >  =09=09
> >  =09=09 * Store device at the device cache, in order to call
> >  =09=09 * put_device() on the final step

--=20
Regards,

Laurent Pinchart
