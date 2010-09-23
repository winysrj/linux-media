Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab0IWEdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 00:33:08 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4X78D023082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:33:07 -0400
Received: from pedra (vpn-239-203.phx2.redhat.com [10.3.239.203])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4X3md018821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:33:06 -0400
Date: Thu, 23 Sep 2010 01:32:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] V4L/DVB: bttv: Move PV951 IR to the right driver
Message-ID: <20100923013253.5ad22d19@pedra>
In-Reply-To: <cover.1285215968.git.mchehab@redhat.com>
References: <cover.1285215968.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
index 407fa61..d502f41 100644
--- a/drivers/media/video/bt8xx/bttv-i2c.c
+++ b/drivers/media/video/bt8xx/bttv-i2c.c
@@ -390,41 +390,3 @@ int __devinit init_bttv_i2c(struct bttv *btv)
 
 	return btv->i2c_rc;
 }
-
-/* Instantiate the I2C IR receiver device, if present */
-void __devinit init_bttv_i2c_ir(struct bttv *btv)
-{
-	if (0 == btv->i2c_rc) {
-		struct i2c_board_info info;
-		/* The external IR receiver is at i2c address 0x34 (0x35 for
-		   reads).  Future Hauppauge cards will have an internal
-		   receiver at 0x30 (0x31 for reads).  In theory, both can be
-		   fitted, and Hauppauge suggest an external overrides an
-		   internal.
-
-		   That's why we probe 0x1a (~0x34) first. CB
-		*/
-		const unsigned short addr_list[] = {
-			0x1a, 0x18, 0x4b, 0x64, 0x30, 0x71,
-			I2C_CLIENT_END
-		};
-
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
-	}
-}
-
-int __devexit fini_bttv_i2c(struct bttv *btv)
-{
-	if (0 != btv->i2c_rc)
-		return 0;
-
-	return i2c_del_adapter(&btv->c.i2c_adap);
-}
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index f68717a..8c90673 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -245,6 +245,83 @@ static void bttv_ir_stop(struct bttv *btv)
 	}
 }
 
+/*
+ * Get_key functions used by I2C remotes
+ */
+
+static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	unsigned char b;
+
+	/* poll IR chip */
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+		dprintk(KERN_INFO DEVNAME ": read error\n");
+		return -EIO;
+	}
+
+	/* ignore 0xaa */
+	if (b==0xaa)
+		return 0;
+	dprintk(KERN_INFO DEVNAME ": key %02x\n", b);
+
+	*ir_key = b;
+	*ir_raw = b;
+	return 1;
+}
+
+/* Instantiate the I2C IR receiver device, if present */
+void __devinit init_bttv_i2c_ir(struct bttv *btv)
+{
+	const unsigned short addr_list[] = {
+		0x1a, 0x18, 0x64, 0x30, 0x71,
+		I2C_CLIENT_END
+	};
+	struct i2c_board_info info;
+
+	if (0 != btv->i2c_rc)
+		return;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	memset(&btv->init_data, 0, sizeof(btv->init_data));
+	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+
+	switch (btv->c.type) {
+	case BTTV_BOARD_PV951:
+		btv->init_data.name = "PV951";
+		btv->init_data.get_key = get_key_pv951;
+		btv->init_data.ir_codes = RC_MAP_PV951;
+		btv->init_data.type = IR_TYPE_OTHER;
+		info.addr = 0x4b;
+		break;
+	default:
+		/*
+		 * The external IR receiver is at i2c address 0x34 (0x35 for
+                 * reads).  Future Hauppauge cards will have an internal
+                 * receiver at 0x30 (0x31 for reads).  In theory, both can be
+                 * fitted, and Hauppauge suggest an external overrides an
+                 * internal.
+		 * That's why we probe 0x1a (~0x34) first. CB
+		 */
+
+		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
+		return;
+	}
+
+	if (btv->init_data.name)
+		info.platform_data = &btv->init_data;
+	i2c_new_device(&btv->c.i2c_adap, &info);
+
+	return;
+}
+
+int __devexit fini_bttv_i2c(struct bttv *btv)
+{
+	if (0 != btv->i2c_rc)
+		return 0;
+
+	return i2c_del_adapter(&btv->c.i2c_adap);
+}
+
 int bttv_input_init(struct bttv *btv)
 {
 	struct card_ir *ir;
@@ -420,10 +497,3 @@ void bttv_input_fini(struct bttv *btv)
 	kfree(btv->remote);
 	btv->remote = NULL;
 }
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index 3ec2402..6fd2a8e 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -18,7 +18,6 @@
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
 #include <media/ir-common.h>
