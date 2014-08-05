Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34736 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaHEW5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 18:57:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] uvcvideo: Add quirk to force the Oculus DK2 IR tracker to grayscale
Date: Wed, 06 Aug 2014 00:57:50 +0200
Message-ID: <7469726.37hXtroWo1@avalon>
In-Reply-To: <1407182535-7622-1-git-send-email-philipp.zabel@gmail.com>
References: <1407182535-7622-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday 04 August 2014 22:02:15 Philipp Zabel wrote:
> This patch adds a quirk to force Y8 pixel format even if the camera reports
> half-width YUYV.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
> The Oculus Rift DK2 comes with an IR webcam that lies about the pixel
> format and frame size it produces. This is a quick hack to make it
> produce proper greyscale images.

I wish webcam vendors could get the firmware right... *sigh*



> ---
>  drivers/media/usb/uvc/uvc_driver.c | 19 +++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index f8135f4..322a674 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -352,6 +352,10 @@ static int uvc_parse_format(struct uvc_device *dev,
> 
>  		/* Find the format descriptor from its GUID. */
>  		fmtdesc = uvc_format_by_guid(&buffer[5]);
> +		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
> +			WARN_ON(!fmtdesc || fmtdesc->fcc != V4L2_PIX_FMT_YUYV);

I don't think this deserves a full WARN_ON, just a warning message should do.

> +			fmtdesc = &uvc_fmts[9];

Do we have to force all formats to Y8, or should we only force 
V4L2_PIX_FMT_YUYV ? To put it differently, could we have cameras that 
implement different formats and for which only YUYV is incorrect ?

Ideally I'd like a more versatile format override mechanism, not just an ad-
hoc quirk, but the overheard is probably too big given the problem at hand. We 
can delay that to the next format-related quirk.

> +		}
> 
>  		if (fmtdesc != NULL) {
>  			strlcpy(format->name, fmtdesc->name,
> @@ -366,6 +370,10 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		}
> 
>  		format->bpp = buffer[21];
> +		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
> +			WARN_ON(format->bpp != 16);

Same here.

> +			format->bpp /= 2;
> +		}
>  		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
>  			ftype = UVC_VS_FRAME_UNCOMPRESSED;
>  		} else {
> @@ -475,6 +483,8 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		frame->bFrameIndex = buffer[3];
>  		frame->bmCapabilities = buffer[4];
>  		frame->wWidth = get_unaligned_le16(&buffer[5]);
> +		if (dev->quirks & UVC_QUIRK_FORCE_Y8)
> +			frame->wWidth *= 2;
>  		frame->wHeight = get_unaligned_le16(&buffer[7]);
>  		frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
>  		frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
> @@ -2486,6 +2496,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
> 
>  				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
> 
> +	/* Oculus VR Positional Tracker DK2 */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x2833,
> +	  .idProduct		= 0x0201,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
>  	/* Generic USB Video Class */
>  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
>  	{}
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index b1f69a6..1252040 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -147,6 +147,7 @@
>  #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
>  #define UVC_QUIRK_PROBE_DEF		0x00000100
>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> +#define UVC_QUIRK_FORCE_Y8		0x00000400
> 
>  /* Format flags */
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001

-- 
Regards,

Laurent Pinchart

