Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaFWXyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 06/23] v4l: vsp1: Fix routing cleanup when stopping the stream
Date: Tue, 24 Jun 2014 01:54:12 +0200
Message-Id: <1403567669-18539-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit d9b45ed3d8b75e8cf38c8cd1563c29217eecba27 ("v4l: vsp1: Support
multi-input entities") reworked pipeline routing configuration and
introduced a bug by writing to the entities routing registers without
first checking whether the entity had a routing register. This results
in overwriting the value at offset 0 of the device register space when
stopping the stream.

Fix this by skipping routing register write for entities without a
routing register.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 677e3aa..c717e28 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -479,7 +479,7 @@ static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	ret = ret == 0 ? -ETIMEDOUT : 0;
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->route)
+		if (entity->route && entity->route->reg)
 			vsp1_write(entity->vsp1, entity->route->reg,
 				   VI6_DPR_NODE_UNUSED);
 
-- 
1.8.5.5

