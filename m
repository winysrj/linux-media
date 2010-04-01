Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758695Ab0DAR6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:21 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/15] V4L/DVB: saa7134: add code to allow changing IR
 protocol
Message-ID: <20100401145632.20550888@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index d7e73de..8187928 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -420,6 +420,10 @@ static void saa7134_input_timer(unsigned long data)
 
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 {
+	if (ir->running)
+		return;
+
+	ir->running = 1;
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
 			    (unsigned long)dev);
@@ -447,8 +451,50 @@ void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 
 void saa7134_ir_stop(struct saa7134_dev *dev)
 {
+	struct card_ir *ir = dev->remote;
+
+	if (!ir->running)
+		return;
 	if (dev->remote->polling)
 		del_timer_sync(&dev->remote->timer);
+	else if (ir->rc5_gpio)
+		del_timer_sync(&ir->timer_end);
+	else if (ir->nec_gpio)
+		tasklet_kill(&ir->tlet);
+	ir->running = 0;
+}
+
+int saa7134_ir_change_protocol(void *priv, u64 ir_type)
+{
+	struct saa7134_dev *dev = priv;
+	struct card_ir *ir = dev->remote;
+	u32 nec_gpio, rc5_gpio;
+
+	if (ir_type == IR_TYPE_RC5) {
+		dprintk("Changing protocol to RC5\n");
+		nec_gpio = 0;
+		rc5_gpio = 1;
+	} else if (ir_type == IR_TYPE_NEC) {
+		dprintk("Changing protocol to NEC\n");
+		nec_gpio = 1;
+		rc5_gpio = 0;
+	} else {
+		dprintk("IR protocol type %ud is not supported\n",
+			(unsigned)ir_type);
+		return -EINVAL;
+	}
+
+	if (ir->running) {
+		saa7134_ir_stop(dev);
+		ir->nec_gpio = nec_gpio;
+		ir->rc5_gpio = rc5_gpio;
+		saa7134_ir_start(dev, ir);
+	} else {
+		ir->nec_gpio = nec_gpio;
+		ir->rc5_gpio = rc5_gpio;
+	}
+
+	return 0;
 }
 
 int saa7134_input_init1(struct saa7134_dev *dev)
@@ -697,6 +743,9 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 
 	ir->dev = input_dev;
+	dev->remote = ir;
+
+	ir->running = 0;
 
 	/* init hardware-specific stuff */
 	ir->mask_keycode = mask_keycode;
@@ -712,6 +761,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
+	if (ir_codes->ir_type != IR_TYPE_OTHER) {
+		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+		ir->props.priv = dev;
+		ir->props.change_protocol = saa7134_ir_change_protocol;
+
+		/* Set IR protocol */
+		saa7134_ir_change_protocol(ir->props.priv, ir_codes->ir_type);
+	}
 	err = ir_input_init(input_dev, &ir->ir, ir_type);
 	if (err < 0)
 		goto err_out_free;
@@ -729,13 +786,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 	input_dev->dev.parent = &dev->pci->dev;
 
-	dev->remote = ir;
-	saa7134_ir_start(dev, ir);
-
-	err = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
+	saa7134_ir_start(dev, ir);
+
 	/* the remote isn't as bouncy as a keyboard */
 	ir->dev->rep[REP_DELAY] = repeat_delay;
 	ir->dev->rep[REP_PERIOD] = repeat_period;
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index c30b283..41469b7 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -51,6 +51,9 @@ struct card_ir {
 	char                    name[32];
 	char                    phys[32];
 
+	u32			running:1;
+	struct ir_dev_props	props;
+
 	/* Usual gpio signalling */
 
 	u32                     mask_keycode;
-- 
1.6.6.1


