Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbbLECNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:14 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 21/32] v4l: vsp1: Make number of BRU inputs configurable
Date: Sat,  5 Dec 2015 04:12:55 +0200
Message-Id: <1449281586-25726-22-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car Gen3 family has 5-inputs BRUs, support them by making the
number of BRU inputs configurable.

As the driver assumes that the number of BRU inputs is equal to the
number of RPFs, replace the BRU_MAX_INPUTS macro with VSP1_MAX_RPF to
make the assumption apparent.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---

Changes since v1:

- Store the number of BRU inputs in the vsp1_platform_data structure

---
 drivers/media/platform/vsp1/vsp1.h        |  1 +
 drivers/media/platform/vsp1/vsp1_bru.c    | 19 ++++++++++---------
 drivers/media/platform/vsp1/vsp1_bru.h    |  3 +--
 drivers/media/platform/vsp1/vsp1_drv.c    |  3 +++
 drivers/media/platform/vsp1/vsp1_entity.h |  4 +++-
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index b25032bd37a7..29a8fd94a0aa 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -48,6 +48,7 @@ struct vsp1_platform_data {
 	unsigned int rpf_count;
 	unsigned int uds_count;
 	unsigned int wpf_count;
+	unsigned int num_bru_inputs;
 };
 
 struct vsp1_device {
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 841bc6664bca..baebfbbef61d 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -79,7 +79,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (!enable)
 		return 0;
 
-	format = &bru->entity.formats[BRU_PAD_SOURCE];
+	format = &bru->entity.formats[bru->entity.source_pad];
 
 	/* The hardware is extremely flexible but we have no userspace API to
 	 * expose all the parameters, nor is it clear whether we would have use
@@ -109,7 +109,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
 		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
 
-	for (i = 0; i < 4; ++i) {
+	for (i = 0; i < bru->entity.source_pad; ++i) {
 		bool premultiplied = false;
 		u32 ctrl = 0;
 
@@ -291,7 +291,7 @@ static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	*format = fmt->format;
 
 	/* Reset the compose rectangle */
-	if (fmt->pad != BRU_PAD_SOURCE) {
+	if (fmt->pad != bru->entity.source_pad) {
 		struct v4l2_rect *compose;
 
 		compose = bru_get_compose(bru, cfg, fmt->pad, fmt->which);
@@ -305,7 +305,7 @@ static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	if (fmt->pad == BRU_PAD_SINK(0)) {
 		unsigned int i;
 
-		for (i = 0; i <= BRU_PAD_SOURCE; ++i) {
+		for (i = 0; i <= bru->entity.source_pad; ++i) {
 			format = vsp1_entity_get_pad_format(&bru->entity, cfg,
 							    i, fmt->which);
 			format->code = fmt->format.code;
@@ -321,7 +321,7 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 {
 	struct vsp1_bru *bru = to_bru(subdev);
 
-	if (sel->pad == BRU_PAD_SOURCE)
+	if (sel->pad == bru->entity.source_pad)
 		return -EINVAL;
 
 	switch (sel->target) {
@@ -349,7 +349,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *compose;
 
-	if (sel->pad == BRU_PAD_SOURCE)
+	if (sel->pad == bru->entity.source_pad)
 		return -EINVAL;
 
 	if (sel->target != V4L2_SEL_TGT_COMPOSE)
@@ -358,8 +358,8 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	/* The compose rectangle top left corner must be inside the output
 	 * frame.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, cfg, BRU_PAD_SOURCE,
-					    sel->which);
+	format = vsp1_entity_get_pad_format(&bru->entity, cfg,
+					    bru->entity.source_pad, sel->which);
 	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
 	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
 
@@ -415,7 +415,8 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 
 	bru->entity.type = VSP1_ENTITY_BRU;
 
-	ret = vsp1_entity_init(vsp1, &bru->entity, 5);
+	ret = vsp1_entity_init(vsp1, &bru->entity,
+			       vsp1->pdata.num_bru_inputs + 1);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
index 16b1c6554911..dbac9686ea69 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_bru.h
@@ -23,7 +23,6 @@ struct vsp1_device;
 struct vsp1_rwpf;
 
 #define BRU_PAD_SINK(n)				(n)
-#define BRU_PAD_SOURCE				4
 
 struct vsp1_bru {
 	struct vsp1_entity entity;
@@ -33,7 +32,7 @@ struct vsp1_bru {
 	struct {
 		struct vsp1_rwpf *rpf;
 		struct v4l2_rect compose;
-	} inputs[4];
+	} inputs[VSP1_MAX_RPF];
 };
 
 static inline struct vsp1_bru *to_bru(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d1e42260a871..53a32f6ccbc0 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 
@@ -539,6 +540,8 @@ static int vsp1_parse_dt(struct vsp1_device *vsp1)
 		return -EINVAL;
 	}
 
+	pdata->num_bru_inputs = 4;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 9606d0d21263..360a2e668ac2 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -32,6 +32,8 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_WPF,
 };
 
+#define VSP1_ENTITY_MAX_INPUTS		5	/* For the BRU */
+
 /*
  * struct vsp1_route - Entity routing configuration
  * @type: Entity type this routing entry is associated with
@@ -48,7 +50,7 @@ struct vsp1_route {
 	enum vsp1_entity_type type;
 	unsigned int index;
 	unsigned int reg;
-	unsigned int inputs[4];
+	unsigned int inputs[VSP1_ENTITY_MAX_INPUTS];
 };
 
 struct vsp1_entity {
-- 
2.4.10

