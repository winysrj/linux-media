Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:26 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:25 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 07/21] em28xx: update description of em28xx_irq_callback
Date: Thu,  8 Nov 2012 20:11:39 +0200
Message-Id: <1352398313-3698-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
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

