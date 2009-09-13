Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:27644 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZIMDa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:30:29 -0400
Received: by qw-out-2122.google.com with SMTP id 9so722067qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:30:32 -0700 (PDT)
Message-ID: <4AAC657A.4070307@gmail.com>
Date: Sat, 12 Sep 2009 23:22:34 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 08/14] radio-mr800: fix potential use after free
Content-Type: multipart/mixed;
 boundary="------------060704010204070404060704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060704010204070404060704
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


--------------060704010204070404060704
Content-Type: text/x-diff;
 name="0008-mr800-fix-potential-use-after-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0008-mr800-fix-potential-use-after-free.patch"

>From 8c441616f67011244cb15bc1a3dda6fd8706ecd2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 16:04:44 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 9fd2342..87b58e3 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -274,7 +274,6 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	video_unregister_device(&radio->videodev);
-	v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.3.3


--------------060704010204070404060704--
