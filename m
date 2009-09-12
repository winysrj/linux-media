Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZILOuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:50:02 -0400
Received: by mail-qy0-f172.google.com with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:50:06 -0700 (PDT)
Message-ID: <4AABB511.7060705@gmail.com>
Date: Sat, 12 Sep 2009 10:49:53 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 07/10] radio-mr800: remove device removed indicator
Content-Type: multipart/mixed;
 boundary="------------040401090809060102030706"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040401090809060102030706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From a9b0a308892919514efc692f2a0e28b80ea304ac Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:22:57 -0400
Subject: [PATCH 07/10] mr800: remove device removed indicator

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 71d15ba..9fd2342 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -137,7 +137,6 @@ struct amradio_device {
     int curfreq;
     int stereo;
     int users;
-    int removed;
     int muted;
 };
 
@@ -270,7 +269,7 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
     struct amradio_device *radio = usb_get_intfdata(intf);
 
     mutex_lock(&radio->lock);
-    radio->removed = 1;
+    radio->usbdev = NULL;
     mutex_unlock(&radio->lock);
 
     usb_set_intfdata(intf, NULL);
@@ -488,7 +487,7 @@ static int usb_amradio_open(struct file *file)
 
     mutex_lock(&radio->lock);
 
-    if (radio->removed) {
+    if (!radio->usbdev) {
         retval = -EIO;
         goto unlock;
     }
@@ -528,19 +527,17 @@ static int usb_amradio_close(struct file *file)
 
     mutex_lock(&radio->lock);
 
-    if (radio->removed) {
+    if (!radio->usbdev) {
         retval = -EIO;
         goto unlock;
     }
 
     radio->users = 0;
 
-    if (!radio->removed) {
-        retval = amradio_set_mute(radio, AMRADIO_STOP);
-        if (retval < 0)
-            amradio_dev_warn(&radio->videodev.dev,
-                "amradio_stop failed\n");
-    }
+    retval = amradio_set_mute(radio, AMRADIO_STOP);
+    if (retval < 0)
+        amradio_dev_warn(&radio->videodev.dev,
+            "amradio_stop failed\n");
 
 unlock:
     mutex_unlock(&radio->lock);
@@ -555,7 +552,7 @@ static long usb_amradio_ioctl(struct file *file, 
unsigned int cmd,
 
     mutex_lock(&radio->lock);
 
-    if (radio->removed) {
+    if (!radio->usbdev) {
         retval = -EIO;
         goto unlock;
     }
@@ -673,7 +670,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
     radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
     radio->videodev.release = usb_amradio_video_device_release;
 
-    radio->removed = 0;
     radio->users = 0;
     radio->usbdev = interface_to_usbdev(intf);
     radio->curfreq = 95.16 * FREQ_MUL;
-- 
1.6.3.3


--------------040401090809060102030706
Content-Type: text/x-diff;
 name="0007-mr800-remove-device-removed-indicator.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0007-mr800-remove-device-removed-indicator.patch"

>From a9b0a308892919514efc692f2a0e28b80ea304ac Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:22:57 -0400
Subject: [PATCH 07/10] mr800: remove device removed indicator

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 71d15ba..9fd2342 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -137,7 +137,6 @@ struct amradio_device {
 	int curfreq;
 	int stereo;
 	int users;
-	int removed;
 	int muted;
 };
 
@@ -270,7 +269,7 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	mutex_lock(&radio->lock);
-	radio->removed = 1;
+	radio->usbdev = NULL;
 	mutex_unlock(&radio->lock);
 
 	usb_set_intfdata(intf, NULL);
@@ -488,7 +487,7 @@ static int usb_amradio_open(struct file *file)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->removed) {
+	if (!radio->usbdev) {
 		retval = -EIO;
 		goto unlock;
 	}
@@ -528,19 +527,17 @@ static int usb_amradio_close(struct file *file)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->removed) {
+	if (!radio->usbdev) {
 		retval = -EIO;
 		goto unlock;
 	}
 
 	radio->users = 0;
 
-	if (!radio->removed) {
-		retval = amradio_set_mute(radio, AMRADIO_STOP);
-		if (retval < 0)
-			amradio_dev_warn(&radio->videodev.dev,
-				"amradio_stop failed\n");
-	}
+	retval = amradio_set_mute(radio, AMRADIO_STOP);
+	if (retval < 0)
+		amradio_dev_warn(&radio->videodev.dev,
+			"amradio_stop failed\n");
 
 unlock:
 	mutex_unlock(&radio->lock);
@@ -555,7 +552,7 @@ static long usb_amradio_ioctl(struct file *file, unsigned int cmd,
 
 	mutex_lock(&radio->lock);
 
-	if (radio->removed) {
+	if (!radio->usbdev) {
 		retval = -EIO;
 		goto unlock;
 	}
@@ -673,7 +670,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
 	radio->videodev.release = usb_amradio_video_device_release;
 
-	radio->removed = 0;
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
-- 
1.6.3.3


--------------040401090809060102030706--
