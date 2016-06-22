Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54500 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbcFVAWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 20:22:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	mchehab@kernel.org, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com
Cc: linux-samsung-soc@vger.kernel.org,
	mjpeg-users@lists.sourceforge.net, devel@driverdev.osuosl.org,
	lars@metafoo.de,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/2] [media] v4l: vsp1: Split pad operations between rpf and wpf
Date: Wed, 22 Jun 2016 02:19:24 +0200
Message-Id: <20160622001925.30077-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160622001925.30077-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160622001925.30077-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done in preparation to move s_stream from v4l2_subdev_video_ops
to v4l2_subdev_pad_ops. Only wpf implements s_stream so it will no
longer be possible to share the v4l2_subdev_pad_ops once s_stream is
moved.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 12 +++++++++-
 drivers/media/platform/vsp1/vsp1_rwpf.c | 40 +++++++++++++--------------------
 drivers/media/platform/vsp1/vsp1_rwpf.h | 20 +++++++++++++++++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 12 +++++++++-
 4 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 49168db..fabe8b2 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -38,8 +38,18 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf,
  * V4L2 Subdevice Operations
  */
 
+const struct v4l2_subdev_pad_ops vsp1_rpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_subdev_get_pad_format,
+	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
+};
+
 static struct v4l2_subdev_ops rpf_ops = {
-	.pad    = &vsp1_rwpf_pad_ops,
+	.pad    = &vsp1_rpf_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 3b6e032..ff03b9c 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -31,9 +31,9 @@ struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
  * V4L2 Subdevice Pad Operations
  */
 
-static int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
-				    struct v4l2_subdev_pad_config *cfg,
-				    struct v4l2_subdev_mbus_code_enum *code)
+int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
 		MEDIA_BUS_FMT_ARGB8888_1X32,
@@ -48,9 +48,9 @@ static int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
-				     struct v4l2_subdev_pad_config *cfg,
-				     struct v4l2_subdev_frame_size_enum *fse)
+int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 
@@ -59,9 +59,9 @@ static int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 					   rwpf->max_height);
 }
 
-static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_pad_config *cfg,
-				struct v4l2_subdev_format *fmt)
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -113,9 +113,9 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_pad_config *cfg,
-				   struct v4l2_subdev_selection *sel)
+int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -150,9 +150,9 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_pad_config *cfg,
-				   struct v4l2_subdev_selection *sel)
+int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -209,16 +209,6 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops = {
-	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
-	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_subdev_get_pad_format,
-	.set_fmt = vsp1_rwpf_set_format,
-	.get_selection = vsp1_rwpf_get_selection,
-	.set_selection = vsp1_rwpf_set_selection,
-};
-
 /* -----------------------------------------------------------------------------
  * Controls
  */
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 9ff7c78..5ed4be5 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -74,6 +74,26 @@ extern const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops;
 
 struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 				     struct v4l2_subdev_pad_config *config);
+
+int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_mbus_code_enum *code);
+
+int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_frame_size_enum *fse);
+
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_format *fmt);
+
+int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_selection *sel);
+
+int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_selection *sel);
 /**
  * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
  * @rwpf: the [RW]PF instance
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 6c91eaa..75fe7de 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -62,13 +62,23 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
  * V4L2 Subdevice Operations
  */
 
+const struct v4l2_subdev_pad_ops vsp1_wpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_subdev_get_pad_format,
+	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
+};
+
 static struct v4l2_subdev_video_ops wpf_video_ops = {
 	.s_stream = wpf_s_stream,
 };
 
 static struct v4l2_subdev_ops wpf_ops = {
 	.video	= &wpf_video_ops,
-	.pad    = &vsp1_rwpf_pad_ops,
+	.pad    = &vsp1_wpf_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.8.3

