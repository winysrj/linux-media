Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3551 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaCAO2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 09:28:32 -0500
Message-ID: <5311EE75.1000305@xs4all.nl>
Date: Sat, 01 Mar 2014 15:28:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6 06/10] v4l: Handle buffer timestamp flags correctly
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi> <1393679828-25878-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-7-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I believe this needs some more work. See comments below:

On 03/01/2014 02:17 PM, Sakari Ailus wrote:
> For COPY timestamps, buffer timestamp source flags will traverse the queue
> untouched.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 3dda083..7afeb6b 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -488,7 +488,22 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  	 * Clear any buffer state related flags.
>  	 */
>  	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> -	b->flags |= q->timestamp_flags;
> +	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +		/*
> +		 * For COPY timestamps, we just set the timestamp type
> +		 * here. The timestamp source is already in b->flags.
> +		 */
> +		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
> +	} else {
> +		/*
> +		 * For non-COPY timestamps, drop timestamp source and
> +		 * obtain the timestamp type and source from the
> +		 * queue.
> +		 */
> +		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +		b->flags |= q->timestamp_flags;
> +	}

It's correct, but I would do it a bit differently:

	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
		/*
		 * For non-COPY timestamps, drop timestamp source and
		 * obtain the timestamp type and source from the
		 * queue.
		 */
		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
	}

That way it is clearer that the timestamp type is always set and that it is
just the timestamp source that has special handling.


>  
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_QUEUED:
> @@ -1031,6 +1046,15 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  
>  	/* Zero flags that the vb2 core handles */
>  	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> +	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +		/*
> +		 * Non-COPY timestamps will get their timestamp and
> +		 * timestamp source flags from the queue.
> +		 */
> +		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}

This should be:

	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {

Capture buffers also need to clear the TSTAMP_SRC flags as they will get it
from the output queue. In other words: capture buffers never set the timestamp
source flags, only output buffers can do that if timestamps are copied.

As an aside: the more I think about it, the more I believe that we're not quite
doing the right thing when it comes to copying timestamps. The problem is that
TIMESTAMP_COPY is part of the timestamp type mask. It should be a separate bit.
That way output buffers supply both type and source, and capture buffers give
those back to the application. Right now you can't copy the timestamp type since
COPY is part of those types.

We did not really think that through.

Regards,

	Hans

> +
>  	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>  		/*
>  		 * For output buffers mask out the timecode flag:
> 
