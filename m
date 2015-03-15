Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35150 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbCOOdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 10:33:22 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH/RFC] v4l: vsp1: Fix Suspend-to-RAM
Date: Sun, 15 Mar 2015 23:33:07 +0900
Message-Id: <1426429987-3134-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>

Fix Suspend-to-RAM
so that VSP1 driver continues to work after resuming.

In detail,
  - Fix the judgment of ref count in resuming.
  - Add stopping VSP1 during suspend.

Signed-off-by: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>
Signed-off-by: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is based on the master branch of linuxtv.org/media_tree.git.

 drivers/media/platform/vsp1/vsp1_drv.c   | 39 ++++++++++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_video.c | 31 ++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |  5 +++-
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 913485a..b6e9cbc 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_drv.c  --  R-Car VSP1 Driver
  *
- * Copyright (C) 2013-2014 Renesas Electronics Corporation
+ * Copyright (C) 2013-2015 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
@@ -397,26 +397,57 @@ void vsp1_device_put(struct vsp1_device *vsp1)
 static int vsp1_pm_suspend(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	unsigned int i = 0;
+	int ret = 0;
 
 	WARN_ON(mutex_is_locked(&vsp1->lock));
 
 	if (vsp1->ref_count == 0)
 		return 0;
 
+	/* Suspend pipeline */
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		ret = vsp1_pipeline_suspend(pipe);
+		if (ret < 0)
+			break;
+	}
+
 	clk_disable_unprepare(vsp1->clock);
-	return 0;
+	return ret;
 }
 
 static int vsp1_pm_resume(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	unsigned int i = 0;
 
 	WARN_ON(mutex_is_locked(&vsp1->lock));
 
-	if (vsp1->ref_count)
+	if (vsp1->ref_count == 0)
 		return 0;
 
-	return clk_prepare_enable(vsp1->clock);
+	clk_prepare_enable(vsp1->clock);
+
+	/* Resume pipeline */
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		vsp1_pipeline_resume(pipe);
+	}
+
+	return 0;
 }
 #endif
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d91f19a..c744608 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_video.c  --  R-Car VSP1 Video Node
  *
- * Copyright (C) 2013-2014 Renesas Electronics Corporation
+ * Copyright (C) 2013-2015 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
@@ -662,6 +662,35 @@ done:
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+int vsp1_pipeline_suspend(struct vsp1_pipeline *pipe)
+{
+	unsigned long flags;
+	int ret;
+
+	if (pipe == NULL)
+		return 0;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+	if (pipe->state == VSP1_PIPELINE_RUNNING)
+		pipe->state = VSP1_PIPELINE_STOPPING;
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	ret = wait_event_timeout(pipe->wq, pipe->state == VSP1_PIPELINE_STOPPED,
+				 msecs_to_jiffies(500));
+	ret = ret == 0 ? -ETIMEDOUT : 0;
+
+	return ret;
+}
+
+void vsp1_pipeline_resume(struct vsp1_pipeline *pipe)
+{
+	if (pipe == NULL)
+		return;
+
+	if (vsp1_pipeline_ready(pipe))
+		vsp1_pipeline_run(pipe);
+}
+
 /*
  * Propagate the alpha value through the pipeline.
  *
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index fd2851a..958a166 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_video.h  --  R-Car VSP1 Video Node
  *
- * Copyright (C) 2013-2014 Renesas Electronics Corporation
+ * Copyright (C) 2013-2015 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
@@ -149,4 +149,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_entity *input,
 				   unsigned int alpha);
 
+int vsp1_pipeline_suspend(struct vsp1_pipeline *pipe);
+void vsp1_pipeline_resume(struct vsp1_pipeline *pipe);
+
 #endif /* __VSP1_VIDEO_H__ */
-- 
1.9.1

