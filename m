Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54507 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbeKHSRa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 13:17:30 -0500
Subject: Re: [PATCH v4 2/3] media: meson: add v4l2 m2m video decoder driver
To: Maxime Jourdan <mjourdan@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20181106075926.19269-1-mjourdan@baylibre.com>
 <20181106075926.19269-3-mjourdan@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2f88a17d-76f8-ec70-c18f-aa0d688249be@xs4all.nl>
Date: Thu, 8 Nov 2018 09:42:53 +0100
MIME-Version: 1.0
In-Reply-To: <20181106075926.19269-3-mjourdan@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2018 08:59 AM, Maxime Jourdan wrote:
> Amlogic SoCs feature a powerful video decoder unit able to
> decode many formats, with a performance of usually up to 4k60.
> 
> This is a driver for this IP that is based around the v4l2 m2m framework.
> 
> It features decoding for:
> - MPEG 1
> - MPEG 2
> 
> Supported SoCs are: GXBB (S905), GXL (S905X/W/D), GXM (S912)
> 
> There is also a hardware bitstream parser (ESPARSER) that is handled here.
> 
> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> ---
>  drivers/media/platform/Kconfig                |   10 +
>  drivers/media/platform/meson/Makefile         |    1 +
>  drivers/media/platform/meson/vdec/Makefile    |    8 +
>  .../media/platform/meson/vdec/codec_mpeg12.c  |  209 ++++
>  .../media/platform/meson/vdec/codec_mpeg12.h  |   14 +
>  drivers/media/platform/meson/vdec/dos_regs.h  |   98 ++
>  drivers/media/platform/meson/vdec/esparser.c  |  322 +++++
>  drivers/media/platform/meson/vdec/esparser.h  |   32 +
>  drivers/media/platform/meson/vdec/vdec.c      | 1034 +++++++++++++++++
>  drivers/media/platform/meson/vdec/vdec.h      |  251 ++++
>  drivers/media/platform/meson/vdec/vdec_1.c    |  231 ++++
>  drivers/media/platform/meson/vdec/vdec_1.h    |   14 +
>  .../media/platform/meson/vdec/vdec_helpers.c  |  412 +++++++
>  .../media/platform/meson/vdec/vdec_helpers.h  |   48 +
>  .../media/platform/meson/vdec/vdec_platform.c |  101 ++
>  .../media/platform/meson/vdec/vdec_platform.h |   30 +
>  16 files changed, 2815 insertions(+)
>  create mode 100644 drivers/media/platform/meson/vdec/Makefile
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
>  create mode 100644 drivers/media/platform/meson/vdec/dos_regs.h
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.c
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h
> 

<snip>

