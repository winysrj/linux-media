Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f185.google.com ([209.85.221.185]:34967 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZIMD3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:29:11 -0400
Received: by qyk15 with SMTP id 15so1729687qyk.15
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:29:13 -0700 (PDT)
Message-ID: <4AAC658E.80401@gmail.com>
Date: Sat, 12 Sep 2009 23:22:54 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 11/14] radio-mr800: fix behavior of set_stereo function
Content-Type: multipart/mixed;
 boundary="------------020403060102000800060302"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020403060102000800060302
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


--------------020403060102000800060302
Content-Type: text/x-diff;
 name="0011-mr800-fix-behavior-of-set_stereo-function.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0011-mr800-fix-behavior-of-set_stereo-function.patch"

>From ea0c11ec6706fbd0777b0147da8a8a827a537699 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 22:00:29 -0400
Subject: [PATCH 11/14] mr800: fix behavior of set_stereo function

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index dbf0dbb..8fc413d 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -252,12 +252,13 @@ static int amradio_set_stereo(struct amradio_device *radio, char argument)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH) {
-		radio->stereo = -1;
+	if (retval < 0 || size != BUFFER_LENGTH)
 		return retval;
-	}
 
-	radio->stereo = 1;
+	if (argument == WANT_STEREO)
+		radio->stereo = 1;
+	else
+		radio->stereo = 0;
 
 	return retval;
 }
-- 
1.6.3.3


--------------020403060102000800060302--
