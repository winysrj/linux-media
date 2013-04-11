Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60907 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3DKTzC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 15:55:02 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so904396eak.24
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 12:55:01 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: fix snapshot button support
Date: Thu, 11 Apr 2013 21:56:01 +0200
Message-Id: <1365710161-4939-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The snapshot button support is currently broken, because module em28xx-rc is
loaded only if the device has remote control support.
Fix it by also loading this module if the device has a snapshot button.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    3 ++-
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 085b8fc..2da17af 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2810,7 +2810,8 @@ static void request_module_async(struct work_struct *work)
 
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
-	if ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir)
+	if (dev->board.has_snapshot_button ||
+	    ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir))
 		request_module("em28xx-rc");
 #endif /* CONFIG_MODULES */
 }
-- 
1.7.10.4

