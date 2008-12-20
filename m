Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK39Db6026839
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:13 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK38dLv011331
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:08 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so1312232ewy.3
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:09:08 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:09:23 +0300
Message-Id: <1229742563.10297.114.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 2/5] dsbr100: fix codinstyle, make ifs more clear
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

We should make if-constructions more clear. Introduce int variables in
some functions to make it this way.

---
diff -r a302bfcb23f8 linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Fri Dec 19 14:34:30 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 02:31:26 2008 +0300
@@ -200,15 +200,24 @@
 /* switch on radio */
 static int dsbr100_start(struct dsbr100_device *radio)
 {
+	int first;
+	int second;
+
 	mutex_lock(&radio->lock);
-	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			USB_REQ_GET_STATUS,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x00, 0xC7, radio->transfer_buffer, 8, 300) < 0 ||
-	usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			DSB100_ONOFF,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x01, 0x00, radio->transfer_buffer, 8, 300) < 0) {
+
+	first = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		USB_REQ_GET_STATUS,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		0x00, 0xC7, radio->transfer_buffer, 8, 300);
+
+	second = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		DSB100_ONOFF,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		0x01, 0x00, radio->transfer_buffer, 8, 300);
+
+	if (first < 0 || second < 0) {
 		mutex_unlock(&radio->lock);
 		return -1;
 	}
@@ -222,15 +231,24 @@
 /* switch off radio */
 static int dsbr100_stop(struct dsbr100_device *radio)
 {
+	int first;
+	int second;
+
 	mutex_lock(&radio->lock);
-	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			USB_REQ_GET_STATUS,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x16, 0x1C, radio->transfer_buffer, 8, 300) < 0 ||
-	usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			DSB100_ONOFF,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x00, 0x00, radio->transfer_buffer, 8, 300) < 0) {
+
+	first = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		USB_REQ_GET_STATUS,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		0x16, 0x1C, radio->transfer_buffer, 8, 300);
+
+	second = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		DSB100_ONOFF,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		0x00, 0x00, radio->transfer_buffer, 8, 300);
+
+	if (first < 0 || second < 0) {
 		mutex_unlock(&radio->lock);
 		return -1;
 	}
@@ -243,21 +261,33 @@
 /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
 static int dsbr100_setfreq(struct dsbr100_device *radio, int freq)
 {
+	int first;
+	int second;
+	int third;
+
 	freq = (freq / 16 * 80) / 1000 + 856;
 	mutex_lock(&radio->lock);
-	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			DSB100_TUNE,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			(freq >> 8) & 0x00ff, freq & 0xff,
-			radio->transfer_buffer, 8, 300) < 0 ||
-	   usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			USB_REQ_GET_STATUS,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x96, 0xB7, radio->transfer_buffer, 8, 300) < 0 ||
-	usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
-			USB_REQ_GET_STATUS,
-			USB_TYPE_VENDOR | USB_RECIP_DEVICE |  USB_DIR_IN,
-			0x00, 0x24, radio->transfer_buffer, 8, 300) < 0) {
+
+	first = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		DSB100_TUNE,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		(freq >> 8) & 0x00ff, freq & 0xff,
+		radio->transfer_buffer, 8, 300);
+
+	second = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		USB_REQ_GET_STATUS,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+		0x96, 0xB7, radio->transfer_buffer, 8, 300);
+
+	third = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
+		USB_REQ_GET_STATUS,
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE |  USB_DIR_IN,
+		0x00, 0x24, radio->transfer_buffer, 8, 300);
+
+	if (first < 0 || second < 0 || third < 0) {
 		radio->stereo = -1;
 		mutex_unlock(&radio->lock);
 		return -1;
@@ -272,14 +302,21 @@
 sees a stereo signal or not.  Pity. */
 static void dsbr100_getstat(struct dsbr100_device *radio)
 {
+	int retval;
+
 	mutex_lock(&radio->lock);
-	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
+
+	retval = usb_control_msg(radio->usbdev,
+		usb_rcvctrlpipe(radio->usbdev, 0),
 		USB_REQ_GET_STATUS,
 		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-		0x00 , 0x24, radio->transfer_buffer, 8, 300) < 0)
+		0x00 , 0x24, radio->transfer_buffer, 8, 300);
+
+	if (retval < 0)
 		radio->stereo = -1;
 	else
 		radio->stereo = !(radio->transfer_buffer[0] & 0x01);
+
 	mutex_unlock(&radio->lock);
 }
 
@@ -361,13 +398,15 @@
 				struct v4l2_frequency *f)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
 		return -EIO;
 
 	radio->curfreq = f->frequency;
-	if (dsbr100_setfreq(radio, radio->curfreq) == -1)
+	retval = dsbr100_setfreq(radio, radio->curfreq);
+	if (retval == -1)
 		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
 	return 0;
 }
@@ -421,6 +460,7 @@
 				struct v4l2_control *ctrl)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+	int retval;
 
 	/* safety check */
 	if (radio->removed)
@@ -429,13 +469,15 @@
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
-			if (dsbr100_stop(radio) == -1) {
+			retval = dsbr100_stop(radio);
+			if (retval == -1) {
 				dev_warn(&radio->usbdev->dev,
 					 "Radio did not respond properly\n");
 				return -EBUSY;
 			}
 		} else {
-			if (dsbr100_start(radio) == -1) {
+			retval = dsbr100_start(radio);
+			if (retval == -1) {
 				dev_warn(&radio->usbdev->dev,
 					 "Radio did not respond properly\n");
 				return -EBUSY;
@@ -487,7 +529,8 @@
 	radio->users = 1;
 	radio->muted = 1;
 
-	if (dsbr100_start(radio) < 0) {
+	retval = dsbr100_start(radio);
+	if (retval < 0) {
 		dev_warn(&radio->usbdev->dev,
 			 "Radio did not start up properly\n");
 		radio->users = 0;
@@ -496,7 +539,6 @@
 	}
 
 	retval = dsbr100_setfreq(radio, radio->curfreq);
-
 	if (retval == -1)
 		dev_warn(&radio->usbdev->dev,
 			"set frequency failed\n");
@@ -604,6 +646,7 @@
 				const struct usb_device_id *id)
 {
 	struct dsbr100_device *radio;
+	int retval;
 
 	radio = kmalloc(sizeof(struct dsbr100_device), GFP_KERNEL);
 
@@ -625,7 +668,8 @@
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
 	video_set_drvdata(&radio->videodev, radio);
-	if (video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr) < 0) {
+	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
+	if (retval < 0) {
 		dev_warn(&intf->dev, "Could not register video device\n");
 		kfree(radio->transfer_buffer);
 		kfree(radio);


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
