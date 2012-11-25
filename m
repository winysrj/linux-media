Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63428 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2KYKiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:38:05 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4046398eaa.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:38:04 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/6] em28xx: em28xx_urb_data_copy_vbi(): calculate vbi_size only if needed
Date: Sun, 25 Nov 2012 11:37:36 +0100
Message-Id: <1353839857-2990-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    5 ++---
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 12e4b0a..6843784 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -525,7 +525,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 	struct em28xx_buffer    *buf, *vbi_buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
-	int xfer_bulk, vbi_size, num_packets, i, rc = 1;
+	int xfer_bulk, num_packets, i, rc = 1;
 	unsigned int actual_length, len = 0;
 	unsigned char *p, *outp = NULL, *vbioutp = NULL;
 
@@ -612,9 +612,8 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 		/* NOTE: with bulk transfers, intermediate data packets
 		 * have no continuation header */
 
-		vbi_size = dev->vbi_width * dev->vbi_height;
-
 		if (dev->capture_type == 0) {
+			int vbi_size = dev->vbi_width * dev->vbi_height;
 			if (dev->vbi_read >= vbi_size) {
 				/* We've already read all the VBI data, so
 				   treat the rest as video */
-- 
1.7.10.4

