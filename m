Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2676 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaGWGBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 02:01:05 -0400
Message-ID: <53CF4F94.9090905@xs4all.nl>
Date: Wed, 23 Jul 2014 08:00:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2: don't warn before we release buffer
References: <1406174011-13600-1-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1406174011-13600-1-git-send-email-scott.jiang.linux@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2014 05:53 AM, Scott Jiang wrote:
> In fact we only need to give a warning if the driver still use the
> buffer after we release all queued buffers.
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

You're removing the warning telling you that your driver has a bug instead
of fixing the driver bug itself. In stop_streaming the driver must hand over
any buffers it owns to vb2 (vb2_buffer_done(..., STATE_ERROR)). If it doesn't
you'll get this warning and vb2 will forcefully reclaim them, quite possibly
leaving the driver with a corrupt buffer list.

The same should occur in start_streaming if an error occurs. In that case
start_streaming must return the buffers to STATE_DEQUEUED.

So fix your driver instead :-)

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7c4489c..fa5dd73 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2112,7 +2112,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	if (q->start_streaming_called)
>  		call_void_qop(q, stop_streaming, q);
>  
> -	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
> +	if (atomic_read(&q->owned_by_drv_count)) {
>  		for (i = 0; i < q->num_buffers; ++i)
>  			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>  				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
> 

