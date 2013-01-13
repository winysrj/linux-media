Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60714 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3AMOUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:30 -0500
Received: by mail-ea0-f182.google.com with SMTP id d1so1375356eaa.41
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:29 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/7] em28xx-input: remove dead code line from em28xx_get_key_em_haup()
Date: Sun, 13 Jan 2013 15:20:39 +0100
Message-Id: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Field 'old' of struct IR_i2c is used nowhere in module ir-kbd-i2c.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |    2 --
 1 Datei geändert, 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 07f6030..f554a52 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -125,8 +125,6 @@ static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (buf[1] == 0xff)
 		return 0;
 
-	ir->old = buf[1];
-
 	/*
 	 * Rearranges bits to the right order.
 	 * The bit order were determined experimentally by using
-- 
1.7.10.4

