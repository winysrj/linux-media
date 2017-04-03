Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35160 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753898AbdDCQJG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:09:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH] uvcvideo: don't recode timespec_sub
Date: Mon, 03 Apr 2017 19:09:50 +0300
Message-ID: <2210310.yWRiF79inX@avalon>
In-Reply-To: <1491218732-12068-1-git-send-email-kbingham@kernel.org>
References: <1491218732-12068-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday 03 Apr 2017 12:25:31 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> The statistics function subtracts two timespecs manually. A helper is
> provided by the kernel to do this.
> 
> Replace the implementation, using the helper.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 7777ed24908b..cff02c6df1b8 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -868,14 +868,8 @@ size_t uvc_video_stats_dump(struct uvc_streaming
> *stream, char *buf, struct timespec ts;
>  	size_t count = 0;
> 
> -	ts.tv_sec = stream->stats.stream.stop_ts.tv_sec
> -		  - stream->stats.stream.start_ts.tv_sec;
> -	ts.tv_nsec = stream->stats.stream.stop_ts.tv_nsec
> -		   - stream->stats.stream.start_ts.tv_nsec;
> -	if (ts.tv_nsec < 0) {
> -		ts.tv_sec--;
> -		ts.tv_nsec += 1000000000;
> -	}
> +	ts = timespec_sub(stream->stats.stream.stop_ts,
> +			  stream->stats.stream.start_ts);
> 
>  	/* Compute the SCR.SOF frequency estimate. At the nominal 1kHz SOF
>  	 * frequency this will not overflow before more than 1h.

-- 
Regards,

Laurent Pinchart
