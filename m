Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45517 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZIMDWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:22:47 -0400
Received: by qw-out-2122.google.com with SMTP id 9so721299qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:22:51 -0700 (PDT)
Message-ID: <4AAC6581.40103@gmail.com>
Date: Sat, 12 Sep 2009 23:22:41 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 09/14] radio-mr800: remove device initialization from open/close
Content-Type: multipart/mixed;
 boundary="------------090605030205070105060602"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090605030205070105060602
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


--------------090605030205070105060602
Content-Type: text/x-diff;
 name="0009-mr800-remove-device-initialization-from-open-close.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0009-mr800-remove-device-initialization-from-open-close.patc";
 filename*1="h"

>From 5d01d49c78e2788dca8981af7369c799b650c706 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 16:28:45 -0400
Subject: [PATCH 09/14] mr800: remove device initialization from open/close

Device initialization should happen on an as needed basis.
This change allows the device to continue operating even
when there are no applications using it. This should allow
simple command based applications to turn the device on and
off without a persistent process.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   35 ++---------------------------------
 1 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 87b58e3..df020e8 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -136,7 +136,6 @@ struct amradio_device {
 	struct mutex lock;	/* buffer locking */
 	int curfreq;
 	int stereo;
-	int users;
 	int muted;
 };
 
@@ -492,26 +491,6 @@ static int usb_amradio_open(struct file *file)
 	}
 
 	file->private_data = radio;
-	radio->users = 1;
-	radio->muted = 1;
-
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev.dev,
-			"radio did not start up properly\n");
-		radio->users = 0;
-		goto unlock;
-	}
-
-	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"set stereo failed\n");
-
-	retval = amradio_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"set frequency failed\n");
 
 unlock:
 	mutex_unlock(&radio->lock);
@@ -526,19 +505,9 @@ static int usb_amradio_close(struct file *file)
 
 	mutex_lock(&radio->lock);
 
-	if (!radio->usbdev) {
+	if (!radio->usbdev)
 		retval = -EIO;
-		goto unlock;
-	}
-
-	radio->users = 0;
 
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"amradio_stop failed\n");
-
-unlock:
 	mutex_unlock(&radio->lock);
 	return retval;
 }
@@ -669,10 +638,10 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
 	radio->videodev.release = usb_amradio_video_device_release;
 
-	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
 	radio->stereo = -1;
+	radio->muted = 1;
 
 	mutex_init(&radio->lock);
 
-- 
1.6.3.3


--------------090605030205070105060602--
