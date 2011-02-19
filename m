Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1BSMf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 07:35:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH] uvcvideo: Fix uvc_fixup_video_ctrl() format search
Date: Sat, 19 Feb 2011 13:35:54 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1296180273.17673.5.camel@svmlwks101>
In-Reply-To: <1296180273.17673.5.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102191335.54479.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Friday 28 January 2011 03:04:33 Stephan Lachowsky wrote:
> The scheme used to index format in uvc_fixup_video_ctrl() is not robust:
> format index is based on descriptor ordering, which does not necessarily
> match bFormatIndex ordering.  Searching for first matching format will
> prevent uvc_fixup_video_ctrl() from using the wrong format/frame to make
> adjustments.

Thanks for the patch. It's missing your Signed-off-by line, can I add it ?

> ---
>  drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_video.c
> b/drivers/media/video/uvc/uvc_video.c index 5673d67..545c029 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -89,15 +89,19 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query,
> __u8 unit, static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl)
>  {
> -	struct uvc_format *format;
> +	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame = NULL;
>  	unsigned int i;
> 
> -	if (ctrl->bFormatIndex <= 0 ||
> -	    ctrl->bFormatIndex > stream->nformats)
> -		return;
> +	for (i = 0; i < stream->nformats; ++i) {
> +		if (stream->format[i].index == ctrl->bFormatIndex) {
> +			format = &stream->format[i];
> +			break;
> +		}
> +	}
> 
> -	format = &stream->format[ctrl->bFormatIndex - 1];
> +	if (format == NULL)
> +		return;
> 
>  	for (i = 0; i < format->nframes; ++i) {
>  		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {

-- 
Regards,

Laurent Pinchart
