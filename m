Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0DFTNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 15:13:13 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36JDCAi018076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 15:13:12 -0400
Received: from pedra (vpn-8-182.rdu.redhat.com [10.11.8.182])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o36JD8a9005366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 15:13:10 -0400
Date: Tue, 6 Apr 2010 15:18:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com> (by way of Mauro
	Carvalho Chehab <mchehab@redhat.com>)
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <20100406151802.7f564b3d@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 17/26] V4L/DVB: Convert drivers/media/dvb/ttpci/budget-ci.c
 to use ir-core
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: David Härdeman <david@hardeman.nu>

Converts drivers/media/dvb/ttpci/budget-ci.c to use ir-core rather than
rolling its own keydown timeout handler and reporting keys via
drivers/media/IR/ir-functions.c.

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index be20749..8950df1 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -35,7 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/spinlock.h>
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 
 #include "budget.h"
 
@@ -82,12 +82,6 @@
 #define SLOTSTATUS_READY	8
 #define SLOTSTATUS_OCCUPIED	(SLOTSTATUS_PRESENT|SLOTSTATUS_RESET|SLOTSTATUS_READY)
 
-/*
- * Milliseconds during which a key is regarded as pressed.
- * If an identical command arrives within this time, the timer will start over.
- */
-#define IR_KEYPRESS_TIMEOUT	250
-
 /* RC5 device wildcard */
 #define IR_DEVICE_ANY		255
 
@@ -104,12 +98,9 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 struct budget_ci_ir {
 	struct input_dev *dev;
 	struct tasklet_struct msp430_irq_tasklet;
-	struct timer_list timer_keyup;
 	char name[72]; /* 40 + 32 for (struct saa7146_dev).name */
 	char phys[32];
-	struct ir_input_state state;
 	int rc5_device;
-	u32 last_raw;
 	u32 ir_key;
 	bool have_command;
 };
@@ -124,18 +115,11 @@ struct budget_ci {
 	u8 tuner_pll_address; /* used for philips_tdm1316l configs */
 };
 
-static void msp430_ir_keyup(unsigned long data)
-{
-	struct budget_ci_ir *ir = (struct budget_ci_ir *) data;
-	ir_input_nokey(ir->dev, &ir->state);
-}
-
 static void msp430_ir_interrupt(unsigned long data)
 {
 	struct budget_ci *budget_ci = (struct budget_ci *) data;
 	struct input_dev *dev = budget_ci->ir.dev;
 	u32 command = ttpci_budget_debiread(&budget_ci->budget, DEBINOSWAP, DEBIADDR_IR, 2, 1, 0) >> 8;
-	u32 raw;
 
 	/*
 	 * The msp430 chip can generate two different bytes, command and device
@@ -171,20 +155,12 @@ static void msp430_ir_interrupt(unsigned long data)
 		return;
 	budget_ci->ir.have_command = false;
 
+	/* FIXME: We should generate complete scancodes with device info */
 	if (budget_ci->ir.rc5_device != IR_DEVICE_ANY &&
 	    budget_ci->ir.rc5_device != (command & 0x1f))
 		return;
 
-	/* Is this a repeated key sequence? (same device, command, toggle) */
-	raw = budget_ci->ir.ir_key | (command << 8);
-	if (budget_ci->ir.last_raw != raw || !timer_pending(&budget_ci->ir.timer_keyup)) {
-		ir_input_nokey(dev, &budget_ci->ir.state);
-		ir_input_keydown(dev, &budget_ci->ir.state,
-				 budget_ci->ir.ir_key);
-		budget_ci->ir.last_raw = raw;
-	}
-
-	mod_timer(&budget_ci->ir.timer_keyup, jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT));
+	ir_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
@@ -251,11 +227,6 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 
 	ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
 
-	/* initialise the key-up timeout handler */
-	init_timer(&budget_ci->ir.timer_keyup);
-	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
-	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
-	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
 	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
@@ -284,9 +255,6 @@ static void msp430_ir_deinit(struct budget_ci *budget_ci)
 	saa7146_setgpio(saa, 3, SAA7146_GPIO_INPUT);
 	tasklet_kill(&budget_ci->ir.msp430_irq_tasklet);
 
-	del_timer_sync(&dev->timer);
-	ir_input_nokey(dev, &budget_ci->ir.state);
-
 	ir_input_unregister(dev);
 }
 
-- 
1.6.6.1


