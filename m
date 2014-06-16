Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3529 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbaFPIIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:08:54 -0400
Message-ID: <539EA5EF.1000407@xs4all.nl>
Date: Mon, 16 Jun 2014 10:08:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 08/30] [media] coda: add support for frame size enumeration
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de> <1402675736-15379-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-9-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2014 06:08 PM, Philipp Zabel wrote:
> This patch adds support for the VIDIOC_ENUM_FRAMESIZES ioctl.
> When decoding H.264, the output frame size is rounded up to the
> next multiple of the macroblock size (16 pixels).

Why do you need this? Implementing VIDIOC_ENUM_FRAMESIZES for a m2m device
seems odd.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 59 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 7e4df82..b5e5983 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -958,6 +958,63 @@ static int coda_decoder_cmd(struct file *file, void *fh,
>  	return 0;
>  }
>  
> +static int coda_enum_framesizes(struct file *file, void *fh,
> +				struct v4l2_frmsizeenum *fs)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(fh);
> +	struct coda_q_data *q_data_src;
> +	struct coda_codec *codec;
> +	struct vb2_queue *src_vq;
> +	int max_w;
> +	int max_h;
> +	int i;
> +
> +	if (fs->index > 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * If the source format is already fixed, try to find a codec that
> +	 * converts to the given destination format
> +	 */
> +	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	if (vb2_is_streaming(src_vq)) {
> +		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +
> +		codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
> +					fs->pixel_format);
> +		if (!codec)
> +			return -EINVAL;
> +
> +		fs->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +		if (codec->src_fourcc == V4L2_PIX_FMT_H264) {
> +			fs->discrete.width = round_up(q_data_src->width, 16);
> +			fs->discrete.height = round_up(q_data_src->height, 16);
> +		} else {
> +			fs->discrete.width = q_data_src->width;
> +			fs->discrete.height = q_data_src->height;
> +		}
> +	} else {
> +		/* We don't know if input or output frame sizes are requested */
> +		coda_get_max_dimensions(ctx->dev, NULL, &max_w, &max_h);
> +		fs->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +		fs->stepwise.min_width = MIN_W;
> +		fs->stepwise.max_width = max_w;
> +		fs->stepwise.step_width = 1;
> +		fs->stepwise.min_height = MIN_H;
> +		fs->stepwise.max_height = max_h;
> +		fs->stepwise.step_height = 1;
> +
> +		for (i = 0; i < ARRAY_SIZE(coda_formats); i++) {
> +			if (coda_formats[i].fourcc == fs->pixel_format)
> +				break;
> +		}
> +		if (i == ARRAY_SIZE(coda_formats))
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int coda_subscribe_event(struct v4l2_fh *fh,
>  				const struct v4l2_event_subscription *sub)
>  {
> @@ -998,6 +1055,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
>  	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
>  	.vidioc_decoder_cmd	= coda_decoder_cmd,
>  
> +	.vidioc_enum_framesizes	= coda_enum_framesizes,
> +
>  	.vidioc_subscribe_event = coda_subscribe_event,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
> 

