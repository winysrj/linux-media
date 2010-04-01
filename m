Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679Ab0DAR6S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:18 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/15] V4L/DVB: ir-core: Add callbacks for input/evdev
 open/close on IR core
Message-ID: <20100401145631.2a227fe7@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Especially when IR needs to do polling, it generates lots of wakeups per
second. This makes no sense, if the input event device is closed.

Adds a callback handler to the IR hardware driver, to allow registering
an open/close ops.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index f25193c..db54562 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -445,6 +445,19 @@ void ir_keydown(struct input_dev *dev, int scancode)
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
+static int ir_open(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	return ir_dev->props->open(ir_dev->props->priv);
+}
+
+static void ir_close(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	ir_dev->props->close(ir_dev->props->priv);
+}
 
 /**
  * ir_input_register() - sets the IR keycode table and add the handlers
@@ -494,6 +507,10 @@ int ir_input_register(struct input_dev *input_dev,
 
 	ir_copy_table(&ir_dev->rc_tab, rc_tab);
 	ir_dev->props = props;
+	if (props && props->open)
+		input_dev->open = ir_open;
+	if (props && props->close)
+		input_dev->close = ir_close;
 
 	/* set the bits for the keys */
 	IR_dprintk(1, "key map size: %d\n", rc_tab->size);
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index a7ad781..68cda10 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -1227,7 +1227,7 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 	if (card_has_mpeg(dev))
 		saa7134_ts_init_hw(dev);
 	if (dev->remote)
-		saa7134_ir_start(dev, dev->remote);
+		saa7134_ir_start(dev);
 	saa7134_hw_enable1(dev);
 
 	msleep(100);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index a42c953..9e2b32c 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -399,7 +399,14 @@ static int get_key_pinnacle_color(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 
 void saa7134_input_irq(struct saa7134_dev *dev)
 {
-	struct card_ir *ir = dev->remote;
+	struct card_ir *ir;
+
+	if (!dev || !dev->remote)
+		return;
+
+	ir = dev->remote;
+	if (!ir->running)
+		return;
 
 	if (ir->nec_gpio) {
 		saa7134_nec_irq(dev);
@@ -431,10 +438,20 @@ void ir_raw_decode_timer_end(unsigned long data)
 	ir->active = 0;
 }
 
-void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
+static int __saa7134_ir_start(void *priv)
 {
+	struct saa7134_dev *dev = priv;
+	struct card_ir *ir;
+
+	if (!dev)
+		return -EINVAL;
+
+	ir  = dev->remote;
+	if (!ir)
+		return -EINVAL;
+
 	if (ir->running)
-		return;
+		return 0;
 
 	ir->running = 1;
 	if (ir->polling) {
@@ -466,11 +483,21 @@ void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 		ir->timer_end.data = (unsigned long)dev;
 		ir->active = 0;
 	}
+
+	return 0;
 }
 
-void saa7134_ir_stop(struct saa7134_dev *dev)
+static void __saa7134_ir_stop(void *priv)
 {
-	struct card_ir *ir = dev->remote;
+	struct saa7134_dev *dev = priv;
+	struct card_ir *ir;
+
+	if (!dev)
+		return;
+
+	ir  = dev->remote;
+	if (!ir)
+		return;
 
 	if (!ir->running)
 		return;
@@ -486,8 +513,42 @@ void saa7134_ir_stop(struct saa7134_dev *dev)
 	}
 
 	ir->running = 0;
+
+	return;
 }
 
+int saa7134_ir_start(struct saa7134_dev *dev)
+{
+	if (dev->remote->users)
+		return __saa7134_ir_start(dev);
+
+	return 0;
+}
+
+void saa7134_ir_stop(struct saa7134_dev *dev)
+{
+	if (dev->remote->users)
+		__saa7134_ir_stop(dev);
+}
+
+static int saa7134_ir_open(void *priv)
+{
+	struct saa7134_dev *dev = priv;
+
+	dev->remote->users++;
+	return __saa7134_ir_start(dev);
+}
+
+static void saa7134_ir_close(void *priv)
+{
+	struct saa7134_dev *dev = priv;
+
+	dev->remote->users--;
+	if (!dev->remote->users)
+		__saa7134_ir_stop(dev);
+}
+
+
 int saa7134_ir_change_protocol(void *priv, u64 ir_type)
 {
 	struct saa7134_dev *dev = priv;
@@ -512,7 +573,7 @@ int saa7134_ir_change_protocol(void *priv, u64 ir_type)
 		saa7134_ir_stop(dev);
 		ir->nec_gpio = nec_gpio;
 		ir->rc5_gpio = rc5_gpio;
-		saa7134_ir_start(dev, ir);
+		saa7134_ir_start(dev);
 	} else {
 		ir->nec_gpio = nec_gpio;
 		ir->rc5_gpio = rc5_gpio;
@@ -787,9 +848,13 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
+
+	ir->props.priv = dev;
+	ir->props.open = saa7134_ir_open;
+	ir->props.close = saa7134_ir_close;
+
 	if (ir_codes->ir_type != IR_TYPE_OTHER && !raw_decode) {
 		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
-		ir->props.priv = dev;
 		ir->props.change_protocol = saa7134_ir_change_protocol;
 
 		/* Set IR protocol */
@@ -814,25 +879,21 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 
 	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
-		goto err_out_stop;
+		goto err_out_free;
 	if (ir_codes->ir_type != IR_TYPE_OTHER) {
 		err = ir_raw_event_register(ir->dev);
 		if (err)
-			goto err_out_stop;
+			goto err_out_free;
 	}
 
-	saa7134_ir_start(dev, ir);
-
 	/* the remote isn't as bouncy as a keyboard */
 	ir->dev->rep[REP_DELAY] = repeat_delay;
 	ir->dev->rep[REP_PERIOD] = repeat_period;
 
 	return 0;
 
- err_out_stop:
-	saa7134_ir_stop(dev);
+err_out_free:
 	dev->remote = NULL;
- err_out_free:
 	kfree(ir);
 	return err;
 }
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index c3a1ae0..cad8aee 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -20,7 +20,7 @@
  */
 
 #include <linux/version.h>
-#define SAA7134_VERSION_CODE KERNEL_VERSION(0,2,15)
+#define SAA7134_VERSION_CODE KERNEL_VERSION(0, 2, 16)
 
 #include <linux/pci.h>
 #include <linux/i2c.h>
@@ -810,7 +810,7 @@ int  saa7134_input_init1(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
-void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir);
+int saa7134_ir_start(struct saa7134_dev *dev);
 void saa7134_ir_stop(struct saa7134_dev *dev);
 
 
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 87f2ec7..e403a9a 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -50,6 +50,7 @@ struct card_ir {
 	struct ir_input_state   ir;
 	char                    name[32];
 	char                    phys[32];
+	int			users;
 
 	u32			running:1;
 	struct ir_dev_props	props;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index c704fa7..9a2f308 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -56,6 +56,8 @@ struct ir_dev_props {
 	unsigned long allowed_protos;
 	void 		*priv;
 	int (*change_protocol)(void *priv, u64 ir_type);
+	int (*open)(void *priv);
+	void (*close)(void *priv);
 };
 
 struct ir_raw_event {
-- 
1.6.6.1


