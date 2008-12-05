Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB58kw4e013533
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 03:46:58 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB58kiXH011965
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 03:46:44 -0500
Date: Fri, 5 Dec 2008 09:46:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Eric Miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70811272357t5fb043e3oee6bd9a269f4efaa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812050944440.4162@axis700.grange>
References: <f17812d70811271731s1473f23cn81ca782172acc1cd@mail.gmail.com>
	<Pine.LNX.4.64.0811280807120.3990@axis700.grange>
	<f17812d70811272356iddc5207rb2bb99cc7c88dcac@mail.gmail.com>
	<f17812d70811272357t5fb043e3oee6bd9a269f4efaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped IO
 access for camera (QCI) registers
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

Hi Eric,

On Fri, 28 Nov 2008, Eric Miao wrote:

...

> And again, I'm OK if you can do a trivial merge and I expect
> the final patch will be a bit different than this one.

below is a version of your patch that I'm going to push upstream. Just 
removed superfluous parenthesis and one trailing tab. Please confirm that 
that is ok with you.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer


>From d6f4027008e14f707c2e887f1a5b3ecda8550a2b Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Fri, 28 Nov 2008 09:29:56 +0800
Subject: [PATCH] V4L/DVB: pxa-camera: use memory mapped IO access for camera (QCI) registers

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |  204 ++++++++++++++++++++++++++++++--------
 drivers/media/video/pxa_camera.h |   95 ------------------
 2 files changed, 162 insertions(+), 137 deletions(-)
 delete mode 100644 drivers/media/video/pxa_camera.h

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 330ceb6..7bfc30d 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -39,11 +39,104 @@
 #include <mach/pxa-regs.h>
 #include <mach/camera.h>
 
-#include "pxa_camera.h"
-
 #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
+/* Camera Interface */
+#define CICR0		0x0000
+#define CICR1		0x0004
+#define CICR2		0x0008
+#define CICR3		0x000C
+#define CICR4		0x0010
+#define CISR		0x0014
+#define CIFR		0x0018
+#define CITOR		0x001C
+#define CIBR0		0x0028
+#define CIBR1		0x0030
+#define CIBR2		0x0038
+
+#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
+#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
+#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
+#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
+#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
+#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
+#define CICR0_TOM	(1 << 9)	/* Time-out mask */
+#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
+#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
+#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
+#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
+#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
+#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
+#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
+#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
+#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
+
+#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
+#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
+#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
+#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
+#define CICR1_RGB_F	(1 << 11)	/* RGB format */
+#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
+#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
+#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
+#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
+#define CICR1_DW	(0x7 << 0)	/* Data width mask */
+
+#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
+					   wait count mask */
+#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
+					   wait count mask */
+#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
+#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
+					   wait count mask */
+#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
+					   wait count mask */
+
+#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
+					   wait count mask */
+#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
+					   wait count mask */
+#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
+#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
+					   wait count mask */
+#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
+
+#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
+#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
+#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
+#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
+#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
+#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
+#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
+#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
+
+#define CISR_FTO	(1 << 15)	/* FIFO time-out */
+#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
+#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
+#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
+#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
+#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
+#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
+#define CISR_EOL	(1 << 8)	/* End of line */
+#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
+#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
+#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
+#define CISR_SOF	(1 << 4)	/* Start of frame */
+#define CISR_EOF	(1 << 3)	/* End of frame */
+#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
+#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
+#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
+
+#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
+#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
+#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
+#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
+#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
+#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
+#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
+#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
+
 #define CICR0_SIM_MP	(0 << 24)
 #define CICR0_SIM_SP	(1 << 24)
 #define CICR0_SIM_MS	(2 << 24)
@@ -387,7 +480,10 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	active = pcdev->active;
 
 	if (!active) {
-		CIFR |= CIFR_RESET_F;
+		unsigned long cifr, cicr0;
+
+		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+		__raw_writel(cifr, pcdev->base + CIFR);
 
 		for (i = 0; i < pcdev->channels; i++) {
 			DDADR(pcdev->dma_chans[i]) = buf->dmas[i].sg_dma;
@@ -396,7 +492,9 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 		}
 
 		pcdev->active = buf;
-		CICR0 |= CICR0_ENB;
+
+		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
+		__raw_writel(cicr0, pcdev->base + CICR0);
 	} else {
 		struct pxa_cam_dma *buf_dma;
 		struct pxa_cam_dma *act_dma;
@@ -480,6 +578,8 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct videobuf_buffer *vb,
 			      struct pxa_buffer *buf)
 {
+	unsigned long cicr0;
+
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
@@ -492,7 +592,9 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 		DCSR(pcdev->dma_chans[0]) = 0;
 		DCSR(pcdev->dma_chans[1]) = 0;
 		DCSR(pcdev->dma_chans[2]) = 0;
-		CICR0 &= ~CICR0_ENB;
+
+		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
+		__raw_writel(cicr0, pcdev->base + CICR0);
 		return;
 	}
 
