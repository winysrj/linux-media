Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60318 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbbEHJ76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 05:59:58 -0400
Message-ID: <554C890C.1000201@xs4all.nl>
Date: Fri, 08 May 2015 11:59:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Fabien Dessenne <fabien.dessenne@st.com>,
	linux-media@vger.kernel.org
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	hugues.fruchet@st.com
Subject: Re: [PATCH v2 2/3] [media] bdisp: 2D blitter driver using v4l2 mem2mem
 framework
References: <1430731461-8496-1-git-send-email-fabien.dessenne@st.com> <1430731461-8496-3-git-send-email-fabien.dessenne@st.com>
In-Reply-To: <1430731461-8496-3-git-send-email-fabien.dessenne@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabien,

Some comments below:

On 05/04/2015 11:24 AM, Fabien Dessenne wrote:
> This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
> It uses the v4l2 mem2mem framework.
> 
> The following features are supported and tested:
> - Color format conversion (RGB32, RGB24, RGB16, NV12, YUV420P)
> - Copy
> - Scale
> - Flip
> - Deinterlace
> - Wide (4K) picture support
> - Crop
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
> ---
>  drivers/media/platform/Kconfig                  |   10 +
>  drivers/media/platform/Makefile                 |    2 +
>  drivers/media/platform/sti/bdisp/Kconfig        |    9 +
>  drivers/media/platform/sti/bdisp/Makefile       |    3 +
>  drivers/media/platform/sti/bdisp/bdisp-filter.h |  346 ++++++
>  drivers/media/platform/sti/bdisp/bdisp-hw.c     |  783 +++++++++++++
>  drivers/media/platform/sti/bdisp/bdisp-reg.h    |  235 ++++
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c   | 1393 +++++++++++++++++++++++
>  drivers/media/platform/sti/bdisp/bdisp.h        |  186 +++
>  9 files changed, 2967 insertions(+)
>  create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
>  create mode 100644 drivers/media/platform/sti/bdisp/Makefile
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
>  create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h
> 

<snip>

> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> new file mode 100644
> index 0000000..b81596f
> --- /dev/null
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c

<snip>

> +/* Default format : VGA ARGB32*/
> +#define BDISP_DEF_WIDTH         640
> +#define BDISP_DEF_HEIGHT        480
> +
> +static const struct bdisp_frame bdisp_dflt_fmt = {
> +		.width          = BDISP_DEF_WIDTH,
> +		.height         = BDISP_DEF_HEIGHT,
> +		.fmt            = &bdisp_formats[0],
> +		.field          = V4L2_FIELD_NONE,
> +		.bytesperline   = BDISP_DEF_WIDTH * 4,
> +		.sizeimage      = BDISP_DEF_WIDTH * BDISP_DEF_HEIGHT * 4,
> +		.colorspace     = V4L2_COLORSPACE_SMPTE170M,

Are you sure about SMPTE170M? That's generally for SDTV (e.g. PAL/SECAM/NTSC)
formats. VGA has normally colorspace SRGB.

> +		.crop           = {0, 0, BDISP_DEF_WIDTH, BDISP_DEF_HEIGHT},
> +		.paddr          = {0, 0, 0, 0}
> +};

<snip>

> +static int bdisp_queue_setup(struct vb2_queue *vq,
> +			     const struct v4l2_format *fmt,
> +			     unsigned int *nb_buf, unsigned int *nb_planes,
> +			     unsigned int sizes[], void *allocators[])
> +{
> +	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
> +
> +	if (IS_ERR(frame)) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
> +		return PTR_ERR(frame);
> +	}
> +
> +	if (!frame->fmt) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid format\n");
> +		return -EINVAL;
> +	}
> +
> +	*nb_planes = 1;
> +	sizes[0] = frame->sizeimage;
> +	allocators[0] = ctx->bdisp_dev->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static int bdisp_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct bdisp_frame *frame = ctx_get_frame(ctx, vb->vb2_queue->type);
> +
> +	if (IS_ERR(frame)) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
> +		return PTR_ERR(frame);
> +	}
> +
> +	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		vb->v4l2_planes[0].bytesused = frame->sizeimage;

Please use vb2_set_plane_payload() instead.

