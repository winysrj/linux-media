Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbcCXX2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 22/51] v4l: vsp1: Fix 80 characters per line violations
Date: Fri, 25 Mar 2016 01:27:18 +0200
Message-Id: <1458862067-19525-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit f7234138f14c ("v4l2-subdev: replace v4l2_subdev_fh by
v4l2_subdev_pad_config") introduced lots of 80 characters per line
violations. Fix them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c  | 12 ++++++++----
 drivers/media/platform/vsp1/vsp1_lif.c  |  6 ++++--
 drivers/media/platform/vsp1/vsp1_lut.c  |  6 ++++--
 drivers/media/platform/vsp1/vsp1_rwpf.c | 12 ++++++++----
 drivers/media/platform/vsp1/vsp1_rwpf.h |  6 ++++--
 drivers/media/platform/vsp1/vsp1_sru.c  |  9 ++++++---
 drivers/media/platform/vsp1/vsp1_uds.c  |  9 ++++++---
 7 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 1814d8dc1cd2..fe6ebfa83311 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -195,7 +195,8 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 			return -EINVAL;
 
 		format = vsp1_entity_get_pad_format(&bru->entity, cfg,
-						    BRU_PAD_SINK(0), code->which);
+						    BRU_PAD_SINK(0),
+						    code->which);
 		code->code = format->code;
 	}
 
@@ -235,7 +236,8 @@ static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
 	}
 }
 
-static int bru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int bru_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
@@ -246,7 +248,8 @@ static int bru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	return 0;
 }
 
-static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_pad_config *cfg,
+static void bru_try_format(struct vsp1_bru *bru,
+			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -274,7 +277,8 @@ static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_pad_config *
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int bru_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 56054fddb675..53725769442d 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -128,7 +128,8 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lif_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int lif_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
@@ -139,7 +140,8 @@ static int lif_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	return 0;
 }
 
-static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int lif_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index c24712fe5f2c..1c0eefeee2f3 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -139,7 +139,8 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lut_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int lut_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
@@ -150,7 +151,8 @@ static int lut_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	return 0;
 }
 
-static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int lut_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 54070ccdc2ff..0924079b920c 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -73,11 +73,13 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static struct v4l2_rect *
-vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_pad_config *cfg, u32 which)
+vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_pad_config *cfg,
+		   u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, cfg, RWPF_PAD_SINK);
+		return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, cfg,
+						RWPF_PAD_SINK);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &rwpf->crop;
 	default:
@@ -85,7 +87,8 @@ vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_pad_config *cfg, u
 	}
 }
 
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
@@ -96,7 +99,8 @@ int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_conf
 	return 0;
 }
 
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index bda0416dc7db..57f15d45f8bb 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -86,9 +86,11 @@ int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_size_enum *fse);
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt);
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt);
 int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_pad_config *cfg,
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 5a7ffbd18043..d81a5b6300de 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -209,7 +209,8 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int sru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int sru_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
@@ -220,7 +221,8 @@ static int sru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	return 0;
 }
 
-static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_pad_config *cfg,
+static void sru_try_format(struct vsp1_sru *sru,
+			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -271,7 +273,8 @@ static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_pad_config *
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int sru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int sru_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 7eaf42a2b036..286d0daea810 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -222,7 +222,8 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int uds_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int uds_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
@@ -233,7 +234,8 @@ static int uds_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_con
 	return 0;
 }
 
-static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_pad_config *cfg,
+static void uds_try_format(struct vsp1_uds *uds,
+			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -269,7 +271,8 @@ static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_pad_config *
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int uds_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
+static int uds_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
-- 
2.7.3

