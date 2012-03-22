Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62339 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2CVMhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 08:37:22 -0400
Received: by bkcik5 with SMTP id ik5so1697910bkc.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 05:37:20 -0700 (PDT)
Message-ID: <4F6B1CAB.9090903@mvista.com>
Date: Thu, 22 Mar 2012 16:35:55 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Bhupesh Sharma <bhupesh.sharma@st.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, spear-devel@list.st.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer'
 routine
References: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
In-Reply-To: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 22-03-2012 8:50, Bhupesh Sharma wrote:

> This patch removes the non-required spinlock acquire/release calls on
> 'queue_irqlock' from 'uvc_queue_next_buffer' routine.

    'queue->irqlock' maybe?

> This routine is called from 'video->encode' function (which translates to either
> 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
> As, the 'video->encode' routines are called with 'queue_irqlock' already held,
> so acquiring a 'queue_irqlock' again in 'uvc_queue_next_buffer' routine causes
> a spin lock recursion.

> Signed-off-by: Bhupesh Sharma<bhupesh.sharma@st.com>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/usb/gadget/uvc_queue.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index d776adb..104ae9c 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -543,11 +543,11 @@ done:
>   	return ret;
>   }
>
> +/* called with &queue_irqlock held.. */

    'queue->irqlock' maybe?

> @@ -556,14 +556,12 @@ uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
>   		return buf;
>   	}
>
> -	spin_lock_irqsave(&queue->irqlock, flags);
>   	list_del(&buf->queue);
>   	if (!list_empty(&queue->irqqueue))
>   		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
>   					   queue);
>   	else
>   		nextbuf = NULL;
> -	spin_unlock_irqrestore(&queue->irqlock, flags);
>
>   	buf->buf.sequence = queue->sequence++;
>   	do_gettimeofday(&buf->buf.timestamp);

WBR, Sergei
