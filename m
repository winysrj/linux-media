Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2185 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbaEIPur (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 11:50:47 -0400
Message-ID: <536CF92C.8050100@xs4all.nl>
Date: Fri, 09 May 2014 17:50:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] [media] vb2: drop queued buffers while q->start_streaming_called
 is still set
References: <1399649540-20943-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1399649540-20943-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/2014 05:32 PM, Philipp Zabel wrote:
> Otherwise yet another warning will trigger in vb2_buffer_done.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Duplicate of: https://patchwork.linuxtv.org/patch/23723/

I'm setting your patch to superseded in patchwork.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 4d4f6ba..bdca528 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2088,8 +2088,6 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	if (q->start_streaming_called)
>  		call_void_qop(q, stop_streaming, q);
>  	q->streaming = 0;
> -	q->start_streaming_called = 0;
> -	q->queued_count = 0;
>  
>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>  		for (i = 0; i < q->num_buffers; ++i)
> @@ -2098,6 +2096,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  		/* Must be zero now */
>  		WARN_ON(atomic_read(&q->owned_by_drv_count));
>  	}
> +	q->start_streaming_called = 0;
> +	q->queued_count = 0;
>  
>  	/*
>  	 * Remove all buffers from videobuf's list...
> 

