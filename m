Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8GEWAg021236
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:32 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8GE23Q030942
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:19 -0500
Received: by ey-out-2122.google.com with SMTP id 4so444057eyf.39
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 08:14:18 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:14:15 +0300
Message-Id: <1228752855.1809.93.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH 1/2] radio-mr800: correct unplug, fix to previous patch
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

This patch corrects unplug procedure, that was implemented wrong in
previous patch. New function usb_amradio_device_release added.
Disconnect lock removed.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r 602d3ac1f476 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Thu Nov 20 19:47:37 2008 -0200
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Dec 08 17:42:06 2008 +0300
@@ -142,7 +142,6 @@
 
 	unsigned char *buffer;
 	struct mutex lock;	/* buffer locking */
-	struct mutex disconnect_lock;
 	int curfreq;
 	int stereo;
 	int users;
@@ -305,16 +304,12 @@
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
-	mutex_lock(&radio->disconnect_lock);
+	mutex_lock(&radio->lock);
 	radio->removed = 1;
+	mutex_unlock(&radio->lock);
+
 	usb_set_intfdata(intf, NULL);
-
-	if (radio->users == 0) {
-		video_unregister_device(radio->videodev);
-		kfree(radio->buffer);
-		kfree(radio);
-	}
-	mutex_unlock(&radio->disconnect_lock);
+	video_unregister_device(radio->videodev);
 }
 
 /* vidioc_querycap - query device capabilities */
@@ -532,7 +527,7 @@
 	return 0;
 }
 
-/*close device - free driver structures */
+/*close device */
 static int usb_amradio_close(struct inode *inode, struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
@@ -541,21 +536,15 @@
 	if (!radio)
 		return -ENODEV;
 
-	mutex_lock(&radio->disconnect_lock);
 	radio->users = 0;
-	if (radio->removed) {
-		video_unregister_device(radio->videodev);
-		kfree(radio->buffer);
-		kfree(radio);
 
-	} else {
+	if (!radio->removed) {
 		retval = amradio_stop(radio);
 		if (retval < 0)
 			amradio_dev_warn(&radio->videodev->dev,
 				"amradio_stop failed\n");
 	}
 
-	mutex_unlock(&radio->disconnect_lock);
 	return 0;
 }
 
@@ -612,12 +601,24 @@
 	.vidioc_s_input     = vidioc_s_input,
 };
 
+static void usb_amradio_device_release(struct video_device *videodev)
+{
+	struct amradio_device *radio = video_get_drvdata(videodev);
+
+	/* we call v4l to free radio->videodev */
+	video_device_release(videodev);
+
+	/* free rest memory */
+	kfree(radio->buffer);
+	kfree(radio);
+}
+
 /* V4L2 interface */
 static struct video_device amradio_videodev_template = {
 	.name		= "AverMedia MR 800 USB FM Radio",
 	.fops		= &usb_amradio_fops,
 	.ioctl_ops 	= &usb_amradio_ioctl_ops,
-	.release	= video_device_release,
+	.release	= usb_amradio_device_release,
 };
 
 /* check if the device is present and register with v4l and
@@ -655,7 +656,6 @@
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
 
-	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
 
 	video_set_drvdata(radio->videodev, radio);


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
