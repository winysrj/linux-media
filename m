Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43963 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381Ab3E2Jc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 05:32:28 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNJ00DNBZS6BKC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 10:32:26 +0100 (BST)
Message-id: <51A5CB28.6080708@samsung.com>
Date: Wed, 29 May 2013 11:32:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC] [media] mem2mem: add support for hardware buffered queue
References: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philip,

On 05/22/2013 12:17 PM, Philipp Zabel wrote:
> On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
> buffer at the end of the stream, remaining frames might need to be decoded
> without additional input buffers being provided, and after calling streamoff
> on the v4l2 output queue. This also allows a driver to copy input buffers
> into their bitstream ringbuffer and immediately mark them as done to be
> dequeued.
> 
> The motivation for this patch is hardware assisted h.264 reordering support
> in the coda driver. For high profile streams, the coda can hold back
> out-of-order frames, causing a few mem2mem device runs in the beginning, that
> don't produce any decompressed buffer at the v4l2 capture side. At the same
> time, the last few frames can be decoded from the bitstream with mem2mem device
> runs that don't need a new input buffer at the v4l2 output side. A streamoff
> on the v4l2 output side can be used to put the decoder into the ringbuffer
> draining end-of-stream mode.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 26 ++++++++++++++++++++------
>  include/media/v4l2-mem2mem.h           |  3 +++
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 357efa4..52818cd 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -196,6 +196,10 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>   * 2) at least one destination buffer has to be queued,
>   * 3) streaming has to be on.
>   *
> + * If a queue is buffered (for example a decoder hardware ringbuffer that has
> + * to be drained before doing streamoff), allow scheduling without v4l2 buffers
> + * on that queue and even when the queue is not streaming anymore.

Does it mean you want to be able to queue buffers on e.g. OUTPUT queue, while
this queue is in STREAM OFF state ?

Or do you really want to be able to to queue/dequeue buffers on CAPTURE queue,
while the OUTPUT queue is in STREAM OFF state ?

>   * There may also be additional, custom requirements. In such case the driver
>   * should supply a custom callback (job_ready in v4l2_m2m_ops) that should
>   * return 1 if the instance is ready.
> @@ -210,7 +214,7 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  	m2m_dev = m2m_ctx->m2m_dev;
>  	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
>  
> -	if (!m2m_ctx->out_q_ctx.q.streaming
> +	if ((!m2m_ctx->out_q_ctx.q.streaming && !m2m_ctx->out_q_ctx.buffered)

This seems a bit asymmetric. Even if a driver sets 'buffered' on the capture
queue nothing really changes, right ?

Thanks,
Sylwester

>  	    || !m2m_ctx->cap_q_ctx.q.streaming) {
>  		dprintk("Streaming needs to be on for both queues\n");
>  		return;
> @@ -224,7 +228,7 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  	}
>  
>  	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> -	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
> +	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue) && !m2m_ctx->out_q_ctx.buffered) {
>  		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
>  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>  		dprintk("No input buffers available\n");
> @@ -434,9 +438,11 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  
>  	m2m_dev = m2m_ctx->m2m_dev;
>  	spin_lock_irqsave(&m2m_dev->job_spinlock, flags_job);
> -	/* We should not be scheduled anymore, since we're dropping a queue. */
> -	INIT_LIST_HEAD(&m2m_ctx->queue);
> -	m2m_ctx->job_flags = 0;gmane.linux.drivers.video-input-infrastructure	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue))
> +	if (!q_ctx->buffered) {
> +		/* We should not be scheduled anymore, since we're dropping a queue. */
> +		INIT_LIST_HEAD(&m2m_ctx->queue);
> +		m2m_ctx->job_flags = 0;
> +	}
>  
>  	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
>  	/* Drop queue, since streamoff returns device to the same state as after
> @@ -444,7 +450,7 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  	INIT_LIST_HEAD(&q_ctx->rdy_queue);
>  	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
>  
> -	if (m2m_dev->curr_ctx == m2m_ctx) {
> +	if (!q_ctx->buffered && (m2m_dev->curr_ctx == m2m_ctx)) {
>  		m2m_dev->curr_ctx = NULL;
>  		wake_up(&m2m_ctx->finished);
>  	}
> @@ -640,6 +646,14 @@ err:
>  }	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue))
>  EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
>  
> +void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq)
> +{
> +	struct v4l2_m2m_queue_ctx *q_ctx = container_of(vq, struct v4l2_m2m_queue_ctx, q);
> +
> +	q_ctx->buffered = true;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_queue_set_buffered);
> +
>  /**
>   * v4l2_m2m_ctx_release() - release m2m context
>   *
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 0f4555b..3415845 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -60,6 +60,7 @@ struct v4l2_m2m_queue_ctx {
>  	struct list_head	rdy_queue;
>  	spinlock_t		rdy_spinlock;
>  	u8			num_rdy;
> +	bool			buffered;
>  };
>  
>  struct v4l2_m2m_ctx {
> @@ -134,6 +135,8 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
>  		void *drv_priv,
>  		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
>  
> +void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq);
> +
>  void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
>  
>  void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
Samsung Electronics