-#include <media/ir-kbd-i2c.h>
 #include <media/i2c-addr.h>
 #include <media/tuner.h>
 
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 6cccc2a..d1e26a4 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -42,7 +42,7 @@
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
 #include <media/ir-common.h>
-
+#include <media/ir-kbd-i2c.h>
 
 #include "bt848.h"
 #include "bttv.h"
@@ -271,6 +271,12 @@ int bttv_sub_del_devices(struct bttv_core *core);
 extern int no_overlay;
 
 /* ---------------------------------------------------------- */
+/* bttv-input.c                                               */
+
+extern void init_bttv_i2c_ir(struct bttv *btv);
+extern int fini_bttv_i2c(struct bttv *btv);
+
+/* ---------------------------------------------------------- */
 /* bttv-driver.c                                              */
 
 /* insmod options */
@@ -279,8 +285,6 @@ extern unsigned int bttv_debug;
 extern unsigned int bttv_gpio;
 extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
 extern int init_bttv_i2c(struct bttv *btv);
-extern void init_bttv_i2c_ir(struct bttv *btv);
-extern int fini_bttv_i2c(struct bttv *btv);
 
 #define bttv_printk if (bttv_verbose) printk
 #define dprintk  if (bttv_debug >= 1) printk
@@ -366,6 +370,9 @@ struct bttv {
 	int has_remote;
 	struct card_ir *remote;
 
+	/* I2C remote data */
+	struct IR_i2c_init_data    init_data;
+
 	/* locking */
 	spinlock_t s_lock;
 	struct mutex lock;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index ece6e15..02fbd08 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -146,26 +146,6 @@ static int get_key_pixelview(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	return 1;
 }
 
-static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
-{
-	unsigned char b;
-
-	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		dprintk(1,"read error\n");
-		return -EIO;
-	}
-
-	/* ignore 0xaa */
-	if (b==0xaa)
-		return 0;
-	dprintk(2,"key %02x\n", b);
-
-	*ir_key = b;
-	*ir_raw = b;
-	return 1;
-}
-
 static int get_key_fusionhdtv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char buf[4];
@@ -321,12 +301,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
-	case 0x4b:
-		name        = "PV951";
-		ir->get_key = get_key_pv951;
-		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = RC_MAP_PV951;
-		break;
 	case 0x18:
 	case 0x1f:
 	case 0x1a:
@@ -396,9 +370,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		case IR_KBD_GET_KEY_PIXELVIEW:
 			ir->get_key = get_key_pixelview;
 			break;
-		case IR_KBD_GET_KEY_PV951:
-			ir->get_key = get_key_pv951;
-			break;
 		case IR_KBD_GET_KEY_HAUP:
 			ir->get_key = get_key_haup;
 			break;
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 5e96d7a..4102f0d 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -24,7 +24,6 @@ struct IR_i2c {
 enum ir_kbd_get_key_fn {
 	IR_KBD_GET_KEY_CUSTOM = 0,
 	IR_KBD_GET_KEY_PIXELVIEW,
-	IR_KBD_GET_KEY_PV951,
 	IR_KBD_GET_KEY_HAUP,
 	IR_KBD_GET_KEY_KNC1,
 	IR_KBD_GET_KEY_FUSIONHDTV,
-- 
1.7.1


