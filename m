Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47066 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdLHIRS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:17:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v9 07/28] rcar-vin: change name of video device
Date: Fri, 08 Dec 2017 10:17:36 +0200
Message-ID: <2107363.OzArtd56sx@avalon>
In-Reply-To: <20171208010842.20047-8-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-8-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

(CC'ing Sakari)

Thank you for the patch.

On Friday, 8 December 2017 03:08:21 EET Niklas S=F6derlund wrote:
> The rcar-vin driver needs to be part of a media controller to support
> Gen3. Give each VIN instance a unique name so it can be referenced from
> userspace.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 59ec6d3d119590aa..19de99133f048960 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -876,7 +876,8 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	vdev->fops =3D &rvin_fops;
>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
>  	vdev->queue =3D &vin->queue;
> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> +		 dev_name(vin->dev));

Do we need the module name here ? How about calling them "%s output",=20
dev_name(vin->dev) to emphasize the fact that this is a video node and not =
a=20
VIN subdev ? This is what the omap3isp and vsp1 drivers do.

We're suffering a bit from the fact that V4L2 has never standardized a nami=
ng=20
scheme for the devices. It wouldn't be fair to ask you to fix that as a=20
prerequisite to get the VIN driver merged, but we clearly have to work on t=
hat=20
at some point.

>  	vdev->release =3D video_device_release_empty;
>  	vdev->ioctl_ops =3D &rvin_ioctl_ops;
>  	vdev->lock =3D &vin->lock;

=2D-=20
Regards,

Laurent Pinchart
