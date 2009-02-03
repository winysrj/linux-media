Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZBCBIb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:08:31 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:08:30 -0800 (PST)
Subject: [patch review 4/8] radio-mr800: move radio start and stop in one
 function
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:08:26 +0300
Message-Id: <1233623306.17456.256.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch introduces new amradio_set_mute function. Amradio_start and
amradio_stop removed. This makes driver more flexible and it's useful
for next changes.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 8a8f7995666e linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 03:09:07 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 03:55:35 2009 +0300
@@ -88,6 +88,16 @@
 #define FREQ_MAX 108.0
 #define FREQ_MUL 16000
 
+/*
+ * Commands that device should understand
+ * List isnt full and will be updated with implementation of new functions
+ */
+#define AMRADIO_SET_MUTE	0xab
+
+/* Comfortable defines for amradio_set_mute */
+#define AMRADIO_START		0x00
+#define AMRADIO_STOP		0x01
+
 /* module parameter */
 static int radio_nr = -1;
 module_param(radio_nr, int, 0);
@@ -172,40 +182,8 @@
 	.supports_autosuspend	= 0,
 };
 
-/* switch on radio. Send 8 bytes to device. */
-static int amradio_start(struct amradio_device *radio)
-{
-	int retval;
-	int size;
-
-	mutex_lock(&radio->lock);
-
-	radio->buffer[0] = 0x00;
-	radio->buffer[1] = 0x55;
-	radio->buffer[2] = 0xaa;
-	radio->buffer[3] = 0x00;
-	radio->buffer[4] = 0xab;
-	radio->buffer[5] = 0x00;
-	radio->buffer[6] = 0x00;
-	radio->buffer[7] = 0x00;
-
-	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
-		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
-
-	if (retval) {
-		mutex_unlock(&radio->lock);
-		return retval;
-	}
-
-	radio->muted = 0;
-
-	mutex_unlock(&radio->lock);
-
-	return retval;
-}
-
-/* switch off radio */
-static int amradio_stop(struct amradio_device *radio)
+/* switch on/off the radio. Send 8 bytes to device */
+static int amradio_set_mute(struct amradio_device *radio, char argument)
 {
 	int retval;
 	int size;
@@ -220,8 +198,8 @@
 	radio->buffer[1] = 0x55;
 	radio->buffer[2] = 0xaa;
 	radio->buffer[3] = 0x00;
-	radio->buffer[4] = 0xab;
-	radio->buffer[5] = 0x01;
+	radio->buffer[4] = AMRADIO_SET_MUTE;
+	radio->buffer[5] = argument;
 	radio->buffer[6] = 0x00;
 	radio->buffer[7] = 0x00;
 
@@ -233,7 +211,7 @@
 		return retval;
 	}
 
-	radio->muted = 1;
+	radio->muted = argument;
 
 	mutex_unlock(&radio->lock);
 
@@ -454,14 +432,14 @@
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
-			retval = amradio_stop(radio);
+			retval = amradio_set_mute(radio, AMRADIO_STOP);
 			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_stop failed\n");
 				return -1;
 			}
 		} else {
-			retval = amradio_start(radio);
+			retval = amradio_set_mute(radio, AMRADIO_START);
 			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_start failed\n");
@@ -520,7 +498,7 @@
 	radio->users = 1;
 	radio->muted = 1;
 
-	retval = amradio_start(radio);
+	retval = amradio_set_mute(radio, AMRADIO_START);
 	if (retval < 0) {
 		amradio_dev_warn(&radio->videodev->dev,
 			"radio did not start up properly\n");
@@ -550,7 +528,7 @@
 	radio->users = 0;
 
 	if (!radio->removed) {
-		retval = amradio_stop(radio);
+		retval = amradio_set_mute(radio, AMRADIO_STOP);
 		if (retval < 0)
 			amradio_dev_warn(&radio->videodev->dev,
 				"amradio_stop failed\n");
@@ -565,7 +543,7 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 	int retval;
 
-	retval = amradio_stop(radio);
+	retval = amradio_set_mute(radio, AMRADIO_STOP);
 	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_stop failed\n");
 
@@ -580,7 +558,7 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 	int retval;
 
-	retval = amradio_start(radio);
+	retval = amradio_set_mute(radio, AMRADIO_START);
 	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_start failed\n");
 


-- 
Best regards, Klimov Alexey

