Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49607 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2L0XCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:44 -0500
Received: by mail-ee0-f48.google.com with SMTP id b57so4823751eek.7
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:43 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/6] em28xx: IR RC: move assignment of get_key functions from *_change_protocol() functions to em28xx_ir_init()
Date: Fri, 28 Dec 2012 00:02:47 +0100
Message-Id: <1356649368-5426-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The get_key functions are independent from the selected protocol, so assign
them once only at device initialization.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |    6 ++----
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 62b6cb7..186820a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -360,7 +360,6 @@ static int em2860_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 		*rc_type = ir->rc_type;
 		return -EINVAL;
 	}
-	ir->get_key = default_polling_getkey;
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
@@ -396,10 +395,7 @@ static int em2874_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 		*rc_type = ir->rc_type;
 		return -EINVAL;
 	}
-
-	ir->get_key = em2874_polling_getkey;
 	em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
-
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
@@ -618,11 +614,13 @@ static int em28xx_ir_init(struct em28xx *dev)
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
 		case CHIP_ID_EM2883:
+			ir->get_key = default_polling_getkey;
 			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 			break;
 		case CHIP_ID_EM2884:
 		case CHIP_ID_EM2874:
 		case CHIP_ID_EM28174:
+			ir->get_key = em2874_polling_getkey;
 			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
 			break;
 		default:
-- 
1.7.10.4

