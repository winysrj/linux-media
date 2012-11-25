Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41667 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2KYKh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:37:57 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997651eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:37:57 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/6] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
Date: Sun, 25 Nov 2012 11:37:34 +0100
Message-Id: <1353839857-2990-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set capture type to 1 (video start) when the video frame start header is
detected. This bug didn't cause any trouble, because this type of header is
never received in vbi mode.
Fix it, because we want to use this function with disabled vbi in the future.
Also start with capture type -1 to avoid processing of corrupted/incomplete
frame data which is usually received at streaming start (especially when
USB bulk transfers are used).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 ++
 1 Datei geändert, 2 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 0bbc6dc..b170476 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -603,6 +603,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 				len -= 4;
 			} else if (p[0] == 0x22 && p[1] == 0x5a) {
 				/* start video */
+				dev->capture_type = 1;
 				p += 4;
 				len -= 4;
 			}
@@ -774,6 +775,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		urb_init = 1;
 
 	if (urb_init) {
+		dev->capture_type = -1;
 		if (em28xx_vbi_supported(dev) == 1)
 			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
 						  dev->analog_xfer_bulk,
-- 
1.7.10.4

