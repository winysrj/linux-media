Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46116 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GSQCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 12:02:55 -0400
Received: by wgbdr13 with SMTP id dr13so2636451wgb.1
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 09:02:54 -0700 (PDT)
Message-ID: <50082FA9.1000404@gmail.com>
Date: Thu, 19 Jul 2012 18:02:49 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de, hverkuil@xs4all.nl
Subject: Re: [PATCH v5] media: coda: Add driver for Coda video codec.
References: <1342692073-17317-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1342692073-17317-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

A few minor comments below...

On 07/19/2012 12:01 PM, Javier Martin wrote:
> Coda is a range of video codecs from Chips&Media that
> support H.264, H.263, MPEG4 and other video standards.
> 
> Currently only support for the codadx6 included in the
> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> are the only supported capabilities by now.
> 
> Signed-off-by: Javier Martin<javier.martin@vista-silicon.com>
> Reviewed-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
...
> +static int coda_wait_timeout(struct coda_dev *dev)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> +
> +	while (coda_isbusy(dev)) {
> +		if (time_after(jiffies, timeout))
> +			return -ETIMEDOUT;
> +	};

Superfluous semicolon.

> +	return 0;
> +}
> +
...
> +/*
> + * Add one array of supported formats for each version of Coda:
> + *  i.MX27 ->  codadx6
> + *  i.MX51 ->  coda7
> + *  i.MX6  ->  coda960
> + */
> +static struct coda_fmt codadx6_formats[] = {

static const ?

> +	{
> +		.name = "YUV 4:2:0 Planar",
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.type = CODA_FMT_RAW,
> +	},
> +	{
> +		.name = "H264 Encoded Stream",
> +		.fourcc = V4L2_PIX_FMT_H264,
> +		.type = CODA_FMT_ENC,
> +	},
> +	{
> +		.name = "MPEG4 Encoded Stream",
> +		.fourcc = V4L2_PIX_FMT_MPEG4,
> +		.type = CODA_FMT_ENC,
> +	},
> +};
> +
> +static struct coda_fmt *find_format(struct coda_dev *dev, struct v4l2_format *f)
> +{
> +	struct coda_fmt *formats = dev->devtype->formats;
> +	struct coda_fmt *fmt;
> +	int num_formats = dev->devtype->num_formats;
> +	unsigned int k;
> +
> +	for (k = 0; k<  num_formats; k++) {
> +		fmt =&formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)

'fmt' could be dropped, if you just do:

	if (formats[k].fourcc == f->fmt.pix.pixelformat)

> +			break;
> +	}
> +
> +	if (k == num_formats)
> +		return NULL;
> +
> +	return&formats[k];
> +}
> +
> +/*
> + * V4L2 ioctl() operations.
> + */
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, CODA_NAME, sizeof(cap->driver) - 1);

strlcpy

> +	strncpy(cap->card, CODA_NAME, sizeof(cap->card) - 1);

strlcpy

> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> +				| V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
...
> +
> +static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
> +{
> +	enum v4l2_field field;
> +
> +	if (!find_format(dev, f))
> +		return -EINVAL;

No, the driver should not return an error here, only because the 
pixelformat passed from user space is not supported. The pixelformat
should be adjusted to some default supported value.
You could, for example, add an extra argument to find_format() so this
function returns some valid format when neeeded.

Also see http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-fmt.html

"... When the application calls the VIDIOC_S_FMT ioctl with a pointer to 
a v4l2_format structure the driver checks and adjusts the parameters 
against hardware abilities. Drivers should not return an error code 
unless the input is ambiguous, this is a mechanism to fathom device 
capabilities and to approach parameters acceptable for both the 
application and driver."
...

"The VIDIOC_TRY_FMT ioctl is equivalent to VIDIOC_S_FMT with one 
exception: it does not change driver state. " 

And http://www.spinics.net/lists/linux-media/msg50465.html ...

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
> +				      W_ALIGN,&f->fmt.pix.height,
> +				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
> +		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
> +		f->fmt.pix.sizeimage = f->fmt.pix.height *
> +					f->fmt.pix.bytesperline;
> +	} else { /*encoded formats h.264/mpeg4 */
> +		f->fmt.pix.bytesperline = 0;
> +		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	int ret;
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
> +	ret = vidioc_try_fmt(ctx->dev, f);
> +	if (ret<  0)
> +		return ret;

This needs to be reordered, according to the comments above.

> +
> +	f->fmt.pix.colorspace = ctx->colorspace;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +	struct coda_fmt *fmt;
> +	int ret;
> +
> +	fmt = find_format(ctx->dev, f);
> +	/*
> +	 * Since decoding support is not implemented yet do not allow
> +	 * CODA_FMT formats in the capture interface.
> +	 */
> +	if (!fmt || !(fmt->type == CODA_FMT_RAW)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	ret = vidioc_try_fmt(ctx->dev, f);
> +	if (ret<  0)
> +		return ret;

Ditto.

> +
> +	if (!f->fmt.pix.colorspace)
> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
> +
> +	return 0;
> +}
> +
...
> +
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	int ret;

What about just removing this variable ?

> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +	return ret;
> +}
> +
...
> +/*
> + * Queue operations
> + */
> +static int coda_queue_setup(struct vb2_queue *vq,
> +				const struct v4l2_format *fmt,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
> +	unsigned int size;
> +
> +	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		*nbuffers = CODA_OUTPUT_BUFS;
> +		if (fmt)
> +			size = fmt->fmt.pix.width *
> +				fmt->fmt.pix.height * 3 / 2;

No need to also check fmt.pix.pixelformat here ?
What about fmt.pix.sizeimage ?

> +		else
> +			size = CODA_MAX_WIDTH *
> +				CODA_MAX_HEIGHT * 3 / 2;
> +	} else {
> +		*nbuffers = CODA_CAPTURE_BUFS;
> +		size = CODA_MAX_FRAME_SIZE;
> +	}
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	alloc_ctxs[0] = ctx->dev->alloc_ctx;
> +
> +	v4l2_dbg(1, coda_debug,&ctx->dev->v4l2_dev,
> +		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
> +
> +	return 0;
> +}
> +
...
> +
> +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	struct coda_dev *dev = ctx->dev;
> +	u32 bitstream_buf, bitstream_size;

Nit: you use "v4l2_err(&ctx->dev->v4l2_dev, ...);" several times below.
How about adding 

 struct v4l2_dev *v4l2_dev = &ctx->dev->v4l2_dev;

here so the error prints can be shortened to "v4l2_err(v4l2_dev, ...); ?

