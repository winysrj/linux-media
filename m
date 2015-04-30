Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbD3OI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 20/22] saa7134: change the debug macros for IR input
Date: Thu, 30 Apr 2015 11:08:40 -0300
Message-Id: <fe62248fcc4ff37a6a381616873f3d5d8dd62120.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the macros to input_dbg() and ir_dbg(), using pr_fmt()
on both, to be coherent with the other debug macro changes.

The ir_dbg() also prints the IR name.

I'm not sure if it is a good idea to keep both macros here,
but merging them would require tests on different flavors of
saaa7134-based boards.

So, for now, let's keep both.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 9406d5d7cdde..89f5fcf12722 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -41,10 +41,10 @@ static int pinnacle_remote;
 module_param(pinnacle_remote, int, 0644);    /* Choose Pinnacle PCTV remote */
 MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0)");
 
-#define dprintk(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG "%s/ir: " fmt, dev->name , ## arg)
-#define i2cdprintk(fmt, arg...)    if (ir_debug) \
-	printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg)
+#define input_dbg(fmt, arg...)	if (ir_debug) \
+	printk(KERN_DEBUG pr_fmt("input: " fmt), ## arg)
+#define ir_dbg(ir, fmt, arg...)    if (ir_debug) \
+	printk(KERN_DEBUG pr_fmt("ir %s: " fmt), ir->name, ## arg)
 
 /* Helper function for raw decoding at GPIO16 or GPIO18 */
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
@@ -75,7 +75,7 @@ static int build_key(struct saa7134_dev *dev)
 	}
 
 	data = ir_extract_bits(gpio, ir->mask_keycode);
-	dprintk("build_key gpio=0x%x mask=0x%x data=%d\n",
+	input_dbg("build_key gpio=0x%x mask=0x%x data=%d\n",
 		gpio, ir->mask_keycode, data);
 
 	switch (dev->board) {
@@ -119,7 +119,7 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 
 	if (dev == NULL) {
-		i2cdprintk("get_key_flydvb_trio: "
+		ir_dbg(ir, "get_key_flydvb_trio: "
 			   "ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
@@ -146,12 +146,12 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 			msleep(10);
 			continue;
 		}
-		i2cdprintk("send wake up byte to pic16C505 (IR chip)"
+		ir_dbg(ir, "send wake up byte to pic16C505 (IR chip)"
 			   "failed %dx\n", attempt);
 		return -EIO;
 	}
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -170,7 +170,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		i2cdprintk("get_key_msi_tvanywhere_plus: "
+		ir_dbg(ir, "get_key_msi_tvanywhere_plus: "
 			   "ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
@@ -191,7 +191,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 	/* GPIO says there is a button press. Get it. */
 
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -202,7 +202,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 
 	/* Button pressed */
 
-	dprintk("get_key_msi_tvanywhere_plus: Key = 0x%02X\n", b);
+	input_dbg("get_key_msi_tvanywhere_plus: Key = 0x%02X\n", b);
 	*protocol = RC_TYPE_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
@@ -219,7 +219,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		i2cdprintk("get_key_kworld_pc150u: "
+		ir_dbg(ir, "get_key_kworld_pc150u: "
 			   "ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
@@ -240,7 +240,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 	/* GPIO says there is a button press. Get it. */
 
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -251,7 +251,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 
 	/* Button pressed */
 
-	dprintk("get_key_kworld_pc150u: Key = 0x%02X\n", b);
+	input_dbg("get_key_kworld_pc150u: Key = 0x%02X\n", b);
 	*protocol = RC_TYPE_UNKNOWN;
 	*scancode = b;
 	*toggle = 0;
@@ -265,7 +265,7 @@ static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
 
 	/* poll IR chip */
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -334,7 +334,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 	ir->c->addr = 0x5a >> 1;
 
 	if (12 != i2c_master_recv(ir->c, data, 12)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -359,7 +359,7 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
 
 	/* poll IR chip */
 	if (4 != i2c_master_recv(ir->c, b, 4)) {
-		i2cdprintk("read error\n");
+		ir_dbg(ir, "read error\n");
 		return -EIO;
 	}
 
@@ -391,7 +391,7 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
 	*scancode = code;
 	*toggle = 0;
 
-	i2cdprintk("Pinnacle PCTV key %02x\n", code);
+	ir_dbg(ir, "Pinnacle PCTV key %02x\n", code);
 	return 1;
 }
 
@@ -916,7 +916,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	int rc;
 
 	if (disable_ir) {
-		dprintk("IR has been disabled, not probing for i2c remote\n");
+		input_dbg("IR has been disabled, not probing for i2c remote\n");
 		return;
 	}
 
@@ -959,7 +959,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		   an existing device. Weird...
 		   REVISIT: might no longer be needed */
 		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
-		dprintk("probe 0x%02x @ %s: %s\n",
+		input_dbg("probe 0x%02x @ %s: %s\n",
 			msg_msi.addr, dev->i2c_adap.name,
 			(1 == rc) ? "yes" : "no");
 		break;
@@ -974,7 +974,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		   an existing device. Weird...
 		   REVISIT: might no longer be needed */
 		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
-		dprintk("probe 0x%02x @ %s: %s\n",
+		input_dbg("probe 0x%02x @ %s: %s\n",
 			msg_msi.addr, dev->i2c_adap.name,
 			(1 == rc) ? "yes" : "no");
 		break;
@@ -1019,7 +1019,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		info.addr = 0x0b;
 		break;
 	default:
-		dprintk("No I2C IR support for board %x\n", dev->board);
+		input_dbg("No I2C IR support for board %x\n", dev->board);
 		return;
 	}
 
-- 
2.1.0

