Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:44497 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab2HOUik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:38:40 -0400
Message-Id: <E1T1kMQ-0007NZ-Si@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 15 Aug 2012 22:16:19 +0200
Subject: [git:v4l-dvb/for_v3.7] [media] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
To: linuxtv-commits@linuxtv.org
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
Author:  Fabio Estevam <fabio.estevam@freescale.com>
Date:    Fri May 25 20:14:47 2012 -0300

Prepare the clock before enabling it.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/platform/mx1_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=52cf3e42951e8316af9ff0db002f169e3efb63e9

diff --git a/drivers/media/platform/mx1_camera.c b/drivers/media/platform/mx1_camera.c
index d2e6f82..560a65a 100644
--- a/drivers/media/platform/mx1_camera.c
+++ b/drivers/media/platform/mx1_camera.c
@@ -403,7 +403,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 	dev_dbg(pcdev->icd->parent, "Activate device\n");
 
-	clk_enable(pcdev->clk);
+	clk_prepare_enable(pcdev->clk);
 
 	/* enable CSI before doing anything else */
 	__raw_writel(csicr1, pcdev->base + CSICR1);
@@ -422,7 +422,7 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
 
-	clk_disable(pcdev->clk);
+	clk_disable_unprepare(pcdev->clk);
 }
 
 /*
