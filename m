Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:58195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FGHor (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 03:44:47 -0400
Date: Tue, 7 Jun 2011 09:44:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-media@vger.kernel.org, Kassey Lee <ygli@marvell.com>
Subject: Re: [PATCH 7/7] marvell-cam: Basic working MMP camera driver
In-Reply-To: <1307400003-94758-8-git-send-email-corbet@lwn.net>
Message-ID: <Pine.LNX.4.64.1106070941140.31635@axis700.grange>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
 <1307400003-94758-8-git-send-email-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Not doing a full review, just a small nit-pick:

On Mon, 6 Jun 2011, Jonathan Corbet wrote:

> Now we have a camera working over the marvell cam controller core.  It
> works like the cafe driver and has all the same limitations, contiguous DMA
> only being one of them.  But it's a start.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/Makefile                   |    1 +
>  drivers/media/video/marvell-ccic/Kconfig       |   11 +
>  drivers/media/video/marvell-ccic/Makefile      |    4 +
>  drivers/media/video/marvell-ccic/cafe-driver.c |    9 +-
>  drivers/media/video/marvell-ccic/mcam-core.c   |   31 ++-
>  drivers/media/video/marvell-ccic/mcam-core.h   |    2 +-
>  drivers/media/video/marvell-ccic/mmp-driver.c  |  337 ++++++++++++++++++++++++
>  include/media/mmp-camera.h                     |    9 +
>  8 files changed, 392 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/media/video/marvell-ccic/mmp-driver.c
>  create mode 100644 include/media/mmp-camera.h
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 42b6a7a..89478f0 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -128,6 +128,7 @@ obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>  obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>  
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
> +obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/

Wouldn't it be better to have only one symbol, selecting the marvell-ccic 
directory in the Makefile and have all CAFE implementations select that 
symbol?

>  
>  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>  
> diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
> index 80136a8..b4f7260 100644
> --- a/drivers/media/video/marvell-ccic/Kconfig
> +++ b/drivers/media/video/marvell-ccic/Kconfig
> @@ -7,3 +7,14 @@ config VIDEO_CAFE_CCIC
>  	  CMOS camera controller.  This is the controller found on first-
>  	  generation OLPC systems.
>  
> +config VIDEO_MMP_CAMERA
> +	tristate "Marvell Armada 610 integrated camera controller support"
> +	depends on ARCH_MMP && I2C && VIDEO_V4L2
> +	select VIDEO_OV7670

Is ov7670 really _integrated_ with the camera controller? Can it not be 
used with any other sensor?

> +	select I2C_GPIO
> +	---help---
> +	  This is a Video4Linux2 driver for the integrated camera
> +	  controller found on Marvell Armada 610 application
> +	  processors (and likely beyond).  This is the controller found
> +	  in OLPC XO 1.75 systems.
> +

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
