Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40191 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2BQJJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:09:23 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>, g.liakhovetski@gmx.de,
	javier.martin@vista-silicon.com, baruch@tkos.co.il,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] media/video mx2_camera: remove now unused code
Date: Fri, 17 Feb 2012 10:09:09 +0100
Message-Id: <1329469749-18099-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
References: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the i.MX27 dma code was disabled in the last patch we can
now remove the resulting dead code. I tried to do this as
mechanically as possible as I currently have no setup to test
this.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |  225 ++++----------------------------------
 1 files changed, 21 insertions(+), 204 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 65709e4..3972dc2 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -38,9 +38,6 @@
 #include <linux/videodev2.h>
 
 #include <mach/mx2_cam.h>
-#ifdef CONFIG_MACH_MX27
-#include <mach/dma-mx1-mx2.h>
-#endif
 #include <mach/hardware.h>
 
 #include <asm/dma.h>
@@ -398,42 +395,6 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
 	pcdev->icd = NULL;
 }
 
-#ifdef CONFIG_MACH_MX27
-static void mx27_camera_dma_enable(struct mx2_camera_dev *pcdev)
-{
-	u32 tmp;
-
-	imx_dma_enable(pcdev->dma);
-
-	tmp = readl(pcdev->base_csi + CSICR1);
-	tmp |= CSICR1_RF_OR_INTEN;
-	writel(tmp, pcdev->base_csi + CSICR1);
-}
-
-static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
-{
-	struct mx2_camera_dev *pcdev = data;
-	u32 status = readl(pcdev->base_csi + CSISR);
-
-	if (status & CSISR_SOF_INT && pcdev->active) {
-		u32 tmp;
-
-		tmp = readl(pcdev->base_csi + CSICR1);
-		writel(tmp | CSICR1_CLR_RXFIFO, pcdev->base_csi + CSICR1);
-		mx27_camera_dma_enable(pcdev);
-	}
-
-	writel(CSISR_SOF_INT | CSISR_RFF_OR_INT, pcdev->base_csi + CSISR);
-
-	return IRQ_HANDLED;
-}
-#else
-static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
-{
-	return IRQ_NONE;
-}
-#endif /* CONFIG_MACH_MX27 */
-
 static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		int state)
 {
@@ -615,26 +576,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 
 	if (cpu_is_mx27()) {
 		goto out;
-#ifdef CONFIG_MACH_MX27
-	} else if (cpu_is_mx27()) {
-		int ret;
-
-		if (pcdev->active == NULL) {
-			ret = imx_dma_setup_single(pcdev->dma,
-					videobuf_to_dma_contig(vb), vb->size,
-					(u32)pcdev->base_dma + 0x10,
-					DMA_MODE_READ);
-			if (ret) {
-				vb->state = VIDEOBUF_ERROR;
-				wake_up(&vb->done);
-				goto out;
-			}
-
-			vb->state = VIDEOBUF_ACTIVE;
-			pcdev->active = buf;
-		}
-#endif
-	} else { /* cpu_is_mx25() */
+	} else if (cpu_is_mx25()) {
 		u32 csicr3, dma_inten = 0;
 
 		if (pcdev->fb1_active == NULL) {
@@ -1197,117 +1139,6 @@ static int mx2_camera_reqbufs(struct soc_camera_device *icd,
 	return 0;
 }
 
-#ifdef CONFIG_MACH_MX27
-static void mx27_camera_frame_done(struct mx2_camera_dev *pcdev, int state)
-{
-	struct videobuf_buffer *vb;
-	struct mx2_buffer *buf;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-
-	if (!pcdev->active) {
-		dev_err(pcdev->dev, "%s called with no active buffer!\n",
-				__func__);
-		goto out;
-	}
-
-	vb = &pcdev->active->vb;
-	buf = container_of(vb, struct mx2_buffer, vb);
-	WARN_ON(list_empty(&vb->queue));
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-
-	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
-	list_del_init(&vb->queue);
-	vb->state = state;
-	do_gettimeofday(&vb->ts);
-	vb->field_count++;
-
-	wake_up(&vb->done);
-
-	if (list_empty(&pcdev->capture)) {
-		pcdev->active = NULL;
-		goto out;
-	}
-
-	pcdev->active = list_entry(pcdev->capture.next,
-			struct mx2_buffer, vb.queue);
-
-	vb = &pcdev->active->vb;
-	vb->state = VIDEOBUF_ACTIVE;
-
-	ret = imx_dma_setup_single(pcdev->dma, videobuf_to_dma_contig(vb),
-			vb->size, (u32)pcdev->base_dma + 0x10, DMA_MODE_READ);
-
-	if (ret) {
-		vb->state = VIDEOBUF_ERROR;
-		pcdev->active = NULL;
-		wake_up(&vb->done);
-	}
-
-out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
-}
-
-static void mx27_camera_dma_err_callback(int channel, void *data, int err)
-{
-	struct mx2_camera_dev *pcdev = data;
-
-	mx27_camera_frame_done(pcdev, VIDEOBUF_ERROR);
-}
-
-static void mx27_camera_dma_callback(int channel, void *data)
-{
-	struct mx2_camera_dev *pcdev = data;
-
-	mx27_camera_frame_done(pcdev, VIDEOBUF_DONE);
-}
-
-#define DMA_REQ_CSI_RX          31 /* FIXME: Add this to a resource */
-
-static int __devinit mx27_camera_dma_init(struct platform_device *pdev,
-		struct mx2_camera_dev *pcdev)
-{
-	int err;
-
-	pcdev->dma = imx_dma_request_by_prio("CSI RX DMA", DMA_PRIO_HIGH);
-	if (pcdev->dma < 0) {
-		dev_err(&pdev->dev, "%s failed to request DMA channel\n",
-				__func__);
-		return pcdev->dma;
-	}
-
-	err = imx_dma_setup_handlers(pcdev->dma, mx27_camera_dma_callback,
-					mx27_camera_dma_err_callback, pcdev);
-	if (err) {
-		dev_err(&pdev->dev, "%s failed to set DMA callback\n",
-				__func__);
-		goto err_out;
-	}
-
-	err = imx_dma_config_channel(pcdev->dma,
-			IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_FIFO,
-			IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
-			DMA_REQ_CSI_RX, 1);
-	if (err) {
-		dev_err(&pdev->dev, "%s failed to config DMA channel\n",
-				__func__);
-		goto err_out;
-	}
-
-	imx_dma_config_burstlen(pcdev->dma, 64);
-
-	return 0;
-
-err_out:
-	imx_dma_free(pcdev->dma);
-
-	return err;
-}
-#endif /* CONFIG_MACH_MX27 */
-
 static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
@@ -1523,8 +1354,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	struct resource *res_csi, *res_emma;
 	void __iomem *base_csi;
 	int irq_csi, irq_emma;
-	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
-		: mx27_camera_irq;
 	int err = 0;
 
 	dev_dbg(&pdev->dev, "initialising\n");
@@ -1553,15 +1382,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Camera clock frequency: %ld\n",
 			clk_get_rate(pcdev->clk_csi));
 
-	/* Initialize DMA */
-#ifdef CONFIG_MACH_MX27
-	if (cpu_is_mx27()) {
-		err = mx27_camera_dma_init(pdev, pcdev);
-		if (err)
-			goto exit_clk_put;
-	}
-#endif /* CONFIG_MACH_MX27 */
-
 	pcdev->res_csi = res_csi;
 	pcdev->pdata = pdev->dev.platform_data;
 	if (pcdev->pdata) {
@@ -1602,11 +1422,13 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->base_dma = res_csi->start;
 	pcdev->dev = &pdev->dev;
 
-	err = request_irq(pcdev->irq_csi, mx2_cam_irq_handler, 0,
-			MX2_CAM_DRV_NAME, pcdev);
-	if (err) {
-		dev_err(pcdev->dev, "Camera interrupt register failed \n");
-		goto exit_iounmap;
+	if (cpu_is_mx25()) {
+		err = request_irq(pcdev->irq_csi, mx25_camera_irq, 0,
+				MX2_CAM_DRV_NAME, pcdev);
+		if (err) {
+			dev_err(pcdev->dev, "Camera interrupt register failed \n");
+			goto exit_iounmap;
+		}
 	}
 
 	if (cpu_is_mx27()) {
@@ -1614,13 +1436,15 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		irq_emma = platform_get_irq(pdev, 1);
 
-		if (res_emma && irq_emma >= 0) {
-			dev_info(&pdev->dev, "Using EMMA\n");
-			pcdev->res_emma = res_emma;
-			pcdev->irq_emma = irq_emma;
-			if (mx27_camera_emma_init(pcdev))
-				goto exit_free_irq;
+		if (!res_emma || !irq_emma) {
+			dev_err(&pdev->dev, "no EMMA resources\n");
+			goto exit_free_irq;
 		}
+
+		pcdev->res_emma = res_emma;
+		pcdev->irq_emma = irq_emma;
+		if (mx27_camera_emma_init(pcdev))
+			goto exit_free_irq;
 	}
 
 	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,
@@ -1643,21 +1467,17 @@ exit_free_emma:
 		clk_disable(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
 		iounmap(pcdev->base_emma);
-		release_mem_region(res_emma->start, resource_size(res_emma));
+		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
 	}
 exit_free_irq:
-	free_irq(pcdev->irq_csi, pcdev);
+	if (cpu_is_mx25())
+		free_irq(pcdev->irq_csi, pcdev);
 exit_iounmap:
 	iounmap(base_csi);
 exit_release:
 	release_mem_region(res_csi->start, resource_size(res_csi));
 exit_dma_free:
-#ifdef CONFIG_MACH_MX27
-	if (cpu_is_mx27())
-		imx_dma_free(pcdev->dma);
-exit_clk_put:
 	clk_put(pcdev->clk_csi);
-#endif /* CONFIG_MACH_MX27 */
 exit_kfree:
 	kfree(pcdev);
 exit:
@@ -1672,11 +1492,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	clk_put(pcdev->clk_csi);
-#ifdef CONFIG_MACH_MX27
-	if (cpu_is_mx27())
-		imx_dma_free(pcdev->dma);
-#endif /* CONFIG_MACH_MX27 */
-	free_irq(pcdev->irq_csi, pcdev);
+	if (cpu_is_mx25())
+		free_irq(pcdev->irq_csi, pcdev);
 	if (cpu_is_mx27())
 		free_irq(pcdev->irq_emma, pcdev);
 
-- 
1.7.9

