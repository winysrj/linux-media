Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53245 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753500AbdJPPHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 11:07:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Yang <hansy@nvidia.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH resend] [media] uvcvideo: zero seq number when disabling stream
Date: Mon, 16 Oct 2017 18:08:12 +0300
Message-ID: <2456831.iuhP316MQr@avalon>
In-Reply-To: <1505456871-12680-1-git-send-email-hansy@nvidia.com>
References: <1505456871-12680-1-git-send-email-hansy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

(CC'ing Guennadi Liakhovetski)

Thank you for the patch.

On Friday, 15 September 2017 09:27:51 EEST Hans Yang wrote:
> For bulk-based devices, when disabling the video stream,
> in addition to issue CLEAR_FEATURE(HALT), it is better to set
> alternate setting 0 as well or the sequnce number in host
> side will probably not reset to zero.

The USB 2.0 specificatin states in the description of the SET_INTERFACE 
request that "If a device only supports a default setting for the specified 
interface, then a STALL may be returned in the Status stage of the request".

The Linux implementation of usb_set_interface() deals with this by handling 
STALL conditions and manually clearing HALT for all endpoints in the 
interface, but I'm still concerned that this change could break existing bulk-
based cameras. Do you know what other operating systems do when disabling the 
stream on bulk cameras ? According to a comment in the driver Windows calls 
CLEAR_FEATURE(HALT), but the situation might have changed since that was 
tested.

Guennadi, how do your bulk-based cameras handle this ?

> Then in next time video stream start, the device will expect
> host starts packet from 0 sequence number but host actually
> continue the sequence number from last transaction and this
> causes transaction errors.

Do you mean the DATA0/DATA1 toggle ? Why does the host continue toggling the 
PID from the last transation ? The usb_clear_halt() function calls 
usb_reset_endpoint() which should reset the DATA PID toggle.

> This commit fixes this by adding set alternate setting 0 back
> as what isoch-based devices do.
> 
> Below error message will also be eliminated for some devices:
> uvcvideo: Non-zero status (-71) in video completion handler.
> 
> Signed-off-by: Hans Yang <hansy@nvidia.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index fb86d6af398d..ad80c2a6da6a 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1862,10 +1862,9 @@ int uvc_video_enable(struct uvc_streaming *stream,
> int enable)
> 
>  	if (!enable) {
>  		uvc_uninit_video(stream, 1);
> -		if (stream->intf->num_altsetting > 1) {
> -			usb_set_interface(stream->dev->udev,
> +		usb_set_interface(stream->dev->udev,
>  					  stream->intfnum, 0);
> -		} else {
> +		if (stream->intf->num_altsetting == 1) {
>  			/* UVC doesn't specify how to inform a bulk-based device
>  			 * when the video stream is stopped. Windows sends a
>  			 * CLEAR_FEATURE(HALT) request to the video streaming

-- 
Regards,

Laurent Pinchart
