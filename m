Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1O0DL4j020741
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 19:13:21 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1O0CnAs032551
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 19:12:50 -0500
Date: Sun, 24 Feb 2008 01:12:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802240059270.4445@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King <rmk@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Clean up pxa-camera driver, remove non-functional and never
 tested pm-support
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

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

This patch addresses most issues pointed out by Russell and Erik, moves 
recently introduced into pxa-regs.h camera-specific defines into 
pxa_camera.c, removes dummy power-management functions, improves 
function-naming, etc.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Russell, Erik, I think, althogh this patch will also go through the v4l 
tree, we need an "ARM"-ack on it too, at least because it touches 
include/asm-arm/arch-pxa/pxa-regs.h, don't we?

Thanks
Guennadi

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 11aecad..a34a193 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -10,10 +10,9 @@
  * (at your option) any later version.
  */
 
-#include <asm/io.h>
-
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
@@ -42,6 +41,26 @@
 #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
+#define CICR0_SIM_MP	(0 << 24)
+#define CICR0_SIM_SP	(1 << 24)
+#define CICR0_SIM_MS	(2 << 24)
+#define CICR0_SIM_EP	(3 << 24)
+#define CICR0_SIM_ES	(4 << 24)
+
+#define CICR1_DW_VAL(x)   ((x) & CICR1_DW)	    /* Data bus width */
+#define CICR1_PPL_VAL(x)  (((x) << 15) & CICR1_PPL) /* Pixels per line */
+
+#define CICR2_BLW_VAL(x)  (((x) << 24) & CICR2_BLW) /* Beginning-of-line pixel clock wait count */
+#define CICR2_ELW_VAL(x)  (((x) << 16) & CICR2_ELW) /* End-of-line pixel clock wait count */
+#define CICR2_HSW_VAL(x)  (((x) << 10) & CICR2_HSW) /* Horizontal sync pulse width */
+#define CICR2_BFPW_VAL(x) (((x) << 3) & CICR2_BFPW) /* Beginning-of-frame pixel clock wait count */
+#define CICR2_FSW_VAL(x)  (((x) << 0) & CICR2_FSW)  /* Frame stabilization wait count */
+
+#define CICR3_BFW_VAL(x)  (((x) << 24) & CICR3_BFW) /* Beginning-of-frame line clock wait count  */
+#define CICR3_EFW_VAL(x)  (((x) << 16) & CICR3_EFW) /* End-of-frame line clock wait count */
+#define CICR3_VSW_VAL(x)  (((x) << 11) & CICR3_VSW) /* Vertical sync pulse width */
+#define CICR3_LPF_VAL(x)  (((x) << 0) & CICR3_LPF)  /* Lines per frame */
+
 #define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM | \
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
@@ -83,8 +102,6 @@ struct pxa_camera_dev {
 	void __iomem		*base;
 	unsigned int		dma_chan_y;
 
-	enum v4l2_buf_type	type;
-
 	struct pxacamera_platform_data *pdata;
 	struct resource		*res;
 	unsigned long		platform_flags;
@@ -94,8 +111,6 @@ struct pxa_camera_dev {
 
 	spinlock_t		lock;
 
-	int			dma_running;
-
 	struct pxa_buffer	*active;
 };
 
@@ -106,9 +121,8 @@ static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
 /*
  *  Videobuf operations
  */
-static int
-pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
-		   unsigned int *size)
+static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
 
@@ -151,9 +165,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
-static int
-pxa_videobuf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-						enum v4l2_field field)
+static int pxa_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici =
@@ -255,15 +268,15 @@ out:
 	return ret;
 }
 
