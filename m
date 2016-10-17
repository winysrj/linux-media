Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52114 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758038AbcJQOJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 10:09:02 -0400
Subject: Re: [Patch 01/35] media: ti-vpe: vpdma: Make vpdma library into its
 own module
To: Benoit Parrot <bparrot@ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
 <20160928211643.26298-2-bparrot@ti.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <30463f1c-4c12-b76c-81f4-d941668ecbd3@xs4all.nl>
Date: Mon, 17 Oct 2016 16:08:55 +0200
MIME-Version: 1.0
In-Reply-To: <20160928211643.26298-2-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2016 11:16 PM, Benoit Parrot wrote:
> The VPDMA (Video Port DMA) as found in devices such as DRA7xx is
> used for both the Video Processing Engine (VPE) and the Video Input
> Port (VIP).
> 
> In preparation for this we need to turn vpdma into its own
> kernel module.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/platform/Kconfig         |  6 ++++++
>  drivers/media/platform/ti-vpe/Makefile |  4 +++-
>  drivers/media/platform/ti-vpe/vpdma.c  | 28 +++++++++++++++++++++++++++-
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index f98ed3fd0efd..3c15c5a53bd5 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -334,6 +334,7 @@ config VIDEO_TI_VPE
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
> +	select VIDEO_TI_VPDMA
>  	default n
>  	---help---
>  	  Support for the TI VPE(Video Processing Engine) block
> @@ -347,6 +348,11 @@ config VIDEO_TI_VPE_DEBUG
>  
>  endif # V4L_MEM2MEM_DRIVERS
>  
> +# TI VIDEO PORT Helper Modules
> +# These will be selected by VPE and VIP
> +config VIDEO_TI_VPDMA
> +	tristate
> +
>  menuconfig V4L_TEST_DRIVERS
>  	bool "Media test drivers"
>  	depends on MEDIA_CAMERA_SUPPORT
> diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
> index e236059a60ad..faca5e115c1d 100644
> --- a/drivers/media/platform/ti-vpe/Makefile
> +++ b/drivers/media/platform/ti-vpe/Makefile
> @@ -1,6 +1,8 @@
>  obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
> +obj-$(CONFIG_VIDEO_TI_VPDMA) += ti-vpdma.o
>  
> -ti-vpe-y := vpe.o sc.o csc.o vpdma.o
> +ti-vpe-y := vpe.o sc.o csc.o
> +ti-vpdma-y := vpdma.o
>  
>  ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
>  
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
> index 3e2e3a33e6ed..e55cb58213bf 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -75,6 +75,7 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
>  		.depth		= 16,
>  	},
>  };
> +EXPORT_SYMBOL(vpdma_yuv_fmts);

EXPORT_SYMBOL_GPL?

(Up to you).

Regards,

	Hans
