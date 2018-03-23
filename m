Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:7253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbeCWVS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org
Subject: [RFC v2 09/10] vim2m: Register V4L2 video device after V4L2 mem2mem init
Date: Fri, 23 Mar 2018 23:17:43 +0200
Message-Id: <1521839864-10146-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise the V4L2 mem2mem framework before creating the video device.
Referencing ctx->m2m_dev isn't allowed before that as it is NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vim2m.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e..9b6b456 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1008,6 +1008,16 @@ static int vim2m_probe(struct platform_device *pdev)
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
 
+	timer_setup(&dev->timer, device_isr, 0);
+	platform_set_drvdata(pdev, dev);
+
+	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+		goto err_unreg_v4l2_dev;
+	}
+
 	dev->vfd = vim2m_videodev;
 	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
@@ -1016,7 +1026,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto unreg_dev;
+		goto err_unreg_vdev;
 	}
 
 	video_set_drvdata(vfd, dev);
@@ -1024,22 +1034,13 @@ static int vim2m_probe(struct platform_device *pdev)
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
 
-	timer_setup(&dev->timer, device_isr, 0);
-	platform_set_drvdata(pdev, dev);
-
-	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(dev->m2m_dev)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
-		ret = PTR_ERR(dev->m2m_dev);
-		goto err_m2m;
-	}
-
 	return 0;
 
-err_m2m:
-	v4l2_m2m_release(dev->m2m_dev);
+err_unreg_vdev:
 	video_unregister_device(&dev->vfd);
-unreg_dev:
+	v4l2_m2m_release(dev->m2m_dev);
+
+err_unreg_v4l2_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return ret;
-- 
2.7.4
