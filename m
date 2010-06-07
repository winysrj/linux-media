Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51232 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0FGTcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:31 -0400
Subject: [PATCH 3/8] ir-core: partially convert cx88 to not use ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:28 +0200
Message-ID: <20100607193228.21236.330.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Partially convert drivers/media/video/cx88/cx88-input.c to
not use ir-functions.c

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/cx88/cx88-input.c |   46 +++++++++++----------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 0de9bdf..e6ecbf8 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 
 #include "cx88.h"
+#include <media/ir-core.h>
 #include <media/ir-common.h>
 
 #define MODULE_NAME "cx88xx"
@@ -38,8 +39,8 @@
 struct cx88_IR {
 	struct cx88_core *core;
 	struct input_dev *input;
-	struct ir_input_state ir;
 	struct ir_dev_props props;
+	u64 ir_type;
 
 	int users;
 
@@ -50,7 +51,6 @@ struct cx88_IR {
 	u32 sampling;
 	u32 samples[16];
 	int scount;
-	unsigned long release;
 
 	/* poll external decoder */
 	int polling;
@@ -124,29 +124,21 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		ir_input_keydown(ir->input, &ir->ir, data);
-		ir_input_nokey(ir->input, &ir->ir);
+		ir_keydown(ir->input, data, 0);
 
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
-		if (gpio & ir->mask_keydown) {
-			ir_input_keydown(ir->input, &ir->ir, data);
-		} else {
-			ir_input_nokey(ir->input, &ir->ir);
-		}
+		if (gpio & ir->mask_keydown)
+			ir_keydown(ir->input, data, 0);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
-		if (0 == (gpio & ir->mask_keyup)) {
-			ir_input_keydown(ir->input, &ir->ir, data);
-		} else {
-			ir_input_nokey(ir->input, &ir->ir);
-		}
+		if (0 == (gpio & ir->mask_keyup))
+			ir_keydown(ir->input, data, 0);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		ir_input_keydown(ir->input, &ir->ir, data);
-		ir_input_nokey(ir->input, &ir->ir);
+		ir_keydown(ir->input, data, 0);
 	}
 }
 
@@ -438,9 +430,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
+	ir->ir_type = ir_type;
 
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
@@ -515,8 +505,6 @@ void cx88_ir_irq(struct cx88_core *core)
 	}
 	if (!ir->scount) {
 		/* nothing to sample */
-		if (ir->ir.keypressed && time_after(jiffies, ir->release))
-			ir_input_nokey(ir->input, &ir->ir);
 		return;
 	}
 
@@ -552,7 +540,7 @@ void cx88_ir_irq(struct cx88_core *core)
 
 		if (ircode == 0) { /* key still pressed */
 			ir_dprintk("pulse distance decoded repeat code\n");
-			ir->release = jiffies + msecs_to_jiffies(120);
+			ir_repeat(ir->input);
 			break;
 		}
 
@@ -566,10 +554,8 @@ void cx88_ir_irq(struct cx88_core *core)
 			break;
 		}
 
-		ir_dprintk("Key Code: %x\n", (ircode >> 16) & 0x7f);
-
-		ir_input_keydown(ir->input, &ir->ir, (ircode >> 16) & 0x7f);
-		ir->release = jiffies + msecs_to_jiffies(120);
+		ir_dprintk("Key Code: %x\n", (ircode >> 16) & 0xff);
+		ir_keydown(ir->input, (ircode >> 16) & 0xff, 0);
 		break;
 	case CX88_BOARD_HAUPPAUGE:
 	case CX88_BOARD_HAUPPAUGE_DVB_T1:
@@ -605,16 +591,16 @@ void cx88_ir_irq(struct cx88_core *core)
 		if ( dev != 0x1e && dev != 0x1f )
 			/* not a hauppauge remote */
 			break;
-		ir_input_keydown(ir->input, &ir->ir, code);
-		ir->release = jiffies + msecs_to_jiffies(120);
+		ir_keydown(ir->input, code, toggle);
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
 		ir_dprintk("biphase decoded: %x\n", ircode);
 		if ((ircode & 0xfffff000) != 0x3000)
 			break;
-		ir_input_keydown(ir->input, &ir->ir, ircode & 0x3f);
-		ir->release = jiffies + msecs_to_jiffies(120);
+		/* Note: bit 0x800 being the toggle is assumed, not checked
+		   with real hardware  */
+		ir_keydown(ir->input, ircode & 0x3f, ircode & 0x0800 ? 1 : 0);
 		break;
 	}
 

