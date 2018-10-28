Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52235 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbeJ2GHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 02:07:34 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: saa7134: hvr1110 can decode rc6
Date: Sun, 28 Oct 2018 21:21:42 +0000
Message-Id: <20181028212142.26572-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function get_key_hvr1110 can only decode rc5, however this is a
standard hauppauge z8f0811 which can decode rc6 as well. Use
get_key_haup_xvr() instead.

Test on a HVR 1110.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c | 43 +++--------------------
 1 file changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 6e6d68964017..bc1ed7798d21 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -299,43 +299,6 @@ static int get_key_purpletv(struct IR_i2c *ir, enum rc_proto *protocol,
 	return 1;
 }
 
-static int get_key_hvr1110(struct IR_i2c *ir, enum rc_proto *protocol,
-			   u32 *scancode, u8 *toggle)
-{
-	int rc;
-	unsigned char buf[5];
-
-	/* poll IR chip */
-	rc = i2c_master_recv(ir->c, buf, 5);
-	if (rc != 5) {
-		ir_dbg(ir, "read error\n");
-		if (rc < 0)
-			return rc;
-		return -EIO;
-	}
-
-	/* Check if some key were pressed */
-	if (!(buf[0] & 0x80))
-		return 0;
-
-	/*
-	 * buf[3] & 0x80 is always high.
-	 * buf[3] & 0x40 is a parity bit. A repeat event is marked
-	 * by preserving it into two separate readings
-	 * buf[4] bits 0 and 1, and buf[1] and buf[2] are always
-	 * zero.
-	 *
-	 * Note that the keymap which the hvr1110 uses is RC5.
-	 *
-	 * FIXME: start bits could maybe be used...?
-	 */
-	*protocol = RC_PROTO_RC5;
-	*scancode = RC_SCANCODE_RC5(buf[3] & 0x1f, buf[4] >> 2);
-	*toggle = !!(buf[3] & 0x40);
-	return 1;
-}
-
-
 static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_proto *protocol,
 			      u32 *scancode, u8 *toggle)
 {
@@ -1029,9 +992,11 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 			(1 == rc) ? "yes" : "no");
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		dev->init_data.name = "HVR 1110";
-		dev->init_data.get_key = get_key_hvr1110;
+		dev->init_data.name = saa7134_boards[dev->board].name;
 		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
+		dev->init_data.type = RC_PROTO_BIT_RC5 |
+				RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_RC6_6A_32;
+		dev->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		info.addr = 0x71;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
-- 
2.17.2