@@ -507,6 +609,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	unsigned long flags;
 	u32 status, camera_status, overrun;
 	struct videobuf_buffer *vb;
+	unsigned long cifr, cicr0;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -529,22 +632,26 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		goto out;
 	}
 
-	camera_status = CISR;
+	camera_status = __raw_readl(pcdev->base + CISR);
 	overrun = CISR_IFO_0;
 	if (pcdev->channels == 3)
 		overrun |= CISR_IFO_1 | CISR_IFO_2;
 	if (camera_status & overrun) {
 		dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n", camera_status);
 		/* Stop the Capture Interface */
-		CICR0 &= ~CICR0_ENB;
+		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
+		__raw_writel(cicr0, pcdev->base + CICR0);
+
 		/* Stop DMA */
 		DCSR(channel) = 0;
 		/* Reset the FIFOs */
-		CIFR |= CIFR_RESET_F;
+		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+		__raw_writel(cifr, pcdev->base + CIFR);
 		/* Enable End-Of-Frame Interrupt */
-		CICR0 &= ~CICR0_EOFM;
+		cicr0 &= ~CICR0_EOFM;
+		__raw_writel(cicr0, pcdev->base + CICR0);
 		/* Restart the Capture Interface */
-		CICR0 |= CICR0_ENB;
+		__raw_writel(cicr0 | CICR0_ENB, pcdev->base + CICR0);
 		goto out;
 	}
 
@@ -631,7 +738,8 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 		pdata->init(pcdev->dev);
 	}
 
-	CICR0 = 0x3FF;   /* disable all interrupts */
+	/* disable all interrupts */
+	__raw_writel(0x3ff, pcdev->base + CICR0);
 
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
 		cicr4 |= CICR4_PCLK_EN;
@@ -644,7 +752,8 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 	if (pcdev->platform_flags & PXA_CAMERA_VSP)
 		cicr4 |= CICR4_VSP;
 
-	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+	cicr4 |= mclk_get_divisor(pcdev);
+	__raw_writel(cicr4, pcdev->base + CICR4);
 
 	clk_enable(pcdev->clk);
 }
@@ -657,14 +766,15 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 static irqreturn_t pxa_camera_irq(int irq, void *data)
 {
 	struct pxa_camera_dev *pcdev = data;
-	unsigned int status = CISR;
+	unsigned long status, cicr0;
 
-	dev_dbg(pcdev->dev, "Camera interrupt status 0x%x\n", status);
+	status = __raw_readl(pcdev->base + CISR);
+	dev_dbg(pcdev->dev, "Camera interrupt status 0x%lx\n", status);
 
 	if (!status)
 		return IRQ_NONE;
 
-	CISR = status;
+	__raw_writel(status, pcdev->base + CISR);
 
 	if (status & CISR_EOF) {
 		int i;
@@ -673,7 +783,8 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 				pcdev->active->dmas[i].sg_dma;
 			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
 		}
-		CICR0 |= CICR0_EOFM;
+		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
+		__raw_writel(cicr0, pcdev->base + CICR0);
 	}
 
 	return IRQ_HANDLED;
@@ -720,7 +831,7 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	/* disable capture, disable interrupts */
-	CICR0 = 0x3ff;
+	__raw_writel(0x3ff, pcdev->base + CICR0);
 
 	/* Stop DMA engine */
 	DCSR(pcdev->dma_chans[0]) = 0;
@@ -781,7 +892,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
-	u32 cicr0, cicr1, cicr4 = 0;
+	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0;
 	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
 
 	if (ret < 0)
@@ -854,9 +965,9 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_VSP;
 
-	cicr0 = CICR0;
+	cicr0 = __raw_readl(pcdev->base + CICR0);
 	if (cicr0 & CICR0_ENB)
-		CICR0 = cicr0 & ~CICR0_ENB;
+		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
 
 	cicr1 = CICR1_PPL_VAL(icd->width - 1) | bpp | dw;
 
@@ -886,16 +997,21 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		break;
 	}
 
