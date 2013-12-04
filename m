Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44194 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDBPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 20:15:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 1/9] vb2: push the mmap semaphore down to __buf_prepare()
Date: Wed, 04 Dec 2013 02:15:52 +0100
Message-ID: <2001434.ZTVRbYTb7A@avalon>
In-Reply-To: <529DA74E.6080902@xs4all.nl>
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl> <1515245.TOT59KTYAx@avalon> <529DA74E.6080902@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 03 December 2013 10:41:34 Hans Verkuil wrote:
> On 11/29/13 19:16, Laurent Pinchart wrote:
> > On Friday 29 November 2013 10:58:36 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Rather than taking the mmap semaphore at a relatively high-level
> >> function, push it down to the place where it is really needed.
> >> 
> >> It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
> >> vb2 calls. The only way I can see that a race can happen is when two
> >> threads queue the same buffer. The solution for that it to introduce
> >> a PREPARING state.
> > 
> > This looks better to me, but what about a vb2_reqbufs(0) call being
> > processed during the time window where we release the queue mutex ?
> 
> You have a nasty mind.

I wonder how I should take that :-)

> That can still go wrong, but note that this is true for the existing code as
> well as far as I can tell.

Yes, that's right.

> How about this patch to fix this race?
> 
> It just refuses to free buffers if any of them is in the preparing state.
> It returns EAGAIN in that case (or would EBUSY be better?).

I would have argued that applications might not be prepared to handle such an 
error when calling REQBUFS(0), but they shouldn't trigger that in the first 
place anyway. The patch looks good to me.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 2aff646..c3ff993 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -284,10 +284,28 @@ static void __vb2_free_mem(struct vb2_queue *q,
> unsigned int buffers) * related information, if no buffers are left return
> the queue to an * uninitialized state. Might be called even if the queue
> has already been freed. */
> -static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
> +static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>  {
>  	unsigned int buffer;
> 
> +	/*
> +	 * Sanity check: when preparing a buffer the queue lock is released for
> +	 * a short while (see __buf_prepare for the details), which would allow
> +	 * a race with a reqbufs which can call this function. Removing the
> +	 * buffers from underneath __buf_prepare is obviously a bad idea, so we
> +	 * check if any of the buffers is in the state PREPARING, and if so we
> +	 * just return -EAGAIN.
> +	 */
> +	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
> +	     ++buffer) {
> +		if (q->bufs[buffer] == NULL)
> +			continue;
> +		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
> +			dprintk(1, "reqbufs: preparing buffers, cannot free\n");
> +			return -EAGAIN;
> +		}
> +	}
> +
>  	/* Call driver-provided cleanup function for each buffer, if provided */
>  	if (q->ops->buf_cleanup) {
>  		for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
> @@ -312,6 +330,7 @@ static void __vb2_queue_free(struct vb2_queue *q,
> unsigned int buffers) if (!q->num_buffers)
>  		q->memory = 0;
>  	INIT_LIST_HEAD(&q->queued_list);
> +	return 0;
>  }
> 
>  /**
> @@ -644,7 +663,9 @@ static int __reqbufs(struct vb2_queue *q, struct
> v4l2_requestbuffers *req) return -EBUSY;
>  		}
> 
> -		__vb2_queue_free(q, q->num_buffers);
> +		ret = __vb2_queue_free(q, q->num_buffers);
> +		if (ret)
> +			return ret;
> 
>  		/*
>  		 * In case of REQBUFS(0) return immediately without calling
-- 
Regards,

Laurent Pinchart

