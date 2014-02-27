Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50487 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaB0MGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 07:06:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 09/15] vb2: rename queued_count to owned_by_drv_count
Date: Thu, 27 Feb 2014 13:08:15 +0100
Message-ID: <6113799.buJEx59e2k@avalon>
In-Reply-To: <1393332775-44067-10-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl> <1393332775-44067-10-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 25 February 2014 13:52:49 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> 'queued_count' is a bit vague since it is not clear to which queue it
> refers to: the vb2 internal list of buffers or the driver-owned list
> of buffers.
> 
> Rename to make it explicit.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
>  include/media/videobuf2-core.h           |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index eefcff7..2a7815c 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1071,7 +1071,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum
> vb2_buffer_state state) spin_lock_irqsave(&q->done_lock, flags);
>  	vb->state = state;
>  	list_add_tail(&vb->done_entry, &q->done_list);
> -	atomic_dec(&q->queued_count);
> +	atomic_dec(&q->owned_by_drv_count);
>  	spin_unlock_irqrestore(&q->done_lock, flags);
> 
>  	/* Inform any processes that may be waiting for buffers */
> @@ -1402,7 +1402,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> unsigned int plane;
> 
>  	vb->state = VB2_BUF_STATE_ACTIVE;
> -	atomic_inc(&q->queued_count);
> +	atomic_inc(&q->owned_by_drv_count);
> 
>  	/* sync buffers */
>  	for (plane = 0; plane < vb->num_planes; ++plane)
> @@ -1554,7 +1554,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	int ret;
> 
>  	/* Tell the driver to start streaming */
> -	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
> +	ret = call_qop(q, start_streaming, q,
> atomic_read(&q->owned_by_drv_count)); if (ret)
>  		fail_qop(q, start_streaming);
> 
> @@ -1775,7 +1775,7 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
>  	}
> 
>  	if (!q->retry_start_streaming)
> -		wait_event(q->done_wq, !atomic_read(&q->queued_count));
> +		wait_event(q->done_wq, !atomic_read(&q->owned_by_drv_count));
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
> @@ -1907,7 +1907,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	 * has not already dequeued before initiating cancel.
>  	 */
>  	INIT_LIST_HEAD(&q->done_list);
> -	atomic_set(&q->queued_count, 0);
> +	atomic_set(&q->owned_by_drv_count, 0);
>  	wake_up_all(&q->done_wq);
> 
>  	/*
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 82b7f0f..adaffed 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -353,7 +353,7 @@ struct v4l2_fh;
>   * @bufs:	videobuf buffer structures
>   * @num_buffers: number of allocated/used buffers
>   * @queued_list: list of buffers currently queued from userspace
> - * @queued_count: number of buffers owned by the driver
> + * @owned_by_drv_count: number of buffers owned by the driver
>   * @done_list:	list of buffers ready to be dequeued to userspace
>   * @done_lock:	lock to protect done_list list
>   * @done_wq:	waitqueue for processes waiting for buffers ready to be
> dequeued @@ -385,7 +385,7 @@ struct vb2_queue {
> 
>  	struct list_head		queued_list;
> 
> -	atomic_t			queued_count;
> +	atomic_t			owned_by_drv_count;
>  	struct list_head		done_list;
>  	spinlock_t			done_lock;
>  	wait_queue_head_t		done_wq;

-- 
Regards,

Laurent Pinchart

