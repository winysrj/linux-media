Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47195 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbdLHJEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:04:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 11/28] rcar-vin: do not allow changing scaling and composing while streaming
Date: Fri, 08 Dec 2017 11:04:26 +0200
Message-ID: <14690079.PLADEzS7Fe@avalon>
In-Reply-To: <20171208010842.20047-12-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-12-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:25 EET Niklas S=F6derlund wrote:
> It is possible on Gen2 to change the registers controlling composing and
> scaling while the stream is running. It is however not a good idea to do
> so and could result in trouble. There are also no good reasons to allow
> this, remove immediate reflection in hardware registers from
> vidioc_s_selection and only configure scaling and composing when the
> stream starts.

There is a good reason: digital zoom.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
>  3 files changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> fd14be20a6604d7a..7be5080f742825fb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -514,7 +514,7 @@ static void rvin_set_coeff(struct rvin_dev *vin,
> unsigned short xs) rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
>  }
>=20
> -void rvin_crop_scale_comp(struct rvin_dev *vin)
> +static void rvin_crop_scale_comp(struct rvin_dev *vin)
>  {
>  	u32 xs, ys;
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 254fa1c8770275a5..d6298c684ab2d731 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -436,9 +436,6 @@ static int rvin_s_selection(struct file *file, void *=
fh,
> return -EINVAL;
>  	}
>=20
> -	/* HW supports modifying configuration while running */
> -	rvin_crop_scale_comp(vin);
> -
>  	return 0;
>  }
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 36d0f0cc4ce01a6e..67541b483ee43c52 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -175,7 +175,4 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
>=20
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>=20
> -/* Cropping, composing and scaling */
> -void rvin_crop_scale_comp(struct rvin_dev *vin);
> -
>  #endif

=2D-=20
Regards,

Laurent Pinchart
