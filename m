Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17408 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3C0LYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 07:24:12 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKB005IRH07FY60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Mar 2013 11:24:09 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MKB001YMH037XB0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Mar 2013 11:24:09 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>, sheu@google.com,
	arunkk.samsung@gmail.com
References: <1364282869-16682-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1364282869-16682-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v2] [media] s5p-mfc: Modify encoder buffer alloc sequence
Date: Wed, 27 Mar 2013 12:24:01 +0100
Message-id: <002901ce2add$9651df10$c2f59d30$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Tuesday, March 26, 2013 8:28 AM
> 
> MFC v6 needs minimum number of output buffers to be queued for encoder
> depending on the stream type and profile.
> For achieving this the sequence for allocating buffers at the encoder
> is modified similar to that of decoder.
> The new sequence is as follows:
> 
> 1) Set format on CAPTURE plane
> 2) REQBUF on CAPTURE
> 3) QBUFS and STREAMON on CAPTURE
> 4) G_CTRL to get minimum buffers for OUTPUT plane
> 5) REQBUF on OUTPUT with the minimum buffers given by driver

I don't like the idea of changing the encoding sequence. What if the old
applications rely on a particular sequence?

I see the problem you are addressing, but let's explore other options.
MFC v6 sets the minimum number of buffers needed after the header is
generated, v5 did not provide such information at all. 

Also using the variables dpb_count and state HEAD_PARSED seems odd. I guess
that you did reuse the existing variable and state. But the naming used now
is definitely misleading. DPB stands for decoded picture buffer.

I suggest adding a new variable epb_count, or changing dpb_count to pb_count
everywhere would be a good idea. Actually I like the latter more. In case of
HEAD_PARSED I suggest adding a HEAD_PRODUCED state.
 
> This also fixes the crash happeninig during multi instance encoder-
> decoder simultaneous run due to memory allocation happening from
> interrupt context.

Could you explain this problem more? What was the reason and how did you fix
it?

Also a small inline comment/question below.

> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
> Changes from v1
> - Corrected the commit message as pointed out by John Sheu.
>   http://www.spinics.net/lists/linux-media/msg61477.html
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   98
> +++++++++++++++++++----
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    7 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   95 +++++++++++++--
> -------
>  4 files changed, 147 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 4f6b553..46ca986 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -557,6 +557,16 @@ static struct mfc_control controls[] = {
>  		.step = 1,
>  		.default_value = 0,
>  	},
> +	{
> +		.id = V4L2_CID_MIN_BUFFERS_FOR_OUTPUT,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.name = "Minimum number of output bufs",
> +		.minimum = 1,
> +		.maximum = 32,
> +		.step = 1,
> +		.default_value = 1,
> +		.is_volatile = 1,
> +	},
>  };
> 
>  #define NUM_CTRLS ARRAY_SIZE(controls)
> @@ -661,18 +671,17 @@ static int enc_post_seq_start(struct s5p_mfc_ctx
> *ctx)
>  		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
>  		spin_unlock_irqrestore(&dev->irqlock, flags);
>  	}
> -	if (IS_MFCV6(dev)) {
> -		ctx->state = MFCINST_HEAD_PARSED; /* for INIT_BUFFER cmd */
> -	} else {
> +
> +	if (!IS_MFCV6(dev)) {
>  		ctx->state = MFCINST_RUNNING;
>  		if (s5p_mfc_ctx_ready(ctx))
>  			set_work_bit_irqsave(ctx);
>  		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> -	}
> -
> -	if (IS_MFCV6(dev))
> +	} else {
>  		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops,
>  				get_enc_dpb_count, dev);
> +		ctx->state = MFCINST_HEAD_PARSED;
> +	}
> 
>  	return 0;
>  }
> @@ -1055,15 +1064,13 @@ static int vidioc_reqbufs(struct file *file,
> void *priv,
>  		}
>  		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> 
> -		if (!IS_MFCV6(dev)) {
> -			ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
> -					alloc_codec_buffers, ctx);
> -			if (ret) {
> -				mfc_err("Failed to allocate encoding
> buffers\n");
> -				reqbufs->count = 0;
> -				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> -				return -ENOMEM;
> -			}
> +		ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
> +				alloc_codec_buffers, ctx);
> +		if (ret) {
> +			mfc_err("Failed to allocate encoding buffers\n");
> +			reqbufs->count = 0;
> +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +			return -ENOMEM;
>  		}
>  	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		if (ctx->output_state != QUEUE_FREE) { @@ -1071,12 +1078,35
> @@ static int vidioc_reqbufs(struct file *file, void *priv,
>  							ctx->output_state);
>  			return -EINVAL;
>  		}
> +
> +		if (IS_MFCV6(dev)) {
> +			if (!ctx->dpb_count) {
> +				mfc_err("Streamon on CAPTURE plane should
be\n"
> +						"done first\n");
> +				return -EINVAL;
> +			}
> +			/* Check for min encoder buffers */
> +			if (reqbufs->count < ctx->dpb_count) {
> +				mfc_err("Minimum %d output buffers
needed\n",
> +						ctx->dpb_count);
> +				return -EINVAL;
> +			}
> +		}
> +
>  		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>  		if (ret != 0) {
>  			mfc_err("error in vb2_reqbufs() for E(S)\n");
>  			return ret;
>  		}
>  		ctx->output_state = QUEUE_BUFS_REQUESTED;
> +
> +		if (IS_MFCV6(dev)) {
> +			/* Run init encoder buffers */
> +			s5p_mfc_hw_call(dev->mfc_ops, init_enc_buffers,
ctx);
> +			set_work_bit_irqsave(ctx);
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> +		}
>  	} else {
>  		mfc_err("invalid buf type\n");
>  		return -EINVAL;
> @@ -1095,7 +1125,8 @@ static int vidioc_querybuf(struct file *file,
> void *priv,
>  		(buf->memory != V4L2_MEMORY_USERPTR))
>  		return -EINVAL;
>  	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> -		if (ctx->state != MFCINST_GOT_INST) {
> +		if ((ctx->state != MFCINST_GOT_INST) &&
> +			(ctx->state != MFCINST_HEAD_PARSED)) {
>  			mfc_err("invalid context state: %d\n", ctx->state);
>  			return -EINVAL;
>  		}
> @@ -1477,8 +1508,40 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl
> *ctrl)
>  	return ret;
>  }
> 
> +static int s5p_mfc_enc_g_v_ctrl(struct v4l2_ctrl *ctrl) {
> +	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
> +		if (ctx->state >= MFCINST_HEAD_PARSED &&
> +		    ctx->state < MFCINST_ABORT) {
> +			ctrl->val = ctx->dpb_count;
> +			break;
> +		} else if (ctx->state <= MFCINST_INIT) {
> +			v4l2_err(&dev->v4l2_dev, "Encoding not
> initialised\n");
> +			return -EINVAL;
> +		}
> +		/* Should proceed if sequnce header is done */
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_wait_for_done_ctx(ctx,
> +				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
> +		if (ctx->state >= MFCINST_HEAD_PARSED &&
> +		    ctx->state < MFCINST_ABORT) {
> +			ctrl->val = ctx->dpb_count;
> +		} else {
> +			v4l2_err(&dev->v4l2_dev, "Encoding not
> initialised\n");
> +			return -EINVAL;
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
>  static const struct v4l2_ctrl_ops s5p_mfc_enc_ctrl_ops = {
>  	.s_ctrl = s5p_mfc_enc_s_ctrl,
> +	.g_volatile_ctrl = s5p_mfc_enc_g_v_ctrl,
>  };
> 
>  static int vidioc_s_parm(struct file *file, void *priv, @@ -1624,7
> +1687,8 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
>  	struct s5p_mfc_dev *dev = ctx->dev;
> 
> -	if (ctx->state != MFCINST_GOT_INST) {
> +	if ((ctx->state != MFCINST_GOT_INST) &&
> +		(ctx->state != MFCINST_HEAD_PARSED)) {
>  		mfc_err("inavlid state: %d\n", ctx->state);
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> index 754c540..2464223 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> @@ -41,6 +41,7 @@ struct s5p_mfc_hw_ops {
>  	int (*set_enc_ref_buffer)(struct s5p_mfc_ctx *ctx);
>  	int (*init_decode)(struct s5p_mfc_ctx *ctx);
>  	int (*init_encode)(struct s5p_mfc_ctx *ctx);
> +	int (*init_enc_buffers)(struct s5p_mfc_ctx *ctx);
>  	int (*encode_one_frame)(struct s5p_mfc_ctx *ctx);
>  	void (*try_run)(struct s5p_mfc_dev *dev);
>  	void (*cleanup_queue)(struct list_head *lh, diff --git
> a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> index f61dba8..51e7ce0e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> @@ -1352,6 +1352,12 @@ static int s5p_mfc_run_init_dec_buffers(struct
> s5p_mfc_ctx *ctx)
>  	return ret;
>  }
> 
> +static int s5p_mfc_run_init_enc_buffers_v5(struct s5p_mfc_ctx *ctx) {
> +	/* Needed for v6 only */
> +	return -1;
> +}
> +
>  /* Try running an operation on hardware */  void
> s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)  { @@ -1692,6 +1698,7 @@
> static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
>  	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v5,
>  	.init_decode = s5p_mfc_init_decode_v5,
>  	.init_encode = s5p_mfc_init_encode_v5,
> +	.init_enc_buffers = s5p_mfc_run_init_enc_buffers_v5,
>  	.encode_one_frame = s5p_mfc_encode_one_frame_v5,
>  	.try_run = s5p_mfc_try_run_v5,
>  	.cleanup_queue = s5p_mfc_cleanup_queue_v5, diff --git
> a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index beb6dba..6dbec0e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -158,39 +158,12 @@ int s5p_mfc_alloc_codec_buffers_v6(struct
> s5p_mfc_ctx *ctx)
>  				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
>  		ctx->bank1.size = ctx->scratch_buf_size;
>  		break;
> -	case S5P_MFC_CODEC_H264_ENC:
> -		ctx->scratch_buf_size =
> -			S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(
> -					mb_width,
> -					mb_height);
> -		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
> -				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
> -		ctx->bank1.size =
> -			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> -			(ctx->dpb_count * (ctx->luma_dpb_size +
> -			ctx->chroma_dpb_size + ctx->me_buffer_size));
> -		ctx->bank2.size = 0;
> -		break;
> -	case S5P_MFC_CODEC_MPEG4_ENC:
> -	case S5P_MFC_CODEC_H263_ENC:
> -		ctx->scratch_buf_size =
> -			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
> -					mb_width,
> -					mb_height);
> -		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
> -				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
> -		ctx->bank1.size =
> -			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> -			(ctx->dpb_count * (ctx->luma_dpb_size +
> -			ctx->chroma_dpb_size + ctx->me_buffer_size));
> -		ctx->bank2.size = 0;
> -		break;
>  	default:
>  		break;
>  	}
> 
>  	/* Allocate only if memory from bank 1 is necessary */
> -	if (ctx->bank1.size > 0) {
> +	if ((ctx->bank1.size > 0) && (ctx->type == MFCINST_DECODER)) {

If no memory from bank1 is needed then shouldn't ctx->bank1.size be set to 0
in both encoder and decoder? Could you explain this change?

>  		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
>  		if (ret) {
>  			mfc_err("Failed to allocate Bank1 memory\n"); @@ -
> 198,7 +171,6 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx
> *ctx)
>  		}
>  		BUG_ON(ctx->bank1.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
>  	}
> -
>  	return 0;
>  }
> 
> @@ -1508,17 +1480,57 @@ static inline int
> s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
>  	return ret;
>  }
> 
> -static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
> +static int s5p_mfc_run_init_enc_buffers_v6(struct s5p_mfc_ctx *ctx)
>  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	int ret;
> +	int ret = 0;
> +	unsigned int mb_width, mb_height;
> 
> -	ret = s5p_mfc_alloc_codec_buffers_v6(ctx);
> -	if (ret) {
> -		mfc_err("Failed to allocate encoding buffers.\n");
> -		return -ENOMEM;
> +	mb_width = MB_WIDTH(ctx->img_width);
> +	mb_height = MB_HEIGHT(ctx->img_height);
> +
> +	/* Codecs have different memory requirements */
> +	switch (ctx->codec_mode) {
> +	case S5P_MFC_CODEC_H264_ENC:
> +		ctx->scratch_buf_size =
> +			S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(
> +					mb_width,
> +					mb_height);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
> +				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
> +		ctx->bank1.size =
> +			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> +			(ctx->dpb_count * (ctx->luma_dpb_size +
> +			ctx->chroma_dpb_size + ctx->me_buffer_size));
> +		ctx->bank2.size = 0;
> +		break;
> +	case S5P_MFC_CODEC_MPEG4_ENC:
> +	case S5P_MFC_CODEC_H263_ENC:
> +		ctx->scratch_buf_size =
> +			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
> +					mb_width,
> +					mb_height);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
> +				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
> +		ctx->bank1.size =
> +			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> +			(ctx->dpb_count * (ctx->luma_dpb_size +
> +			ctx->chroma_dpb_size + ctx->me_buffer_size));
> +		ctx->bank2.size = 0;
> +		break;
> +	default:
> +		break;
>  	}
> 
> +	/* Allocate bank1 memory */
> +	if (ctx->bank1.size > 0) {
> +		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
> +		if (ret) {
> +			mfc_err("Failed to allocate Bank1 memory\n");
> +			return ret;
> +		}
> +		BUG_ON(ctx->bank1.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> +	}
>  	/* Header was generated now starting processing
>  	 * First set the reference frame buffers
>  	 */
> @@ -1529,6 +1541,14 @@ static inline int
> s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
>  		return -EAGAIN;
>  	}
> 
> +	return 0;
> +}
> +
> +static int s5p_mfc_init_enc_buffers_cmd(struct s5p_mfc_ctx *ctx) {
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	int ret = 0;
> +
>  	dev->curr_ctx = ctx->num;
>  	s5p_mfc_clean_ctx_int_flags(ctx);
>  	ret = s5p_mfc_set_enc_ref_buffer_v6(ctx);
> @@ -1638,8 +1658,8 @@ void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
>  		case MFCINST_GOT_INST:
>  			s5p_mfc_run_init_enc(ctx);
>  			break;
> -		case MFCINST_HEAD_PARSED: /* Only for MFC6.x */
> -			ret = s5p_mfc_run_init_enc_buffers(ctx);
> +		case MFCINST_HEAD_PARSED:
> +			ret = s5p_mfc_init_enc_buffers_cmd(ctx);
>  			break;
>  		default:
>  			ret = -EAGAIN;
> @@ -1865,6 +1885,7 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
>  	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v6,
>  	.init_decode = s5p_mfc_init_decode_v6,
>  	.init_encode = s5p_mfc_init_encode_v6,
> +	.init_enc_buffers = s5p_mfc_run_init_enc_buffers_v6,
>  	.encode_one_frame = s5p_mfc_encode_one_frame_v6,
>  	.try_run = s5p_mfc_try_run_v6,
>  	.cleanup_queue = s5p_mfc_cleanup_queue_v6,
> --
> 1.7.9.5

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


