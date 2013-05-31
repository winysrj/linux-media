Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3782 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EaKDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 05/21] radio-tea5764: embed struct video_device.
Date: Fri, 31 May 2013 12:02:25 +0200
Message-Id: <1369994561-25236-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This simplifies the code as it removes a memory allocation check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index f6a5471..4e0bf64 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -141,7 +141,7 @@ static int use_xtal = RADIO_TEA5764_XTAL;
 struct tea5764_device {
 	struct v4l2_device v4l2_dev;
 	struct i2c_client		*i2c_client;
-	struct video_device		*videodev;
+	struct video_device		vdev;
 	struct tea5764_regs		regs;
 	struct mutex			mutex;
 };
@@ -303,7 +303,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *v)
 {
 	struct tea5764_device *radio = video_drvdata(file);
-	struct video_device *dev = radio->videodev;
+	struct video_device *dev = &radio->vdev;
 
 	strlcpy(v->driver, dev->dev.driver->name, sizeof(v->driver));
 	strlcpy(v->card, dev->name, sizeof(v->card));
@@ -491,7 +491,7 @@ static struct video_device tea5764_radio_template = {
 	.name		= "TEA5764 FM-Radio",
 	.fops           = &tea5764_fops,
 	.ioctl_ops 	= &tea5764_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 /* I2C probe: check if the device exists and register with v4l if it is */
@@ -528,17 +528,12 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 		goto errunreg;
 	}
 
-	radio->videodev = video_device_alloc();
-	if (!(radio->videodev)) {
-		ret = -ENOMEM;
-		goto errunreg;
-	}
-	*radio->videodev = tea5764_radio_template;
+	radio->vdev = tea5764_radio_template;
 
 	i2c_set_clientdata(client, radio);
-	video_set_drvdata(radio->videodev, radio);
-	radio->videodev->lock = &radio->mutex;
-	radio->videodev->v4l2_dev = v4l2_dev;
+	video_set_drvdata(&radio->vdev, radio);
+	radio->vdev.lock = &radio->mutex;
+	radio->vdev.v4l2_dev = v4l2_dev;
 
 	/* initialize and power off the chip */
 	tea5764_i2c_read(radio);
@@ -546,16 +541,14 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 	tea5764_mute(radio, 1);
 	tea5764_power_down(radio);
 
-	ret = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
+	ret = video_register_device(&radio->vdev, VFL_TYPE_RADIO, radio_nr);
 	if (ret < 0) {
 		PWARN("Could not register video device!");
-		goto errrel;
+		goto errunreg;
 	}
 
 	PINFO("registered.");
 	return 0;
-errrel:
-	video_device_release(radio->videodev);
 errunreg:
 	v4l2_device_unregister(v4l2_dev);
 errfr:
@@ -570,7 +563,7 @@ static int tea5764_i2c_remove(struct i2c_client *client)
 	PDEBUG("remove");
 	if (radio) {
 		tea5764_power_down(radio);
-		video_unregister_device(radio->videodev);
+		video_unregister_device(&radio->vdev);
 		v4l2_device_unregister(&radio->v4l2_dev);
 		kfree(radio);
 	}
-- 
1.7.10.4

