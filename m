Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48663 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbcLFKTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:24 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4 03/13] [media] winbond-cir: use sysfs wakeup filter
Date: Tue,  6 Dec 2016 10:19:11 +0000
Message-Id: <c97427a190a97afbf43236dbf7d29319e1bd8f57.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we can select the exact variant of the protocol for wakeup
filter, the winbond-cir can use the wakeup filter rather than module
parameters.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 252 ++++++++++++++++++++---------------------
 1 file changed, 125 insertions(+), 127 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 78491ed..ce1e8c2 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -194,7 +194,6 @@ enum wbcir_txstate {
 #define WBCIR_NAME	"Winbond CIR"
 #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
 #define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
-#define INVALID_SCANCODE   0x7FFFFFFF /* Invalid with all protos	*/
 #define WAKEUP_IOMEM_LEN         0x10 /* Wake-Up I/O Reg Len		*/
 #define EHFUNC_IOMEM_LEN         0x10 /* Enhanced Func I/O Reg Len	*/
 #define SP_IOMEM_LEN             0x08 /* Serial Port 3 (IR) Reg Len	*/
@@ -225,10 +224,6 @@ struct wbcir_data {
 	u32 txcarrier;
 };
 
-static enum wbcir_protocol protocol = IR_PROTOCOL_RC6;
-module_param(protocol, uint, 0444);
-MODULE_PARM_DESC(protocol, "IR protocol to use for the power-on command (0 = RC5, 1 = NEC, 2 = RC6A, default)");
-
 static bool invert; /* default = 0 */
 module_param(invert, bool, 0444);
 MODULE_PARM_DESC(invert, "Invert the signal from the IR receiver");
@@ -237,15 +232,6 @@ static bool txandrx; /* default = 0 */
 module_param(txandrx, bool, 0444);
 MODULE_PARM_DESC(txandrx, "Allow simultaneous TX and RX");
 
-static unsigned int wake_sc = 0x800F040C;
-module_param(wake_sc, uint, 0644);
-MODULE_PARM_DESC(wake_sc, "Scancode of the power-on IR command");
-
-static unsigned int wake_rc6mode = 6;
-module_param(wake_rc6mode, uint, 0644);
-MODULE_PARM_DESC(wake_rc6mode, "RC6 mode for the power-on command (0 = 0, 6 = 6A, default)");
-
-
 
 /*****************************************************************************
  *
@@ -696,138 +682,135 @@ wbcir_shutdown(struct pnp_dev *device)
 {
 	struct device *dev = &device->dev;
 	struct wbcir_data *data = pnp_get_drvdata(device);
+	struct rc_dev *rc = data->dev;
 	bool do_wake = true;
 	u8 match[11];
 	u8 mask[11];
 	u8 rc6_csl = 0;
+	u8 proto;
+	u32 wake_sc = rc->scancode_wakeup_filter.data;
+	u32 mask_sc = rc->scancode_wakeup_filter.mask;
 	int i;
 
 	memset(match, 0, sizeof(match));
 	memset(mask, 0, sizeof(mask));
 
-	if (wake_sc == INVALID_SCANCODE || !device_may_wakeup(dev)) {
+	if (!mask_sc || rc->wakeup_protocol == RC_TYPE_UNKNOWN ||
+						!device_may_wakeup(dev)) {
 		do_wake = false;
 		goto finish;
 	}
 
-	switch (protocol) {
-	case IR_PROTOCOL_RC5:
-		if (wake_sc > 0xFFF) {
-			do_wake = false;
-			dev_err(dev, "RC5 - Invalid wake scancode\n");
-			break;
-		}
-
+	switch (rc->wakeup_protocol) {
+	case RC_TYPE_RC5:
 		/* Mask = 13 bits, ex toggle */
-		mask[0] = 0xFF;
-		mask[1] = 0x17;
+		mask[0]  = (mask_sc & 0x003f);
+		mask[0] |= (mask_sc & 0x0300) >> 2;
+		mask[1]  = (mask_sc & 0x1c00) >> 10;
+		if (mask_sc & 0x0040)		      /* 2nd start bit  */
+			match[1] |= 0x10;
 
-		match[0]  = (wake_sc & 0x003F);      /* 6 command bits */
-		match[0] |= (wake_sc & 0x0180) >> 1; /* 2 address bits */
-		match[1]  = (wake_sc & 0x0E00) >> 9; /* 3 address bits */
-		if (!(wake_sc & 0x0040))             /* 2nd start bit  */
+		match[0]  = (wake_sc & 0x003F);       /* 6 command bits */
+		match[0] |= (wake_sc & 0x0300) >> 2;  /* 2 address bits */
+		match[1]  = (wake_sc & 0x1c00) >> 10; /* 3 address bits */
+		if (!(wake_sc & 0x0040))	      /* 2nd start bit  */
 			match[1] |= 0x10;
 
+		proto = IR_PROTOCOL_RC5;
 		break;
 
-	case IR_PROTOCOL_NEC:
-		if (wake_sc > 0xFFFFFF) {
-			do_wake = false;
-			dev_err(dev, "NEC - Invalid wake scancode\n");
-			break;
-		}
+	case RC_TYPE_NEC:
+		mask[1] = bitrev8(mask_sc);
+		mask[0] = ~mask[1];
+		mask[3] = bitrev8(mask_sc >> 8);
+		mask[2] = ~mask[3];
 
-		mask[0] = mask[1] = mask[2] = mask[3] = 0xFF;
+		match[1] = bitrev8(wake_sc);
+		match[0] = ~mask[1];
+		match[3] = bitrev8(wake_sc >> 8);
+		match[2] = ~mask[3];
 
-		match[1] = bitrev8((wake_sc & 0xFF));
-		match[0] = ~match[1];
+		proto = IR_PROTOCOL_NEC;
+		break;
 
-		match[3] = bitrev8((wake_sc & 0xFF00) >> 8);
-		if (wake_sc > 0xFFFF)
-			match[2] = bitrev8((wake_sc & 0xFF0000) >> 16);
-		else
-			match[2] = ~match[3];
+	case RC_TYPE_NECX:
+		mask[1] = bitrev8(mask_sc);
+		mask[0] = ~mask[1];
+		mask[3] = bitrev8(mask_sc >> 8);
+		mask[2] = bitrev8(mask_sc >> 16);
 
+		match[1] = bitrev8(wake_sc);
+		match[0] = ~mask[1];
+		match[3] = bitrev8(wake_sc >> 8);
+		match[2] = bitrev8(mask_sc >> 16);
+
+		proto = IR_PROTOCOL_NEC;
 		break;
 
-	case IR_PROTOCOL_RC6:
-
-		if (wake_rc6mode == 0) {
-			if (wake_sc > 0xFFFF) {
-				do_wake = false;
-				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
-			}
-
-			/* Command */
-			match[0] = wbcir_to_rc6cells(wake_sc >>  0);
-			mask[0]  = 0xFF;
-			match[1] = wbcir_to_rc6cells(wake_sc >>  4);
-			mask[1]  = 0xFF;
-
-			/* Address */
-			match[2] = wbcir_to_rc6cells(wake_sc >>  8);
-			mask[2]  = 0xFF;
-			match[3] = wbcir_to_rc6cells(wake_sc >> 12);
-			mask[3]  = 0xFF;
-
-			/* Header */
-			match[4] = 0x50; /* mode1 = mode0 = 0, ignore toggle */
-			mask[4]  = 0xF0;
-			match[5] = 0x09; /* start bit = 1, mode2 = 0 */
-			mask[5]  = 0x0F;
-
-			rc6_csl = 44;
-
-		} else if (wake_rc6mode == 6) {
-			i = 0;
-
-			/* Command */
-			match[i]  = wbcir_to_rc6cells(wake_sc >>  0);
-			mask[i++] = 0xFF;
-			match[i]  = wbcir_to_rc6cells(wake_sc >>  4);
-			mask[i++] = 0xFF;
-
-			/* Address + Toggle */
-			match[i]  = wbcir_to_rc6cells(wake_sc >>  8);
-			mask[i++] = 0xFF;
-			match[i]  = wbcir_to_rc6cells(wake_sc >> 12);
-			mask[i++] = 0x3F;
-
-			/* Customer bits 7 - 0 */
-			match[i]  = wbcir_to_rc6cells(wake_sc >> 16);
-			mask[i++] = 0xFF;
-			match[i]  = wbcir_to_rc6cells(wake_sc >> 20);
-			mask[i++] = 0xFF;
-
-			if (wake_sc & 0x80000000) {
-				/* Customer range bit and bits 15 - 8 */
-				match[i]  = wbcir_to_rc6cells(wake_sc >> 24);
-				mask[i++] = 0xFF;
-				match[i]  = wbcir_to_rc6cells(wake_sc >> 28);
-				mask[i++] = 0xFF;
-				rc6_csl = 76;
-			} else if (wake_sc <= 0x007FFFFF) {
-				rc6_csl = 60;
-			} else {
-				do_wake = false;
-				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
-			}
-
-			/* Header */
-			match[i]  = 0x93; /* mode1 = mode0 = 1, submode = 0 */
-			mask[i++] = 0xFF;
-			match[i]  = 0x0A; /* start bit = 1, mode2 = 1 */
-			mask[i++] = 0x0F;
+	case RC_TYPE_RC6_0:
+		/* Command */
+		match[0] = wbcir_to_rc6cells(wake_sc >> 0);
+		mask[0]  = wbcir_to_rc6cells(mask_sc >> 0);
+		match[1] = wbcir_to_rc6cells(wake_sc >> 4);
+		mask[1]  = wbcir_to_rc6cells(mask_sc >> 4);
+
+		/* Address */
+		match[2] = wbcir_to_rc6cells(wake_sc >>  8);
+		mask[2]  = wbcir_to_rc6cells(mask_sc >>  8);
+		match[3] = wbcir_to_rc6cells(wake_sc >> 12);
+		mask[3]  = wbcir_to_rc6cells(mask_sc >> 12);
+
+		/* Header */
+		match[4] = 0x50; /* mode1 = mode0 = 0, ignore toggle */
+		mask[4]  = 0xF0;
+		match[5] = 0x09; /* start bit = 1, mode2 = 0 */
+		mask[5]  = 0x0F;
+
+		rc6_csl = 44;
+		proto = IR_PROTOCOL_RC6;
+		break;
 
+	case RC_TYPE_RC6_6A_24:
+	case RC_TYPE_RC6_6A_32:
+	case RC_TYPE_RC6_MCE:
+		i = 0;
+
+		/* Command */
+		match[i]  = wbcir_to_rc6cells(wake_sc >>  0);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >>  0);
+		match[i]  = wbcir_to_rc6cells(wake_sc >>  4);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >>  4);
+
+		/* Address + Toggle */
+		match[i]  = wbcir_to_rc6cells(wake_sc >>  8);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >>  8);
+		match[i]  = wbcir_to_rc6cells(wake_sc >> 12);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >> 12);
+
+		/* Customer bits 7 - 0 */
+		match[i]  = wbcir_to_rc6cells(wake_sc >> 16);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >> 16);
+		match[i]  = wbcir_to_rc6cells(wake_sc >> 20);
+		mask[i++] = wbcir_to_rc6cells(mask_sc >> 20);
+
+		if (rc->wakeup_protocol == RC_TYPE_RC6_6A_24) {
+			rc6_csl = 60;
 		} else {
-			do_wake = false;
-			dev_err(dev, "RC6 - Invalid wake mode\n");
+			/* Customer range bit and bits 15 - 8 */
+			match[i]  = wbcir_to_rc6cells(wake_sc >> 24);
+			mask[i++] = wbcir_to_rc6cells(mask_sc >> 24);
+			match[i]  = wbcir_to_rc6cells(wake_sc >> 28);
+			mask[i++] = wbcir_to_rc6cells(mask_sc >> 28);
+			rc6_csl = 76;
 		}
 