> +static int vdec_queue_setup(struct vb2_queue *q,
> +		unsigned int *num_buffers, unsigned int *num_planes,
> +		unsigned int sizes[], struct device *alloc_devs[])
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	const struct amvdec_format *fmt_out = sess->fmt_out;
> +	u32 output_size = amvdec_get_output_size(sess);
> +	u32 buffers_total;
> +
> +	if (*num_planes) {

If you are not supporting create_bufs, then you can drop this part.
Without create_bufs you can assume that *num_planes == 0 and
q->num_buffers == 0.

You should add a comment here mentioning that create_bufs isn't
supported by this driver and explain why it isn't supported.

I understand it is due to gstreamer problems, but the explanation
in your cover letter didn't say why it is a problem with this driver
but not other drivers (apparently).

> +		switch (q->type) {
> +		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +			if (*num_planes != 1 || sizes[0] < output_size)
> +				return -EINVAL;
> +			break;
> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +			switch (sess->pixfmt_cap) {
> +			case V4L2_PIX_FMT_NV12M:
> +				if (*num_planes != 2 ||
> +				    sizes[0] < output_size ||
> +				    sizes[1] < output_size / 2)
> +					return -EINVAL;
> +				break;
> +			case V4L2_PIX_FMT_YUV420M:
> +				if (*num_planes != 3 ||
> +				    sizes[0] < output_size ||
> +				    sizes[1] < output_size / 4 ||
> +				    sizes[2] < output_size / 4)
> +					return -EINVAL;
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +			break;
> +		}
> +
> +		return 0;
> +	}
> +
> +	switch (q->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		sizes[0] = amvdec_get_output_size(sess);
> +		*num_planes = 1;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		switch (sess->pixfmt_cap) {
> +		case V4L2_PIX_FMT_NV12M:
> +			sizes[0] = output_size;
> +			sizes[1] = output_size / 2;
> +			*num_planes = 2;
> +			break;
> +		case V4L2_PIX_FMT_YUV420M:
> +			sizes[0] = output_size;
> +			sizes[1] = output_size / 4;
> +			sizes[2] = output_size / 4;
> +			*num_planes = 3;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		buffers_total = q->num_buffers + *num_buffers;
> +
> +		if (buffers_total < fmt_out->min_buffers)
> +			*num_buffers = fmt_out->min_buffers - q->num_buffers;
> +		if (buffers_total > fmt_out->max_buffers)
> +			*num_buffers = fmt_out->max_buffers - q->num_buffers;
> +
> +		/* We need to program the complete CAPTURE buffer list
> +		 * in registers during start_streaming, and the firmwares
> +		 * are free to choose any of them to write frames to. As such,
> +		 * we need all of them to be queued into the driver
> +		 */
> +		q->min_buffers_needed = q->num_buffers + *num_buffers;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vdec_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct amvdec_session *sess = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_m2m_ctx *m2m_ctx = sess->m2m_ctx;
> +
> +	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> +
> +	if (!sess->streamon_out || !sess->streamon_cap)
> +		return;
> +
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	    vdec_codec_needs_recycle(sess))
> +		vdec_queue_recycle(sess, vb);
> +
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	struct amvdec_core *core = sess->core;
> +	struct vb2_v4l2_buffer *buf;
> +	int ret;
> +
> +	if (core->cur_sess && core->cur_sess != sess) {
> +		ret = -EBUSY;
> +		goto bufs_done;
> +	}
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 1;
> +	else
> +		sess->streamon_cap = 1;
> +
> +	if (!sess->streamon_out || !sess->streamon_cap)
> +		return 0;
> +
> +	sess->vififo_size = SIZE_VIFIFO;
> +	sess->vififo_vaddr =
> +		dma_alloc_coherent(sess->core->dev, sess->vififo_size,
> +				   &sess->vififo_paddr, GFP_KERNEL);
> +	if (!sess->vififo_vaddr) {
> +		dev_err(sess->core->dev, "Failed to request VIFIFO buffer\n");
> +		ret = -ENOMEM;
> +		goto bufs_done;
> +	}
> +
> +	sess->should_stop = 0;
> +	sess->keyframe_found = 0;
> +	sess->last_offset = 0;
> +	sess->wrap_count = 0;
> +	sess->pixelaspect.numerator = 1;
> +	sess->pixelaspect.denominator = 1;
> +	atomic_set(&sess->esparser_queued_bufs, 0);
> +
> +	ret = vdec_poweron(sess);
> +	if (ret)
> +		goto vififo_free;
> +
> +	sess->sequence_cap = 0;
> +	if (vdec_codec_needs_recycle(sess))
> +		sess->recycle_thread = kthread_run(vdec_recycle_thread, sess,
> +						   "vdec_recycle");
> +
> +	core->cur_sess = sess;
> +
> +	return 0;
> +
> +vififo_free:
> +	dma_free_coherent(sess->core->dev, sess->vififo_size,
> +			  sess->vififo_vaddr, sess->vififo_paddr);
> +bufs_done:
> +	while ((buf = v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +	while ((buf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 0;
> +	else
> +		sess->streamon_cap = 0;
> +
> +	return ret;
> +}
> +
> +static void vdec_free_canvas(struct amvdec_session *sess)
> +{
> +	int i;
> +
> +	for (i = 0; i < sess->canvas_num; ++i)
> +		meson_canvas_free(sess->core->canvas, sess->canvas_alloc[i]);
> +
> +	sess->canvas_num = 0;
> +}
> +
> +static void vdec_reset_timestamps(struct amvdec_session *sess)
> +{
> +	struct amvdec_timestamp *tmp, *n;
> +
> +	list_for_each_entry_safe(tmp, n, &sess->timestamps, list) {
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +	}
> +}
> +
> +static void vdec_reset_bufs_recycle(struct amvdec_session *sess)
> +{
> +	struct amvdec_buffer *tmp, *n;
> +
> +	list_for_each_entry_safe(tmp, n, &sess->bufs_recycle, list) {
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +	}
> +}
> +
> +static void vdec_stop_streaming(struct vb2_queue *q)
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	struct amvdec_core *core = sess->core;
> +	struct vb2_v4l2_buffer *buf;
> +
> +	if (sess->streamon_out && sess->streamon_cap) {
> +		if (vdec_codec_needs_recycle(sess))
> +			kthread_stop(sess->recycle_thread);
> +
> +		vdec_poweroff(sess);
> +		vdec_free_canvas(sess);
> +		dma_free_coherent(sess->core->dev, sess->vififo_size,
> +				  sess->vififo_vaddr, sess->vififo_paddr);
> +		vdec_reset_timestamps(sess);
> +		vdec_reset_bufs_recycle(sess);
> +		kfree(sess->priv);
> +		sess->priv = NULL;
> +		core->cur_sess = NULL;
> +	}
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		while ((buf = v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +
> +		sess->streamon_out = 0;
> +	} else {
> +		while ((buf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +
> +		sess->streamon_cap = 0;
> +	}
> +}
> +
> +static const struct vb2_ops vdec_vb2_ops = {
> +	.queue_setup = vdec_queue_setup,
> +	.start_streaming = vdec_start_streaming,
> +	.stop_streaming = vdec_stop_streaming,
> +	.buf_queue = vdec_vb2_buf_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +};
> +
> +static int
> +vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	strscpy(cap->driver, "meson-vdec", sizeof(cap->driver));
> +	strscpy(cap->card, "Amlogic Video Decoder", sizeof(cap->card));
> +	strscpy(cap->bus_info, "platform:meson-vdec", sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +static const struct amvdec_format *
> +find_format(const struct amvdec_format *fmts, u32 size, u32 pixfmt)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		if (fmts[i].pixfmt == pixfmt)
> +			return &fmts[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static unsigned int
> +vdec_supports_pixfmt_cap(const struct amvdec_format *fmt_out, u32 pixfmt_cap)
> +{
> +	int i;
> +
> +	for (i = 0; fmt_out->pixfmts_cap[i]; i++)
> +		if (fmt_out->pixfmts_cap[i] == pixfmt_cap)
> +			return 1;
> +
> +	return 0;
> +}
> +
> +static const struct amvdec_format *
> +vdec_try_fmt_common(struct amvdec_session *sess, u32 size,
> +		    struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
> +	const struct amvdec_format *fmts = sess->core->platform->formats;
> +	const struct amvdec_format *fmt_out;
> +
> +	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
> +	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt_out = find_format(fmts, size, pixmp->pixelformat);
> +		if (!fmt_out) {
> +			pixmp->pixelformat = V4L2_PIX_FMT_MPEG2;
> +			fmt_out = find_format(fmts, size, pixmp->pixelformat);
> +		}
> +
> +		pfmt[0].sizeimage =
> +			get_output_size(pixmp->width, pixmp->height);
> +		pfmt[0].bytesperline = 0;
> +		pixmp->num_planes = 1;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt_out = sess->fmt_out;
> +		if (!vdec_supports_pixfmt_cap(fmt_out, pixmp->pixelformat))
> +			pixmp->pixelformat = fmt_out->pixfmts_cap[0];
> +
> +		memset(pfmt[1].reserved, 0, sizeof(pfmt[1].reserved));
> +		if (pixmp->pixelformat == V4L2_PIX_FMT_NV12M) {
> +			pfmt[0].sizeimage =
> +				get_output_size(pixmp->width, pixmp->height);
> +			pfmt[0].bytesperline = ALIGN(pixmp->width, 64);
> +
> +			pfmt[1].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 2;
> +			pfmt[1].bytesperline = ALIGN(pixmp->width, 64);
> +			pixmp->num_planes = 2;
> +		} else if (pixmp->pixelformat == V4L2_PIX_FMT_YUV420M) {
> +			pfmt[0].sizeimage =
> +				get_output_size(pixmp->width, pixmp->height);
> +			pfmt[0].bytesperline = ALIGN(pixmp->width, 64);
> +
> +			pfmt[1].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 4;
> +			pfmt[1].bytesperline = ALIGN(pixmp->width, 64) / 2;
> +
> +			pfmt[2].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 4;
> +			pfmt[2].bytesperline = ALIGN(pixmp->width, 64) / 2;
> +			pixmp->num_planes = 3;
> +		}
> +	} else {
> +		return NULL;
> +	}
> +
> +	pixmp->width  = clamp(pixmp->width,  (u32)256, fmt_out->max_width);
> +	pixmp->height = clamp(pixmp->height, (u32)144, fmt_out->max_height);
> +
> +	if (pixmp->field == V4L2_FIELD_ANY)
> +		pixmp->field = V4L2_FIELD_NONE;
> +
> +	return fmt_out;
> +}
> +
> +static int vdec_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		pixmp->pixelformat = sess->pixfmt_cap;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		pixmp->pixelformat = sess->fmt_out->pixfmt;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		pixmp->width = sess->width;
> +		pixmp->height = sess->height;
> +		pixmp->colorspace = sess->colorspace;
> +		pixmp->ycbcr_enc = sess->ycbcr_enc;
> +		pixmp->quantization = sess->quantization;
> +		pixmp->xfer_func = sess->xfer_func;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		pixmp->width = sess->width;
> +		pixmp->height = sess->height;
> +	}
> +
> +	vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	u32 num_formats = sess->core->platform->num_formats;
> +	const struct amvdec_format *fmt_out;
> +	struct v4l2_pix_format_mplane orig_pixmp;
> +	struct v4l2_format format;
> +	u32 pixfmt_out = 0, pixfmt_cap = 0;
> +
> +	orig_pixmp = *pixmp;
> +
> +	fmt_out = vdec_try_fmt_common(sess, num_formats, f);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		pixfmt_out = pixmp->pixelformat;
> +		pixfmt_cap = sess->pixfmt_cap;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		pixfmt_cap = pixmp->pixelformat;
> +		pixfmt_out = sess->fmt_out->pixfmt;
> +	}
> +
> +	memset(&format, 0, sizeof(format));
> +
> +	format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	format.fmt.pix_mp.pixelformat = pixfmt_out;
> +	format.fmt.pix_mp.width = orig_pixmp.width;
> +	format.fmt.pix_mp.height = orig_pixmp.height;
> +	vdec_try_fmt_common(sess, num_formats, &format);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		sess->width = format.fmt.pix_mp.width;
> +		sess->height = format.fmt.pix_mp.height;
> +		sess->colorspace = pixmp->colorspace;
> +		sess->ycbcr_enc = pixmp->ycbcr_enc;
> +		sess->quantization = pixmp->quantization;
> +		sess->xfer_func = pixmp->xfer_func;
> +	}
> +
> +	memset(&format, 0, sizeof(format));
> +
> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	format.fmt.pix_mp.pixelformat = pixfmt_cap;
> +	format.fmt.pix_mp.width = orig_pixmp.width;
> +	format.fmt.pix_mp.height = orig_pixmp.height;
> +	vdec_try_fmt_common(sess, num_formats, &format);
> +
> +	sess->width = format.fmt.pix_mp.width;
> +	sess->height = format.fmt.pix_mp.height;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->fmt_out = fmt_out;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		sess->pixfmt_cap = format.fmt.pix_mp.pixelformat;
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	const struct vdec_platform *platform = sess->core->platform;
> +	const struct amvdec_format *fmt_out;
> +
> +	memset(f->reserved, 0, sizeof(f->reserved));
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		if (f->index >= platform->num_formats)
> +			return -EINVAL;
> +
> +		fmt_out = &platform->formats[f->index];
> +		f->pixelformat = fmt_out->pixfmt;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt_out = sess->fmt_out;
> +		if (f->index >= 4 || !fmt_out->pixfmts_cap[f->index])
> +			return -EINVAL;
> +
> +		f->pixelformat = fmt_out->pixfmts_cap[f->index];
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_framesizes(struct file *file, void *fh,
> +				struct v4l2_frmsizeenum *fsize)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	const struct amvdec_format *formats = sess->core->platform->formats;
> +	const struct amvdec_format *fmt;
> +	u32 num_formats = sess->core->platform->num_formats;
> +
> +	fmt = find_format(formats, num_formats, fsize->pixel_format);
> +	if (!fmt || fsize->index)
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;

Why STEPWISE? Since the steps are '1', I'd go with CONTINUOUS.

> +
> +	fsize->stepwise.min_width = 256;
> +	fsize->stepwise.max_width = fmt->max_width;
> +	fsize->stepwise.step_width = 1;
> +	fsize->stepwise.min_height = 144;
> +	fsize->stepwise.max_height = fmt->max_height;
> +	fsize->stepwise.step_height = 1;
> +
> +	return 0;
> +}
> +
> +static int
> +vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> +{
> +	switch (cmd->cmd) {
> +	case V4L2_DEC_CMD_STOP:
> +		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	struct device *dev = sess->core->dev;
> +	int ret;
> +
> +	ret = vdec_try_decoder_cmd(file, fh, cmd);
> +	if (ret)
> +		return ret;
> +
> +	if (!(sess->streamon_out & sess->streamon_cap))
> +		return 0;
> +
> +	dev_dbg(dev, "Received V4L2_DEC_CMD_STOP\n");
> +	sess->should_stop = 1;
> +
> +	vdec_wait_inactive(sess);
> +
> +	if (codec_ops->drain) {
> +		codec_ops->drain(sess);
> +	} else if (codec_ops->eos_sequence) {
> +		u32 len;
> +		const u8 *data = codec_ops->eos_sequence(&len);
> +
> +		esparser_queue_eos(sess->core, data, len);
> +	}
> +
> +	return ret;
> +}
> +
> +static int vdec_subscribe_event(struct v4l2_fh *fh,
> +				const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_EOS:
> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int vdec_cropcap(struct file *file, void *fh,
> +			struct v4l2_cropcap *crop)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	crop->pixelaspect = sess->pixelaspect;
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
> +	.vidioc_querycap = vdec_querycap,
> +	.vidioc_enum_fmt_vid_cap_mplane = vdec_enum_fmt,
> +	.vidioc_enum_fmt_vid_out_mplane = vdec_enum_fmt,
> +	.vidioc_s_fmt_vid_cap_mplane = vdec_s_fmt,
> +	.vidioc_s_fmt_vid_out_mplane = vdec_s_fmt,
> +	.vidioc_g_fmt_vid_cap_mplane = vdec_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane = vdec_g_fmt,
> +	.vidioc_try_fmt_vid_cap_mplane = vdec_try_fmt,
> +	.vidioc_try_fmt_vid_out_mplane = vdec_try_fmt,
> +	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
> +	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
> +	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
> +	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
> +	.vidioc_enum_framesizes = vdec_enum_framesizes,
> +	.vidioc_subscribe_event = vdec_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +	.vidioc_try_decoder_cmd = vdec_try_decoder_cmd,
> +	.vidioc_decoder_cmd = vdec_decoder_cmd,
> +	.vidioc_cropcap = vdec_cropcap,

This will conflict with this pending pull request:

https://patchwork.linuxtv.org/patch/52811/

It's best to wait until that has been merged and then rebase.

> +};
> +
> +static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct amvdec_session *sess = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->ops = &vdec_vb2_ops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->drv_priv = sess;
> +	src_vq->buf_struct_size = sizeof(struct dummy_buf);
> +	src_vq->min_buffers_needed = 1;
> +	src_vq->dev = sess->core->dev;
> +	src_vq->lock = &sess->lock;
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->ops = &vdec_vb2_ops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->drv_priv = sess;
> +	dst_vq->buf_struct_size = sizeof(struct dummy_buf);
> +	dst_vq->min_buffers_needed = 1;
> +	dst_vq->dev = sess->core->dev;
> +	dst_vq->lock = &sess->lock;
> +	ret = vb2_queue_init(dst_vq);
> +	if (ret) {
> +		vb2_queue_release(src_vq);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vdec_open(struct file *file)
> +{
> +	struct amvdec_core *core = video_drvdata(file);
> +	struct device *dev = core->dev;
> +	const struct amvdec_format *formats = core->platform->formats;
> +	struct amvdec_session *sess;
> +	int ret;
> +
> +	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
> +	if (!sess)
> +		return -ENOMEM;
> +
> +	sess->core = core;
> +
> +	sess->m2m_dev = v4l2_m2m_init(&vdec_m2m_ops);
> +	if (IS_ERR(sess->m2m_dev)) {
> +		dev_err(dev, "Fail to v4l2_m2m_init\n");
> +		ret = PTR_ERR(sess->m2m_dev);
> +		goto err_free_sess;
> +	}
> +
> +	sess->m2m_ctx = v4l2_m2m_ctx_init(sess->m2m_dev, sess, m2m_queue_init);
> +	if (IS_ERR(sess->m2m_ctx)) {
> +		dev_err(dev, "Fail to v4l2_m2m_ctx_init\n");
> +		ret = PTR_ERR(sess->m2m_ctx);
> +		goto err_m2m_release;
> +	}
> +
> +	sess->pixfmt_cap = formats[0].pixfmts_cap[0];
> +	sess->fmt_out = &formats[0];
> +	sess->width = 1280;
> +	sess->height = 720;
> +	sess->pixelaspect.numerator = 1;
> +	sess->pixelaspect.denominator = 1;
> +
> +	INIT_LIST_HEAD(&sess->timestamps);
> +	INIT_LIST_HEAD(&sess->bufs_recycle);
> +	INIT_WORK(&sess->esparser_queue_work, esparser_queue_all_src);
> +	mutex_init(&sess->lock);
> +	mutex_init(&sess->bufs_recycle_lock);
> +	spin_lock_init(&sess->ts_spinlock);
> +
> +	v4l2_fh_init(&sess->fh, core->vdev_dec);
> +	v4l2_fh_add(&sess->fh);
> +	sess->fh.m2m_ctx = sess->m2m_ctx;
> +	file->private_data = &sess->fh;
> +
> +	return 0;
> +
> +err_m2m_release:
> +	v4l2_m2m_release(sess->m2m_dev);
> +err_free_sess:
> +	kfree(sess);
> +	return ret;
> +}
> +
> +static int vdec_close(struct file *file)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	v4l2_m2m_ctx_release(sess->m2m_ctx);
> +	v4l2_m2m_release(sess->m2m_dev);
> +	v4l2_fh_del(&sess->fh);
> +	v4l2_fh_exit(&sess->fh);
> +
> +	mutex_destroy(&sess->lock);
> +	mutex_destroy(&sess->bufs_recycle_lock);
> +
> +	kfree(sess);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations vdec_fops = {
> +	.owner = THIS_MODULE,
> +	.open = vdec_open,
> +	.release = vdec_close,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = v4l2_m2m_fop_poll,
> +	.mmap = v4l2_m2m_fop_mmap,
> +};
> +
> +static irqreturn_t vdec_isr(int irq, void *data)
> +{
> +	struct amvdec_core *core = data;
> +	struct amvdec_session *sess = core->cur_sess;
> +
> +	sess->last_irq_jiffies = get_jiffies_64();
> +
> +	return sess->fmt_out->codec_ops->isr(sess);
> +}
> +
> +static irqreturn_t vdec_threaded_isr(int irq, void *data)
> +{
> +	struct amvdec_core *core = data;
> +	struct amvdec_session *sess = core->cur_sess;
> +
> +	return sess->fmt_out->codec_ops->threaded_isr(sess);
> +}
> +
> +static const struct of_device_id vdec_dt_match[] = {
> +	{ .compatible = "amlogic,gxbb-vdec",
> +	  .data = &vdec_platform_gxbb },
> +	{ .compatible = "amlogic,gxm-vdec",
> +	  .data = &vdec_platform_gxm },
> +	{ .compatible = "amlogic,gxl-vdec",
> +	  .data = &vdec_platform_gxl },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, vdec_dt_match);
> +
> +static int vdec_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct video_device *vdev;
> +	struct amvdec_core *core;
> +	struct resource *r;
> +	const struct of_device_id *of_id;
> +	int irq;
> +	int ret;
> +
> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> +	if (!core)
> +		return -ENOMEM;
> +
> +	core->dev = dev;
> +	platform_set_drvdata(pdev, core);
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dos");
> +	core->dos_base = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(core->dos_base)) {
> +		dev_err(dev, "Couldn't remap DOS memory\n");
> +		return PTR_ERR(core->dos_base);
> +	}
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "esparser");
> +	core->esparser_base = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(core->esparser_base)) {
> +		dev_err(dev, "Couldn't remap ESPARSER memory\n");
> +		return PTR_ERR(core->esparser_base);
> +	}
> +
> +	core->regmap_ao = syscon_regmap_lookup_by_phandle(dev->of_node,
> +							 "amlogic,ao-sysctrl");
> +	if (IS_ERR(core->regmap_ao)) {
> +		dev_err(dev, "Couldn't regmap AO sysctrl\n");
> +		return PTR_ERR(core->regmap_ao);
> +	}
> +
> +	core->canvas = meson_canvas_get(dev);
> +	if (!core->canvas)
> +		return PTR_ERR(core->canvas);
> +
> +	core->dos_parser_clk = devm_clk_get(dev, "dos_parser");
> +	if (IS_ERR(core->dos_parser_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->dos_clk = devm_clk_get(dev, "dos");
> +	if (IS_ERR(core->dos_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->vdec_1_clk = devm_clk_get(dev, "vdec_1");
> +	if (IS_ERR(core->vdec_1_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->vdec_hevc_clk = devm_clk_get(dev, "vdec_hevc");
> +	if (IS_ERR(core->vdec_hevc_clk))
> +		return -EPROBE_DEFER;
> +
> +	irq = platform_get_irq_byname(pdev, "vdec");
> +	if (irq < 0)
> +		return irq;
> +
> +	ret = devm_request_threaded_irq(core->dev, irq, vdec_isr,
> +					vdec_threaded_isr, IRQF_ONESHOT,
> +					"vdec", core);
> +	if (ret)
> +		return ret;
> +
> +	ret = esparser_init(pdev, core);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_device_register(dev, &core->v4l2_dev);
> +	if (ret) {
> +		dev_err(dev, "Couldn't register v4l2 device\n");
> +		return -ENOMEM;
> +	}
> +
> +	vdev = video_device_alloc();
> +	if (!vdev) {
> +		ret = -ENOMEM;
> +		goto err_vdev_release;
> +	}
> +
> +	of_id = of_match_node(vdec_dt_match, dev->of_node);
> +	core->platform = of_id->data;
> +	core->vdev_dec = vdev;
> +	core->dev_dec = dev;
> +	mutex_init(&core->lock);
> +
> +	strscpy(vdev->name, "meson-video-decoder", sizeof(vdev->name));
> +	vdev->release = video_device_release;
> +	vdev->fops = &vdec_fops;
> +	vdev->ioctl_ops = &vdec_ioctl_ops;
> +	vdev->vfl_dir = VFL_DIR_M2M;
> +	vdev->v4l2_dev = &core->v4l2_dev;
> +	vdev->lock = &core->lock;
> +	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +
> +	video_set_drvdata(vdev, core);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(dev, "Failed registering video device\n");
> +		goto err_vdev_release;
> +	}
> +
> +	return 0;
> +
> +err_vdev_release:
> +	video_device_release(vdev);
> +	return ret;
> +}
> +
> +static int vdec_remove(struct platform_device *pdev)
> +{
> +	struct amvdec_core *core = platform_get_drvdata(pdev);
> +
> +	video_unregister_device(core->vdev_dec);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver meson_vdec_driver = {
> +	.probe = vdec_probe,
> +	.remove = vdec_remove,
> +	.driver = {
> +		.name = "meson-vdec",
> +		.of_match_table = vdec_dt_match,
> +	},
> +};
> +module_platform_driver(meson_vdec_driver);
> +
> +MODULE_DESCRIPTION("Meson video decoder driver for GXBB/GXL/GXM");
> +MODULE_AUTHOR("Maxime Jourdan <mjourdan@baylibre.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/meson/vdec/vdec.h b/drivers/media/platform/meson/vdec/vdec.h
> new file mode 100644
> index 000000000000..4e8c3f1742ac
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec.h
> @@ -0,0 +1,251 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#ifndef __MESON_VDEC_CORE_H_
> +#define __MESON_VDEC_CORE_H_
> +
> +#include <linux/regmap.h>
> +#include <linux/list.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <linux/soc/amlogic/meson-canvas.h>
> +
> +#include "vdec_platform.h"
> +
> +/* 32 buffers in 3-plane YUV420 */
> +#define MAX_CANVAS (32 * 3)
> +
> +struct amvdec_buffer {
> +	struct list_head list;
> +	struct vb2_buffer *vb;
> +};
> +
> +/**
> + * struct amvdec_timestamp - stores a src timestamp along with a VIFIFO offset
> + *
> + * @list: used to make lists out of this struct
> + * @ts: timestamp
> + * @offset: offset in the VIFIFO where the associated packet was written
> + */
> +struct amvdec_timestamp {
> +	struct list_head list;
> +	u64 ts;
> +	u32 offset;
> +};
> +
> +struct amvdec_session;
> +
> +/**
> + * struct amvdec_core - device parameters, singleton
> + *
> + * @dos_base: DOS memory base address
> + * @esparser_base: PARSER memory base address
> + * @regmap_ao: regmap for the AO bus
> + * @dev: core device
> + * @dev_dec: decoder device
> + * @platform: platform-specific data
> + * @canvas: canvas provider reference
> + * @dos_parser_clk: DOS_PARSER clock
> + * @dos_clk: DOS clock
> + * @vdec_1_clk: VDEC_1 clock
> + * @vdec_hevc_clk: VDEC_HEVC clock
> + * @esparser_reset: RESET for the PARSER
> + * @vdec_dec: video device for the decoder
> + * @v4l2_dev: v4l2 device
> + * @cur_sess: current decoding session
> + * @lock: lock for this structure
> + */
> +struct amvdec_core {
> +	void __iomem *dos_base;
> +	void __iomem *esparser_base;
> +	struct regmap *regmap_ao;
> +
> +	struct device *dev;
> +	struct device *dev_dec;
> +	const struct vdec_platform *platform;
> +
> +	struct meson_canvas *canvas;
> +
> +	struct clk *dos_parser_clk;
> +	struct clk *dos_clk;
> +	struct clk *vdec_1_clk;
> +	struct clk *vdec_hevc_clk;
> +
> +	struct reset_control *esparser_reset;
> +
> +	struct video_device *vdev_dec;
> +	struct v4l2_device v4l2_dev;
> +
> +	struct amvdec_session *cur_sess;
> +	struct mutex lock;
> +};
> +
> +/**
> + * struct amvdec_ops - vdec operations
> + *
> + * @start: mandatory call when the vdec needs to initialize
> + * @stop: mandatory call when the vdec needs to stop
> + * @conf_esparser: mandatory call to let the vdec configure the ESPARSER
> + * @vififo_level: mandatory call to get the current amount of data
> + *		  in the VIFIFO
> + * @use_offsets: mandatory call. Returns 1 if the VDEC supports vififo offsets
> + */
> +struct amvdec_ops {
> +	int (*start)(struct amvdec_session *sess);
> +	int (*stop)(struct amvdec_session *sess);
> +	void (*conf_esparser)(struct amvdec_session *sess);
> +	u32 (*vififo_level)(struct amvdec_session *sess);
> +};
> +
> +/**
> + * struct amvdec_codec_ops - codec operations
> + *
> + * @start: mandatory call when the codec needs to initialize
> + * @stop: mandatory call when the codec needs to stop
> + * @load_extended_firmware: optional call to load additional firmware bits
> + * @num_pending_bufs: optional call to get the number of dst buffers on hold
> + * @can_recycle: optional call to know if the codec is ready to recycle
> + *		 a dst buffer
> + * @recycle: optional call to tell the codec to recycle a dst buffer. Must go
> + *	     in pair with @can_recycle
> + * @drain: optional call if the codec has a custom way of draining
> + * @eos_sequence: optional call to get an end sequence to send to esparser
> + *		  for flush. Mutually exclusive with @drain.
> + * @isr: mandatory call when the ISR triggers
> + * @threaded_isr: mandatory call for the threaded ISR
> + */
> +struct amvdec_codec_ops {
> +	int (*start)(struct amvdec_session *sess);
> +	int (*stop)(struct amvdec_session *sess);
> +	int (*load_extended_firmware)(struct amvdec_session *sess,
> +				      const u8 *data, u32 len);
> +	u32 (*num_pending_bufs)(struct amvdec_session *sess);
> +	int (*can_recycle)(struct amvdec_core *core);
> +	void (*recycle)(struct amvdec_core *core, u32 buf_idx);
> +	void (*drain)(struct amvdec_session *sess);
> +	const u8 * (*eos_sequence)(u32 *len);
> +	irqreturn_t (*isr)(struct amvdec_session *sess);
> +	irqreturn_t (*threaded_isr)(struct amvdec_session *sess);
> +};
> +
> +/**
> + * struct amvdec_format - describes one of the OUTPUT (src) format supported
> + *
> + * @pixfmt: V4L2 pixel format
> + * @min_buffers: minimum amount of CAPTURE (dst) buffers
> + * @max_buffers: maximum amount of CAPTURE (dst) buffers
> + * @max_width: maximum picture width supported
> + * @max_height: maximum picture height supported
> + * @vdec_ops: the VDEC operations that support this format
> + * @codec_ops: the codec operations that support this format
> + * @firmware_path: Path to the firmware that supports this format
> + * @pixfmts_cap: list of CAPTURE pixel formats available with pixfmt
> + */
> +struct amvdec_format {
> +	u32 pixfmt;
> +	u32 min_buffers;
> +	u32 max_buffers;
> +	u32 max_width;
> +	u32 max_height;
> +
> +	struct amvdec_ops *vdec_ops;
> +	struct amvdec_codec_ops *codec_ops;
> +
> +	char *firmware_path;
> +	u32 pixfmts_cap[4];
> +};
> +
> +/**
> + * struct amvdec_session - decoding session parameters
> + *
> + * @core: reference to the vdec core struct
> + * @fh: v4l2 file handle
> + * @m2m_dev: v4l2 m2m device
> + * @m2m_ctx: v4l2 m2m context
> + * @lock: session lock
> + * @fmt_out: vdec pixel format for the OUTPUT queue
> + * @pixfmt_cap: V4L2 pixel format for the CAPTURE queue
> + * @width: current picture width
> + * @height: current picture height
> + * @colorspace: current colorspace
> + * @ycbcr_enc: current ycbcr_enc
> + * @quantization: current quantization
> + * @xfer_func: current transfer function
> + * @pixelaspect: Pixel Aspect Ratio reported by the decoder
> + * @esparser_queued_bufs: number of buffers currently queued into ESPARSER
> + * @esparser_queue_work: work struct for the ESPARSER to process src buffers
> + * @streamon_cap: stream on flag for capture queue
> + * @streamon_out: stream on flag for output queue
> + * @sequence_cap: capture sequence counter
> + * @should_stop: flag set if userspace signaled EOS via command
> + *		 or empty buffer
> + * @keyframe_found: flag set once a keyframe has been parsed
> + * @canvas_alloc: array of all the canvas IDs allocated
> + * @canvas_num: number of canvas IDs allocated
> + * @vififo_vaddr: virtual address for the VIFIFO
> + * @vififo_paddr: physical address for the VIFIFO
> + * @vififo_size: size of the VIFIFO dma alloc
> + * @bufs_recycle: list of buffers that need to be recycled
> + * @bufs_recycle_lock: lock for the bufs_recycle list
> + * @recycle_thread: task struct for the recycling thread
> + * @timestamps: chronological list of src timestamps
> + * @ts_spinlock: spinlock for the timestamps list
> + * @last_irq_jiffies: tracks last time the vdec triggered an IRQ
> + * @priv: codec private data
> + */
> +struct amvdec_session {
> +	struct amvdec_core *core;
> +
> +	struct v4l2_fh fh;
> +	struct v4l2_m2m_dev *m2m_dev;
> +	struct v4l2_m2m_ctx *m2m_ctx;
> +	struct mutex lock;
> +
> +	const struct amvdec_format *fmt_out;
> +	u32 pixfmt_cap;
> +
> +	u32 width;
> +	u32 height;
> +	u32 colorspace;
> +	u8 ycbcr_enc;
> +	u8 quantization;
> +	u8 xfer_func;
> +
> +	struct v4l2_fract pixelaspect;
> +
> +	atomic_t esparser_queued_bufs;
> +	struct work_struct esparser_queue_work;
> +
> +	unsigned int streamon_cap, streamon_out;
> +	unsigned int sequence_cap;
> +	unsigned int should_stop;
> +	unsigned int keyframe_found;
> +
> +	u8 canvas_alloc[MAX_CANVAS];
> +	u32 canvas_num;
> +
> +	void *vififo_vaddr;
> +	dma_addr_t vififo_paddr;
> +	u32 vififo_size;
> +
> +	struct list_head bufs_recycle;
> +	struct mutex bufs_recycle_lock;
> +	struct task_struct *recycle_thread;
> +
> +	struct list_head timestamps;
> +	spinlock_t ts_spinlock;
> +
> +	u64 last_irq_jiffies;
> +	u32 last_offset;
> +	u32 wrap_count;
> +
> +	void *priv;
> +};
> +
> +u32 amvdec_get_output_size(struct amvdec_session *sess);
> +
> +#endif
> diff --git a/drivers/media/platform/meson/vdec/vdec_1.c b/drivers/media/platform/meson/vdec/vdec_1.c
> new file mode 100644
> index 000000000000..88b8bed9441e
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_1.c
> @@ -0,0 +1,231 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + *
> + * VDEC_1 is a video decoding block that allows decoding of
> + * MPEG 1/2/4, H.263, H.264, MJPEG, VC1
> + */
> +
> +#include <linux/firmware.h>
> +#include <linux/clk.h>
> +
> +#include "vdec_1.h"
> +#include "vdec_helpers.h"
> +#include "dos_regs.h"
> +
> +/* AO Registers */
> +#define AO_RTI_GEN_PWR_SLEEP0	0xe8
> +#define AO_RTI_GEN_PWR_ISO0	0xec
> +	#define GEN_PWR_VDEC_1 (BIT(3) | BIT(2))
> +
> +#define MC_SIZE			(4096 * 4)
> +
> +static int
> +vdec_1_load_firmware(struct amvdec_session *sess, const char *fwname)
> +{
> +	const struct firmware *fw;
> +	struct amvdec_core *core = sess->core;
> +	struct device *dev = core->dev_dec;
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	static void *mc_addr;
> +	static dma_addr_t mc_addr_map;
> +	int ret;
> +	u32 i = 1000;
> +
> +	ret = request_firmware(&fw, fwname, dev);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	if (fw->size < MC_SIZE) {
> +		dev_err(dev, "Firmware size %zu is too small. Expected %u.\n",
> +			fw->size, MC_SIZE);
> +		ret = -EINVAL;
> +		goto release_firmware;
> +	}
> +
> +	mc_addr = dma_alloc_coherent(core->dev, MC_SIZE,
> +				     &mc_addr_map, GFP_KERNEL);
> +	if (!mc_addr) {
> +		dev_err(dev,
> +			"Failed allocating memory for firmware loading\n");
> +		ret = -ENOMEM;
> +		goto release_firmware;
> +	}
> +
> +	memcpy(mc_addr, fw->data, MC_SIZE);
> +
> +	amvdec_write_dos(core, MPSR, 0);
> +	amvdec_write_dos(core, CPSR, 0);
> +
> +	amvdec_clear_dos_bits(core, MDEC_PIC_DC_CTRL, BIT(31));
> +
> +	amvdec_write_dos(core, IMEM_DMA_ADR, mc_addr_map);
> +	amvdec_write_dos(core, IMEM_DMA_COUNT, MC_SIZE / 4);
> +	amvdec_write_dos(core, IMEM_DMA_CTRL, (0x8000 | (7 << 16)));
> +
> +	while (--i && amvdec_read_dos(core, IMEM_DMA_CTRL) & 0x8000) { }
> +
> +	if (i == 0) {
> +		dev_err(dev, "Firmware load fail (DMA hang?)\n");
> +		ret = -EINVAL;
> +		goto free_mc;
> +	}
> +
> +	if (codec_ops->load_extended_firmware)
> +		ret = codec_ops->load_extended_firmware(sess,
> +							fw->data + MC_SIZE,
> +							fw->size - MC_SIZE);
> +
> +free_mc:
> +	dma_free_coherent(core->dev, MC_SIZE, mc_addr, mc_addr_map);
> +release_firmware:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +int vdec_1_stbuf_power_up(struct amvdec_session *sess)
> +{
> +	struct amvdec_core *core = sess->core;
> +
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_CONTROL, 0);
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_WRAP_COUNT, 0);
> +	amvdec_write_dos(core, POWER_CTL_VLD, BIT(4));
> +
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_START_PTR, sess->vififo_paddr);
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_CURR_PTR, sess->vififo_paddr);
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_END_PTR,
> +			 sess->vififo_paddr + sess->vififo_size - 8);
> +
> +	amvdec_write_dos_bits(core, VLD_MEM_VIFIFO_CONTROL, 1);
> +	amvdec_clear_dos_bits(core, VLD_MEM_VIFIFO_CONTROL, 1);
> +
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_BUF_CNTL, MEM_BUFCTRL_MANUAL);
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_WP, sess->vififo_paddr);
> +
> +	amvdec_write_dos_bits(core, VLD_MEM_VIFIFO_BUF_CNTL, 1);
> +	amvdec_clear_dos_bits(core, VLD_MEM_VIFIFO_BUF_CNTL, 1);
> +
> +	amvdec_write_dos_bits(core, VLD_MEM_VIFIFO_CONTROL,
> +		(0x11 << MEM_FIFO_CNT_BIT) | MEM_FILL_ON_LEVEL |
> +		MEM_CTRL_FILL_EN | MEM_CTRL_EMPTY_EN);
> +
> +	return 0;
> +}
> +
> +static void vdec_1_conf_esparser(struct amvdec_session *sess)
> +{
> +	struct amvdec_core *core = sess->core;
> +
> +	/* VDEC_1 specific ESPARSER stuff */
> +	amvdec_write_dos(core, DOS_GEN_CTRL0, 0);
> +	amvdec_write_dos(core, VLD_MEM_VIFIFO_BUF_CNTL, 1);
> +	amvdec_clear_dos_bits(core, VLD_MEM_VIFIFO_BUF_CNTL, 1);
> +}
> +
> +static u32 vdec_1_vififo_level(struct amvdec_session *sess)
> +{
> +	struct amvdec_core *core = sess->core;
> +
> +	return amvdec_read_dos(core, VLD_MEM_VIFIFO_LEVEL);
> +}
> +
> +static int vdec_1_stop(struct amvdec_session *sess)
> +{
> +	struct amvdec_core *core = sess->core;
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	amvdec_write_dos(core, MPSR, 0);
> +	amvdec_write_dos(core, CPSR, 0);
> +	amvdec_write_dos(core, ASSIST_MBOX1_MASK, 0);
> +
> +	amvdec_write_dos(core, DOS_SW_RESET0, BIT(12) | BIT(11));
> +	amvdec_write_dos(core, DOS_SW_RESET0, 0);
> +	amvdec_read_dos(core, DOS_SW_RESET0);
> +
> +	/* enable vdec1 isolation */
> +	regmap_write(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0xc0);
> +	/* power off vdec1 memories */
> +	amvdec_write_dos(core, DOS_MEM_PD_VDEC, 0xffffffff);
> +	/* power off vdec1 */
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +			   GEN_PWR_VDEC_1, GEN_PWR_VDEC_1);
> +
> +	clk_disable_unprepare(core->vdec_1_clk);
> +
> +	if (sess->priv)
> +		codec_ops->stop(sess);
> +
> +	return 0;
> +}
> +
> +static int vdec_1_start(struct amvdec_session *sess)
> +{
> +	int ret;
> +	struct amvdec_core *core = sess->core;
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	/* Configure the vdec clk to the maximum available */
> +	clk_set_rate(core->vdec_1_clk, 666666666);
> +	ret = clk_prepare_enable(core->vdec_1_clk);
> +	if (ret)
> +		return ret;
> +
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +			   GEN_PWR_VDEC_1, 0);
> +	udelay(10);
> +
> +	/* Reset VDEC1 */
> +	amvdec_write_dos(core, DOS_SW_RESET0, 0xfffffffc);
> +	amvdec_write_dos(core, DOS_SW_RESET0, 0x00000000);
> +
> +	amvdec_write_dos(core, DOS_GCLK_EN0, 0x3ff);
> +
> +	/* enable VDEC Memories */
> +	amvdec_write_dos(core, DOS_MEM_PD_VDEC, 0);
> +	/* Remove VDEC1 Isolation */
> +	regmap_write(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0);
> +	/* Reset DOS top registers */
> +	amvdec_write_dos(core, DOS_VDEC_MCRCC_STALL_CTRL, 0);
> +
> +	amvdec_write_dos(core, GCLK_EN, 0x3ff);
> +	amvdec_clear_dos_bits(core, MDEC_PIC_DC_CTRL, BIT(31));
> +
> +	vdec_1_stbuf_power_up(sess);
> +
> +	ret = vdec_1_load_firmware(sess, sess->fmt_out->firmware_path);
> +	if (ret)
> +		goto stop;
> +
> +	ret = codec_ops->start(sess);
> +	if (ret)
> +		goto stop;
> +
> +	/* Enable IRQ */
> +	amvdec_write_dos(core, ASSIST_MBOX1_CLR_REG, 1);
> +	amvdec_write_dos(core, ASSIST_MBOX1_MASK, 1);
> +
> +	/* Enable 2-plane output */
> +	if (sess->pixfmt_cap == V4L2_PIX_FMT_NV12M)
> +		amvdec_write_dos_bits(core, MDEC_PIC_DC_CTRL, BIT(17));
> +	else
> +		amvdec_clear_dos_bits(core, MDEC_PIC_DC_CTRL, BIT(17));
> +
> +	/* Enable firmware processor */
> +	amvdec_write_dos(core, MPSR, 1);
> +	/* Let the firmware settle */
> +	udelay(10);
> +
> +	return 0;
> +
> +stop:
> +	vdec_1_stop(sess);
> +	return ret;
> +}
> +
> +struct amvdec_ops vdec_1_ops = {
> +	.start = vdec_1_start,
> +	.stop = vdec_1_stop,
> +	.conf_esparser = vdec_1_conf_esparser,
> +	.vififo_level = vdec_1_vififo_level,
> +};
> diff --git a/drivers/media/platform/meson/vdec/vdec_1.h b/drivers/media/platform/meson/vdec/vdec_1.h
> new file mode 100644
> index 000000000000..042d930c40d7
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_1.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#ifndef __MESON_VDEC_VDEC_1_H_
> +#define __MESON_VDEC_VDEC_1_H_
> +
> +#include "vdec.h"
> +
> +extern struct amvdec_ops vdec_1_ops;
> +
> +#endif
> diff --git a/drivers/media/platform/meson/vdec/vdec_helpers.c b/drivers/media/platform/meson/vdec/vdec_helpers.c
> new file mode 100644
> index 000000000000..02090c5b089e
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_helpers.c
> @@ -0,0 +1,412 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#include <linux/gcd.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "vdec_helpers.h"
> +
> +#define NUM_CANVAS_NV12 2
> +#define NUM_CANVAS_YUV420 3
> +
> +u32 amvdec_read_dos(struct amvdec_core *core, u32 reg)
> +{
> +	return readl_relaxed(core->dos_base + reg);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_read_dos);
> +
> +void amvdec_write_dos(struct amvdec_core *core, u32 reg, u32 val)
> +{
> +	writel_relaxed(val, core->dos_base + reg);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_write_dos);
> +
> +void amvdec_write_dos_bits(struct amvdec_core *core, u32 reg, u32 val)
> +{
> +	amvdec_write_dos(core, reg, amvdec_read_dos(core, reg) | val);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_write_dos_bits);
> +
> +void amvdec_clear_dos_bits(struct amvdec_core *core, u32 reg, u32 val)
> +{
> +	amvdec_write_dos(core, reg, amvdec_read_dos(core, reg) & ~val);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_clear_dos_bits);
> +
> +u32 amvdec_read_parser(struct amvdec_core *core, u32 reg)
> +{
> +	return readl_relaxed(core->esparser_base + reg);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_read_parser);
> +
> +void amvdec_write_parser(struct amvdec_core *core, u32 reg, u32 val)
> +{
> +	writel_relaxed(val, core->esparser_base + reg);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_write_parser);
> +
> +static int canvas_alloc(struct amvdec_session *sess, u8 *canvas_id)
> +{
> +	int ret;
> +
> +	if (sess->canvas_num >= MAX_CANVAS) {
> +		dev_err(sess->core->dev, "Reached max number of canvas\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = meson_canvas_alloc(sess->core->canvas, canvas_id);
> +	if (ret)
> +		return ret;
> +
> +	sess->canvas_alloc[sess->canvas_num++] = *canvas_id;
> +	return 0;
> +}
> +
> +static int set_canvas_yuv420m(struct amvdec_session *sess,
> +			      struct vb2_buffer *vb, u32 width,
> +			      u32 height, u32 reg)
> +{
> +	struct amvdec_core *core = sess->core;
> +	u8 canvas_id[NUM_CANVAS_YUV420]; /* Y U V */
> +	dma_addr_t buf_paddr[NUM_CANVAS_YUV420]; /* Y U V */
> +	int ret, i;
> +
> +	for (i = 0; i < NUM_CANVAS_YUV420; ++i) {
> +		ret = canvas_alloc(sess, &canvas_id[i]);
> +		if (ret)
> +			return ret;
> +
> +		buf_paddr[i] =
> +		    vb2_dma_contig_plane_dma_addr(vb, i);
> +	}
> +
> +	/* Y plane */
> +	meson_canvas_config(core->canvas, canvas_id[0], buf_paddr[0],
> +			    width, height, MESON_CANVAS_WRAP_NONE,
> +			    MESON_CANVAS_BLKMODE_LINEAR,
> +			    MESON_CANVAS_ENDIAN_SWAP64);
> +
> +	/* U plane */
> +	meson_canvas_config(core->canvas, canvas_id[1], buf_paddr[1],
> +			    width / 2, height / 2, MESON_CANVAS_WRAP_NONE,
> +			    MESON_CANVAS_BLKMODE_LINEAR,
> +			    MESON_CANVAS_ENDIAN_SWAP64);
> +
> +	/* V plane */
> +	meson_canvas_config(core->canvas, canvas_id[2], buf_paddr[2],
> +			    width / 2, height / 2, MESON_CANVAS_WRAP_NONE,
> +			    MESON_CANVAS_BLKMODE_LINEAR,
> +			    MESON_CANVAS_ENDIAN_SWAP64);
> +
> +	amvdec_write_dos(core, reg,
> +			 ((canvas_id[2]) << 16) |
> +			 ((canvas_id[1]) << 8)  |
> +			 (canvas_id[0]));
> +
> +	return 0;
> +}
> +
> +static int set_canvas_nv12m(struct amvdec_session *sess,
> +			    struct vb2_buffer *vb, u32 width,
> +			    u32 height, u32 reg)
> +{
> +	struct amvdec_core *core = sess->core;
> +	u8 canvas_id[NUM_CANVAS_NV12]; /* Y U/V */
> +	dma_addr_t buf_paddr[NUM_CANVAS_NV12]; /* Y U/V */
> +	int ret, i;
> +
> +	for (i = 0; i < NUM_CANVAS_NV12; ++i) {
> +		ret = canvas_alloc(sess, &canvas_id[i]);
> +		if (ret)
> +			return ret;
> +
> +		buf_paddr[i] =
> +		    vb2_dma_contig_plane_dma_addr(vb, i);
> +	}
> +
> +	/* Y plane */
> +	meson_canvas_config(core->canvas, canvas_id[0], buf_paddr[0],
> +			    width, height, MESON_CANVAS_WRAP_NONE,
> +			    MESON_CANVAS_BLKMODE_LINEAR,
> +			    MESON_CANVAS_ENDIAN_SWAP64);
> +
> +	/* U/V plane */
> +	meson_canvas_config(core->canvas, canvas_id[1], buf_paddr[1],
> +			    width, height / 2, MESON_CANVAS_WRAP_NONE,
> +			    MESON_CANVAS_BLKMODE_LINEAR,
> +			    MESON_CANVAS_ENDIAN_SWAP64);
> +
> +	amvdec_write_dos(core, reg,
> +			 ((canvas_id[1]) << 16) |
> +			 ((canvas_id[1]) << 8)  |
> +			 (canvas_id[0]));
> +
> +	return 0;
> +}
> +
> +int amvdec_set_canvases(struct amvdec_session *sess,
> +			u32 reg_base[], u32 reg_num[])
> +{
> +	struct v4l2_m2m_buffer *buf;
> +	u32 pixfmt = sess->pixfmt_cap;
> +	u32 width = ALIGN(sess->width, 64);
> +	u32 height = ALIGN(sess->height, 64);
> +	u32 reg_cur = reg_base[0];
> +	u32 reg_num_cur = 0;
> +	u32 reg_base_cur = 0;
> +	int ret;
> +
> +	v4l2_m2m_for_each_dst_buf(sess->m2m_ctx, buf) {
> +		if (!reg_base[reg_base_cur])
> +			return -EINVAL;
> +
> +		reg_cur = reg_base[reg_base_cur] + reg_num_cur * 4;
> +
> +		switch (pixfmt) {
> +		case V4L2_PIX_FMT_NV12M:
> +			ret = set_canvas_nv12m(sess, &buf->vb.vb2_buf, width,
> +					       height, reg_cur);
> +			if (ret)
> +				return ret;
> +			break;
> +		case V4L2_PIX_FMT_YUV420M:
> +			ret = set_canvas_yuv420m(sess, &buf->vb.vb2_buf, width,
> +						 height, reg_cur);
> +			if (ret)
> +				return ret;
> +			break;
> +		default:
> +			dev_err(sess->core->dev, "Unsupported pixfmt %08X\n",
> +				pixfmt);
> +			return -EINVAL;
> +		};
> +
> +		reg_num_cur++;
> +		if (reg_num_cur >= reg_num[reg_base_cur]) {
> +			reg_base_cur++;
> +			reg_num_cur = 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(amvdec_set_canvases);
> +
> +void amvdec_add_ts_reorder(struct amvdec_session *sess, u64 ts, u32 offset)
> +{
> +	struct amvdec_timestamp *new_ts, *tmp;
> +	unsigned long flags;
> +
> +	new_ts = kmalloc(sizeof(*new_ts), GFP_KERNEL);
> +	new_ts->ts = ts;
> +	new_ts->offset = offset;
> +
> +	spin_lock_irqsave(&sess->ts_spinlock, flags);
> +
> +	if (list_empty(&sess->timestamps))
> +		goto add_tail;
> +
> +	list_for_each_entry(tmp, &sess->timestamps, list) {
> +		if (ts <= tmp->ts) {
> +			list_add_tail(&new_ts->list, &tmp->list);
> +			goto unlock;
> +		}
> +	}
> +
> +add_tail:
> +	list_add_tail(&new_ts->list, &sess->timestamps);
> +unlock:
> +	spin_unlock_irqrestore(&sess->ts_spinlock, flags);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_add_ts_reorder);
> +
> +void amvdec_remove_ts(struct amvdec_session *sess, u64 ts)
> +{
> +	struct amvdec_timestamp *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sess->ts_spinlock, flags);
> +	list_for_each_entry(tmp, &sess->timestamps, list) {
> +		if (tmp->ts == ts) {
> +			list_del(&tmp->list);
> +			kfree(tmp);
> +			goto unlock;
> +		}
> +	}
> +	dev_warn(sess->core->dev_dec,
> +		 "Couldn't remove buffer with timestamp %llu from list\n", ts);
> +
> +unlock:
> +	spin_unlock_irqrestore(&sess->ts_spinlock, flags);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_remove_ts);
> +
> +static void dst_buf_done(struct amvdec_session *sess,
> +			 struct vb2_v4l2_buffer *vbuf,
> +			 u32 field,
> +			 u64 timestamp)
> +{
> +	struct device *dev = sess->core->dev_dec;
> +	u32 output_size = amvdec_get_output_size(sess);
> +
> +	switch (sess->pixfmt_cap) {
> +	case V4L2_PIX_FMT_NV12M:
> +		vbuf->vb2_buf.planes[0].bytesused = output_size;
> +		vbuf->vb2_buf.planes[1].bytesused = output_size / 2;
> +		break;
> +	case V4L2_PIX_FMT_YUV420M:
> +		vbuf->vb2_buf.planes[0].bytesused = output_size;
> +		vbuf->vb2_buf.planes[1].bytesused = output_size / 4;
> +		vbuf->vb2_buf.planes[2].bytesused = output_size / 4;
> +		break;
> +	}
> +
> +	vbuf->vb2_buf.timestamp = timestamp;
> +	vbuf->sequence = sess->sequence_cap++;
> +
> +	if (sess->should_stop &&
> +	    atomic_read(&sess->esparser_queued_bufs) <= 2) {
> +		const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> +
> +		dev_dbg(dev, "Signaling EOS\n");
> +		v4l2_event_queue_fh(&sess->fh, &ev);
> +		vbuf->flags |= V4L2_BUF_FLAG_LAST;
> +	} else if (sess->should_stop)
> +		dev_dbg(dev, "should_stop, %u bufs remain\n",
> +			atomic_read(&sess->esparser_queued_bufs));
> +
> +	dev_dbg(dev, "Buffer %u done\n", vbuf->vb2_buf.index);
> +	vbuf->field = field;
> +	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
> +
> +	/* Buffer done probably means the vififo got freed */
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +void amvdec_dst_buf_done(struct amvdec_session *sess,
> +			 struct vb2_v4l2_buffer *vbuf, u32 field)
> +{
> +	struct device *dev = sess->core->dev_dec;
> +	struct amvdec_timestamp *tmp;
> +	struct list_head *timestamps = &sess->timestamps;
> +	u64 timestamp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sess->ts_spinlock, flags);
> +	if (list_empty(timestamps)) {
> +		dev_err(dev, "Buffer %u done but list is empty\n",
> +			vbuf->vb2_buf.index);
> +
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +		spin_unlock_irqrestore(&sess->ts_spinlock, flags);
> +		return;
> +	}
> +
> +	tmp = list_first_entry(timestamps, struct amvdec_timestamp, list);
> +	timestamp = tmp->ts;
> +	list_del(&tmp->list);
> +	kfree(tmp);
> +	spin_unlock_irqrestore(&sess->ts_spinlock, flags);
> +
> +	dst_buf_done(sess, vbuf, field, timestamp);
> +	atomic_dec(&sess->esparser_queued_bufs);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_dst_buf_done);
> +
> +static void amvdec_dst_buf_done_offset(struct amvdec_session *sess,
> +				       struct vb2_v4l2_buffer *vbuf,
> +				       u32 offset,
> +				       u32 field)
> +{
> +	struct device *dev = sess->core->dev_dec;
> +	struct amvdec_timestamp *match = NULL;
> +	struct amvdec_timestamp *tmp, *n;
> +	u64 timestamp = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sess->ts_spinlock, flags);
> +
> +	/* Look for our vififo offset to get the corresponding timestamp. */
> +	list_for_each_entry_safe(tmp, n, &sess->timestamps, list) {
> +		s64 delta = (s64)offset - tmp->offset;
> +
> +		/* Offsets reported by codecs usually differ slightly,
> +		 * so we need some wiggle room.
> +		 * 4KiB being the minimum packet size, there is no risk here.
> +		 */
> +		if (delta > (-1 * (s32)SZ_4K) && delta < SZ_4K) {
> +			match = tmp;
> +			break;
> +		}
> +
> +		/* Delete any timestamp entry that appears before our target
> +		 * (not all src packets/timestamps lead to a frame)
> +		 */
> +		if (delta > 0 || delta < -1 * (s32)sess->vififo_size) {
> +			atomic_dec(&sess->esparser_queued_bufs);
> +			list_del(&tmp->list);
> +			kfree(tmp);
> +		}
> +	}
> +
> +	if (!match) {
> +		dev_dbg(dev, "Buffer %u done but can't match offset (%08X)\n",
> +			vbuf->vb2_buf.index, offset);
> +	} else {
> +		timestamp = match->ts;
> +		list_del(&match->list);
> +		kfree(match);
> +	}
> +	spin_unlock_irqrestore(&sess->ts_spinlock, flags);
> +
> +	dst_buf_done(sess, vbuf, field, timestamp);
> +	if (match)
> +		atomic_dec(&sess->esparser_queued_bufs);
> +}
> +
> +void amvdec_dst_buf_done_idx(struct amvdec_session *sess,
> +			     u32 buf_idx, u32 offset, u32 field)
> +{
> +	struct vb2_v4l2_buffer *vbuf;
> +	struct device *dev = sess->core->dev_dec;
> +
> +	vbuf = v4l2_m2m_dst_buf_remove_by_idx(sess->m2m_ctx, buf_idx);
> +	if (!vbuf) {
> +		dev_err(dev,
> +			"Buffer %u done but it doesn't exist in m2m_ctx\n",
> +			buf_idx);
> +		return;
> +	}
> +
> +	if (offset != -1)
> +		amvdec_dst_buf_done_offset(sess, vbuf, offset, field);
> +	else
> +		amvdec_dst_buf_done(sess, vbuf, field);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_dst_buf_done_idx);
> +
> +void amvdec_set_par_from_dar(struct amvdec_session *sess,
> +			     u32 dar_num, u32 dar_den)
> +{
> +	u32 div;
> +
> +	sess->pixelaspect.numerator = sess->height * dar_num;
> +	sess->pixelaspect.denominator = sess->width * dar_den;
> +	div = gcd(sess->pixelaspect.numerator, sess->pixelaspect.denominator);
> +	sess->pixelaspect.numerator /= div;
> +	sess->pixelaspect.denominator /= div;
> +}
> +EXPORT_SYMBOL_GPL(amvdec_set_par_from_dar);
> +
> +void amvdec_abort(struct amvdec_session *sess)
> +{
> +	dev_info(sess->core->dev, "Aborting decoding session!\n");
> +	vb2_queue_error(&sess->m2m_ctx->cap_q_ctx.q);
> +	vb2_queue_error(&sess->m2m_ctx->out_q_ctx.q);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_abort);
> diff --git a/drivers/media/platform/meson/vdec/vdec_helpers.h b/drivers/media/platform/meson/vdec/vdec_helpers.h
> new file mode 100644
> index 000000000000..b9250a8157c4
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_helpers.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#ifndef __MESON_VDEC_HELPERS_H_
> +#define __MESON_VDEC_HELPERS_H_
> +
> +#include "vdec.h"
> +
> +/**
> + * amvdec_set_canvases() - Map VB2 buffers to canvases
> + *
> + * @sess: current session
> + * @reg_base: Registry bases of where to write the canvas indexes
> + * @reg_num: number of contiguous registers after each reg_base (including it)
> + */
> +int amvdec_set_canvases(struct amvdec_session *sess,
> +			u32 reg_base[], u32 reg_num[]);
> +
> +u32 amvdec_read_dos(struct amvdec_core *core, u32 reg);
> +void amvdec_write_dos(struct amvdec_core *core, u32 reg, u32 val);
> +void amvdec_write_dos_bits(struct amvdec_core *core, u32 reg, u32 val);
> +void amvdec_clear_dos_bits(struct amvdec_core *core, u32 reg, u32 val);
> +u32 amvdec_read_parser(struct amvdec_core *core, u32 reg);
> +void amvdec_write_parser(struct amvdec_core *core, u32 reg, u32 val);
> +
> +void amvdec_dst_buf_done_idx(struct amvdec_session *sess, u32 buf_idx,
> +			     u32 offset, u32 field);
> +void amvdec_dst_buf_done(struct amvdec_session *sess,
> +			 struct vb2_v4l2_buffer *vbuf, u32 field);
> +
> +/**
> + * amvdec_add_ts_reorder() - Add a timestamp to the list in chronological order
> + *
> + * @sess: current session
> + * @ts: timestamp to add
> + * @offset: offset in the VIFIFO where the associated packet was written
> + */
> +void amvdec_add_ts_reorder(struct amvdec_session *sess, u64 ts, u32 offset);
> +void amvdec_remove_ts(struct amvdec_session *sess, u64 ts);
> +
> +void amvdec_set_par_from_dar(struct amvdec_session *sess,
> +			     u32 dar_num, u32 dar_den);
> +
> +void amvdec_abort(struct amvdec_session *sess);
> +#endif
> diff --git a/drivers/media/platform/meson/vdec/vdec_platform.c b/drivers/media/platform/meson/vdec/vdec_platform.c
> new file mode 100644
> index 000000000000..46eeb7426f54
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_platform.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#include "vdec_platform.h"
> +#include "vdec.h"
> +
> +#include "vdec_1.h"
> +#include "codec_mpeg12.h"
> +
> +static const struct amvdec_format vdec_formats_gxbb[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	},
> +};
> +
> +static const struct amvdec_format vdec_formats_gxl[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	},
> +};
> +
> +static const struct amvdec_format vdec_formats_gxm[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.max_width = 1920,
> +		.max_height = 1080,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +		.pixfmts_cap = { V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M, 0 },
> +	},
> +};
> +
> +const struct vdec_platform vdec_platform_gxbb = {
> +	.formats = vdec_formats_gxbb,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxbb),
> +	.revision = VDEC_REVISION_GXBB,
> +};
> +
> +const struct vdec_platform vdec_platform_gxl = {
> +	.formats = vdec_formats_gxl,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxl),
> +	.revision = VDEC_REVISION_GXL,
> +};
> +
> +const struct vdec_platform vdec_platform_gxm = {
> +	.formats = vdec_formats_gxm,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxm),
> +	.revision = VDEC_REVISION_GXM,
> +};
> diff --git a/drivers/media/platform/meson/vdec/vdec_platform.h b/drivers/media/platform/meson/vdec/vdec_platform.h
> new file mode 100644
> index 000000000000..f6025326db1d
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_platform.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#ifndef __MESON_VDEC_PLATFORM_H_
> +#define __MESON_VDEC_PLATFORM_H_
> +
> +#include "vdec.h"
> +
> +struct amvdec_format;
> +
> +enum vdec_revision {
> +	VDEC_REVISION_GXBB,
> +	VDEC_REVISION_GXL,
> +	VDEC_REVISION_GXM,
> +};
> +
> +struct vdec_platform {
> +	const struct amvdec_format *formats;
> +	const u32 num_formats;
> +	enum vdec_revision revision;
> +};
> +
> +extern const struct vdec_platform vdec_platform_gxbb;
> +extern const struct vdec_platform vdec_platform_gxm;
> +extern const struct vdec_platform vdec_platform_gxl;
> +
> +#endif
> 

There were some kbuild test robot reports, don't forget to fix those in v5.

Regards,

	Hans
