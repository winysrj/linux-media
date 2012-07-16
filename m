Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GPRVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 13:21:17 -0400
Subject: Re: [PATCH v3] media: coda: Add driver for Coda video codec.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de
In-Reply-To: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
References: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 19:21:13 +0200
Message-ID: <1342459273.2535.665.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

I'm trying to use this driver (on i.MX53) with GStreamer, with two
buffers on the encoded bitstream side. I'm getting negative bytesused
values calculated in coda_isr().

The CODA_REG_BIT_WR_PTR address, which is initialized in
coda_start_streaming() only moves around in the first buffer (so far
attempts to set it from device_run() have failed). This causes negative
bytesused values to be calculated in coda_isr() if the second buffer
(which has a higher BB_START address than WR_PTR) is active.
I'll repeat my observations inline below.

Are you using just one buffer for encoded frames? Does your firmware
behave differently?
I see there is a comment about the expected register setting not working
for CODA_REG_BIT_STREAM_CTRL in start_streaming(). Could this be
related?

Also, I've missed two problems with platform device removal and module
autoloading before, see below.

Am Donnerstag, den 12.07.2012, 09:11 +0200 schrieb Javier Martin:
> Coda is a range of video codecs from Chips&Media that
> support H.264, H.263, MPEG4 and other video standards.
> 
> Currently only support for the codadx6 included in the
> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> are the only supported capabilities by now.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> Changes since v2:
>  - Make hex constants lower case.
>  - Fix bytesperline.
>  - Make some functions and variables static.
>  - Fix logical &&
>  - Remove get_qops()
> ---
[...]
> +static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct coda_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> +	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		f->fmt.pix.width	= q_data->width;
> +		f->fmt.pix.height	= q_data->height;
> +		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
> +	} else { /* encoded formats h.264/mpeg4 */
> +		f->fmt.pix.width	= 0;
> +		f->fmt.pix.height	= 0;
> +		f->fmt.pix.bytesperline = 0;
> +	}
> +	f->fmt.pix.sizeimage	= q_data->sizeimage;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
> +{
> +	enum v4l2_field field;
> +
> +	if (!find_format(dev, f))
> +		return -EINVAL;
> +
> +	field = f->fmt.pix.field;
> +	if (field == V4L2_FIELD_ANY)
> +		field = V4L2_FIELD_NONE;
> +	else if (V4L2_FIELD_NONE != field)
> +		return -EINVAL;
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported */
> +	f->fmt.pix.field = field;
> +
> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
> +				      W_ALIGN, &f->fmt.pix.height,
> +				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
> +		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
> +		f->fmt.pix.sizeimage = f->fmt.pix.height *
> +					f->fmt.pix.bytesperline;
> +	} else { /*encoded formats h.264/mpeg4 */
> +		f->fmt.pix.bytesperline = CODA_MAX_FRAME_SIZE;

I failed to point this out specifically, but I think if G_FMT returns
zero in bytesperline, so should TRY_FMT.

> +		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct coda_fmt *fmt;
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	fmt = find_format(ctx->dev, f);
> +	/*
> +	 * Since decoding support is not implemented yet do not allow
> +	 * CODA_FMT_RAW formats in the capture interface.
> +	 */
> +	if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(ctx->dev, f);
> +}
[...]
> +/*
> + * Mem-to-mem operations.
> + */
> +
> +static int coda_isr(struct coda_dev *dev)
> +{
> +	struct coda_ctx *ctx;
> +	struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
> +	u32 wr_ptr, start_ptr;
> +
> +	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
> +	if (ctx == NULL) {
> +		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (ctx->aborting) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "task has been aborted\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (coda_isbusy(ctx->dev)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "coda is still busy!!!!\n");
> +		return IRQ_NONE;
> +	}
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +	/* Get results from the coda */
> +	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
> +	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
> +	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));

Here CODA_REG_BIT_WR_PTR is read, and it always contains a pointer into
the first destination buffer that was set during start_streaming()
below, even if I try to set it before starting the PIC_RUN command in
device_run().

