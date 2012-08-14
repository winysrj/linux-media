Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10625 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2HNKhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:37:10 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8Q000GEQUUKA80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:37:42 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8Q00J24QTW8K10@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:37:08 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1344935620-7514-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1344935620-7514-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH] v4l/s5p-mfc: optimized code related to working contextes
Date: Tue, 14 Aug 2012 12:37:07 +0200
Message-id: <00b401cd7a08$c12aff40$4380fdc0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for your patch.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: 14 August 2012 11:14
> 
> All code setting/clearing working context bits has been moved
> to separate functions. set_bit/clear_bit have been replaced by
> non-atomic variants - variable is already guarded by spin_lock.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
> The patch should be applied after
> "[RESEND] v4l/s5p-mfc: added support for end of stream handling in MFC
encoder"
> http://patchwork.linuxtv.org/patch/13721/
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |   55
++++++++++++++++++-------
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |    5 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |   28 +++----------
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   34 ++++------------
>  4 files changed, 60 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
b/drivers/media/video/s5p-
> mfc/s5p_mfc.c
> index 40cef6b..e5c2b80 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -41,16 +41,49 @@ module_param(debug, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Debug level - higher value produces more verbose
> messages");
> 
>  /* Helper functions for interrupt processing */
> +
>  /* Remove from hw execution round robin */
> -static void clear_work_bit(struct s5p_mfc_ctx *ctx)
> +void clear_work_bit(struct s5p_mfc_ctx *ctx)
>  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
> 
>  	spin_lock(&dev->condlock);
> -	clear_bit(ctx->num, &dev->ctx_work_bits);
> +	__clear_bit(ctx->num, &dev->ctx_work_bits);
>  	spin_unlock(&dev->condlock);
>  }
> 
> +/* Add to hw execution round robin */
> +void set_work_bit(struct s5p_mfc_ctx *ctx)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +
> +	spin_lock(&dev->condlock);
> +	__set_bit(ctx->num, &dev->ctx_work_bits);
> +	spin_unlock(&dev->condlock);
> +}
> +
> +/* Remove from hw execution round robin */
> +void clear_work_bit_irqsave(struct s5p_mfc_ctx *ctx)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->condlock, flags);
> +	__clear_bit(ctx->num, &dev->ctx_work_bits);
> +	spin_unlock_irqrestore(&dev->condlock, flags);
> +}
> +
> +/* Add to hw execution round robin */
> +void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->condlock, flags);
> +	__set_bit(ctx->num, &dev->ctx_work_bits);
> +	spin_unlock_irqrestore(&dev->condlock, flags);
> +}
> +
>  /* Wake up context wait_queue */
>  static void wake_up_ctx(struct s5p_mfc_ctx *ctx, unsigned int reason,
>  			unsigned int err)
> @@ -504,9 +537,7 @@ static void s5p_mfc_handle_init_buffers(struct
s5p_mfc_ctx
> *ctx,
>  	ctx->int_type = reason;
>  	ctx->int_err = err;
>  	ctx->int_cond = 1;
> -	spin_lock(&dev->condlock);
> -	clear_bit(ctx->num, &dev->ctx_work_bits);
> -	spin_unlock(&dev->condlock);
> +	clear_work_bit(ctx);
>  	if (err == 0) {
>  		ctx->state = MFCINST_RUNNING;
>  		if (!ctx->dpb_flush_flag) {
> @@ -681,7 +712,6 @@ static int s5p_mfc_open(struct file *file)
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct s5p_mfc_ctx *ctx = NULL;
>  	struct vb2_queue *q;
> -	unsigned long flags;
>  	int ret = 0;
> 
>  	mfc_debug_enter();
> @@ -714,9 +744,7 @@ static int s5p_mfc_open(struct file *file)
>  		}
>  	}
>  	/* Mark context as idle */
> -	spin_lock_irqsave(&dev->condlock, flags);
> -	clear_bit(ctx->num, &dev->ctx_work_bits);
> -	spin_unlock_irqrestore(&dev->condlock, flags);
> +	clear_work_bit_irqsave(ctx);
>  	dev->ctx[ctx->num] = ctx;
>  	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
>  		ctx->type = MFCINST_DECODER;
> @@ -843,7 +871,6 @@ static int s5p_mfc_release(struct file *file)
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	unsigned long flags;
> 
>  	mfc_debug_enter();
>  	mutex_lock(&dev->mfc_mutex);
> @@ -851,17 +878,13 @@ static int s5p_mfc_release(struct file *file)
>  	vb2_queue_release(&ctx->vq_src);
>  	vb2_queue_release(&ctx->vq_dst);
>  	/* Mark context as idle */
> -	spin_lock_irqsave(&dev->condlock, flags);
> -	clear_bit(ctx->num, &dev->ctx_work_bits);
> -	spin_unlock_irqrestore(&dev->condlock, flags);
> +	clear_work_bit_irqsave(ctx);
>  	/* If instance was initialised then
>  	 * return instance and free reosurces */
>  	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
>  		mfc_debug(2, "Has to free instance\n");
>  		ctx->state = MFCINST_RETURN_INST;
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> +		set_work_bit_irqsave(ctx);
>  		s5p_mfc_clean_ctx_int_flags(ctx);
>  		s5p_mfc_try_run(dev);
>  		/* Wait until instance is returned or timeout occured */
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> index 8871f0d..519b0d6 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> @@ -570,4 +570,9 @@ struct mfc_control {
>  #define ctrl_to_ctx(__ctrl) \
>  	container_of((__ctrl)->handler, struct s5p_mfc_ctx, ctrl_handler)
> 
> +void clear_work_bit(struct s5p_mfc_ctx *ctx);
> +void set_work_bit(struct s5p_mfc_ctx *ctx);
> +void clear_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
> +void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
> +
>  #endif /* S5P_MFC_COMMON_H_ */
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> index 65be806..9c6309d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> @@ -415,7 +415,6 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>  	int ret = 0;
> -	unsigned long flags;
> 
>  	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
>  		mfc_err("Only V4L2_MEMORY_MAP is supported\n");
> @@ -497,11 +496,8 @@ static int vidioc_reqbufs(struct file *file, void
*priv,
>  			s5p_mfc_clock_off();
>  			return -ENOMEM;
>  		}
> -		if (s5p_mfc_ctx_ready(ctx)) {
> -			spin_lock_irqsave(&dev->condlock, flags);
> -			set_bit(ctx->num, &dev->ctx_work_bits);
> -			spin_unlock_irqrestore(&dev->condlock, flags);
> -		}
> +		if (s5p_mfc_ctx_ready(ctx))
> +			set_work_bit_irqsave(ctx);
>  		s5p_mfc_try_run(dev);
>  		s5p_mfc_wait_for_done_ctx(ctx,
>  					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET,
0);
> @@ -576,7 +572,6 @@ static int vidioc_streamon(struct file *file, void
*priv,
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	unsigned long flags;
>  	int ret = -EINVAL;
> 
>  	mfc_debug_enter();
> @@ -589,9 +584,7 @@ static int vidioc_streamon(struct file *file, void
*priv,
>  			ctx->output_state = QUEUE_FREE;
>  			s5p_mfc_alloc_instance_buffer(ctx);
>  			s5p_mfc_alloc_dec_temp_buffers(ctx);
> -			spin_lock_irqsave(&dev->condlock, flags);
> -			set_bit(ctx->num, &dev->ctx_work_bits);
> -			spin_unlock_irqrestore(&dev->condlock, flags);
> +			set_work_bit_irqsave(ctx);
>  			s5p_mfc_clean_ctx_int_flags(ctx);
>  			s5p_mfc_try_run(dev);
> 
> @@ -875,18 +868,14 @@ static int s5p_mfc_start_streaming(struct vb2_queue
*q,
> unsigned int count)
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	unsigned long flags;
> 
>  	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
>  	if (ctx->state == MFCINST_FINISHING ||
>  		ctx->state == MFCINST_FINISHED)
>  		ctx->state = MFCINST_RUNNING;
>  	/* If context is ready then dev = work->data;schedule it to run */
> -	if (s5p_mfc_ctx_ready(ctx)) {
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> -	}
> +	if (s5p_mfc_ctx_ready(ctx))
> +		set_work_bit_irqsave(ctx);
>  	s5p_mfc_try_run(dev);
>  	return 0;
>  }
> @@ -953,11 +942,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
>  	} else {
>  		mfc_err("Unsupported buffer type (%d)\n", vq->type);
>  	}
> -	if (s5p_mfc_ctx_ready(ctx)) {
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> -	}
> +	if (s5p_mfc_ctx_ready(ctx))
> +		set_work_bit_irqsave(ctx);
>  	s5p_mfc_try_run(dev);
>  }
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index 602bc7d..53c305d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -643,11 +643,8 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
>  		spin_unlock_irqrestore(&dev->irqlock, flags);
>  	}
>  	ctx->state = MFCINST_RUNNING;
> -	if (s5p_mfc_ctx_ready(ctx)) {
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> -	}
> +	if (s5p_mfc_ctx_ready(ctx))
> +		set_work_bit_irqsave(ctx);
>  	s5p_mfc_try_run(dev);
>  	return 0;
>  }
> @@ -755,11 +752,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx
*ctx)
>  		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
>  	}
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> -	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0)) {
> -		spin_lock(&dev->condlock);
> -		clear_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock(&dev->condlock);
> -	}
> +	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
> +		clear_work_bit(ctx);
>  	return 0;
>  }
> 
> @@ -922,7 +916,6 @@ static int vidioc_s_fmt(struct file *file, void *priv,
> struct v4l2_format *f)
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>  	struct s5p_mfc_fmt *fmt;
>  	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> -	unsigned long flags;
>  	int ret = 0;
> 
>  	ret = vidioc_try_fmt(file, priv, f);
> @@ -947,9 +940,7 @@ static int vidioc_s_fmt(struct file *file, void *priv,
> struct v4l2_format *f)
>  		ctx->dst_bufs_cnt = 0;
>  		ctx->capture_state = QUEUE_FREE;
>  		s5p_mfc_alloc_instance_buffer(ctx);
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> +		set_work_bit_irqsave(ctx);
>  		s5p_mfc_clean_ctx_int_flags(ctx);
>  		s5p_mfc_try_run(dev);
>  		if (s5p_mfc_wait_for_done_ctx(ctx, \
> @@ -1719,15 +1710,11 @@ static int s5p_mfc_start_streaming(struct vb2_queue
*q,
> unsigned int count)
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	unsigned long flags;
> 
>  	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
>  	/* If context is ready then dev = work->data;schedule it to run */
> -	if (s5p_mfc_ctx_ready(ctx)) {
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> -	}
> +	if (s5p_mfc_ctx_ready(ctx))
> +		set_work_bit_irqsave(ctx);
>  	s5p_mfc_try_run(dev);
>  	return 0;
>  }
> @@ -1793,11 +1780,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
>  	} else {
>  		mfc_err("unsupported buffer type (%d)\n", vq->type);
>  	}
> -	if (s5p_mfc_ctx_ready(ctx)) {
> -		spin_lock_irqsave(&dev->condlock, flags);
> -		set_bit(ctx->num, &dev->ctx_work_bits);
> -		spin_unlock_irqrestore(&dev->condlock, flags);
> -	}
> +	if (s5p_mfc_ctx_ready(ctx))
> +		set_work_bit_irqsave(ctx);
>  	s5p_mfc_try_run(dev);
>  }
> 
> --
> 1.7.0.4

