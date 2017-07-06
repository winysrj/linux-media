Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39544 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751659AbdGFJ1c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 05:27:32 -0400
Subject: Re: [PATCH 12/12] [media] vb2: add out-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-13-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1305e017-58d4-8f67-56a4-755098c29017@xs4all.nl>
Date: Thu, 6 Jul 2017 11:27:24 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-13-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
> an out_fence for the buffer and return it to userspace on the fence_fd
> field. It only works with ordered queues.
> 
> The fence is signaled on buffer_done(), when the job on the buffer is
> finished.
> 
> v2: check if the queue is ordered.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |  6 ++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 22 +++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 21cc4ed..a57902ee 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -356,6 +356,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>  			vb->planes[plane].length = plane_sizes[plane];
>  			vb->planes[plane].min_length = plane_sizes[plane];
>  		}
> +		vb->out_fence_fd = -1;
>  		q->bufs[vb->index] = vb;
>  
>  		/* Allocate video buffer memory for the MMAP type */
> @@ -940,6 +941,11 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  			__enqueue_in_driver(vb);
>  		return;
>  	default:
> +		dma_fence_signal(vb->out_fence);
> +		dma_fence_put(vb->out_fence);
> +		vb->out_fence = NULL;
> +		vb->out_fence_fd = -1;
> +
>  		/* Inform any processes that may be waiting for buffers */
>  		wake_up(&q->done_wq);
>  		break;

case VB2_BUF_STATE_REQUEUEING: a driver that calls this would break the ordering
requirement. I would suggest a WARN_ON_ONCE(q->ordered) call there together with
a comment.

> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index e6ad77f..e2733dd 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -204,9 +204,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timestamp = ns_to_timeval(vb->timestamp);
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
> -	b->fence_fd = -1;
> +	b->fence_fd = vb->out_fence_fd;
>  	b->reserved = 0;
>  
> +	if (vb->sync_file) {
> +		fd_install(vb->out_fence_fd, vb->sync_file->file);
> +		vb->sync_file = NULL;

I'm no fence expert, but this seems the wrong place for this.

> +	}
> +

You need to set the OUT_FENCE flag if there is a fence pending.

>  	if (q->is_multiplanar) {
>  		/*
>  		 * Fill in plane-related data if userspace provided an array
> @@ -581,6 +586,21 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  		}
>  	}
>  
> +	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
> +		if (!q->ordered) {
> +			dprintk(1, "can't use out-fences with unordered queues\n");
> +			dma_fence_put(fence);
> +			return -EINVAL;
> +		}
> +
> +		ret = vb2_setup_out_fence(q, b->index);
> +		if (ret) {
> +			dprintk(1, "failed to set up out-fence\n");
> +			dma_fence_put(fence);
> +			return ret;
> +		}
> +	}
> +
>  	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);

Wouldn't it make more sense to do the fd_install after this call?

Besides, if vb2_core_qbuf returns with an error, then I expect that
we need to clean up the fence?

>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
> 

Regards,

	Hans
