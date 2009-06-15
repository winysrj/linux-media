Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36057 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZFOJxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 05:53:13 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Subject: Re: Fwd: [PATCH 2/2] uvc: Added two webcams with 'No FID' quirk.
Date: Mon, 15 Jun 2009 11:53:08 +0200
Cc: linux-media@vger.kernel.org
References: <b24e53350906120953v7eeb595dpe58ca138dcf438b5@mail.gmail.com>
In-Reply-To: <b24e53350906120953v7eeb595dpe58ca138dcf438b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151153.09783.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 18:53:29 Robert Krakora wrote:
> From: Robert Krakora <rob.krakora@messagenetsystems.com>
>
> Added two webcams with 'No FID' quirk.
>
> Priority: normal
>
> Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>
>
> diff -r bff77ec33116 linux/drivers/media/video/uvc/uvc_driver.c
> --- a/linux/drivers/media/video/uvc/uvc_driver.c        Thu Jun 11
> 18:44:23 2009 -0300
> +++ b/linux/drivers/media/video/uvc/uvc_driver.c        Fri Jun 12
> 11:35:04 2009 -0400
> @@ -1919,6 +1919,24 @@
>           .bInterfaceSubClass   = 1,
>           .bInterfaceProtocol   = 0,
>           .driver_info          = UVC_QUIRK_STREAM_NO_FID },
> +       /* Suyin Corp. HP Webcam */
> +       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                               | USB_DEVICE_ID_MATCH_INT_INFO,
> +         .idVendor             = 0x064e,
> +         .idProduct            = 0xa110,
> +         .bInterfaceClass      = USB_CLASS_VIDEO,
> +         .bInterfaceSubClass   = 1,
> +         .bInterfaceProtocol   = 0,
> +         .driver_info          = UVC_QUIRK_STREAM_NO_FID },
> +       /* Creative Live! Cam Optia AF */
> +       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                               | USB_DEVICE_ID_MATCH_INT_INFO,
> +         .idVendor             = 0x041e,
> +         .idProduct            = 0x406d,
> +         .bInterfaceClass      = USB_CLASS_VIDEO,
> +         .bInterfaceSubClass   = 1,
> +         .bInterfaceProtocol   = 0,
> +         .driver_info          = UVC_QUIRK_STREAM_NO_FID },

NAK. Those cameras have been reported to work without the FID quirk. Please 
double-check. If the quirk is required on your side I'd like to see logs.

Best regards,

Laurent Pinchart

