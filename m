Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3141 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaCBHMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 02:12:32 -0500
Message-ID: <5312D9CC.3030505@xs4all.nl>
Date: Sun, 02 Mar 2014 08:12:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6.1 06/10] v4l: Handle buffer timestamp flags correctly
References: <5311EE75.1000305@xs4all.nl> <1393693166-9624-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393693166-9624-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 03/01/2014 05:59 PM, Sakari Ailus wrote:
> For COPY timestamps, buffer timestamp source flags will traverse the queue
> untouched.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> changes since v6:
> - Clean up changes to __fill_v4l2_buffer().
> - Drop timestamp source flags for non-OUTPUT buffers in __fill_vb2_buffer().
> - Comments fixed accordingly.
> 
>  drivers/media/v4l2-core/videobuf2-core.c |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 42a8568..79eb9ba 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -488,7 +488,16 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  	 * Clear any buffer state related flags.
>  	 */
>  	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> -	b->flags |= q->timestamp_flags;
> +	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
> +	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +		/*
> +		 * For non-COPY timestamps, drop timestamp source bits
> +		 * and obtain the timestamp source from the queue.
> +		 */
> +		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}
>  
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_QUEUED:
> @@ -1031,6 +1040,16 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  
>  	/* Zero flags that the vb2 core handles */
>  	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> +	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		/*
> +		 * Non-COPY timestamps and non-OUTPUT queues will get
> +		 * their timestamp and timestamp source flags from the
> +		 * queue.
> +		 */
> +		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}
> +
>  	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>  		/*
>  		 * For output buffers mask out the timecode flag:
> 
