Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbcCYKoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:44 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 17/54] v4l: vsp1: Don't setup control handler when starting streaming
Date: Fri, 25 Mar 2016 12:43:51 +0200
Message-Id: <1458902668-1141-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control handler set operations don't program the hardware anymore,
there's thus no need to call them when starting the stream.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    |  5 +----
 drivers/media/platform/vsp1/vsp1_entity.c | 18 +-----------------
 drivers/media/platform/vsp1/vsp1_entity.h |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  5 +----
 drivers/media/platform/vsp1/vsp1_sru.c    |  5 +----
 drivers/media/platform/vsp1/vsp1_wpf.c    |  5 +----
 6 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 16345ec66870..5feec203e6fb 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -66,11 +66,8 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
-	int ret;
 
-	ret = vsp1_entity_set_streaming(&bru->entity, enable);
-	if (ret < 0)
-		return ret;
+	vsp1_entity_set_streaming(&bru->entity, enable);
 
 	if (!enable)
 		return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index a94f544dcc77..6b425ae9aba3 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -45,29 +45,13 @@ bool vsp1_entity_is_streaming(struct vsp1_entity *entity)
 	return streaming;
 }
 
-int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
+void vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 {
 	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&entity->lock, flags);
 	entity->streaming = streaming;
 	spin_unlock_irqrestore(&entity->lock, flags);
-
-	if (!streaming)
-		return 0;
-
-	if (!entity->vsp1->info->uapi || !entity->subdev.ctrl_handler)
-		return 0;
-
-	ret = v4l2_ctrl_handler_setup(entity->subdev.ctrl_handler);
-	if (ret < 0) {
-		spin_lock_irqsave(&entity->lock, flags);
-		entity->streaming = false;
-		spin_unlock_irqrestore(&entity->lock, flags);
-	}
-
-	return ret;
 }
 
 void vsp1_entity_route_setup(struct vsp1_entity *source)
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 259880e524fe..c0d6db82ebfb 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -101,7 +101,7 @@ void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg);
 
 bool vsp1_entity_is_streaming(struct vsp1_entity *entity);
-int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
+void vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
 
 void vsp1_entity_route_setup(struct vsp1_entity *source);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 8721c82801ca..8c7c385ec046 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -45,11 +45,8 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	const struct v4l2_rect *crop = &rpf->crop;
 	u32 pstride;
 	u32 infmt;
-	int ret;
 
-	ret = vsp1_entity_set_streaming(&rpf->entity, enable);
-	if (ret < 0)
-		return ret;
+	vsp1_entity_set_streaming(&rpf->entity, enable);
 
 	if (!enable)
 		return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index d2c705563cd7..a97541492af8 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -113,11 +113,8 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct v4l2_mbus_framefmt *input;
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
-	int ret;
 
-	ret = vsp1_entity_set_streaming(&sru->entity, enable);
-	if (ret < 0)
-		return ret;
+	vsp1_entity_set_streaming(&sru->entity, enable);
 
 	if (!enable)
 		return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1ca08f4d67c2..a7101f700d9e 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -46,11 +46,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	unsigned int i;
 	u32 srcrpf = 0;
 	u32 outfmt = 0;
-	int ret;
 
-	ret = vsp1_entity_set_streaming(&wpf->entity, enable);
-	if (ret < 0)
-		return ret;
+	vsp1_entity_set_streaming(&wpf->entity, enable);
 
 	if (!enable) {
 		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
-- 
2.7.3

