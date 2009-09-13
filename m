Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45517 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZIMDXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:23:08 -0400
Received: by qw-out-2122.google.com with SMTP id 9so721299qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:23:11 -0700 (PDT)
Message-ID: <4AAC6595.5090401@gmail.com>
Date: Sat, 12 Sep 2009 23:23:01 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 12/14] radio-mr800: preserve radio state during suspend/resume
Content-Type: multipart/mixed;
 boundary="------------070809090701050301070102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070809090701050301070102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 8c441616f67011244cb15bc1a3dda6fd8706ecd2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 16:04:44 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 9fd2342..87b58e3 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -274,7 +274,6 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
 
     usb_set_intfdata(intf, NULL);
     video_unregister_device(&radio->videodev);
-    v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.3.3


--------------070809090701050301070102
Content-Type: text/x-diff;
 name="0012-mr800-preserve-radio-state-during-suspend-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0012-mr800-preserve-radio-state-during-suspend-resume.patch"

>From c8c27c663db7294c660a3bac659742c915ce91a9 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 22:01:49 -0400
Subject: [PATCH 12/14] mr800: preserve radio state during suspend/resume

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 8fc413d..ed734bb 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -573,9 +573,12 @@ static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 
 	mutex_lock(&radio->lock);
 
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_stop failed\n");
+	if (!radio->muted && radio->initialized) {
+		retval = amradio_set_mute(radio, AMRADIO_STOP);
+		if (retval < 0)
+			dev_warn(&intf->dev, "amradio_stop failed\n");
+		radio->muted = 0;
+	}
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
@@ -591,10 +594,30 @@ static int usb_amradio_resume(struct usb_interface *intf)
 
 	mutex_lock(&radio->lock);
 
-	retval = amradio_set_mute(radio, AMRADIO_START);
+	if (unlikely(!radio->initialized))
+		goto unlock;
+
+	if (radio->stereo)
+		retval = amradio_set_stereo(radio, WANT_STEREO);
+	else
+		retval = amradio_set_stereo(radio, WANT_MONO);
+
 	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_start failed\n");
+		amradio_dev_warn(&radio->videodev.dev, "set stereo failed\n");
 
+	retval = amradio_setfreq(radio, radio->curfreq);
+	if (retval < 0)
+		amradio_dev_warn(&radio->videodev.dev,
+			"set frequency failed\n");
+
+	if (!radio->muted) {
+		retval = amradio_set_mute(radio, AMRADIO_START);
+		if (retval < 0)
+			dev_warn(&radio->videodev.dev,
+				"amradio_start failed\n");
+	}
+
+unlock:
 	dev_info(&intf->dev, "coming out of suspend..\n");
 
 	mutex_unlock(&radio->lock);
-- 
1.6.3.3


--------------070809090701050301070102--
