Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbcBHLoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:20 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 32/35] v4l: vsp1: Disconnect unused RPFs from the DRM pipeline
Date: Mon,  8 Feb 2016 13:44:02 +0200
Message-Id: <1454931845-23864-33-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index ac81ff10c339..a918bb4ab46c 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -38,13 +38,17 @@ static int vsp1_drm_pipeline_run(struct vsp1_pipeline *pipe)
 		struct vsp1_entity *entity;
 
 		list_for_each_entry(entity, &pipe->entities, list_pipe) {
-			/* Skip unused RPFs. */
+			/* Disconnect unused RPFs from the pipeline. */
 			if (entity->type == VSP1_ENTITY_RPF) {
 				struct vsp1_rwpf *rpf =
 					to_rwpf(&entity->subdev);
 
-				if (!pipe->inputs[rpf->entity.index])
+				if (!pipe->inputs[rpf->entity.index]) {
+					vsp1_write(entity->vsp1,
+						   entity->route->reg,
+						   VI6_DPR_NODE_UNUSED);
 					continue;
+				}
 			}
 
 			vsp1_entity_route_setup(entity);
-- 
2.4.10

