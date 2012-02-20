Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2BTPRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 10:17:42 -0500
Date: Mon, 20 Feb 2012 16:17:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Fabio Estevam <festevam@gmail.com>,
	javier.martin@vista-silicon.com
Subject: [PATCH] V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make
 EMMA mandatory
In-Reply-To: <20120217093018.GS3852@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1202201615400.2836@axis700.grange>
References: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
 <1329469749-18099-2-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1202171022050.22632@axis700.grange> <20120217093018.GS3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

The i.MX27 DMA support was introduced with the initial commit of this
driver and originally created by me. However, I never got this stable
due to the racy DMA engine and used the EMMA engine instead. As the DMA
support is most probably unused and broken in its current state, remove
it. EMMA becomes the only supported mode on i.MX27.

This also helps us get rid of another user of the legacy i.MX DMA
support and remove the dependency on ARCH_MX* macros as these are
scheduled for removal.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
[g.liakhovetski@gmx.de: remove unused goto]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Sascha, I'd prefer to merge your two mx2_camera patches and additionally 
slightly improve it by removing a dangling goto. Please confirm, that 
you're ok with this version.

Thanks
Guennadi

 drivers/media/video/mx2_camera.c |  245 ++++---------------------------------
 1 files changed, 27 insertions(+), 218 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 04aab0c..f771f53 100644
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
@@ -206,8 +203,6 @@
 #define PRP_INTR_LBOVF		(1 << 7)
 #define PRP_INTR_CH2OVF		(1 << 8)
 
-#define mx27_camera_emma(pcdev)	(cpu_is_mx27() && pcdev->use_emma)
-
 #define MAX_VIDEO_MEM	16
 
 struct mx2_prp_cfg {
@@ -250,8 +245,6 @@ struct mx2_camera_dev {
 	struct mx2_buffer	*fb1_active;
 	struct mx2_buffer	*fb2_active;
 
-	int			use_emma;
-
 	u32			csicr1;
 
 	void			*discard_buffer;
@@ -330,7 +323,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 
 	clk_disable(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
 	} else if (cpu_is_mx25()) {
 		spin_lock_irqsave(&pcdev->lock, flags);
@@ -362,7 +355,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	csicr1 = CSICR1_MCLKEN;
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
 			CSICR1_RXFF_LEVEL(0);
 	} else if (cpu_is_mx27())
@@ -402,42 +395,6 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
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
@@ -617,28 +574,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &pcdev->capture);
 
-	if (mx27_camera_emma(pcdev)) {
-		goto out;
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
+	if (cpu_is_mx25()) {
 		u32 csicr3, dma_inten = 0;
 
 		if (pcdev->fb1_active == NULL) {
@@ -674,7 +610,6 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 		}
 	}
 
-out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
@@ -939,7 +874,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	if (bytesperline < 0)
 		return bytesperline;
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		ret = mx27_camera_emma_prp_reset(pcdev);
 		if (ret)
 			return ret;
@@ -1089,7 +1024,7 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
-	if (mx27_camera_emma(pcdev))
+	if (cpu_is_mx27())
 		pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
 						xlate->host_fmt->fourcc);
 
@@ -1201,117 +1136,6 @@ static int mx2_camera_reqbufs(struct soc_camera_device *icd,
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
@@ -1527,8 +1351,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	struct resource *res_csi, *res_emma;
 	void __iomem *base_csi;
 	int irq_csi, irq_emma;
-	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
-		: mx27_camera_irq;
 	int err = 0;
 
 	dev_dbg(&pdev->dev, "initialising\n");
@@ -1557,15 +1379,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
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
@@ -1606,11 +1419,13 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
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
@@ -1618,14 +1433,15 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		irq_emma = platform_get_irq(pdev, 1);
 
-		if (res_emma && irq_emma >= 0) {
-			dev_info(&pdev->dev, "Using EMMA\n");
-			pcdev->use_emma = 1;
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
@@ -1643,26 +1459,22 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_emma:
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		free_irq(pcdev->irq_emma, pcdev);
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
@@ -1677,19 +1489,16 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	clk_put(pcdev->clk_csi);
-#ifdef CONFIG_MACH_MX27
+	if (cpu_is_mx25())
+		free_irq(pcdev->irq_csi, pcdev);
 	if (cpu_is_mx27())
-		imx_dma_free(pcdev->dma);
-#endif /* CONFIG_MACH_MX27 */
-	free_irq(pcdev->irq_csi, pcdev);
-	if (mx27_camera_emma(pcdev))
 		free_irq(pcdev->irq_emma, pcdev);
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
 	iounmap(pcdev->base_csi);
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		clk_disable(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
 		iounmap(pcdev->base_emma);
-- 
1.7.2.5