> +
> +	return 0;
> +}
> +
> +static void bdisp_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	/* return to V4L2 any 0-size buffer so it can be dequeued by user */
> +	if (!vb->v4l2_planes[0].bytesused) {

Please use vb2_get_plane_payload() instead.

> +		dev_dbg(ctx->bdisp_dev->dev, "0 data buffer, skip it\n");
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		return;
> +	}
> +
> +	if (ctx->fh.m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> +}
> +
> +static int bdisp_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct bdisp_ctx *ctx = q->drv_priv;
> +	int ret = pm_runtime_get_sync(ctx->bdisp_dev->dev);
> +
> +	if (ret < 0) {
> +		dev_err(ctx->bdisp_dev->dev, "failed to set runtime PM\n");

Test what happens when you force an error here. I suspect you get a warning
about unbalanced vb2 ops. You likely will have to call v4l2_m2m_buf_done()
with state VB2_BUF_STATE_QUEUE for all queued buffers to keep the vb2 ops
in balance.

> +		return ret;
> +	}
> +
> +	return 0;
> +}

<snip>

> +static int bdisp_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +	const struct bdisp_fmt *fmt;
> +
> +	if (f->index >= ARRAY_SIZE(bdisp_formats))
> +		return -EINVAL;
> +
> +	fmt = &bdisp_formats[f->index];
> +
> +	if ((fmt->pixelformat == V4L2_PIX_FMT_YUV420) &&
> +	    (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
> +		dev_dbg(ctx->bdisp_dev->dev, "No YU12 on capture\n");

This only works if V4L2_PIX_FMT_YUV420 is the last format in bdisp_formats.
Applications stop enumerating when they get the first EINVAL, so in this
case the V4L2_PIX_FMT_RGB24 format will be missed for V4L2_BUF_TYPE_VIDEO_CAPTURE.

The easiest fix is to move V4L2_PIX_FMT_YUV420 to the end of bdisp_formats.

> +		return -EINVAL;
> +	}
> +	f->pixelformat = fmt->pixelformat;
> +
> +	return 0;
> +}
> +
> +static int bdisp_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct bdisp_frame *frame  = ctx_get_frame(ctx, f->type);
> +
> +	if (IS_ERR(frame)) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
> +		return PTR_ERR(frame);
> +	}
> +
> +	pix = &f->fmt.pix;
> +	pix->width = frame->width;
> +	pix->height = frame->height;
> +	pix->pixelformat = frame->fmt->pixelformat;
> +	pix->field = frame->field;
> +	pix->bytesperline = frame->bytesperline;
> +	pix->sizeimage = frame->sizeimage;
> +	pix->colorspace = frame->colorspace;
> +	pix->priv = 0;

Not needed anymore, just drop that line.