start_ptr contains the correct buffer address as set in device_run().

> +	/* Calculate bytesused field */
> +	if (dst_buf->v4l2_buf.sequence == 0) {
> +		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
> +						ctx->vpu_header_size[0] +
> +						ctx->vpu_header_size[1] +
> +						ctx->vpu_header_size[2];
> +	} else {
> +		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);

So it is possible to have wr_ptr < start_ptr here.

> +	}
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
> +		 wr_ptr - start_ptr);
> +
> +	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
> +	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
> +
> +	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
> +		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
> +		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
> +	} else {
> +		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
> +		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> +	}
> +
> +	/* Free previous reference picture if available */
> +	if (ctx->reference) {
> +		v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
> +		ctx->reference = NULL;
> +	}
> +
> +	/*
> +	 * For the last frame of the gop we don't need to save
> +	 * a reference picture.
> +	 */
> +	v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	if (ctx->gopcounter == 0)
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +	else
> +		ctx->reference = tmp_buf;
> +
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +
> +	ctx->gopcounter--;
> +	if (ctx->gopcounter < 0)
> +		ctx->gopcounter = ctx->params.gop_size - 1;
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
> +		"job finished: encoding frame (%d) (%s)\n",
> +		dst_buf->v4l2_buf.sequence,
> +		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
> +		"KEYFRAME" : "PFRAME");
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void coda_device_run(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +	struct coda_q_data *q_data_src, *q_data_dst;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct coda_dev *dev = ctx->dev;
> +	int force_ipicture;
> +	int quant_param = 0;
> +	u32 picture_y, picture_cb, picture_cr;
> +	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
> +	u32 dst_fourcc;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	dst_fourcc = q_data_dst->fmt->fourcc;
> +
> +	src_buf->v4l2_buf.sequence = ctx->isequence;
> +	dst_buf->v4l2_buf.sequence = ctx->isequence;
> +	ctx->isequence++;
> +
> +	/*
> +	 * Workaround coda firmware BUG that only marks the first
> +	 * frame as IDR. This is a problem for some decoders that can't
> +	 * recover when a frame is lost.
> +	 */
> +	if (src_buf->v4l2_buf.sequence % ctx->params.gop_size) {
> +		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
> +		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> +	} else {
> +		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
> +		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
> +	}
> +
> +	/*
> +	 * Copy headers at the beginning of the first frame for H.264 only.
> +	 * In MPEG4 they are already copied by the coda.
> +	 */
> +	if (src_buf->v4l2_buf.sequence == 0) {
> +		pic_stream_buffer_addr =
> +			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
> +			ctx->vpu_header_size[0] +
> +			ctx->vpu_header_size[1] +
> +			ctx->vpu_header_size[2];
> +		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE -
> +			ctx->vpu_header_size[0] -
> +			ctx->vpu_header_size[1] -
> +			ctx->vpu_header_size[2];
> +		memcpy(vb2_plane_vaddr(dst_buf, 0),
> +		       &ctx->vpu_header[0][0], ctx->vpu_header_size[0]);
> +		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
> +		       &ctx->vpu_header[1][0], ctx->vpu_header_size[1]);
> +		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
> +			ctx->vpu_header_size[1], &ctx->vpu_header[2][0],
> +			ctx->vpu_header_size[2]);
> +	} else {
> +		pic_stream_buffer_addr =
> +			vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE;
> +	}
> +
> +	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
> +		force_ipicture = 1;
> +		switch (dst_fourcc) {
> +		case V4L2_PIX_FMT_H264:
> +			quant_param = ctx->params.h264_intra_qp;
> +			break;
> +		case V4L2_PIX_FMT_MPEG4:
> +			quant_param = ctx->params.mpeg4_intra_qp;
> +			break;
> +		default:
> +			v4l2_warn(&ctx->dev->v4l2_dev,
> +				"cannot set intra qp, fmt not supported\n");
> +			break;
> +		}
> +	} else {
> +		force_ipicture = 0;
> +		switch (dst_fourcc) {
> +		case V4L2_PIX_FMT_H264:
> +			quant_param = ctx->params.h264_inter_qp;
> +			break;
> +		case V4L2_PIX_FMT_MPEG4:
> +			quant_param = ctx->params.mpeg4_inter_qp;
> +			break;
> +		default:
> +			v4l2_warn(&ctx->dev->v4l2_dev,
> +				"cannot set inter qp, fmt not supported\n");
> +			break;
> +		}
> +	}
> +
> +	/* submit */
> +	coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
> +	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
> +
> +
> +	picture_y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	picture_cb = picture_y + q_data_src->width * q_data_src->height;
> +	picture_cr = picture_cb + q_data_src->width / 2 *
> +			q_data_src->height / 2;
> +
> +	coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
> +	coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
> +	coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
> +	coda_write(dev, force_ipicture << 1 & 0x2,
> +		   CODA_CMD_ENC_PIC_OPTION);
> +
> +	coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
> +	coda_write(dev, pic_stream_buffer_size / 1024,
> +		   CODA_CMD_ENC_PIC_BB_SIZE);

