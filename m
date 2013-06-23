Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59819 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3FWCj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 22:39:26 -0400
Message-ID: <51C65FC6.6030005@infradead.org>
Date: Sat, 22 Jun 2013 19:39:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH] uvc: Depend on VIDEO_V4L2
References: <1371911157-11955-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1371911157-11955-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/13 07:25, Laurent Pinchart wrote:
> The uvcvideo driver lost its dependency on VIDEO_V4L2 during the big
> media directory reorganization. Add it back.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  drivers/media/usb/uvc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
> index 541c9f1..6ed85ef 100644
> --- a/drivers/media/usb/uvc/Kconfig
> +++ b/drivers/media/usb/uvc/Kconfig
> @@ -1,5 +1,6 @@
>  config USB_VIDEO_CLASS
>  	tristate "USB Video Class (UVC)"
> +	depends on VIDEO_V4L2
>  	select VIDEOBUF2_VMALLOC
>  	---help---
>  	  Support for the USB Video Class (UVC).  Currently only video
> 


-- 
~Randy
