Return-path: <mchehab@gaivota>
Received: from mailout2.samsung.com ([203.254.224.25]:63462 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1AEPpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 10:45:39 -0500
Date: Wed, 05 Jan 2011 16:45:30 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 7/9] media: MFC: Add MFC v5.1 V4L2 driver
In-reply-to: <002601cba59d$e4852290$ad8f67b0$%han@samsung.com>
To: 'Jonghun Han' <jonghun.han@samsung.com>,
	'Jeongtae Park' <jtp.park@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <000c01cbacef$97e5c490$c7b14db0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-5-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
 <002601cba59d$e4852290$ad8f67b0$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

Thanks for the comment. Some of them include my code, which will I comment
below.
 
> My review also imply Kamil's original patch.

<snip>

> > +
> > +/* Display status */
> > +#define S5P_FIMV_DEC_STATUS_DECODING_ONLY		0
> > +#define S5P_FIMV_DEC_STATUS_DECODING_DISPLAY		1
> > +#define S5P_FIMV_DEC_STATUS_DISPLAY_ONLY		2
> > +#define S5P_FIMV_DEC_STATUS_DECODING_EMPTY		3
> > +#define S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK	7
> > +#define S5P_FIMV_DEC_STATUS_PROGRESSIVE			(0<<3)
> > +#define S5P_FIMV_DEC_STATUS_INTERLACE			(1<<3)
> > +#define S5P_FIMV_DEC_STATUS_INTERLACE_MASK		(1<<3)
> > +#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_TWO		(0<<4)
> > +#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_FOUR		(1<<4)
> > +#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_MASK		(1<<4)
> > +#define S5P_FIMV_DEC_STATUS_CRC_GENERATED		(1<<5)
> > +#define S5P_FIMV_DEC_STATUS_CRC_NOT_GENERATED		(0<<5)
> > +#define S5P_FIMV_DEC_STATUS_CRC_MASK			(1<<5)
> 
> 
> Use like (0 << 3), (1 << 3) ...
> 
> <snip>

Fixed.
 
> > +/* Enumerate format */
> > +static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool
> out,
> > +						enum s5p_mfc_node_type
> > node)
> > +{
> > +	struct s5p_mfc_fmt *fmt;
> > +	int i, j = 0;
> > +
> > +	if (node == MFCNODE_INVALID)
> > +		return 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> > +		if (mplane && formats[i].num_planes == 1)
> > +			continue;
> > +		else if (!mplane && formats[i].num_planes > 1)
> > +			continue;
> > +		if (node == MFCNODE_DECODER) {
> > +			if (out && formats[i].type != MFC_FMT_DEC)
> > +				continue;
> > +			else if (!out && formats[i].type != MFC_FMT_RAW)
> > +				continue;
> > +		} else if (node == MFCNODE_ENCODER) {
> > +			if (out && formats[i].type != MFC_FMT_RAW)
> > +				continue;
> > +			else if (!out && formats[i].type != MFC_FMT_ENC)
> > +				continue;
> > +		}
> > +
> > +		if (j == f->index) {
> > +			fmt = &formats[i];
> > +			strlcpy(f->description, fmt->name,
> > +				sizeof(f->description));
> > +			f->pixelformat = fmt->fourcc;
> > +
> > +			return 0;
> > +		}
> > +
> > +		++j;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> 
> At a glance, no needed to use j variable.
> if (i == f->index) instead of if (j == f->index)
> 

This code by me was modified, as you know the patches got mixed up.
There should be two num_fmt's one for decoding and one for encoding node.
Using j here will ensure that numbering of formats for both nodes is
continuous. 

> 
> > +/* Get format */
> > +static int vidioc_g_fmt(struct file *file, void *priv, struct
> v4l2_format
> *f)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +
> > +	mfc_debug_enter();
> > +	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> > +	    ctx->state == MFCINST_GOT_INST) {
> > +		/* If the MFC is parsing the header,
> > +		 * so wait until it is finished */
> > +		s5p_mfc_clean_ctx_int_flags(ctx);
> > +		s5p_mfc_wait_for_done_ctx(ctx,
> > S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
> > +									1);
> > +	}
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> > +	    ctx->state >= MFCINST_HEAD_PARSED &&
> > +	    ctx->state <= MFCINST_ABORT) {
> > +		/* This is run on CAPTURE (deocde output) */
> > +		/* Width and height are set to the dimensions
> > +		   of the movie, the buffer is bigger and
> > +		   further processing stages should crop to this
> > +		   rectangle. */
> > +		f->fmt.pix_mp.width = ctx->buf_width;
> > +		f->fmt.pix_mp.height = ctx->buf_height;
> > +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> > +		f->fmt.pix_mp.num_planes = 2;
> > +		/* Set pixelformat to the format in which MFC
> > +		   outputs the decoded frame */
> > +		f->fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
> > +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->buf_width;
> > +		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->luma_size;
> > +		f->fmt.pix_mp.plane_fmt[1].bytesperline = ctx->buf_width;
> > +		f->fmt.pix_mp.plane_fmt[1].sizeimage = ctx->chroma_size;
> > +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		/* This is run on OUTPUT
> > +		   The buffer contains compressed image
> > +		   so width and height have no meaning */
> > +		f->fmt.pix_mp.width = 1;
> > +		f->fmt.pix_mp.height = 1;
> > +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> > +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx-
> > >dec_src_buf_size;
> > +		f->fmt.pix_mp.plane_fmt[0].sizeimage =
> ctx->dec_src_buf_size;
> > +		f->fmt.pix_mp.pixelformat = ctx->src_fmt->fourcc;
> > +		f->fmt.pix_mp.num_planes = ctx->src_fmt->num_planes;
> > +	} else {
> > +		mfc_err("Format could not be read\n");
> > +		mfc_debug("%s-- with error\n", __func__);
> > +		return -EINVAL;
> > +	}
> > +	mfc_debug_leave();
> > +	return 0;
> > +}
> > +
> 
> How about using size 0 instead of 1 for no meaning value?