+		/* Header */
+		match[i]  = 0x93; /* mode1 = mode0 = 1, submode = 0 */
+		mask[i++] = 0xFF;
+		match[i]  = 0x0A; /* start bit = 1, mode2 = 1 */
+		mask[i++] = 0x0F;
+		proto = IR_PROTOCOL_RC6;
 		break;
-
 	default:
 		do_wake = false;
 		break;
@@ -855,7 +838,8 @@ wbcir_shutdown(struct pnp_dev *device)
 		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);
 
 		/* Set CEIR_EN */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);
+		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL,
+						(proto << 4) | 0x01, 0x31);
 
 	} else {
 		/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
@@ -875,6 +859,21 @@ wbcir_shutdown(struct pnp_dev *device)
 	disable_irq(data->irq);
 }
 
+/*
+ * Wakeup handling is done on shutdown.
+ */
+static int
+wbcir_change_wakeup_protocol(struct rc_dev *rc, enum rc_type protocol)
+{
+	return 0;
+}
+
+static int
+wbcir_set_wakeup_filter(struct rc_dev *rc, struct rc_scancode_filter *filter)
+{
+	return 0;
+}
+
 static int
 wbcir_suspend(struct pnp_dev *device, pm_message_t state)
 {
@@ -893,7 +892,7 @@ wbcir_init_hw(struct wbcir_data *data)
 	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
 
 	/* Set PROT_SEL, RX_INV, Clear CEIR_EN (needed for the led) */
-	tmp = protocol << 4;
+	tmp = 0;
 	if (invert)
 		tmp |= 0x08;
 	outb(tmp, data->wbase + WBCIR_REG_WCEIR_CTL);
@@ -1084,6 +1083,14 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protocols = RC_BIT_ALL;
+	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
+			RC_BIT_RC5 | RC_BIT_RC6_0 | RC_BIT_RC6_6A_24 |
+			RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE;
+	data->dev->wakeup_protocol = RC_TYPE_RC6_MCE;
+	data->dev->scancode_wakeup_filter.data = 0x800F040C;
+	data->dev->scancode_wakeup_filter.mask = ~0;
+	data->dev->change_wakeup_protocol = wbcir_change_wakeup_protocol;
+	data->dev->s_wakeup_filter = wbcir_set_wakeup_filter;
 
 	err = rc_register_device(data->dev);
 	if (err)
@@ -1199,15 +1206,6 @@ wbcir_init(void)
 {
 	int ret;
 
-	switch (protocol) {
-	case IR_PROTOCOL_RC5:
-	case IR_PROTOCOL_NEC:
-	case IR_PROTOCOL_RC6:
-		break;
-	default:
-		pr_err("Invalid power-on protocol\n");
-	}
-
 	ret = pnp_register_driver(&wbcir_driver);
 	if (ret)
 		pr_err("Unable to register driver\n");
-- 
2.9.3

