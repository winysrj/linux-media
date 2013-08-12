Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40005 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3HLIku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 04:40:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRE00BG0TFMW670@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Aug 2013 09:40:48 +0100 (BST)
Message-id: <52089F8E.6090107@samsung.com>
Date: Mon, 12 Aug 2013 10:40:46 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 1/2] media: vb2: Fix potential deadlock in
 vb2_prepare_buffer
References: <1376050286-8201-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1376050286-8201-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1376050286-8201-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/9/2013 2:11 PM, Laurent Pinchart wrote:
> Commit b037c0fde22b1d3cd0b3c3717d28e54619fc1592 ("media: vb2: fix
> potential deadlock in mmap vs. get_userptr handling") fixes an AB-BA
> deadlock related to the mmap_sem and driver locks. The same deadlock can
> occur in vb2_prepare_buffer(), fix it the same way.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 52 ++++++++++++++++++++++++++------
>   1 file changed, 43 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7f32860..7c2a8ce 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1248,50 +1248,84 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>    */
>   int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>   {
> +	struct rw_semaphore *mmap_sem = NULL;
>   	struct vb2_buffer *vb;
>   	int ret;
>   
> +	/*
> +	 * In case of user pointer buffers vb2 allocator needs to get direct
> +	 * access to userspace pages. This requires getting read access on
> +	 * mmap semaphore in the current process structure. The same
> +	 * semaphore is taken before calling mmap operation, while both mmap
> +	 * and prepare_buf are called by the driver or v4l2 core with driver's
> +	 * lock held. To avoid a AB-BA deadlock (mmap_sem then driver's lock in
> +	 * mmap and driver's lock then mmap_sem in prepare_buf) the videobuf2
> +	 * core release driver's lock, takes mmap_sem and then takes again
> +	 * driver's lock.
> +	 *
> +	 * To avoid race with other vb2 calls, which might be called after
> +	 * releasing driver's lock, this operation is performed at the
> +	 * beggining of prepare_buf processing. This way the queue status is
> +	 * consistent after getting driver's lock back.
> +	 */
> +	if (q->memory == V4L2_MEMORY_USERPTR) {
> +		mmap_sem = &current->mm->mmap_sem;
> +		call_qop(q, wait_prepare, q);
> +		down_read(mmap_sem);
> +		call_qop(q, wait_finish, q);
> +	}
> +
>   	if (q->fileio) {
>   		dprintk(1, "%s(): file io in progress\n", __func__);
> -		return -EBUSY;
> +		ret = -EBUSY;
> +		goto unlock;
>   	}
>   
>   	if (b->type != q->type) {
>   		dprintk(1, "%s(): invalid buffer type\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>   	}
>   
>   	if (b->index >= q->num_buffers) {
>   		dprintk(1, "%s(): buffer index out of range\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>   	}
>   
>   	vb = q->bufs[b->index];
>   	if (NULL == vb) {
>   		/* Should never happen */
>   		dprintk(1, "%s(): buffer is NULL\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>   	}
>   
>   	if (b->memory != q->memory) {
>   		dprintk(1, "%s(): invalid memory type\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>   	}
>   
>   	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>   		dprintk(1, "%s(): invalid buffer state %d\n", __func__, vb->state);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>   	}
>   	ret = __verify_planes_array(vb, b);
>   	if (ret < 0)
> -		return ret;
> +		goto unlock;
> +
>   	ret = __buf_prepare(vb, b);
>   	if (ret < 0)
> -		return ret;
> +		goto unlock;
>   
>   	__fill_v4l2_buffer(vb, b);
>   
> -	return 0;
> +unlock:
> +	if (mmap_sem)
> +		up_read(mmap_sem);
> +	return ret;
>   }
>   EXPORT_SYMBOL_GPL(vb2_prepare_buf);
>   

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


