Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50288 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031375Ab2COAqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 20:46:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	spear-devel@list.st.com
Subject: Re: [PATCH RESEND] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine
Date: Thu, 15 Mar 2012 01:47:15 +0100
Message-ID: <11788268.pQ7t4NVJy6@avalon>
In-Reply-To: <d5dbc7befb35abdce18d77f918954137a2be2f26.1331638300.git.bhupesh.sharma@st.com>
References: <d5dbc7befb35abdce18d77f918954137a2be2f26.1331638300.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

Thank you for the patch.

On Tuesday 13 March 2012 17:04:01 Bhupesh Sharma wrote:
> This patch removes the non-required spinlock acquire/release calls on
> 'queue_irqlock' from 'uvc_queue_next_buffer' routine.
> 
> This routine is called from 'video->encode' function (which translates to
> either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> 'uvc_video.c'. As, the 'video->encode' routines are called with
> 'queue_irqlock' already held, so acquiring a 'queue_irqlock' again in
> 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> 
> A sample kernel crash log is given below (as observed on using 'g_webcam'
> with DWC designware 2.0 UDC):
> 
> Kernel crash log:
> -----------------

[snip]

I don't think you need to include the complete crash report in the commit 
message, the above description should be enough.

> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This should probably go in through the USB tree. Could you please either send 
a pull request or make sure the patch is picked up (after modifying the commit 
message if you agree with my comment) ?

> ---
>  drivers/usb/gadget/uvc_queue.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index d776adb..104ae9c 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -543,11 +543,11 @@ done:
>  	return ret;
>  }
> 
> +/* called with &queue_irqlock held.. */
>  static struct uvc_buffer *
>  uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer
> *buf) {
>  	struct uvc_buffer *nextbuf;
> -	unsigned long flags;
> 
>  	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
>  	    buf->buf.length != buf->buf.bytesused) {
> @@ -556,14 +556,12 @@ uvc_queue_next_buffer(struct uvc_video_queue *queue,
> struct uvc_buffer *buf) return buf;
>  	}
> 
> -	spin_lock_irqsave(&queue->irqlock, flags);
>  	list_del(&buf->queue);
>  	if (!list_empty(&queue->irqqueue))
>  		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
>  					   queue);
>  	else
>  		nextbuf = NULL;
> -	spin_unlock_irqrestore(&queue->irqlock, flags);
> 
>  	buf->buf.sequence = queue->sequence++;
>  	do_gettimeofday(&buf->buf.timestamp);

-- 
Regards,

Laurent Pinchart

