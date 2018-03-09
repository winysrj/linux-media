Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:46526 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751211AbeCIPaC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:30:02 -0500
Subject: Re: [PATCH v12 14/33] rcar-vin: align pixelformat check
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-15-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <09e74fb4-817f-ae34-ed1e-91523a5029cb@xs4all.nl>
Date: Fri, 9 Mar 2018 16:30:00 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-15-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:04, Niklas Söderlund wrote:
> If the pixelformat is not supported it should not fail but be set to
> something that works. While we are at it move the two different
> checks of the pixelformat to the same statement.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 55fa69aa7c454928..01f2a14169a74ff3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -187,12 +187,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	u32 walign;
>  	int ret;
>  
> -	/* If requested format is not supported fallback to the default */
> -	if (!rvin_format_from_pixel(pix->pixelformat)) {
> -		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> -			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> +	if (!rvin_format_from_pixel(pix->pixelformat) ||
> +	    (vin->info->model == RCAR_M1 &&
> +	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
>  		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> -	}
>  
>  	/* Limit to source capabilities */
>  	ret = __rvin_try_format_source(vin, which, pix, source);
> @@ -231,12 +229,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	pix->bytesperline = rvin_format_bytesperline(pix);
>  	pix->sizeimage = rvin_format_sizeimage(pix);
>  
> -	if (vin->info->model == RCAR_M1 &&
> -	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> -		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> -		return -EINVAL;
> -	}
> -
>  	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
>  		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
>  
> 
