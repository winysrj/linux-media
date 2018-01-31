Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44535 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753639AbeAaK0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:26:49 -0500
Received: by mail-pf0-f196.google.com with SMTP id 17so10704820pfw.11
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:26:49 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv2 16/17] media: vim2m: add media device
Date: Wed, 31 Jan 2018 19:26:24 +0900
Message-Id: <20180131102625.208021-7-acourbot@chromium.org>
In-Reply-To: <20180131102625.208021-1-acourbot@chromium.org>
References: <20180131102625.208021-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Request API requires a media node. Add one to the vim2m driver so we can
use requests with it.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index b01fba020d5f..a32e8a7950eb 100644
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
@@ -1001,6 +1004,13 @@ static int vim2m_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dev->irqlock);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->mdev.dev = &pdev->dev;
+	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	media_device_init(&dev->mdev);
+	dev->v4l2_dev.mdev = &dev->mdev;
+#endif
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
@@ -1034,6 +1044,13 @@ static int vim2m_probe(struct platform_device *pdev)
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
@@ -1050,6 +1067,13 @@ static int vim2m_remove(struct platform_device *pdev)
 	struct vim2m_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (media_devnode_is_registered(dev->mdev.devnode))
+		media_device_unregister(&dev->mdev);
+	media_device_cleanup(&dev->mdev);
+#endif
+
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
 	video_unregister_device(&dev->vfd);
-- 
2.16.0.rc1.238.g530d649a79-goog
