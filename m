Return-path: <mchehab@gaivota>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1162 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0LVNBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 08:01:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jeongtae Park <jtp.park@samsung.com>
Subject: Re: [PATCH 7/9] media: MFC: Add MFC v5.1 V4L2 driver
Date: Wed, 22 Dec 2010 14:01:08 +0100
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org, jonghun.han@samsung.com
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com> <1293018885-15239-7-git-send-email-jtp.park@samsung.com> <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221401.09078.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A quick review:

On Wednesday, December 22, 2010 12:54:43 Jeongtae Park wrote:
> Multi Format Codec v5.1 is a module available on S5PC110 and S5PC210
> Samsung SoCs. Hardware is capable of handling a range of video codecs
> and this driver provides V4L2 interface for video decoding & encoding.
> 
> Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> ---
>  drivers/media/video/Kconfig                  |    8 +
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/s5p-mfc/Makefile         |    3 +
>  drivers/media/video/s5p-mfc/regs-mfc5.h      |  356 +++
>  drivers/media/video/s5p-mfc/s5p_mfc.c        | 3237 ++++++++++++++++++++++++++

Over 3000 lines?! I strongly suggest splitting up this source, it's way too
big.

>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  333 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  622 +++++
>  drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   55 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   94 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
>  drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   42 +
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1349 +++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  147 ++
>  13 files changed, 6273 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/Makefile
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
> 

<snip>

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
> new file mode 100644
> index 0000000..2653864
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -0,0 +1,3237 @@

<snip>

