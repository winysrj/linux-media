Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35121 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaJDTlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 15:41:20 -0400
Received: by mail-qg0-f47.google.com with SMTP id i50so2301382qgf.34
        for <linux-media@vger.kernel.org>; Sat, 04 Oct 2014 12:41:19 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/3] [media] coda: Call v4l2_device_unregister() from a single location
Date: Sat,  4 Oct 2014 16:40:50 -0300
Message-Id: <1412451652-27220-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Instead of calling v4l2_device_unregister() in multiple locations within the
error paths, let's call it from a single location to make the error handling
simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda/coda-common.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ced4760..7cd82e8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1926,8 +1926,8 @@ static int coda_probe(struct platform_device *pdev)
 	} else if (pdev_id) {
 		dev->devtype = &coda_devdata[pdev_id->driver_data];
 	} else {
-		v4l2_device_unregister(&dev->v4l2_dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_v4l2_register;
 	}
 
 	dev->debugfs_root = debugfs_create_dir("coda", NULL);
@@ -1941,8 +1941,7 @@ static int coda_probe(struct platform_device *pdev)
 					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate work buffer\n");
-			v4l2_device_unregister(&dev->v4l2_dev);
-			return ret;
+			goto err_v4l2_register;
 		}
 	}
 
@@ -1952,8 +1951,7 @@ static int coda_probe(struct platform_device *pdev)
 					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate temp buffer\n");
-			v4l2_device_unregister(&dev->v4l2_dev);
-			return ret;
+			goto err_v4l2_register;
 		}
 	}
 
@@ -1988,6 +1986,10 @@ static int coda_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	return coda_firmware_request(dev);
+
+err_v4l2_register:
+	v4l2_device_unregister(&dev->v4l2_dev);
+	return ret;
 }
 
 static int coda_remove(struct platform_device *pdev)
-- 
1.9.1

