Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:44496 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab2HOUik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:38:40 -0400
Message-Id: <E1T1kMQ-0007NG-Mi@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 15 Aug 2012 22:17:29 +0200
Subject: [git:v4l-dvb/for_v3.7] [media] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare
To: linuxtv-commits@linuxtv.org
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare
Author:  Fabio Estevam <fabio.estevam@freescale.com>
Date:    Fri May 25 20:14:48 2012 -0300

Prepare the clock before enabling it.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/platform/mx2_camera.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=561d5d78cb03fe08519a166594820c5a70f3931c

diff --git a/drivers/media/platform/mx2_camera.c b/drivers/media/platform/mx2_camera.c
index 637bde8..2c3ec94 100644
--- a/drivers/media/platform/mx2_camera.c
+++ b/drivers/media/platform/mx2_camera.c
@@ -407,7 +407,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
 
-	clk_disable(pcdev->clk_csi);
+	clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -435,7 +435,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	ret = clk_enable(pcdev->clk_csi);
+	ret = clk_prepare_enable(pcdev->clk_csi);
 	if (ret < 0)
 		return ret;
 
@@ -1639,7 +1639,7 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
 		goto exit_free_irq;
 	}
 
-	clk_enable(pcdev->clk_emma);
+	clk_prepare_enable(pcdev->clk_emma);
 
 	err = mx27_camera_emma_prp_reset(pcdev);
 	if (err)
@@ -1648,7 +1648,7 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
 	return err;
 
 exit_clk_emma_put:
-	clk_disable(pcdev->clk_emma);
+	clk_disable_unprepare(pcdev->clk_emma);
 	clk_put(pcdev->clk_emma);
 exit_free_irq:
 	free_irq(pcdev->irq_emma, pcdev);
@@ -1785,7 +1785,7 @@ exit_free_emma:
 eallocctx:
 	if (cpu_is_mx27()) {
 		free_irq(pcdev->irq_emma, pcdev);
-		clk_disable(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
 		iounmap(pcdev->base_emma);
 		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
@@ -1825,7 +1825,7 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	iounmap(pcdev->base_csi);
 
 	if (cpu_is_mx27()) {
-		clk_disable(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma);
 		clk_put(pcdev->clk_emma);
 		iounmap(pcdev->base_emma);
 		res = pcdev->res_emma;
