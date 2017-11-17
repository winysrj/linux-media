Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59960 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933430AbdKQOcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:32:53 -0500
Subject: Re: [PATCH] media: usbvision: remove unneeded DRIVER_LICENSE #define
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20171117141826.GC17880@kroah.com>
Cc: Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cca54dd4-c4f2-639d-54ba-595cf6d68be8@xs4all.nl>
Date: Fri, 17 Nov 2017 15:32:50 +0100
MIME-Version: 1.0
In-Reply-To: <20171117141826.GC17880@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/11/17 15:18, Greg Kroah-Hartman wrote:
> There is no need to #define the license of the driver, just put it in
> the MODULE_LICENSE() line directly as a text string.
> 
> This allows tools that check that the module license matches the source
> code license to work properly, as there is no need to unwind the
> unneeded dereference.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/usb/usbvision/usbvision-video.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
> index 960272d3c924..0f5954a1fea2 100644
> --- a/drivers/media/usb/usbvision/usbvision-video.c
> +++ b/drivers/media/usb/usbvision/usbvision-video.c
> @@ -72,7 +72,6 @@
>  #define DRIVER_NAME "usbvision"
>  #define DRIVER_ALIAS "USBVision"
>  #define DRIVER_DESC "USBVision USB Video Device Driver for Linux"
> -#define DRIVER_LICENSE "GPL"
>  #define USBVISION_VERSION_STRING "0.9.11"
>  
>  #define	ENABLE_HEXDUMP	0	/* Enable if you need it */
> @@ -141,7 +140,7 @@ MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1
>  /* Misc stuff */
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_DESCRIPTION(DRIVER_DESC);
> -MODULE_LICENSE(DRIVER_LICENSE);
> +MODULE_LICENSE("GPL");
>  MODULE_VERSION(USBVISION_VERSION_STRING);
>  MODULE_ALIAS(DRIVER_ALIAS);
>  
> 
