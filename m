Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3207 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3I3IIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 04:08:19 -0400
Message-ID: <52493160.5030401@xs4all.nl>
Date: Mon, 30 Sep 2013 10:08:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, posciak@google.com, inki.dae@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v3 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com> <1378991371-24428-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1378991371-24428-4-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

I have a few questions regarding the selection part...

On 09/12/2013 03:09 PM, Shaik Ameer Basha wrote:
> This patch adds the Makefile and memory to memory (m2m) interface
> functionality for the SCALER driver.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/Kconfig                    |    8 +
>  drivers/media/platform/Makefile                   |    1 +
>  drivers/media/platform/exynos-scaler/Makefile     |    3 +
>  drivers/media/platform/exynos-scaler/scaler-m2m.c |  781 +++++++++++++++++++++
>  4 files changed, 793 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-scaler/Makefile
>  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
> 

...

> +
> +static int scaler_m2m_g_selection(struct file *file, void *fh,
> +			struct v4l2_selection *s)
> +{
> +	struct scaler_frame *frame;
> +	struct scaler_ctx *ctx = fh_to_ctx(fh);
> +
> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
> +		return -EINVAL;
> +
> +	frame = ctx_get_frame(ctx, s->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:

This can't be right: depending on s->type you either support compose or crop,
I'm pretty sure you are not supporting both composing and cropping for both
capture and output directions.

What exactly is the functionality you attempt to implement here?

I'm CC-ing Tomasz as well as I discussed the selection API for m2m devices with
him during the LPC.

> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = frame->f_width;
> +		s->r.height = frame->f_height;
> +		return 0;
> +
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_CROP:

Ditto.

> +		s->r.left = frame->crop.left;
> +		s->r.top = frame->crop.top;
> +		s->r.width = frame->crop.width;
> +		s->r.height = frame->crop.height;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int scaler_m2m_s_selection(struct file *file, void *fh,
> +				struct v4l2_selection *s)
> +{
> +	struct scaler_frame *frame;
> +	struct scaler_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_crop cr;
> +	struct scaler_variant *variant = ctx->scaler_dev->variant;
> +	int ret;
> +
> +	cr.type = s->type;
> +	cr.c = s->r;
> +
> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
> +		return -EINVAL;
> +
> +	ret = scaler_try_crop(ctx, &cr);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (s->flags & V4L2_SEL_FLAG_LE &&
> +	    !is_rectangle_enclosed(&cr.c, &s->r))
> +		return -ERANGE;
> +
> +	if (s->flags & V4L2_SEL_FLAG_GE &&
> +	    !is_rectangle_enclosed(&s->r, &cr.c))
> +		return -ERANGE;
> +
> +	s->r = cr.c;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE:
> +		frame = &ctx->s_frame;
> +		break;
> +
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		frame = &ctx->d_frame;
> +		break;

Similar problems as with g_selection above. Tomasz mentioned to me that the selection
API is not implemented correctly in m2m Samsung drivers. It looks like this code is
copied-and-pasted from other drivers, so it seems he was right.

The selection API for m2m devices will be discussed during the upcoming V4L2 mini-summit
since the API may actually need some adjustments to have it work the way it should.

As requested above, if you can explain the exact functionality you are trying to
implement here, then I can look over this code carefully and see how it should be done.

Thanks!

	Hans

> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Check to see if scaling ratio is within supported range */
> +	if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret = scaler_check_scaler_ratio(variant, cr.c.width,
> +			cr.c.height, ctx->d_frame.crop.width,
> +			ctx->d_frame.crop.height,
> +			ctx->ctrls_scaler.rotate->val);
> +	} else {
> +		ret = scaler_check_scaler_ratio(variant,
> +			ctx->s_frame.crop.width,
> +			ctx->s_frame.crop.height, cr.c.width,
> +			cr.c.height, ctx->ctrls_scaler.rotate->val);
> +	}
> +
> +	if (ret < 0) {
> +		scaler_dbg(ctx->scaler_dev, "Out of scaler range");
> +		return -EINVAL;
> +	}
> +
> +	frame->crop = cr.c;
> +
> +	scaler_ctx_state_lock_set(SCALER_PARAMS, ctx);
> +	return 0;
> +}

