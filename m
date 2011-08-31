Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab1HaNqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:46:40 -0400
Date: Wed, 31 Aug 2011 15:46:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/6] V4L menu: move USB drivers section to the top.
In-Reply-To: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
Message-ID: <Pine.LNX.4.64.1108311546001.8429@axis700.grange>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
 <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Aug 2011, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> USB webcams are some of the most used V4L devices, so move it to a more
> prominent place in the menu instead of being at the end.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/Kconfig |  141 ++++++++++++++++++++++---------------------
>  1 files changed, 71 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index f574dc0..336251f 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -545,6 +545,77 @@ config VIDEO_M52790
>  
>  endmenu # encoder / decoder chips
>  
> +#
> +# USB Multimedia device configuration
> +#
> +
> +menuconfig V4L_USB_DRIVERS
> +	bool "V4L USB devices"
> +	depends on USB
> +	default y
> +
> +if V4L_USB_DRIVERS && USB

is "&& USB" needed? V4L_USB_DRIVERS already depends on USB

Thanks
Guennadi

> +
> +source "drivers/media/video/uvc/Kconfig"
> +
> +source "drivers/media/video/gspca/Kconfig"
> +
> +source "drivers/media/video/pvrusb2/Kconfig"
> +
> +source "drivers/media/video/hdpvr/Kconfig"
> +
> +source "drivers/media/video/em28xx/Kconfig"
> +
> +source "drivers/media/video/tlg2300/Kconfig"
> +
> +source "drivers/media/video/cx231xx/Kconfig"
> +
> +source "drivers/media/video/usbvision/Kconfig"
> +
> +source "drivers/media/video/et61x251/Kconfig"
> +
> +source "drivers/media/video/sn9c102/Kconfig"
> +
> +source "drivers/media/video/pwc/Kconfig"
> +
> +config USB_ZR364XX
> +	tristate "USB ZR364XX Camera support"
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF_GEN
> +	select VIDEOBUF_VMALLOC
> +	---help---
> +	  Say Y here if you want to connect this type of camera to your
> +	  computer's USB port.
> +	  See <file:Documentation/video4linux/zr364xx.txt> for more info
> +	  and list of supported cameras.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called zr364xx.
> +
> +config USB_STKWEBCAM
> +	tristate "USB Syntek DC1125 Camera support"
> +	depends on VIDEO_V4L2 && EXPERIMENTAL
> +	---help---
> +	  Say Y here if you want to use this type of camera.
> +	  Supported devices are typically found in some Asus laptops,
> +	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
> +	  may be supported by the stk11xx driver, from which this is
> +	  derived, see <http://sourceforge.net/projects/syntekdriver/>
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called stkwebcam.
> +
> +config USB_S2255
> +	tristate "USB Sensoray 2255 video capture device"
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF_VMALLOC
> +	default n
> +	help
> +	  Say Y here if you want support for the Sensoray 2255 USB device.
> +	  This driver can be compiled as a module, called s2255drv.
> +
> +endif # V4L_USB_DRIVERS
> +
>  config VIDEO_SH_VOU
>  	tristate "SuperH VOU video output driver"
>  	depends on VIDEO_DEV && ARCH_SHMOBILE
> @@ -979,76 +1050,6 @@ config VIDEO_S5P_MIPI_CSIS
>  
>  source "drivers/media/video/s5p-tv/Kconfig"
>  
> -#
> -# USB Multimedia device configuration
> -#
> -
> -menuconfig V4L_USB_DRIVERS
> -	bool "V4L USB devices"
> -	depends on USB
> -	default y
> -
> -if V4L_USB_DRIVERS && USB
> -
> -source "drivers/media/video/uvc/Kconfig"
> -
> -source "drivers/media/video/gspca/Kconfig"
> -
> -source "drivers/media/video/pvrusb2/Kconfig"
> -
> -source "drivers/media/video/hdpvr/Kconfig"
> -
> -source "drivers/media/video/em28xx/Kconfig"
> -
> -source "drivers/media/video/tlg2300/Kconfig"
> -
> -source "drivers/media/video/cx231xx/Kconfig"
> -
> -source "drivers/media/video/usbvision/Kconfig"
> -
> -source "drivers/media/video/et61x251/Kconfig"
> -
> -source "drivers/media/video/sn9c102/Kconfig"
> -
> -source "drivers/media/video/pwc/Kconfig"
> -
> -config USB_ZR364XX
> -	tristate "USB ZR364XX Camera support"
> -	depends on VIDEO_V4L2
> -	select VIDEOBUF_GEN
> -	select VIDEOBUF_VMALLOC
> -	---help---
> -	  Say Y here if you want to connect this type of camera to your
> -	  computer's USB port.
> -	  See <file:Documentation/video4linux/zr364xx.txt> for more info
> -	  and list of supported cameras.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called zr364xx.
> -
> -config USB_STKWEBCAM
> -	tristate "USB Syntek DC1125 Camera support"
> -	depends on VIDEO_V4L2 && EXPERIMENTAL
> -	---help---
> -	  Say Y here if you want to use this type of camera.
> -	  Supported devices are typically found in some Asus laptops,
> -	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
> -	  may be supported by the stk11xx driver, from which this is
> -	  derived, see <http://sourceforge.net/projects/syntekdriver/>
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called stkwebcam.
> -
> -config USB_S2255
> -	tristate "USB Sensoray 2255 video capture device"
> -	depends on VIDEO_V4L2
> -	select VIDEOBUF_VMALLOC
> -	default n
> -	help
> -	  Say Y here if you want support for the Sensoray 2255 USB device.
> -	  This driver can be compiled as a module, called s2255drv.
> -
> -endif # V4L_USB_DRIVERS
>  endif # VIDEO_CAPTURE_DRIVERS
>  
>  menuconfig V4L_MEM2MEM_DRIVERS
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
