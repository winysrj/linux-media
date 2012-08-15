Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:53139 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab2HXOZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 10:25:58 -0400
Message-Id: <E1T4upf-0003SB-UM@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 16 Aug 2012 00:23:43 +0200
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

 drivers/media/video/mx2_camera.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f8afbf3caa991655e989ecd10c135162d84288b2

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 637bde8..2c3ec94 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
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
