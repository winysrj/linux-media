Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935618Ab0CMAnd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 19:43:33 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hWWS031966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:32 -0500
Received: from [10.3.250.145] (vpn-250-145.phx2.redhat.com [10.3.250.145])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hTcg017573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:31 -0500
Message-Id: <ba527793a5e752fddf8e739d3cf4cac4383b6547.1268440758.git.mchehab@redhat.com>
In-Reply-To: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
References: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Fri, 12 Mar 2010 21:18:14 -0300
Subject: [PATCH 4/4] V4L/DVB: ir-core: export driver name used by IR via uevent
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now, both driver and keytable names are exported to userspace. This
will help userspace to decide when a table need to be replaced
by another one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 31f22ba..2d9ba84 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -403,7 +403,8 @@ EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
  */
 int ir_input_register(struct input_dev *input_dev,
 		      const struct ir_scancode_table *rc_tab,
-		      const struct ir_dev_props *props)
+		      const struct ir_dev_props *props,
+		      const char *driver_name)
 {
 	struct ir_input_dev *ir_dev;
 	struct ir_scancode  *keymap    = rc_tab->scan;
@@ -418,6 +419,10 @@ int ir_input_register(struct input_dev *input_dev,
 
 	spin_lock_init(&ir_dev->rc_tab.lock);
 
+	ir_dev->driver_name = kmalloc(strlen(driver_name) + 1, GFP_KERNEL);
+	if (!ir_dev->driver_name)
+		return -ENOMEM;
+	strcpy(ir_dev->driver_name, driver_name);
 	ir_dev->rc_tab.name = rc_tab->name;
 	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
 	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 0f4da05..bbddf2f 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -139,6 +139,8 @@ static int ir_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 
 	if (ir_dev->rc_tab.name)
 		ADD_HOTPLUG_VAR("NAME=\"%s\"", ir_dev->rc_tab.name);
+	if (ir_dev->driver_name)
+		ADD_HOTPLUG_VAR("DRV_NAME=\"%s\"", ir_dev->driver_name);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 383cca3..f1721e9 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -45,6 +45,8 @@
 #include "z0194a.h"
 #include "ds3000.h"
 
+#define MODULE_NAME "dm1105"
+
 #define UNSET (-1U)
 
 #define DM1105_BOARD_NOAUTO		UNSET
@@ -627,7 +629,7 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
-	err = ir_input_register(input_dev, ir_codes, NULL);
+	err = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 
 	return err;
 }
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index 4675a3b..6baf302 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -32,6 +32,8 @@
 #include "mantis_reg.h"
 #include "mantis_uart.h"
 
+#define MODULE_NAME "mantis_core"
+
 static struct ir_scancode mantis_ir_table[] = {
 	{ 0x29, KEY_POWER	},
 	{ 0x28, KEY_FAVORITES	},
@@ -126,7 +128,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 	rc->id.version	= 1;
 	rc->dev		= mantis->pdev->dev;
 
-	err = ir_input_register(rc, &ir_mantis, NULL);
+	err = ir_input_register(rc, &ir_mantis, NULL, MODULE_NAME);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret = %d", err);
 		input_free_device(rc);
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 49c2a81..ec89afd 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -54,6 +54,8 @@
 #include "tda1002x.h"
 #include "tda827x.h"
 
+#define MODULE_NAME "budget_ci"
+
 /*
  * Regarding DEBIADDR_IR:
  * Some CI modules hang if random addresses are read.
@@ -254,7 +256,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
 	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
 	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
-	error = ir_input_register(input_dev, ir_codes, NULL);
+	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
 		return error;
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index b320dbd..6c11687 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -48,6 +48,8 @@ module_param(ir_rc5_key_timeout, int, 0644);
 
 #define DEVNAME "bttv-input"
 
+#define MODULE_NAME "bttv"
+
 /* ---------------------------------------------------------------------- */
 
 static void ir_handle_key(struct bttv *btv)
@@ -389,7 +391,7 @@ int bttv_input_init(struct bttv *btv)
 	bttv_ir_start(btv, ir);
 
 	/* all done */
-	err = ir_input_register(btv->remote->dev, ir_codes, NULL);
+	err = ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index c5771db..1cbfba1 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -34,6 +34,8 @@ static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
+#define MODULE_NAME "cx231xx"
+
 #define i2cdprintk(fmt, arg...) \
 	if (ir_debug) { \
 		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
@@ -216,7 +218,8 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	cx231xx_ir_start(ir);
 
 	/* all done */
-	err = ir_input_register(ir->input, dev->board.ir_codes, NULL);
+	err = ir_input_register(ir->input, dev->board.ir_codes,
+				NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 9c6620f..2e6c023 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -50,6 +50,8 @@
 
 #define RC5_EXTENDED_COMMAND_OFFSET	64
 
+#define MODULE_NAME "cx23885"
+
 static inline unsigned int rc5_command(u32 rc5_baseband)
 {
 	return RC5_INSTR(rc5_baseband) +
@@ -397,7 +399,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	dev->ir_input = ir;
 	cx23885_input_ir_start(dev);
 
-	ret = ir_input_register(ir->dev, ir_codes, NULL);
+	ret = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
 	if (ret)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index de180d4..8f1b846 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -31,6 +31,8 @@
 #include "cx88.h"
 #include <media/ir-common.h>
 
+#define MODULE_NAME "cx88xx"
+
 /* ---------------------------------------------------------------------- */
 
 struct cx88_IR {
@@ -383,7 +385,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	cx88_ir_start(core, ir);
 
 	/* all done */
-	err = ir_input_register(ir->input, ir_codes, NULL);
+	err = ir_input_register(ir->input, ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 1fb754e..5a1850a 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -38,6 +38,8 @@ static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
+#define MODULE_NAME "em28xx"
+
 #define i2cdprintk(fmt, arg...) \
 	if (ir_debug) { \
 		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
@@ -473,7 +475,7 @@ int em28xx_ir_init(struct em28xx *dev)
 
 	/* all done */
 	err = ir_input_register(ir->input, dev->board.ir_codes,
-				&ir->props);
+				&ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index da18d69..6af69d5 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -61,9 +61,9 @@ module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
 MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey (defaults to 0)");
 
 
-#define DEVNAME "ir-kbd-i2c"
+#define MODULE_NAME "ir-kbd-i2c"
 #define dprintk(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG DEVNAME ": " fmt , ## arg)
+	printk(KERN_DEBUG MODULE_NAME ": " fmt , ## arg)
 
 /* ----------------------------------------------------------------------- */
 
@@ -447,11 +447,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
-	err = ir_input_register(ir->input, ir->ir_codes, NULL);
+	err = ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
-	printk(DEVNAME ": %s detected at %s [%s]\n",
+	printk(MODULE_NAME ": %s detected at %s [%s]\n",
 	       ir->input->name, ir->input->phys, adap->name);
 
 	/* start polling via eventd */
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index f884b33..076be22 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -27,6 +27,8 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 
+#define MODULE_NAME "saa7134"
+
 static unsigned int disable_ir;
 module_param(disable_ir, int, 0444);
 MODULE_PARM_DESC(disable_ir,"disable infrared remote support");
@@ -729,7 +731,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	dev->remote = ir;
 	saa7134_ir_start(dev, ir);
 
-	err = ir_input_register(ir->dev, ir_codes, NULL);
+	err = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 9ab8a77..1eae72d 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -49,6 +49,7 @@ struct ir_dev_props {
 
 struct ir_input_dev {
 	struct device			dev;		/* device */
+	char				*driver_name;	/* Name of the driver module */
 	struct ir_scancode_table	rc_tab;		/* scan/key table */
 	unsigned long			devno;		/* device number */
 	const struct ir_dev_props	*props;		/* Device properties */
@@ -62,7 +63,8 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev,
 
 int ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
-		      const struct ir_dev_props *props);
+		      const struct ir_dev_props *props,
+		      const char *driver_name);
 void ir_input_unregister(struct input_dev *input_dev);
 
 /* Routines from ir-sysfs.c */
-- 
1.6.6.1

