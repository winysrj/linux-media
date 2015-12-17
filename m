Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336AbbLQIlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:20 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 39/48] v4l: vsp1: Implement and use the subdev pad::init_cfg configuration
Date: Thu, 17 Dec 2015 10:40:17 +0200
Message-Id: <1450341626-6695-40-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Turn the custom formats initialization function into a standard
pad::init_cfg handler and use it in subdevs instead of initializing
formats in the subdev open handler.

This makes the subdev open handler empty, so remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    |  1 +
 drivers/media/platform/vsp1/vsp1_entity.c | 26 ++++++--------------------
 drivers/media/platform/vsp1/vsp1_entity.h |  2 ++
 drivers/media/platform/vsp1/vsp1_hsit.c   |  1 +
 drivers/media/platform/vsp1/vsp1_lif.c    |  1 +
 drivers/media/platform/vsp1/vsp1_lut.c    |  1 +
 drivers/media/platform/vsp1/vsp1_rpf.c    |  1 +
 drivers/media/platform/vsp1/vsp1_sru.c    |  1 +
 drivers/media/platform/vsp1/vsp1_uds.c    |  1 +
 drivers/media/platform/vsp1/vsp1_wpf.c    |  1 +
 10 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index d8b7bdeb5af5..879dc9c9d3f0 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -387,6 +387,7 @@ static struct v4l2_subdev_video_ops bru_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops bru_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = bru_enum_mbus_code,
 	.enum_frame_size = bru_enum_frame_size,
 	.get_fmt = bru_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index caf8e413adeb..77eaabf3c6ec 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -62,16 +62,15 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 }
 
 /*
- * vsp1_entity_init_formats - Initialize formats on all pads
+ * vsp1_entity_init_cfg - Initialize formats on all pads
  * @subdev: V4L2 subdevice
  * @cfg: V4L2 subdev pad configuration
  *
- * Initialize all pad formats with default values. If cfg is not NULL, try
- * formats are initialized on the file handle. Otherwise active formats are
- * initialized on the device.
+ * Initialize all pad formats with default values in the given pad config. This
+ * function can be used as a handler for the subdev pad::init_cfg operation.
  */
-static void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
-				     struct v4l2_subdev_pad_config *cfg)
+void vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg)
 {
 	struct v4l2_subdev_format format;
 	unsigned int pad;
@@ -87,18 +86,6 @@ static void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
 	}
 }
 
-static int vsp1_entity_open(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh)
-{
-	vsp1_entity_init_formats(subdev, fh->pad);
-
-	return 0;
-}
-
-const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops = {
-	.open = vsp1_entity_open,
-};
-
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
@@ -209,13 +196,12 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	v4l2_subdev_init(subdev, ops);
 
 	subdev->entity.ops = &vsp1->media_ops;
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
 		 dev_name(vsp1->dev), name);
 
-	vsp1_entity_init_formats(subdev, NULL);
+	vsp1_entity_init_cfg(subdev, NULL);
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 0fdda82a8d9a..3c298e2482ef 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -107,6 +107,8 @@ struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, u32 which);
+void vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg);
 
 void vsp1_entity_route_setup(struct vsp1_entity *source);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 49ff74b51e03..3e36755c8c2a 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -163,6 +163,7 @@ static struct v4l2_subdev_video_ops hsit_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops hsit_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = hsit_enum_mbus_code,
 	.enum_frame_size = hsit_enum_frame_size,
 	.get_fmt = hsit_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index ead6cc3aa3fa..5edf6a742c5b 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -190,6 +190,7 @@ static struct v4l2_subdev_video_ops lif_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops lif_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lif_enum_mbus_code,
 	.enum_frame_size = lif_enum_frame_size,
 	.get_fmt = lif_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 6ba6a58fbac6..f0afc4291387 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -203,6 +203,7 @@ static struct v4l2_subdev_video_ops lut_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops lut_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lut_enum_mbus_code,
 	.enum_frame_size = lut_enum_frame_size,
 	.get_fmt = lut_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index a68f26db9b3f..69fd76eed0bb 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -127,6 +127,7 @@ static struct v4l2_subdev_video_ops rpf_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops rpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
 	.enum_frame_size = vsp1_rwpf_enum_frame_size,
 	.get_fmt = vsp1_rwpf_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index c8642bf8b1a1..043dac6644c1 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -307,6 +307,7 @@ static struct v4l2_subdev_video_ops sru_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops sru_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = sru_enum_mbus_code,
 	.enum_frame_size = sru_enum_frame_size,
 	.get_fmt = sru_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 34689adda810..666fabcd0382 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -305,6 +305,7 @@ static struct v4l2_subdev_video_ops uds_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops uds_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = uds_enum_mbus_code,
 	.enum_frame_size = uds_enum_frame_size,
 	.get_fmt = uds_get_format,
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 84772fa258a5..d46910db7e08 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -138,6 +138,7 @@ static struct v4l2_subdev_video_ops wpf_video_ops = {
 };
 
 static struct v4l2_subdev_pad_ops wpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
 	.enum_frame_size = vsp1_rwpf_enum_frame_size,
 	.get_fmt = vsp1_rwpf_get_format,
-- 
2.4.10