-	CICR1 = cicr1;
-	CICR2 = 0;
-	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
+	cicr2 = 0;
+	cicr3 = CICR3_LPF_VAL(icd->height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
-	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+	cicr4 |= mclk_get_divisor(pcdev);
+
+	__raw_writel(cicr1, pcdev->base + CICR1);
+	__raw_writel(cicr2, pcdev->base + CICR2);
+	__raw_writel(cicr3, pcdev->base + CICR3);
+	__raw_writel(cicr4, pcdev->base + CICR4);
 
 	/* CIF interrupts are not used, only DMA */
-	CICR0 = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-		 CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP)) |
-		CICR0_DMAEN | CICR0_IRQ_MASK | (cicr0 & CICR0_ENB);
+	cicr0 = (cicr0 & CICR0_ENB) | (pcdev->platform_flags & PXA_CAMERA_MASTER ?
+		CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP));
+	cicr0 |= CICR0_DMAEN | CICR0_IRQ_MASK;
+	__raw_writel(cicr0, pcdev->base + CICR0);
 
 	return 0;
 }
@@ -1141,11 +1257,11 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
-	pcdev->save_cicr[i++] = CICR0;
-	pcdev->save_cicr[i++] = CICR1;
-	pcdev->save_cicr[i++] = CICR2;
-	pcdev->save_cicr[i++] = CICR3;
-	pcdev->save_cicr[i++] = CICR4;
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR1);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR2);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
 	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
 		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
@@ -1164,23 +1280,27 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
 	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
 
-	CICR0 = pcdev->save_cicr[i++] & ~CICR0_ENB;
-	CICR1 = pcdev->save_cicr[i++];
-	CICR2 = pcdev->save_cicr[i++];
-	CICR3 = pcdev->save_cicr[i++];
-	CICR4 = pcdev->save_cicr[i++];
+	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
 	if ((pcdev->icd) && (pcdev->icd->ops->resume))
 		ret = pcdev->icd->ops->resume(pcdev->icd);
 
 	/* Restart frame capture if active buffer exists */
 	if (!ret && pcdev->active) {
+		unsigned long cifr, cicr0;
+
 		/* Reset the FIFOs */
-		CIFR |= CIFR_RESET_F;
-		/* Enable End-Of-Frame Interrupt */
-		CICR0 &= ~CICR0_EOFM;
-		/* Restart the Capture Interface */
-		CICR0 |= CICR0_ENB;
+		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+		__raw_writel(cifr, pcdev->base + CIFR);
+
+		cicr0 = __raw_readl(pcdev->base + CICR0);
+		cicr0 &= ~CICR0_EOFM;	/* Enable End-Of-Frame Interrupt */
+		cicr0 |= CICR0_ENB;	/* Restart the Capture Interface */
+		__raw_writel(cicr0, pcdev->base + CICR0);
 	}
 
 	return ret;
diff --git a/drivers/media/video/pxa_camera.h b/drivers/media/video/pxa_camera.h
deleted file mode 100644
index 89cbfc9..0000000
--- a/drivers/media/video/pxa_camera.h
+++ /dev/null
@@ -1,95 +0,0 @@
-/* Camera Interface */
-#define CICR0		__REG(0x50000000)
-#define CICR1		__REG(0x50000004)
-#define CICR2		__REG(0x50000008)
-#define CICR3		__REG(0x5000000C)
-#define CICR4		__REG(0x50000010)
-#define CISR		__REG(0x50000014)
-#define CIFR		__REG(0x50000018)
-#define CITOR		__REG(0x5000001C)
-#define CIBR0		__REG(0x50000028)
-#define CIBR1		__REG(0x50000030)
-#define CIBR2		__REG(0x50000038)
-
-#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
-#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
-#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
-#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
-#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
-#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
-#define CICR0_TOM	(1 << 9)	/* Time-out mask */
-#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
-#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
-#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
-#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
-#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
-#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
-#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
-#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
-#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
-
-#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
-#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
-#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
-#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
-#define CICR1_RGB_F	(1 << 11)	/* RGB format */
-#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
-#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
-#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
-#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
-#define CICR1_DW	(0x7 << 0)	/* Data width mask */
-
-#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
-					   wait count mask */
-#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
-					   wait count mask */
-#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
-#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
-					   wait count mask */
-#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
-					   wait count mask */
-
-#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
-					   wait count mask */
-#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
-					   wait count mask */
-#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
-#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
-					   wait count mask */
-#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
-
-#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
-#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
-#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
-#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
-#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
-#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
-#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
-#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
-
-#define CISR_FTO	(1 << 15)	/* FIFO time-out */
-#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
-#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
-#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
-#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
-#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
-#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
-#define CISR_EOL	(1 << 8)	/* End of line */
-#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
-#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
-#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
-#define CISR_SOF	(1 << 4)	/* Start of frame */
-#define CISR_EOF	(1 << 3)	/* End of frame */
-#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
-#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
-#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
-
-#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
-#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
-#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
-#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
-#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
-#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
-#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
-#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
-
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
