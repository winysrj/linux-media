Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54311 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbcLBRRJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:09 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/8] [media] em28xx: IR protocol not reported correctly
Date: Fri,  2 Dec 2016 17:16:10 +0000
Message-Id: <1480698974-9093-4-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report the correct NEC variant.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/em28xx/em28xx-input.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index a1904e2..a9a7f16 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -259,18 +259,21 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 		break;
 
 	case RC_BIT_NEC:
-		poll_result->protocol = RC_TYPE_RC5;
 		poll_result->scancode = msg[1] << 8 | msg[2];
-		if ((msg[3] ^ msg[4]) != 0xff)		/* 32 bits NEC */
+		if ((msg[3] ^ msg[4]) != 0xff) {	/* 32 bits NEC */
+			poll_result->protocol = RC_TYPE_NEC32;
 			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
 								  (msg[2] << 16) |
 								  (msg[3] << 8)  |
 								  (msg[4]));
-		else if ((msg[1] ^ msg[2]) != 0xff)	/* 24 bits NEC */
+		} else if ((msg[1] ^ msg[2]) != 0xff) {	/* 24 bits NEC */
+			poll_result->protocol = RC_TYPE_NECX;
 			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
 								 msg[2], msg[3]);
-		else					/* Normal NEC */
+		} else {				/* Normal NEC */
+			poll_result->protocol = RC_TYPE_NEC;
 			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
+		}
 		break;
 
 	case RC_BIT_RC6_0:
@@ -775,7 +778,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
 			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC |
-					     RC_BIT_RC6_0;
+				RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_0;
 			break;
 		default:
 			err = -ENODEV;
-- 
2.9.3