If I set CODA_REG_BIT_WR_PTR to pic_stream_buffer_addr here, and
pic_stream_buffer_addr points to the second destination buffer, after
the PIC_RUN command finishes, CODA_REG_BIT_WR_PTR again points into the
first destination buffer, as set in start_streaming().

> +	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
> +}
> +
> +static int coda_job_ready(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +
> +	/*
> +	 * For both 'P' and 'key' frame cases 1 picture
> +	 * and 1 frame are needed.
> +	 */
> +	if (!(v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) >= 1) ||
> +		!(v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) >= 1)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: not enough video buffers.\n");
> +		return 0;
> +	}
> +
> +	/* For P frames a reference picture is needed too */
> +	if ((ctx->gopcounter != (ctx->params.gop_size - 1)) &&
> +	   (!ctx->reference)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: reference picture not available.\n");
> +		return 0;
> +	}
> +
> +	if (coda_isbusy(ctx->dev)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: coda is still busy.\n");
> +		return 0;
> +	}
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			"job ready\n");
> +	return 1;
> +}
[...]
> +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	struct coda_dev *dev = ctx->dev;
> +	u32 bitstream_buf, bitstream_size;
> +
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		ctx->rawstreamon = 1;
> +	else
> +		ctx->compstreamon = 1;
> +
> +	if (ctx->rawstreamon & ctx->compstreamon) {
> +		struct coda_q_data *q_data_src, *q_data_dst;
> +		u32 dst_fourcc;
> +		struct vb2_buffer *buf;
> +		struct vb2_queue *src_vq;
> +		u32 value;
> +		int i = 0;
> +
> +		ctx->gopcounter = ctx->params.gop_size - 1;
> +
> +		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +		bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
> +		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		bitstream_size = q_data_dst->sizeimage;
> +		dst_fourcc = q_data_dst->fmt->fourcc;
> +
> +		/* Find out whether coda must encode or decode */
> +		if (q_data_src->fmt->type == CODA_FMT_RAW &&
> +		    q_data_dst->fmt->type == CODA_FMT_ENC) {
> +			ctx->inst_type = CODA_INST_ENCODER;
> +		} else if (q_data_src->fmt->type == CODA_FMT_ENC &&
> +			   q_data_dst->fmt->type == CODA_FMT_RAW) {
> +			ctx->inst_type = CODA_INST_DECODER;
> +			v4l2_err(&ctx->dev->v4l2_dev, "decoding not supported.\n");
> +			return -EINVAL;
> +		} else {
> +			v4l2_err(&ctx->dev->v4l2_dev, "couldn't tell instance type.\n");
> +			return -EINVAL;
> +		}
> +
> +		if (!coda_is_initialized(dev)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "coda is not initialized.\n");
> +			return -EFAULT;
> +		}
> +		coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
> +		coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
> +		coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));

Here CODA_REG_BIT_WR_PTR is set to the beginning of bitstream_buf, which
is the first destination buffer.

