Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35183 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753585AbdDCQJd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:09:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH] uvcvideo: Fix empty packet statistic
Date: Mon, 03 Apr 2017 19:10:13 +0300
Message-ID: <2233324.kYs3IlRQ2o@avalon>
In-Reply-To: <1491218732-12068-2-git-send-email-kbingham@kernel.org>
References: <1491218732-12068-2-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday 03 Apr 2017 12:25:32 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> The frame counters are inadvertently counting packets with content as
> empty.
> 
> Fix it by correcting the logic expression
> 
> Fixes: 7bc5edb00bbd [media] uvcvideo: Extract video stream statistics
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 075a0fe77485..7777ed24908b 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -818,7 +818,7 @@ static void uvc_video_stats_decode(struct uvc_streaming
> *stream,
> 
>  	/* Update the packets counters. */
>  	stream->stats.frame.nb_packets++;
> -	if (len > header_size)
> +	if (len <= header_size)
>  		stream->stats.frame.nb_empty++;
> 
>  	if (data[1] & UVC_STREAM_ERR)

-- 
Regards,

Laurent Pinchart