> +
> +	if (count<  1)
> +		return -EINVAL;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		ctx->rawstreamon = 1;
> +	else
> +		ctx->compstreamon = 1;
> +
> +	if (ctx->rawstreamon&  ctx->compstreamon) {
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
> +		if (q_data_src->fmt->type == CODA_FMT_RAW&&
> +		    q_data_dst->fmt->type == CODA_FMT_ENC) {
> +			ctx->inst_type = CODA_INST_ENCODER;
> +		} else if (q_data_src->fmt->type == CODA_FMT_ENC&&
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
> +		switch (dev->devtype->product) {
> +		case CODA_DX6:
> +			coda_write(dev, CODADX6_STREAM_BUF_DYNALLOC_EN |
> +				CODADX6_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> +			break;
> +		default:
> +			coda_write(dev, CODA7_STREAM_BUF_DYNALLOC_EN |
> +				CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> +		}
> +
> +		/* Configure the coda */
> +		coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> +
> +		/* Could set rotation here if needed */
> +		switch (dev->devtype->product) {
> +		case CODA_DX6:
> +			value = (q_data_src->width&  CODADX6_PICWIDTH_MASK)<<  CODADX6_PICWIDTH_OFFSET;
> +			break;
> +		default:
> +			value = (q_data_src->width&  CODA7_PICWIDTH_MASK)<<  CODA7_PICWIDTH_OFFSET;
> +		}
> +		value |= (q_data_src->height&  CODA_PICHEIGHT_MASK)<<  CODA_PICHEIGHT_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
> +		coda_write(dev, ctx->params.framerate,
> +			   CODA_CMD_ENC_SEQ_SRC_F_RATE);
> +
> +		switch (dst_fourcc) {
> +		case V4L2_PIX_FMT_MPEG4:
> +			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_MP4 : CODA7_MODE_ENCODE_MP4;

Probably better to just use if/else.	
> +			coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
> +			value  = (0&  CODA_MP4PARAM_VERID_MASK)<<  CODA_MP4PARAM_VERID_OFFSET;
> +			value |= (0&  CODA_MP4PARAM_INTRADCVLCTHR_MASK)<<  CODA_MP4PARAM_INTRADCVLCTHR_OFFSET;
> +			value |= (0&  CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK)<<  CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET;
> +			value |=  0&  CODA_MP4PARAM_DATAPARTITIONENABLE_MASK;

Hmm, isn't something wrong here? The "0 &"s cause 'value' is just set 
to 0 at this point. 0 & X = 0; X | 0 = 0;... I guess it's just some 
debugging leftovers.

> +			coda_write(dev, value, CODA_CMD_ENC_SEQ_MP4_PARA);
> +			break;
> +		case V4L2_PIX_FMT_H264:
> +			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_H264 : CODA7_MODE_ENCODE_H264;
> +			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
> +			value  = (0&  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK)<<  CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET;
> +			value |= (0&  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK)<<  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET;
> +			value |= (0&  CODA_264PARAM_DISABLEDEBLK_MASK)<<  CODA_264PARAM_DISABLEDEBLK_OFFSET;
> +			value |= (0&  CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK)<<  CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET;
> +			value |=  0&  CODA_264PARAM_CHROMAQPOFFSET_MASK;

Ditto.

> +			coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
> +			break;
> +		default:
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				 "dst format (0x%08x) invalid.\n", dst_fourcc);
> +			return -EINVAL;
> +		}
> +
> +		value  = (ctx->params.slice_max_mb&  CODA_SLICING_SIZE_MASK)<<  CODA_SLICING_SIZE_OFFSET;
> +		value |= (1&  CODA_SLICING_UNIT_MASK)<<  CODA_SLICING_UNIT_OFFSET;
> +		if (ctx->params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
> +			value |=  1&  CODA_SLICING_MODE_MASK;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
> +		value  =  ctx->params.gop_size&  CODA_GOP_SIZE_MASK;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
> +
> +		if (ctx->params.bitrate) {
> +			/* Rate control enabled */
> +			value  = (0&  CODA_RATECONTROL_AUTOSKIP_MASK)<<  CODA_RATECONTROL_AUTOSKIP_OFFSET;
> +			value |= (0&  CODA_RATECONTROL_INITIALDELAY_MASK)<<  CODA_RATECONTROL_INITIALDELAY_OFFSET;

?

> +			value |= (ctx->params.bitrate&  CODA_RATECONTROL_BITRATE_MASK)<<  CODA_RATECONTROL_BITRATE_OFFSET;
> +			value |=  1&  CODA_RATECONTROL_ENABLE_MASK;
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
> +		value = (CODA_DEFAULT_GAMMA&  CODA_GAMMA_MASK)<<  CODA_GAMMA_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_GAMMA);
> +
> +		value  = (CODA_DEFAULT_GAMMA>  0)<<  CODA_OPTION_GAMMA_OFFSET;
> +		value |= (0&  CODA_OPTION_SLICEREPORT_MASK)<<  CODA_OPTION_SLICEREPORT_OFFSET;
> +		coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
> +
> +		if (dst_fourcc == V4L2_PIX_FMT_H264) {
> +			value  = (FMO_SLICE_SAVE_BUF_SIZE<<  7);
> +			value |= (0&  CODA_FMOPARAM_TYPE_MASK)<<  CODA_FMOPARAM_TYPE_OFFSET;
> +			value |=  0&  CODA_FMOPARAM_SLICENUM_MASK;

?
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
> +		for (i = 0; i<  src_vq->num_buffers; i++) {
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
> +		v4l2_dbg(1, coda_debug,&ctx->dev->v4l2_dev,
> +			 "%s: output\n", __func__);
> +		ctx->rawstreamon = 0;
> +	} else {
> +		v4l2_dbg(1, coda_debug,&ctx->dev->v4l2_dev,
> +			 "%s: capture\n", __func__);
> +		ctx->compstreamon = 0;
> +	}
> +
> +	if (!ctx->rawstreamon&&  !ctx->compstreamon) {
> +		v4l2_dbg(1, coda_debug,&ctx->dev->v4l2_dev,
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
...
> +
> +static int coda_ctrls_setup(struct coda_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
> +
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
> +	v4l2_ctrl_new_std(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls,&coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> +		(1<<  V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);

You should check ctx->ctrls.error to make sure all controls were
crated successfuly, before trying v4l2_ctrl_handler_setup().

> +
> +	return v4l2_ctrl_handler_setup(&ctx->ctrls);
> +}
> +
...
> +
> +static int coda_open(struct file *file)
> +{
> +	struct coda_dev *dev = video_drvdata(file);
> +	struct coda_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	if (dev->instances>= CODA_MAX_INSTANCES)
> +		return -EBUSY;
> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data =&ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->dev = dev;
> +
> +	set_default_params(ctx);
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> +					&coda_queue_init);
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

Nit: superfluous empty line.

> +		goto err;
> +	}
> +
> +	ctx->fh.ctrl_handler =&ctx->ctrls;
> +
> +	ctx->parabuf.vaddr = dma_alloc_coherent(&dev->plat_dev->dev,
> +			CODA_PARA_BUF_SIZE,&ctx->parabuf.paddr, GFP_KERNEL);
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

No need to check return value ?

> +
> +	v4l2_dbg(1, coda_debug,&dev->v4l2_dev, "Created instance %d (%p)\n",
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
> +	v4l2_dbg(1, coda_debug,&dev->v4l2_dev, "Releasing instance %p\n",
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
...
> +static void coda_fw_callback(const struct firmware *fw, void *context)
> +{
> +	struct coda_dev *dev = context;
> +	struct platform_device *pdev = dev->plat_dev;
> +	int ret;
> +
> +	if (!fw) {
> +		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
> +		return;
> +	}
> +
> +	/* allocate auxiliary per-device code buffer for the BIT processor */
> +	dev->codebuf_size = fw->size;

Does it make sense to do some sanity check on firmware size here ?

> +	dev->codebuf.vaddr = dma_alloc_coherent(&pdev->dev, fw->size,
> +						&dev->codebuf.paddr,
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
> +	dev->vfd.fops	=&coda_fops,
> +	dev->vfd.ioctl_ops	=&coda_ioctl_ops;
> +	dev->vfd.release	= video_device_release_empty,
> +	dev->vfd.lock	=&dev->dev_mutex;
> +	dev->vfd.v4l2_dev	=&dev->v4l2_dev;
> +	snprintf(dev->vfd.name, sizeof(dev->vfd.name), "%s", CODA_NAME);
> +	video_set_drvdata(&dev->vfd, dev);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> +		return;
> +	}
> +
> +	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
> +	if (IS_ERR(dev->m2m_dev)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> +		goto rel_ctx;
> +	}
> +
> +	ret = video_register_device(&dev->vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		goto rel_m2m;
> +	}
> +	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video%d\n",
> +		  dev->vfd.num);
> +
> +	return;
> +
> +rel_m2m:
> +	v4l2_m2m_release(dev->m2m_dev);
> +rel_ctx:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +
> +	return;

Unneded return;

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
> +		fw,&dev->plat_dev->dev, GFP_KERNEL, dev, coda_fw_callback);
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
> +	{ .compatible = "fsl,imx27-vpu", .data =&coda_platform_ids[CODA_IMX27] },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, coda_dt_ids);
> +#endif
> +
> +static int __devinit coda_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id =
> +			of_match_device(of_match_ptr(coda_dt_ids),&pdev->dev);
> +	const struct platform_device_id *pdev_id;
> +	struct coda_dev *dev;
> +	struct resource *res;
> +	unsigned int bufsize;
> +	int ret;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(&pdev->dev, "Not enough memory for %s\n",
> +			CODA_NAME);
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&dev->irqlock);
> +
> +	dev->plat_dev = pdev;
> +	dev->clk_per = devm_clk_get(&pdev->dev, "per");
> +	if (IS_ERR(dev->clk_per)) {
> +		dev_err(&pdev->dev, "Could not get per clock\n");
> +		return PTR_ERR(dev->clk_per);
> +	}
> +
> +	dev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(dev->clk_ahb)) {
> +		dev_err(&pdev->dev, "Could not get ahb clock\n");
> +		return PTR_ERR(dev->clk_ahb);
> +	}
> +
> +	/* Get  memory for physical registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		return -ENOENT;
> +	}
> +
> +	if (devm_request_mem_region(&pdev->dev, res->start,
> +			resource_size(res), CODA_NAME) == NULL) {
> +		dev_err(&pdev->dev, "failed to request memory region\n");
> +		return -ENOENT;
> +	}
> +	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
> +				      resource_size(res));
> +	if (!dev->regs_base) {
> +		dev_err(&pdev->dev, "failed to ioremap address region\n");
> +		return -ENOENT;
> +	}
> +
> +	/* IRQ */
> +	dev->irq = platform_get_irq(pdev, 0);

Nit: dev->irq is only used in this function, so perhaps there is no 
need for an 'irq' member in struct coda_dev.

> +	if (dev->irq<  0) {
> +		dev_err(&pdev->dev, "failed to get irq resource\n");
> +		return -ENOENT;
> +	}
> +
> +	if (devm_request_irq(&pdev->dev, dev->irq, coda_irq_handler,
> +		0, CODA_NAME, dev)<  0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return -ENOENT;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev,&dev->v4l2_dev);
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&dev->dev_mutex);
> +
> +	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
> +
> +	if (of_id)
> +		dev->devtype = of_id->data;
> +	else if (pdev_id)
> +		dev->devtype =&coda_devdata[pdev_id->driver_data];
> +	else
> +		return -EINVAL;

Missing v4l2_device_unregister() ?

> +
> +	/* allocate auxiliary per-device buffers for the BIT processor */
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		bufsize = CODADX6_WORK_BUF_SIZE;
> +		break;
> +	default:
> +		bufsize = CODA7_WORK_BUF_SIZE;

Can't bufsize be stored in dev->workbuf data structure ?
Then you would not need same switch statement in coda_remove()
below.

> +	}
> +	dev->workbuf.vaddr = dma_alloc_coherent(&pdev->dev, bufsize,
> +						&dev->workbuf.paddr,
> +						    GFP_KERNEL);
> +	if (!dev->workbuf.vaddr) {
> +		dev_err(&pdev->dev, "failed to allocate work buffer\n");
> +		return -ENOMEM;
> +	}
> +
> +	platform_set_drvdata(pdev, dev);
> +
> +	return coda_firmware_request(dev);
> +}
> +
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
> +	video_unregister_device(&dev->vfd);
> +	v4l2_m2m_release(dev->m2m_dev);
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	if (dev->codebuf.vaddr)
> +		dma_free_coherent(&pdev->dev, dev->codebuf_size,
> +				&dev->codebuf.vaddr, dev->codebuf.paddr);
> +	dma_free_coherent(&pdev->dev, bufsize,&dev->workbuf.vaddr,
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
> +MODULE_AUTHOR("Javier Martin<javier.martin@vista-silicon.com>");
> +MODULE_DESCRIPTION("Coda multi-standard codec V4L2 driver");

Otherwise looks good!

--

Thanks,
Sylwester
