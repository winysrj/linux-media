Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758819AbcIMXQe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 03/13] v4l: vsp1: Ensure pipeline locking in resume path
Date: Wed, 14 Sep 2016 02:16:56 +0300
Message-Id: <1473808626-19488-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

The vsp1_pipeline_ready() and vsp1_pipeline_run() functions must be
called with the pipeline lock held, fix the resume code path.

Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 3e75fb3fcace..474de82165d8 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -365,6 +365,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 
 void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 {
+	unsigned long flags;
 	unsigned int i;
 
 	/* Resume all running pipelines. */
@@ -379,7 +380,9 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 		if (pipe == NULL)
 			continue;
 
+		spin_lock_irqsave(&pipe->irqlock, flags);
 		if (vsp1_pipeline_ready(pipe))
 			vsp1_pipeline_run(pipe);
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
 	}
 }
-- 
Regards,

Laurent Pinchart

