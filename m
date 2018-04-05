Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54335 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbeDEJSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:46 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 14/15] v4l: vsp1: Add BRx dynamic assignment debugging messages
Date: Thu,  5 Apr 2018 12:18:39 +0300
Message-Id: <20180405091840.30728-15-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic assignment of the BRU and BRS to pipelines is prone to
regressions, add messages to make debugging easier. Keep it as a
separate commit to ease removal of those messages once the code will
deem to be completely stable.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index f82f83b6d4ff..b43d6dc0d5f5 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -190,6 +190,10 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 
 		/* Release our BRU if we have one. */
 		if (pipe->bru) {
+			dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
+				__func__, pipe->lif->index,
+				BRU_NAME(pipe->bru));
+
 			/*
 			 * The BRU might be acquired by the other pipeline in
 			 * the next step. We must thus remove it from the list
@@ -219,6 +223,9 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 		if (bru->pipe) {
 			struct vsp1_drm_pipeline *owner_pipe;
 
+			dev_dbg(vsp1->dev, "%s: pipe %u: waiting for %s\n",
+				__func__, pipe->lif->index, BRU_NAME(bru));
+
 			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
 			owner_pipe->force_bru_release = true;
 
@@ -245,6 +252,9 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 				      &pipe->entities);
 
 		/* Add the BRU to the pipeline. */
+		dev_dbg(vsp1->dev, "%s: pipe %u: acquired %s\n",
+			__func__, pipe->lif->index, BRU_NAME(bru));
+
 		pipe->bru = bru;
 		pipe->bru->pipe = pipe;
 		pipe->bru->sink = &pipe->output->entity;
@@ -548,6 +558,10 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		drm_pipe->du_complete = NULL;
 		pipe->num_inputs = 0;
 
+		dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
+			__func__, pipe->lif->index,
+			BRU_NAME(pipe->bru));
+
 		list_del(&pipe->bru->list_pipe);
 		pipe->bru->pipe = NULL;
 		pipe->bru = NULL;
-- 
Regards,

Laurent Pinchart