> +/* Get format */
> +static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +
> +	mfc_debug_enter();
> +	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	    ctx->state == MFCINST_GOT_INST) {
> +		/* If the MFC is parsing the header,
> +		 * so wait until it is finished */
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
> +									1);
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	    ctx->state >= MFCINST_HEAD_PARSED &&
> +	    ctx->state <= MFCINST_ABORT) {
> +		/* This is run on CAPTURE (deocde output) */
> +		/* Width and height are set to the dimensions
> +		   of the movie, the buffer is bigger and
> +		   further processing stages should crop to this
> +		   rectangle. */
> +		f->fmt.pix_mp.width = ctx->buf_width;

Create a temp variable pointing to &f->fmt.pix_mp and use that in this and
the next function. It makes it easier to read.

> +		f->fmt.pix_mp.height = ctx->buf_height;
> +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> +		f->fmt.pix_mp.num_planes = 2;
> +		/* Set pixelformat to the format in which MFC
> +		   outputs the decoded frame */
> +		f->fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->buf_width;
> +		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->luma_size;
> +		f->fmt.pix_mp.plane_fmt[1].bytesperline = ctx->buf_width;
> +		f->fmt.pix_mp.plane_fmt[1].sizeimage = ctx->chroma_size;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		/* This is run on OUTPUT
> +		   The buffer contains compressed image
> +		   so width and height have no meaning */
> +		f->fmt.pix_mp.width = 1;
> +		f->fmt.pix_mp.height = 1;
> +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->dec_src_buf_size;
> +		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->dec_src_buf_size;
> +		f->fmt.pix_mp.pixelformat = ctx->src_fmt->fourcc;
> +		f->fmt.pix_mp.num_planes = ctx->src_fmt->num_planes;
> +	} else {
> +		mfc_err("Format could not be read\n");
> +		mfc_debug("%s-- with error\n", __func__);
> +		return -EINVAL;
> +	}
> +	mfc_debug_leave();
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +
> +	mfc_debug_enter();
> +
> +	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		/* This is run on OUTPUT (encoder dest) */
> +		f->fmt.pix_mp.width = 1;
> +		f->fmt.pix_mp.height = 1;
> +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> +		f->fmt.pix_mp.pixelformat = ctx->dst_fmt->fourcc;
> +		f->fmt.pix_mp.num_planes = ctx->dst_fmt->num_planes;
> +
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->enc_dst_buf_size;
> +		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->enc_dst_buf_size;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		/* This is run on CAPTURE (encoder src) */
> +		f->fmt.pix_mp.width = ctx->img_width;
> +		f->fmt.pix_mp.height = ctx->img_height;
> +		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
> +		f->fmt.pix_mp.pixelformat = ctx->src_fmt->fourcc;
> +		f->fmt.pix_mp.num_planes = ctx->src_fmt->num_planes;
> +
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->buf_width;
> +		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->luma_size;
> +		f->fmt.pix_mp.plane_fmt[1].bytesperline = ctx->buf_width;
> +		f->fmt.pix_mp.plane_fmt[1].sizeimage = ctx->chroma_size;
> +	} else {
> +		mfc_err("invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	mfc_debug_leave();
> +
> +	return 0;
> +}
> +
> +/* Find selected format description */
> +static struct s5p_mfc_fmt *find_format(struct v4l2_format *f, unsigned int t)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (formats[i].fourcc == f->fmt.pix_mp.pixelformat &&
> +		    formats[i].type == t)
> +			return (struct s5p_mfc_fmt *)&formats[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Try format */
> +static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_fmt *fmt;
> +
> +	mfc_debug("Type is %d\n", f->type);
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		mfc_err("Currently only decoding is supported.\n");
> +		return -EINVAL;
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {

Invert this test and return 0, then the rest can be indented one level to the
left, making it easier to read.

> +		fmt = find_format(f, MFC_FMT_DEC);
> +		if (!fmt) {
> +			mfc_err("Unsupported format.\n");
> +			return -EINVAL;
> +		}
> +		if (f->fmt.pix_mp.plane_fmt[0].sizeimage == 0) {
> +			mfc_err("Application is required to "
> +				"specify input buffer size (via sizeimage)\n");
> +			return -EINVAL;
> +		}
> +		/* As this buffer will contain compressed data, the size is set
> +		 * to the maximum size.
> +		 * Width and height are left intact as they may be relevant for
> +		 * DivX 3.11 decoding. */
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline =
> +					f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +	}
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_fmt *fmt;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_ENC);
> +		if (!fmt) {
> +			mfc_err("failed to try output format\n");
> +			return -EINVAL;
> +		}
> +
> +		if (f->fmt.pix_mp.plane_fmt[0].sizeimage == 0) {
> +			mfc_err("must be set encoding output size\n");
> +			return -EINVAL;
> +		}
> +
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline =
> +			f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_RAW);
> +		if (!fmt) {
> +			mfc_err("failed to try output format\n");
> +			return -EINVAL;
> +		}
> +
> +		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
> +			mfc_err("failed to try output format\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		mfc_err("invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Set format */
> +static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	unsigned long flags;
> +	int ret = 0;
> +	struct s5p_mfc_fmt *fmt;
> +
> +	mfc_debug_enter();
> +	ret = vidioc_try_fmt(file, priv, f);
> +	if (ret)
> +		return ret;
> +	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
> +		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {

Same trick can be done here and elsewhere as well. The basic idea is to
do the short tests first, then the main work can be done without it
being inside a huge 'if' statement.

> +		fmt = find_format(f, MFC_FMT_DEC);
> +		if (!fmt || fmt->codec_mode == MFC_FORMATS_NO_CODEC) {
> +			mfc_err("Unknown codec.\n");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		ctx->src_fmt = fmt;
> +		ctx->codec_mode = fmt->codec_mode;
> +		mfc_debug("The codec number is: %d\n", ctx->codec_mode);
> +		ctx->pix_format = f->fmt.pix_mp.pixelformat;
> +		if (f->fmt.pix_mp.pixelformat != V4L2_PIX_FMT_DIVX3) {
> +			f->fmt.pix_mp.height = 1;
> +			f->fmt.pix_mp.width = 1;
> +		} else {
> +			ctx->img_height = f->fmt.pix_mp.height;
> +			ctx->img_width = f->fmt.pix_mp.width;
> +		}
> +		mfc_debug("s_fmt w/h: %dx%d, ctx: %dx%d\n", f->fmt.pix_mp.width,
> +			f->fmt.pix_mp.height, ctx->img_width, ctx->img_height);
> +		ctx->dec_src_buf_size =	f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
> +		ctx->state = MFCINST_INIT;
> +		ctx->dst_bufs_cnt = 0;
> +		ctx->src_bufs_cnt = 0;
> +		ctx->capture_state = QUEUE_FREE;
> +		ctx->output_state = QUEUE_FREE;
> +		s5p_mfc_alloc_instance_buffer(ctx);
> +		s5p_mfc_alloc_dec_temp_buffers(ctx);
> +		spin_lock_irqsave(&dev->condlock, flags);
> +		set_bit(ctx->num, &dev->ctx_work_bits);
> +		spin_unlock_irqrestore(&dev->condlock, flags);
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_try_run();
> +		if (s5p_mfc_wait_for_done_ctx(ctx,
> +				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
> +			/* Error or timeout */
> +			mfc_err("Error getting instance from hardware.\n");
> +			s5p_mfc_release_instance_buffer(ctx);
> +			s5p_mfc_release_dec_desc_buffer(ctx);
> +			ret = -EIO;
> +			goto out;
> +		}
> +		mfc_debug("Got instance number: %d\n", ctx->inst_no);
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		mfc_err("Currently only decoding is supported.\n");
> +		ret = -EINVAL;
> +	}
> +out:
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +static int vidioc_s_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	unsigned long flags;
> +	int ret = 0;
> +	struct s5p_mfc_fmt *fmt;
> +
> +	mfc_debug_enter();
> +
> +	ret = vidioc_try_fmt_enc(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
> +		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_ENC);
> +		if (!fmt) {
> +			mfc_err("failed to set capture format\n");
> +			return -EINVAL;
> +		}
> +		ctx->state = MFCINST_INIT;
> +
> +		ctx->dst_fmt = fmt;
> +		ctx->codec_mode = ctx->dst_fmt->codec_mode;
> +		mfc_debug("codec number: %d\n", ctx->dst_fmt->codec_mode);
> +
> +		ctx->enc_dst_buf_size =	f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
> +
> +		ctx->dst_bufs_cnt = 0;
> +		ctx->capture_state = QUEUE_FREE;
> +
> +		s5p_mfc_alloc_instance_buffer(ctx);
> +
> +		spin_lock_irqsave(&dev->condlock, flags);
> +		set_bit(ctx->num, &dev->ctx_work_bits);
> +		spin_unlock_irqrestore(&dev->condlock, flags);
> +
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_try_run();
> +		if (s5p_mfc_wait_for_done_ctx(ctx, \
> +				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
> +			/* Error or timeout */
> +			mfc_err("Error getting instance from hardware.\n");
> +			s5p_mfc_release_instance_buffer(ctx);
> +			ret = -EIO;
> +			goto out;
> +		}
> +		mfc_debug("Got instance number: %d\n", ctx->inst_no);
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_RAW);
> +		if (!fmt) {
> +			mfc_err("failed to set output format\n");
> +			return -EINVAL;
> +		}
> +
> +		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
> +			mfc_err("failed to set output format\n");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		ctx->src_fmt = fmt;
> +		ctx->img_width = f->fmt.pix_mp.width;
> +		ctx->img_height = f->fmt.pix_mp.height;
> +
> +		mfc_debug("codec number: %d\n", ctx->src_fmt->codec_mode);
> +		mfc_debug("fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
> +			f->fmt.pix_mp.width, f->fmt.pix_mp.height,
> +			ctx->img_width, ctx->img_height);
> +
> +		ctx->buf_width = f->fmt.pix_mp.plane_fmt[0].bytesperline;
> +		ctx->luma_size = f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +		ctx->buf_width = f->fmt.pix_mp.plane_fmt[1].bytesperline;
> +		ctx->chroma_size = f->fmt.pix_mp.plane_fmt[1].sizeimage;
> +
> +		ctx->src_bufs_cnt = 0;
> +		ctx->output_state = QUEUE_FREE;
> +	} else {
> +		mfc_err("invalid buf type\n");
> +		return -EINVAL;
> +	}
> +out:
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +/* Reqeust buffers */
> +static int vidioc_reqbufs(struct file *file, void *priv,
> +					  struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	mfc_debug_enter();
> +	mfc_debug("Memory type: %d\n", reqbufs->memory);
> +	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
> +		mfc_err("Only V4L2_MEMORY_MAP is supported.\n");
> +		return -EINVAL;
> +	}
> +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		/* Can only request buffers after an instance has been opened.*/
> +		if (ctx->state == MFCINST_GOT_INST) {
> +			/* Decoding */
> +			if (ctx->output_state != QUEUE_FREE) {
> +				mfc_err("Bufs have already been requested.\n");
> +				return -EINVAL;
> +			}
> +			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
> +			if (ret) {
> +				mfc_err("vb2_reqbufs on output failed.\n");
> +				return ret;
> +			}
> +			mfc_debug("vb2_reqbufs: %d\n", ret);
> +			ctx->output_state = QUEUE_BUFS_REQUESTED;
> +		}
> +	}
> +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		if (ctx->capture_state != QUEUE_FREE) {
> +			mfc_err("Bufs have already been requested.\n");
> +			return -EINVAL;
> +		}
> +		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> +		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +		if (ret) {
> +			mfc_err("vb2_reqbufs on capture failed.\n");
> +			return ret;
> +		}
> +		if (reqbufs->count < ctx->dpb_count) {
> +			mfc_err("Not enough buffers allocated.\n");
> +			reqbufs->count = 0;
> +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +			return -ENOMEM;
> +		}
> +		ctx->total_dpb_count = reqbufs->count;
> +		ret = s5p_mfc_alloc_codec_buffers(ctx);
> +		if (ret) {
> +			mfc_err("Failed to allocate decoding buffers.\n");
> +			reqbufs->count = 0;
> +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +			return -ENOMEM;
> +		}
> +		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
> +			ctx->capture_state = QUEUE_BUFS_MMAPED;
> +		} else {
> +			mfc_err("Not all buffers passed to buf_init.\n");
> +			reqbufs->count = 0;
> +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +			s5p_mfc_release_codec_buffers(ctx);
> +			return -ENOMEM;
> +		}
> +		if (s5p_mfc_ctx_ready(ctx)) {
> +			spin_lock_irqsave(&dev->condlock, flags);
> +			set_bit(ctx->num, &dev->ctx_work_bits);
> +			spin_unlock_irqrestore(&dev->condlock, flags);
> +		}
> +		s5p_mfc_try_run();
> +		s5p_mfc_wait_for_done_ctx(ctx,
> +					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 1);
> +	}
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +static int vidioc_reqbufs_enc(struct file *file, void *priv,
> +					  struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret = 0;
> +
> +	mfc_debug_enter();
> +
> +	mfc_debug("type: %d\n", reqbufs->memory);
> +
> +	/* if memory is not mmp or userptr return error */
> +	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
> +		(reqbufs->memory != V4L2_MEMORY_USERPTR))
> +		return -EINVAL;
> +
> +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		if (ctx->capture_state != QUEUE_FREE) {
> +			mfc_err("invalid capture state: %d\n", ctx->capture_state);
> +			return -EINVAL;
> +		}
> +
> +		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +		if (ret != 0) {
> +			mfc_err("error in vb2_reqbufs() for E(D)\n");
> +			return ret;
> +		}
> +		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> +
> +		ret = s5p_mfc_alloc_codec_buffers(ctx);
> +		if (ret) {
> +			mfc_err("Failed to allocate encoding buffers.\n");
> +			reqbufs->count = 0;
> +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +			return -ENOMEM;
> +		}
> +	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		if (ctx->output_state != QUEUE_FREE) {
> +			mfc_err("invalid output state: %d\n", ctx->output_state);
> +			return -EINVAL;
> +		}
> +
> +		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
> +		if (ret != 0) {
> +			mfc_err("error in vb2_reqbufs() for E(S)\n");
> +			return ret;
> +		}
> +		ctx->output_state = QUEUE_BUFS_REQUESTED;
> +	} else {
> +		mfc_err("invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	mfc_debug("--\n");
> +
> +	return ret;
> +}
> +
> +/* Query buffer */
> +static int vidioc_querybuf(struct file *file, void *priv,
> +						   struct v4l2_buffer *buf)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret;
> +	int i;
> +
> +	mfc_debug_enter();
> +	if (buf->memory != V4L2_MEMORY_MMAP) {
> +		mfc_err("Only mmaped buffers can be used.\n");
> +		return -EINVAL;
> +	}
> +	mfc_debug("State: %d, buf->type: %d\n", ctx->state, buf->type);
> +	if (ctx->state == MFCINST_GOT_INST &&
> +			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret = vb2_querybuf(&ctx->vq_src, buf);
> +	} else if (ctx->state == MFCINST_RUNNING &&
> +			buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret = vb2_querybuf(&ctx->vq_dst, buf);
> +		for (i = 0; i < buf->length; i++)
> +			buf->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
> +	} else {
> +		mfc_err("vidioc_querybuf called in an inappropriate state.\n");
> +		ret = -EINVAL;
> +	}
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +static int vidioc_querybuf_enc(struct file *file, void *priv,
> +						   struct v4l2_buffer *buf)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret = 0;
> +
> +	mfc_debug_enter();
> +
> +	mfc_debug("type: %d\n", buf->memory);
> +
> +	/* if memory is not mmp or userptr return error */
> +	if ((buf->memory != V4L2_MEMORY_MMAP) &&
> +		(buf->memory != V4L2_MEMORY_USERPTR))
> +		return -EINVAL;
> +
> +	mfc_debug("state: %d, buf->type: %d\n", ctx->state, buf->type);
> +
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		if (ctx->state != MFCINST_GOT_INST) {
> +			mfc_err("invalid context state: %d\n", ctx->state);
> +			return -EINVAL;
> +		}
> +
> +		ret = vb2_querybuf(&ctx->vq_dst, buf);
> +		if (ret != 0) {
> +			mfc_err("error in vb2_querybuf() for E(D)\n");
> +			return ret;
> +		}
> +
> +		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
> +	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret = vb2_querybuf(&ctx->vq_src, buf);
> +		if (ret != 0) {
> +			mfc_err("error in vb2_querybuf() for E(S)\n");
> +			return ret;
> +		}
> +	} else {
> +		mfc_err("invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	mfc_debug_leave();
> +
> +	return ret;
> +}
> +
> +/* Queue a buffer */
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +
> +	mfc_debug_enter();
> +	mfc_debug("Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
> +	if (ctx->state == MFCINST_ERROR) {
> +		mfc_err("Call on QBUF after unrecoverable error.\n");
> +		return -EIO;
> +	}
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return vb2_qbuf(&ctx->vq_src, buf);
> +	else
> +		return vb2_qbuf(&ctx->vq_dst, buf);
> +	mfc_debug_leave();
> +	return -EINVAL;
> +}
> +
> +/* Dequeue a buffer */
> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret;
> +
> +	mfc_debug_enter();
> +	mfc_debug("Addr: %p %p %p Type: %d\n", &ctx->vq_src, buf, buf->m.planes,
> +								buf->type);
> +	if (ctx->state == MFCINST_ERROR) {
> +		mfc_err("Call on DQBUF after unrecoverable error.\n");
> +		return -EIO;
> +	}
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
> +	else
> +		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +/* Stream on */
> +static int vidioc_streamon(struct file *file, void *priv,
> +			   enum v4l2_buf_type type)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret = -EINVAL;
> +
> +	mfc_debug_enter();
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		ret = vb2_streamon(&ctx->vq_src, type);
> +	else
> +		ret = vb2_streamon(&ctx->vq_dst, type);
> +	mfc_debug("ctx->src_queue_cnt = %d ctx->state = %d "
> +		  "ctx->dst_queue_cnt = %d ctx->dpb_count = %d\n",
> +		  ctx->src_queue_cnt, ctx->state, ctx->dst_queue_cnt,
> +		  ctx->dpb_count);
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +/* Stream off, which equals to a pause */
> +static int vidioc_streamoff(struct file *file, void *priv,
> +			    enum v4l2_buf_type type)
> +{
> +	struct s5p_mfc_ctx *ctx = priv;
> +	int ret;
> +
> +	mfc_debug_enter();
> +	ret = -EINVAL;
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		ret = vb2_streamoff(&ctx->vq_src, type);
> +	else
> +		ret = vb2_streamoff(&ctx->vq_dst, type);
> +	mfc_debug_leave();
> +	return ret;
> +}
> +
> +/* Query a ctrl */
> +static int vidioc_queryctrl(struct file *file, void *priv,
> +			    struct v4l2_queryctrl *qc)

Use the new control framework. Much simpler. Particularly if you have controls
that have dependencies on one another.

> +{
> +	struct v4l2_queryctrl *c;
> +
> +	c = get_ctrl(qc->id);
> +	if (!c)
> +		return -EINVAL;
> +	*qc = *c;
> +	return 0;
> +}

<snip>

> +/* MFC probe function */
> +static int s5p_mfc_probe(struct platform_device *pdev)
> +{
> +	struct video_device *vfd;
> +	struct resource *res;
> +	int ret = -ENOENT;
> +	size_t size;
> +
> +	pr_debug("%s++\n", __func__);
> +	dev = kzalloc(sizeof *dev, GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(&pdev->dev, "Not enough memory for MFC device.\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&dev->irqlock);
> +	spin_lock_init(&dev->condlock);
> +	dev_dbg(&pdev->dev, "Initialised spin lock\n");
> +	dev->plat_dev = pdev;
> +	if (!dev->plat_dev) {
> +		dev_err(&pdev->dev, "No platform data specified\n");
> +		ret = -ENODEV;
> +		goto free_dev;
> +	}
> +	dev_dbg(&pdev->dev, "Getting clocks\n");
> +	dev->clock1 = clk_get(&pdev->dev, "sclk_mfc");
> +	dev->clock2 = clk_get(&pdev->dev, "mfc");
> +	if (IS_ERR(dev->clock1) || IS_ERR(dev->clock2)) {
> +		dev_err(&pdev->dev, "failed to get mfc clock source\n");
> +		goto free_clk;
> +	}
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource.\n");
> +		ret = -ENOENT;
> +		goto probe_out1;
> +	}
> +	size = (res->end - res->start) + 1;
> +	dev->mfc_mem = request_mem_region(res->start, size, pdev->name);
> +	if (dev->mfc_mem == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region.\n");
> +		ret = -ENOENT;
> +		goto probe_out2;
> +	}
> +	dev->base_virt_addr = ioremap(dev->mfc_mem->start,
> +			      dev->mfc_mem->end - dev->mfc_mem->start + 1);
> +	if (dev->base_virt_addr == NULL) {
> +		dev_err(&pdev->dev, "failed to ioremap address region.\n");
> +		ret = -ENOENT;
> +		goto probe_out3;
> +	}
> +	dev->regs_base = dev->base_virt_addr;
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get irq resource.\n");
> +		ret = -ENOENT;
> +		goto probe_out4;
> +	}
> +	dev->irq = res->start;
> +	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev->name,
> +									dev);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
> +		goto probe_out5;
> +	}
> +	dev->mfc_mutex = kmalloc(sizeof(struct mutex), GFP_KERNEL);

