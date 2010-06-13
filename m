Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65302 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0FMSJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 14:09:27 -0400
Received: by wwb18 with SMTP id 18so3028519wwb.19
        for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 11:09:25 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jarkko Nikula <jhnikula@gmail.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/2] V4L/DVB: radio-si4713: Release i2c adapter in driver cleanup paths
Date: Sun, 13 Jun 2010 21:09:27 +0300
Message-Id: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call to i2c_put_adapter was missing in radio_si4713_pdriver_probe and
radio_si4713_pdriver_remove.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/radio/radio-si4713.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 13554ab..0a9fc4d 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -296,14 +296,14 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	if (!sd) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
 		rval = -ENODEV;
-		goto unregister_v4l2_dev;
+		goto put_adapter;
 	}
 
 	rsdev->radio_dev = video_device_alloc();
 	if (!rsdev->radio_dev) {
 		dev_err(&pdev->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
-		goto unregister_v4l2_dev;
+		goto put_adapter;
 	}
 
 	memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
@@ -320,6 +320,8 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 
 free_vdev:
 	video_device_release(rsdev->radio_dev);
+put_adapter:
+	i2c_put_adapter(adapter);
 unregister_v4l2_dev:
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 free_rsdev:
@@ -335,8 +337,12 @@ static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
 	struct radio_si4713_device *rsdev = container_of(v4l2_dev,
 						struct radio_si4713_device,
 						v4l2_dev);
+	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
+					    struct v4l2_subdev, list);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	video_unregister_device(rsdev->radio_dev);
+	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 	kfree(rsdev);
 
-- 
1.7.1

