Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52317 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0IUItf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 04:49:35 -0400
Received: by ewy23 with SMTP id 23so1843056ewy.19
        for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 01:49:34 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCHv2 1/2] V4L/DVB: radio-si4713: Release i2c adapter in driver cleanup paths
Date: Tue, 21 Sep 2010 11:49:42 +0300
Message-Id: <1285058983-28657-2-git-send-email-jhnikula@gmail.com>
In-Reply-To: <1285058983-28657-1-git-send-email-jhnikula@gmail.com>
References: <1285058983-28657-1-git-send-email-jhnikula@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Call to i2c_put_adapter was missing in radio_si4713_pdriver_probe and
radio_si4713_pdriver_remove.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Acked-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
No changes, Eduardo's ack added.
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

