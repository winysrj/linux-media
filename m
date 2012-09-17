Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2IQJ0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 05:26:31 -0400
Date: Mon, 17 Sep 2012 11:26:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Shawn Guo <shawn.guo@linaro.org>
cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vinod.koul@intel.com>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 14/34] dma: ipu: rename mach/ipu.h to include/linux/dma/ipu-dma.h
In-Reply-To: <1347860103-4141-15-git-send-email-shawn.guo@linaro.org>
Message-ID: <Pine.LNX.4.64.1209171124130.1689@axis700.grange>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <1347860103-4141-15-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Sep 2012, Shawn Guo wrote:

> The header ipu.h really belongs to dma subsystem rather than imx
> platform.  Rename it to ipu-dma.h and put it into include/linux/dma/.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-media@vger.kernel.org
> Cc: linux-fbdev@vger.kernel.org

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/dma/ipu/ipu_idmac.c                        |    3 +--
>  drivers/dma/ipu/ipu_irq.c                          |    3 +--
>  drivers/media/video/mx3_camera.c                   |    2 +-
>  drivers/video/mx3fb.c                              |    2 +-
>  .../mach/ipu.h => include/linux/dma/ipu-dma.h      |    6 +++---
>  5 files changed, 7 insertions(+), 9 deletions(-)
>  rename arch/arm/mach-imx/include/mach/ipu.h => include/linux/dma/ipu-dma.h (97%)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index c7573e5..6585537 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -22,8 +22,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> -
> -#include <mach/ipu.h>
> +#include <linux/dma/ipu-dma.h>
>  
>  #include "../dmaengine.h"
>  #include "ipu_intern.h"
> diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
> index fa95bcc..a5ee37d 100644
> --- a/drivers/dma/ipu/ipu_irq.c
> +++ b/drivers/dma/ipu/ipu_irq.c
> @@ -15,8 +15,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> -
> -#include <mach/ipu.h>
> +#include <linux/dma/ipu-dma.h>
>  
>  #include "ipu_intern.h"
>  
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 1481b0d..892cba5 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -17,6 +17,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> +#include <linux/dma/ipu-dma.h>
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> @@ -24,7 +25,6 @@
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
>  
> -#include <mach/ipu.h>
>  #include <linux/platform_data/camera-mx3.h>
>  #include <linux/platform_data/dma-imx.h>
>  
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index d738108..3b63ad8 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -26,10 +26,10 @@
>  #include <linux/console.h>
>  #include <linux/clk.h>
>  #include <linux/mutex.h>
> +#include <linux/dma/ipu-dma.h>
>  
>  #include <linux/platform_data/dma-imx.h>
>  #include <mach/hardware.h>
> -#include <mach/ipu.h>
>  #include <linux/platform_data/video-mx3fb.h>
>  
>  #include <asm/io.h>
> diff --git a/arch/arm/mach-imx/include/mach/ipu.h b/include/linux/dma/ipu-dma.h
> similarity index 97%
> rename from arch/arm/mach-imx/include/mach/ipu.h
> rename to include/linux/dma/ipu-dma.h
> index 539e559..1803111 100644
> --- a/arch/arm/mach-imx/include/mach/ipu.h
> +++ b/include/linux/dma/ipu-dma.h
> @@ -9,8 +9,8 @@
>   * published by the Free Software Foundation.
>   */
>  
> -#ifndef _IPU_H_
> -#define _IPU_H_
> +#ifndef __LINUX_DMA_IPU_DMA_H
> +#define __LINUX_DMA_IPU_DMA_H
>  
>  #include <linux/types.h>
>  #include <linux/dmaengine.h>
> @@ -174,4 +174,4 @@ struct idmac_channel {
>  #define to_tx_desc(tx) container_of(tx, struct idmac_tx_desc, txd)
>  #define to_idmac_chan(c) container_of(c, struct idmac_channel, dma_chan)
>  
> -#endif
> +#endif /* __LINUX_DMA_IPU_DMA_H */
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
