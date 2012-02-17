Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40182 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2BQJJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:09:15 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>, g.liakhovetski@gmx.de,
	javier.martin@vista-silicon.com, baruch@tkos.co.il,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] media/video mx2_camera: make using emma mandatory for i.MX27
Date: Fri, 17 Feb 2012 10:09:08 +0100
Message-Id: <1329469749-18099-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
References: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i.MX27 dma support was introduced with the initial commit of
this driver and originally created by me. However, I never got
this stable due to the racy dma engine and used the EMMA engine
instead. As the DMA support is most probably unused and broken in
its current state, remove it. This also helps us to get rid of
another user of the legacy i.MX DMA support,
Also, remove the dependency on ARCH_MX* macros as these are scheduled
for removal.

This patch only removes the use_emma variable and assumes it's
hardcoded '1'. The resulting dead code is removed in the next patch.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 04aab0c..65709e4 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -206,8 +206,6 @@
 #define PRP_INTR_LBOVF		(1 << 7)
 #define PRP_INTR_CH2OVF		(1 << 8)
 
-#define mx27_camera_emma(pcdev)	(cpu_is_mx27() && pcdev->use_emma)
-
 #define MAX_VIDEO_MEM	16
 
 struct mx2_prp_cfg {
@@ -250,8 +248,6 @@ struct mx2_camera_dev {
 	struct mx2_buffer	*fb1_active;
 	struct mx2_buffer	*fb2_active;
 
-	int			use_emma;
-
 	u32			csicr1;
 
 	void			*discard_buffer;
@@ -330,7 +326,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 
 	clk_disable(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
 	} else if (cpu_is_mx25()) {
 		spin_lock_irqsave(&pcdev->lock, flags);
@@ -362,7 +358,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	csicr1 = CSICR1_MCLKEN;
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
 			CSICR1_RXFF_LEVEL(0);
 	} else if (cpu_is_mx27())
@@ -617,7 +613,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &pcdev->capture);
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		goto out;
 #ifdef CONFIG_MACH_MX27
 	} else if (cpu_is_mx27()) {
@@ -939,7 +935,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	if (bytesperline < 0)
 		return bytesperline;
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		ret = mx27_camera_emma_prp_reset(pcdev);
 		if (ret)
 			return ret;
@@ -1089,7 +1085,7 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
-	if (mx27_camera_emma(pcdev))
+	if (cpu_is_mx27())
 		pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
 						xlate->host_fmt->fourcc);
 
@@ -1620,7 +1616,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 		if (res_emma && irq_emma >= 0) {
 			dev_info(&pdev->dev, "Using EMMA\n");
-			pcdev->use_emma = 1;
 			pcdev->res_emma = res_emma;
 			pcdev->irq_emma = irq_emma;
 			if (mx27_camera_emma_init(pcdev))
@@ -1643,7 +1638,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_emma:
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		free_irq(pcdev->irq_emma, pcdev);
 		clk_disable(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
@@ -1682,14 +1677,14 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 		imx_dma_free(pcdev->dma);
 #endif /* CONFIG_MACH_MX27 */
 	free_irq(pcdev->irq_csi, pcdev);
-	if (mx27_camera_emma(pcdev))
+	if (cpu_is_mx27())
 		free_irq(pcdev->irq_emma, pcdev);
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
 	iounmap(pcdev->base_csi);
 
-	if (mx27_camera_emma(pcdev)) {
+	if (cpu_is_mx27()) {
 		clk_disable(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
 		iounmap(pcdev->base_emma);
-- 
1.7.9

