Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9KwkIn013205
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 15:58:46 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9KtpJ7024319
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 15:55:51 -0500
Received: by ewy14 with SMTP id 14so207465ewy.3
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 12:55:50 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0812090602m6c0f67feje2493fae7bed6850@mail.gmail.com>
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
	<1227410369.16932.31.camel@tux.localhost>
	<30353c3d0811240635t3649fa2bk5f5982c4d3d6e87c@mail.gmail.com>
	<1227787210.11477.7.camel@tux.localhost>
	<30353c3d0811292119y226c5af3tb63dbf130da59c69@mail.gmail.com>
	<208cbae30812051604t6d74a0cbr4177262324563688@mail.gmail.com>
	<20081206080555.6764076d@pedra.chehab.org>
	<1228786534.4367.17.camel@tux.localhost>
	<30353c3d0812090602m6c0f67feje2493fae7bed6850@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 23:55:43 +0300
Message-Id: <1228856144.20449.17.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] dsbr100: fix unplug oops
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

This patch corrects unplug procedure. Patch adds
usb_dsbr100_video_device_release, new macros - videodev_to_radio, mutex
lock and a lot of safety checks.
Struct video_device videodev is embedded in dsbr100_device structure.
Video_device_alloc and memcpy calls removed.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r 6bab82c6096e linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Wed Dec 03 15:32:11 2008 -0200
+++ b/linux/drivers/media/radio/dsbr100.c	Tue Dec 09 23:37:18 2008 +0300
@@ -146,6 +146,7 @@
 #define FREQ_MAX 108.0
 #define FREQ_MUL 16000
 
+#define videodev_to_radio(d) container_of(d, struct dsbr100_device, videodev)
 
 static int usb_dsbr100_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
@@ -162,8 +163,9 @@
 /* Data for one (physical) device */
 struct dsbr100_device {
 	struct usb_device *usbdev;
-	struct video_device *videodev;
+	struct video_device videodev;
 	u8 *transfer_buffer;
+	struct mutex lock;	/* buffer locking */
 	int curfreq;
 	int stereo;
 	int users;
@@ -198,6 +200,7 @@
 /* switch on radio */
 static int dsbr100_start(struct dsbr100_device *radio)
 {
+	mutex_lock(&radio->lock);
 	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 			USB_REQ_GET_STATUS,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
@@ -205,9 +208,13 @@
 	usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 			DSB100_ONOFF,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x01, 0x00, radio->transfer_buffer, 8, 300) < 0)
+			0x01, 0x00, radio->transfer_buffer, 8, 300) < 0) {
+		mutex_unlock(&radio->lock);
 		return -1;
+	}
+
 	radio->muted=0;
+	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 }
 
@@ -215,6 +222,7 @@
 /* switch off radio */
 static int dsbr100_stop(struct dsbr100_device *radio)
 {
+	mutex_lock(&radio->lock);
 	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 			USB_REQ_GET_STATUS,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
@@ -222,9 +230,13 @@
 	usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 			DSB100_ONOFF,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			0x00, 0x00, radio->transfer_buffer, 8, 300) < 0)
+			0x00, 0x00, radio->transfer_buffer, 8, 300) < 0) {
+		mutex_unlock(&radio->lock);
 		return -1;
+	}
+
 	radio->muted=1;
+	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 }
 
@@ -232,6 +244,7 @@
 static int dsbr100_setfreq(struct dsbr100_device *radio, int freq)
 {
 	freq = (freq / 16 * 80) / 1000 + 856;
+	mutex_lock(&radio->lock);
 	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 			DSB100_TUNE,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
@@ -246,9 +259,12 @@
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE |  USB_DIR_IN,
 			0x00, 0x24, radio->transfer_buffer, 8, 300) < 0) {
 		radio->stereo = -1;
+		mutex_unlock(&radio->lock);
 		return -1;
 	}
+
 	radio->stereo = !((radio->transfer_buffer)[0] & 0x01);
+	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 }
 
