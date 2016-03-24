Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbcCXX2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 49/51] v4l: vsp1: lut: Use display list fragments to fill LUT
Date: Fri, 25 Mar 2016 01:27:45 +0200
Message-Id: <1458862067-19525-50-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Synchronize the userspace LUT setup with the pipeline operation by using
a display list fragment to store LUT data.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 31 ++++++++++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_lut.h |  6 +++++-
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index d45f563dea00..c5250abfd0d0 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -38,10 +38,25 @@ static inline void vsp1_lut_write(struct vsp1_lut *lut, struct vsp1_dl_list *dl,
  * V4L2 Subdevice Core Operations
  */
 
-static void lut_set_table(struct vsp1_lut *lut, struct vsp1_lut_config *config)
+static int lut_set_table(struct vsp1_lut *lut, struct vsp1_lut_config *config)
 {
-	memcpy_toio(lut->entity.vsp1->mmio + VI6_LUT_TABLE, config->lut,
-		    sizeof(config->lut));
+	struct vsp1_dl_body *dlb;
+	unsigned int i;
+
+	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, ARRAY_SIZE(config->lut));
+	if (!dlb)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(config->lut); ++i)
+		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
+				       config->lut[i]);
+
+	mutex_lock(&lut->lock);
+	swap(lut->lut, dlb);
+	mutex_unlock(&lut->lock);
+
+	vsp1_dl_fragment_free(dlb);
+	return 0;
 }
 
 static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
@@ -50,8 +65,7 @@ static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
 
 	switch (cmd) {
 	case VIDIOC_VSP1_LUT_CONFIG:
-		lut_set_table(lut, arg);
-		return 0;
+		return lut_set_table(lut, arg);
 
 	default:
 		return -ENOIOCTLCMD;
@@ -161,6 +175,13 @@ static void lut_configure(struct vsp1_entity *entity,
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
 	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+
+	mutex_lock(&lut->lock);
+	if (lut->lut) {
+		vsp1_dl_list_add_fragment(dl, lut->lut);
+		lut->lut = NULL;
+	}
+	mutex_unlock(&lut->lock);
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index f92ffb867350..cef874f22b6a 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -13,6 +13,8 @@
 #ifndef __VSP1_LUT_H__
 #define __VSP1_LUT_H__
 
+#include <linux/mutex.h>
+
 #include <media/media-entity.h>
 #include <media/v4l2-subdev.h>
 
@@ -25,7 +27,9 @@ struct vsp1_device;
 
 struct vsp1_lut {
 	struct vsp1_entity entity;
-	u32 lut[256];
+
+	struct mutex lock;
+	struct vsp1_dl_body *lut;
 };
 
 static inline struct vsp1_lut *to_lut(struct v4l2_subdev *subdev)
-- 
2.7.3

