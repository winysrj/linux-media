Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2643 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3EaKDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 04/21] radio-tea5764: add support for struct v4l2_device.
Date: Fri, 31 May 2013 12:02:24 +0200
Message-Id: <1369994561-25236-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 38d563d..f6a5471 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -39,6 +39,7 @@
 #include <linux/i2c.h>			/* I2C				*/
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
 
 #define DRIVER_VERSION	"0.0.2"
 
@@ -138,6 +139,7 @@ static int radio_nr = -1;
 static int use_xtal = RADIO_TEA5764_XTAL;
 
 struct tea5764_device {
+	struct v4l2_device v4l2_dev;
 	struct i2c_client		*i2c_client;
 	struct video_device		*videodev;
 	struct tea5764_regs		regs;
@@ -497,6 +499,7 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
 	struct tea5764_device *radio;
+	struct v4l2_device *v4l2_dev;
 	struct tea5764_regs *r;
 	int ret;
 
@@ -505,31 +508,37 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 	if (!radio)
 		return -ENOMEM;
 
+	v4l2_dev = &radio->v4l2_dev;
+	ret = v4l2_device_register(&client->dev, v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "could not register v4l2_device\n");
+		goto errfr;
+	}
 	mutex_init(&radio->mutex);
 	radio->i2c_client = client;
 	ret = tea5764_i2c_read(radio);
 	if (ret)
-		goto errfr;
+		goto errunreg;
 	r = &radio->regs;
 	PDEBUG("chipid = %04X, manid = %04X", r->chipid, r->manid);
 	if (r->chipid != TEA5764_CHIPID ||
 		(r->manid & 0x0fff) != TEA5764_MANID) {
 		PWARN("This chip is not a TEA5764!");
 		ret = -EINVAL;
-		goto errfr;
+		goto errunreg;
 	}
 
 	radio->videodev = video_device_alloc();
 	if (!(radio->videodev)) {
 		ret = -ENOMEM;
-		goto errfr;
+		goto errunreg;
 	}
-	memcpy(radio->videodev, &tea5764_radio_template,
-		sizeof(tea5764_radio_template));
+	*radio->videodev = tea5764_radio_template;
 
 	i2c_set_clientdata(client, radio);
 	video_set_drvdata(radio->videodev, radio);
 	radio->videodev->lock = &radio->mutex;
+	radio->videodev->v4l2_dev = v4l2_dev;
 
 	/* initialize and power off the chip */
 	tea5764_i2c_read(radio);
@@ -547,6 +556,8 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 	return 0;
 errrel:
 	video_device_release(radio->videodev);
+errunreg:
+	v4l2_device_unregister(v4l2_dev);
 errfr:
 	kfree(radio);
 	return ret;
@@ -560,6 +571,7 @@ static int tea5764_i2c_remove(struct i2c_client *client)
 	if (radio) {
 		tea5764_power_down(radio);
 		video_unregister_device(radio->videodev);
+		v4l2_device_unregister(&radio->v4l2_dev);
 		kfree(radio);
 	}
 	return 0;
-- 
1.7.10.4

