Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47662 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877AbbGCKuS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 06:50:18 -0400
Message-ID: <559668BF.4020905@xs4all.nl>
Date: Fri, 03 Jul 2015 12:49:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com
Subject: Re: [PATCH 1/1] vb2: Only requeue buffers immediately once streaming
 is started
References: <1435918810-21180-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1435918810-21180-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2015 12:20 PM, Sakari Ailus wrote:
> Buffers can be returned back to videobuf2 in driver's streamon handler. In
> this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
> cause the driver's buf_queue vb2 operation to be called, queueing the same
> buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
> on.
> 
> Instead of using q->start_streamin_called to judge whether to return the
> buffer to the driver immediately, use q->streaming which is set only after
> the driver's start_streaming() vb2 operation is called.

I don't think this patch will work. If q->min_buffers_needed is > 0, then
q->streaming and q->start_streaming_called will both be true in vb2_buffer_done(),
still causing the same issue.

The problem is that there is no clear distinction between STATE_QUEUED as used
in start_streaming and STATE_QUEUED as used to requeue a buffer while streaming.

The best option here I think is to introduce a STATE_REQUEUE for the second use
case.

Regards,

	Hans

> 
> Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org # for v4.1
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 1a096a6..6957078 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1208,7 +1208,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	spin_unlock_irqrestore(&q->done_lock, flags);
>  
>  	if (state == VB2_BUF_STATE_QUEUED) {
> -		if (q->start_streaming_called)
> +		if (q->streaming)
>  			__enqueue_in_driver(vb);
>  		return;
>  	}
> 

