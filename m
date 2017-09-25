Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52735 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932879AbdIYJtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:49:41 -0400
Subject: Re: [PATCH v6 08/25] rcar-vin: do not reset crop and compose when
 setting format
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-9-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b45ac262-4e81-01b7-441c-20936a02b36d@xs4all.nl>
Date: Mon, 25 Sep 2017 11:49:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-9-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> It was a bad idea to reset the crop and compose settings when a new
> format is set. This would overwrite any crop/compose set by s_select and
> cause unexpected behaviors, remove it. Also fold the reset helper in to
> the only remaining caller.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index affdc128a75e502e..421820caf275b066 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -90,17 +90,6 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
>   * V4L2
>   */
>  
> -static void rvin_reset_crop_compose(struct rvin_dev *vin)
> -{
> -	vin->crop.top = vin->crop.left = 0;
> -	vin->crop.width = vin->source.width;
> -	vin->crop.height = vin->source.height;
> -
> -	vin->compose.top = vin->compose.left = 0;
> -	vin->compose.width = vin->format.width;
> -	vin->compose.height = vin->format.height;
> -}
> -
>  int rvin_reset_format(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt = {
> @@ -147,7 +136,13 @@ int rvin_reset_format(struct rvin_dev *vin)
>  		break;
>  	}
>  
> -	rvin_reset_crop_compose(vin);
> +	vin->crop.top = vin->crop.left = 0;
> +	vin->crop.width = mf->width;
> +	vin->crop.height = mf->height;
> +
> +	vin->compose.top = vin->compose.left = 0;
> +	vin->compose.width = mf->width;
> +	vin->compose.height = mf->height;
>  
>  	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
>  	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
> @@ -317,8 +312,6 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
>  
>  	vin->format = f->fmt.pix;
>  
> -	rvin_reset_crop_compose(vin);
> -
>  	return 0;
>  }
>  
> 
