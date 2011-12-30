Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:39082 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab1L3Sgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 13:36:33 -0500
Date: Fri, 30 Dec 2011 11:13:41 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] marvell-cam: Make suspend/resume work on MMP2
Message-ID: <20111230111341.30f5b20d@dt>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Somehow I didn't ever quite get around to implementing suspend/resume on
the MMP2 platform; this patch fixes that little oversight.  A bit of core
work was necessary to do the right thing in the s/g DMA case.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c  |   36 ++++++++++++++++++++-----
 drivers/media/video/marvell-ccic/mmp-driver.c |   35 ++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 80ec64d..c1f12f9 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -522,6 +522,15 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
  */
 static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 {
+	/*
+	 * The list-empty condition can hit us at resume time
+	 * if the buffer list was empty when the system was suspended.
+	 */
+	if (list_empty(&cam->buffers)) {
+		set_bit(CF_SG_RESTART, &cam->flags);
+		return;
+	}
+
 	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_3WORD);
 	mcam_sg_next_buffer(cam);
 	mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
@@ -566,6 +575,7 @@ static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 	} else {
 		set_bit(CF_SG_RESTART, &cam->flags);
 		singles++;
+		cam->vb_bufs[0] = NULL;
 	}
 	/*
 	 * Now we can give the completed frame back to user space.
@@ -661,10 +671,10 @@ static int mcam_ctlr_configure(struct mcam_camera *cam)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	clear_bit(CF_SG_RESTART, &cam->flags);
 	cam->dma_setup(cam);
 	mcam_ctlr_image(cam);
 	mcam_set_config_needed(cam, 0);
-	clear_bit(CF_SG_RESTART, &cam->flags);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	return 0;
 }
@@ -873,7 +883,8 @@ static int mcam_read_setup(struct mcam_camera *cam)
 	mcam_reset_buffers(cam);
 	mcam_ctlr_irq_enable(cam);
 	cam->state = S_STREAMING;
-	mcam_ctlr_start(cam);
+	if (!test_bit(CF_SG_RESTART, &cam->flags))
+		mcam_ctlr_start(cam);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	return 0;
 }
@@ -1818,11 +1829,15 @@ void mccic_shutdown(struct mcam_camera *cam)
 
 void mccic_suspend(struct mcam_camera *cam)
 {
-	enum mcam_state cstate = cam->state;
+	mutex_lock(&cam->s_mutex);
+	if (cam->users > 0) {
+		enum mcam_state cstate = cam->state;
 
-	mcam_ctlr_stop_dma(cam);
-	mcam_ctlr_power_down(cam);
-	cam->state = cstate;
+		mcam_ctlr_stop_dma(cam);
+		mcam_ctlr_power_down(cam);
+		cam->state = cstate;
+	}
+	mutex_unlock(&cam->s_mutex);
 }
 
 int mccic_resume(struct mcam_camera *cam)
@@ -1839,8 +1854,15 @@ int mccic_resume(struct mcam_camera *cam)
 	mutex_unlock(&cam->s_mutex);
 
 	set_bit(CF_CONFIG_NEEDED, &cam->flags);
-	if (cam->state == S_STREAMING)
+	if (cam->state == S_STREAMING) {
+		/*
+		 * If there was a buffer in the DMA engine at suspend
+		 * time, put it back on the queue or we'll forget about it.
+		 */
+		if (cam->buffer_mode == B_DMA_sg && cam->vb_bufs[0])
+			list_add(&cam->vb_bufs[0]->queue, &cam->buffers);
 		ret = mcam_read_setup(cam);
+	}
 	return ret;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index fb0b124..0d64e2d 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/list.h>
+#include <linux/pm.h>
 
 #include "mcam-core.h"
 
@@ -310,10 +311,44 @@ static int mmpcam_platform_remove(struct platform_device *pdev)
 	return mmpcam_remove(cam);
 }
 
+/*
+ * Suspend/resume support.
+ */
+#ifdef CONFIG_PM
+
+static int mmpcam_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mmp_camera *cam = mmpcam_find_device(pdev);
+
+	if (state.event != PM_EVENT_SUSPEND)
+		return 0;
+	mccic_suspend(&cam->mcam);
+	return 0;
+}
+
+static int mmpcam_resume(struct platform_device *pdev)
+{
+	struct mmp_camera *cam = mmpcam_find_device(pdev);
+
+	/*
+	 * Power up unconditionally just in case the core tries to
+	 * touch a register even if nothing was active before; trust
+	 * me, it's better this way.
+	 */
+	mmpcam_power_up(&cam->mcam);
+	return mccic_resume(&cam->mcam);
+}
+
+#endif
+
 
 static struct platform_driver mmpcam_driver = {
 	.probe		= mmpcam_probe,
 	.remove		= mmpcam_platform_remove,
+#ifdef CONFIG_PM
+	.suspend	= mmpcam_suspend,
+	.resume		= mmpcam_resume,
+#endif
 	.driver = {
 		.name	= "mmp-camera",
 		.owner	= THIS_MODULE
-- 
1.7.8.1

