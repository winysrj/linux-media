Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:64819 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1AMJye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 04:54:34 -0500
Date: Thu, 13 Jan 2011 18:51:19 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: [RFC/PATCH v6 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <1294417534-3856-4-git-send-email-k.debski@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com
Message-id: <008001cbb307$6f8cea00$4ea6be00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
 <1294417534-3856-4-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

Kamil Debski wrote:

<snip>

> +/* Reqeust buffers */
> +static int vidioc_reqbufs(struct file *file, void *priv,
> +					  struct v4l2_requestbuffers
*reqbufs)
> +{
> +	struct s5p_mfc_dev *dev = video_drvdata(file);
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
> +		/* Can only request buffers after an instance has been
opened.*/
> +		if (ctx->state == MFCINST_DEC_GOT_INST) {
> +			/* Decoding */
> +			if (ctx->output_state != QUEUE_FREE) {
> +				mfc_err("Bufs have already been
requested.\n");
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
> +	} else if (reqbufs->type ==
> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
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
> +		ret = s5p_mfc_alloc_dec_buffers(ctx);
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
> +			s5p_mfc_release_dec_buffers(ctx);
> +			return -ENOMEM;
> +		}
> +		if (s5p_mfc_ctx_ready(ctx)) {
> +			spin_lock_irqsave(&dev->condlock, flags);
> +			set_bit(ctx->num, &dev->ctx_work_bits);
> +			spin_unlock_irqrestore(&dev->condlock, flags);
> +		}
> +		s5p_mfc_try_run(dev);
> +		s5p_mfc_wait_for_done_ctx(ctx,
> +
> S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 1);
> +	}
> +	mfc_debug_leave();
> +	return ret;
> +}

I don't know how to handle the followings.

So I suggest that in reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT case, 
how about return -EINVAL if reqbufs->count is bigger than 1.

Because if reqbufs->count is bigger than 1, it is hard to handle the encoded
input stream.

For example: Dynamic resolution change
Dynamic resolution change means that resolution can be changed at any
I-frame with header on the fly during streaming.

MFC H/W can detect it after getting decoding command from the driver.
If the dynamic resolution change is detected by MFC H/W, 
driver should let application know the fact to do the following Sequence 1
by application.

Sequence 1:
streamoff -> munmap -> reqbufs(0) -> S_FMT(changed resolution) -> querybuf
-> mmap -> re-QBUF with the I-frame -> STREAMON -> ...

Why it is hard to handle the encoded input stream in multiple input stream
case is the following Sequence 2.

Sequence 2:
QBUF(0) -> QBUF(1: resolution changed I-frame) -> QBUF(2: already changed)
-> QBUF(3: already changed) -> DQBUF(0) -> DQBUF(1): return fail -> ...

Application cannot know the resolution change in the QBUF ioctl.
Driver will return 0 at the QBUF because all parameters are fine.
But after sending the decode command to MFC H/W, driver can know that the
I-frame needs to change resolution.
In that case driver can return error at the DQBUF of the buffer.

In the sequence 2, application can know the resolution change in the
DQBUF(1).
So the application should re-QBUF the buffer 2, 3 after Sequence 1.
It is hard to re-control the buffers which are already queued in the point
of application.
Because in the reqbufs(0) buffers will be freed. 
So application has to copy them to the temporary buffer to re-QBUF after
Sequence 1.

How can we solve this case ?

Best regards,


