Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33191 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbbJ2ThO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 15:37:14 -0400
Received: by wmeg8 with SMTP id g8so30616170wme.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 12:37:12 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: ir-sharp-decoder: add support for Denon variant of
 the protocol
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Message-ID: <56327348.80807@gmail.com>
Date: Thu, 29 Oct 2015 20:28:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Denon also uses the Sharp protocol, however with different check bits.

It would have been also possible to add this as a separate protocol
but this may not be worth the effort.

Successfully tested with a Denon RC-1002 remote control.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/Kconfig            | 3 ++-
 drivers/media/rc/ir-sharp-decoder.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index b6e1311..bd4d685 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -101,7 +101,8 @@ config IR_SHARP_DECODER
 
 	---help---
 	   Enable this option if you have an infrared remote control which
-	   uses the Sharp protocol, and you need software decoding support.
+	   uses the Sharp protocol (Sharp, Denon), and you need software
+	   decoding support.
 
 config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index b7acdba..1f33164 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -118,7 +118,9 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		if (data->count == SHARP_NBITS) {
 			/* exp,chk bits should be 1,0 */
-			if ((data->bits & 0x3) != 0x2)
+			if ((data->bits & 0x3) != 0x2 &&
+			/* DENON variant, both chk bits 0 */
+			    (data->bits & 0x3) != 0x0)
 				break;
 			data->state = STATE_ECHO_SPACE;
 		} else {
-- 
2.6.2

