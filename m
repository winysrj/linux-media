Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:21564 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752701AbeEUIzV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 30/36] media: vim2m: add media device
Date: Mon, 21 May 2018 11:54:55 +0300
Message-Id: <20180521085501.16861-31-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Request API requires a media node. Add one to the vim2m driver so we can
use requests with it.

This probably needs a bit more work to correctly represent m2m
hardware in the media topology.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4d..9be4da3b85773 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -140,6 +140,10 @@ static struct vim2m_fmt *find_format(struct v4l2_format *f)
 struct vim2m_dev {
 	struct v4l2_device	v4l2_dev;
 	struct video_device	vfd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device	mdev;
+	struct media_pad	pad[2];
+#endif
 
 	atomic_t		num_inst;
 	struct mutex		dev_mutex;
@@ -1000,11 +1004,6 @@ static int vim2m_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&dev->irqlock);
-
-	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
-	if (ret)
-		return ret;
-
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
 
@@ -1013,6 +1012,22 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->mdev.dev = &pdev->dev;
+	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	media_device_init(&dev->mdev);
+	dev->v4l2_dev.mdev = &dev->mdev;
+	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
+	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&vfd->entity, 2, dev->pad);
+	if (ret)
+		return ret;
+#endif
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto unreg_media;
+
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
@@ -1034,6 +1049,13 @@ static int vim2m_probe(struct platform_device *pdev)
 		goto err_m2m;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	/* Register the media device node */
+	ret = media_device_register(&dev->mdev);
+	if (ret)
+		goto err_m2m;
+#endif
+
 	return 0;
 
 err_m2m:
@@ -1041,6 +1063,10 @@ static int vim2m_probe(struct platform_device *pdev)
 	video_unregister_device(&dev->vfd);
 unreg_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
+unreg_media:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_unregister(&dev->mdev);
+#endif
 
 	return ret;
 }
@@ -1050,6 +1076,12 @@ static int vim2m_remove(struct platform_device *pdev)
 	struct vim2m_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_unregister(&dev->mdev);
+	media_device_cleanup(&dev->mdev);
+#endif
+
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
 	video_unregister_device(&dev->vfd);
-- 
2.11.0
