Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2668 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaC1QL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:11:29 -0400
Message-ID: <53359F1A.6000700@xs4all.nl>
Date: Fri, 28 Mar 2014 17:11:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-usb@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH v2 1/3] usb: gadget: uvc: Switch to monotonic clock for
 buffer timestamps
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com> <1396022568-6794-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396022568-6794-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2014 05:02 PM, Laurent Pinchart wrote:
> The wall time clock isn't useful for applications as it can jump around
> due to time adjustement. Switch to the monotonic clock.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/usb/gadget/uvc_queue.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> Changes since v1:
> 
> - Replace ktime_get_ts() with v4l2_get_timestamp()
> 
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index 0bb5d50..9ac4ffe1 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -20,6 +20,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
>  
> +#include <media/v4l2-common.h>
>  #include <media/videobuf2-vmalloc.h>
>  
>  #include "uvc.h"
> @@ -379,14 +380,8 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  	else
>  		nextbuf = NULL;
>  
> -	/*
> -	 * FIXME: with videobuf2, the sequence number or timestamp fields
> -	 * are valid only for video capture devices and the UVC gadget usually
> -	 * is a video output device. Keeping these until the specs are clear on
> -	 * this aspect.
> -	 */
>  	buf->buf.v4l2_buf.sequence = queue->sequence++;
> -	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
> +	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
>  
>  	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
>  	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> 