@@ -256,6 +272,7 @@
 sees a stereo signal or not.  Pity. */
 static void dsbr100_getstat(struct dsbr100_device *radio)
 {
+	mutex_lock(&radio->lock);
 	if (usb_control_msg(radio->usbdev, usb_rcvctrlpipe(radio->usbdev, 0),
 		USB_REQ_GET_STATUS,
 		USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
@@ -263,6 +280,7 @@
 		radio->stereo = -1;
 	else
 		radio->stereo = !(radio->transfer_buffer[0] & 0x01);
+	mutex_unlock(&radio->lock);
 }
 
 
@@ -277,16 +295,12 @@
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 
 	usb_set_intfdata (intf, NULL);
-	if (radio) {
-		video_unregister_device(radio->videodev);
-		radio->videodev = NULL;
-		if (radio->users) {
-			kfree(radio->transfer_buffer);
-			kfree(radio);
-		} else {
-			radio->removed = 1;
-		}
-	}
+
+	mutex_lock(&radio->lock);
+	radio->removed = 1;
+	mutex_unlock(&radio->lock);
+
+	video_unregister_device(&radio->videodev);
 }
 
 
@@ -305,6 +319,10 @@
 				struct v4l2_tuner *v)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
 
 	if (v->index > 0)
 		return -EINVAL;
@@ -327,6 +345,12 @@
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
+	struct dsbr100_device *radio = video_drvdata(file);
+
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
+
 	if (v->index > 0)
 		return -EINVAL;
 
@@ -338,6 +362,10 @@
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
+
 	radio->curfreq = f->frequency;
 	if (dsbr100_setfreq(radio, radio->curfreq) == -1)
 		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
@@ -348,6 +376,10 @@
 				struct v4l2_frequency *f)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
 
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = radio->curfreq;
@@ -373,6 +405,10 @@
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		ctrl->value = radio->muted;
@@ -385,6 +421,10 @@
 				struct v4l2_control *ctrl)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+
+	/* safety check */
+	if (radio->removed)
+		return -EIO;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -467,13 +507,19 @@
 static int usb_dsbr100_close(struct inode *inode, struct file *file)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
+	int retval;
 
 	if (!radio)
 		return -ENODEV;
+
 	radio->users = 0;
-	if (radio->removed) {
-		kfree(radio->transfer_buffer);
-		kfree(radio);
+	if (!radio->removed) {
+		retval = dsbr100_stop(radio);
+		if (retval == -1) {
+			dev_warn(&radio->usbdev->dev,
+				"dsbr100_stop failed\n");
+		}
+
 	}
 	return 0;
 }
@@ -508,6 +554,14 @@
 	return 0;
 }
 
+static void usb_dsbr100_video_device_release(struct video_device *videodev)
+{
+	struct dsbr100_device *radio = videodev_to_radio(videodev);
+
+	kfree(radio->transfer_buffer);
+	kfree(radio);
+}
+
 /* File system interface */
 static const struct file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
@@ -536,11 +590,11 @@
 };
 
 /* V4L2 interface */
-static struct video_device dsbr100_videodev_template = {
+static struct video_device dsbr100_videodev_data = {
 	.name		= "D-Link DSB-R 100",
 	.fops		= &usb_dsbr100_fops,
 	.ioctl_ops 	= &usb_dsbr100_ioctl_ops,
-	.release	= video_device_release,
+	.release	= usb_dsbr100_video_device_release,
 };
 
 /* check if the device is present and register with v4l and
@@ -561,23 +615,17 @@
 		kfree(radio);
 		return -ENOMEM;
 	}
-	radio->videodev = video_device_alloc();
 
-	if (!(radio->videodev)) {
-		kfree(radio->transfer_buffer);
-		kfree(radio);
-		return -ENOMEM;
-	}
-	memcpy(radio->videodev, &dsbr100_videodev_template,
-		sizeof(dsbr100_videodev_template));
+	mutex_init(&radio->lock);
+	radio->videodev = dsbr100_videodev_data;
+
 	radio->removed = 0;
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
-	video_set_drvdata(radio->videodev, radio);
-	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr) < 0) {
+	video_set_drvdata(&radio->videodev, radio);
+	if (video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		dev_warn(&intf->dev, "Could not register video device\n");
-		video_device_release(radio->videodev);
 		kfree(radio->transfer_buffer);
 		kfree(radio);
 		return -EIO;


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
