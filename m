Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:50072 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1DDG6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 02:58:44 -0400
Date: Mon, 4 Apr 2011 08:58:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com
Subject: Re: [PATCH 1/5] [media] vb2: redesign the stop_streaming() callback
 and make it obligatory
In-Reply-To: <1301874670-14833-2-git-send-email-pawel@osciak.com>
Message-ID: <Pine.LNX.4.64.1104040854300.4668@axis700.grange>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
 <1301874670-14833-2-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 3 Apr 2011, Pawel Osciak wrote:

> Drivers are now required to implement the stop_streaming() callback
> to ensure that all ongoing hardware operations are finished and their
> ownership of buffers is ceded.
> Drivers do not have to call vb2_buffer_done() for each buffer they own
> anymore.
> Also remove the return value from the callback.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/videobuf2-core.c |   16 ++++++++++++++--
>  include/media/videobuf2-core.h       |   16 +++++++---------
>  2 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6e69584..59d5e8b 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -640,6 +640,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
>  
> +	if (atomic_read(&q->queued_count) == 0)
> +		return;
> +
>  	if (vb->state != VB2_BUF_STATE_ACTIVE)
>  		return;
>  
> @@ -1178,12 +1181,20 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	unsigned int i;
>  
>  	/*
> -	 * Tell driver to stop all transactions and release all queued
> +	 * Tell the driver to stop all transactions and release all queued
>  	 * buffers.
>  	 */
>  	if (q->streaming)
>  		call_qop(q, stop_streaming, q);
> +
> +	/*
> +	 * All buffers should now not be in use by the driver anymore, but we
> +	 * have to manually set queued_count to 0, as the driver was not
> +	 * required to call vb2_buffer_done() from stop_streaming() for all
> +	 * buffers it had queued.
> +	 */
>  	q->streaming = 0;
> +	atomic_set(&q->queued_count, 0);
>  
>  	/*
>  	 * Remove all buffers from videobuf's list...
> @@ -1197,7 +1208,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	wake_up_all(&q->done_wq);
>  
>  	/*
> -	 * Reinitialize all buffers for next use.
> +	 * Reinitialize all buffers for future use.
>  	 */
>  	for (i = 0; i < q->num_buffers; ++i)
>  		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
> @@ -1440,6 +1451,7 @@ int vb2_queue_init(struct vb2_queue *q)
>  
>  	BUG_ON(!q->ops->queue_setup);
>  	BUG_ON(!q->ops->buf_queue);
> +	BUG_ON(!q->ops->stop_streaming);
>  
>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f3bdbb2..8115fe9 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -184,7 +184,7 @@ struct vb2_buffer {
>  
>  /**
>   * struct vb2_ops - driver-specific callbacks to be implemented by the driver
> - * Required: queue_setup, buf_queue. The rest is optional.
> + * Required: queue_setup, buf_queue, stop_streaming. The rest is optional.
>   *
>   * @queue_setup:	used to negotiate queue parameters between the userspace
>   *			and the driver; called before memory allocation;
> @@ -231,13 +231,11 @@ struct vb2_buffer {
>   *			the driver before streaming begins (such as enabling
>   *			the device);
>   * @stop_streaming:	called when the 'streaming' state must be disabled;
> - * 			drivers should stop any DMA transactions here (or wait
> - * 			until they are finished) and give back all the buffers
> - * 			received via buf_queue() by calling vb2_buffer_done()
> - * 			for each of them;
> - * 			drivers can use the vb2_wait_for_all_buffers() function
> - * 			here to wait for asynchronous completion events that
> - * 			call vb2_buffer_done(), such as ISRs;
> + *			drivers should stop any DMA transactions here (or wait
> + *			until they are finished) before returning;
> + *			drivers can use the vb2_wait_for_all_buffers() function
> + *			here to wait for asynchronous completion events, such
> + *			as ISRs;
>   * @buf_queue:		passes a buffer to the driver; the driver may start
>   *			a hardware operation on that buffer; this callback
>   *			MUST return immediately, i.e. it may NOT wait for
> @@ -259,7 +257,7 @@ struct vb2_ops {
>  	void (*buf_cleanup)(struct vb2_buffer *vb);
>  
>  	int (*start_streaming)(struct vb2_queue *q);
> -	int (*stop_streaming)(struct vb2_queue *q);
> +	void (*stop_streaming)(struct vb2_queue *q);

Won't compilation break after this patch with "assignment from 
incompatible pointer type?" I know, it's only until it is fixed by the 
follow-up patches, but normally we're trying to avoid such bisection 
breakages.

Thanks
Guennadi

>  
>  	void (*buf_queue)(struct vb2_buffer *vb);
>  };
> -- 
> 1.7.4.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
