Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbZILOuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:50:06 -0400
Received: by mail-qy0-f172.google.com with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:50:09 -0700 (PDT)
Message-ID: <4AABB518.8090804@gmail.com>
Date: Sat, 12 Sep 2009 10:50:00 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 08/10] radio-mr800: turn radio on during first open and
 off during last close
Content-Type: multipart/mixed;
 boundary="------------080002050202010108050203"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080002050202010108050203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 46c7d395e4ed2df431b21b6c07fb02a075a15e43 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:57:36 -0400
Subject: [PATCH 08/10] mr800: turn radio on during first open and off 
during last close

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 9fd2342..11db6ea 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -493,15 +493,14 @@ static int usb_amradio_open(struct file *file)
     }
 
     file->private_data = radio;
-    radio->users = 1;
-    radio->muted = 1;
 
-    retval = amradio_set_mute(radio, AMRADIO_START);
-    if (retval < 0) {
-        amradio_dev_warn(&radio->videodev.dev,
-            "radio did not start up properly\n");
-        radio->users = 0;
-        goto unlock;
+    if (radio->users == 0) {
+        retval = amradio_set_mute(radio, AMRADIO_START);
+        if (retval < 0) {
+            amradio_dev_warn(&radio->videodev.dev,
+                "radio did not start up properly\n");
+            goto unlock;
+        }
     }
 
     retval = amradio_set_stereo(radio, WANT_STEREO);
@@ -514,6 +513,8 @@ static int usb_amradio_open(struct file *file)
         amradio_dev_warn(&radio->videodev.dev,
             "set frequency failed\n");
 
+    radio->users++;
+
 unlock:
     mutex_unlock(&radio->lock);
     return retval;
@@ -526,18 +527,19 @@ static int usb_amradio_close(struct file *file)
     int retval = 0;
 
     mutex_lock(&radio->lock);
+    radio->users--;
 
     if (!radio->usbdev) {
         retval = -EIO;
         goto unlock;
     }
 
-    radio->users = 0;
-
-    retval = amradio_set_mute(radio, AMRADIO_STOP);
-    if (retval < 0)
-        amradio_dev_warn(&radio->videodev.dev,
-            "amradio_stop failed\n");
+    if (radio->users == 0 && !radio->muted) {
+        retval = amradio_set_mute(radio, AMRADIO_STOP);
+        if (retval < 0)
+            amradio_dev_warn(&radio->videodev.dev,
+                "amradio_stop failed\n");
+    }
 
 unlock:
     mutex_unlock(&radio->lock);
@@ -674,6 +676,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
     radio->usbdev = interface_to_usbdev(intf);
     radio->curfreq = 95.16 * FREQ_MUL;
     radio->stereo = -1;
+    radio->muted = 1;
 
     mutex_init(&radio->lock);
 
-- 
1.6.3.3


--------------080002050202010108050203
Content-Type: text/x-diff;
 name="0008-mr800-turn-radio-on-during-first-open-and-off-during.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0008-mr800-turn-radio-on-during-first-open-and-off-during.pa";
 filename*1="tch"

>From 46c7d395e4ed2df431b21b6c07fb02a075a15e43 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:57:36 -0400
Subject: [PATCH 08/10] mr800: turn radio on during first open and off during last close

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 9fd2342..11db6ea 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -493,15 +493,14 @@ static int usb_amradio_open(struct file *file)
 	}
 
 	file->private_data = radio;
-	radio->users = 1;
-	radio->muted = 1;
 
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev.dev,
-			"radio did not start up properly\n");
-		radio->users = 0;
-		goto unlock;
+	if (radio->users == 0) {
+		retval = amradio_set_mute(radio, AMRADIO_START);
+		if (retval < 0) {
+			amradio_dev_warn(&radio->videodev.dev,
+				"radio did not start up properly\n");
+			goto unlock;
+		}
 	}
 
 	retval = amradio_set_stereo(radio, WANT_STEREO);
@@ -514,6 +513,8 @@ static int usb_amradio_open(struct file *file)
 		amradio_dev_warn(&radio->videodev.dev,
 			"set frequency failed\n");
 
+	radio->users++;
+
 unlock:
 	mutex_unlock(&radio->lock);
 	return retval;
@@ -526,18 +527,19 @@ static int usb_amradio_close(struct file *file)
 	int retval = 0;
 
 	mutex_lock(&radio->lock);
+	radio->users--;
 
 	if (!radio->usbdev) {
 		retval = -EIO;
 		goto unlock;
 	}
 
-	radio->users = 0;
-
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"amradio_stop failed\n");
+	if (radio->users == 0 && !radio->muted) {
+		retval = amradio_set_mute(radio, AMRADIO_STOP);
+		if (retval < 0)
+			amradio_dev_warn(&radio->videodev.dev,
+				"amradio_stop failed\n");
+	}
 
 unlock:
 	mutex_unlock(&radio->lock);
@@ -674,6 +676,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
 	radio->stereo = -1;
+	radio->muted = 1;
 
 	mutex_init(&radio->lock);
 
-- 
1.6.3.3


--------------080002050202010108050203--
