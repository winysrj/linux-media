Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3328 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaDVL6N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 07:58:13 -0400
Message-ID: <53565947.3010002@xs4all.nl>
Date: Tue, 22 Apr 2014 13:57:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: vb2: Avoid double WARN_ON when stopping streaming
References: <1398038141-26572-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398038141-26572-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/2014 01:55 AM, Laurent Pinchart wrote:
> The __vb2_queue_cancel function marks the queue as not streaming and
> then WARNs when buffers are still owned by the driver. It proceeds to
> complete all active buffers by calling vb2_buffer_done with the new
> buffer state set to VB2_BUF_STATE_ERROR in that case. This triggers
> another WARN_ON due to as new state not being VB2_BUF_STATE_QUEUED while
> the queue is not streaming.
> 
> Check buffer ownership and complete all active buffers before marking
> the queue as not streaming to avoid the double WARN_on.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 6ab13b7..ab88c09 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2028,9 +2028,6 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	 */
>  	if (q->start_streaming_called)
>  		call_qop(q, stop_streaming, q);
> -	q->streaming = 0;
> -	q->start_streaming_called = 0;
> -	q->queued_count = 0;
>  
>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>  		for (i = 0; i < q->num_buffers; ++i)
> @@ -2040,6 +2037,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  		WARN_ON(atomic_read(&q->owned_by_drv_count));
>  	}
>  
> +	q->streaming = 0;
> +	q->start_streaming_called = 0;
> +	q->queued_count = 0;
> +
>  	/*
>  	 * Remove all buffers from videobuf's list...
>  	 */
> 

