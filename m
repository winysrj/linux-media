Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41667 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2KYKhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:37:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997651eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:37:49 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/6] em28xx: fix video data start position calculation in em28xx_urb_data_copy_vbi()
Date: Sun, 25 Nov 2012 11:37:32 +0100
Message-Id: <1353839857-2990-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header check/removal code at the end of function em28xx_urb_data_copy_vbi()
is obsolete, because this is already done earlier in this function.
In fact it is incomplete (doesn't check for vbi header) and causes trouble
when the first data bytes are the same as header bytes (which is fortunately
very unlikely).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   20 ++------------------
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 18 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4ec54fd..7994d17 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -678,24 +678,8 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			dma_q->pos = 0;
 		}
 
-		if (buf != NULL && dev->capture_type == 2) {
-			if (len >= 4 && p[0] == 0x88 && p[1] == 0x88 &&
-			    p[2] == 0x88 && p[3] == 0x88) {
-				p += 4;
-				len -= 4;
-			}
-			if (len >= 4 && p[0] == 0x22 && p[1] == 0x5a) {
-				em28xx_usbdbg("Video frame %d, len=%i, %s\n",
-					       p[2], len, (p[2] & 1) ?
-					       "odd" : "even");
-				p += 4;
-				len -= 4;
-			}
-
-			if (len > 0)
-				em28xx_copy_video(dev, dma_q, buf, p, outp,
-						  len);
-		}
+		if (buf != NULL && dev->capture_type == 2 && len > 0)
+			em28xx_copy_video(dev, dma_q, buf, p, outp, len);
 	}
 	return rc;
 }
-- 
1.7.10.4