> +
> +	return 0;
> +}
> +
> +static int bdisp_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	const struct bdisp_fmt *format;
> +	u32 in_w, in_h;
> +
> +	format = bdisp_find_fmt(pix->pixelformat);
> +	if (!format) {
> +		dev_dbg(ctx->bdisp_dev->dev, "Unknown format 0x%x\n",
> +			pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	/* YUV420P only supported for VIDEO_OUTPUT */
> +	if ((format->pixelformat == V4L2_PIX_FMT_YUV420) &&
> +	    (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
> +		dev_dbg(ctx->bdisp_dev->dev, "No YU12 on capture\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Field */
> +	if (pix->field == V4L2_FIELD_ANY)
> +		pix->field = V4L2_FIELD_NONE;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		if ((pix->field != V4L2_FIELD_NONE) &&
> +		    (pix->field != V4L2_FIELD_INTERLACED))
> +			goto err_field;
> +	} else {
> +		if (pix->field != V4L2_FIELD_NONE)
> +			goto err_field;
> +	}

Don't give an error for this. If the field value is not supported, then
replace it by a reasonable default.

The only reason for an EINVAL by try_fmt is if the pixelformat is not
supported (and even there you have the option to replace it by some
default). Anything else should be modified to something valid.

BTW, does the hardware support V4L2_FIELD_ALTERNATE as well? In general
HDTV receivers will give you each field as it comes in (FIELD_ALTERNATE)
and they will not combine the two fields (FIELD_INTERLACED).

> +
> +	/* Adjust width & height */
> +	in_w = pix->width;
> +	in_h = pix->height;
> +	v4l_bound_align_image(&pix->width,
> +			      BDISP_MIN_W, BDISP_MAX_W,
> +			      ffs(format->w_align) - 1,
> +			      &pix->height,
> +			      BDISP_MIN_H, BDISP_MAX_H,
> +			      ffs(format->h_align) - 1,
> +			      0);
> +	if ((pix->width != in_w) || (pix->height != in_h))
> +		dev_dbg(ctx->bdisp_dev->dev,
> +			"%s size updated: %dx%d -> %dx%d\n", __func__,
> +			in_w, in_h, pix->width, pix->height);
> +
> +	pix->bytesperline = (pix->width * format->bpp_plane0) / 8;
> +	pix->sizeimage = (pix->width * pix->height * format->bpp) / 8;
> +
> +	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;

This isn't right: for V4L2_BUF_TYPE_VIDEO_OUTPUT the colorspace provided
by the application should be stored, and for CAPTURE that colorspace should
be returned. Initially you will set colorspace to some default in the open()
function. This should depend on the default format.

Think about it: the driver doesn't know the colorspace of the frames it is
given by userspace, only userspace knows.

> +	pix->priv = 0;

This line can be dropped.

> +
> +	return 0;
> +
> +err_field:
> +	dev_dbg(ctx->bdisp_dev->dev, "Unsupported field %d\n", pix->field);
> +
> +	return -EINVAL;
> +}
> +
> +static int bdisp_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +	struct vb2_queue *vq;
> +	struct bdisp_frame *frame;
> +	struct v4l2_pix_format *pix;
> +	int ret;
> +	u32 state;
> +
> +	ret = bdisp_try_fmt(file, fh, f);
> +	if (ret) {
> +		dev_err(ctx->bdisp_dev->dev, "Cannot set format\n");
> +		return ret;
> +	}
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq)) {
> +		dev_err(ctx->bdisp_dev->dev, "queue (%d) busy\n", f->type);
> +		return -EBUSY;
> +	}
> +
> +	frame = (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
> +			&ctx->src : &ctx->dst;
> +	pix = &f->fmt.pix;
> +	frame->fmt = bdisp_find_fmt(pix->pixelformat);
> +	if (!frame->fmt) {
> +		dev_err(ctx->bdisp_dev->dev, "Unknown format 0x%x\n",
> +			pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	frame->width = pix->width;
> +	frame->height = pix->height;
> +	frame->bytesperline = pix->bytesperline;
> +	frame->sizeimage = pix->sizeimage;
> +	frame->field = pix->field;
> +	frame->colorspace = pix->colorspace;

This should be done for OUTPUT only. For CAPTURE the try_fmt call should have set this
to whatever colorspace was set for the output side.

> +
> +	frame->crop.width = frame->width;
> +	frame->crop.height = frame->height;
> +	frame->crop.left = 0;
> +	frame->crop.top = 0;
> +
> +	state = BDISP_PARAMS;
> +	state |= (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ?
> +			BDISP_DST_FMT : BDISP_SRC_FMT;
> +	bdisp_ctx_state_lock_set(state, ctx);
> +
> +	return 0;
> +}
> +
> +static int bdisp_g_selection(struct file *file, void *fh,
> +			     struct v4l2_selection *s)
> +{
> +	struct bdisp_frame *frame;
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +
> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
> +		return -EINVAL;

s_selection only supports VIDEO_OUTPUT, so shouldn't the same check be done here?

> +
> +	frame = ctx_get_frame(ctx, s->type);
> +	if (IS_ERR(frame)) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
> +		return PTR_ERR(frame);
> +	}
> +
> +	if ((s->target == V4L2_SEL_TGT_CROP) ||
> +	    (s->target == V4L2_SEL_TGT_COMPOSE)) {

Same thing: do you support only cropping on the VIDEO_OUTPUT? s_selection suggests
that that is the case, so why allow TGT_COMPOSE?

And you should support CROP_DEFAULT/BOUNDS as well. Anything else should return
-EINVAL.

> +		/* cropped frame */
> +		s->r = frame->crop;
> +	} else {
> +		/* complete frame */
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = frame->width;
> +		s->r.height = frame->height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int is_rect_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
> +{
> +	/* Return 1 if a is enclosed in b, or 0 otherwise. */
> +
> +	if (a->left < b->left || a->top < b->top)
> +		return 0;
> +
> +	if (a->left + a->width > b->left + b->width)
> +		return 0;
> +
> +	if (a->top + a->height > b->top + b->height)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int bdisp_s_selection(struct file *file, void *fh,
> +			     struct v4l2_selection *s)
> +{
> +	struct bdisp_frame *frame;
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_rect *in, out;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		/* Composing is not supported */
> +		dev_dbg(ctx->bdisp_dev->dev, "Not supported at output\n");

You probably mean: "Selection is only supported at output".

> +		return -EINVAL;
> +	}
> +
> +	if ((s->target != V4L2_SEL_TGT_CROP) &&
> +	    (s->target != V4L2_SEL_TGT_COMPOSE)) {

This makes no sense. As far as I can tell you only support cropping for the
VIDEO_OUTPUT. E.g. you crop a rectangle from the frame as it resides in
memory and only that part is DMAed to the hardware.

It doesn't look like you support compose, so why allow TGT_COMPOSE here?

> +		dev_dbg(ctx->bdisp_dev->dev, "Invalid target\n");
> +		return -EINVAL;
> +	}
> +
> +	frame = ctx_get_frame(ctx, s->type);
> +	if (IS_ERR(frame)) {
> +		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
> +		return PTR_ERR(frame);
> +	}
> +
> +	in = &s->r;
> +	out = *in;
> +
> +	/* Align and check origin */
> +	out.left = ALIGN(in->left, frame->fmt->w_align);
> +	out.top = ALIGN(in->top, frame->fmt->h_align);
> +
> +	if ((out.left < 0) || (out.left >= frame->width) ||
> +	    (out.top < 0) || (out.top >= frame->height)) {
> +		dev_err(ctx->bdisp_dev->dev,
> +			"Invalid crop: %dx%d@(%d,%d) vs frame: %dx%d\n",
> +			out.width, out.height, out.left, out.top,
> +			frame->width, frame->height);
> +		return -EINVAL;
> +	}
> +
> +	/* Align and check size */
> +	out.width = ALIGN(in->width, frame->fmt->w_align);
> +	out.height = ALIGN(in->height, frame->fmt->w_align);
> +
> +	if ((out.width < 0) || (out.height < 0) ||
> +	    ((out.left + out.width) > frame->width) ||
> +	    ((out.top + out.height) > frame->height)) {
> +		dev_err(ctx->bdisp_dev->dev,
> +			"Invalid crop: %dx%d@(%d,%d) vs frame: %dx%d\n",
> +			out.width, out.height, out.left, out.top,
> +			frame->width, frame->height);
> +		return -EINVAL;
> +	}
> +
> +	/* Checks adjust constraints falgs */

falgs -> flags

> +	if (s->flags & V4L2_SEL_FLAG_LE && !is_rect_enclosed(&out, in))
> +		return -ERANGE;
> +
> +	if (s->flags & V4L2_SEL_FLAG_GE && !is_rect_enclosed(in, &out))
> +		return -ERANGE;
> +
> +	if ((out.left != in->left) || (out.top != in->top) ||
> +	    (out.width != in->width) || (out.height != in->height)) {
> +		dev_dbg(ctx->bdisp_dev->dev,
> +			"%s crop updated: %dx%d@(%d,%d) -> %dx%d@(%d,%d)\n",
> +			__func__, in->width, in->height, in->left, in->top,
> +			out.width, out.height, out.left, out.top);
> +		*in = out;
> +	}
> +
> +	frame->crop = out;
> +
> +	bdisp_ctx_state_lock_set(BDISP_PARAMS, ctx);
> +
> +	return 0;
> +}
> +
> +static int bdisp_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct bdisp_ctx *ctx = fh_to_ctx(fh);
> +
> +	if ((type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
> +	    !bdisp_ctx_state_is_set(BDISP_SRC_FMT, ctx)) {
> +		dev_err(ctx->bdisp_dev->dev, "src not defined\n");
> +		return -EINVAL;
> +	}
> +
> +	if ((type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +	    !bdisp_ctx_state_is_set(BDISP_DST_FMT, ctx)) {
> +		dev_err(ctx->bdisp_dev->dev, "dst not defined\n");
> +		return -EINVAL;
> +	}
> +
> +	return v4l2_m2m_streamon(file, ctx->fh.m2m_ctx, type);
> +}
> +
> +static const struct v4l2_ioctl_ops bdisp_ioctl_ops = {
> +	.vidioc_querycap                = bdisp_querycap,
> +	.vidioc_enum_fmt_vid_cap        = bdisp_enum_fmt,
> +	.vidioc_enum_fmt_vid_out        = bdisp_enum_fmt,
> +	.vidioc_g_fmt_vid_cap           = bdisp_g_fmt,
> +	.vidioc_g_fmt_vid_out           = bdisp_g_fmt,
> +	.vidioc_try_fmt_vid_cap         = bdisp_try_fmt,
> +	.vidioc_try_fmt_vid_out         = bdisp_try_fmt,
> +	.vidioc_s_fmt_vid_cap           = bdisp_s_fmt,
> +	.vidioc_s_fmt_vid_out           = bdisp_s_fmt,
> +	.vidioc_g_selection		= bdisp_g_selection,
> +	.vidioc_s_selection		= bdisp_s_selection,
> +	.vidioc_reqbufs                 = v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_create_bufs             = v4l2_m2m_ioctl_create_bufs,

Either remove this or support create_bufs correctly in queue_setup. See
e.g. Documentation/video4linux/v4l2-pci-skeleton.c how this is typically
done.

> +	.vidioc_expbuf                  = v4l2_m2m_ioctl_expbuf,
> +	.vidioc_querybuf                = v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf                    = v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf                   = v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon                = bdisp_streamon,
> +	.vidioc_streamoff               = v4l2_m2m_ioctl_streamoff,
> +	.vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
> +};

<snip>

> +static int bdisp_probe(struct platform_device *pdev)
> +{
> +	struct bdisp_dev *bdisp;
> +	struct resource *res;
> +	struct device *dev = &pdev->dev;
> +	int ret;
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	bdisp = devm_kzalloc(dev, sizeof(struct bdisp_dev), GFP_KERNEL);
> +	if (!bdisp)
> +		return -ENOMEM;
> +
> +	bdisp->pdev = pdev;
> +	bdisp->dev = dev;
> +	platform_set_drvdata(pdev, bdisp);
> +
> +	if (dev->of_node)
> +		bdisp->id = of_alias_get_id(pdev->dev.of_node, BDISP_NAME);
> +	else
> +		bdisp->id = pdev->id;
> +
> +	init_waitqueue_head(&bdisp->irq_queue);
> +	INIT_DELAYED_WORK(&bdisp->timeout_work, bdisp_irq_timeout);
> +	bdisp->work_queue = create_workqueue(BDISP_NAME);
> +
> +	spin_lock_init(&bdisp->slock);
> +	mutex_init(&bdisp->lock);
> +
> +	/* get resources */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	bdisp->regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(bdisp->regs)) {
> +		dev_err(dev, "failed to get regs\n");
> +		return PTR_ERR(bdisp->regs);
> +	}
> +
> +	bdisp->clock = devm_clk_get(dev, BDISP_NAME);
> +	if (IS_ERR(bdisp->clock)) {
> +		dev_err(dev, "failed to get clock\n");
> +		return PTR_ERR(bdisp->clock);
> +	}
> +
> +	ret = clk_prepare(bdisp->clock);
> +	if (ret < 0) {
> +		dev_err(dev, "clock prepare failed\n");
> +		bdisp->clock = ERR_PTR(-EINVAL);
> +		return ret;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(dev, "failed to get IRQ resource\n");
> +		goto err_clk;
> +	}
> +
> +	ret = devm_request_threaded_irq(dev, res->start, bdisp_irq_handler,
> +					bdisp_irq_thread, IRQF_ONESHOT,
> +					pdev->name, bdisp);
> +	if (ret) {
> +		dev_err(dev, "failed to install irq\n");
> +		goto err_clk;
> +	}
> +
> +	/* Register */
> +	ret = v4l2_device_register(dev, &bdisp->v4l2_dev);
> +	if (ret) {
> +		dev_err(dev, "failed to register\n");
> +		goto err_clk;
> +	}
> +
> +	ret = bdisp_register_device(bdisp);
> +	if (ret) {
> +		dev_err(dev, "failed to register\n");
> +		goto err_v4l2;
> +	}

This should be done as the very last thing in probe. As soon as the video device is
created udev can trigger applications that start to use it. So it is generally best
to call this as the very last thing so you know the device is ready for use.

> +
> +	/* Power management */
> +	pm_runtime_enable(dev);
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to set PM\n");
> +		goto err_m2m;
> +	}
> +
> +	/* Continuous memory allocator */
> +	bdisp->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(bdisp->alloc_ctx)) {
> +		ret = PTR_ERR(bdisp->alloc_ctx);
> +		goto err_pm;
> +	}
> +
> +	/* Filters */
> +	if (bdisp_hw_alloc_filters(bdisp->dev)) {
> +		dev_err(bdisp->dev, "no memory for filters\n");
> +		ret = -ENOMEM;
> +		goto err_vb2_dma;
> +	}
> +
> +	dev_info(dev, "%s%d registered as /dev/video%d\n", BDISP_NAME,
> +		 bdisp->id, bdisp->vdev.num);
> +
> +	pm_runtime_put(dev);
> +
> +	return 0;
> +
> +err_vb2_dma:
> +	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
> +err_pm:
> +	pm_runtime_put(dev);
> +err_m2m:
> +	bdisp_unregister_device(bdisp);
> +err_v4l2:
> +	v4l2_device_unregister(&bdisp->v4l2_dev);
> +err_clk:
> +	if (!IS_ERR(bdisp->clock))
> +		clk_unprepare(bdisp->clock);
> +
> +	return ret;
> +}

<snip>

Regards,

	Hans
