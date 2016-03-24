Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbcCXX2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:01 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 07/51] v4l: vsp1: Set entities functions
Date: Fri, 25 Mar 2016 01:27:03 +0200
Message-Id: <1458862067-19525-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the function field of all subdev entities instantiated by the
driver. This gets rids of multiple warnings printed by the media
controller core.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_hsit.c | 2 ++
 drivers/media/platform/vsp1/vsp1_lif.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_lut.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_rpf.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_sru.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_uds.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 2 ++
 8 files changed, 16 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index cb0dbc15ddad..565c8b2edf19 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -424,7 +424,9 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	subdev = &bru->entity.subdev;
 	v4l2_subdev_init(subdev, &bru_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_COMPOSER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s bru",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index c1087cff31a0..ce42ce2e4847 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -203,7 +203,9 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 	subdev = &hsit->entity.subdev;
 	v4l2_subdev_init(subdev, &hsit_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
 		 dev_name(vsp1->dev), inverse ? "hsi" : "hst");
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 433853ce8dbf..56054fddb675 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -223,7 +223,9 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 	subdev = &lif->entity.subdev;
 	v4l2_subdev_init(subdev, &lif_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_GENERIC;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 4b89095e7b5f..f0cd4f79fbff 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -237,7 +237,9 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	subdev = &lut->entity.subdev;
 	v4l2_subdev_init(subdev, &lut_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_GENERIC;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s lut",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 5bc1d1574a43..7853e0f1d526 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -245,7 +245,9 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &rpf->entity.subdev;
 	v4l2_subdev_init(subdev, &rpf_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s rpf.%u",
 		 dev_name(vsp1->dev), index);
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index cc09efbfb24f..149ee1cd0b5a 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -363,7 +363,9 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	subdev = &sru->entity.subdev;
 	v4l2_subdev_init(subdev, &sru_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s sru",
 		 dev_name(vsp1->dev));
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index bba67770cf95..b1881a0a314f 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -338,7 +338,9 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &uds->entity.subdev;
 	v4l2_subdev_init(subdev, &uds_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s uds.%u",
 		 dev_name(vsp1->dev), index);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index c78d4af50fcf..d2735f09d1da 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -244,7 +244,9 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	subdev = &wpf->entity.subdev;
 	v4l2_subdev_init(subdev, &wpf_ops);
 
+	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
 	subdev->entity.ops = &vsp1->media_ops;
+
 	subdev->internal_ops = &vsp1_subdev_internal_ops;
 	snprintf(subdev->name, sizeof(subdev->name), "%s wpf.%u",
 		 dev_name(vsp1->dev), index);
-- 
2.7.3

