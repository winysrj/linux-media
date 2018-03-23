Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35364 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754042AbeCWL5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 19/30] media: saa7134-input: improve error handling
Date: Fri, 23 Mar 2018 07:57:05 -0400
Message-Id: <5fd46ac9291402ba1d04e2c5ce3b295e1c13143e.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the code produces those false-positives:
	drivers/media/pci/saa7134/saa7134-input.c:203 get_key_msi_tvanywhere_plus() error: uninitialized symbol 'b'.
	drivers/media/pci/saa7134/saa7134-input.c:251 get_key_kworld_pc150u() error: uninitialized symbol 'b'.
	drivers/media/pci/saa7134/saa7134-input.c:275 get_key_purpletv() error: uninitialized symbol 'b'.

Improve the error handling code, making it to look like our
coding style.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7134/saa7134-input.c | 46 +++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 33ee8322895e..0e28c5021ac4 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -115,7 +115,7 @@ static int build_key(struct saa7134_dev *dev)
 static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_proto *protocol,
 			       u32 *scancode, u8 *toggle)
 {
-	int gpio;
+	int gpio, rc;
 	int attempt = 0;
 	unsigned char b;
 
@@ -153,8 +153,11 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_proto *protocol,
 		       attempt);
 		return -EIO;
 	}
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -169,7 +172,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir,
 				       u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
-	int gpio;
+	int gpio, rc;
 
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
@@ -193,8 +196,11 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir,
 
 	/* GPIO says there is a button press. Get it. */
 
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -218,6 +224,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_proto *protocol,
 {
 	unsigned char b;
 	unsigned int gpio;
+	int rc;
 
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
@@ -241,8 +248,11 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* GPIO says there is a button press. Get it. */
 
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -263,11 +273,15 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_purpletv(struct IR_i2c *ir, enum rc_proto *protocol,
 			    u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -288,11 +302,17 @@ static int get_key_purpletv(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_hvr1110(struct IR_i2c *ir, enum rc_proto *protocol,
 			   u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char buf[5];
 
 	/* poll IR chip */
-	if (5 != i2c_master_recv(ir->c, buf, 5))
+	rc = i2c_master_recv(ir->c, buf, 5);
+	if (rc != 5) {
+		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
+	}
 
 	/* Check if some key were pressed */
 	if (!(buf[0] & 0x80))
@@ -319,6 +339,7 @@ static int get_key_hvr1110(struct IR_i2c *ir, enum rc_proto *protocol,
 static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_proto *protocol,
 			      u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char data[12];
 	u32 gpio;
 
@@ -335,8 +356,11 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	ir->c->addr = 0x5a >> 1;
 
-	if (12 != i2c_master_recv(ir->c, data, 12)) {
+	rc = i2c_master_recv(ir->c, data, 12);
+	if (rc != 12) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
@@ -356,12 +380,16 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_proto *protocol,
 			    u32 *scancode, u8 *toggle, int parity_offset,
 			    int marker, int code_modulo)
 {
+	int rc;
 	unsigned char b[4];
 	unsigned int start = 0,parity = 0,code = 0;
 
 	/* poll IR chip */
-	if (4 != i2c_master_recv(ir->c, b, 4)) {
+	rc = i2c_master_recv(ir->c, b, 4);
+	if (rc != 4) {
 		ir_dbg(ir, "read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
-- 
2.14.3
