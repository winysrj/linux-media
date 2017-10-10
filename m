Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41269 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755354AbdJJHSE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:04 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 11/26] media: rc: document and fix rc_validate_scancode()
Date: Tue, 10 Oct 2017 08:18:03 +0100
Message-Id: <073d6101e16dd762362bf177f8335b268e0ac1df.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some IR protocols, some scancode values not valid, i.e. they're part
of a different protocol variant.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 38393f13822f..ae1df089c96f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -776,21 +776,35 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
 /**
- * rc_validate_scancode() - checks that a scancode is valid for a protocol
+ * rc_validate_scancode() - checks that a scancode is valid for a protocol.
+ *	For nec, it should do the opposite of ir_nec_bytes_to_scancode()
  * @proto:	protocol
  * @scancode:	scancode
  */
 bool rc_validate_scancode(enum rc_proto proto, u32 scancode)
 {
 	switch (proto) {
+	/*
+	 * NECX has a 16-bit address; if the lower 8 bits match the upper
+	 * 8 bits inverted, then the address would match regular nec.
+	 */
 	case RC_PROTO_NECX:
 		if ((((scancode >> 16) ^ ~(scancode >> 8)) & 0xff) == 0)
 			return false;
 		break;
+	/*
+	 * NEC32 has a 16 bit address and 16 bit command. If the lower 8 bits
+	 * of the command match the upper 8 bits inverted, then it would
+	 * be either NEC or NECX.
+	 */
 	case RC_PROTO_NEC32:
-		if ((((scancode >> 24) ^ ~(scancode >> 16)) & 0xff) == 0)
+		if ((((scancode >> 8) ^ ~scancode) & 0xff) == 0)
 			return false;
 		break;
+	/*
+	 * If the customer code (top 32-bit) is 0x800f, it is MCE else it
+	 * is regular mode-6a 32 bit
+	 */
 	case RC_PROTO_RC6_MCE:
 		if ((scancode & 0xffff0000) != 0x800f0000)
 			return false;
-- 
2.13.6