Yes, it is also good. After giving it a though I can agree.

> In my opinion f->fmt.pix_mp.plane_fmt[1].bytesperline should be
> (ctx->buf_width >> 1), isn't it ?
> 
> <snip>
> 
> > +static int vidioc_try_fmt_enc(struct file *file, void *priv, struct
> v4l2_format *f)
> > +{
> > +	struct s5p_mfc_fmt *fmt;
> > +
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		fmt = find_format(f, MFC_FMT_ENC);
> > +		if (!fmt) {
> > +			mfc_err("failed to try output format\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (f->fmt.pix_mp.plane_fmt[0].sizeimage == 0) {
> > +			mfc_err("must be set encoding output size\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		f->fmt.pix_mp.plane_fmt[0].bytesperline =
> > +			f->fmt.pix_mp.plane_fmt[0].sizeimage;
> > +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		fmt = find_format(f, MFC_FMT_RAW);
> > +		if (!fmt) {
> > +			mfc_err("failed to try output format\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
> > +			mfc_err("failed to try output format\n");
> > +			return -EINVAL;
> > +		}
> > +	} else {
> > +		mfc_err("invalid buf type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> How about check the valid range ?
> This driver already has pix_limit variable in variant structure.
> 
> <snip>
> 
> > +static int vidioc_s_fmt_enc(struct file *file, void *priv, struct
> v4l2_format *f)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	unsigned long flags;
> > +	int ret = 0;
> > +	struct s5p_mfc_fmt *fmt;
> > +
> > +	mfc_debug_enter();
> > +
> > +	ret = vidioc_try_fmt_enc(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
> > +		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		fmt = find_format(f, MFC_FMT_ENC);
> > +		if (!fmt) {
> > +			mfc_err("failed to set capture format\n");
> > +			return -EINVAL;
> > +		}
> > +		ctx->state = MFCINST_INIT;
> > +
> > +		ctx->dst_fmt = fmt;
> > +		ctx->codec_mode = ctx->dst_fmt->codec_mode;
> > +		mfc_debug("codec number: %d\n", ctx->dst_fmt->codec_mode);
> > +
> > +		ctx->enc_dst_buf_size =
> f->fmt.pix_mp.plane_fmt[0].sizeimage;
> > +		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
> > +
> > +		ctx->dst_bufs_cnt = 0;
> > +		ctx->capture_state = QUEUE_FREE;
> > +
> > +		s5p_mfc_alloc_instance_buffer(ctx);
> > +
> > +		spin_lock_irqsave(&dev->condlock, flags);
> > +		set_bit(ctx->num, &dev->ctx_work_bits);
> > +		spin_unlock_irqrestore(&dev->condlock, flags);
> > +
> > +		s5p_mfc_clean_ctx_int_flags(ctx);
> > +		s5p_mfc_try_run();
> > +		if (s5p_mfc_wait_for_done_ctx(ctx, \
> > +				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET,
> > 1)) {
> > +			/* Error or timeout */
> > +			mfc_err("Error getting instance from hardware.\n");
> > +			s5p_mfc_release_instance_buffer(ctx);
> > +			ret = -EIO;
> > +			goto out;
> > +		}
> > +		mfc_debug("Got instance number: %d\n", ctx->inst_no);
> > +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		fmt = find_format(f, MFC_FMT_RAW);
> > +		if (!fmt) {
> > +			mfc_err("failed to set output format\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
> > +			mfc_err("failed to set output format\n");
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		ctx->src_fmt = fmt;
> > +		ctx->img_width = f->fmt.pix_mp.width;
> > +		ctx->img_height = f->fmt.pix_mp.height;
> > +
> > +		mfc_debug("codec number: %d\n", ctx->src_fmt->codec_mode);
> > +		mfc_debug("fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
> > +			f->fmt.pix_mp.width, f->fmt.pix_mp.height,
> > +			ctx->img_width, ctx->img_height);
> > +
> > +		ctx->buf_width = f->fmt.pix_mp.plane_fmt[0].bytesperline;
> > +		ctx->luma_size = f->fmt.pix_mp.plane_fmt[0].sizeimage;
> > +		ctx->buf_width = f->fmt.pix_mp.plane_fmt[1].bytesperline;
> > +		ctx->chroma_size = f->fmt.pix_mp.plane_fmt[1].sizeimage;
> > +
> > +		ctx->src_bufs_cnt = 0;
> > +		ctx->output_state = QUEUE_FREE;
> > +	} else {
> > +		mfc_err("invalid buf type\n");
> > +		return -EINVAL;
> > +	}
> > +out:
> > +	mfc_debug_leave();
> > +	return ret;
> > +}
> > +
> 
> ctx->buf_width is overwritten by " f-
> >fmt.pix_mp.plane_fmt[1].bytesperline".

Yep, something not good here. Jeongtae?

> 
> <snip>
> 
> > +static int vidioc_reqbufs_enc(struct file *file, void *priv,
> > +					  struct v4l2_requestbuffers
> *reqbufs)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	int ret = 0;
> > +
> > +	mfc_debug_enter();
> > +
> > +	mfc_debug("type: %d\n", reqbufs->memory);
> > +
> > +	/* if memory is not mmp or userptr return error */
> > +	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
> > +		(reqbufs->memory != V4L2_MEMORY_USERPTR))
> > +		return -EINVAL;
> > +
> > +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		if (ctx->capture_state != QUEUE_FREE) {
> > +			mfc_err("invalid capture state: %d\n", ctx-
> > >capture_state);
> > +			return -EINVAL;
> > +		}
> > +
> > +		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +		if (ret != 0) {
> > +			mfc_err("error in vb2_reqbufs() for E(D)\n");
> > +			return ret;
> > +		}
> > +		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> > +
> > +		ret = s5p_mfc_alloc_codec_buffers(ctx);
> > +		if (ret) {
> > +			mfc_err("Failed to allocate encoding buffers.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			return -ENOMEM;
> > +		}
> > +	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > {
> > +		if (ctx->output_state != QUEUE_FREE) {
> > +			mfc_err("invalid output state: %d\n",
> ctx->output_state);
> > +			return -EINVAL;
> > +		}
> > +
> > +		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
> > +		if (ret != 0) {
> > +			mfc_err("error in vb2_reqbufs() for E(S)\n");
> > +			return ret;
> > +		}
> > +		ctx->output_state = QUEUE_BUFS_REQUESTED;
> > +	} else {
> > +		mfc_err("invalid buf type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	mfc_debug("--\n");
> > +
> > +	return ret;
> > +}
> > +
> 
> if (ctx->capture_state != QUEUE_FREE), conditional statement looks
> strange.
> If REQBUFS(0) directly follows REQBUFS(n), state is
> QUEUE_BUFS_REQUESTED.
> So in that case REQBUFS(0) will be failed.

This one, as I see, was heavily modified by Jeongtae. When I look at my
original
code everything seems fine. Entry to reqbufs is protected by mfc_mutex. This
is
done in drivers/media/video/v4l2-dev.c. At the end there is waiting for end
of interrupt.
 
> <snip>
> 
> > +static int set_ctrl_val_enc(struct s5p_mfc_ctx *ctx, struct
> v4l2_control
> *ctrl)
> > +{
> > +	struct s5p_mfc_enc_params *p = &ctx->enc_params;
> > +	int ret = 0;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_CODEC_MFC51_ENC_GOP_SIZE:
> > +		p->gop_size = ctrl->value;
> > +		break;
> > +	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MODE:
> > +		p->slice_mode = ctrl->value;
> > +		break;
> > +	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MB:
> > +		p->slice_mb = ctrl->value;
> > +		break;
> > +	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_BIT:
> > +		p->slice_bit = ctrl->value;
> > +		break;
> > +	case V4L2_CID_CODEC_MFC51_ENC_INTRA_REFRESH_MB:
> > +		p->intra_refresh_mb = ctrl->value;
> > +		break;
> > +	case V4L2_CID_CODEC_MFC51_ENC_PAD_CTRL_ENABLE:
> > +		p->pad = ctrl->value;
> > +		break;
> <snip>
> > +	case V4L2_CID_CODEC_MFC51_ENC_H264_I_PERIOD:
> > +		p->codec.h264.open_gop_size = ctrl->value;
> > +		break;
> > +	default:
> > +		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
> > +		ret = -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> 
> How about use MACRO like cmd_input_size in
> ./drivers/media/video/v4l2-ioctl.c.
> 
> <snip>
> 
> > +static int vidioc_g_ext_ctrls(struct file *file, void *priv,
> > +				struct v4l2_ext_controls *f)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	struct v4l2_ext_control *ext_ctrl;
> > +	struct v4l2_control ctrl;
> > +	int i;
> > +	int ret = 0;
> > +
> > +	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
> > +		return -EINVAL;
> > +
> > +	if (f->ctrl_class != V4L2_CTRL_CLASS_CODEC)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < f->count; i++) {
> > +		ext_ctrl = (f->controls + i);
> > +
> > +		ctrl.id = ext_ctrl->id;
> > +
> > +		ret = get_ctrl_val_enc(ctx, &ctrl);
> > +		if (ret == 0) {
> > +			ext_ctrl->value = ctrl.value;
> > +		} else {
> > +			f->error_idx = i;
> > +			break;
> > +		}
> > +
> > +		mfc_debug("[%d] id: 0x%08x, value: %d", i, ext_ctrl->id,
> > +				ext_ctrl->value);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> 
> How about use vidioc_g_ext_ctrls_enc instead of vidioc_g_ext_ctrls ?
> Because the function is only for encoder.
> vidioc_s_ext_ctrls also.
> 
> <snip>
> 
> > +/* Get cropping information */
> > +static int vidioc_g_crop(struct file *file, void *priv,
> > +		struct v4l2_crop *cr)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	u32 left, right, top, bottom;
> > +
> > +	mfc_debug_enter();
> > +	if (ctx->state != MFCINST_HEAD_PARSED &&
> > +	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
> > +					&& ctx->state != MFCINST_FINISHED)
> > {
> > +			mfc_debug("%s-- with error\n", __func__);
> > +			return -EINVAL;
> > +		}
> 
> Keep indent "}"
> 
> <snip>
> 
> > +static int s5p_mfc_enc_queue_setup(struct vb2_queue *vq,
> > +		unsigned int *buf_count, unsigned int *plane_count,
> > +		unsigned long psize[], void *allocators[])
> > +{
> > +	struct s5p_mfc_ctx *ctx = vq->drv_priv;
> > +	int i;
> > +
> > +	mfc_debug_enter();
> > +
> > +	if (ctx->state != MFCINST_GOT_INST) {
> > +		mfc_err("inavlid state: %d\n", ctx->state);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		if (ctx->dst_fmt)
> > +			*plane_count = ctx->dst_fmt->num_planes;
> > +		else
> > +			*plane_count = MFC_ENC_CAP_PLANE_COUNT;
> > +
> > +		if (*buf_count < 1)
> > +			*buf_count = 1;
> > +		if (*buf_count > MFC_MAX_BUFFERS)
> > +			*buf_count = MFC_MAX_BUFFERS;
> > +
> > +		psize[0] = ctx->enc_dst_buf_size;
> > +		allocators[0] = ctx->dev-
> > >alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX];
> > +	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		if (ctx->src_fmt)
> > +			*plane_count = ctx->src_fmt->num_planes;
> > +		else
> > +			*plane_count = MFC_ENC_OUT_PLANE_COUNT;
> > +
> > +		if (*buf_count < 1)
> > +			*buf_count = 1;
> > +		if (*buf_count > MFC_MAX_BUFFERS)
> > +			*buf_count = MFC_MAX_BUFFERS;
> > +
> > +		psize[0] = ctx->luma_size;
> > +		psize[1] = ctx->chroma_size;
> > +		allocators[0] = ctx->dev-
> > >alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX];
> > +		allocators[1] = ctx->dev-
> > >alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX];
> > +
> > +	} else {
> > +		mfc_err("inavlid queue type: %d\n", vq->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	mfc_debug("buf_count: %d, plane_count: %d\n", *buf_count,
> > *plane_count);
> > +	for (i = 0; i < *plane_count; i++)
> > +		mfc_debug("plane[%d] size=%lu\n", i, psize[i]);
> > +
> > +	mfc_debug_leave();
> > +
> > +	return 0;
> > +}
> > +
> 
> Below two lines are dead line.
> 		else
> 			*plane_count = MFC_ENC_OUT_PLANE_COUNT;
> Because ctx->src_fmt is set in s5p_mfc_open.
> 
> <snip>
> 
> > +/* Let the streaming begin. */
> > +static int s5p_mfc_start_streaming(struct vb2_queue *q)
> > +{
> > +	struct s5p_mfc_ctx *ctx = q->drv_priv;
> > +
> > +	unsigned long flags;
> > +	/* If context is ready then schedule it to run */
> > +	if (s5p_mfc_ctx_ready(ctx)) {
> > +		spin_lock_irqsave(&dev->condlock, flags);
> > +		set_bit(ctx->num, &dev->ctx_work_bits);
> > +		spin_unlock_irqrestore(&dev->condlock, flags);
> > +	}
> > +
> > +	s5p_mfc_try_run();
> > +	return 0;
> > +}
> > +
> 
> In my opinion s5p_mfc_start_streaming is useless.
> Because in the following sequence s5p_mfc_try_run will be called in
> s5p_mfc_enc_buf_queue without s5p_mfc_start_streaming.
> VIDIOC_STREAMON -> vidioc_streamon -> vb2_streamon ->
> __enqueue_in_driver ->
> buf_queue -> s5p_mfc_enc_buf_queue

Using s5p_mfc_start_streaming is necessary because of videobuf2.
 
> <snip>
> 
> > +/* Open an MFC node */
> > +static int s5p_mfc_open(struct file *file)
> > +{
> > +	struct s5p_mfc_ctx *ctx = NULL;
> > +	struct vb2_queue *q;
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	mfc_debug_enter();
> > +	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
> > +	/* Allocate memory for context */
> > +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> > +	if (!ctx) {
> > +		mfc_err("Not enough memory.\n");
> > +		ret = -ENOMEM;
> > +		goto out_open;
> > +	}
> > +	file->private_data = ctx;
> > +	ctx->dev = dev;
> > +	INIT_LIST_HEAD(&ctx->src_queue);
> > +	INIT_LIST_HEAD(&ctx->dst_queue);
> > +	ctx->src_queue_cnt = 0;
> > +	ctx->dst_queue_cnt = 0;
> > +	/* Get context number */
> > +	ctx->num = 0;
> > +	while (dev->ctx[ctx->num]) {
> > +		ctx->num++;
> > +		if (ctx->num >= MFC_NUM_CONTEXTS) {
> > +			mfc_err("Too many open contexts.\n");
> > +			ret = -EAGAIN;
> > +			goto out_open;
> > +		}
> > +	}
> > +	/* Mark context as idle */
> > +	spin_lock_irqsave(&dev->condlock, flags);
> > +	clear_bit(ctx->num, &dev->ctx_work_bits);
> > +	spin_unlock_irqrestore(&dev->condlock, flags);
> > +	dev->ctx[ctx->num] = ctx;
> > +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> > +		ctx->type = MFCINST_DECODER;
> > +		ctx->c_ops = &decoder_codec_ops;
> > +		/* Default format */
> > +		ctx->src_fmt = &formats[DEC_DEF_SRC_FMT];
> > +		ctx->dst_fmt = &formats[DEC_DEF_DST_FMT];
> > +	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
> > +		ctx->type = MFCINST_ENCODER;
> > +		ctx->c_ops = &encoder_codec_ops;
> > +		/* Default format */
> > +		ctx->src_fmt = &formats[ENC_DEF_SRC_FMT];
> > +		ctx->dst_fmt = &formats[ENC_DEF_DST_FMT];
> > +	} else {
> > +		ret = -ENOENT;
> > +		goto out_open;
> > +	}
> > +	ctx->inst_no = -1;
> > +	/* Load firmware if this is the first instance */
> > +	if (dev->num_inst == 1) {
> > +		dev->watchdog_timer.expires = jiffies +
> > +
> > 	msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
> > +		add_timer(&dev->watchdog_timer);
> > +
> > +		/* Load the FW */
> > +		ret = s5p_mfc_alloc_firmware(dev);
> > +		if (ret != 0)
> > +			goto out_open_2a;
> > +		ret = s5p_mfc_load_firmware(dev);
> > +		if (ret != 0)
> > +			goto out_open_2;
> > +		mfc_debug("Enabling clocks.\n");
> > +		clk_enable(dev->clock1);
> > +		clk_enable(dev->clock2);
> > +		/* Init the FW */
> > +		ret = s5p_mfc_init_hw(dev);
> > +		if (ret != 0)
> > +			goto out_open_3;
> > +	}
> > +
> > +	/* Init videobuf2 queue for CAPTURE */
> > +	q = &ctx->vq_dst;
> > +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	q->drv_priv = ctx;
> > +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> > +		q->io_modes = VB2_MMAP;
> > +		q->ops = &s5p_mfc_qops;
> > +	} else {
> > +		q->io_modes = VB2_MMAP | VB2_USERPTR;
> > +		q->ops = &s5p_mfc_enc_qops;
> > +	}
> > +	q->mem_ops = &vb2_cma_memops;
> > +	ret = vb2_queue_init(q);
> > +	if (ret) {
> > +		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
> > +		goto out_open_3;
> > +	}
> > +
> > +	/* Init videobuf2 queue for OUTPUT */
> > +	q = &ctx->vq_src;
> > +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	q->io_modes = VB2_MMAP;
> > +	q->drv_priv = ctx;
> > +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> > +		q->io_modes = VB2_MMAP;
> > +		q->ops = &s5p_mfc_qops;
> > +	} else {
> > +		q->io_modes = VB2_MMAP | VB2_USERPTR;
> > +		q->ops = &s5p_mfc_enc_qops;
> > +	}
> > +	q->mem_ops = &vb2_cma_memops;
> > +	ret = vb2_queue_init(q);
> > +	if (ret) {
> > +		mfc_err("Failed to initialize videobuf2 queue(output)\n");
> > +		goto out_open_3;
> > +	}
> > +	init_waitqueue_head(&ctx->queue);
> > +	mfc_debug("%s-- (via irq_cleanup_hw)\n", __func__);
> > +	return ret;
> > +	/* Deinit when failure occured */
> > +out_open_3:
> > +	if (dev->num_inst == 1) {
> > +		clk_disable(dev->clock1);
> > +		clk_disable(dev->clock2);
> > +		s5p_mfc_release_firmware(dev);
> > +	}
> > +out_open_2:
> > +	s5p_mfc_release_firmware(dev);
> > +out_open_2a:
> > +	dev->ctx[ctx->num] = 0;
> > +	kfree(ctx);
> > +	del_timer_sync(&dev->watchdog_timer);
> > +out_open:
> > +	dev->num_inst--;
> > +	mfc_debug_leave();
> > +	return ret;
> > +}
> 
> You had better use atomic operation for increment and decrement instead
> dev->num_inst++.

This is under the mfc_mutex lock (videobuf2) so no need to make it atomic.
 
> In my opinion -EBUSY is good for return value instead of -EAGAIN if
> ctx->num
> is exceed MFC_NUM_CONTEXTS.

Yes, I agree.
 
> In my opinion, " /* Load firmware if this is the first instance */" is
> not
> suitable comment.
> Because clk_enable is included in the conditional statements.

Again, this was modified by Jeongtae.

 
> How about exchange init videobuf2 sequence OUTPUT, CAPTURE ?
> Because OUTPUT is the source of device and CAPTURE is the destination
> of
> device.

No need. Everything is under the mfc_mutex. So either way it is ok.

> 
> > +/* MFC probe function */
> > +static int s5p_mfc_probe(struct platform_device *pdev)
> > +{
> > +	struct video_device *vfd;
> > +	struct resource *res;
> > +	int ret = -ENOENT;
> > +	size_t size;
> > +
> > +	pr_debug("%s++\n", __func__);
> > +	dev = kzalloc(sizeof *dev, GFP_KERNEL);
> > +	if (!dev) {
> > +		dev_err(&pdev->dev, "Not enough memory for MFC device.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	spin_lock_init(&dev->irqlock);
> > +	spin_lock_init(&dev->condlock);
> > +	dev_dbg(&pdev->dev, "Initialised spin lock\n");
> > +	dev->plat_dev = pdev;
> > +	if (!dev->plat_dev) {
> > +		dev_err(&pdev->dev, "No platform data specified\n");
> > +		ret = -ENODEV;
> > +		goto free_dev;
> > +	}
> > +	dev_dbg(&pdev->dev, "Getting clocks\n");
> > +	dev->clock1 = clk_get(&pdev->dev, "sclk_mfc");
> > +	dev->clock2 = clk_get(&pdev->dev, "mfc");
> > +	if (IS_ERR(dev->clock1) || IS_ERR(dev->clock2)) {
> > +		dev_err(&pdev->dev, "failed to get mfc clock source\n");
> > +		goto free_clk;
> > +	}
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (res == NULL) {
> > +		dev_err(&pdev->dev, "failed to get memory region
> resource.\n");
> > +		ret = -ENOENT;
> > +		goto probe_out1;
> > +	}
> > +	size = (res->end - res->start) + 1;
> > +	dev->mfc_mem = request_mem_region(res->start, size, pdev->name);
> > +	if (dev->mfc_mem == NULL) {
> > +		dev_err(&pdev->dev, "failed to get memory region.\n");
> > +		ret = -ENOENT;
> > +		goto probe_out2;
> > +	}
> > +	dev->base_virt_addr = ioremap(dev->mfc_mem->start,
> > +			      dev->mfc_mem->end - dev->mfc_mem->start + 1);
> > +	if (dev->base_virt_addr == NULL) {
> > +		dev_err(&pdev->dev, "failed to ioremap address region.\n");
> > +		ret = -ENOENT;
> > +		goto probe_out3;
> > +	}
> > +	dev->regs_base = dev->base_virt_addr;
> > +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +	if (res == NULL) {
> > +		dev_err(&pdev->dev, "failed to get irq resource.\n");
> > +		ret = -ENOENT;
> > +		goto probe_out4;
> > +	}
> > +	dev->irq = res->start;
> > +	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev-
> >name,
> > +
> > 	dev);
> > +	if (ret != 0) {
> > +		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
> > +		goto probe_out5;
> > +	}
> > +	dev->mfc_mutex = kmalloc(sizeof(struct mutex), GFP_KERNEL);
> > +	if (dev->mfc_mutex == NULL) {
> > +		dev_err(&pdev->dev, "Memory allocation failed\n");
> > +		ret = -ENOMEM;
> > +		goto probe_out6;
> > +	}
> > +	mutex_init(dev->mfc_mutex);
> > +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +	if (ret)
> > +		goto probe_out7;
> > +	init_waitqueue_head(&dev->queue);
> > +
> > +	/* decoder */
> > +	vfd = video_device_alloc();
> > +	if (!vfd) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to allocate video
> device\n");
> > +		ret = -ENOMEM;
> > +		goto unreg_dev;
> > +	}
> > +	*vfd = s5p_mfc_videodev;
> > +	vfd->lock = dev->mfc_mutex;
> > +	vfd->v4l2_dev = &dev->v4l2_dev;
> > +	snprintf(vfd->name, sizeof(vfd->name), "%s",
> s5p_mfc_videodev.name);
> > +
> > +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	if (ret) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to register video
> device\n");
> > +		video_device_release(vfd);
> > +		goto rel_vdev_dec;
> > +	}
> > +	v4l2_info(&dev->v4l2_dev,
> > +			"MFC decoder device registered as /dev/video%d\n",
> > +			vfd->num);
> > +
> > +	dev->vfd_dec = vfd;
> > +
> > +	/* encoder */
> > +	vfd = video_device_alloc();
> > +	if (!vfd) {
> > +		v4l2_err(&dev->v4l2_dev,
> > +				"Failed to allocate video device\n");
> > +		ret = -ENOMEM;
> > +		goto unreg_vdev_dec;
> > +	}
> > +	*vfd = s5p_mfc_enc_videodev;
> > +	vfd->lock = dev->mfc_mutex;
> > +	vfd->v4l2_dev = &dev->v4l2_dev;
> > +	snprintf(vfd->name, sizeof(vfd->name), "%s",
> > s5p_mfc_enc_videodev.name);
> > +
> > +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	if (ret) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to register video
> device\n");
> > +		video_device_release(vfd);
> > +		goto rel_vdev_enc;
> > +	}
> > +	v4l2_info(&dev->v4l2_dev,
> > +			"MFC encoder device registered as /dev/video%d\n",
> > +			vfd->num);
> > +
> > +	dev->vfd_enc = vfd;
> > +
> > +	video_set_drvdata(vfd, dev);
> > +
> > +	platform_set_drvdata(pdev, dev);
> > +	dev->hw_lock = 0;
> > +	dev->watchdog_workqueue = create_singlethread_workqueue("s5p-
> mfc");
> > +	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
> > +	atomic_set(&dev->watchdog_cnt, 0);
> > +	init_timer(&dev->watchdog_timer);
> > +	dev->watchdog_timer.data = 0;
> > +	dev->watchdog_timer.function = s5p_mfc_watchdog;
> > +
> > +	dev->alloc_ctx = vb2_cma_init_multi(&pdev->dev,
> > MFC_CMA_ALLOC_CTX_NUM,
> > +					s5p_mem_types,
> > s5p_mem_alignments);
> > +	if (IS_ERR(dev->alloc_ctx)) {
> > +		mfc_err("Couldn't prepare allocator ctx.\n");
> > +		ret = PTR_ERR(dev->alloc_ctx);
> > +		goto alloc_ctx_fail;
> > +	}
> > +
> > +	pr_debug("%s--\n", __func__);
> > +	return 0;
> > +
> > +/* Deinit MFC if probe had failed */
> > +alloc_ctx_fail:
> > +	video_unregister_device(dev->vfd_enc);
> > +rel_vdev_enc:
> > +	video_device_release(dev->vfd_enc);
> > +unreg_vdev_dec:
> > +	video_unregister_device(dev->vfd_dec);
> > +rel_vdev_dec:
> > +	video_device_release(dev->vfd_dec);
> > +unreg_dev:
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +probe_out7:
> > +	if (dev->mfc_mutex) {
> > +		mutex_destroy(dev->mfc_mutex);
> > +		kfree(dev->mfc_mutex);
> > +	}
> > +probe_out6:
> > +	free_irq(dev->irq, dev);
> > +probe_out5:
> > +probe_out4:
> > +	iounmap(dev->base_virt_addr);
> > +	dev->base_virt_addr = NULL;
> > +probe_out3:
> > +	release_resource(dev->mfc_mem);
> > +	kfree(dev->mfc_mem);
> > +probe_out2:
> > +probe_out1:
> > +	clk_put(dev->clock1);
> > +	clk_put(dev->clock2);
> > +free_clk:
> > +
> > +free_dev:
> > +	kfree(dev);
> > +	pr_debug("%s-- with error\n", __func__);
> > +	return ret;
> > +}
> > +
> 
> What's the diff btw dev->regs_base and dev->base_virt_addr ?

None. You're right. Will fix it.

> In your implementation I cannot find video_get_drvdata.
> Is video_set_drvdata needed ?

I will publish a version without the global variable.

> 
> <snip>
> 
> > +#define MFC_NUM_CONTEXTS	4
> 
> How about use MFC_NUM_INSTANT instead MFC_NUM_CONTEXTS ?
> Because too many terms can make confusion.

An instance means an MFC HW instance. Context is used for each open file
handle.

> <snip>
> 
> > +/**
> > + * struct s5p_mfc_buf - MFC buffer
> > + *
> > + */
> > +struct s5p_mfc_buf {
> > +	struct list_head list;
> > +	struct vb2_buffer *b;
> > +	union {
> > +		struct {
> > +			size_t luma;
> > +			size_t chroma;
> > +		} raw;
> > +		size_t stream;
> > +	} paddr;
> > +};
> 
> How about use cookie instead paddr ?
>

I am not so sure about using this name, either way I can change it in the
new version. 

> 
> <snip>
> 
> > +/**
> > + * struct s5p_mfc_ctx - This struct contains the instance context
> > + */
> > +struct s5p_mfc_ctx {
> > +	struct s5p_mfc_dev *dev;
> > +	int num;
> > +
> > +	int int_cond;
> > +	int int_type;
> > +	unsigned int int_err;
> > +	wait_queue_head_t queue;
> > +
> > +	struct s5p_mfc_fmt *src_fmt;
> > +	struct s5p_mfc_fmt *dst_fmt;
> > +
> > +	struct vb2_queue vq_src;
> > +	struct vb2_queue vq_dst;
> > +
> > +	struct list_head src_queue;
> > +	struct list_head dst_queue;
> > +
> > +	unsigned int src_queue_cnt;
> > +	unsigned int dst_queue_cnt;
> > +
> > +	enum s5p_mfc_inst_type type;
> > +	enum s5p_mfc_inst_state state;
> > +	int inst_no;
> > +
> > +	/* Decoder parameters */
> > +	int img_width;
> > +	int img_height;
> > +	int buf_width;
> > +	int buf_height;
> > +	int dpb_count;
> > +	int total_dpb_count;
> > +
> > +	int luma_size;
> > +	int chroma_size;
> > +	int mv_size;
> > +
> > +	unsigned long consumed_stream;
> > +	int slice_interface;
> > +
> > +	/* Buffers */
> > +	void *port_a_buf;
> > +	size_t port_a_phys;
> > +	size_t port_a_size;
> > +
> > +	void *port_b_buf;
> > +	size_t port_b_phys;
> > +	size_t port_b_size;
> > +
> > +
> > +	enum s5p_mfc_queue_state capture_state;
> > +	enum s5p_mfc_queue_state output_state;
> > +
> > +	struct s5p_mfc_buf src_bufs[MFC_MAX_BUFFERS];
> > +	int src_bufs_cnt;
> > +	struct s5p_mfc_buf dst_bufs[MFC_MAX_BUFFERS];
> > +	int dst_bufs_cnt;
> > +
> > +	unsigned int sequence;
> > +	unsigned long dec_dst_flag;
> > +	size_t dec_src_buf_size;
> > +
> > +	/* Control values */
> > +	int codec_mode;
> > +	__u32 pix_format;
> > +	int loop_filter_mpeg4;
> > +	int display_delay;
> > +
> > +	/* Buffers */
> > +	void *instance_buf;
> > +	size_t instance_phys;
> > +	size_t instance_size;
> > +
> > +	void *desc_buf;
> > +	size_t desc_phys;
> > +
> > +	void *shared_buf;
> > +	size_t shared_phys;
> > +	void *shared_virt;
> > +
> > +	/* Encoder parameters */
> > +	struct s5p_mfc_enc_params enc_params;
> > +
> > +	size_t enc_dst_buf_size;
> > +
> > +	int frame_count;
> > +	enum v4l2_codec_mfc5x_enc_frame_type frame_type;
> > +	enum v4l2_codec_mfc5x_enc_force_frame_type force_frame_type;
> > +
> > +	struct s5p_mfc_codec_ops *c_ops;
> > +};
> > +
> 
> Data structure is too big. How about split it like as below ?
> struct s5p_mfc_ctx {
> 	struct s5p_mfc_dec *dec;
> 	struct s5p_mfc_dec *enc;
> 	....
> };
> 
> Or like this:
> 
> struct s5p_mfc_ctx {
> 	union {
> 		struct s5p_mfc_dec *dec;
> 		struct s5p_mfc_dec *enc;
> 	};
> 	....
> };
> 
> What's the difference btw num and inst_no ?
> It looks very similar.

The inst_no is the number of hardware instance in MFC. Num on the other
hand is the number of context used by an open file handle.

Splitting the structure to two separate ones is a good idea.

> 
> And how about define common data structure for source, destination
> about
> size, format ...  like mfc_frame ?
> It can make simplify the structure.
> 
> <snip>
> 
> > +static struct v4l2_queryctrl s5p_mfc_ctrls[] = {
> > +/* For decoding */
> > +	{
> > +		.id = V4L2_CID_CODEC_DISPLAY_DELAY,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "",
> > +		.minimum = 0,
> > +		.maximum = 16383,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "Mpeg4 Loop Filter Enable",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_CODEC_SLICE_INTERFACE,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "Slice Interface Enable",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +/* For encoding */
> > +	{
> > +		.id = V4L2_CID_CODEC_MFC51_ENC_GOP_SIZE,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "The period of intra frame",
> > +		.minimum = 0,
> > +		.maximum = (1 << 16) - 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> 
> You had better use control-framework.

I have some doubts about the point of using the control-framework
in MFC. I have expressed them in my previous email (in reply to
comments by Hans).

> 
> > +/* Allocate firmware */
> > +int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
> > +{
> > +	int err;
> > +	struct cma_info mem_info_f, mem_info_a, mem_info_b;
> 
> How about exchange above two lines ?
> 

Ok.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

