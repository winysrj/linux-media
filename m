Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45334 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEHQVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 12:21:51 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5900JJZK4BGQ40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 May 2014 17:21:47 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org,
	arunkk.samsung@gmail.com
References: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
 <1395391035-27349-4-git-send-email-arun.kk@samsung.com>
In-reply-to: <1395391035-27349-4-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH 3/3] [media] s5p-mfc: Don't allocate codec buffers on
 STREAMON.
Date: Thu, 08 May 2014 18:22:02 +0200
Message-id: <004a01cf6ad9$a5a2c870$f0e85950$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
> Kumar K
> Sent: Friday, March 21, 2014 9:37 AM
> 
> From: Pawel Osciak <posciak@chromium.org>
> 
> Currently, we allocate private codec buffers on STREAMON, which may
> fail if we are out of memory. We don't check for failure though, which
> will make us crash with the codec accessing random memory.
> 
> We shouldn't be failing STREAMON with out of memory errors though. So
> move the allocation of private codec buffers to REQBUFS for OUTPUT
> queue. Also, move MFC instance opening and closing to REQBUFS as well,
> as it's tied to allocation and deallocation of private codec buffers.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c      |   10 ++++-----
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   30 +++++++++++------
> --------
>  3 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 04030f5..4ee5a02 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -637,8 +637,9 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>  		goto irq_cleanup_hw;
> 
>  	case S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET:
> -		clear_work_bit(ctx);
> +		ctx->inst_no = MFC_NO_INSTANCE_SET;
>  		ctx->state = MFCINST_FREE;
> +		clear_work_bit(ctx);
>  		wake_up(&ctx->queue);

I have the impression that work bit first should be cleared and then
changes made to the context. 

		clear_work_bit(ctx);
+		ctx->inst_no = MFC_NO_INSTANCE_SET;
 		ctx->state = MFCINST_FREE;

>  		goto irq_cleanup_hw;
> 
> @@ -758,7 +759,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_bad_node;
>  	}
>  	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> -	ctx->inst_no = -1;
> +	ctx->inst_no = MFC_NO_INSTANCE_SET;
>  	/* Load firmware if this is the first instance */
>  	if (dev->num_inst == 1) {
>  		dev->watchdog_timer.expires = jiffies + @@ -868,12 +869,11
> @@ static int s5p_mfc_release(struct file *file)
>  	vb2_queue_release(&ctx->vq_dst);
>  	/* Mark context as idle */
>  	clear_work_bit_irqsave(ctx);
> -	/* If instance was initialised then
> +	/* If instance was initialised and not yet freed,
>  	 * return instance and free resources */
> -	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
> +	if (ctx->state != MFCINST_FREE && ctx->state != MFCINST_INIT) {
>  		mfc_debug(2, "Has to free instance\n");
>  		s5p_mfc_close_mfc_inst(dev, ctx);
> -		ctx->inst_no = MFC_NO_INSTANCE_SET;
>  	}
>  	/* hardware locking scheme */
>  	if (dev->curr_ctx == ctx->num)
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index ccbfcb3..865e9e0 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -461,5 +461,6 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev,
> struct s5p_mfc_ctx *ctx)
>  	if (ctx->type == MFCINST_DECODER)
>  		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
> 
> +	ctx->inst_no = MFC_NO_INSTANCE_SET;
>  	ctx->state = MFCINST_FREE;
>  }
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index efc78ae..4586186 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -475,11 +475,11 @@ static int reqbufs_output(struct s5p_mfc_dev *dev,
> struct s5p_mfc_ctx *ctx,
>  		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>  		if (ret)
>  			goto out;
> +		s5p_mfc_close_mfc_inst(dev, ctx);
>  		ctx->src_bufs_cnt = 0;
> +		ctx->output_state = QUEUE_FREE;
>  	} else if (ctx->output_state == QUEUE_FREE) {
> -		/* Can only request buffers after the instance
> -		 * has been opened.
> -		 */
> +		/* Can only request buffers when we have a valid format set.
> */
>  		WARN_ON(ctx->src_bufs_cnt != 0);
>  		if (ctx->state != MFCINST_INIT) {
>  			mfc_err("Reqbufs called in an invalid state\n"); @@
-
> 493,6 +493,13 @@ static int reqbufs_output(struct s5p_mfc_dev *dev,
> struct s5p_mfc_ctx *ctx,
>  		if (ret)
>  			goto out;
> 
> +		ret = s5p_mfc_open_mfc_inst(dev, ctx);
> +		if (ret) {
> +			reqbufs->count = 0;
> +			vb2_reqbufs(&ctx->vq_src, reqbufs);
> +			goto out;
> +		}
> +
>  		ctx->output_state = QUEUE_BUFS_REQUESTED;
>  	} else {
>  		mfc_err("Buffers have already been requested\n"); @@ -594,7
> +601,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
>  		return -EINVAL;
>  	}
>  	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
> -	if (ctx->state == MFCINST_INIT &&
> +	if (ctx->state == MFCINST_GOT_INST &&
>  			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		ret = vb2_querybuf(&ctx->vq_src, buf);
>  	} else if (ctx->state == MFCINST_RUNNING && @@ -670,24 +677,13 @@
> static int vidioc_streamon(struct file *file, void *priv,
>  			   enum v4l2_buf_type type)
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
> -	struct s5p_mfc_dev *dev = ctx->dev;
>  	int ret = -EINVAL;
> 
>  	mfc_debug_enter();
> -	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> -		if (ctx->state == MFCINST_INIT) {
> -			ctx->dst_bufs_cnt = 0;
> -			ctx->src_bufs_cnt = 0;
> -			ctx->capture_state = QUEUE_FREE;
> -			ctx->output_state = QUEUE_FREE;
> -			ret = s5p_mfc_open_mfc_inst(dev, ctx);
> -			if (ret)
> -				return ret;
> -		}
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>  		ret = vb2_streamon(&ctx->vq_src, type);
> -	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>  		ret = vb2_streamon(&ctx->vq_dst, type);
> -	}
>  	mfc_debug_leave();
>  	return ret;
>  }
> --
> 1.7.9.5

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

