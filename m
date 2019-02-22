Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6916C4360F
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 08:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A479F207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 08:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfBVIqN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:46:13 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:54453 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfBVIqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 03:46:12 -0500
X-Originating-IP: 31.157.247.153
Received: from uno.localdomain (unknown [31.157.247.153])
        (Authenticated sender: jacopo@jmondi.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A83A6FF817;
        Fri, 22 Feb 2019 08:46:07 +0000 (UTC)
Date:   Fri, 22 Feb 2019 09:46:34 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190222084634.26clkuumd3mgsw4f@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190115235145.GF31088@pendragon.ideasonboard.com>
 <20190221145920.7w7mynzhdwln4drb@uno.localdomain>
 <20190221234936.pbbymgzmqrv7ypje@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="khdpzh3now36xi5h"
Content-Disposition: inline
In-Reply-To: <20190221234936.pbbymgzmqrv7ypje@kekkonen.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--khdpzh3now36xi5h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Fri, Feb 22, 2019 at 01:49:36AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Thu, Feb 21, 2019 at 03:59:20PM +0100, Jacopo Mondi wrote:
> > Hi Sakari, Laurent, Niklas,
> >    (another) quick question, but a different one :)
> >
> > On Wed, Jan 16, 2019 at 01:51:45AM +0200, Laurent Pinchart wrote:
> > > Hi Niklas,
> > >
> > > Thank you for the patch.
> > >
> > > On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas S=C3=B6derlund wrote:
> > > > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > >
> > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > > >
> > > > - Add sink and source streams for multiplexed links
> > > > - Copy the argument back in case of an error. This is needed to let=
 the
> > > >   caller know the number of routes.
> > > >
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> > > > ---
> > > >  drivers/media/v4l2-core/v4l2-ioctl.c  | 20 +++++++++++++-
> > > >  drivers/media/v4l2-core/v4l2-subdev.c | 28 +++++++++++++++++++
> > > >  include/media/v4l2-subdev.h           |  7 +++++
> > > >  include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++=
++++
> > >
> > > Missing documentation :-(
> > >
> > > >  4 files changed, 94 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v=
4l2-core/v4l2-ioctl.c
> > > > index 7de041bae84fb2f2..40406acb51ec0906 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > @@ -19,6 +19,7 @@
> > > >  #include <linux/kernel.h>
> > > >  #include <linux/version.h>
> > > >
> > > > +#include <linux/v4l2-subdev.h>
> > > >  #include <linux/videodev2.h>
> > > >
> > > >  #include <media/v4l2-common.h>
> > > > @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd=
, void *parg, size_t *array_size,
> > > >  		}
> > > >  		break;
> > > >  	}
> > > > +
> > > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > > +		struct v4l2_subdev_routing *route =3D parg;
> > > > +
> > > > +		if (route->num_routes > 0) {
> > > > +			if (route->num_routes > 256)
> > > > +				return -EINVAL;
> > > > +
> > > > +			*user_ptr =3D (void __user *)route->routes;
> > > > +			*kernel_ptr =3D (void *)&route->routes;
> > > > +			*array_size =3D sizeof(struct v4l2_subdev_route)
> > > > +				    * route->num_routes;
> > > > +			ret =3D 1;
> > > > +		}
> > > > +		break;
> > > > +	}
> > > >  	}
> > > >
> > > >  	return ret;
> > > > @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned in=
t cmd, unsigned long arg,
> > > >  	 * Some ioctls can return an error, but still have valid
> > > >  	 * results that must be returned.
> > > >  	 */
> > > > -	if (err < 0 && !always_copy)
> > > > +	if (err < 0 && !always_copy && cmd !=3D VIDIOC_SUBDEV_G_ROUTING)
> > >
> > > This seems like a hack. Shouldn't VIDIOC_SUBDEV_G_ROUTING set
> > > always_copy instead ?
> > >
> > > >  		goto out;
> > > >
> > > >  out_array_args:
> > > > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/=
v4l2-core/v4l2-subdev.c
> > > > index 792f41dffe2329b9..1d3b37cf548fa533 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > > > @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file,=
 unsigned int cmd, void *arg)
