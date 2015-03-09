Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444AbbCIQey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:34:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/19] radio-bcm2048: embed video_device
Date: Mon,  9 Mar 2015 17:33:58 +0100
Message-Id: <1425918853-12371-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 33 ++++++++-------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 297ceaa..bd50fb2 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -279,7 +279,7 @@ struct region_info {
 
 struct bcm2048_device {
 	struct i2c_client *client;
-	struct video_device *videodev;
+	struct video_device videodev;
 	struct work_struct work;
 	struct completion compl;
 	struct mutex mutex;
@@ -2583,7 +2583,7 @@ static struct v4l2_ioctl_ops bcm2048_ioctl_ops = {
 static struct video_device bcm2048_viddev_template = {
 	.fops			= &bcm2048_fops,
 	.name			= BCM2048_DRIVER_NAME,
-	.release		= video_device_release,
+	.release		= video_device_release_empty,
 	.ioctl_ops		= &bcm2048_ioctl_ops,
 };
 
@@ -2602,13 +2602,6 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	bdev->videodev = video_device_alloc();
-	if (!bdev->videodev) {
-		dev_dbg(&client->dev, "Failed to alloc video device.\n");
-		err = -ENOMEM;
-		goto free_bdev;
-	}
-
 	bdev->client = client;
 	i2c_set_clientdata(client, bdev);
 	mutex_init(&bdev->mutex);
@@ -2621,16 +2614,16 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 			client->name, bdev);
 		if (err < 0) {
 			dev_err(&client->dev, "Could not request IRQ\n");
-			goto free_vdev;
+			goto free_bdev;
 		}
 		dev_dbg(&client->dev, "IRQ requested.\n");
 	} else {
 		dev_dbg(&client->dev, "IRQ not configured. Using timeouts.\n");
 	}
 
-	*bdev->videodev = bcm2048_viddev_template;
-	video_set_drvdata(bdev->videodev, bdev);
-	if (video_register_device(bdev->videodev, VFL_TYPE_RADIO, radio_nr)) {
+	bdev->videodev = bcm2048_viddev_template;
+	video_set_drvdata(&bdev->videodev, bdev);
+	if (video_register_device(&bdev->videodev, VFL_TYPE_RADIO, radio_nr)) {
 		dev_dbg(&client->dev, "Could not register video device.\n");
 		err = -EIO;
 		goto free_irq;
@@ -2653,18 +2646,13 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 free_sysfs:
 	bcm2048_sysfs_unregister_properties(bdev, ARRAY_SIZE(attrs));
 free_registration:
-	video_unregister_device(bdev->videodev);
-	/* video_unregister_device frees bdev->videodev */
-	bdev->videodev = NULL;
+	video_unregister_device(&bdev->videodev);
 	skip_release = 1;
 free_irq:
 	if (client->irq)
 		free_irq(client->irq, bdev);
-free_vdev:
-	if (!skip_release)
-		video_device_release(bdev->videodev);
-	i2c_set_clientdata(client, NULL);
 free_bdev:
+	i2c_set_clientdata(client, NULL);
 	kfree(bdev);
 exit:
 	return err;
@@ -2673,16 +2661,13 @@ exit:
 static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
 {
 	struct bcm2048_device *bdev = i2c_get_clientdata(client);
-	struct video_device *vd;
 
 	if (!client->adapter)
 		return -ENODEV;
 
 	if (bdev) {
-		vd = bdev->videodev;
-
 		bcm2048_sysfs_unregister_properties(bdev, ARRAY_SIZE(attrs));
-		video_unregister_device(vd);
+		video_unregister_device(&bdev->videodev);
 
 		if (bdev->power_state)
 			bcm2048_set_power_state(bdev, BCM2048_POWER_OFF);
-- 
2.1.4

