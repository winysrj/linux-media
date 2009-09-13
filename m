Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:9038 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZIMDbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:31:25 -0400
Received: by qw-out-2122.google.com with SMTP id 9so722164qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:31:28 -0700 (PDT)
Message-ID: <4AAC65A3.4010607@gmail.com>
Date: Sat, 12 Sep 2009 23:23:15 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 14/14] radio-mr800: set radio frequency only upon success
Content-Type: multipart/mixed;
 boundary="------------060205040502090700020106"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060205040502090700020106
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


--------------060205040502090700020106
Content-Type: text/x-diff;
 name="0014-mr800-set-radio-frequency-only-upon-success.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0014-mr800-set-radio-frequency-only-upon-success.patch"

>From 1c62f52da6114756d16644f8401f1903a50ae455 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 22:03:56 -0400
Subject: [PATCH 14/14] mr800: set radio frequency only upon success

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 4d955aa..f609fdf 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -235,6 +235,7 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 	if (retval < 0 || size != BUFFER_LENGTH)
 		goto out_err;
 
+	radio->curfreq = freq;
 	goto out;
 
 out_err:
@@ -370,13 +371,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = file->private_data;
-	int retval = 0;
-
-	radio->curfreq = f->frequency;
 
-	retval = amradio_setfreq(radio, radio->curfreq);
-
-	return retval;
+	return amradio_setfreq(radio, f->frequency);
 }
 
 /* vidioc_g_frequency - get tuner radio frequency */
-- 
1.6.3.3


--------------060205040502090700020106--