Huh? Why not embed the mutex in dev?

> +	if (dev->mfc_mutex == NULL) {
> +		dev_err(&pdev->dev, "Memory allocation failed\n");
> +		ret = -ENOMEM;
> +		goto probe_out6;
> +	}
> +	mutex_init(dev->mfc_mutex);
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret)
> +		goto probe_out7;
> +	init_waitqueue_head(&dev->queue);
> +
> +	/* decoder */
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto unreg_dev;
> +	}
> +	*vfd = s5p_mfc_videodev;
> +	vfd->lock = dev->mfc_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_videodev.name);
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		video_device_release(vfd);
> +		goto rel_vdev_dec;
> +	}
> +	v4l2_info(&dev->v4l2_dev,
> +			"MFC decoder device registered as /dev/video%d\n",
> +			vfd->num);
> +
> +	dev->vfd_dec = vfd;
> +
> +	/* encoder */
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&dev->v4l2_dev,
> +				"Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto unreg_vdev_dec;
> +	}
> +	*vfd = s5p_mfc_enc_videodev;
> +	vfd->lock = dev->mfc_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_enc_videodev.name);
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);

This should be the very last action. As soon as this device is created apps
can start to use it, so all other initializations must be done before you do
this.

> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		video_device_release(vfd);
> +		goto rel_vdev_enc;
> +	}
> +	v4l2_info(&dev->v4l2_dev,
> +			"MFC encoder device registered as /dev/video%d\n",
> +			vfd->num);
> +
> +	dev->vfd_enc = vfd;
> +
> +	video_set_drvdata(vfd, dev);
> +
> +	platform_set_drvdata(pdev, dev);
> +	dev->hw_lock = 0;
> +	dev->watchdog_workqueue = create_singlethread_workqueue("s5p-mfc");
> +	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
> +	atomic_set(&dev->watchdog_cnt, 0);
> +	init_timer(&dev->watchdog_timer);
> +	dev->watchdog_timer.data = 0;
> +	dev->watchdog_timer.function = s5p_mfc_watchdog;
> +
> +	dev->alloc_ctx = vb2_cma_init_multi(&pdev->dev, MFC_CMA_ALLOC_CTX_NUM,
> +					s5p_mem_types, s5p_mem_alignments);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		mfc_err("Couldn't prepare allocator ctx.\n");
> +		ret = PTR_ERR(dev->alloc_ctx);
> +		goto alloc_ctx_fail;
> +	}
> +
> +	pr_debug("%s--\n", __func__);
> +	return 0;
> +
> +/* Deinit MFC if probe had failed */
> +alloc_ctx_fail:
> +	video_unregister_device(dev->vfd_enc);
> +rel_vdev_enc:
> +	video_device_release(dev->vfd_enc);
> +unreg_vdev_dec:
> +	video_unregister_device(dev->vfd_dec);
> +rel_vdev_dec:
> +	video_device_release(dev->vfd_dec);
> +unreg_dev:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +probe_out7:
> +	if (dev->mfc_mutex) {
> +		mutex_destroy(dev->mfc_mutex);
> +		kfree(dev->mfc_mutex);
> +	}
> +probe_out6:
> +	free_irq(dev->irq, dev);
> +probe_out5:
> +probe_out4:
> +	iounmap(dev->base_virt_addr);
> +	dev->base_virt_addr = NULL;
> +probe_out3:
> +	release_resource(dev->mfc_mem);
> +	kfree(dev->mfc_mem);
> +probe_out2:
> +probe_out1:
> +	clk_put(dev->clock1);
> +	clk_put(dev->clock2);
> +free_clk:
> +
> +free_dev:
> +	kfree(dev);
> +	pr_debug("%s-- with error\n", __func__);
> +	return ret;
> +}
> +
> +/* Remove the driver */
> +static int s5p_mfc_remove(struct platform_device *pdev)
> +{
> +	dev_dbg(&pdev->dev, "%s++\n", __func__);
> +	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
> +	del_timer_sync(&dev->watchdog_timer);
> +	flush_workqueue(dev->watchdog_workqueue);
> +	destroy_workqueue(dev->watchdog_workqueue);
> +	video_unregister_device(dev->vfd_enc);
> +	video_unregister_device(dev->vfd_dec);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	vb2_cma_cleanup_multi(dev->alloc_ctx);
> +	if (dev->mfc_mutex) {
> +		mutex_destroy(dev->mfc_mutex);
> +		kfree(dev->mfc_mutex);
> +	}
> +	mfc_debug("Will now deinit HW\n");
> +	s5p_mfc_deinit_hw(dev);
> +	free_irq(dev->irq, dev);
> +	iounmap(dev->base_virt_addr);
> +	if (dev->mfc_mem != NULL) {
> +		release_resource(dev->mfc_mem);
> +		kfree(dev->mfc_mem);
> +		dev->mfc_mem = NULL;
> +	}
> +	clk_put(dev->clock1);
> +	clk_put(dev->clock2);
> +	kfree(dev);
> +	dev_dbg(&pdev->dev, "%s--\n", __func__);
> +	return 0;
> +}
> +
> +static int s5p_mfc_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int s5p_mfc_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +/* Power management */
> +static const struct dev_pm_ops s5p_mfc_pm_ops = {
> +	.suspend = s5p_mfc_suspend,
> +	.resume = s5p_mfc_resume,
> +};
> +
> +static struct platform_driver s5p_mfc_pdrv = {
> +	.probe = s5p_mfc_probe,
> +	.remove = __devexit_p(s5p_mfc_remove),
> +	.driver = {
> +		   .name = S5P_MFC_NAME,
> +		   .owner = THIS_MODULE,
> +		   .pm = &s5p_mfc_pm_ops},
> +};
> +
> +static char banner[] __initdata =
> +			"S5P MFC V4L2 Driver, (c) 2010 Samsung Electronics\n";
> +
> +static int __init s5p_mfc_init(void)
> +{
> +	pr_info("%s", banner);
> +	if (platform_driver_register(&s5p_mfc_pdrv) != 0) {
> +		pr_err("Platform device registration failed..\n");
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static void __devexit s5p_mfc_exit(void)
> +{
> +	platform_driver_unregister(&s5p_mfc_pdrv);
> +}
> +
> +module_init(s5p_mfc_init);
> +module_exit(s5p_mfc_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> +MODULE_AUTHOR("Jeongtae Park <jtp.park@samsung.com>");

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
