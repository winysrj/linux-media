Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56683 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbbFJBSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 21:18:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dennis Chen <barracks510@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3 Cameras
Date: Wed, 10 Jun 2015 04:19:24 +0300
Message-ID: <2450709.nghA4lNjjK@avalon>
In-Reply-To: <1433898546.11979.6.camel@gmail.com>
References: <1433879614.3036.3.camel@gmail.com> <3765742.rat6LA2JPE@avalon> <1433898546.11979.6.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dennis,

Thank you for the patch.

On Tuesday 09 June 2015 18:09:06 Dennis Chen wrote:
> Add support for the Microsoft Surface Pro 3 Cameras.

Is this needed ? Looking at the patch your cameras are UVC-compliant and 
should thus be picked by the uvcvideo driver without any change to the code.

> Signed-off-by: Dennis Chen <barracks510@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 5970dd6..ec5a407 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2538,6 +2538,22 @@ static struct usb_device_id uvc_ids[] = {
>           .bInterfaceSubClass   = 1,
>           .bInterfaceProtocol   = 0,
>           .driver_info          = UVC_QUIRK_FORCE_Y8 },
> +       /*Microsoft Surface Pro 3 Front Camera*/
> +       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                               | USB_DEVICE_ID_MATCH_INT_INFO,
> +         .idVendor             = 0x045e,
> +         .idProduct            = 0x07be,
> +         .bInterfaceClass      = USB_CLASS_VIDEO,
> +         .bInterfaceSubClass   = 1,
> +         .bInterfaceProtocol   = 1 },
> +       /* Microsoft Surface Pro 3 Rear */
> +       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                               | USB_DEVICE_ID_MATCH_INT_INFO,
> +         .idVendor             = 0x045e,
> +         .idProduct            = 0x07bf,
> +         .bInterfaceClass      = USB_CLASS_VIDEO,
> +         .bInterfaceSubClass   = 1,
> +         .bInterfaceProtocol   = 1 },
>         /* Generic USB Video Class */
>         { USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
>         {}

-- 
Regards,

Laurent Pinchart