> +		switch (dev->devtype->product) {
> +		case CODA_DX6:
> +			/*
> +			 * We should use (CODADX6_STREAM_BUF_PIC_RESET |
> +			 * CODADX6_STREAM_BUF_PIC_FLUSH) but it doesn't work
> +			 * with firmware 2.2.5.
> +			 */
> +			coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
> +			break;
> +		default:
> +			coda_write(dev, CODA7_STREAM_BUF_PIC_RESET |
> +				CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
> +		}
> +
> +		/* Configure the coda */
> +		coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> +
> +		/* Could set rotation here if needed */
> +		switch (dev->devtype->product) {
> +		case CODA_DX6:
> +			value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
> +			break;
> +		default:
> +			value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
> +		}
> +		value |= (q_data_src->height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
> +		coda_write(dev, ctx->params.framerate,
> +			   CODA_CMD_ENC_SEQ_SRC_F_RATE);
> +
> +		switch (dst_fourcc) {
> +		case V4L2_PIX_FMT_MPEG4:
> +			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_MP4 : CODA7_MODE_ENCODE_MP4;
> +			coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
> +			value  = (0 & CODA_MP4PARAM_VERID_MASK) << CODA_MP4PARAM_VERID_OFFSET;
> +			value |= (0 & CODA_MP4PARAM_INTRADCVLCTHR_MASK) << CODA_MP4PARAM_INTRADCVLCTHR_OFFSET;
> +			value |= (0 & CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK) << CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET;
> +			value |=  0 & CODA_MP4PARAM_DATAPARTITIONENABLE_MASK;
> +			coda_write(dev, value, CODA_CMD_ENC_SEQ_MP4_PARA);
> +			break;
> +		case V4L2_PIX_FMT_H264:
> +			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_H264 : CODA7_MODE_ENCODE_H264;
> +			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
> +			value  = (0 & CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET;
> +			value |= (0 & CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET;
> +			value |= (0 & CODA_264PARAM_DISABLEDEBLK_MASK) << CODA_264PARAM_DISABLEDEBLK_OFFSET;
> +			value |= (0 & CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK) << CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET;
> +			value |=  0 & CODA_264PARAM_CHROMAQPOFFSET_MASK;
> +			coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
> +			break;
> +		default:
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				 "dst format (0x%08x) invalid.\n", dst_fourcc);
> +			return -EINVAL;
> +		}
> +
> +		value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
> +		value |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
> +		if (ctx->params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
> +			value |=  1 & CODA_SLICING_MODE_MASK;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
> +		value  =  ctx->params.gop_size & CODA_GOP_SIZE_MASK;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
> +
> +		if (ctx->params.bitrate) {
> +			/* Rate control enabled */
> +			value  = (0 & CODA_RATECONTROL_AUTOSKIP_MASK) << CODA_RATECONTROL_AUTOSKIP_OFFSET;
> +			value |= (0 & CODA_RATECONTROL_INITIALDELAY_MASK) << CODA_RATECONTROL_INITIALDELAY_OFFSET;
> +			value |= (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
> +			value |=  1 & CODA_RATECONTROL_ENABLE_MASK;
> +		} else {
> +			value = 0;
> +		}
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_PARA);
> +
> +		coda_write(dev, 0, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
> +		coda_write(dev, 0, CODA_CMD_ENC_SEQ_INTRA_REFRESH);
> +
> +		coda_write(dev, bitstream_buf, CODA_CMD_ENC_SEQ_BB_START);
> +		coda_write(dev, bitstream_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
> +
> +		/* set default gamma */
> +		value = (CODA_DEFAULT_GAMMA & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_GAMMA);
> +
> +		value  = (CODA_DEFAULT_GAMMA > 0) << CODA_OPTION_GAMMA_OFFSET;
> +		value |= (0 & CODA_OPTION_SLICEREPORT_MASK) << CODA_OPTION_SLICEREPORT_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
> +
> +		if (dst_fourcc == V4L2_PIX_FMT_H264) {
> +			value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> +			value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> +			value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
> +			coda_write(dev, value, CODA_CMD_ENC_SEQ_FMO);
> +		}
> +
> +		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
> +			return -EFAULT;
> +
> +		/*
> +		 * Walk the src buffer list and let the codec know the
> +		 * addresses of the pictures.
> +		 */
> +		src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		for (i = 0; i < src_vq->num_buffers; i++) {
> +			u32 *p;
> +
> +			buf = src_vq->bufs[i];
> +			p = ctx->parabuf.vaddr;
> +
> +			p[i * 3] = vb2_dma_contig_plane_dma_addr(buf, 0);
> +			p[i * 3 + 1] = p[i * 3] + q_data_src->width *
> +					q_data_src->height;
> +			p[i * 3 + 2] = p[i * 3 + 1] + q_data_src->width / 2 *
> +					q_data_src->height / 2;
> +		}
> +
> +		coda_write(dev, src_vq->num_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
> +		coda_write(dev, q_data_src->width, CODA_CMD_SET_FRAME_BUF_STRIDE);
> +		if (coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		/* Save stream headers */
> +		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +		switch (dst_fourcc) {
> +		case V4L2_PIX_FMT_H264:
> +			/*
> +			 * Get SPS in the first frame and copy it to an
> +			 * intermediate buffer.
> +			 */
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_H264_SPS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
> +			       ctx->vpu_header_size[0]);
> +
> +			/*
> +			 * Get PPS in the first frame and copy it to an
> +			 * intermediate buffer.
> +			 */
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_H264_PPS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
> +			       ctx->vpu_header_size[1]);
> +			ctx->vpu_header_size[2] = 0;
> +			break;
> +		case V4L2_PIX_FMT_MPEG4:
> +			/*
> +			 * Get VOS in the first frame and copy it to an
> +			 * intermediate buffer
> +			 */
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VOS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
> +			       ctx->vpu_header_size[0]);
> +
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VIS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
> +			       ctx->vpu_header_size[1]);
> +
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VOL, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->vpu_header_size[2] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->vpu_header[2][0], vb2_plane_vaddr(buf, 0),
> +			       ctx->vpu_header_size[2]);
> +			break;
> +		default:
> +			/* No more formats need to save headers at the moment */
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int coda_stop_streaming(struct vb2_queue *q)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "%s: output\n", __func__);
> +		ctx->rawstreamon = 0;
> +	} else {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "%s: capture\n", __func__);
> +		ctx->compstreamon = 0;
> +	}
> +
> +	if (!ctx->rawstreamon && !ctx->compstreamon) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "%s: sent command 'SEQ_END' to coda\n", __func__);
> +		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				 "CODA_COMMAND_SEQ_END failed\n");
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops coda_qops = {
> +	.queue_setup		= coda_queue_setup,
> +	.buf_prepare		= coda_buf_prepare,
> +	.buf_queue		= coda_buf_queue,
> +	.wait_prepare		= coda_wait_prepare,
> +	.wait_finish		= coda_wait_finish,
> +	.start_streaming	= coda_start_streaming,
> +	.stop_streaming		= coda_stop_streaming,
> +};
> +
> +static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct coda_ctx *ctx =
> +			container_of(ctrl->handler, struct coda_ctx, ctrls);
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +		ctx->params.bitrate = ctrl->val / 1000;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		ctx->params.gop_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
> +		ctx->params.h264_intra_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
> +		ctx->params.h264_inter_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
> +		ctx->params.mpeg4_intra_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
> +		ctx->params.mpeg4_inter_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
> +		ctx->params.slice_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
> +		ctx->params.slice_max_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> +		break;
> +	default:
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			"Invalid control, id=%d, val=%d\n",
> +			ctrl->id, ctrl->val);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct v4l2_ctrl_ops coda_ctrl_ops = {
> +	.s_ctrl = coda_s_ctrl,
> +};
> +
> +static int coda_ctrls_setup(struct coda_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
> +
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> +		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
> +
> +	return v4l2_ctrl_handler_setup(&ctx->ctrls);
> +}
> +
> +static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct coda_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &coda_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &coda_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static int coda_open(struct file *file)
> +{
> +	struct coda_dev *dev = video_drvdata(file);
> +	struct coda_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	if (dev->instances >= CODA_MAX_INSTANCES)
> +		return -EBUSY;
> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->dev = dev;
> +
> +	set_default_params(ctx);
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> +					 &coda_queue_init);
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		int ret = PTR_ERR(ctx->m2m_ctx);
> +
> +		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
> +			 __func__, ret);
> +		goto err;
> +	}
> +	ret = coda_ctrls_setup(ctx);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
> +
> +		goto err;
> +	}
> +
> +	ctx->fh.ctrl_handler = &ctx->ctrls;
> +
> +	ctx->parabuf.vaddr = dma_alloc_coherent(&dev->plat_dev->dev,
> +			CODA_PARA_BUF_SIZE, &ctx->parabuf.paddr, GFP_KERNEL);
> +	if (!ctx->parabuf.vaddr) {
> +		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	coda_lock(ctx);
> +	ctx->idx = dev->instances++;
> +	coda_unlock(ctx);
> +
> +	clk_prepare_enable(dev->clk_per);
> +	clk_prepare_enable(dev->clk_ahb);
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
> +		 ctx->idx, ctx);
> +
> +	return 0;
> +
> +err:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int coda_release(struct file *file)
> +{
> +	struct coda_dev *dev = video_drvdata(file);
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
> +		 ctx);
> +
> +	coda_lock(ctx);
> +	dev->instances--;
> +	coda_unlock(ctx);
> +
> +	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
> +		ctx->parabuf.vaddr, ctx->parabuf.paddr);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_ctrl_handler_free(&ctx->ctrls);
> +	clk_disable_unprepare(dev->clk_per);
> +	clk_disable_unprepare(dev->clk_ahb);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	return 0;
> +}
> +
> +static unsigned int coda_poll(struct file *file,
> +				 struct poll_table_struct *wait)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +	int ret;
> +
> +	coda_lock(ctx);
> +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	coda_unlock(ctx);
> +	return ret;
> +}
> +
> +static int coda_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +}
> +
> +static const struct v4l2_file_operations coda_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= coda_open,
> +	.release	= coda_release,
> +	.poll		= coda_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= coda_mmap,
> +};
> +
> +static irqreturn_t coda_irq_handler(int irq, void *data)
> +{
> +	struct coda_dev *dev = data;
> +
> +	/* read status register to attend the IRQ */
> +	coda_read(dev, CODA_REG_BIT_INT_STATUS);
> +	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
> +		      CODA_REG_BIT_INT_CLEAR);
> +
> +	return coda_isr(dev);
> +}
> +
> +static u32 coda_supported_firmwares[] = {
> +	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
> +};
> +
> +static bool coda_firmware_supported(u32 vernum)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(coda_supported_firmwares); i++)
> +		if (vernum == coda_supported_firmwares[i])
> +			return true;
> +	return false;
> +}
> +
> +static char *coda_product_name(int product)
> +{
> +	static char buf[9];
> +
> +	switch (product) {
> +	case CODA_DX6:
> +		return "CodaDx6";
> +	default:
> +		snprintf(buf, sizeof(buf), "(0x%04x)", product);
> +		return buf;
> +	}
> +}
> +
> +static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
> +{
> +	u16 product, major, minor, release;
> +	u32 data;
> +	u16 *p;
> +	int i;
> +
> +	clk_prepare_enable(dev->clk_per);
> +	clk_prepare_enable(dev->clk_ahb);
> +
> +	/* Copy the whole firmware image to the code buffer */
> +	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
> +	/*
> +	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
> +	 * This memory seems to be big-endian here, which is weird, since
> +	 * the internal ARM processor of the coda is little endian.
> +	 * Data in this SRAM survives a reboot.
> +	 */
> +	p = (u16 *)fw->data;
> +	for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
> +		data = CODA_DOWN_ADDRESS_SET(i) |
> +			CODA_DOWN_DATA_SET(p[i ^ 1]);
> +		coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
> +	}
> +	release_firmware(fw);
> +
> +	/* Tell the BIT where to find everything it needs */
> +	coda_write(dev, dev->workbuf.paddr,
> +		      CODA_REG_BIT_WORK_BUF_ADDR);
> +	coda_write(dev, dev->codebuf.paddr,
> +		      CODA_REG_BIT_CODE_BUF_ADDR);
> +	coda_write(dev, 0, CODA_REG_BIT_CODE_RUN);
> +
> +	/* Set default values */
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		coda_write(dev, CODADX6_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
> +		break;
> +	default:
> +		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
> +	}
> +	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
> +	coda_write(dev, CODA_INT_INTERRUPT_ENABLE,
> +		      CODA_REG_BIT_INT_ENABLE);
> +
> +	/* Reset VPU and start processor */
> +	data = coda_read(dev, CODA_REG_BIT_CODE_RESET);
> +	data |= CODA_REG_RESET_ENABLE;
> +	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
> +	udelay(10);
> +	data &= ~CODA_REG_RESET_ENABLE;
> +	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
> +	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
> +
> +	/* Load firmware */
> +	coda_write(dev, 0, CODA_CMD_FIRMWARE_VERNUM);
> +	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
> +	coda_write(dev, 0, CODA_REG_BIT_RUN_INDEX);
> +	coda_write(dev, 0, CODA_REG_BIT_RUN_COD_STD);
> +	coda_write(dev, CODA_COMMAND_FIRMWARE_GET, CODA_REG_BIT_RUN_COMMAND);
> +	if (coda_wait_timeout(dev)) {
> +		clk_disable_unprepare(dev->clk_per);
> +		clk_disable_unprepare(dev->clk_ahb);
> +		v4l2_err(&dev->v4l2_dev, "firmware get command error\n");
> +		return -EIO;
> +	}
> +
> +	/* Check we are compatible with the loaded firmware */
> +	data = coda_read(dev, CODA_CMD_FIRMWARE_VERNUM);
> +	product = CODA_FIRMWARE_PRODUCT(data);
> +	major = CODA_FIRMWARE_MAJOR(data);
> +	minor = CODA_FIRMWARE_MINOR(data);
> +	release = CODA_FIRMWARE_RELEASE(data);
> +
> +	clk_disable_unprepare(dev->clk_per);
> +	clk_disable_unprepare(dev->clk_ahb);
> +
> +	if (product != dev->devtype->product) {
> +		v4l2_err(&dev->v4l2_dev, "Wrong firmware. Hw: %s, Fw: %s,"
> +			 " Version: %u.%u.%u\n",
> +			 coda_product_name(dev->devtype->product),
> +			 coda_product_name(product), major, minor, release);
> +		return -EINVAL;
> +	}
> +
> +	v4l2_info(&dev->v4l2_dev, "Initialized %s.\n",
> +		  coda_product_name(product));
> +
> +	if (coda_firmware_supported(data)) {
> +		v4l2_info(&dev->v4l2_dev, "Firmware version: %u.%u.%u\n",
> +			  major, minor, release);
> +	} else {
> +		v4l2_warn(&dev->v4l2_dev, "Unsupported firmware version: "
> +			  "%u.%u.%u\n", major, minor, release);
> +	}
> +
> +	return 0;
> +}
> +
> +static void coda_fw_callback(const struct firmware *fw, void *context)
> +{
> +	struct coda_dev *dev = context;
> +	struct platform_device *pdev = dev->plat_dev;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	if (!fw) {
> +		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
> +		return;
> +	}
> +
> +	/* allocate auxiliary per-device code buffer for the BIT processor */
> +	dev->codebuf_size = fw->size;
> +	dev->codebuf.vaddr = dma_alloc_coherent(&pdev->dev, fw->size,
> +						    &dev->codebuf.paddr,
> +						    GFP_KERNEL);
> +	if (!dev->codebuf.vaddr) {
> +		dev_err(&pdev->dev, "failed to allocate code buffer\n");
> +		return;
> +	}
> +
> +	ret = coda_hw_init(dev, fw);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> +		return;
> +	}
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
> +		return;
> +	}
> +
> +	vfd->fops	= &coda_fops,
> +	vfd->ioctl_ops	= &coda_ioctl_ops;
> +	vfd->release	= video_device_release,
> +	vfd->lock	= &dev->dev_mutex;
> +	vfd->v4l2_dev	= &dev->v4l2_dev;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", CODA_NAME);
> +	dev->vfd = vfd;
> +	video_set_drvdata(vfd, dev);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> +		goto rel_vdev;
> +	}
> +
> +	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
> +	if (IS_ERR(dev->m2m_dev)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> +		goto rel_ctx;
> +	}
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		goto rel_m2m;
> +	}
> +	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video%d\n",
> +		  vfd->num);
> +
> +	return;
> +
> +rel_m2m:
> +	v4l2_m2m_release(dev->m2m_dev);
> +rel_ctx:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +rel_vdev:
> +	video_device_release(vfd);
> +
> +	return;
> +}
> +
> +static int coda_firmware_request(struct coda_dev *dev)
> +{
> +	char *fw = dev->devtype->firmware;
> +
> +	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
> +		coda_product_name(dev->devtype->product));
> +
> +	return request_firmware_nowait(THIS_MODULE, true,
> +		fw, &dev->plat_dev->dev, GFP_KERNEL, dev, coda_fw_callback);
> +}
> +
> +enum coda_platform {
> +	CODA_IMX27,
> +};
> +
> +static struct coda_devtype coda_devdata[] = {
> +	[CODA_IMX27] = {
> +		.firmware    = "v4l-codadx6-imx27.bin",
> +		.product     = CODA_DX6,
> +		.formats     = codadx6_formats,
> +		.num_formats = ARRAY_SIZE(codadx6_formats),
> +	},
> +};
> +
> +static struct platform_device_id coda_platform_ids[] = {
> +	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, coda_platform_ids);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id coda_dt_ids[] = {
> +	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, coda_dt_ids);

Should be
MODULE_DEVICE_TABLE(of, coda_dt_ids);

I completely missed this before, but today it was pointed out to me that
module autoloading doesn't work.

[...]
> +static int coda_remove(struct platform_device *pdev)
> +{
> +	struct coda_dev *dev = platform_get_drvdata(pdev);
> +	unsigned int bufsize;
> +
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		bufsize = CODADX6_WORK_BUF_SIZE;
> +		break;
> +	default:
> +		bufsize = CODA7_WORK_BUF_SIZE;
> +	}
> +
> +	video_unregister_device(dev->vfd);
> +	v4l2_m2m_release(dev->m2m_dev);
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +	video_device_release(dev->vfd);

-+       video_device_release(dev->vfd);
++       v4l2_device_unregister(&dev->v4l2_dev);

video_device_release is already called by kobj refcounting.
With this change I can cleanly rmmod/insmod the coda.ko module.

> +	if (dev->codebuf.vaddr)
> +		dma_free_coherent(&pdev->dev, dev->codebuf_size,
> +				  &dev->codebuf.vaddr, dev->codebuf.paddr);
> +	dma_free_coherent(&pdev->dev, bufsize, &dev->workbuf.vaddr,
> +			  dev->workbuf.paddr);
> +	return 0;
> +}
> +
> +static struct platform_driver coda_driver = {
> +	.probe	= coda_probe,
> +	.remove	= __devexit_p(coda_remove),
> +	.driver	= {
> +		.name	= CODA_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(coda_dt_ids),
> +	},
> +	.id_table = coda_platform_ids,
> +};
> +
> +module_platform_driver(coda_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
> +MODULE_DESCRIPTION("Coda multi-standard codec V4L2 driver");
[...]

regards
Philipp


