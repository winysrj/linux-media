Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:49341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZBCBHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:07:30 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763350fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:07:28 -0800 (PST)
Subject: [patch review 1/8] radio-mr800: codingstyle cleanups
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 03:17:12 +0300
Message-Id: <1233620232.17456.7.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanups of many if-check constructions.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 1dce9d4e2179 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Sun Feb 01 11:40:27 2009 -0200
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 02:22:56 2009 +0300
@@ -378,13 +378,15 @@
 				struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
 		return -EIO;
 
 	radio->curfreq = f->frequency;
-	if (amradio_setfreq(radio, radio->curfreq) < 0)
+	retval = amradio_setfreq(radio, radio->curfreq);
+	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
 	return 0;
@@ -443,6 +445,7 @@
 				struct v4l2_control *ctrl)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
@@ -451,13 +454,15 @@
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
-			if (amradio_stop(radio) < 0) {
+			retval = amradio_stop(radio);
+			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_stop failed\n");
 				return -1;
 			}
 		} else {
-			if (amradio_start(radio) < 0) {
+			retval = amradio_start(radio);
+			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_start failed\n");
 				return -1;
@@ -508,20 +513,24 @@
 static int usb_amradio_open(struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	lock_kernel();
 
 	radio->users = 1;
 	radio->muted = 1;
 
-	if (amradio_start(radio) < 0) {
+	retval = amradio_start(radio);
+	if (retval < 0) {
 		amradio_dev_warn(&radio->videodev->dev,
 			"radio did not start up properly\n");
 		radio->users = 0;
 		unlock_kernel();
 		return -EIO;
 	}
-	if (amradio_setfreq(radio, radio->curfreq) < 0)
+
+	retval = amradio_setfreq(radio, radio->curfreq);
+	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
 
@@ -554,8 +563,10 @@
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
+	int retval;
 
-	if (amradio_stop(radio) < 0)
+	retval = amradio_stop(radio);
+	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_stop failed\n");
 
 	dev_info(&intf->dev, "going into suspend..\n");
@@ -567,8 +578,10 @@
 static int usb_amradio_resume(struct usb_interface *intf)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
+	int retval;
 
-	if (amradio_start(radio) < 0)
+	retval = amradio_start(radio);
+	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_start failed\n");
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
@@ -619,16 +632,16 @@
 	.release	= usb_amradio_device_release,
 };
 
-/* check if the device is present and register with v4l and
-usb if it is */
+/* check if the device is present and register with v4l and usb if it is */
 static int usb_amradio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct amradio_device *radio;
+	int retval;
 
 	radio = kmalloc(sizeof(struct amradio_device), GFP_KERNEL);
 
-	if (!(radio))
+	if (!radio)
 		return -ENOMEM;
 
 	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
@@ -657,7 +670,8 @@
 	mutex_init(&radio->lock);
 
 	video_set_drvdata(radio->videodev, radio);
-	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
+	retval = video_register_device(radio->videodev,	VFL_TYPE_RADIO,	radio_nr);
+	if (retval < 0) {
 		dev_warn(&intf->dev, "could not register video device\n");
 		video_device_release(radio->videodev);
 		kfree(radio->buffer);


-- 
Best regards, Klimov Alexey

