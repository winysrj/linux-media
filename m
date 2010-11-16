Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3764 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0KPV4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:07 -0500
Message-Id: <81ed71feea3c7d705d3a687aad156782a5f18e2e.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:55:49 +0100
Subject: [RFCv2 PATCH 04/15] tea5764: convert to unlocked_ioctl
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert from ioctl to unlocked_ioctl using the v4l2 core lock.

Also removed the 'exclusive access' limitation. There was no need for it
and it violates the v4l2 spec as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-tea5764.c |   49 ++++++----------------------------
 1 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 789d2ec..0e71d81 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -142,7 +142,6 @@ struct tea5764_device {
 	struct video_device		*videodev;
 	struct tea5764_regs		regs;
 	struct mutex			mutex;
-	int				users;
 };
 
 /* I2C code related */
@@ -458,41 +457,10 @@ static int vidioc_s_audio(struct file *file, void *priv,
 	return 0;
 }
 
-static int tea5764_open(struct file *file)
-{
-	/* Currently we support only one device */
-	struct tea5764_device *radio = video_drvdata(file);
-
-	mutex_lock(&radio->mutex);
-	/* Only exclusive access */
-	if (radio->users) {
-		mutex_unlock(&radio->mutex);
-		return -EBUSY;
-	}
-	radio->users++;
-	mutex_unlock(&radio->mutex);
-	file->private_data = radio;
-	return 0;
-}
-
-static int tea5764_close(struct file *file)
-{
-	struct tea5764_device *radio = video_drvdata(file);
-
-	if (!radio)
-		return -ENODEV;
-	mutex_lock(&radio->mutex);
-	radio->users--;
-	mutex_unlock(&radio->mutex);
-	return 0;
-}
-
 /* File system interface */
 static const struct v4l2_file_operations tea5764_fops = {
 	.owner		= THIS_MODULE,
-	.open           = tea5764_open,
-	.release        = tea5764_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
@@ -527,7 +495,7 @@ static int __devinit tea5764_i2c_probe(struct i2c_client *client,
 	int ret;
 
 	PDEBUG("probe");
-	radio = kmalloc(sizeof(struct tea5764_device), GFP_KERNEL);
+	radio = kzalloc(sizeof(struct tea5764_device), GFP_KERNEL);
 	if (!radio)
 		return -ENOMEM;
 
@@ -555,12 +523,7 @@ static int __devinit tea5764_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, radio);
 	video_set_drvdata(radio->videodev, radio);
-
-	ret = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
-	if (ret < 0) {
-		PWARN("Could not register video device!");
-		goto errrel;
-	}
+	radio->videodev->lock = &radio->mutex;
 
 	/* initialize and power off the chip */
 	tea5764_i2c_read(radio);
@@ -568,6 +531,12 @@ static int __devinit tea5764_i2c_probe(struct i2c_client *client,
 	tea5764_mute(radio, 1);
 	tea5764_power_down(radio);
 
+	ret = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
+	if (ret < 0) {
+		PWARN("Could not register video device!");
+		goto errrel;
+	}
+
 	PINFO("registered.");
 	return 0;
 errrel:
-- 
1.7.0.4

