Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52170 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab0DOVqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:19 -0400
Subject: [PATCH 4/8] ir-core: remove ir-functions usage from dm1105
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:15 +0200
Message-ID: <20100415214615.14142.43915.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers/media/dvb/dm1105/dm1105.c to not rely on
ir-functions.c.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 333d7b1..89f1eca 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -27,7 +27,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/input.h>
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 
 #include "demux.h"
 #include "dmxdev.h"
@@ -266,7 +266,6 @@ static void dm1105_card_list(struct pci_dev *pci)
 /* infrared remote control */
 struct infrared {
 	struct input_dev	*input_dev;
-	struct ir_input_state	ir;
 	char			input_phys[32];
 	struct work_struct	work;
 	u32			ir_command;
@@ -532,8 +531,7 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	ir_input_keydown(ir->input_dev, &ir->ir, data);
-	ir_input_nokey(ir->input_dev, &ir->ir);
+	ir_keydown(ir->input_dev, data, 0);
 }
 
 /* work handler */
@@ -596,7 +594,6 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct input_dev *input_dev;
 	char *ir_codes = NULL;
-	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
 	input_dev = input_allocate_device();
@@ -607,12 +604,6 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 	snprintf(dm1105->ir.input_phys, sizeof(dm1105->ir.input_phys),
 		"pci-%s/ir0", pci_name(dm1105->pdev));
 
-	err = ir_input_init(input_dev, &dm1105->ir.ir, ir_type);
-	if (err < 0) {
-		input_free_device(input_dev);
-		return err;
-	}
-
 	input_dev->name = "DVB on-card IR receiver";
 	input_dev->phys = dm1105->ir.input_phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -630,8 +621,12 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
 	err = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	if (err < 0) {
+		input_free_device(input_dev);
+		return err;
+	}
 
-	return err;
+	return 0;
 }
 
 void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)