-static void
-pxa_videobuf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+static void pxa_videobuf_queue(struct videobuf_queue *vq,
+			       struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-	struct pxa_buffer *active = pcdev->active;
+	struct pxa_buffer *active;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
 	int nents = dma->sglen;
 	unsigned long flags;
@@ -275,8 +288,9 @@ pxa_videobuf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	vb->state = VIDEOBUF_ACTIVE;
+	active = pcdev->active;
 
-	if (!pcdev->active) {
+	if (!active) {
 		CIFR |= CIFR_RESET_F;
 		DDADR(pcdev->dma_chan_y) = buf->sg_dma;
 		DCSR(pcdev->dma_chan_y) = DCSR_RUN;
@@ -373,22 +387,21 @@ static void pxa_camera_dma_irq_y(int channel, void *data)
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	status = DCSR(pcdev->dma_chan_y);
+	DCSR(pcdev->dma_chan_y) = status;
+
 	if (status & DCSR_BUSERR) {
-		dev_err(pcdev->dev, "%s: Bus Error\n", __FUNCTION__);
-		DCSR(pcdev->dma_chan_y) |= DCSR_BUSERR;
+		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
 		goto out;
 	}
 
 	if (!(status & DCSR_ENDINTR)) {
-		dev_err(pcdev->dev, "%s: unknown dma interrupt source. "
-			"status: 0x%08x\n", __FUNCTION__, status);
+		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
+			"status: 0x%08x\n", status);
 		goto out;
 	}
 
-	DCSR(pcdev->dma_chan_y) |= DCSR_ENDINTR;
-
 	if (!pcdev->active) {
-		dev_err(pcdev->dev, "%s: no active buf\n", __FUNCTION__);
+		dev_err(pcdev->dev, "DMA End IRQ with no active buffer!\n");
 		goto out;
 	}
 
@@ -398,7 +411,7 @@ static void pxa_camera_dma_irq_y(int channel, void *data)
 	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
 		vb, vb->baddr, vb->bsize);
 
-	/* _init is used to debug races, see comment in pxa_is_reqbufs() */
+	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
 	do_gettimeofday(&vb->ts);
@@ -419,7 +432,7 @@ out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static struct videobuf_queue_ops pxa_video_ops = {
+static struct videobuf_queue_ops pxa_videobuf_ops = {
 	.buf_setup      = pxa_videobuf_setup,
 	.buf_prepare    = pxa_videobuf_prepare,
 	.buf_queue      = pxa_videobuf_queue,
@@ -444,7 +457,7 @@ static int mclk_get_divisor(struct pxa_camera_dev *pcdev)
 	return div;
 }
 
-static void pxa_is_activate(struct pxa_camera_dev *pcdev)
+static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 {
 	struct pxacamera_platform_data *pdata = pcdev->pdata;
 	u32 cicr4 = 0;
@@ -486,7 +499,7 @@ static void pxa_is_activate(struct pxa_camera_dev *pcdev)
 	clk_enable(pcdev->clk);
 }
 
-static void pxa_is_deactivate(struct pxa_camera_dev *pcdev)
+static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 {
 	struct pxacamera_platform_data *board = pcdev->pdata;
 
@@ -518,7 +531,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 
 /* The following two functions absolutely depend on the fact, that
  * there can be only one camera on PXA quick capture interface */
-static int pxa_is_add_device(struct soc_camera_device *icd)
+static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
@@ -534,7 +547,7 @@ static int pxa_is_add_device(struct soc_camera_device *icd)
 	dev_info(&icd->dev, "PXA Camera driver attached to camera %d\n",
 		 icd->devnum);
 
-	pxa_is_activate(pcdev);
+	pxa_camera_activate(pcdev);
 	ret = icd->ops->init(icd);
 
 	if (!ret)
@@ -546,7 +559,7 @@ ebusy:
 	return ret;
 }
 
-static void pxa_is_remove_device(struct soc_camera_device *icd)
+static void pxa_camera_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
@@ -563,13 +576,13 @@ static void pxa_is_remove_device(struct soc_camera_device *icd)
 
 	icd->ops->release(icd);
 
-	pxa_is_deactivate(pcdev);
+	pxa_camera_deactivate(pcdev);
 
 	pcdev->icd = NULL;
 }
 
-static int pxa_is_set_capture_format(struct soc_camera_device *icd,
-				     __u32 pixfmt, struct v4l2_rect *rect)
+static int pxa_camera_set_capture_format(struct soc_camera_device *icd,
+					 __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
@@ -652,14 +665,14 @@ static int pxa_is_set_capture_format(struct soc_camera_device *icd,
 
 	/* CIF interrupts are not used, only DMA */
 	CICR0 = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-			0 : (CICR0_SL_CAP_EN | CICR0_SIM_SP)) |
+		 CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP)) |
 		CICR0_DMAEN | CICR0_IRQ_MASK | (cicr0 & CICR0_ENB);
 
 	return 0;
 }
 
