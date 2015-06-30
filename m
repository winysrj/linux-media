Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33236 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbF3Q0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 12:26:05 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2 2/2] v4l: vsp1: Fix Suspend-to-RAM
Date: Wed,  1 Jul 2015 01:25:06 +0900
Message-Id: <1435681506-24296-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1435681506-24296-1-git-send-email-ykaneko0929@gmail.com>
References: <1435681506-24296-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>

Fix Suspend-to-RAM
so that VSP1 driver continues to work after resuming.

Add stopping VSP1 during suspend.

Signed-off-by: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>
Signed-off-by: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
[Kaneko: Moved correction of vsp1_pm_resume() logic to separate patch]
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

---

This patch is based on the master branch of linuxtv.org/media_tree.git.

v2 [Yoshihiro Kaneko]
* compile tested only
* As suggested by Laurent Pinchart
  - separate a patch into two patches
  - add stop/restart the video stream code to vsp1_pipelines_suspend() and
    vsp1_pipelines_resume() function in vsp1_video.c.

 drivers/media/platform/vsp1/vsp1_drv.c   |  9 ++++-
 drivers/media/platform/vsp1/vsp1_video.c | 69 +++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |  5 ++-
 3 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index a7dfbb0..caf55e4 100644
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
@@ -403,7 +403,9 @@ static int vsp1_pm_suspend(struct device *dev)
 	if (vsp1->ref_count == 0)
 		return 0;
 
+	vsp1_pipelines_suspend(vsp1);
 	clk_disable_unprepare(vsp1->clock);
+
 	return 0;
 }
 
@@ -416,7 +418,10 @@ static int vsp1_pm_resume(struct device *dev)
 	if (vsp1->ref_count == 0)
 		return 0;
 
-	return clk_prepare_enable(vsp1->clock);
+	clk_prepare_enable(vsp1->clock);
+	vsp1_pipelines_resume(vsp1);
+
+	return 0;
 }
 #endif
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d91f19a..2be96cd 100644
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
@@ -662,6 +662,73 @@ done:
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
+{
+	unsigned int i;
+	unsigned long flags;
+	int ret;
+
+	/* To avoid increasing the system suspend time needlessly, loop over
+	 * the pipelines twice, first to set them all to the stopping state,
+	 * and then to wait for the stop to complete.
+	 */
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		if (pipe == NULL)
+			continue;
+
+		spin_lock_irqsave(&pipe->irqlock, flags);
+		if (pipe->state == VSP1_PIPELINE_RUNNING)
+			pipe->state = VSP1_PIPELINE_STOPPING;
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
+	}
+
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		if (pipe == NULL)
+			continue;
+
+		ret = wait_event_timeout(pipe->wq,
+					 pipe->state == VSP1_PIPELINE_STOPPED,
+					 msecs_to_jiffies(500));
+		if (ret == 0)
+			dev_warn(vsp1->dev, "pipeline stop timeout\n");
+	}
+}
+
+void vsp1_pipelines_resume(struct vsp1_device *vsp1)
+{
+	unsigned int i;
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
+		if (pipe == NULL)
+			continue;
+
+		if (vsp1_pipeline_ready(pipe))
+			vsp1_pipeline_run(pipe);
+	}
+}
+
 /*
  * Propagate the alpha value through the pipeline.
  *
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index fd2851a..0887a4d 100644
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
 
+void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
+void vsp1_pipelines_resume(struct vsp1_device *vsp1);
+
 #endif /* __VSP1_VIDEO_H__ */
-- 
1.9.1

