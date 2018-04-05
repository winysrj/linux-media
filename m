Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbeDEJSh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:37 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 04/15] v4l: vsp1: Use vsp1_entity.pipe to check if entity belongs to a pipeline
Date: Thu,  5 Apr 2018 12:18:29 +0300
Message-Id: <20180405091840.30728-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRM pipeline handling code uses the entity's pipe list head to check
whether the entity is already included in a pipeline. This method is a
bit fragile in the sense that it uses list_empty() on a list_head that
is a list member. Replace it by a simpler check for the entity pipe
pointer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a7ad85ab0b08..e210917fdc3f 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -119,9 +119,9 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 			 * Remove the RPF from the pipe and the list of BRU
 			 * inputs.
 			 */
-			WARN_ON(list_empty(&rpf->entity.list_pipe));
+			WARN_ON(!rpf->entity.pipe);
 			rpf->entity.pipe = NULL;
-			list_del_init(&rpf->entity.list_pipe);
+			list_del(&rpf->entity.list_pipe);
 			pipe->inputs[i] = NULL;
 
 			bru->inputs[rpf->bru_input].rpf = NULL;
@@ -537,7 +537,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 			continue;
 		}
 
-		if (list_empty(&rpf->entity.list_pipe)) {
+		if (!rpf->entity.pipe) {
 			rpf->entity.pipe = pipe;
 			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
 		}
@@ -566,7 +566,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 					   VI6_DPR_NODE_UNUSED);
 
 			entity->pipe = NULL;
-			list_del_init(&entity->list_pipe);
+			list_del(&entity->list_pipe);
 
 			continue;
 		}
-- 
Regards,

Laurent Pinchart
