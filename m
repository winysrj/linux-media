Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44703 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbbBBOBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 09:01:32 -0500
Message-ID: <54CF8313.5020207@xs4all.nl>
Date: Mon, 02 Feb 2015 15:00:51 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [RFC PATCH 2/2] [media] videobuf2: return -EPIPE from DQBUF after
 the last buffer
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de> <1421926118-29535-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1421926118-29535-3-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2015 12:28 PM, Philipp Zabel wrote:
> If the last buffer was dequeued from a capture queue, let poll return
> immediately and let DQBUF return -EPIPE to signal there will no more
> buffers to dequeue until STREAMOFF.

This looks OK to me, although I would like to see comments from others as well.
Of course, this needs to be documented in the spec as well.

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> TODO: (How) should the last_buffer_dequeud flag be cleared in reaction to
> V4L2_DEC_CMD_START?

I would suggest an inline function in videobuf2-core.h that clears the flag
and that drivers can call. I don't think the vb2 core can detect when it is
OK to clear the flag, it needs to be told by the driver (correct me if I am
wrong).

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c   | 10 +++++++++-
>  drivers/media/v4l2-core/videobuf2-core.c | 18 +++++++++++++++++-
>  include/media/videobuf2-core.h           |  1 +
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 80c588f..1b5b432 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -564,8 +564,16 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  
>  	if (list_empty(&src_q->done_list))
>  		poll_wait(file, &src_q->done_wq, wait);
> -	if (list_empty(&dst_q->done_list))
> +	if (list_empty(&dst_q->done_list)) {
> +		/*
> +		 * If the last buffer was dequeued from the capture queue,
> +		 * return immediately. DQBUF will return -EPIPE.
> +		 */
> +		if (dst_q->last_buffer_dequeued)
> +			return rc | POLLIN | POLLRDNORM;
> +
>  		poll_wait(file, &dst_q->done_wq, wait);
> +	}
>  
>  	if (m2m_ctx->m2m_dev->m2m_ops->lock)
>  		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index d09a891..c2c2eac 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2046,6 +2046,10 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>  	struct vb2_buffer *vb = NULL;
>  	int ret;
>  
> +	if (q->last_buffer_dequeued) {
> +		dprintk(3, "last buffer dequeued already\n");
> +		return -EPIPE;
> +	}
>  	if (b->type != q->type) {
>  		dprintk(1, "invalid buffer type\n");
>  		return -EINVAL;
> @@ -2073,6 +2077,9 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>  	/* Remove from videobuf queue */
>  	list_del(&vb->queued_entry);
>  	q->queued_count--;
> +	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
> +	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
> +		q->last_buffer_dequeued = true;
>  	/* go back to dequeued state */
>  	__vb2_dqbuf(vb);
>  
> @@ -2286,6 +2293,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  	 */
>  	__vb2_queue_cancel(q);
>  	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> +	q->last_buffer_dequeued = false;
>  
>  	dprintk(3, "successful\n");
>  	return 0;
> @@ -2628,8 +2636,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
>  		return res | POLLOUT | POLLWRNORM;
>  
> -	if (list_empty(&q->done_list))
> +	if (list_empty(&q->done_list)) {
> +		/*
> +		 * If the last buffer was dequeued from a capture queue,
> +		 * return immediately. DQBUF will return -EPIPE.
> +		 */
> +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && q->last_buffer_dequeued)
> +			return res | POLLIN | POLLRDNORM;
> +
>  		poll_wait(file, &q->done_wq, wait);
> +	}
>  
>  	/*
>  	 * Take first buffer available for dequeuing.
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bd2cec2..ca337bf 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -429,6 +429,7 @@ struct vb2_queue {
>  	unsigned int			start_streaming_called:1;
>  	unsigned int			error:1;
>  	unsigned int			waiting_for_buffers:1;
> +	unsigned int			last_buffer_dequeued:1;
>  
>  	struct vb2_fileio_data		*fileio;
>  	struct vb2_threadio_data	*threadio;
> 

