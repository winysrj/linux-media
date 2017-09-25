Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44942 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932879AbdIYJuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:50:39 -0400
Subject: Re: [PATCH v6 09/25] rcar-vin: do not allow changing scaling and
 composing while streaming
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-10-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <458b7c1c-493e-cce7-a204-d7a9d5043428@xs4all.nl>
Date: Mon, 25 Sep 2017 11:50:36 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-10-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> It is possible on Gen2 to change the registers controlling composing and
> scaling while the stream is running. Is however not a good idea to do so

Is -> It

> and could result in trouble. There are also no good reason to allow

reason -> reasons

> this, remove immediate reflection in hardware registers from
> vidioc_s_selection and only configure scaling and composing when the
> stream starts.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 5f9674dc898305ba..6cc880e5ef7e0718 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -514,7 +514,7 @@ static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
>  	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
>  }
>  
> -void rvin_crop_scale_comp(struct rvin_dev *vin)
> +static void rvin_crop_scale_comp(struct rvin_dev *vin)
>  {
>  	u32 xs, ys;
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 421820caf275b066..305a74d033b2d9c5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -436,9 +436,6 @@ static int rvin_s_selection(struct file *file, void *fh,
>  		return -EINVAL;
>  	}
>  
> -	/* HW supports modifying configuration while running */
> -	rvin_crop_scale_comp(vin);
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index b2bac06c0a3cfcb7..fc70ded462ed3244 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -176,7 +176,4 @@ int rvin_reset_format(struct rvin_dev *vin);
>  
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>  
> -/* Cropping, composing and scaling */
> -void rvin_crop_scale_comp(struct rvin_dev *vin);
> -
>  #endif
> 
