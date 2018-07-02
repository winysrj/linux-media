Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55660 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752055AbeGBPgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 11:36:25 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 2/2] vim2m: add media device
Date: Mon,  2 Jul 2018 12:36:06 -0300
Message-Id: <20180702153606.24876-3-ezequiel@collabora.com>
In-Reply-To: <20180702153606.24876-1-ezequiel@collabora.com>
References: <20180702153606.24876-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Request API requires a media node. Add one to the vim2m driver so we can
use requests with it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vim2m.c | 41 ++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4..da13a8927f3f 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -140,6 +140,9 @@ static struct vim2m_fmt *find_format(struct v4l2_format *f)
 struct vim2m_dev {
 	struct v4l2_device	v4l2_dev;
 	struct video_device	vfd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device	mdev;
+#endif
 
 	atomic_t		num_inst;
 	struct mutex		dev_mutex;
@@ -1016,7 +1019,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto unreg_dev;
+		goto unreg_v4l2;
 	}
 
 	video_set_drvdata(vfd, dev);
@@ -1031,15 +1034,39 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
-		goto err_m2m;
+		goto unreg_dev;
+	}
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->mdev.dev = &pdev->dev;
+	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	media_device_init(&dev->mdev);
+	dev->v4l2_dev.mdev = &dev->mdev;
+
+	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,
+			vfd, MEDIA_ENT_F_PROC_VIDEO_SCALER);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
+		goto unreg_m2m;
 	}
 
+	ret = media_device_register(&dev->mdev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
+		goto unreg_m2m_mc;
+	}
+#endif
 	return 0;
 
-err_m2m:
+#ifdef CONFIG_MEDIA_CONTROLLER
+unreg_m2m_mc:
+	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
+unreg_m2m:
 	v4l2_m2m_release(dev->m2m_dev);
-	video_unregister_device(&dev->vfd);
+#endif
 unreg_dev:
+	video_unregister_device(&dev->vfd);
+unreg_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return ret;
@@ -1050,6 +1077,12 @@ static int vim2m_remove(struct platform_device *pdev)
 	struct vim2m_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_unregister(&dev->mdev);
+	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
+	media_device_cleanup(&dev->mdev);
+#endif
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
 	video_unregister_device(&dev->vfd);
-- 
2.18.0.rc2
