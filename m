Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3E0MEf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 08:04:35 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4RC4Zr4020968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 May 2013 08:04:35 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] hdpvr: Simplify the logic that checks for error
Date: Mon, 27 May 2013 09:04:29 -0300
Message-Id: <1369656269-11444-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At get_video_info, there's a somewhat complex logic that checks
for error.

That logic can be highly simplified, as usb_control_msg will
only return a negative value, or the buffer length, as it does
the transfers via DMA.

While here, document why this particular driver is returning -EFAULT,
instead of the USB error code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index d1a3d84..a015a24 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -56,12 +56,6 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 			      0x1400, 0x0003,
 			      dev->usbc_buf, 5,
 			      1000);
-	if (ret == 5) {
-		vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
-		vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
-		vidinf->fps	= dev->usbc_buf[4];
-	}
-
 #ifdef HDPVR_DEBUG
 	if (hdpvr_debug & MSG_INFO) {
 		char print_buf[15];
@@ -73,11 +67,20 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
-	if (ret > 0 && ret != 5) { /* fail if unexpected byte count returned */
-		ret = -EFAULT;
-	}
+	/*
+	 * Returning EFAULT is wrong. Unfortunately, MythTV hdpvr
+	 * handling code was written to expect this specific error,
+	 * instead of accepting any error code. So, we can't fix it
+	 * in Kernel without breaking userspace.
+	 */
+	if (ret < 0)
+		return -EFAULT;
 
-	return ret < 0 ? ret : 0;
+	vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
+	vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
+	vidinf->fps	= dev->usbc_buf[4];
+
+	return 0;
 }
 
 int get_input_lines_info(struct hdpvr_device *dev)
-- 
1.8.1.4

