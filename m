Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4969 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaC1QLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:11:40 -0400
Message-ID: <53359F26.9050004@xs4all.nl>
Date: Fri, 28 Mar 2014 17:11:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-usb@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH v2 2/3] usb: gadget: uvc: Set the V4L2 buffer field to
 V4L2_FIELD_NONE
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com> <1396022568-6794-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396022568-6794-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2014 05:02 PM, Laurent Pinchart wrote:
> The UVC gadget driver doesn't support interlaced video but left the
> buffer field uninitialized. Set it to V4L2_FIELD_NONE.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/usb/gadget/uvc_queue.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index 9ac4ffe1..305eb49 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -380,6 +380,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  	else
>  		nextbuf = NULL;
>  
> +	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
>  	buf->buf.v4l2_buf.sequence = queue->sequence++;
>  	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
>  
> 

