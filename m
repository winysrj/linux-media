Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34268 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2JURxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:36 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so1752706wib.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:36 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 12/23] em28xx: remove double checks for urb->status == -ENOENT in urb_data_copy functions
Date: Sun, 21 Oct 2012 19:52:18 +0300
Message-Id: <1350838349-14763-14-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This check is already done in the URB handler
em28xx_irq_callback before calling these functions.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c   |    5 +----
 drivers/media/usb/em28xx/em28xx-video.c |   10 ++--------
 2 Dateien geändert, 3 Zeilen hinzugefügt(+), 12 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 66535dc..b47e164 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -134,11 +134,8 @@ static inline int em28xx_dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
 	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
 		return 0;
 
-	if (urb->status < 0) {
+	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
-		if (urb->status == -ENOENT)
-			return 0;
-	}
 
 	for (i = 0; i < urb->number_of_packets; i++) {
 		int status = urb->iso_frame_desc[i].status;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4024dfc..3518753 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -429,11 +429,8 @@ static inline int em28xx_isoc_copy(struct em28xx *dev, struct urb *urb)
 	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
 		return 0;
 
-	if (urb->status < 0) {
+	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
-		if (urb->status == -ENOENT)
-			return 0;
-	}
 
 	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
@@ -525,11 +522,8 @@ static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
 	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
 		return 0;
 
-	if (urb->status < 0) {
+	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
-		if (urb->status == -ENOENT)
-			return 0;
-	}
 
 	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
-- 
1.7.10.4

