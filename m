Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35917 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753467AbcISWV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:21:27 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: Hauppauge z8f0811 can decode RC6
Date: Mon, 19 Sep 2016 23:21:23 +0100
Message-Id: <1474323685-16439-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware does not decode the 16, 20 or 24 bit variety.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c               | 90 ++++++++++++++++++----------
 drivers/media/pci/cx18/cx18-i2c.c            |  3 +-
 drivers/media/pci/cx88/cx88-input.c          |  3 +-
 drivers/media/pci/ivtv/ivtv-i2c.c            |  3 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c          |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |  3 +-
 6 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index bf82726..f95a6bc 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -35,6 +35,7 @@
  *
  */
 
+#include <asm/unaligned.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -63,51 +64,80 @@ module_param(debug, int, 0644);    /* debug level (0,1,2) */
 /* ----------------------------------------------------------------------- */
 
 static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
-			       u32 *scancode, u8 *ptoggle, int size, int offset)
+					u32 *scancode, u8 *ptoggle, int size)
 {
 	unsigned char buf[6];
-	int start, range, toggle, dev, code, ircode;
+	int start, range, toggle, dev, code, ircode, vendor;
 
 	/* poll IR chip */
 	if (size != i2c_master_recv(ir->c, buf, size))
 		return -EIO;
 
-	/* split rc5 data block ... */
-	start  = (buf[offset] >> 7) &    1;
-	range  = (buf[offset] >> 6) &    1;
-	toggle = (buf[offset] >> 5) &    1;
-	dev    =  buf[offset]       & 0x1f;
-	code   = (buf[offset+1] >> 2) & 0x3f;
+	if (buf[0] & 0x80) {
+		int offset = (size == 6) ? 3 : 0;
 
-	/* rc5 has two start bits
-	 * the first bit must be one
-	 * the second bit defines the command range (1 = 0-63, 0 = 64 - 127)
-	 */
-	if (!start)
-		/* no key pressed */
-		return 0;
+		/* split rc5 data block ... */
+		start  = (buf[offset] >> 7) &    1;
+		range  = (buf[offset] >> 6) &    1;
+		toggle = (buf[offset] >> 5) &    1;
+		dev    =  buf[offset]       & 0x1f;
+		code   = (buf[offset+1] >> 2) & 0x3f;
 
-	/* filter out invalid key presses */
-	ircode = (start << 12) | (toggle << 11) | (dev << 6) | code;
-	if ((ircode & 0x1fff) == 0x1fff)
-		return 0;
+		/* rc5 has two start bits
+		 * the first bit must be one
+		 * the second bit defines the command range:
+		 * 1 = 0-63, 0 = 64 - 127
+		 */
+		if (!start)
+			/* no key pressed */
+			return 0;
 
-	if (!range)
-		code += 64;
+		/* filter out invalid key presses */
+		ircode = (start << 12) | (toggle << 11) | (dev << 6) | code;
+		if ((ircode & 0x1fff) == 0x1fff)
+			return 0;
 
-	dprintk(1,"ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
-		start, range, toggle, dev, code);
+		if (!range)
+			code += 64;
 
-	*protocol = RC_TYPE_RC5;
-	*scancode = RC_SCANCODE_RC5(dev, code);
-	*ptoggle = toggle;
-	return 1;
+		dprintk(1, "ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
+			start, range, toggle, dev, code);
+
+		*protocol = RC_TYPE_RC5;
+		*scancode = RC_SCANCODE_RC5(dev, code);
+		*ptoggle = toggle;
+
+		return 1;
+	} else if (size == 6 && (buf[0] & 0x40)) {
+		code = buf[4];
+		dev = buf[3];
+		vendor = get_unaligned_be16(buf + 1);
+
+		if (vendor == 0x800f) {
+			*ptoggle = (dev & 0x80) != 0;
+			*protocol = RC_TYPE_RC6_MCE;
+			dev &= 0x7f;
+			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
+						toggle, vendor, dev, code);
+		} else {
+			*ptoggle = 0;
+			*protocol = RC_TYPE_RC6_6A_32;
+			dprintk(1, "ir hauppauge (rc6-6a-32): vendor=%d dev=%d code=%d\n",
+							vendor, dev, code);
+		}
+
+		*scancode = RC_SCANCODE_RC6_6A(vendor, dev, code);
+
+		return 1;
+	}
+
+	return 0;
 }
 
 static int get_key_haup(struct IR_i2c *ir, enum rc_type *protocol,
 			u32 *scancode, u8 *toggle)
 {
-	return get_key_haup_common (ir, protocol, scancode, toggle, 3, 0);
+	return get_key_haup_common(ir, protocol, scancode, toggle, 3);
 }
 
 static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
@@ -126,7 +156,7 @@ static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
 	if (ret != 1)
 		return (ret < 0) ? ret : -EINVAL;
 
-	return get_key_haup_common(ir, protocol, scancode, toggle, 6, 3);
+	return get_key_haup_common(ir, protocol, scancode, toggle, 6);
 }
 
 static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
@@ -347,7 +377,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x71:
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
-		rc_type     = RC_BIT_RC5;
+		rc_type     = RC_BIT_RC5 | RC_BIT_RC6_MCE | RC_BIT_RC6_6A_32;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	}
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 4af8cd6..c932937 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -98,7 +98,8 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_BIT_RC5;
+		init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
+							RC_BIT_RC6_6A_32;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 3f1342c..21d029b 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -631,7 +631,8 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-			core->init_data.type = RC_BIT_RC5;
+			core->init_data.type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
+							RC_BIT_RC6_6A_32;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index c9dbeb3..98b5375 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -218,7 +218,8 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_BIT_RC5;
+		init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE |
+							RC_BIT_RC6_6A_32;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_I2C_IR_RX_ADAPTEC:
diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index a38f58c..ee419fa 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -55,7 +55,7 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 	/* Our default information for ir-kbd-i2c.c to use */
 	init_data->ir_codes = RC_MAP_HAUPPAUGE;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-	init_data->type = RC_BIT_RC5;
+	init_data->type = RC_BIT_RC5 | RC_BIT_RC6_MCE | RC_BIT_RC6_6A_32;
 	init_data->name = "HD-PVR";
 	init_data->polling_interval = 405; /* ms, duplicated from Windows */
 	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index 14321d0..6da5fb5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -596,7 +596,8 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type                  = RC_BIT_RC5;
+		init_data->type                  = RC_BIT_RC5 | RC_BIT_RC6_MCE |
+							RC_BIT_RC6_6A_32;
 		init_data->name                  = hdw->hdw_desc->description;
 		/* IR Receiver */
 		info.addr          = 0x71;
-- 
2.7.4

