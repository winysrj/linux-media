Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447Ab0DFSSq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:46 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIjWj002346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:45 -0400
Date: Tue, 6 Apr 2010 15:18:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/26] V4L/DVB: ir: prepare IR code for a parameter change
 at register function
Message-ID: <20100406151803.48b7ac96@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A latter patch will reuse the ir_input_register with a different meaning.
Before it, change all occurrences to a temporary name.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index db54562..1d9c467 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -460,7 +460,7 @@ static void ir_close(struct input_dev *input_dev)
 }
 
 /**
- * ir_input_register() - sets the IR keycode table and add the handlers
+ * __ir_input_register() - sets the IR keycode table and add the handlers
  *			    for keymap table get/set
  * @input_dev:	the struct input_dev descriptor of the device
  * @rc_tab:	the struct ir_scancode_table table of scancode/keymap
@@ -470,7 +470,7 @@ static void ir_close(struct input_dev *input_dev)
  * It will register the input/evdev interface for the device and
  * register the syfs code for IR class
  */
-int ir_input_register(struct input_dev *input_dev,
+int __ir_input_register(struct input_dev *input_dev,
 		      const struct ir_scancode_table *rc_tab,
 		      const struct ir_dev_props *props,
 		      const char *driver_name)
@@ -538,7 +538,7 @@ err:
 	kfree(ir_dev);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ir_input_register);
+EXPORT_SYMBOL_GPL(__ir_input_register);
 
 /**
  * ir_input_unregister() - unregisters IR and frees resources
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 17003ed..3a67f30 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -629,7 +629,7 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
-	err = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	err = __ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 
 	return err;
 }
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index 6baf302..3d4e466 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -128,7 +128,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 	rc->id.version	= 1;
 	rc->dev		= mantis->pdev->dev;
 
-	err = ir_input_register(rc, &ir_mantis, NULL, MODULE_NAME);
+	err = __ir_input_register(rc, &ir_mantis, NULL, MODULE_NAME);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret = %d", err);
 		input_free_device(rc);
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 75c640e..ab7479a 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -256,7 +256,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
 	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
 	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
-	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	error = __ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
 		return error;
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index d5d26e6..eae4925 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -391,7 +391,7 @@ int bttv_input_init(struct bttv *btv)
 	bttv_ir_start(btv, ir);
 
 	/* all done */
-	err = ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
+	err = __ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 1cbfba1..dbd6218 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -218,7 +218,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	cx231xx_ir_start(ir);
 
 	/* all done */
-	err = ir_input_register(ir->input, dev->board.ir_codes,
+	err = __ir_input_register(ir->input, dev->board.ir_codes,
 				NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index c7e854d..5767d3e 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -399,7 +399,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	dev->ir_input = ir;
 	cx23885_input_ir_start(dev);
 
-	ret = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
+	ret = __ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
 	if (ret)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index b73b9e3..638e599 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -438,7 +438,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	ir->props.close = cx88_ir_close;
 
 	/* all done */
-	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
+	err = __ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 5a1850a..c237c72 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -474,7 +474,7 @@ int em28xx_ir_init(struct em28xx *dev)
 	em28xx_ir_start(ir);
 
 	/* all done */
-	err = ir_input_register(ir->input, dev->board.ir_codes,
+	err = __ir_input_register(ir->input, dev->board.ir_codes,
 				&ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 607a0be..e6ada5e 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -447,7 +447,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
-	err = ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
+	err = __ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index aac29a0..2a3cae9 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -877,7 +877,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 	input_dev->dev.parent = &dev->pci->dev;
 
-	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
+	err = __ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 	if (ir_codes->ir_type != IR_TYPE_OTHER) {
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 39df3cf..8e975f2 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -119,23 +119,37 @@ EXPORT_SYMBOL_GPL(IR_KEYTABLE(tabname))
 #define DEFINE_LEGACY_IR_KEYTABLE(tabname)			\
 	DEFINE_IR_KEYTABLE(tabname, IR_TYPE_UNKNOWN)
 
+/* Routines from rc-map.c */
+
+int ir_register_map(struct rc_keymap *map);
+void ir_unregister_map(struct rc_keymap *map);
+struct ir_scancode_table *get_rc_map(const char *name);
+
 /* Routines from ir-keytable.c */
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
 			    u32 scancode);
 void ir_keyup(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode);
-int ir_input_register(struct input_dev *dev,
+int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,
 		      const char *driver_name);
-void ir_input_unregister(struct input_dev *input_dev);
 
-/* Routines from rc-map.c */
+static inline int ir_input_register(struct input_dev *dev,
+		      const char *map_name,
+		      const struct ir_dev_props *props,
+		      const char *driver_name) {
+	struct ir_scancode_table *ir_codes;
 
-int ir_register_map(struct rc_keymap *map);
-void ir_unregister_map(struct rc_keymap *map);
-struct ir_scancode_table *get_rc_map(const char *name);
+	ir_codes = get_rc_map(map_name);
+	if (!ir_codes)
+		return -EINVAL;
+
+	return __ir_input_register(dev, ir_codes, props, driver_name);
+}
+
+		      void ir_input_unregister(struct input_dev *input_dev);
 
 /* Routines from ir-sysfs.c */
 
-- 
1.6.6.1


