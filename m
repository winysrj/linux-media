Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:34039 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZIVCfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 22:35:55 -0400
Received: by yxe37 with SMTP id 37so3809794yxe.33
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 19:35:59 -0700 (PDT)
Message-ID: <4AB8366E.1010905@gmail.com>
Date: Mon, 21 Sep 2009 22:29:02 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: david@identd.dyndns.org
CC: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: Re: [RFC/RFT 08/14] radio-mr800: fix potential use after free
References: <4AAC657A.4070307@gmail.com>
In-Reply-To: <4AAC657A.4070307@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060806090705050902030705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060806090705050902030705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Version 2

 From c2c100652ed74d91ade7fdfb2a22d607ff43acf2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 21 Sep 2009 22:17:05 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 9fd2342..c8fbdde 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -273,8 +273,8 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
     mutex_unlock(&radio->lock);
 
     usb_set_intfdata(intf, NULL);
-    video_unregister_device(&radio->videodev);
     v4l2_device_disconnect(&radio->v4l2_dev);
+    video_unregister_device(&radio->videodev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.4.3



--------------060806090705050902030705
Content-Type: text/x-diff;
 name="0008-mr800-fix-potential-use-after-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0008-mr800-fix-potential-use-after-free.patch"

>From c2c100652ed74d91ade7fdfb2a22d607ff43acf2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 21 Sep 2009 22:17:05 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 9fd2342..c8fbdde 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -273,8 +273,8 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 	mutex_unlock(&radio->lock);
 
 	usb_set_intfdata(intf, NULL);
-	video_unregister_device(&radio->videodev);
 	v4l2_device_disconnect(&radio->v4l2_dev);
+	video_unregister_device(&radio->videodev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.4.3


--------------060806090705050902030705--
