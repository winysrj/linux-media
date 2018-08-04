Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38116 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbeHDR73 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 13:59:29 -0400
Received: by mail-qk0-f195.google.com with SMTP id 126-v6so6134031qke.5
        for <linux-media@vger.kernel.org>; Sat, 04 Aug 2018 08:58:21 -0700 (PDT)
Message-ID: <0121adf26dc5df64a3955253795dc2e04610b1b5.camel@ndufresne.ca>
Subject: Re: [PATCH v2 1/2] uvcvideo: rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 04 Aug 2018 11:58:18 -0400
In-Reply-To: <alpine.DEB.2.20.1808031334440.13762@axis700.grange>
References: <alpine.DEB.2.20.1808031334440.13762@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 03 août 2018 à 13:36 +0200, Guennadi Liakhovetski a écrit :
> This macro defines "information about quirks," not "quirks for
> information."

Does not sound better to me. It's "Quirk's information", vs
"information about quirks". I prefer the first one. In term of C
namespace the orignal is also better. So the name space is UVC_QUIRK,
and the detail is INFO.

If we where to apply your logic, you'd rename driver_info, into
info_driver, because it's information about the driver.

> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com
> >
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c
> index d46dc43..699984b 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2344,7 +2344,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	.quirks = UVC_QUIRK_FORCE_Y8,
>  };
>  
> -#define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct
> uvc_device_info){.quirks = q}
> +#define UVC_INFO_QUIRK(q) (kernel_ulong_t)&(struct
> uvc_device_info){.quirks = q}
>  
>  /*
>   * The Logitech cameras listed below have their interface class set
> to
> @@ -2453,7 +2453,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
>  	/* Chicony CNF7129 (Asus EEE 100HE) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> @@ -2462,7 +2462,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_RESTRICT_FRAME_RATE) },
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_RESTRICT_FRAME_RATE) },
>  	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> @@ -2525,7 +2525,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
>  					| UVC_QUIRK_BUILTIN_ISIGHT) },
>  	/* Apple Built-In iSight via iBridge */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2607,7 +2607,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
>  					| UVC_QUIRK_PROBE_DEF) },
>  	/* IMC Networks (Medion Akoya) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2707,7 +2707,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
>  					| UVC_QUIRK_PROBE_EXTRAFIELDS)
> },
>  	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2725,7 +2725,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_PROBE_EXTRAFIELDS) },
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_PROBE_EXTRAFIELDS) },
>  	/* Manta MM-353 Plako */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> @@ -2771,7 +2771,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_STATUS_INTERVAL) },
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_STATUS_INTERVAL) },
>  	/* MSI StarCam 370i */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> @@ -2798,7 +2798,7 @@ static int uvc_clock_param_set(const char *val,
> const struct kernel_param *kp)
>  	  .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		=
> UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		=
> UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
>  					|
> UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
>  	/* Oculus VR Positional Tracker DK2 */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
