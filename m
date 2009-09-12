Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZILOuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:50:21 -0400
Received: by mail-qy0-f172.google.com with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:50:25 -0700 (PDT)
Message-ID: <4AABB528.1060603@gmail.com>
Date: Sat, 12 Sep 2009 10:50:16 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 10/10] radio-mr800: fix potential use after free
Content-Type: multipart/mixed;
 boundary="------------080909020300030208050703"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080909020300030208050703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 987d22363c7a55a5e48a2746a61a6d805fef8661 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 02:35:22 -0400
Subject: [PATCH 10/10] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 10bed62..806523c 100644
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


--------------080909020300030208050703
Content-Type: text/x-diff;
 name="0010-mr800-fix-potential-use-after-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0010-mr800-fix-potential-use-after-free.patch"

>From 987d22363c7a55a5e48a2746a61a6d805fef8661 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 02:35:22 -0400
Subject: [PATCH 10/10] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 10bed62..806523c 100644
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


--------------080909020300030208050703--
