Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:35 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:35 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 11/21] em28xx: clear USB halt/stall condition in em28xx_init_usb_xfer when using bulk transfers
Date: Thu,  8 Nov 2012 20:11:43 +0200
Message-Id: <1352398313-3698-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   11 +++++++++++
 1 Datei geändert, 11 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index d8a8e8b..8b8f783 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1174,6 +1174,17 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 			return rc;
 	}
 
+	if (xfer_bulk) {
+		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
+		if (rc < 0) {
+			em28xx_err("failed to clear USB bulk endpoint "
+				   "stall/halt condition (error=%i)\n",
+				   rc);
+			em28xx_uninit_usb_xfer(dev, mode);
+			return rc;
+		}
+	}
+
 	init_waitqueue_head(&dma_q->wq);
 	init_waitqueue_head(&vbi_dma_q->wq);
 
-- 
1.7.10.4

