Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbcBHLoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:19 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 30/35] v4l: vsp1: Don't validate links when the userspace API is disabled
Date: Mon,  8 Feb 2016 13:44:00 +0200
Message-Id: <1454931845-23864-31-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the pipeline is configured internally by the driver when the
userspace API is disabled its configuration can be trusted and link
validation isn't needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h        |  2 ++
 drivers/media/platform/vsp1/vsp1_bru.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_drv.c    | 10 ++++++++++
 drivers/media/platform/vsp1/vsp1_entity.c | 11 +++--------
 drivers/media/platform/vsp1/vsp1_entity.h |  5 ++++-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |  2 +-
 12 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 4fd4386a7049..454201bf59ee 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -78,6 +78,8 @@ struct vsp1_device {
 
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
+
+	struct media_entity_operations media_ops;
 };
 
 int vsp1_device_get(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index baebfbbef61d..848bfb5a42ff 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -424,7 +424,7 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	subdev = &bru->entity.subdev;
 	v4l2_subdev_init(subdev, &bru_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s bru",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 63892b2f4484..1e10fc4723c5 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -21,6 +21,8 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-subdev.h>
+
 #include "vsp1.h"
 #include "vsp1_bru.h"
 #include "vsp1_hsit.h"
@@ -214,6 +216,14 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		 dev_name(mdev->dev));
 	media_device_init(mdev);
 
+	vsp1->media_ops.link_setup = vsp1_entity_link_setup;
+	/* Don't perform link validation when the userspace API is disabled as
+	 * the pipeline is configured internally by the driver in that case, and
+	 * its configuration can thus be trusted.
+	 */
+	if (vsp1->pdata.uapi)
+		vsp1->media_ops.link_validate = v4l2_subdev_link_validate;
+
 	vdev->mdev = mdev;
 	ret = v4l2_device_register(vsp1->dev, vdev);
 	if (ret < 0) {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 338a1b0b4fad..03523899d7d0 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -131,9 +131,9 @@ const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops = {
  * Media Operations
  */
 
-static int vsp1_entity_link_setup(struct media_entity *entity,
-				  const struct media_pad *local,
-				  const struct media_pad *remote, u32 flags)
+int vsp1_entity_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
 {
 	struct vsp1_entity *source;
 
@@ -158,11 +158,6 @@ static int vsp1_entity_link_setup(struct media_entity *entity,
 	return 0;
 }
 
-const struct media_entity_operations vsp1_media_ops = {
-	.link_setup = vsp1_entity_link_setup,
-	.link_validate = v4l2_subdev_link_validate,
-};
-
 /* -----------------------------------------------------------------------------
  * Initialization
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 360a2e668ac2..83570dfde8ec 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -86,7 +86,10 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 void vsp1_entity_destroy(struct vsp1_entity *entity);
 
 extern const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops;
-extern const struct media_entity_operations vsp1_media_ops;
+
+int vsp1_entity_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags);
 
 struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 8ffb817ae525..c1087cff31a0 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -203,7 +203,7 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 	subdev = &hsit->entity.subdev;
 	v4l2_subdev_init(subdev, &hsit_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
 		 dev_name(vsp1->dev), inverse ? "hsi" : "hst");
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index b868bce08982..b8e73d32d14d 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -223,7 +223,7 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 	subdev = &lif->entity.subdev;
 	v4l2_subdev_init(subdev, &lif_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 9e33caa9c616..4b89095e7b5f 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -237,7 +237,7 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	subdev = &lut->entity.subdev;
 	v4l2_subdev_init(subdev, &lut_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s lut",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index b1d4a46f230e..3992da09e466 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -245,7 +245,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &rpf->entity.subdev;
 	v4l2_subdev_init(subdev, &rpf_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s rpf.%u",
 		 dev_name(vsp1->dev), index);
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index cff4a1d82e3b..6dcf76a1ca57 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -363,7 +363,7 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	subdev = &sru->entity.subdev;
 	v4l2_subdev_init(subdev, &sru_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s sru",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 27ad07466ebd..bba67770cf95 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -338,7 +338,7 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &uds->entity.subdev;
 	v4l2_subdev_init(subdev, &uds_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s uds.%u",
 		 dev_name(vsp1->dev), index);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 40eeaf2d76d2..849ed81d86a1 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -243,7 +243,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &wpf->entity.subdev;
 	v4l2_subdev_init(subdev, &wpf_ops);
 
-	subdev->entity.ops = &vsp1_media_ops;
+	subdev->entity.ops = &vsp1->media_ops;
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s wpf.%u",
 		 dev_name(vsp1->dev), index);
-- 
2.4.10

