Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:49216
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab2BPSZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:25:56 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@infradead.org>, <g.liakhovetski@gmx.de>,
	<javier.martin@vista-silicon.com>, <baruch@tkos.co.il>,
	<kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] media: video: mx2_camera: Remove ifdef's
Date: Thu, 16 Feb 2012 16:25:39 -0200
Message-ID: <1329416739-23566-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we are able to build a same kernel that supports both mx27 and mx25, we should remove
the ifdef's for CONFIG_MACH_MX27 in the mx2_camera driver.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_camera.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 04aab0c..afb4619 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -38,9 +38,7 @@
 #include <linux/videodev2.h>
 
 #include <mach/mx2_cam.h>
-#ifdef CONFIG_MACH_MX27
 #include <mach/dma-mx1-mx2.h>
-#endif
 #include <mach/hardware.h>
 
 #include <asm/dma.h>
@@ -402,7 +400,6 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
 	pcdev->icd = NULL;
 }
 
-#ifdef CONFIG_MACH_MX27
 static void mx27_camera_dma_enable(struct mx2_camera_dev *pcdev)
 {
 	u32 tmp;
@@ -419,6 +416,9 @@ static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
 	struct mx2_camera_dev *pcdev = data;
 	u32 status = readl(pcdev->base_csi + CSISR);
 
+	if(!cpu_is_mx27())
+		return IRQ_NONE;
+
 	if (status & CSISR_SOF_INT && pcdev->active) {
 		u32 tmp;
 
@@ -431,12 +431,6 @@ static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
 
 	return IRQ_HANDLED;
 }
-#else
-static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
-{
-	return IRQ_NONE;
-}
-#endif /* CONFIG_MACH_MX27 */
 
 static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		int state)
@@ -619,7 +613,6 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 
 	if (mx27_camera_emma(pcdev)) {
 		goto out;
-#ifdef CONFIG_MACH_MX27
 	} else if (cpu_is_mx27()) {
 		int ret;
 
@@ -637,7 +630,6 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 			vb->state = VIDEOBUF_ACTIVE;
 			pcdev->active = buf;
 		}
-#endif
 	} else { /* cpu_is_mx25() */
 		u32 csicr3, dma_inten = 0;
 
@@ -1201,7 +1193,6 @@ static int mx2_camera_reqbufs(struct soc_camera_device *icd,
 	return 0;
 }
 
-#ifdef CONFIG_MACH_MX27
 static void mx27_camera_frame_done(struct mx2_camera_dev *pcdev, int state)
 {
 	struct videobuf_buffer *vb;
@@ -1310,7 +1301,6 @@ err_out:
 
 	return err;
 }
-#endif /* CONFIG_MACH_MX27 */
 
 static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
 {
@@ -1558,13 +1548,11 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 			clk_get_rate(pcdev->clk_csi));
 
 	/* Initialize DMA */
-#ifdef CONFIG_MACH_MX27
 	if (cpu_is_mx27()) {
 		err = mx27_camera_dma_init(pdev, pcdev);
 		if (err)
 			goto exit_clk_put;
 	}
-#endif /* CONFIG_MACH_MX27 */
 
 	pcdev->res_csi = res_csi;
 	pcdev->pdata = pdev->dev.platform_data;
@@ -1657,12 +1645,10 @@ exit_iounmap:
 exit_release:
 	release_mem_region(res_csi->start, resource_size(res_csi));
 exit_dma_free:
-#ifdef CONFIG_MACH_MX27
 	if (cpu_is_mx27())
 		imx_dma_free(pcdev->dma);
 exit_clk_put:
 	clk_put(pcdev->clk_csi);
-#endif /* CONFIG_MACH_MX27 */
 exit_kfree:
 	kfree(pcdev);
 exit:
@@ -1677,10 +1663,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	clk_put(pcdev->clk_csi);
-#ifdef CONFIG_MACH_MX27
 	if (cpu_is_mx27())
 		imx_dma_free(pcdev->dma);
-#endif /* CONFIG_MACH_MX27 */
 	free_irq(pcdev->irq_csi, pcdev);
 	if (mx27_camera_emma(pcdev))
 		free_irq(pcdev->irq_emma, pcdev);
-- 
1.7.1


