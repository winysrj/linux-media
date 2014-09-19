Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4166 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISQzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 12:55:43 -0400
Message-ID: <541C5FFE.3030207@xs4all.nl>
Date: Fri, 19 Sep 2014 18:55:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH] vb2: yet another attempt to fix the vb2/VBI/poll
 regression
References: <541C56A7.5060708@xs4all.nl>
In-Reply-To: <541C56A7.5060708@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2014 06:15 PM, Hans Verkuil wrote:
> After a long discussion on irc the decision was taken that poll() should:
> 
> - return POLLERR when not streaming or when q->error is set
> - return POLLERR when streaming from a capture queue, but no buffers have been
>   queued yet, and it is not part of an M2M device.
> 
> The first rule is logical, the second less so. It emulates vb1 behavior that some
> applications might rely on. It is behavior that we don't want for output devices
> or M2M devices because calling STREAMON without QBUF makes a lot of sense for
> output devices, and for M2M devices I want to avoid causing a regression by
> potentially changing the behavior of M2M capture queues. We don't have legacy apps
> to support there, so let's make sure that those queue types remain unchanged.
> 
> I do that by setting needs_buffers to false in v4l2_m2m_streamon. All M2M drivers
> use that function with the exception of s5p-mfc, but there STREAMON will return
> an error if not enough buffers are queued so it's not able to do STREAMON without
> a QBUF anyway.
> 
> There will be a second version, since I need to update some comments in the header
> and adjust the spec, but I would like to get code reviews as soon as possible.
> 
> Just explaining that second rule makes my head hurt, which is usually a bad sign.
> 
> 	Hans
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 80c588f..c8d2b5b 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -463,6 +463,7 @@ int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  	int ret;
>  
>  	vq = v4l2_m2m_get_vq(m2m_ctx, type);
> +	vq->needs_buffers = false;

I'm going to drop this. Up to 3.16 all vb2 drivers would return POLLERR if
no buffers were queued, so it was standard behavior. That simplifies the patch
a bit.

	Hans

>  	ret = vb2_streamon(vq, type);
>  	if (!ret)
>  		v4l2_m2m_try_schedule(m2m_ctx);
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7e6aff6..efbf1ce 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -977,6 +977,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	 * to the userspace.
>  	 */
>  	req->count = allocated_buffers;
> +	q->needs_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
>  
>  	return 0;
>  }
> @@ -1801,6 +1802,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	 */
>  	list_add_tail(&vb->queued_entry, &q->queued_list);
>  	q->queued_count++;
> +	q->needs_buffers = false;
>  	vb->state = VB2_BUF_STATE_QUEUED;
>  	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
>  		/*
> @@ -2583,10 +2585,18 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	}
>  
>  	/*
> -	 * There is nothing to wait for if no buffer has been queued and the
> -	 * queue isn't streaming, or if the error flag is set.
> +	 * There is nothing to wait for if the queue isn't streaming, or if the
> +	 * error flag is set.
>  	 */
> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
> +	if (!vb2_is_streaming(q) || q->error)
> +		return res | POLLERR;
> +	/*
> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> +	 * return POLLERR as well. This only affects capture queues, output
> +	 * queues will always initialize needs_buffers to false. M2M devices
> +	 * also set needs_buffers to false in v4l2_m2m_streamon().
> +	 */
> +	if (q->needs_buffers)
>  		return res | POLLERR;
>  
>  	/*
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 5a10d8d..1c218b1 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -419,6 +419,7 @@ struct vb2_queue {
>  	unsigned int			streaming:1;
>  	unsigned int			start_streaming_called:1;
>  	unsigned int			error:1;
> +	unsigned int			needs_buffers:1;
>  
>  	struct vb2_fileio_data		*fileio;
>  	struct vb2_threadio_data	*threadio;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

