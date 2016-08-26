Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54122 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754703AbcHZXos (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 19/21] omap3isp: Allocate the media device dynamically
Date: Sat, 27 Aug 2016 02:43:27 +0300
Message-Id: <1472255009-28719-20-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new media_device_alloc() API to allocate and release the media
device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c      | 24 +++++++++++++-----------
 drivers/media/platform/omap3isp/isp.h      |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c |  2 +-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c..565d392 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1597,8 +1597,8 @@ static void isp_unregister_entities(struct isp_device *isp)
 	omap3isp_stat_unregister_entities(&isp->isp_hist);
 
 	v4l2_device_unregister(&isp->v4l2_dev);
-	media_device_unregister(&isp->media_dev);
-	media_device_cleanup(&isp->media_dev);
+	media_device_unregister(isp->media_dev);
+	media_device_put(isp->media_dev);
 }
 
 static int isp_link_entity(
@@ -1676,14 +1676,16 @@ static int isp_register_entities(struct isp_device *isp)
 {
 	int ret;
 
-	isp->media_dev.dev = isp->dev;
-	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
-		sizeof(isp->media_dev.model));
-	isp->media_dev.hw_revision = isp->revision;
-	isp->media_dev.link_notify = v4l2_pipeline_link_notify;
-	media_device_init(&isp->media_dev);
+	isp->media_dev = media_device_alloc(isp->dev, isp);
+	if (!isp->media_dev)
+		return -ENOMEM;
+
+	strlcpy(isp->media_dev->model, "TI OMAP3 ISP",
+		sizeof(isp->media_dev->model));
+	isp->media_dev->hw_revision = isp->revision;
+	isp->media_dev->link_notify = v4l2_pipeline_link_notify;
 
-	isp->v4l2_dev.mdev = &isp->media_dev;
+	isp->v4l2_dev.mdev = isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
 	if (ret < 0) {
 		dev_err(isp->dev, "%s: V4L2 device registration failed (%d)\n",
@@ -2161,7 +2163,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	struct isp_bus_cfg *bus;
 	int ret;
 
-	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
+	ret = media_entity_enum_init(&isp->crashed, isp->media_dev);
 	if (ret)
 		return ret;
 
@@ -2179,7 +2181,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	if (ret < 0)
 		return ret;
 
-	return media_device_register(&isp->media_dev);
+	return media_device_register(isp->media_dev);
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 7e6f663..7378279 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -176,7 +176,7 @@ struct isp_xclk {
 struct isp_device {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_async_notifier notifier;
-	struct media_device media_dev;
+	struct media_device *media_dev;
 	struct device *dev;
 	u32 revision;
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 7d9f359..45ef38c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1077,7 +1077,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
 
-	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
+	ret = media_entity_enum_init(&pipe->ent_enum, video->isp->media_dev);
 	if (ret)
 		goto err_enum_init;
 
-- 
2.1.4

