Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41148 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2IXGVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:21:35 -0400
Received: by padhz1 with SMTP id hz1so712496pad.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 23:21:35 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sachin.kamat@linaro.org,
	m.szyprowski@samsung.com, pawel@osciak.com, patches@linaro.org
Subject: [PATCH 4/4] [media] mem2mem_testdev: Use devm_kzalloc() in probe
Date: Mon, 24 Sep 2012 11:47:48 +0530
Message-Id: <1348467468-19854-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_kzalloc() makes error handling and cleanup simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/mem2mem_testdev.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index f7d15ec..cd1c844 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -1019,7 +1019,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	int ret;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -1027,7 +1027,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		goto free_dev;
+		return ret;
 
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
@@ -1073,8 +1073,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
-free_dev:
-	kfree(dev);
 
 	return ret;
 }
@@ -1089,7 +1087,6 @@ static int m2mtest_remove(struct platform_device *pdev)
 	del_timer_sync(&dev->timer);
 	video_unregister_device(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	kfree(dev);
 
 	return 0;
 }
-- 
1.7.4.1

