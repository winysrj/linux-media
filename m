Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:51644 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2L0XCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:45 -0500
Received: by mail-ea0-f182.google.com with SMTP id a14so4002535eaa.27
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:44 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/6] ir-kbd-i2c: fix get_key_knc1()
Date: Fri, 28 Dec 2012 00:02:48 +0100
Message-Id: <1356649368-5426-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- return valid key code when button is hold
- debug: print key code only when a button is pressed

Tested with device "Terratec Cinergy 200 USB" (em28xx).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ir-kbd-i2c.c |   15 +++++----------
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 08ae067..2984b7d 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -184,18 +184,13 @@ static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		return -EIO;
 	}
 
-	/* it seems that 0xFE indicates that a button is still hold
-	   down, while 0xff indicates that no button is hold
-	   down. 0xfe sequences are sometimes interrupted by 0xFF */
-
-	dprintk(2,"key %02x\n", b);
-
-	if (b == 0xff)
+	if (b == 0xff) /* no button */
 		return 0;
 
-	if (b == 0xfe)
-		/* keep old data */
-		return 1;
+	if (b == 0xfe) /* button is still hold */
+		b = ir->rc->last_scancode; /* keep old data */
+
+	dprintk(2,"key %02x\n", b);
 
 	*ir_key = b;
 	*ir_raw = b;
-- 
1.7.10.4

