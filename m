Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49190 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdBJHvh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 02:51:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: usb: uvc:  add a quirk for Generalplus Technology Inc. 808 Camera
Date: Fri, 10 Feb 2017 09:51:56 +0200
Message-ID: <3738332.DuyL28vVhe@avalon>
In-Reply-To: <1486646806-8217-1-git-send-email-narmstrong@baylibre.com>
References: <1486646806-8217-1-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thank you for the patch.

On Thursday 09 Feb 2017 14:26:46 Neil Armstrong wrote:
> As reported on [1], this device needs this quirk to be able to
> reliably initialise the webcam.
> 
> [1] https://sourceforge.net/p/linux-uvc/mailman/message/33791098/
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I'll send a pull request for v4.12.

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 04bf350..6b2d761 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2671,6 +2671,15 @@ static int uvc_clock_param_set(const char *val,
> struct kernel_param *kp) .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
> +	/* Generalplus Technology Inc. 808 Camera */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x1b3f,
> +	  .idProduct		= 0x2002,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
>  	/* SiGma Micro USB Web Camera */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart

