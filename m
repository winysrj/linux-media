Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:15620 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbZILOuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:50:14 -0400
Received: by qw-out-2122.google.com with SMTP id 9so632979qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:50:18 -0700 (PDT)
Message-ID: <4AABB520.9030805@gmail.com>
Date: Sat, 12 Sep 2009 10:50:08 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 09/10] radio-mr800: preserve radio state during suspend/resume
Content-Type: multipart/mixed;
 boundary="------------040600020708040902030708"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040600020708040902030708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 31243088bd32d5568f06f2044f8ff782641e16b5 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 02:05:57 -0400
Subject: [PATCH 09/10] mr800: preserve radio state during suspend/resume

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 11db6ea..10bed62 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -574,9 +574,12 @@ static int usb_amradio_suspend(struct usb_interface 
*intf, pm_message_t message)
 
     mutex_lock(&radio->lock);
 
-    retval = amradio_set_mute(radio, AMRADIO_STOP);
-    if (retval < 0)
-        dev_warn(&intf->dev, "amradio_stop failed\n");
+    if (!radio->muted) {
+        retval = amradio_set_mute(radio, AMRADIO_STOP);
+        if (retval < 0)
+            dev_warn(&intf->dev, "amradio_stop failed\n");
+        radio->muted = 0;
+    }
 
     dev_info(&intf->dev, "going into suspend..\n");
 
@@ -592,9 +595,11 @@ static int usb_amradio_resume(struct usb_interface 
*intf)
 
     mutex_lock(&radio->lock);
 
-    retval = amradio_set_mute(radio, AMRADIO_START);
-    if (retval < 0)
-        dev_warn(&intf->dev, "amradio_start failed\n");
+    if (!radio->muted) {
+        retval = amradio_set_mute(radio, AMRADIO_START);
+        if (retval < 0)
+            dev_warn(&intf->dev, "amradio_start failed\n");
+    }
 
     dev_info(&intf->dev, "coming out of suspend..\n");
 
-- 
1.6.3.3


--------------040600020708040902030708
Content-Type: text/x-diff;
 name="0009-mr800-preserve-radio-state-during-suspend-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0009-mr800-preserve-radio-state-during-suspend-resume.patch"

>From 31243088bd32d5568f06f2044f8ff782641e16b5 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 02:05:57 -0400
Subject: [PATCH 09/10] mr800: preserve radio state during suspend/resume

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 11db6ea..10bed62 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -574,9 +574,12 @@ static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 
 	mutex_lock(&radio->lock);
 
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_stop failed\n");
+	if (!radio->muted) {
+		retval = amradio_set_mute(radio, AMRADIO_STOP);
+		if (retval < 0)
+			dev_warn(&intf->dev, "amradio_stop failed\n");
+		radio->muted = 0;
+	}
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
@@ -592,9 +595,11 @@ static int usb_amradio_resume(struct usb_interface *intf)
 
 	mutex_lock(&radio->lock);
 
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_start failed\n");
+	if (!radio->muted) {
+		retval = amradio_set_mute(radio, AMRADIO_START);
+		if (retval < 0)
+			dev_warn(&intf->dev, "amradio_start failed\n");
+	}
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
 
-- 
1.6.3.3


--------------040600020708040902030708--