> > > >
> > > >  	case VIDIOC_SUBDEV_QUERYSTD:
> > > >  		return v4l2_subdev_call(sd, video, querystd, arg);
> > > > +
> > > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > > +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> > > > +
> > > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > > +		struct v4l2_subdev_routing *route =3D arg;
> > > > +		unsigned int i;
> > > > +
> > > > +		if (route->num_routes > sd->entity.num_pads)
> > > > +			return -EINVAL;
> > > > +
> > > > +		for (i =3D 0; i < route->num_routes; ++i) {
> >
> > How have you envisioned the number of routes to be negotiated with
> > applications? I'm writing the documentation for this ioctl, and I
> > would like to insert this part as well.
> >
> > Would a model like the one implemented in G_TOPOLOGY work in your
> > opinion? In my understanding, at the moment applications do not have a
> > way to reserve a known number of routes entries, but would likely
> > reserve 'enough(tm)' (ie 256) and pass them to the G_ROUTING ioctl that=
 the
> > first time will likely adjust the number of num_routes and return -ENOS=
PC.
> >
> > Wouldn't it work to make the IOCTL behave in a way that it
> > expects the first call to be performed with (num_routes =3D=3D 0) and n=
o routes
> > entries reserved, and just adjust 'num_routes' in that case?
> > So that applications should call G_ROUTING a first time with
> > num_routes =3D 0, get back the number of routes entries, reserve memory
> > for them, and then call G_ROUTING again to have the entries populated
> > by the driver. Do you have different ideas or was this the intended
> > behavior already?
>
> I think whenever the number of routes isn't enough to return them all, the
> IOCTL should return -ENOSPC, and set the actual number of routes there. N=
ot
> just zero. The user could e.g. try with a static allocation of some, and
> allocate memory if the static allocation turns not to be enough.

I see. That's fine, I just wanted to make sure I was not missing
something... Fine with me if num_routes is not adequate, it should be
corrected by the driver and -ENOSPC returned. How applications deal
with allocation is up to them (even if documentation might suggest to
perform and "call with 0, allocate, call again" sequence as a way to
ease this)

>
> Btw. the idea behind S_ROUTING behaviour was to allow multiple users to
> work on a single sub-device without having to know about each other. That=
's
> why there are flags to tell which routes are enabled and which are not.
>
> I'll be better available tomorrow, let's discuss e.g. on #v4l then.
>

Unfortunately I won't too much today :) I'll keep pinging in the next
days then, sorry about this :p

Thanks
   j

> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--khdpzh3now36xi5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxvtuoACgkQcjQGjxah
VjyUXhAAoxI1C2qGjbL5xbcfO/Has/gkHCGkwi+g4zgeiKmi68f+ERJJk9Srl60G
lyJz8MBpgrY+Fy+GSLgydyUYQ/Mwib43qHtc6dqjKIFIdumiE71P0EV9xTAeXrq4
/M9+xVcDuljR/mNs5pOz7bnIUlnI++8LJ8CSnSqYHmYm+FOiPMNzMDrk9ASpriLl
wruaFnVTRDHDAFAv/+MwFrpki4+45mMYFXQiMu+UcnTnaqT7HSajpL9iUdGF72El
uBh/hRWrbSBs9yzkcFOXN65CUra0/IIYxUiex6IoLfzsmvkBfwe65gzNS5ATNPgb
qf/riEyLAvVGBDsWXnM7knCc1a5tiPY8F5RVSzu0H6uZD2MFVDLT2Y+osoKVMjVd
w+qz9NCC6b+JL31vZFZYgeu953DGzPGPnYCmg2OFplXF9tlmAfnw8yN/AqGmHK3r
Li3c+kUmXGZmPei3t3SaWqa0Z6XJDczHwX51nbtXPAx60SrPf3KAuH4m/jdNRidp
kZa4Vw75P+QujGsPS/Jd3Mf05qY0tS/DU3n23e9bf0t/gHql6CvyBaKyIHUQora1
EUjqI4+JwvJy600wPtxRe9Wh2LxAvZmj4RrOuV3EhQTP1pY7jj4ME1gQ4fcGpKXE
Fg3t1LhX0e8t3ERROZZEroKRLyP2ff77IkgqacSUMSgmMKf9mC4=
=PLmx
-----END PGP SIGNATURE-----

--khdpzh3now36xi5h--
