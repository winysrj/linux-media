Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40507 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbdLNPuT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 10:50:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 07/28] rcar-vin: change name of video device
Date: Thu, 14 Dec 2017 17:50:24 +0200
Message-ID: <3340556.KXTJ26DsAn@avalon>
In-Reply-To: <20171214142500.lhp3v6lrd7kovx7b@valkosipuli.retiisi.org.uk>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <2107363.OzArtd56sx@avalon> <20171214142500.lhp3v6lrd7kovx7b@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday, 14 December 2017 16:25:00 EET Sakari Ailus wrote:
> On Fri, Dec 08, 2017 at 10:17:36AM +0200, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:21 EET Niklas S=F6derlund wrote:
> > > The rcar-vin driver needs to be part of a media controller to support
> > > Gen3. Give each VIN instance a unique name so it can be referenced fr=
om
> > > userspace.
> > >=20
> > > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
=2Ese>
> > > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > >=20
> > >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > > 59ec6d3d119590aa..19de99133f048960 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > @@ -876,7 +876,8 @@ int rvin_v4l2_register(struct rvin_dev *vin)
> > >=20
> > >  	vdev->fops =3D &rvin_fops;
> > >  	vdev->v4l2_dev =3D &vin->v4l2_dev;
> > >  	vdev->queue =3D &vin->queue;
> > >=20
> > > -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> > > +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> > > +		 dev_name(vin->dev));
> >=20
> > Do we need the module name here ? How about calling them "%s output",
> > dev_name(vin->dev) to emphasize the fact that this is a video node and =
not
> > a VIN subdev ? This is what the omap3isp and vsp1 drivers do.
> >=20
> > We're suffering a bit from the fact that V4L2 has never standardized a
> > naming scheme for the devices. It wouldn't be fair to ask you to fix th=
at
> > as a prerequisite to get the VIN driver merged, but we clearly have to
> > work on that at some point.
>=20
> Agreed, this needs to be stable and I think aligning to what omap3isp or
> vsp1 do would be a good fix here.

Even omap3isp and vsp1 are not fully aligned, so I think we need to design =
a=20
naming policy and document it.

=2D-=20
Regards,

Laurent Pinchart
