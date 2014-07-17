Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2996 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895AbaGQQX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:23:58 -0400
Message-ID: <53C7F87D.6050103@xs4all.nl>
Date: Thu, 17 Jul 2014 18:23:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 09/11] [media] coda: split format enumeration for encoder
 end decoder device
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-10-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> Let the decoder capture side and encoder output side only list
> uncompressed formats, and the decoder output and encoder capture
> side only list compressed formats.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/coda.c | 57 +++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 4a159031..e63226b 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -542,8 +542,8 @@ static int coda_querycap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
> -			enum v4l2_buf_type type, int src_fourcc)
> +static int coda_enum_fmt(struct file *file, void *priv,
> +			 struct v4l2_fmtdesc *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	struct coda_codec *codecs = ctx->dev->devtype->codecs;
> @@ -552,11 +552,19 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>  	int num_codecs = ctx->dev->devtype->num_codecs;
>  	int num_formats = ARRAY_SIZE(coda_formats);
>  	int i, k, num = 0;
> +	bool yuv;
> +
> +	if (ctx->inst_type == CODA_INST_ENCODER)
> +		yuv = (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	else
> +		yuv = (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE);
>  
>  	for (i = 0; i < num_formats; i++) {
> -		/* Both uncompressed formats are always supported */
> -		if (coda_format_is_yuv(formats[i].fourcc) &&
> -		    !coda_format_is_yuv(src_fourcc)) {
> +		/* Skip either raw or compressed formats */
> +		if (yuv != coda_format_is_yuv(formats[i].fourcc))
> +			continue;
> +		/* All uncompressed formats are always supported */
> +		if (yuv) {
>  			if (num == f->index)
>  				break;
>  			++num;
> @@ -564,12 +572,10 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>  		}
>  		/* Compressed formats may be supported, check the codec list */
>  		for (k = 0; k < num_codecs; k++) {
> -			/* if src_fourcc is set, only consider matching codecs */
> -			if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> -			    formats[i].fourcc == codecs[k].dst_fourcc &&
> -			    (!src_fourcc || src_fourcc == codecs[k].src_fourcc))
> +			if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +			    formats[i].fourcc == codecs[k].dst_fourcc)
>  				break;
> -			if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +			if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
>  			    formats[i].fourcc == codecs[k].src_fourcc)
>  				break;
>  		}
> @@ -584,7 +590,7 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>  		fmt = &formats[i];
>  		strlcpy(f->description, fmt->name, sizeof(f->description));
>  		f->pixelformat = fmt->fourcc;
> -		if (!coda_format_is_yuv(fmt->fourcc))
> +		if (!yuv)
>  			f->flags |= V4L2_FMT_FLAG_COMPRESSED;
>  		return 0;
>  	}
> @@ -593,31 +599,6 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>  	return -EINVAL;
>  }
>  
> -static int coda_enum_fmt_vid_cap(struct file *file, void *priv,
> -				 struct v4l2_fmtdesc *f)
> -{
> -	struct coda_ctx *ctx = fh_to_ctx(priv);
> -	struct vb2_queue *src_vq;
> -	struct coda_q_data *q_data_src;
> -
> -	/* If the source format is already fixed, only list matching formats */
> -	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> -	if (vb2_is_streaming(src_vq)) {
> -		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> -
> -		return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -				q_data_src->fourcc);
> -	}
> -
> -	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0);
> -}
> -
> -static int coda_enum_fmt_vid_out(struct file *file, void *priv,
> -				 struct v4l2_fmtdesc *f)
> -{
> -	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_OUTPUT, 0);
> -}
> -
>  static int coda_g_fmt(struct file *file, void *priv,
>  		      struct v4l2_format *f)
>  {
> @@ -972,12 +953,12 @@ static int coda_subscribe_event(struct v4l2_fh *fh,
>  static const struct v4l2_ioctl_ops coda_ioctl_ops = {
>  	.vidioc_querycap	= coda_querycap,
>  
> -	.vidioc_enum_fmt_vid_cap = coda_enum_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = coda_enum_fmt,
>  	.vidioc_g_fmt_vid_cap	= coda_g_fmt,
>  	.vidioc_try_fmt_vid_cap	= coda_try_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_cap	= coda_s_fmt_vid_cap,
>  
> -	.vidioc_enum_fmt_vid_out = coda_enum_fmt_vid_out,
> +	.vidioc_enum_fmt_vid_out = coda_enum_fmt,
>  	.vidioc_g_fmt_vid_out	= coda_g_fmt,
>  	.vidioc_try_fmt_vid_out	= coda_try_fmt_vid_out,
>  	.vidioc_s_fmt_vid_out	= coda_s_fmt_vid_out,
> 

