Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43383 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932182AbeATTUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Jan 2018 14:20:36 -0500
Received: by mail-qt0-f194.google.com with SMTP id s3so11756077qtb.10
        for <linux-media@vger.kernel.org>; Sat, 20 Jan 2018 11:20:36 -0800 (PST)
Date: Sat, 20 Jan 2018 14:19:57 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH] media: radio: Critical v4l2 registration bugfix for si470x
 over i2c
Message-ID: <20180120141957.3621a22c@Constantine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added the call to v4l2_device_register() required to add a new radio
device. Without this patch, it is impossible for the driver to load.
This does not affect USB devices.

Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
---

diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-i2c.c
linux/drivers/media/radio/si470x/radio-si470x-i2c.c ---
linux.orig/drivers/media/radio/si470x/radio-si470x-i2c.c
2018-01-15 21:58:10.675620432 -0500 +++
linux/drivers/media/radio/si470x/radio-si470x-i2c.c	2018-01-16
17:08:02.929734342 -0500 @@ -43,7 +43,6 @@ static const struct
i2c_device_id si470x MODULE_DEVICE_TABLE(i2c, si470x_i2c_id); 
-
 /**************************************************************************
  * Module Parameters
  **************************************************************************/
@@ -362,8 +361,29 @@ static int si470x_i2c_probe(struct i2c_c
 	mutex_init(&radio->lock);
 	init_completion(&radio->completion);
 
+	retval = v4l2_device_register(&client->dev, &radio->v4l2_dev);
+	if (retval < 0) {
+		dev_err(&client->dev, "couldn't register
v4l2_device\n");
+		goto err_initial;
+	}
+
+	v4l2_ctrl_handler_init(&radio->hdl, 2);
+	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 15, 1, 15);
+	if (radio->hdl.error) {
+		retval = radio->hdl.error;
+		dev_err(&client->dev, "couldn't register control\n");
+		goto err_dev;
+	}
+
 	/* video device initialization */
 	radio->videodev = si470x_viddev_template;
+	radio->videodev.ctrl_handler =
&radio->hdl;				// no?
+	radio->videodev.lock =
&radio->lock;					// no?
+	radio->videodev.v4l2_dev = &radio->v4l2_dev;
+	radio->videodev.release = video_device_release_empty;
 	video_set_drvdata(&radio->videodev, radio);
 
 	/* power up : need 110ms */
@@ -435,6 +455,8 @@ static int si470x_i2c_probe(struct i2c_c
 	return 0;
 err_all:
 	free_irq(client->irq, radio);
+err_dev:
+	v4l2_device_unregister(&radio->v4l2_dev);
 err_rds:
 	kfree(radio->buffer);
 err_radio:
