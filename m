Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40847 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753987AbeCWL5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 20/30] media: ir-kbd-i2c: improve error handling code
Date: Fri, 23 Mar 2018 07:57:06 -0400
Message-Id: <c3902dab05a2a256607764ac0b5688f29ac544c7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current I2C error handling logic makes static analyzers
confused, and it doesn't follow the coding style we're using:

	drivers/media/i2c/ir-kbd-i2c.c:180 get_key_pixelview() error: uninitialized symbol 'b'.
	drivers/media/i2c/ir-kbd-i2c.c:224 get_key_knc1() error: uninitialized symbol 'b'.
	drivers/media/i2c/ir-kbd-i2c.c:226 get_key_knc1() error: uninitialized symbol 'b'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ir-kbd-i2c.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 193020d64e51..1d11aab1817a 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -168,11 +168,15 @@ static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_pixelview(struct IR_i2c *ir, enum rc_proto *protocol,
 			     u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		dev_dbg(&ir->rc->dev, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -185,11 +189,15 @@ static int get_key_pixelview(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_proto *protocol,
 			      u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char buf[4];
 
 	/* poll IR chip */
-	if (4 != i2c_master_recv(ir->c, buf, 4)) {
+	rc = i2c_master_recv(ir->c, buf, 4);
+	if (rc != 4) {
 		dev_dbg(&ir->rc->dev, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -209,11 +217,15 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_knc1(struct IR_i2c *ir, enum rc_proto *protocol,
 			u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		dev_dbg(&ir->rc->dev, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
-- 
2.14.3
