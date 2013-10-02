Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51777 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753650Ab3JBXLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 19:11:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com,
	a.hajda@samsung.com
Subject: [PATCH v2 3/4] omap3isp: Mark which pads must connect
Date: Thu,  3 Oct 2013 02:17:52 +0300
Message-Id: <1380755873-25835-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
References: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark pads that must be connected.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c    |    3 ++-
 drivers/media/platform/omap3isp/ispccp2.c    |    3 ++-
 drivers/media/platform/omap3isp/ispcsi2.c    |    3 ++-
 drivers/media/platform/omap3isp/isppreview.c |    3 ++-
 drivers/media/platform/omap3isp/ispresizer.c |    3 ++-
 drivers/media/platform/omap3isp/ispstat.c    |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c   |    6 ++++--
 7 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 907a205..561c991 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2484,7 +2484,8 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 	v4l2_set_subdevdata(sd, ccdc);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	pads[CCDC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CCDC_PAD_SINK].flags = MEDIA_PAD_FL_SINK
+				    | MEDIA_PAD_FL_MUST_CONNECT;
 	pads[CCDC_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
 	pads[CCDC_PAD_SOURCE_OF].flags = MEDIA_PAD_FL_SOURCE;
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e716514..e84fe05 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1076,7 +1076,8 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 	v4l2_set_subdevdata(sd, ccp2);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	pads[CCP2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CCP2_PAD_SINK].flags = MEDIA_PAD_FL_SINK
+				    | MEDIA_PAD_FL_MUST_CONNECT;
 	pads[CCP2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &ccp2_media_ops;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 6db245d..6205608 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1245,7 +1245,8 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	pads[CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	pads[CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK
+				    | MEDIA_PAD_FL_MUST_CONNECT;
 
 	me->ops = &csi2_media_ops;
 	ret = media_entity_init(me, CSI2_PADS_NUM, pads, 0);
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index cd8831a..1c776c1 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2283,7 +2283,8 @@ static int preview_init_entities(struct isp_prev_device *prev)
 	v4l2_ctrl_handler_setup(&prev->ctrls);
 	sd->ctrl_handler = &prev->ctrls;
 
-	pads[PREV_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[PREV_PAD_SINK].flags = MEDIA_PAD_FL_SINK
+				    | MEDIA_PAD_FL_MUST_CONNECT;
 	pads[PREV_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &preview_media_ops;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index d11fb26..fa35f2c 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1701,7 +1701,8 @@ static int resizer_init_entities(struct isp_res_device *res)
 	v4l2_set_subdevdata(sd, res);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	pads[RESZ_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[RESZ_PAD_SINK].flags = MEDIA_PAD_FL_SINK
+				    | MEDIA_PAD_FL_MUST_CONNECT;
 	pads[RESZ_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &resizer_media_ops;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 61e17f9..a75407c 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1067,7 +1067,7 @@ static int isp_stat_init_entities(struct ispstat *stat, const char *name,
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_set_subdevdata(subdev, stat);
 
-	stat->pad.flags = MEDIA_PAD_FL_SINK;
+	stat->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
 	me->ops = NULL;
 
 	return media_entity_init(me, 1, &stat->pad, 0);
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a908d00..d45af5c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1335,11 +1335,13 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	switch (video->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		direction = "output";
-		video->pad.flags = MEDIA_PAD_FL_SINK;
+		video->pad.flags = MEDIA_PAD_FL_SINK
+				   | MEDIA_PAD_FL_MUST_CONNECT;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		direction = "input";
-		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		video->pad.flags = MEDIA_PAD_FL_SOURCE
+				   | MEDIA_PAD_FL_MUST_CONNECT;
 		video->video.vfl_dir = VFL_DIR_TX;
 		break;
 
-- 
1.7.10.4