-static int pxa_is_try_fmt_cap(struct soc_camera_host *ici,
-			      struct v4l2_format *f)
+static int pxa_camera_try_fmt_cap(struct soc_camera_host *ici,
+				  struct v4l2_format *f)
 {
 	/* limit to pxa hardware capabilities */
 	if (f->fmt.pix.height < 32)
@@ -675,8 +688,8 @@ static int pxa_is_try_fmt_cap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int pxa_is_reqbufs(struct soc_camera_file *icf,
-			  struct v4l2_requestbuffers *p)
+static int pxa_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
 {
 	int i;
 
@@ -694,7 +707,7 @@ static int pxa_is_reqbufs(struct soc_camera_file *icf,
 	return 0;
 }
 
-static unsigned int pxa_is_poll(struct file *file, poll_table *pt)
+static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct pxa_buffer *buf;
@@ -711,8 +724,8 @@ static unsigned int pxa_is_poll(struct file *file, poll_table *pt)
 	return 0;
 }
 
-static int pxa_is_querycap(struct soc_camera_host *ici,
-			   struct v4l2_capability *cap)
+static int pxa_camera_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
 {
 	/* cap->name is set by the firendly caller:-> */
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
@@ -725,15 +738,15 @@ static int pxa_is_querycap(struct soc_camera_host *ici,
 /* Should beallocated dynamically too, but we have only one. */
 static struct soc_camera_host pxa_soc_camera_host = {
 	.drv_name		= PXA_CAM_DRV_NAME,
-	.vbq_ops		= &pxa_video_ops,
-	.add			= pxa_is_add_device,
-	.remove			= pxa_is_remove_device,
+	.vbq_ops		= &pxa_videobuf_ops,
+	.add			= pxa_camera_add_device,
+	.remove			= pxa_camera_remove_device,
 	.msize			= sizeof(struct pxa_buffer),
-	.set_capture_format	= pxa_is_set_capture_format,
-	.try_fmt_cap		= pxa_is_try_fmt_cap,
-	.reqbufs		= pxa_is_reqbufs,
-	.poll			= pxa_is_poll,
-	.querycap		= pxa_is_querycap,
+	.set_capture_format	= pxa_camera_set_capture_format,
+	.try_fmt_cap		= pxa_camera_try_fmt_cap,
+	.reqbufs		= pxa_camera_reqbufs,
+	.poll			= pxa_camera_poll,
+	.querycap		= pxa_camera_querycap,
 };
 
 static int pxa_camera_probe(struct platform_device *pdev)
@@ -753,8 +766,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev) {
-		dev_err(&pdev->dev, "%s: Could not allocate pcdev\n",
-			__FUNCTION__);
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -871,51 +883,17 @@ static int __devexit pxa_camera_remove(struct platform_device *pdev)
 
 	kfree(pcdev);
 
-	dev_info(&pdev->dev, "%s: PXA Camera driver unloaded\n", __FUNCTION__);
-
-	return 0;
-}
-
-/*
- * Suspend the Camera Module.
- */
-static int pxa_camera_suspend(struct platform_device *pdev, pm_message_t level)
-{
-	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
 
-	dev_info(&pdev->dev, "camera suspend\n");
-	disable_irq(pcdev->irq);
 	return 0;
 }
 
-/*
- * Resume the Camera Module.
- */
-static int pxa_camera_resume(struct platform_device *pdev)
-{
-	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
-
-	dev_info(&pdev->dev, "camera resume\n");
-	enable_irq(pcdev->irq);
-
-/* 	if (pcdev) {	*/ /* FIXME: dev in use? */
-/* 		DRCMR68 = pcdev->dma_chan_y  | DRCMR_MAPVLD; */
-/* 		DRCMR69 = pcdev->dma_chan_cb | DRCMR_MAPVLD; */
-/* 		DRCMR70 = pcdev->dma_chan_cr | DRCMR_MAPVLD; */
-/* 	} */
-
-	return 0;
-}
-
-
 static struct platform_driver pxa_camera_driver = {
 	.driver 	= {
 		.name	= PXA_CAM_DRV_NAME,
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= __exit_p(pxa_camera_remove),
-	.suspend	= pxa_camera_suspend,
-	.resume		= pxa_camera_resume,
 };
 
 
diff --git a/include/asm-arm/arch-pxa/pxa-regs.h b/include/asm-arm/arch-pxa/pxa-regs.h
index 9c1d3ed..099b8ee 100644
--- a/include/asm-arm/arch-pxa/pxa-regs.h
+++ b/include/asm-arm/arch-pxa/pxa-regs.h
@@ -2013,11 +2013,6 @@
 #define CICR0_ENB	(1 << 28)	/* Camera interface enable */
 #define CICR0_DIS	(1 << 27)	/* Camera interface disable */
 #define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
-#define CICR0_SIM_MP	(0 << 24)
-#define CICR0_SIM_SP	(1 << 24)
-#define CICR0_SIM_MS	(2 << 24)
-#define CICR0_SIM_EP	(3 << 24)
-#define CICR0_SIM_ES	(4 << 24)
 #define CICR0_TOM	(1 << 9)	/* Time-out mask */
 #define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
 #define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
@@ -2068,20 +2063,6 @@
 #define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
 #define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
 
-#define CICR1_DW_VAL(x)		((x) & CICR1_DW)		/* Data bus width */
-#define CICR1_PPL_VAL(x)	(((x) << 15) & CICR1_PPL)	/* Pixels per line */
-
-#define CICR2_BLW_VAL(x)	(((x) << 24) & CICR2_BLW)	/* Beginning-of-line pixel clock wait count */
-#define CICR2_ELW_VAL(x)	(((x) << 16) & CICR2_ELW)	/* End-of-line pixel clock wait count */
-#define CICR2_HSW_VAL(x)	(((x) << 10) & CICR2_HSW)	/* Horizontal sync pulse width */
-#define CICR2_BFPW_VAL(x)	(((x) << 3) & CICR2_BFPW)	/* Beginning-of-frame pixel clock wait count */
-#define CICR2_FSW_VAL(x)	(((x) << 0) & CICR2_FSW)	/* Frame stabilization wait count */
-
-#define CICR3_BFW_VAL(x)	(((x) << 24) & CICR3_BFW)	/* Beginning-of-frame line clock wait count  */
-#define CICR3_EFW_VAL(x)	(((x) << 16) & CICR3_EFW)	/* End-of-frame line clock wait count */
-#define CICR3_VSW_VAL(x)	(((x) << 11) & CICR3_VSW)	/* Vertical sync pulse width */
-#define CICR3_LPF_VAL(x)	(((x) << 0) & CICR3_LPF)	/* Lines per frame */
-
 #define CISR_FTO	(1 << 15)	/* FIFO time-out */
 #define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
 #define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
