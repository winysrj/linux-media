Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47528 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757043Ab0CLJWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 04:22:24 -0500
Date: Fri, 12 Mar 2010 10:22:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] V4L/DVB: mx1-camera: compile fix
In-Reply-To: <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1003121016480.4385@axis700.grange>
References: <20100304194241.GG19843@pengutronix.de>
 <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uwe

On Fri, 5 Mar 2010, Uwe Kleine-König wrote:

> This is a regression of
> 
> 	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/media/video/mx1_camera.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index 2ba14fb..29c2833 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -45,11 +45,13 @@
>  #include <mach/hardware.h>
>  #include <mach/mx1_camera.h>
>  
> +#define __DMAREG(offset)	(MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR) + offset)
> +

Well, I think, Sascha is right, we have to fix 
arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h, because that's what actually 
got broken. The line

#define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)

in it is no longer valid, right? So, we have to either remove it, or fix 
it, if we think, that other drivers might start using it. And even if we 
decide to remove it from the header and implement here, wouldn't it be 
better to choose a name, not beginning with "__"? Something like 
MX1_DMA_REG, perhaps? Or maybe even we shall remap those registers?

Thanks
Guennadi

>  /*
>   * CSI registers
>   */
> -#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
> -#define DMA_DIMR	0x08			/* Interrupt mask Register */
> +#define DMA_CCR(x)	__DMAREG(0x8c + ((x) << 6))	/* Control Registers */
> +#define DMA_DIMR	__DMAREG(0x08)		/* Interrupt mask Register */
>  #define CSICR1		0x00			/* CSI Control Register 1 */
>  #define CSISR		0x08			/* CSI Status Register */
>  #define CSIRXR		0x10			/* CSI RxFIFO Register */
> @@ -783,7 +785,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  			       pcdev);
>  
>  	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
> -			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
> +			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
>  	/* burst length : 16 words = 64 bytes */
>  	imx_dma_config_burstlen(pcdev->dma_chan, 0);
>  
> @@ -797,8 +799,8 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
>  						   &mx1_camera_sof_fiq_start);
>  
> -	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
> -	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
> +	regs.ARM_r8 = (long)DMA_DIMR;
> +	regs.ARM_r9 = (long)DMA_CCR(pcdev->dma_chan);
>  	regs.ARM_r10 = (long)pcdev->base + CSICR1;
>  	regs.ARM_fp = (long)pcdev->base + CSISR;
>  	regs.ARM_sp = 1 << pcdev->dma_chan;
> -- 
> 1.7.0
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
