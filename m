Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55495 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932069AbeCIP3J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:29:09 -0500
Subject: Re: [PATCH v12 13/33] rcar-vin: update bytesperline and sizeimage
 calculation
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-14-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5db94f59-1636-0a59-63aa-6ca384f4f9df@xs4all.nl>
Date: Fri, 9 Mar 2018 16:29:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-14-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:04, Niklas Söderlund wrote:
> Remove over complicated logic to calculate the value for bytesperline
> and sizeimage that was carried over from the soc_camera port. There is
> no need to find the max value of bytesperline and sizeimage from
> user-space as they are set to 0 before the max_t() operation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index b76d59be64e0132d..55fa69aa7c454928 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -194,10 +194,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  		pix->pixelformat = RVIN_DEFAULT_FORMAT;
>  	}
>  
> -	/* Always recalculate */
> -	pix->bytesperline = 0;
> -	pix->sizeimage = 0;
> -
>  	/* Limit to source capabilities */
>  	ret = __rvin_try_format_source(vin, which, pix, source);
>  	if (ret)
> @@ -232,10 +228,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
>  			      &pix->height, 4, vin->info->max_height, 2, 0);
>  
> -	pix->bytesperline = max_t(u32, pix->bytesperline,
> -				  rvin_format_bytesperline(pix));
> -	pix->sizeimage = max_t(u32, pix->sizeimage,
> -			       rvin_format_sizeimage(pix));
> +	pix->bytesperline = rvin_format_bytesperline(pix);
> +	pix->sizeimage = rvin_format_sizeimage(pix);
>  
>  	if (vin->info->model == RCAR_M1 &&
>  	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> 
