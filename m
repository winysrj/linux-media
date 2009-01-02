Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02FxbDq026560
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 10:59:37 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n02FxMKZ025741
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 10:59:22 -0500
Date: Fri, 2 Jan 2009 16:59:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Eric Miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901021625420.4694@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 2 Jan 2009, Eric Miao wrote:

> 1. now pxa_camera.c uses ioremap() for register access, pxa_camera.h is
>    totally useless. Remove it.
> 
> 2. <asm/dma.h> does no longer include <mach/dma.h>, include the latter
>    file explicitly
> 
> Signed-off-by: Eric Miao <eric.miao@marvell.com>

Mauro, it looks like the drivers/media/video/pxa_camera.h part of 
http://linuxtv.org/hg/~gliakhovetski/v4l-dvb/rev/30773c067724 has been 
dropped on its way to 
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed

Your hg tree also includes the header hunks, so, it disappeared between 
your hg tree and the git tree. Looks like you also lost this hunk

 #include <asm/arch/camera.h>
 #endif
 
-#include "pxa_camera.h"
-
 #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
 #define PXA_CAM_DRV_NAME "pxa27x-camera"

so that now registers are defined twice - by including the header and 
directly in .c. What shall we do now? I presume, we cannot roll back 
git-tree(s) any more, so, we have to somehow synchronise our hg-trees 
now. (how much easier this would be in a perfect world without partial 
hg-trees...)

Thanks
Guennadi

> ---
>  drivers/media/video/pxa_camera.c |    4 +-
>  drivers/media/video/pxa_camera.h |   95 --------------------------------------
>  2 files changed, 1 insertions(+), 98 deletions(-)
>  delete mode 100644 drivers/media/video/pxa_camera.h
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 9d33de2..a1d6008 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -34,12 +34,10 @@
> 
>  #include <linux/videodev2.h>
> 
> -#include <asm/dma.h>
> +#include <mach/dma.h>
>  #include <mach/pxa-regs.h>
>  #include <mach/camera.h>
> 
> -#include "pxa_camera.h"
> -
>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
> 
> diff --git a/drivers/media/video/pxa_camera.h b/drivers/media/video/pxa_camera.h
> deleted file mode 100644
> index 89cbfc9..0000000
> --- a/drivers/media/video/pxa_camera.h
> +++ /dev/null
> @@ -1,95 +0,0 @@
> -/* Camera Interface */
> -#define CICR0		__REG(0x50000000)
> -#define CICR1		__REG(0x50000004)
> -#define CICR2		__REG(0x50000008)
> -#define CICR3		__REG(0x5000000C)
> -#define CICR4		__REG(0x50000010)
> -#define CISR		__REG(0x50000014)
> -#define CIFR		__REG(0x50000018)
> -#define CITOR		__REG(0x5000001C)
> -#define CIBR0		__REG(0x50000028)
> -#define CIBR1		__REG(0x50000030)
> -#define CIBR2		__REG(0x50000038)
> -
> -#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
> -#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
> -#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> -#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
> -#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
> -#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
> -#define CICR0_TOM	(1 << 9)	/* Time-out mask */
> -#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
> -#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
> -#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
> -#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
> -#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
> -#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
> -#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
> -#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
> -#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
> -
> -#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
> -#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
> -#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
> -#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
> -#define CICR1_RGB_F	(1 << 11)	/* RGB format */
> -#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
> -#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
> -#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
> -#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
> -#define CICR1_DW	(0x7 << 0)	/* Data width mask */
> -
> -#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
> -					   wait count mask */
> -#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
> -					   wait count mask */
> -#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
> -#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> -					   wait count mask */
> -#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
> -					   wait count mask */
> -
> -#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
> -					   wait count mask */
> -#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
> -					   wait count mask */
> -#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
> -#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> -					   wait count mask */
> -#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
> -
> -#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
> -#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
> -#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
> -#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
> -#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
> -#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
> -#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
> -#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
> -
> -#define CISR_FTO	(1 << 15)	/* FIFO time-out */
> -#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
> -#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
> -#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
> -#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
> -#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
> -#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
> -#define CISR_EOL	(1 << 8)	/* End of line */
> -#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
> -#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
> -#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
> -#define CISR_SOF	(1 << 4)	/* Start of frame */
> -#define CISR_EOF	(1 << 3)	/* End of frame */
> -#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
> -#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
> -#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
> -
> -#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
> -#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
> -#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
> -#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
> -#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
> -#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
> -#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
> -#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
> -
> -- 
> 1.6.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
