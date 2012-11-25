Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34934 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2KYKhv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:37:51 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997648eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:37:50 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/6] em28xx: make sure the packet size is >= 4 before checking for headers in em28xx_urb_data_copy_vbi()
Date: Sun, 25 Nov 2012 11:37:33 +0100
Message-Id: <1353839857-2990-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   45 ++++++++++++++++---------------
 1 Datei geändert, 24 Zeilen hinzugefügt(+), 21 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7994d17..0bbc6dc 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -576,7 +576,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			    urb->iso_frame_desc[i].offset;
 		}
 
-		if (actual_length <= 0) {
+		if (actual_length == 0) {
 			/* NOTE: happens very often with isoc transfers */
 			/* em28xx_usbdbg("packet %d is empty",i); - spammy */
 			continue;
@@ -585,27 +585,30 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 		/* capture type 0 = vbi start
 		   capture type 1 = video start
 		   capture type 2 = video in progress */
-		if (p[0] == 0x33 && p[1] == 0x95) {
-			dev->capture_type = 0;
-			dev->vbi_read = 0;
-			em28xx_usbdbg("VBI START HEADER!!!\n");
-			dev->cur_field = p[2];
-			p += 4;
-			len = actual_length - 4;
-		} else if (p[0] == 0x88 && p[1] == 0x88 &&
-			   p[2] == 0x88 && p[3] == 0x88) {
-			/* continuation */
-			p += 4;
-			len = actual_length - 4;
-		} else if (p[0] == 0x22 && p[1] == 0x5a) {
-			/* start video */
-			p += 4;
-			len = actual_length - 4;
-		} else {
-			/* NOTE: With bulk transfers, intermediate data packets
-			 * have no continuation header */
-			len = actual_length;
+		len = actual_length;
+		if (len >= 4) {
+			/* NOTE: headers are always 4 bytes and
+			 * never split across packets */
+			if (p[0] == 0x33 && p[1] == 0x95) {
+				dev->capture_type = 0;
+				dev->vbi_read = 0;
+				em28xx_usbdbg("VBI START HEADER!!!\n");
+				dev->cur_field = p[2];
+				p += 4;
+				len -= 4;
+			} else if (p[0] == 0x88 && p[1] == 0x88 &&
+				   p[2] == 0x88 && p[3] == 0x88) {
+				/* continuation */
+				p += 4;
+				len -= 4;
+			} else if (p[0] == 0x22 && p[1] == 0x5a) {
+				/* start video */
+				p += 4;
+				len -= 4;
+			}
 		}
+		/* NOTE: with bulk transfers, intermediate data packets
+		 * have no continuation header */
 
 		vbi_size = dev->vbi_width * dev->vbi_height;
 
-- 
1.7.10.4

