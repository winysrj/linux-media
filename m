Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2153 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934506AbaGQQY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:24:59 -0400
Message-ID: <53C7F8BB.2080903@xs4all.nl>
Date: Thu, 17 Jul 2014 18:24:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 10/11] [media] coda: default to h.264 decoder on invalid
 formats
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-11-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> If the user provides an invalid format, let the decoder device
> default to h.264.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index e63226b..ed5fa4c 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -685,7 +685,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
> -	struct coda_codec *codec;
> +	struct coda_codec *codec = NULL;
>  	struct vb2_queue *src_vq;
>  	int ret;
>  
> @@ -738,6 +738,12 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
>  	/* Determine codec by encoded format, returns NULL if raw or invalid */
>  	codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
>  				V4L2_PIX_FMT_YUV420);
> +	if (!codec && ctx->inst_type == CODA_INST_DECODER) {
> +		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_H264,
> +					V4L2_PIX_FMT_YUV420);
> +		if (!codec)
> +			return -EINVAL;
> +	}
>  
>  	if (!f->fmt.pix.colorspace)
>  		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
> 

