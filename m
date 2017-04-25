Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58364 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176720AbdDYLy6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 07:54:58 -0400
Subject: Re: [git:media_tree/master] [media] uvcvideo: Don't record
 timespec_sub
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <E1cxWsU-0008R8-DB@www.linuxtv.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <df8b9c7b-d1b8-93b5-d9e9-a7933d024c19@ideasonboard.com>
Date: Tue, 25 Apr 2017 12:54:54 +0100
MIME-Version: 1.0
In-Reply-To: <E1cxWsU-0008R8-DB@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On 10/04/17 11:42, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued:
> 
> Subject: [media] uvcvideo: Don't record timespec_sub

In my submission, this subject line was "uvcvideo: Don't recode timespec_sub"

I don't believe we are 'recording' timespec_sub.

I suspect it is too late to fix now.

--
Regards

Kieran



> Author:  Kieran Bingham <kieran.bingham@ideasonboard.com>
> Date:    Mon Apr 3 08:25:31 2017 -0300
> 
> The statistics function subtracts two timespecs manually. A helper is
> provided by the kernel to do this.
> 
> Replace the implementation, using the helper.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
>  drivers/media/usb/uvc/uvc_video.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> ---
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 128c0a7826ce..47d93a938dde 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -868,14 +868,8 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
>  	struct timespec ts;
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
> 
