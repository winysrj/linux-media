Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZBCBJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:09:01 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:09:00 -0800 (PST)
Subject: [patch review 6/8] radio-mr800: add stereo support
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:08:55 +0300
Message-Id: <1233623335.17456.262.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch introduces new amradio_set_stereo function.
Driver calls this func to make stereo radio reception.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 34b045702595 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Tue Feb 03 03:02:39 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Tue Feb 03 03:04:54 2009 +0300
@@ -94,10 +94,15 @@
  */
 #define AMRADIO_SET_FREQ	0xa4
 #define AMRADIO_SET_MUTE	0xab
+#define AMRADIO_SET_MONO	0xae
 
 /* Comfortable defines for amradio_set_mute */
 #define AMRADIO_START		0x00
 #define AMRADIO_STOP		0x01
+
+/* Comfortable defines for amradio_set_stereo */
+#define WANT_STEREO		0x00
+#define WANT_MONO		0x01
 
 /* module parameter */
 static int radio_nr = -1;
@@ -266,12 +271,48 @@
 		return retval;
 	}
 
-	radio->stereo = 0;
+	mutex_unlock(&radio->lock);
+
+	return retval;
+}
+
+static int amradio_set_stereo(struct amradio_device *radio, char argument)
+{
+	int retval;
+	int size;
+
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
+
+	mutex_lock(&radio->lock);
+
+	radio->buffer[0] = 0x00;
+	radio->buffer[1] = 0x55;
+	radio->buffer[2] = 0xaa;
+	radio->buffer[3] = 0x00;
+	radio->buffer[4] = AMRADIO_SET_MONO;
+	radio->buffer[5] = argument;
+	radio->buffer[6] = 0x00;
+	radio->buffer[7] = 0x00;
+
+	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
+		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
+
+	if (retval) {
+		radio->stereo = -1;
+		mutex_unlock(&radio->lock);
+		return retval;
+	}
+
+	radio->stereo = 1;
 
 	mutex_unlock(&radio->lock);
 
 	return retval;
 }
+
+
 
 /* USB subsystem interface begins here */
 
@@ -310,6 +351,7 @@
 				struct v4l2_tuner *v)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
@@ -321,7 +363,16 @@
 /* TODO: Add function which look is signal stereo or not
  * 	amradio_getstat(radio);
  */
-	radio->stereo = -1;
+
+/* we call amradio_set_stereo to set radio->stereo
+ * Honestly, amradio_getstat should cover this in future and
+ * amradio_set_stereo shouldn't be here
+ */
+	retval = amradio_set_stereo(radio, WANT_STEREO);
+	if (retval < 0)
+		amradio_dev_warn(&radio->videodev->dev,
+			"set stereo failed\n");
+
 	strcpy(v->name, "FM");
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_MIN * FREQ_MUL;
@@ -342,6 +393,7 @@
 				struct v4l2_tuner *v)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
@@ -349,6 +401,25 @@
 
 	if (v->index > 0)
 		return -EINVAL;
+
+	/* mono/stereo selector */
+	switch (v->audmode) {
+	case V4L2_TUNER_MODE_MONO:
+		retval = amradio_set_stereo(radio, WANT_MONO);
+		if (retval < 0)
+			amradio_dev_warn(&radio->videodev->dev,
+				"set mono failed\n");
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		retval = amradio_set_stereo(radio, WANT_STEREO);
+		if (retval < 0)
+			amradio_dev_warn(&radio->videodev->dev,
+				"set stereo failed\n");
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -508,6 +579,11 @@
 		return -EIO;
 	}
 
+	retval = amradio_set_stereo(radio, WANT_STEREO);
+	if (retval < 0)
+		amradio_dev_warn(&radio->videodev->dev,
+			"set stereo failed\n");
+
 	retval = amradio_setfreq(radio, radio->curfreq);
 	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
@@ -649,6 +725,7 @@
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
+	radio->stereo = -1;
 
 	mutex_init(&radio->lock);
 


-- 
Best regards, Klimov Alexey

