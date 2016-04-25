Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37359 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbcDYVg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 17:36:26 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 07/13] v4l: vsp1: Replace container_of() with dedicated macro
Date: Tue, 26 Apr 2016 00:36:32 +0300
Message-Id: <1461620198-13428-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a macro to cast from a struct media_entity to a struct vsp1_entity
to replace the manual implementations.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 6a96ea77de69..f60d7926d53f 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -22,6 +22,12 @@
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 
+static inline struct vsp1_entity *
+media_entity_to_vsp1_entity(struct media_entity *entity)
+{
+	return container_of(entity, struct vsp1_entity, subdev.entity);
+}
+
 void vsp1_entity_route_setup(struct vsp1_entity *source,
 			     struct vsp1_dl_list *dl)
 {
@@ -30,7 +36,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *source,
 	if (source->route->reg == 0)
 		return;
 
-	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
+	sink = media_entity_to_vsp1_entity(source->sink);
 	vsp1_dl_list_write(dl, source->route->reg,
 			   sink->route->inputs[source->sink_pad]);
 }
@@ -252,7 +258,7 @@ int vsp1_entity_link_setup(struct media_entity *entity,
 	if (!(local->flags & MEDIA_PAD_FL_SOURCE))
 		return 0;
 
-	source = container_of(local->entity, struct vsp1_entity, subdev.entity);
+	source = media_entity_to_vsp1_entity(local->entity);
 
 	if (!source->route)
 		return 0;
-- 
2.7.3

