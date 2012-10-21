Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34268 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab2JURx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so1752706wib.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:27 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 07/23] em28xx: update description of em28xx_irq_callback
Date: Sun, 21 Oct 2012 19:52:12 +0300
Message-Id: <1350838349-14763-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_irq_callback can be used for isoc and bulk transfers.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    3 ++-
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 0892d92..8f50f5c 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -919,7 +919,7 @@ EXPORT_SYMBOL_GPL(em28xx_set_mode);
    ------------------------------------------------------------------*/
 
 /*
- * IRQ callback, called by URB callback
+ * URB completion handler for isoc/bulk transfers
  */
 static void em28xx_irq_callback(struct urb *urb)
 {
@@ -946,6 +946,7 @@ static void em28xx_irq_callback(struct urb *urb)
 
 	/* Reset urb buffers */
 	for (i = 0; i < urb->number_of_packets; i++) {
+		/* isoc only (bulk: number_of_packets = 0) */
 		urb->iso_frame_desc[i].status = 0;
 		urb->iso_frame_desc[i].actual_length = 0;
 	}
-- 
1.7.10.4

