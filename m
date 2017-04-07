Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52511 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753187AbdDGHzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 03:55:13 -0400
Message-ID: <1491551711.2904.51.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: do not enumerate YUYV if VDOA is not
 available
From: Lucas Stach <l.stach@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de
Date: Fri, 07 Apr 2017 09:55:11 +0200
In-Reply-To: <20170406140340.5900-1-p.zabel@pengutronix.de>
References: <20170406140340.5900-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 06.04.2017, 16:03 +0200 schrieb Philipp Zabel:
> TRY_FMT already disables the YUYV format if the VDOA is not available.
> ENUM_FMT must do the same.
> 
> Fixes: d40e98c13b3e ("[media] coda: support YUYV output if VDOA is used")
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>

> ---
>  drivers/media/platform/coda/coda-common.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index eb6548f46cbac..1c155b055ea30 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -386,6 +386,7 @@ static int coda_enum_fmt(struct file *file, void *priv,
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	const struct coda_video_device *cvd = to_coda_video_device(vdev);
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	const u32 *formats;
>  
>  	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> @@ -398,6 +399,11 @@ static int coda_enum_fmt(struct file *file, void *priv,
>  	if (f->index >= CODA_MAX_FORMATS || formats[f->index] == 0)
>  		return -EINVAL;
>  
> +	/* Skip YUYV if the vdoa is not available */
> +	if (!ctx->vdoa && f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    formats[f->index] == V4L2_PIX_FMT_YUYV)
> +		return -EINVAL;
> +
>  	f->pixelformat = formats[f->index];
>  
>  	return 0;
