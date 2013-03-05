Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3CENd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 08:33:27 -0500
Date: Tue, 5 Mar 2013 14:33:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [REVIEW PATCH V4 10/12] [media] marvell-ccic: add soc_camera
 support for marvell-ccic driver
In-Reply-To: <1360238687-15768-11-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1303051151310.25837@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-11-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, can we test existing systems, have they been tested? It is hard to 
review this, as you might imagine. At least I don't think I can in any 
reasonably way verify by just looking at this whether it's breaking 
anything... I think, people, really using / developing this driver for 
other platforms would have to just extensively test this and verify the 
final result (I think I know one such person ;-)). A couple of minor 
comments below. In general - it does look quite good to me! So, provided 
relevant testing is done and, possibly, my comments addressed:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

On Thu, 7 Feb 2013, Albert Wang wrote:

> This patch adds the soc_camera mode support in marvell-ccic driver.
> It also removes the old mode for maintaining single mode in the future.
> 
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/platform/Makefile                  |    4 +-
>  drivers/media/platform/marvell-ccic/Kconfig      |    6 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c  | 1084 +++++++---------------
>  drivers/media/platform/marvell-ccic/mcam-core.h  |   27 +-
>  drivers/media/platform/marvell-ccic/mmp-driver.c |   73 +-
>  include/media/mmp-camera.h                       |    5 +
>  6 files changed, 402 insertions(+), 797 deletions(-)

At least the stats look good ;-)

> 
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 4817d28..1a345c8 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -11,8 +11,6 @@ obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
>  obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>  
>  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
> -obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
> -obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
>  
>  obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
>  obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
> @@ -43,6 +41,8 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
>  obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
>  
>  obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
> +obj-$(CONFIG_VIDEO_CAFE_CCIC)		+= marvell-ccic/
> +obj-$(CONFIG_VIDEO_MMP_CAMERA)		+= marvell-ccic/
>  
>  obj-y	+= davinci/
>  
> diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
> index bf739e3..7fa3c62 100755
> --- a/drivers/media/platform/marvell-ccic/Kconfig
> +++ b/drivers/media/platform/marvell-ccic/Kconfig
> @@ -10,14 +10,14 @@ config VIDEO_CAFE_CCIC
>  	  generation OLPC systems.
>  
>  config VIDEO_MMP_CAMERA
> -	tristate "Marvell Armada 610 integrated camera controller support"
> +	tristate "Marvell Armada integrated camera controller support"
>  	depends on ARCH_MMP && I2C && VIDEO_V4L2

Perhaps, you want to add "&& SOC_CAMERA" above

> -	select VIDEO_OV7670
>  	select I2C_GPIO
> +	select VIDEOBUF2_DMA_CONTIG
>  	select VIDEOBUF2_DMA_SG
>  	---help---
>  	  This is a Video4Linux2 driver for the integrated camera
> -	  controller found on Marvell Armada 610 application
> +	  controller found on Marvell Armada application
>  	  processors (and likely beyond).  This is the controller found
>  	  in OLPC XO 1.75 systems.
>  

[snip]

> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index 732af16..3d5db24 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -28,6 +28,10 @@
>  #include <linux/list.h>
>  #include <linux/pm.h>
>  #include <linux/clk.h>
> +#include <linux/regulator/consumer.h>

Looks like you don't need this header.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
