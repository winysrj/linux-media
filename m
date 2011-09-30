Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1I3Nqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 09:46:40 -0400
Message-ID: <4E85C83C.8030007@redhat.com>
Date: Fri, 30 Sep 2011 10:46:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 7/7] V4L menu: move all PCI(e) devices to their
 own submenu.
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl> <09bda56fe8e3f74a894f2ab9864f3bcbbc66cf94.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <09bda56fe8e3f74a894f2ab9864f3bcbbc66cf94.1317384926.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-09-2011 09:18, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/Kconfig |  109 ++++++++++++++++++++++++------------------
>  1 files changed, 62 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 399804f..a2ccf78 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -573,6 +573,20 @@ config VIDEO_M52790
>  
>  endmenu # encoder / decoder chips
>  
> +config VIDEO_VIVI
> +	tristate "Virtual Video Driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
> +	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
> +	select FONT_8x16
> +	select VIDEOBUF2_VMALLOC
> +	default n
> +	---help---
> +	  Enables a virtual video driver. This device shows a color bar
> +	  and a timestamp, as a real device would generate by using V4L2
> +	  api.
> +	  Say Y here if you want to test video apps or debug V4L devices.
> +	  In doubt, say N.
> +
>  #
>  # USB Multimedia device configuration
>  #
> @@ -608,6 +622,8 @@ source "drivers/media/video/sn9c102/Kconfig"
>  
>  source "drivers/media/video/pwc/Kconfig"
>  
> +source "drivers/media/video/cpia2/Kconfig"
> +
>  config USB_ZR364XX
>  	tristate "USB ZR364XX Camera support"
>  	depends on VIDEO_V4L2
> @@ -646,25 +662,53 @@ config USB_S2255
>  
>  endif # V4L_USB_DRIVERS
>  
> -config VIDEO_VIVI
> -	tristate "Virtual Video Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
> -	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
> -	select FONT_8x16
> -	select VIDEOBUF2_VMALLOC
> -	default n
> +#
> +# PCI drivers configuration
> +#
> +
> +menuconfig V4L_PCI_DRIVERS
> +	bool "V4L PCI(e) devices"
> +	depends on PCI
> +	default y
>  	---help---
> -	  Enables a virtual video driver. This device shows a color bar
> -	  and a timestamp, as a real device would generate by using V4L2
> -	  api.
> -	  Say Y here if you want to test video apps or debug V4L devices.
> -	  In doubt, say N.
> +	  Say Y here to enable support for these PCI(e) drivers.

s/these//

Btw, I also liked Stephan suggestion of saying that this won't actually add any
code to the Kernel. So, the final comment will probably be something like:

	Say Y to enable support for PCI(e) drivers.
	This option alone does not add any kernel code.
	If you say N, all PCI(e) media drivers will be skipped and disabled.


> +
> +if V4L_PCI_DRIVERS
> +
> +source "drivers/media/video/au0828/Kconfig"
>  
>  source "drivers/media/video/bt8xx/Kconfig"
>  
> -source "drivers/media/video/cpia2/Kconfig"
> +source "drivers/media/video/cx18/Kconfig"
>  
> -source "drivers/media/video/zoran/Kconfig"
> +source "drivers/media/video/cx23885/Kconfig"
> +
> +source "drivers/media/video/cx88/Kconfig"
> +
> +config VIDEO_HEXIUM_GEMINI
> +	tristate "Hexium Gemini frame grabber"
> +	depends on PCI && VIDEO_V4L2 && I2C
> +	select VIDEO_SAA7146_VV
> +	---help---
> +	  This is a video4linux driver for the Hexium Gemini frame
> +	  grabber card by Hexium. Please note that the Gemini Dual
> +	  card is *not* fully supported.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called hexium_gemini.
> +
> +config VIDEO_HEXIUM_ORION
> +	tristate "Hexium HV-PCI6 and Orion frame grabber"
> +	depends on PCI && VIDEO_V4L2 && I2C
> +	select VIDEO_SAA7146_VV
> +	---help---
> +	  This is a video4linux driver for the Hexium HV-PCI6 and
> +	  Orion frame grabber cards by Hexium.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called hexium_orion.
> +
> +source "drivers/media/video/ivtv/Kconfig"
>  
>  config VIDEO_MEYE
>  	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
> @@ -680,8 +724,6 @@ config VIDEO_MEYE
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called meye.
>  
> -source "drivers/media/video/saa7134/Kconfig"
> -
>  config VIDEO_MXB
>  	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
>  	depends on PCI && VIDEO_V4L2 && I2C
> @@ -698,40 +740,13 @@ config VIDEO_MXB
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called mxb.
>  
> -config VIDEO_HEXIUM_ORION
> -	tristate "Hexium HV-PCI6 and Orion frame grabber"
> -	depends on PCI && VIDEO_V4L2 && I2C
> -	select VIDEO_SAA7146_VV
> -	---help---
> -	  This is a video4linux driver for the Hexium HV-PCI6 and
> -	  Orion frame grabber cards by Hexium.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called hexium_orion.
> -
> -config VIDEO_HEXIUM_GEMINI
> -	tristate "Hexium Gemini frame grabber"
> -	depends on PCI && VIDEO_V4L2 && I2C
> -	select VIDEO_SAA7146_VV
> -	---help---
> -	  This is a video4linux driver for the Hexium Gemini frame
> -	  grabber card by Hexium. Please note that the Gemini Dual
> -	  card is *not* fully supported.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called hexium_gemini.
> -
> -source "drivers/media/video/cx88/Kconfig"
> -
> -source "drivers/media/video/cx23885/Kconfig"
> -
> -source "drivers/media/video/au0828/Kconfig"
> +source "drivers/media/video/saa7134/Kconfig"
>  
> -source "drivers/media/video/ivtv/Kconfig"
> +source "drivers/media/video/saa7164/Kconfig"
>  
> -source "drivers/media/video/cx18/Kconfig"
> +source "drivers/media/video/zoran/Kconfig"
>  
> -source "drivers/media/video/saa7164/Kconfig"
> +endif # V4L_PCI_DRIVERS
>  
>  #
>  # ISA & parallel port drivers configuration

