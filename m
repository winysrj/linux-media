Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1LaVA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 16:00:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: mrjuuzer@upcmail.hu
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] saa7134: fix IR handling for HVR-1110
Date: Sat, 31 Dec 2011 18:58:58 -0200
Message-Id: <1325365138-18745-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <20111231132217.DZKT1551.viefep16-int.chello.at@edge01.upcmail.net>
References: <20111231132217.DZKT1551.viefep16-int.chello.at@edge01.upcmail.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return the complete RC-5 code, instead of just the 8 least significant
bits.

Reported-by: Dorozel Csaba <mrjuuzer@upcmail.hu>
Tested-by: Dorozel Csaba <mrjuuzer@upcmail.hu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

Please, re-test this patch. It is a more detailed version of the
previous one, with a few more documentation, and some cleanups.


 drivers/media/video/saa7134/saa7134-input.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index d4ee24b..0e4926a 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -235,22 +235,27 @@ static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 
 static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
-	unsigned char buf[5], cod4, code3, code4;
+	unsigned char buf[5], scancode;
 
 	/* poll IR chip */
 	if (5 != i2c_master_recv(ir->c, buf, 5))
 		return -EIO;
 
-	cod4	= buf[4];
-	code4	= (cod4 >> 2);
-	code3	= buf[3];
-	if (code3 == 0)
-		/* no key pressed */
+	/* Check if some key were pressed */
+	if (!(buf[0] & 0x80))
 		return 0;
 
-	/* return key */
-	*ir_key = code4;
-	*ir_raw = code4;
+	/*
+	 * buf[3] & 0x80 is always high.
+	 * buf[3] & 0x40 is a parity bit. A repeat event is marked
+	 * by preserving it into two separate readings
+	 * buf[4] bits 0 and 1, and buf[1] and buf[2] are always
+	 * zero.
+	 */
+	scancode = 0x1fff & ((buf[3] << 8) | (buf[4] >> 2));
+
+	*ir_key = scancode;
+	*ir_raw = scancode;
 	return 1;
 }
 
-- 
1.7.8.352.g876a6

