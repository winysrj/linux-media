Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41076 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbeHTPRU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 11:17:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] uvcvideo: rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
Date: Mon, 20 Aug 2018 15:02:53 +0300
Message-ID: <2137438.JYWfeMsUUX@avalon>
In-Reply-To: <alpine.DEB.2.20.1808031334440.13762@axis700.grange>
References: <alpine.DEB.2.20.1808031334440.13762@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Friday, 3 August 2018 14:36:56 EEST Guennadi Liakhovetski wrote:
> This macro defines "information about quirks," not "quirks for
> information."
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree.

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index d46dc43..699984b 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2344,7 +2344,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .quirks = UVC_QUIRK_FORCE_Y8,
>  };
> 
> -#define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks
> = q} +#define UVC_INFO_QUIRK(q) (kernel_ulong_t)&(struct
> uvc_device_info){.quirks = q}
> 
>  /*
>   * The Logitech cameras listed below have their interface class set to
> @@ -2453,7 +2453,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
>  	/* Chicony CNF7129 (Asus EEE 100HE) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> 
> @@ -2462,7 +2462,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_RESTRICT_FRAME_RATE) },
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTRICT_FRAME_RATE) },
>  	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> 
> @@ -2525,7 +2525,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> 
>  					| UVC_QUIRK_BUILTIN_ISIGHT) },
> 
>  	/* Apple Built-In iSight via iBridge */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2607,7 +2607,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> 
>  					| UVC_QUIRK_PROBE_DEF) },
> 
>  	/* IMC Networks (Medion Akoya) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2707,7 +2707,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> 
>  					| UVC_QUIRK_PROBE_EXTRAFIELDS) },
> 
>  	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> @@ -2725,7 +2725,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_EXTRAFIELDS) },
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_EXTRAFIELDS) },
>  	/* Manta MM-353 Plako */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> 
> @@ -2771,7 +2771,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_STATUS_INTERVAL) },
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_STATUS_INTERVAL) },
>  	/* MSI StarCam 370i */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> 
> @@ -2798,7 +2798,7 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp) .bInterfaceClass	= USB_CLASS_VIDEO,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
> -	  .driver_info		= UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> 
>  					| UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
> 
>  	/* Oculus VR Positional Tracker DK2 */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE


-- 
Regards,

Laurent Pinchart
