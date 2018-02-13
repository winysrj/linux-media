Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50673 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965701AbeBMUKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 15:10:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 23/30] rcar-vin: change name of video device
Date: Tue, 13 Feb 2018 22:10:49 +0200
Message-ID: <3546910.V9PaBWYjKi@avalon>
In-Reply-To: <20180129163435.24936-24-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-24-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:28 EET Niklas S=F6derlund wrote:
> The rcar-vin driver needs to be part of a media controller to support
> Gen3. Give each VIN instance a unique name so it can be referenced from
> userspace.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 292e1f22a4be36c7..3ac6cdcb18ce4a21 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -1012,7 +1012,7 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	/* video node */
>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
>  	vdev->queue =3D &vin->queue;
> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "VIN%u output", vin->id);
>  	vdev->release =3D video_device_release_empty;
>  	vdev->lock =3D &vin->lock;
>  	vdev->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |


=2D-=20
Regards,

Laurent Pinchart
