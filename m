Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:50477 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397Ab0HXXCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:19 -0400
Subject: [PATCH 3/3] make rc_dev the primary interface for remote control
	drivers
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org
Date: Wed, 25 Aug 2010 01:02:12 +0200
Message-ID: <20100824230212.13006.11379.stgit@localhost.localdomain>
In-Reply-To: <20100824225427.13006.57226.stgit@localhost.localdomain>
References: <20100824225427.13006.57226.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch merges the ir_input_dev and ir_dev_props structs into a single
struct called rc_dev. The drivers and various functions in rc-core used
by the drivers are also changed to use rc_dev as the primary interface
when dealing with rc-core.

This means that the input_dev is abstracted away from the drivers which
is necessary if we ever want to support multiple input devs per rc device.

The new API is similar to what the input subsystem uses, i.e:
rc_device_alloc()
rc_device_free()
rc_device_register()
rc_device_unregister()

Note that this patch (in its current state) has not been tested and
will break the imon driver since it hasn't been converted yet.
---
 drivers/media/IR/ir-core-priv.h             |   10 
 drivers/media/IR/ir-jvc-decoder.c           |   13 -
 drivers/media/IR/ir-lirc-codec.c            |   75 +--
 drivers/media/IR/ir-nec-decoder.c           |   13 -
 drivers/media/IR/ir-rc5-decoder.c           |   13 -
 drivers/media/IR/ir-rc6-decoder.c           |   17 -
 drivers/media/IR/ir-sony-decoder.c          |   11 
 drivers/media/IR/mceusb.c                   |   99 ++--
 drivers/media/IR/rc-core.c                  |  630 ++++++++++++---------------
 drivers/media/dvb/dm1105/dm1105.c           |   45 +-
 drivers/media/dvb/mantis/mantis_common.h    |    4 
 drivers/media/dvb/mantis/mantis_input.c     |   61 +--
 drivers/media/dvb/ttpci/budget-ci.c         |   49 +-
 drivers/media/video/bt8xx/bttv-input.c      |   41 +-
 drivers/media/video/cx23885/cx23885-input.c |   34 +
 drivers/media/video/cx88/cx88-input.c       |   78 ++-
 drivers/media/video/em28xx/em28xx-input.c   |   71 +--
 drivers/media/video/ir-kbd-i2c.c            |   27 +
 drivers/media/video/saa7134/saa7134-input.c |   71 +--
 include/media/ir-common.h                   |    3 
 include/media/ir-core.h                     |  154 +++----
 include/media/ir-kbd-i2c.h                  |    2 
 22 files changed, 699 insertions(+), 822 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 64a90b4..c3bff41 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -23,11 +23,11 @@ struct ir_raw_handler {
 	struct list_head list;
 
 	u64 protocols; /* which are handled by this handler */
-	int (*decode)(struct input_dev *input_dev, struct ir_raw_event event);
+	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
 
 	/* These two should only be used by the lirc decoder */
-	int (*raw_register)(struct input_dev *input_dev);
-	int (*raw_unregister)(struct input_dev *input_dev);
+	int (*raw_register)(struct rc_dev *dev);
+	int (*raw_unregister)(struct rc_dev *dev);
 };
 
 struct ir_raw_event_ctrl {
@@ -36,7 +36,7 @@ struct ir_raw_event_ctrl {
 	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
-	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
+	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
 	u64				enabled_protocols; /* enabled raw protocol decoders */
 
 	/* raw decoder state follows */
@@ -74,7 +74,7 @@ struct ir_raw_event_ctrl {
 		bool toggle;
 	} jvc;
 	struct lirc_codec {
-		struct ir_input_dev *ir_dev;
+		struct rc_dev *dev;
 		struct lirc_driver *drv;
 		int lircdata;
 	} lirc;
diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
index 8894d8b..c7256f0 100644
--- a/drivers/media/IR/ir-jvc-decoder.c
+++ b/drivers/media/IR/ir-jvc-decoder.c
@@ -36,17 +36,16 @@ enum jvc_state {
 
 /**
  * ir_jvc_decode() - Decode one JVC pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @duration:   the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct jvc_dec *data = &ir_dev->raw->jvc;
+	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_JVC))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_JVC))
 		return 0;
 
 	if (IS_RESET(ev)) {
@@ -137,12 +136,12 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
 			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
-			ir_keydown(input_dev, scancode, data->toggle);
+			ir_keydown(dev, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
 			IR_dprintk(1, "JVC repeat\n");
-			ir_repeat(input_dev);
+			ir_repeat(dev);
 		} else {
 			IR_dprintk(1, "JVC invalid repeat msg\n");
 			break;
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index aff31d1..408d1e6 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -24,33 +24,31 @@
 /**
  * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
  *		      lircd userspace daemon for decoding.
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @duration:	the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the lirc interfaces aren't wired up.
  */
-static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_LIRC))
 		return 0;
 
-	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
+	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
 	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
 		   TO_US(ev.duration), TO_STR(ev.pulse));
 
-	ir_dev->raw->lirc.lircdata += ev.duration / 1000;
+	dev->raw->lirc.lircdata += ev.duration / 1000;
 	if (ev.pulse)
-		ir_dev->raw->lirc.lircdata |= PULSE_BIT;
+		dev->raw->lirc.lircdata |= PULSE_BIT;
 
-	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
-			  (unsigned char *) &ir_dev->raw->lirc.lircdata);
-	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
+	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
+			  (unsigned char *) &dev->raw->lirc.lircdata);
+	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
 
-	ir_dev->raw->lirc.lircdata = 0;
+	dev->raw->lirc.lircdata = 0;
 
 	return 0;
 }
@@ -59,7 +57,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 				   size_t n, loff_t *ppos)
 {
 	struct lirc_codec *lirc;
-	struct ir_input_dev *ir_dev;
+	struct rc_dev *dev;
 	int *txbuf; /* buffer with values to transmit */
 	int ret = 0, count;
 
@@ -83,14 +81,14 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 		goto out;
 	}
 
-	ir_dev = lirc->ir_dev;
-	if (!ir_dev) {
+	dev = lirc->dev;
+	if (!dev) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	if (ir_dev->props && ir_dev->props->tx_ir)
-		ret = ir_dev->props->tx_ir(ir_dev->props->priv, txbuf, (u32)n);
+	if (dev->tx_ir)
+		ret = dev->tx_ir(dev, (const char *)txbuf, (u32)n);
 
 out:
 	kfree(txbuf);
@@ -101,29 +99,26 @@ static int ir_lirc_ioctl(struct inode *node, struct file *filep,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct lirc_codec *lirc;
-	struct ir_input_dev *ir_dev;
+	struct rc_dev *dev;
 	int ret = 0;
-	void *drv_data;
 	unsigned long val;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
 		return -EFAULT;
 
-	ir_dev = lirc->ir_dev;
-	if (!ir_dev || !ir_dev->props || !ir_dev->props->priv)
+	dev = lirc->dev;
+	if (!dev)
 		return -EFAULT;
 
-	drv_data = ir_dev->props->priv;
-
 	switch (cmd) {
 	case LIRC_SET_TRANSMITTER_MASK:
 		ret = get_user(val, (unsigned long *)arg);
 		if (ret)
 			return ret;
 
-		if (ir_dev->props && ir_dev->props->s_tx_mask)
-			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
+		if (dev->s_tx_mask)
+			ret = dev->s_tx_mask(dev, (u32)val);
 		else
 			return -EINVAL;
 		break;
@@ -133,8 +128,8 @@ static int ir_lirc_ioctl(struct inode *node, struct file *filep,
 		if (ret)
 			return ret;
 
-		if (ir_dev->props && ir_dev->props->s_tx_carrier)
-			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
+		if (dev->s_tx_carrier)
+			dev->s_tx_carrier(dev, (u32)val);
 		else
 			return -EINVAL;
 		break;
@@ -180,9 +175,8 @@ static struct file_operations lirc_fops = {
 	.release	= lirc_dev_fop_close,
 };
 
-static int ir_lirc_register(struct input_dev *input_dev)
+static int ir_lirc_register(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct lirc_driver *drv;
 	struct lirc_buffer *rbuf;
 	int rc = -ENOMEM;
@@ -201,25 +195,25 @@ static int ir_lirc_register(struct input_dev *input_dev)
 		goto rbuf_init_failed;
 
 	features = LIRC_CAN_REC_MODE2;
-	if (ir_dev->props->tx_ir) {
+	if (dev->tx_ir) {
 		features |= LIRC_CAN_SEND_PULSE;
-		if (ir_dev->props->s_tx_mask)
+		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
-		if (ir_dev->props->s_tx_carrier)
+		if (dev->s_tx_carrier)
 			features |= LIRC_CAN_SET_SEND_CARRIER;
 	}
 
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
-		 ir_dev->driver_name);
+		 dev->driver_name);
 	drv->minor = -1;
 	drv->features = features;
-	drv->data = &ir_dev->raw->lirc;
+	drv->data = &dev->raw->lirc;
 	drv->rbuf = rbuf;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->fops = &lirc_fops;
-	drv->dev = &ir_dev->dev;
+	drv->dev = &dev->dev;
 	drv->owner = THIS_MODULE;
 
 	drv->minor = lirc_register_driver(drv);
@@ -228,9 +222,9 @@ static int ir_lirc_register(struct input_dev *input_dev)
 		goto lirc_register_failed;
 	}
 
-	ir_dev->raw->lirc.drv = drv;
-	ir_dev->raw->lirc.ir_dev = ir_dev;
-	ir_dev->raw->lirc.lircdata = PULSE_MASK;
+	dev->raw->lirc.drv = drv;
+	dev->raw->lirc.dev = dev;
+	dev->raw->lirc.lircdata = PULSE_MASK;
 
 	return 0;
 
@@ -243,10 +237,9 @@ rbuf_alloc_failed:
 	return rc;
 }
 
-static int ir_lirc_unregister(struct input_dev *input_dev)
+static int ir_lirc_unregister(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct lirc_codec *lirc = &ir_dev->raw->lirc;
+	struct lirc_codec *lirc = &dev->raw->lirc;
 
 	lirc_unregister_driver(lirc->drv->minor);
 	lirc_buffer_free(lirc->drv->rbuf);
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 52e0f37..165992b 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -38,19 +38,18 @@ enum nec_state {
 
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @duration:	the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct nec_dec *data = &ir_dev->raw->nec;
+	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
 
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_NEC))
 		return 0;
 
 	if (IS_RESET(ev)) {
@@ -83,7 +82,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			ir_repeat(input_dev);
+			ir_repeat(dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
 			return 0;
@@ -159,7 +158,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
 		}
 
-		ir_keydown(input_dev, scancode, 0);
+		ir_keydown(dev, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index df4770d..b895fd6 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -40,19 +40,18 @@ enum rc5_state {
 
 /**
  * ir_rc5_decode() - Decode one RC-5 pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct rc5_dec *data = &ir_dev->raw->rc5;
+	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
 	u32 scancode;
 
-        if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5))
+        if (!(dev->raw->enabled_protocols & IR_TYPE_RC5))
                 return 0;
 
 	if (IS_RESET(ev)) {
@@ -95,7 +94,7 @@ again:
 		return 0;
 
 	case STATE_BIT_END:
-		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
+		if (!is_transition(&ev, &dev->raw->prev_ev))
 			break;
 
 		if (data->count == data->wanted_bits)
@@ -150,7 +149,7 @@ again:
 				   scancode, toggle);
 		}
 
-		ir_keydown(input_dev, scancode, toggle);
+		ir_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
index f1624b8..863837f 100644
--- a/drivers/media/IR/ir-rc6-decoder.c
+++ b/drivers/media/IR/ir-rc6-decoder.c
@@ -70,19 +70,18 @@ static enum rc6_mode rc6_mode(struct rc6_dec *data)
 
 /**
  * ir_rc6_decode() - Decode one RC6 pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct rc6_dec *data = &ir_dev->raw->rc6;
+	struct rc6_dec *data = &dev->raw->rc6;
 	u32 scancode;
 	u8 toggle;
 
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC6))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_RC6))
 		return 0;
 
 	if (IS_RESET(ev)) {
@@ -138,7 +137,7 @@ again:
 		return 0;
 
 	case STATE_HEADER_BIT_END:
-		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
+		if (!is_transition(&ev, &dev->raw->prev_ev))
 			break;
 
 		if (data->count == RC6_HEADER_NBITS)
@@ -158,7 +157,7 @@ again:
 		return 0;
 
 	case STATE_TOGGLE_END:
-		if (!is_transition(&ev, &ir_dev->raw->prev_ev) ||
+		if (!is_transition(&ev, &dev->raw->prev_ev) ||
 		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
 			break;
 
@@ -203,7 +202,7 @@ again:
 		return 0;
 
 	case STATE_BODY_BIT_END:
-		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
+		if (!is_transition(&ev, &dev->raw->prev_ev))
 			break;
 
 		if (data->count == data->wanted_bits)
@@ -242,7 +241,7 @@ again:
 			goto out;
 		}
 
-		ir_keydown(input_dev, scancode, toggle);
+		ir_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/IR/ir-sony-decoder.c
index b9074f0..421450f 100644
--- a/drivers/media/IR/ir-sony-decoder.c
+++ b/drivers/media/IR/ir-sony-decoder.c
@@ -33,19 +33,18 @@ enum sony_state {
 
 /**
  * ir_sony_decode() - Decode one Sony pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @ev:         the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_sony_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct sony_dec *data = &ir_dev->raw->sony;
+	struct sony_dec *data = &dev->raw->sony;
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_SONY))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_SONY))
 		return 0;
 
 	if (IS_RESET(ev)) {
@@ -143,7 +142,7 @@ static int ir_sony_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 
 		scancode = device << 16 | subdevice << 8 | function;
 		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
-		ir_keydown(input_dev, scancode, 0);
+		ir_keydown(dev, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index aaa40d8..edb9b8e 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -38,7 +38,6 @@
 #include <linux/usb.h>
 #include <linux/input.h>
 #include <media/ir-core.h>
-#include <media/ir-common.h>
 
 #define DRIVER_VERSION	"1.91"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
@@ -229,13 +228,11 @@ static struct usb_device_id std_tx_mask_list[] = {
 /* data structure for each usb transceiver */
 struct mceusb_dev {
 	/* ir-core bits */
-	struct ir_input_dev *irdev;
-	struct ir_dev_props *props;
+	struct rc_dev *rc;
 	struct ir_raw_event rawir;
 
 	/* core device bits */
 	struct device *dev;
-	struct input_dev *idev;
 
 	/* usb */
 	struct usb_device *usbdev;
@@ -516,9 +513,9 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 }
 
 /* Send data out the IR blaster port(s) */
-static int mceusb_tx_ir(void *priv, const char *buf, u32 n)
+static int mceusb_tx_ir(struct rc_dev *dev, const char *buf, u32 n)
 {
-	struct mceusb_dev *ir = priv;
+	struct mceusb_dev *ir = dev->priv;
 	int i, count = 0, cmdcount = 0;
 	int wbuf[IRBUF_SIZE]; /* Workbuffer with values to tx */
 	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
@@ -598,9 +595,9 @@ static int mceusb_tx_ir(void *priv, const char *buf, u32 n)
 }
 
 /* Sets active IR outputs -- mce devices typically (all?) have two */
-static int mceusb_set_tx_mask(void *priv, u32 mask)
+static int mceusb_set_tx_mask(struct rc_dev *dev, u32 mask)
 {
-	struct mceusb_dev *ir = priv;
+	struct mceusb_dev *ir = dev->priv;
 
 	if (ir->flags.tx_mask_inverted)
 		ir->tx_mask = (mask != 0x03 ? mask ^ 0x03 : mask) << 1;
@@ -611,9 +608,9 @@ static int mceusb_set_tx_mask(void *priv, u32 mask)
 }
 
 /* Sets the send carrier frequency and mode */
-static int mceusb_set_tx_carrier(void *priv, u32 carrier)
+static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 {
-	struct mceusb_dev *ir = priv;
+	struct mceusb_dev *ir = dev->priv;
 	int clk = 10000000;
 	int prescaler = 0, divisor = 0;
 	unsigned char cmdbuf[4] = { 0x9f, 0x06, 0x00, 0x00 };
@@ -705,14 +702,14 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
-			ir_raw_event_store(ir->idev, &rawir);
+			ir_raw_event_store(ir->rc, &rawir);
 		}
 
 		if (ir->buf_in[i] == 0x80 || ir->buf_in[i] == 0x9f)
 			ir->rem = 0;
 
 		dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
-		ir_raw_event_handle(ir->idev);
+		ir_raw_event_handle(ir->rc);
 	}
 }
 
@@ -737,7 +734,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
 		ir->send_flags = SEND_FLAG_COMPLETE;
-		dev_dbg(&ir->irdev->dev, "setup answer received %d bytes\n",
+		dev_dbg(ir->dev, "setup answer received %d bytes\n",
 			buf_len);
 	}
 
@@ -884,70 +881,46 @@ static void mceusb_gen3_init(struct mceusb_dev *ir)
 	mce_sync_in(ir, NULL, maxp);
 }
 
-static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
+static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 {
-	struct input_dev *idev;
-	struct ir_dev_props *props;
-	struct ir_input_dev *irdev;
 	struct device *dev = ir->dev;
-	int ret = -ENODEV;
+	struct rc_dev *rc;
+	int ret;
 
-	idev = input_allocate_device();
-	if (!idev) {
+	rc = rc_allocate_device();
+	if (!rc) {
 		dev_err(dev, "remote input dev allocation failed\n");
-		goto idev_alloc_failed;
-	}
-
-	ret = -ENOMEM;
-	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
-	if (!props) {
-		dev_err(dev, "remote ir dev props allocation failed\n");
-		goto props_alloc_failed;
-	}
-
-	irdev = kzalloc(sizeof(struct ir_input_dev), GFP_KERNEL);
-	if (!irdev) {
-		dev_err(dev, "remote ir input dev allocation failed\n");
-		goto ir_dev_alloc_failed;
+		goto out;
 	}
 
 	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
-
-	idev->name = ir->name;
 	usb_make_path(ir->usbdev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
-	idev->phys = ir->phys;
-
-	props->priv = ir;
-	props->driver_type = RC_DRIVER_IR_RAW;
-	props->allowed_protos = IR_TYPE_ALL;
-	props->s_tx_mask = mceusb_set_tx_mask;
-	props->s_tx_carrier = mceusb_set_tx_carrier;
-	props->tx_ir = mceusb_tx_ir;
-
-	ir->props = props;
-	ir->irdev = irdev;
-
-	input_set_drvdata(idev, irdev);
 
-	ret = ir_input_register(idev, RC_MAP_RC6_MCE, props, DRIVER_NAME);
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->priv = ir;
+	rc->driver_type = RC_DRIVER_IR_RAW;
+	rc->allowed_protos = IR_TYPE_ALL;
+	rc->s_tx_mask = mceusb_set_tx_mask;
+	rc->s_tx_carrier = mceusb_set_tx_carrier;
+	rc->tx_ir = mceusb_tx_ir;
+	rc->map_name = RC_MAP_RC6_MCE;
+	rc->driver_name = DRIVER_NAME;
+
+	ret = rc_register_device(rc);
 	if (ret < 0) {
 		dev_err(dev, "remote input device register failed\n");
-		goto irdev_failed;
+		goto out;
 	}
 
-	return idev;
+	return rc;
 
-irdev_failed:
-	kfree(irdev);
-ir_dev_alloc_failed:
-	kfree(props);
-props_alloc_failed:
-	input_free_device(idev);
-idev_alloc_failed:
+out:
+	rc_free_device(rc);
 	return NULL;
 }
 
@@ -1053,8 +1026,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	ir->idev = mceusb_init_input_dev(ir);
-	if (!ir->idev)
+	ir->rc = mceusb_init_rc_dev(ir);
+	if (!ir->rc)
 		goto input_dev_fail;
 
 	/* inbound data */
@@ -1075,7 +1048,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mce_sync_in(ir, NULL, maxp);
 
-	mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
+	mceusb_set_tx_mask(ir->rc, MCE_DEFAULT_TX_MASK);
 
 	usb_set_intfdata(intf, ir);
 
@@ -1109,7 +1082,7 @@ static void __devexit mceusb_dev_disconnect(struct usb_interface *intf)
 		return;
 
 	ir->usbdev = NULL;
-	ir_input_unregister(ir->idev);
+	rc_unregister_device(ir->rc);
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
diff --git a/drivers/media/IR/rc-core.c b/drivers/media/IR/rc-core.c
index 8699e15..acc9910 100644
--- a/drivers/media/IR/rc-core.c
+++ b/drivers/media/IR/rc-core.c
@@ -40,11 +40,6 @@ static u64 available_protocols;
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
 
-#define IRRCV_NUM_DEVICES 256
-
-/* bit array to represent IR sysfs device number */
-static unsigned long ir_core_dev_number;
-
 #ifdef MODULE
 /* Used to load the decoders */
 static struct work_struct wq_load;
@@ -54,10 +49,6 @@ static struct work_struct wq_load;
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
-/* Forward declarations */
-static int ir_register_class(struct input_dev *input_dev);
-static void ir_unregister_class(struct input_dev *input_dev);
-
 static struct rc_keymap *seek_rc_map(const char *name)
 {
 	struct rc_keymap *map = NULL;
@@ -130,7 +121,7 @@ static void ir_raw_event_work(struct work_struct *work)
 	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
 		spin_lock(&ir_raw_handler_lock);
 		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->input_dev, ev);
+			handler->decode(raw->dev, ev);
 		spin_unlock(&ir_raw_handler_lock);
 		raw->prev_ev = ev;
 	}
@@ -138,7 +129,7 @@ static void ir_raw_event_work(struct work_struct *work)
 
 /**
  * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This routine (which may be called from an interrupt context) stores a
@@ -146,14 +137,12 @@ static void ir_raw_event_work(struct work_struct *work)
  * signalled as positive values and spaces as negative values. A zero value
  * will reset the decoding state machines.
  */
-int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-
-	if (!ir->raw)
+	if (!dev->raw)
 		return -EINVAL;
 
-	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
 		return -ENOMEM;
 
 	return 0;
@@ -162,7 +151,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
 
 /**
  * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @type:	the type of the event that has occurred
  *
  * This routine (which may be called from an interrupt context) is used to
@@ -171,118 +160,111 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
  * hardware which does not provide durations directly but only interrupts
  * (or similar events) on state change.
  */
-int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type)
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 {
-	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
 	ktime_t			now;
 	s64			delta; /* ns */
 	struct ir_raw_event	ev;
 	int			rc = 0;
 
-	if (!ir->raw)
+	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
-	delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
+	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
 
 	/* Check for a long duration since last event or if we're
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
 	ev.duration = 0;
-	if (delta > IR_MAX_DURATION || !ir->raw->last_type)
+	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
 		ev.duration = delta;
 
 	if (type & IR_START_EVENT)
-		ir_raw_event_reset(input_dev);
-	else if (ir->raw->last_type & IR_SPACE) {
+		ir_raw_event_reset(dev);
+	else if (dev->raw->last_type & IR_SPACE) {
 		ev.pulse = false;
-		rc = ir_raw_event_store(input_dev, &ev);
-	} else if (ir->raw->last_type & IR_PULSE) {
+		rc = ir_raw_event_store(dev, &ev);
+	} else if (dev->raw->last_type & IR_PULSE) {
 		ev.pulse = true;
-		rc = ir_raw_event_store(input_dev, &ev);
+		rc = ir_raw_event_store(dev, &ev);
 	} else
 		return 0;
 
-	ir->raw->last_event = now;
-	ir->raw->last_type = type;
+	dev->raw->last_event = now;
+	dev->raw->last_type = type;
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
 
 /**
  * ir_raw_event_handle() - schedules the decoding of stored ir data
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  *
  * This routine will signal the workqueue to start decoding stored ir data.
  */
-void ir_raw_event_handle(struct input_dev *input_dev)
+void ir_raw_event_handle(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-
-	if (!ir->raw)
-		return;
-
-	schedule_work(&ir->raw->rx_work);
+	if (dev->raw)
+		schedule_work(&dev->raw->rx_work);
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
 /*
  * Used to (un)register raw event clients
  */
-static int ir_raw_event_register(struct input_dev *input_dev)
+static int ir_raw_event_register(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 	int rc;
 	struct ir_raw_handler *handler;
 
-	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
-	if (!ir->raw)
+	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
+	if (!dev->raw)
 		return -ENOMEM;
 
-	ir->raw->input_dev = input_dev;
-	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
-	ir->raw->enabled_protocols = ~0;
-	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
+	dev->raw->dev = dev;
+	INIT_WORK(&dev->raw->rx_work, ir_raw_event_work);
+	dev->raw->enabled_protocols = ~0;
+	rc = kfifo_alloc(&dev->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
 	if (rc < 0) {
-		kfree(ir->raw);
-		ir->raw = NULL;
+		kfree(dev->raw);
+		dev->raw = NULL;
 		return rc;
 	}
 
 	spin_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir->raw->list, &ir_raw_client_list);
+	list_add_tail(&dev->raw->list, &ir_raw_client_list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_register)
-			handler->raw_register(ir->raw->input_dev);
+			handler->raw_register(dev);
 	spin_unlock(&ir_raw_handler_lock);
 
 	return 0;
 }
 
-static void ir_raw_event_unregister(struct input_dev *input_dev)
+static void ir_raw_event_unregister(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 	struct ir_raw_handler *handler;
 
-	if (!ir->raw)
+	if (!dev->raw)
 		return;
 
-	cancel_work_sync(&ir->raw->rx_work);
+	cancel_work_sync(&dev->raw->rx_work);
 
 	spin_lock(&ir_raw_handler_lock);
-	list_del(&ir->raw->list);
+	list_del(&dev->raw->list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
-			handler->raw_unregister(ir->raw->input_dev);
+			handler->raw_unregister(dev);
 	spin_unlock(&ir_raw_handler_lock);
 
-	kfifo_free(&ir->raw->kfifo);
-	kfree(ir->raw);
-	ir->raw = NULL;
+	kfifo_free(&dev->raw->kfifo);
+	kfree(dev->raw);
+	dev->raw = NULL;
 }
 
 /*
@@ -297,7 +279,7 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->input_dev);
+			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
 	spin_unlock(&ir_raw_handler_lock);
 
@@ -313,7 +295,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	list_del(&ir_raw_handler->list);
 	if (ir_raw_handler->raw_unregister)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->input_dev);
+			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
 	spin_unlock(&ir_raw_handler_lock);
 }
@@ -395,7 +377,7 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 /**
  * ir_do_setkeycode() - internal function to set a keycode in the
  *			scancode->keycode table
- * @dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @rc_tab:	the struct ir_scancode_table to set the keycode in
  * @scancode:	the scancode for the ir command
  * @keycode:	the keycode for the ir command
@@ -405,14 +387,13 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
  * This routine is used internally to manipulate the scancode->keycode table.
  * The caller has to hold @rc_tab->lock.
  */
-static int ir_do_setkeycode(struct input_dev *dev,
+static int ir_do_setkeycode(struct rc_dev *dev,
 			    struct ir_scancode_table *rc_tab,
 			    unsigned scancode, unsigned keycode,
 			    bool resize)
 {
 	unsigned int i;
 	int old_keycode = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 
 	/*
 	 * Unfortunately, some hardware-based IR decoders don't provide
@@ -421,9 +402,8 @@ static int ir_do_setkeycode(struct input_dev *dev,
 	 * the provided IR with another one, it is needed to allow loading
 	 * IR tables from other remotes. So,
 	 */
-	if (ir_dev->props && ir_dev->props->scanmask) {
-		scancode &= ir_dev->props->scanmask;
-	}
+	if (dev->scanmask)
+		scancode &= dev->scanmask;
 
 	/* First check if we already have a mapping for this ir command */
 	for (i = 0; i < rc_tab->len; i++) {
@@ -464,16 +444,16 @@ static int ir_do_setkeycode(struct input_dev *dev,
 		rc_tab->scan[i].scancode = scancode;
 		rc_tab->scan[i].keycode = keycode;
 		rc_tab->len++;
-		set_bit(keycode, dev->keybit);
+		set_bit(keycode, dev->input_dev->keybit);
 	} else {
 		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
 			   i, scancode, keycode);
 		/* A previous mapping was updated... */
-		clear_bit(old_keycode, dev->keybit);
+		clear_bit(old_keycode, dev->input_dev->keybit);
 		/* ...but another scancode might use the same keycode */
 		for (i = 0; i < rc_tab->len; i++) {
 			if (rc_tab->scan[i].keycode == old_keycode) {
-				set_bit(old_keycode, dev->keybit);
+				set_bit(old_keycode, dev->input_dev->keybit);
 				break;
 			}
 		}
@@ -484,20 +464,20 @@ static int ir_do_setkeycode(struct input_dev *dev,
 
 /**
  * ir_setkeycode() - set a keycode in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
+ * @idev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
  * @keycode:	result
  * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
  *
  * This routine is used to handle evdev EVIOCSKEY ioctl.
  */
-static int ir_setkeycode(struct input_dev *dev,
+static int ir_setkeycode(struct input_dev *idev,
 			 unsigned int scancode, unsigned int keycode)
 {
 	int rc;
 	unsigned long flags;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct rc_dev *dev = input_get_drvdata(idev);
+	struct ir_scancode_table *rc_tab = &dev->rc_tab;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
 	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
@@ -507,19 +487,18 @@ static int ir_setkeycode(struct input_dev *dev,
 
 /**
  * ir_setkeytable() - sets several entries in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @to:		the struct ir_scancode_table to copy entries to
  * @from:	the struct ir_scancode_table to copy entries from
  * @return:	-EINVAL if all keycodes could not be inserted, otherwise zero.
  *
  * This routine is used to handle table initialization.
  */
-static int ir_setkeytable(struct input_dev *dev,
+static int ir_setkeytable(struct rc_dev *dev,
 			  struct ir_scancode_table *to,
 			  const struct ir_scancode_table *from)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct ir_scancode_table *rc_tab = &dev->rc_tab;
 	unsigned long flags;
 	unsigned int i;
 	int rc = 0;
@@ -537,21 +516,21 @@ static int ir_setkeytable(struct input_dev *dev,
 
 /**
  * ir_getkeycode() - get a keycode from the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
+ * @idev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
  * @keycode:	used to return the keycode, if found, or KEY_RESERVED
  * @return:	always returns zero.
  *
  * This routine is used to handle evdev EVIOCGKEY ioctl.
  */
-static int ir_getkeycode(struct input_dev *dev,
+static int ir_getkeycode(struct input_dev *idev,
 			 unsigned int scancode, unsigned int *keycode)
 {
 	int start, end, mid;
 	unsigned long flags;
 	int key = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct rc_dev *dev = input_get_drvdata(idev);
+	struct ir_scancode_table *rc_tab = &dev->rc_tab;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
 	start = 0;
@@ -579,7 +558,7 @@ static int ir_getkeycode(struct input_dev *dev,
 
 /**
  * ir_g_keycode_from_table() - gets the keycode that corresponds to a scancode
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode that we're seeking
  *
  * This routine is used by the input routines when a key is pressed at the
@@ -587,64 +566,64 @@ static int ir_getkeycode(struct input_dev *dev,
  * If the key is not found, it returns KEY_RESERVED. Otherwise, returns the
  * corresponding keycode from the table.
  */
-u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
+u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 {
 	int keycode;
 
-	ir_getkeycode(dev, scancode, &keycode);
+	ir_getkeycode(dev->input_dev, scancode, &keycode);
 	if (keycode != KEY_RESERVED)
 		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->name, scancode, keycode);
+			   dev->input_dev->name ? dev->input_dev->name : "unknown",
+			   scancode, keycode);
 	return keycode;
 }
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
 
 /**
  * ir_do_keyup() - internal function to signal the release of a keypress
- * @ir:		the struct ir_input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  *
  * This function is used internally to release a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keyup(struct ir_input_dev *ir)
+static void ir_do_keyup(struct rc_dev *dev)
 {
-	if (!ir->keypressed)
+	if (!dev->keypressed)
 		return;
 
-	IR_dprintk(1, "keyup key 0x%04x\n", ir->last_keycode);
-	input_report_key(ir->input_dev, ir->last_keycode, 0);
-	input_sync(ir->input_dev);
-	ir->keypressed = false;
+	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
+	input_report_key(dev->input_dev, dev->last_keycode, 0);
+	input_sync(dev->input_dev);
+	dev->keypressed = false;
 }
 
 /**
  * ir_keyup() - generates input event to signal the release of a keypress
- * @dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  *
  * This routine is used to signal that a key has been released on the
  * remote control.
  */
-void ir_keyup(struct input_dev *dev)
+void ir_keyup(struct rc_dev *dev)
 {
 	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
 
-	spin_lock_irqsave(&ir->keylock, flags);
-	ir_do_keyup(ir);
-	spin_unlock_irqrestore(&ir->keylock, flags);
+	spin_lock_irqsave(&dev->keylock, flags);
+	ir_do_keyup(dev);
+	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keyup);
 
 /**
  * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:     a pointer to struct ir_input_dev passed to setup_timer()
+ * @cookie:     a pointer to struct rc_dev passed to setup_timer()
  *
  * This routine will generate a keyup event some time after a keydown event
  * is generated when no further activity has been detected.
  */
 static void ir_timer_keyup(unsigned long cookie)
 {
-	struct ir_input_dev *ir = (struct ir_input_dev *)cookie;
+	struct rc_dev *dev = (struct rc_dev *)cookie;
 	unsigned long flags;
 
 	/*
@@ -657,41 +636,40 @@ static void ir_timer_keyup(unsigned long cookie)
 	 * to allow the input subsystem to do its auto-repeat magic or
 	 * a keyup event might follow immediately after the keydown.
 	 */
-	spin_lock_irqsave(&ir->keylock, flags);
-	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
-		ir_do_keyup(ir);
-	spin_unlock_irqrestore(&ir->keylock, flags);
+	spin_lock_irqsave(&dev->keylock, flags);
+	if (time_is_after_eq_jiffies(dev->keyup_jiffies))
+		ir_do_keyup(dev);
+	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 
 /**
  * ir_repeat() - notifies the IR core that a key is still pressed
- * @dev:        the struct input_dev descriptor of the device
+ * @dev:        the struct rc_dev descriptor of the device
  *
  * This routine is used by IR decoders when a repeat message which does
  * not include the necessary bits to reproduce the scancode has been
  * received.
  */
-void ir_repeat(struct input_dev *dev)
+void ir_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
 
-	spin_lock_irqsave(&ir->keylock, flags);
+	spin_lock_irqsave(&dev->keylock, flags);
 
-	if (!ir->keypressed)
+	if (!dev->keypressed)
 		goto out;
 
-	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 
 out:
-	spin_unlock_irqrestore(&ir->keylock, flags);
+	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_repeat);
 
 /**
  * ir_do_keydown() - internal function to process a keypress
- * @dev:       the struct input_dev descriptor of the device
+ * @dev:       the struct rc_dev descriptor of the device
  * @scancode:  the scancode of the keypress
  * @keycode:   the keycode of the keypress
  * @toggle:    the toggle value of the keypress
@@ -699,38 +677,37 @@ EXPORT_SYMBOL_GPL(ir_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct input_dev *dev, int scancode,
+static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
 	/* Repeat event? */
-	if (ir->keypressed &&
-	    ir->last_scancode == scancode &&
-	    ir->last_toggle == toggle)
+	if (dev->keypressed &&
+	    dev->last_scancode == scancode &&
+	    dev->last_toggle == toggle)
 		return;
 
 	/* Release old keypress */
-	ir_do_keyup(ir);
+	ir_do_keyup(dev);
 
-	ir->last_scancode = scancode;
-	ir->last_toggle = toggle;
-	ir->last_keycode = keycode;
+	dev->last_scancode = scancode;
+	dev->last_toggle = toggle;
+	dev->last_keycode = keycode;
 
 	if (keycode == KEY_RESERVED)
 		return;
 
 	/* Register a keypress */
-	ir->keypressed = true;
+	dev->keypressed = true;
 	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		   dev->name, keycode, scancode);
-	input_report_key(dev, ir->last_keycode, 1);
-	input_sync(dev);
+		   dev->input_dev->name ? dev->input_dev->name : "unknown",
+		   keycode, scancode);
+	input_report_key(dev->input_dev, dev->last_keycode, 1);
+	input_sync(dev->input_dev);
 }
 
 /**
  * ir_keydown() - generates input event for a key press
- * @dev:        the struct input_dev descriptor of the device
+ * @dev:        the struct rc_dev descriptor of the device
  * @scancode:   the scancode that we're seeking
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
@@ -739,28 +716,27 @@ static void ir_do_keydown(struct input_dev *dev, int scancode,
  * IR. It gets the keycode for a scancode and reports an input event via
  * input_report_key().
  */
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
+void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle)
 {
 	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
 	u32 keycode = ir_g_keycode_from_table(dev, scancode);
 
-	spin_lock_irqsave(&ir->keylock, flags);
+	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, scancode, keycode, toggle);
 
-	if (ir->keypressed) {
-		ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-		mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+	if (dev->keypressed) {
+		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 
-	spin_unlock_irqrestore(&ir->keylock, flags);
+	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
 /**
  * ir_keydown_notimeout() - generates input event for a key press without
  *                          an automatic keyup event at a later time
- * @dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode that we're seeking
  * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
  *		support toggle values, this should be set to zero)
@@ -770,160 +746,30 @@ EXPORT_SYMBOL_GPL(ir_keydown);
  * input_report_key(). The driver must manually call ir_keyup() at a later
  * stage.
  */
-void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle)
+void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
 {
 	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
 	u32 keycode = ir_g_keycode_from_table(dev, scancode);
 
-	spin_lock_irqsave(&ir->keylock, flags);
+	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, scancode, keycode, toggle);
-	spin_unlock_irqrestore(&ir->keylock, flags);
+	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown_notimeout);
 
 static int ir_open(struct input_dev *input_dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct rc_dev *dev = input_get_drvdata(input_dev);
 
-	return ir_dev->props->open(ir_dev->props->priv);
+	return dev->open(dev);
 }
 
 static void ir_close(struct input_dev *input_dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	ir_dev->props->close(ir_dev->props->priv);
-}
-
-/**
- * __ir_input_register() - sets the IR keycode table and add the handlers
- *			    for keymap table get/set
- * @input_dev:	the struct input_dev descriptor of the device
- * @rc_tab:	the struct ir_scancode_table table of scancode/keymap
- *
- * This routine is used to initialize the input infrastructure
- * to work with an IR.
- * It will register the input/evdev interface for the device and
- * register the syfs code for IR class
- */
-int __ir_input_register(struct input_dev *input_dev,
-		      const struct ir_scancode_table *rc_tab,
-		      const struct ir_dev_props *props,
-		      const char *driver_name)
-{
-	struct ir_input_dev *ir_dev;
-	int rc;
-
-	if (rc_tab->scan == NULL || !rc_tab->size)
-		return -EINVAL;
-
-	ir_dev = kzalloc(sizeof(*ir_dev), GFP_KERNEL);
-	if (!ir_dev)
-		return -ENOMEM;
-
-	ir_dev->driver_name = kasprintf(GFP_KERNEL, "%s", driver_name);
-	if (!ir_dev->driver_name) {
-		rc = -ENOMEM;
-		goto out_dev;
-	}
-
-	input_dev->getkeycode = ir_getkeycode;
-	input_dev->setkeycode = ir_setkeycode;
-	input_set_drvdata(input_dev, ir_dev);
-	ir_dev->input_dev = input_dev;
-
-	spin_lock_init(&ir_dev->rc_tab.lock);
-	spin_lock_init(&ir_dev->keylock);
-	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
-
-	ir_dev->rc_tab.name = rc_tab->name;
-	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
-	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
-						  sizeof(struct ir_scancode));
-	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
-	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
-	if (props) {
-		ir_dev->props = props;
-		if (props->open)
-			input_dev->open = ir_open;
-		if (props->close)
-			input_dev->close = ir_close;
-	}
-
-	if (!ir_dev->rc_tab.scan) {
-		rc = -ENOMEM;
-		goto out_name;
-	}
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
-
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(EV_REP, input_dev->evbit);
-
-	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
-		rc = -ENOMEM;
-		goto out_table;
-	}
-
-	rc = ir_register_class(input_dev);
-	if (rc < 0)
-		goto out_table;
-
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
-		rc = ir_raw_event_register(input_dev);
-		if (rc < 0)
-			goto out_event;
-	}
-
-	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
-		   driver_name, rc_tab->name);
-
-	return 0;
-
-out_event:
-	ir_unregister_class(input_dev);
-out_table:
-	kfree(ir_dev->rc_tab.scan);
-out_name:
-	kfree(ir_dev->driver_name);
-out_dev:
-	kfree(ir_dev);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(__ir_input_register);
-
-/**
- * ir_input_unregister() - unregisters IR and frees resources
- * @input_dev:	the struct input_dev descriptor of the device
-
- * This routine is used to free memory and de-register interfaces.
- */
-void ir_input_unregister(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct ir_scancode_table *rc_tab;
+	struct rc_dev *dev = input_get_drvdata(input_dev);
 
-	if (!ir_dev)
-		return;
-
-	IR_dprintk(1, "Freed keycode table\n");
-
-	del_timer_sync(&ir_dev->timer_keyup);
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(input_dev);
-	rc_tab = &ir_dev->rc_tab;
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
-
-	ir_unregister_class(input_dev);
-
-	kfree(ir_dev->driver_name);
-	kfree(ir_dev);
+	return dev->close(dev);
 }
-EXPORT_SYMBOL_GPL(ir_input_unregister);
 
 /* class for /sys/class/rc */
 static char *ir_devnode(struct device *dev, mode_t *mode)
@@ -950,15 +796,15 @@ static struct class ir_input_class = {
 static ssize_t show_protocols(struct device *d,
 			      struct device_attribute *mattr, char *buf)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct rc_dev *dev = dev_get_drvdata(d);
 	u64 allowed, enabled;
 	char *tmp = buf;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = ir_dev->rc_tab.ir_type;
-		allowed = ir_dev->props->allowed_protos;
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		enabled = dev->rc_tab.ir_type;
+		allowed = dev->allowed_protos;
 	} else {
-		enabled = ir_dev->raw->enabled_protocols;
+		enabled = dev->raw->enabled_protocols;
 		spin_lock(&ir_raw_handler_lock);
 		allowed = available_protocols;
 		spin_unlock(&ir_raw_handler_lock);
@@ -1029,7 +875,7 @@ static ssize_t store_protocols(struct device *d,
 			       const char *data,
 			       size_t len)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct rc_dev *dev = dev_get_drvdata(d);
 	bool enable, disable;
 	const char *tmp;
 	u64 type;
@@ -1084,10 +930,10 @@ static ssize_t store_protocols(struct device *d,
 		return -EINVAL;
 	}
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
+	if (dev->driver_type == RC_DRIVER_SCANCODE)
+		type = dev->rc_tab.ir_type;
 	else
-		type = ir_dev->raw->enabled_protocols;
+		type = dev->raw->enabled_protocols;
 
 	if (enable)
 		type |= mask;
@@ -1096,9 +942,8 @@ static ssize_t store_protocols(struct device *d,
 	else
 		type = mask;
 
-	if (ir_dev->props && ir_dev->props->change_protocol) {
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    type);
+	if (dev->change_protocol) {
+		rc = dev->change_protocol(dev, type);
 		if (rc < 0) {
 			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 				   (long long)type);
@@ -1106,12 +951,12 @@ static ssize_t store_protocols(struct device *d,
 		}
 	}
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
-		ir_dev->rc_tab.ir_type = type;
-		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		spin_lock_irqsave(&dev->rc_tab.lock, flags);
+		dev->rc_tab.ir_type = type;
+		spin_unlock_irqrestore(&dev->rc_tab.lock, flags);
 	} else {
-		ir_dev->raw->enabled_protocols = type;
+		dev->raw->enabled_protocols = type;
 	}
 
 
@@ -1121,6 +966,14 @@ static ssize_t store_protocols(struct device *d,
 	return len;
 }
 
+static void rc_dev_release(struct device *device)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+
+	kfree(dev);
+	module_put(THIS_MODULE);
+}
+
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
 	do {								\
 		int err = add_uevent_var(env, fmt, val);		\
@@ -1130,12 +983,12 @@ static ssize_t store_protocols(struct device *d,
 
 static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
+	struct rc_dev *dev = dev_get_drvdata(device);
 
-	if (ir_dev->rc_tab.name)
-		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
-	if (ir_dev->driver_name)
-		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
+	if (dev->rc_tab.name)
+		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_tab.name);
+	if (dev->driver_name)
+		ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
 
 	return 0;
 }
@@ -1162,75 +1015,162 @@ static const struct attribute_group *rc_dev_attr_groups[] = {
 
 static struct device_type rc_dev_type = {
 	.groups		= rc_dev_attr_groups,
+	.release	= rc_dev_release,
 	.uevent		= rc_dev_uevent,
 };
 
-/**
- * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to register the syfs code for IR class
- */
-static int ir_register_class(struct input_dev *input_dev)
+struct rc_dev *rc_allocate_device(void)
 {
-	int rc;
-	const char *path;
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int devno = find_first_zero_bit(&ir_core_dev_number,
-					IRRCV_NUM_DEVICES);
-
-	if (unlikely(devno < 0))
-		return devno;
-
-	ir_dev->dev.type = &rc_dev_type;
-	ir_dev->dev.class = &ir_input_class;
-	ir_dev->dev.parent = input_dev->dev.parent;
-	dev_set_name(&ir_dev->dev, "rc%d", devno);
-	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	rc = device_register(&ir_dev->dev);
-	if (rc)
-		return rc;
+	struct rc_dev *dev;
 
+	dev = kzalloc(sizeof(struct rc_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
 
-	input_dev->dev.parent = &ir_dev->dev;
-	rc = input_register_device(input_dev);
-	if (rc < 0) {
-		device_del(&ir_dev->dev);
-		return rc;
+	dev->input_dev = input_allocate_device();
+	if (!dev->input_dev) {
+		kfree(dev);
+		return NULL;
 	}
 
+	dev->input_dev->getkeycode = ir_getkeycode;
+	dev->input_dev->setkeycode = ir_setkeycode;
+	input_set_drvdata(dev->input_dev, dev);
+	spin_lock_init(&dev->rc_tab.lock);
+	spin_lock_init(&dev->keylock);
+	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
+	dev->dev.class = &ir_input_class;
+	dev->dev.type = &rc_dev_type;
+	device_initialize(&dev->dev);
+
 	__module_get(THIS_MODULE);
+	return dev;
+}
+EXPORT_SYMBOL(rc_allocate_device);
+
+void rc_free_device(struct rc_dev *dev)
+{
+	if (dev) {
+		input_free_device(dev->input_dev);
+		put_device(&dev->dev);
+	}
+}
+EXPORT_SYMBOL(rc_free_device);
+
+int rc_register_device(struct rc_dev *dev)
+{
+	static atomic_t devno = ATOMIC_INIT(0);
+	struct ir_scancode_table *rc_tab;
+	const char *path;
+	int rc;
+
+	if (!dev->map_name)
+		return -EINVAL;
+
+	rc_tab = get_rc_map(dev->map_name);
+	if (!rc_tab || !rc_tab->scan || !rc_tab->size)
+		return -EINVAL;
+
+	if (dev->open)
+		dev->input_dev->open = ir_open;
+	if (dev->close)
+		dev->input_dev->close = ir_close;
+
+	dev->rc_tab.name = rc_tab->name;
+	dev->rc_tab.ir_type = rc_tab->ir_type;
+	dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
+					       sizeof(struct ir_scancode));
+	dev->rc_tab.size = dev->rc_tab.alloc / sizeof(struct ir_scancode);
+	dev->rc_tab.scan = kmalloc(dev->rc_tab.alloc, GFP_KERNEL);
+
+	if (!dev->rc_tab.scan)
+		return -ENOMEM;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   dev->rc_tab.size, dev->rc_tab.alloc);
+
+	set_bit(EV_KEY, dev->input_dev->evbit);
+	set_bit(EV_REP, dev->input_dev->evbit);
+
+	if (ir_setkeytable(dev, &dev->rc_tab, rc_tab)) {
+		rc = -ENOMEM;
+		goto out_table;
+	}
+
+	dev->devno = (unsigned long)(atomic_inc_return(&devno) - 1);
+	dev_set_name(&dev->dev, "rc%ld", dev->devno);
+	dev_set_drvdata(&dev->dev, dev);
+
+	rc = device_add(&dev->dev);
+	if (rc)
+		goto out_table;
+
+	dev->input_dev->dev.parent = &dev->dev;
+	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
+	dev->input_dev->phys = dev->input_phys;
+	dev->input_dev->name = dev->input_name;
+	rc = input_register_device(dev->input_dev);
+	if (rc)
+		goto out_dev;
 
-	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
+	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&ir_dev->dev),
-		input_dev->name ? input_dev->name : "Unspecified device",
-		path ? path : "N/A");
+	       dev_name(&dev->dev),
+	       dev->input_dev->name ? dev->input_dev->name : "Unspecified device",
+	       path ? path : "N/A");
 	kfree(path);
 
-	ir_dev->devno = devno;
-	set_bit(devno, &ir_core_dev_number);
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		rc = ir_raw_event_register(dev);
+		if (rc < 0)
+			goto out_input;
+	}
+
+	if (dev->change_protocol) {
+		rc = dev->change_protocol(dev, rc_tab->ir_type);
+		if (rc < 0)
+			goto out_raw;
+	}
+
+	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
+		   dev->driver_name, rc_tab->name);
 
 	return 0;
-};
 
-/**
- * ir_unregister_class() - removes the sysfs for sysfs for
- *			   /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to unregister the syfs code for IR class
- */
-static void ir_unregister_class(struct input_dev *input_dev)
+out_raw:
+	ir_raw_event_unregister(dev);
+out_input:
+	input_unregister_device(dev->input_dev);
+	dev->input_dev = NULL;
+out_dev:
+	device_del(&dev->dev);
+out_table:
+	kfree(dev->rc_tab.scan);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rc_register_device);
+
+void rc_unregister_device(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct ir_scancode_table *rc_tab;
 
-	clear_bit(ir_dev->devno, &ir_core_dev_number);
-	input_unregister_device(input_dev);
-	device_del(&ir_dev->dev);
+	if (!dev)
+		return;
 
-	module_put(THIS_MODULE);
+	del_timer_sync(&dev->timer_keyup);
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_event_unregister(dev);
+
+	rc_tab = &dev->rc_tab;
+	rc_tab->size = 0;
+	kfree(rc_tab->scan);
+	rc_tab->scan = NULL;
+	IR_dprintk(1, "Freed keycode table\n");
+
+	input_unregister_device(dev->input_dev);
+	device_unregister(&dev->dev);
 }
+EXPORT_SYMBOL_GPL(rc_unregister_device);
 
 /*
  * Init/exit code for the module. Basically, creates/removes /sys/class/rc
@@ -1255,7 +1195,7 @@ static void __exit ir_core_exit(void)
 	class_unregister(&ir_input_class);
 }
 
-module_init(ir_core_init);
+subsys_initcall(ir_core_init);
 module_exit(ir_core_exit);
 
 int ir_core_debug;    /* ir_debug level (0,1,2) */
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index b762e56..6909eed 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -26,7 +26,6 @@
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <linux/input.h>
 #include <linux/slab.h>
 #include <media/ir-core.h>
 
@@ -266,8 +265,8 @@ static void dm1105_card_list(struct pci_dev *pci)
 
 /* infrared remote control */
 struct infrared {
-	struct input_dev	*input_dev;
-	char			input_phys[32];
+	struct rc_dev		*dev;
+	char			phys[32];
 	struct work_struct	work;
 	u32			ir_command;
 };
@@ -532,7 +531,7 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	ir_keydown(ir->input_dev, data, 0);
+	ir_keydown(ir->dev, data, 0);
 }
 
 /* work handler */
@@ -593,46 +592,48 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 
 int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
-	struct input_dev *input_dev;
+	struct rc_dev *dev;
 	char *ir_codes = NULL;
 	int err = -ENOMEM;
 
-	input_dev = input_allocate_device();
-	if (!input_dev)
+	dev = rc_allocate_device();
+	if (!dev)
 		return -ENOMEM;
 
-	dm1105->ir.input_dev = input_dev;
-	snprintf(dm1105->ir.input_phys, sizeof(dm1105->ir.input_phys),
+	snprintf(dm1105->ir.phys, sizeof(dm1105->ir.phys),
 		"pci-%s/ir0", pci_name(dm1105->pdev));
 
-	input_dev->name = "DVB on-card IR receiver";
-	input_dev->phys = dm1105->ir.input_phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	dev->driver_type = RC_DRIVER_SCANCODE;
+	dev->input_name = "DVB on-card IR receiver";
+	dev->input_phys = dm1105->ir.phys;
+	dev->input_id.bustype = BUS_PCI;
+	dev->input_id.version = 1;
 	if (dm1105->pdev->subsystem_vendor) {
-		input_dev->id.vendor = dm1105->pdev->subsystem_vendor;
-		input_dev->id.product = dm1105->pdev->subsystem_device;
+		dev->input_id.vendor = dm1105->pdev->subsystem_vendor;
+		dev->input_id.product = dm1105->pdev->subsystem_device;
 	} else {
-		input_dev->id.vendor = dm1105->pdev->vendor;
-		input_dev->id.product = dm1105->pdev->device;
+		dev->input_id.vendor = dm1105->pdev->vendor;
+		dev->input_id.product = dm1105->pdev->device;
 	}
-
-	input_dev->dev.parent = &dm1105->pdev->dev;
+	dev->map_name = ir_codes;
+	dev->driver_name = MODULE_NAME;
+	dev->dev.parent = &dm1105->pdev->dev;
 
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
-	err = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	err = rc_register_device(dev);
 	if (err < 0) {
-		input_free_device(input_dev);
+		rc_free_device(dev);
 		return err;
 	}
 
+	dm1105->ir.dev = dev;
 	return 0;
 }
 
 void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)
 {
-	ir_input_unregister(dm1105->ir.input_dev);
+	rc_unregister_device(dm1105->ir.dev);
 }
 
 static int __devinit dm1105_hw_init(struct dm1105_dev *dev)
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/dvb/mantis/mantis_common.h
index d0b645a..bd400d2 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -171,7 +171,9 @@ struct mantis_pci {
 	struct work_struct	uart_work;
 	spinlock_t		uart_lock;
 
-	struct input_dev	*rc;
+	struct rc_dev		*rc;
+	char			input_name[80];
+	char			input_phys[80];
 };
 
 #define MANTIS_HIF_STATUS	(mantis->gpio_status)
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index a99489b..56e4ca3 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -18,7 +18,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/input.h>
 #include <media/ir-core.h>
 #include <linux/pci.h>
 
@@ -33,6 +32,7 @@
 #include "mantis_uart.h"
 
 #define MODULE_NAME "mantis_core"
+#define RC_MAP_MANTIS "rc-mantis"
 
 static struct ir_scancode mantis_ir_table[] = {
 	{ 0x29, KEY_POWER	},
@@ -95,53 +95,60 @@ static struct ir_scancode mantis_ir_table[] = {
 	{ 0x00, KEY_BLUE	},
 };
 
-struct ir_scancode_table ir_mantis = {
-	.scan = mantis_ir_table,
-	.size = ARRAY_SIZE(mantis_ir_table),
+static struct rc_keymap ir_mantis_map = {
+	.map = {
+		.scan = mantis_ir_table,
+		.size = ARRAY_SIZE(mantis_ir_table),
+		.ir_type = IR_TYPE_UNKNOWN,
+		.name = RC_MAP_MANTIS,
+	}
 };
-EXPORT_SYMBOL_GPL(ir_mantis);
 
 int mantis_input_init(struct mantis_pci *mantis)
 {
-	struct input_dev *rc;
-	char name[80], dev[80];
+	struct rc_dev *dev;
 	int err;
 
-	rc = input_allocate_device();
-	if (!rc) {
-		dprintk(MANTIS_ERROR, 1, "Input device allocate failed");
+	err = ir_register_map(&ir_mantis_map);
+	if (err)
+		return err;
+
+	dev = rc_allocate_device();
+	if (!dev) {
+		dprintk(MANTIS_ERROR, 1, "Remote device allocate failed");
+		ir_unregister_map(&ir_mantis_map);
 		return -ENOMEM;
 	}
 
-	sprintf(name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
-	sprintf(dev, "pci-%s/ir0", pci_name(mantis->pdev));
-
-	rc->name = name;
-	rc->phys = dev;
+	sprintf(mantis->input_name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
+	sprintf(mantis->input_phys, "pci-%s/ir0", pci_name(mantis->pdev));
 
-	rc->id.bustype	= BUS_PCI;
-	rc->id.vendor	= mantis->vendor_id;
-	rc->id.product	= mantis->device_id;
-	rc->id.version	= 1;
-	rc->dev		= mantis->pdev->dev;
+	dev->input_name         = mantis->input_name;
+	dev->input_phys         = mantis->input_phys;
+	dev->input_id.bustype   = BUS_PCI;
+	dev->input_id.vendor    = mantis->vendor_id;
+	dev->input_id.product   = mantis->device_id;
+	dev->input_id.version   = 1;
+	dev->driver_name        = MODULE_NAME;
+	dev->map_name           = RC_MAP_MANTIS;
+	dev->dev.parent         = &mantis->pdev->dev;
 
-	err = __ir_input_register(rc, &ir_mantis, NULL, MODULE_NAME);
+	err = rc_register_device(dev);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret = %d", err);
-		input_free_device(rc);
+		rc_free_device(dev);
+		ir_unregister_map(&ir_mantis_map);
 		return -ENODEV;
 	}
 
-	mantis->rc = rc;
+	mantis->rc = dev;
 
 	return 0;
 }
 
 int mantis_exit(struct mantis_pci *mantis)
 {
-	struct input_dev *rc = mantis->rc;
-
-	ir_input_unregister(rc);
-
+	rc_unregister_device(mantis->rc);
+	ir_unregister_map(&ir_mantis_map);
 	return 0;
 }
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 4617143..84597e7 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -33,7 +33,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
 #include <linux/spinlock.h>
 #include <media/ir-core.h>
 
@@ -96,7 +95,7 @@ MODULE_PARM_DESC(ir_debug, "enable debugging information for IR decoding");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct budget_ci_ir {
-	struct input_dev *dev;
+	struct rc_dev *dev;
 	struct tasklet_struct msp430_irq_tasklet;
 	char name[72]; /* 40 + 32 for (struct saa7146_dev).name */
 	char phys[32];
@@ -118,7 +117,7 @@ struct budget_ci {
 static void msp430_ir_interrupt(unsigned long data)
 {
 	struct budget_ci *budget_ci = (struct budget_ci *) data;
-	struct input_dev *dev = budget_ci->ir.dev;
+	struct rc_dev *dev = budget_ci->ir.dev;
 	u32 command = ttpci_budget_debiread(&budget_ci->budget, DEBINOSWAP, DEBIADDR_IR, 2, 1, 0) >> 8;
 
 	/*
@@ -166,13 +165,11 @@ static void msp430_ir_interrupt(unsigned long data)
 static int msp430_ir_init(struct budget_ci *budget_ci)
 {
 	struct saa7146_dev *saa = budget_ci->budget.dev;
-	struct input_dev *input_dev = budget_ci->ir.dev;
+	struct rc_dev *dev;
 	int error;
-	char *ir_codes = NULL;
 
-
-	budget_ci->ir.dev = input_dev = input_allocate_device();
-	if (!input_dev) {
+	dev = rc_allocate_device();
+	if (!dev) {
 		printk(KERN_ERR "budget_ci: IR interface initialisation failed\n");
 		return -ENOMEM;
 	}
@@ -182,19 +179,19 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	snprintf(budget_ci->ir.phys, sizeof(budget_ci->ir.phys),
 		 "pci-%s/ir0", pci_name(saa->pci));
 
-	input_dev->name = budget_ci->ir.name;
-
-	input_dev->phys = budget_ci->ir.phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	dev->driver_name = MODULE_NAME;
+	dev->input_name = budget_ci->ir.name;
+	dev->input_phys = budget_ci->ir.phys;
+	dev->input_id.bustype = BUS_PCI;
+	dev->input_id.version = 1;
 	if (saa->pci->subsystem_vendor) {
-		input_dev->id.vendor = saa->pci->subsystem_vendor;
-		input_dev->id.product = saa->pci->subsystem_device;
+		dev->input_id.vendor = saa->pci->subsystem_vendor;
+		dev->input_id.product = saa->pci->subsystem_device;
 	} else {
-		input_dev->id.vendor = saa->pci->vendor;
-		input_dev->id.product = saa->pci->device;
+		dev->input_id.vendor = saa->pci->vendor;
+		dev->input_id.product = saa->pci->device;
 	}
-	input_dev->dev.parent = &saa->pci->dev;
+	dev->dev.parent = &saa->pci->dev;
 
 	if (rc5_device < 0)
 		budget_ci->ir.rc5_device = IR_DEVICE_ANY;
@@ -208,7 +205,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1011:
 	case 0x1012:
 		/* The hauppauge keymap is a superset of these remotes */
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		dev->map_name = RC_MAP_HAUPPAUGE_NEW;
 
 		if (rc5_device < 0)
 			budget_ci->ir.rc5_device = 0x1f;
@@ -217,23 +214,22 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1017:
 	case 0x101a:
 		/* for the Technotrend 1500 bundled remote */
-		ir_codes = RC_MAP_TT_1500;
+		dev->map_name = RC_MAP_TT_1500;
 		break;
 	default:
 		/* unknown remote */
-		ir_codes = RC_MAP_BUDGET_CI_OLD;
+		dev->map_name = RC_MAP_BUDGET_CI_OLD;
 		break;
 	}
 
-	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	error = rc_register_device(dev);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
+		rc_free_device(dev);
 		return error;
 	}
 
-	/* note: these must be after input_register_device */
-	input_dev->rep[REP_DELAY] = 400;
-	input_dev->rep[REP_PERIOD] = 250;
+	budget_ci->ir.dev = dev;
 
 	tasklet_init(&budget_ci->ir.msp430_irq_tasklet, msp430_ir_interrupt,
 		     (unsigned long) budget_ci);
@@ -247,13 +243,12 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 static void msp430_ir_deinit(struct budget_ci *budget_ci)
 {
 	struct saa7146_dev *saa = budget_ci->budget.dev;
-	struct input_dev *dev = budget_ci->ir.dev;
 
 	SAA7146_IER_DISABLE(saa, MASK_06);
 	saa7146_setgpio(saa, 3, SAA7146_GPIO_INPUT);
 	tasklet_kill(&budget_ci->ir.msp430_irq_tasklet);
 
-	ir_input_unregister(dev);
+	rc_unregister_device(budget_ci->ir.dev);
 }
 
 static int ciintf_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 1d93a73..0132828 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -31,10 +31,6 @@
 
 static int ir_debug;
 module_param(ir_debug, int, 0644);
-static int repeat_delay = 500;
-module_param(repeat_delay, int, 0644);
-static int repeat_period = 33;
-module_param(repeat_period, int, 0644);
 
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
@@ -242,15 +238,15 @@ int bttv_input_init(struct bttv *btv)
 {
 	struct card_ir *ir;
 	char *ir_codes = NULL;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	int err = -ENOMEM;
 
 	if (!btv->has_remote)
 		return -ENODEV;
 
 	ir = kzalloc(sizeof(*ir),GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev)
+	rc = rc_allocate_device();
+	if (!ir || !rc)
 		goto err_out_free;
 
 	/* detect & configure */
@@ -356,44 +352,43 @@ int bttv_input_init(struct bttv *btv)
 	}
 
 	/* init input device */
-	ir->dev = input_dev;
+	ir->dev = rc;
 
 	snprintf(ir->name, sizeof(ir->name), "bttv IR (card=%d)",
 		 btv->c.type);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(btv->c.pci));
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->input_id.bustype = BUS_PCI;
+	rc->input_id.version = 1;
 	if (btv->c.pci->subsystem_vendor) {
-		input_dev->id.vendor  = btv->c.pci->subsystem_vendor;
-		input_dev->id.product = btv->c.pci->subsystem_device;
+		rc->input_id.vendor  = btv->c.pci->subsystem_vendor;
+		rc->input_id.product = btv->c.pci->subsystem_device;
 	} else {
-		input_dev->id.vendor  = btv->c.pci->vendor;
-		input_dev->id.product = btv->c.pci->device;
+		rc->input_id.vendor  = btv->c.pci->vendor;
+		rc->input_id.product = btv->c.pci->device;
 	}
-	input_dev->dev.parent = &btv->c.pci->dev;
+	rc->dev.parent = &btv->c.pci->dev;
+	rc->map_name = ir_codes;
+	rc->driver_name = MODULE_NAME;
 
 	btv->remote = ir;
 	bttv_ir_start(btv, ir);
 
 	/* all done */
-	err = ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
+	err = rc_register_device(rc);
 	if (err)
 		goto err_out_stop;
 
-	/* the remote isn't as bouncy as a keyboard */
-	ir->dev->rep[REP_DELAY] = repeat_delay;
-	ir->dev->rep[REP_PERIOD] = repeat_period;
-
 	return 0;
 
  err_out_stop:
 	bttv_ir_stop(btv);
 	btv->remote = NULL;
  err_out_free:
+	rc_free_device(rc);
 	kfree(ir);
 	return err;
 }
@@ -404,7 +399,7 @@ void bttv_input_fini(struct bttv *btv)
 		return;
 
 	bttv_ir_stop(btv);
-	ir_input_unregister(btv->remote->dev);
+	rc_unregister_device(btv->remote->dev);
 	kfree(btv->remote);
 	btv->remote = NULL;
 }
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 444251b..3905adf 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -35,7 +35,6 @@
  *  02110-1301, USA.
  */
 
-#include <linux/input.h>
 #include <linux/slab.h>
 #include <media/ir-common.h>
 #include <media/v4l2-subdev.h>
@@ -291,7 +290,7 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 int cx23885_input_init(struct cx23885_dev *dev)
 {
 	struct card_ir *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	char *ir_codes = NULL;
 	int ir_addr, ir_start;
 	int ret;
@@ -316,13 +315,13 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		return -ENODEV;
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev) {
+	rc = rc_allocate_device();
+	if (!ir || !rc) {
 		ret = -ENOMEM;
 		goto err_out_free;
 	}
 
-	ir->dev = input_dev;
+	ir->dev = rc;
 	ir->addr = ir_addr;
 	ir->start = ir_start;
 
@@ -331,23 +330,25 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		 cx23885_boards[dev->board].name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(dev->pci));
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->map_name = ir_codes;
+	rc->driver_name = MODULE_NAME;
+	rc->input_id.bustype = BUS_PCI;
+	rc->input_id.version = 1;
 	if (dev->pci->subsystem_vendor) {
-		input_dev->id.vendor  = dev->pci->subsystem_vendor;
-		input_dev->id.product = dev->pci->subsystem_device;
+		rc->input_id.vendor  = dev->pci->subsystem_vendor;
+		rc->input_id.product = dev->pci->subsystem_device;
 	} else {
-		input_dev->id.vendor  = dev->pci->vendor;
-		input_dev->id.product = dev->pci->device;
+		rc->input_id.vendor  = dev->pci->vendor;
+		rc->input_id.product = dev->pci->device;
 	}
-	input_dev->dev.parent = &dev->pci->dev;
+	rc->dev.parent = &dev->pci->dev;
 
 	dev->ir_input = ir;
 	cx23885_input_ir_start(dev);
 
-	ret = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
+	ret = rc_register_device(rc);
 	if (ret)
 		goto err_out_stop;
 
@@ -357,6 +358,7 @@ err_out_stop:
 	cx23885_input_ir_stop(dev);
 	dev->ir_input = NULL;
 err_out_free:
+	rc_free_device(rc);
 	kfree(ir);
 	return ret;
 }
@@ -368,7 +370,7 @@ void cx23885_input_fini(struct cx23885_dev *dev)
 
 	if (dev->ir_input == NULL)
 		return;
-	ir_input_unregister(dev->ir_input->dev);
+	rc_unregister_device(dev->ir_input->dev);
 	kfree(dev->ir_input);
 	dev->ir_input = NULL;
 }
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 45cf079..06a9faf 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -24,7 +24,6 @@
 
 #include <linux/init.h>
 #include <linux/hrtimer.h>
-#include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -39,8 +38,7 @@
 
 struct cx88_IR {
 	struct cx88_core *core;
-	struct input_dev *input;
-	struct ir_dev_props props;
+	struct rc_dev *dev;
 
 	int users;
 
@@ -124,27 +122,27 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		ir_keydown_notimeout(ir->input, data, 0);
-		ir_keyup(ir->input);
+		ir_keydown_notimeout(ir->dev, data, 0);
+		ir_keyup(ir->dev);
 
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			ir_keydown_notimeout(ir->input, data, 0);
+			ir_keydown_notimeout(ir->dev, data, 0);
 		else
-			ir_keyup(ir->input);
+			ir_keyup(ir->dev);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			ir_keydown_notimeout(ir->input, data, 0);
+			ir_keydown_notimeout(ir->dev, data, 0);
 		else
-			ir_keyup(ir->input);
+			ir_keyup(ir->dev);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		ir_keydown_notimeout(ir->input, data, 0);
-		ir_keyup(ir->input);
+		ir_keydown_notimeout(ir->dev, data, 0);
+		ir_keyup(ir->dev);
 	}
 }
 
@@ -219,17 +217,17 @@ void cx88_ir_stop(struct cx88_core *core)
 		__cx88_ir_stop(core);
 }
 
-static int cx88_ir_open(void *priv)
+static int cx88_ir_open(struct rc_dev *dev)
 {
-	struct cx88_core *core = priv;
+	struct cx88_core *core = dev->priv;
 
 	core->ir->users++;
 	return __cx88_ir_start(core);
 }
 
-static void cx88_ir_close(void *priv)
+static void cx88_ir_close(struct rc_dev *dev)
 {
-	struct cx88_core *core = priv;
+	struct cx88_core *core = dev->priv;
 
 	core->ir->users--;
 	if (!core->ir->users)
@@ -241,7 +239,7 @@ static void cx88_ir_close(void *priv)
 int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	struct cx88_IR *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	char *ir_codes = NULL;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
@@ -249,11 +247,11 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 				 */
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev)
+	rc = rc_allocate_device();
+	if (!ir || !rc)
 		goto err_out_free;
 
-	ir->input = input_dev;
+	ir->dev = rc;
 
 	/* detect & configure */
 	switch (core->boardnr) {
@@ -429,35 +427,39 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->input_id.bustype = BUS_PCI;
+	rc->input_id.version = 1;
 	if (pci->subsystem_vendor) {
-		input_dev->id.vendor = pci->subsystem_vendor;
-		input_dev->id.product = pci->subsystem_device;
+		rc->input_id.vendor = pci->subsystem_vendor;
+		rc->input_id.product = pci->subsystem_device;
 	} else {
-		input_dev->id.vendor = pci->vendor;
-		input_dev->id.product = pci->device;
+		rc->input_id.vendor = pci->vendor;
+		rc->input_id.product = pci->device;
 	}
-	input_dev->dev.parent = &pci->dev;
+	rc->dev.parent = &pci->dev;
+	rc->map_name = ir_codes;
+	rc->driver_name = MODULE_NAME;
+
 	/* record handles to ourself */
 	ir->core = core;
 	core->ir = ir;
 
-	ir->props.priv = core;
-	ir->props.open = cx88_ir_open;
-	ir->props.close = cx88_ir_close;
-	ir->props.scanmask = hardware_mask;
+	rc->priv = core;
+	rc->open = cx88_ir_open;
+	rc->close = cx88_ir_close;
+	rc->scanmask = hardware_mask;
 
 	/* all done */
-	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
+	err = rc_register_device(rc);
 	if (err)
 		goto err_out_free;
 
 	return 0;
 
  err_out_free:
+	rc_free_device(rc);
 	core->ir = NULL;
 	kfree(ir);
 	return err;
@@ -472,7 +474,7 @@ int cx88_ir_fini(struct cx88_core *core)
 		return 0;
 
 	cx88_ir_stop(core);
-	ir_input_unregister(ir->input);
+	rc_unregister_device(ir->dev);
 	kfree(ir);
 
 	/* done */
@@ -537,7 +539,7 @@ void cx88_ir_irq(struct cx88_core *core)
 
 		if (ircode == 0) { /* key still pressed */
 			ir_dprintk("pulse distance decoded repeat code\n");
-			ir_repeat(ir->input);
+			ir_repeat(ir->dev);
 			break;
 		}
 
@@ -552,7 +554,7 @@ void cx88_ir_irq(struct cx88_core *core)
 		}
 
 		ir_dprintk("Key Code: %x\n", (ircode >> 16) & 0xff);
-		ir_keydown(ir->input, (ircode >> 16) & 0xff, 0);
+		ir_keydown(ir->dev, (ircode >> 16) & 0xff, 0);
 		break;
 	case CX88_BOARD_HAUPPAUGE:
 	case CX88_BOARD_HAUPPAUGE_DVB_T1:
@@ -588,7 +590,7 @@ void cx88_ir_irq(struct cx88_core *core)
 		if ( dev != 0x1e && dev != 0x1f )
 			/* not a hauppauge remote */
 			break;
-		ir_keydown(ir->input, code, toggle);
+		ir_keydown(ir->dev, code, toggle);
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
@@ -597,7 +599,7 @@ void cx88_ir_irq(struct cx88_core *core)
 			break;
 		/* Note: bit 0x800 being the toggle is assumed, not checked
 		   with real hardware  */
-		ir_keydown(ir->input, ircode & 0x3f, ircode & 0x0800 ? 1 : 0);
+		ir_keydown(ir->dev, ircode & 0x3f, ircode & 0x0800 ? 1 : 0);
 		break;
 	}
 
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 6759cd5..176b300 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/slab.h>
 
@@ -64,7 +63,7 @@ struct em28xx_ir_poll_result {
 
 struct em28xx_IR {
 	struct em28xx *dev;
-	struct input_dev *input;
+	struct rc_dev *rc;
 	char name[32];
 	char phys[32];
 
@@ -75,10 +74,6 @@ struct em28xx_IR {
 	unsigned int last_readcount;
 
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
-
-	/* IR device properties */
-
-	struct ir_dev_props props;
 };
 
 /**********************************************************
@@ -302,12 +297,12 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 			poll_result.toggle_bit, poll_result.read_count,
 			poll_result.rc_address, poll_result.rc_data[0]);
 		if (ir->full_code)
-			ir_keydown(ir->input,
+			ir_keydown(ir->rc,
 				   poll_result.rc_address << 8 |
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
 		else
-			ir_keydown(ir->input,
+			ir_keydown(ir->rc,
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
 
@@ -331,9 +326,9 @@ static void em28xx_ir_work(struct work_struct *work)
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
-static int em28xx_ir_start(void *priv)
+static int em28xx_ir_start(struct rc_dev *dev)
 {
-	struct em28xx_IR *ir = priv;
+	struct em28xx_IR *ir = dev->priv;
 
 	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 	schedule_delayed_work(&ir->work, 0);
@@ -341,17 +336,17 @@ static int em28xx_ir_start(void *priv)
 	return 0;
 }
 
-static void em28xx_ir_stop(void *priv)
+static void em28xx_ir_stop(struct rc_dev *dev)
 {
-	struct em28xx_IR *ir = priv;
+	struct em28xx_IR *ir = dev->priv;
 
 	cancel_delayed_work_sync(&ir->work);
 }
 
-int em28xx_ir_change_protocol(void *priv, u64 ir_type)
+int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 ir_type)
 {
 	int rc = 0;
-	struct em28xx_IR *ir = priv;
+	struct em28xx_IR *ir = rc_dev->priv;
 	struct em28xx *dev = ir->dev;
 	u8 ir_config = EM2874_IR_RC5;
 
@@ -391,7 +386,7 @@ int em28xx_ir_change_protocol(void *priv, u64 ir_type)
 int em28xx_ir_init(struct em28xx *dev)
 {
 	struct em28xx_IR *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	int err = -ENOMEM;
 
 	if (dev->board.ir_codes == NULL) {
@@ -400,28 +395,28 @@ int em28xx_ir_init(struct em28xx *dev)
 	}
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev)
+	rc = rc_allocate_device();
+	if (!ir || !rc)
 		goto err_out_free;
 
 	/* record handles to ourself */
 	ir->dev = dev;
 	dev->ir = ir;
 
-	ir->input = input_dev;
+	ir->rc = rc;
 
 	/*
 	 * em2874 supports more protocols. For now, let's just announce
 	 * the two protocols that were already tested
 	 */
-	ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
-	ir->props.priv = ir;
-	ir->props.change_protocol = em28xx_ir_change_protocol;
-	ir->props.open = em28xx_ir_start;
-	ir->props.close = em28xx_ir_stop;
+	rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+	rc->priv = ir;
+	rc->change_protocol = em28xx_ir_change_protocol;
+	rc->open = em28xx_ir_start;
+	rc->close = em28xx_ir_stop;
 
 	/* By default, keep protocol field untouched */
-	err = em28xx_ir_change_protocol(ir, IR_TYPE_UNKNOWN);
+	err = em28xx_ir_change_protocol(rc, IR_TYPE_UNKNOWN);
 	if (err)
 		goto err_out_free;
 
@@ -435,27 +430,27 @@ int em28xx_ir_init(struct em28xx *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_USB;
-	input_dev->id.version = 1;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
-
-	input_dev->dev.parent = &dev->udev->dev;
-
-
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->input_id.bustype = BUS_USB;
+	rc->input_id.version = 1;
+	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	rc->map_name = dev->board.ir_codes;
+	rc->driver_name = MODULE_NAME;
+	rc->dev.parent = &dev->udev->dev;
 
 	/* all done */
-	err = ir_input_register(ir->input, dev->board.ir_codes,
-				&ir->props, MODULE_NAME);
+	err = rc_register_device(rc);
 	if (err)
 		goto err_out_stop;
 
 	return 0;
+
  err_out_stop:
 	dev->ir = NULL;
  err_out_free:
+	rc_free_device(rc);
 	kfree(ir);
 	return err;
 }
@@ -468,8 +463,8 @@ int em28xx_ir_fini(struct em28xx *dev)
 	if (!ir)
 		return 0;
 
-	em28xx_ir_stop(ir);
-	ir_input_unregister(ir->input);
+	em28xx_ir_stop(ir->rc);
+	rc_unregister_device(ir->rc);
 	kfree(ir);
 
 	/* done */
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index edd414d..0104771 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -273,7 +273,7 @@ static void ir_key_poll(struct IR_i2c *ir)
 	}
 
 	if (rc)
-		ir_keydown(ir->input, ir_key, 0);
+		ir_keydown(ir->rc, ir_key, 0);
 }
 
 static void ir_work(struct work_struct *work)
@@ -297,20 +297,20 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	char *ir_codes = NULL;
 	const char *name = NULL;
 	struct IR_i2c *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	struct i2c_adapter *adap = client->adapter;
 	unsigned short addr = client->addr;
 	int err;
 
 	ir = kzalloc(sizeof(struct IR_i2c),GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev) {
+	rc = rc_allocate_device();
+	if (!ir || !rc) {
 		err = -ENOMEM;
 		goto err_out_free;
 	}
 
 	ir->c = client;
-	ir->input = input_dev;
+	ir->rc = rc;
 	i2c_set_clientdata(client, ir);
 
 	switch(addr) {
@@ -425,16 +425,20 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 dev_name(&client->dev));
 
 	/* init + register input device */
-	input_dev->id.bustype = BUS_I2C;
-	input_dev->name       = ir->name;
-	input_dev->phys       = ir->phys;
+	rc->input_id.bustype = BUS_I2C;
+	rc->input_name       = ir->name;
+	rc->input_phys       = ir->phys;
+	rc->map_name         = ir->ir_codes;
+	rc->driver_name      = MODULE_NAME;
 
-	err = ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
+	err = rc_register_device(rc);
 	if (err)
 		goto err_out_free;
 
+	ir->rc = rc;
+
 	printk(MODULE_NAME ": %s detected at %s [%s]\n",
-	       ir->input->name, ir->input->phys, adap->name);
+	       ir->name, ir->phys, adap->name);
 
 	/* start polling via eventd */
 	INIT_DELAYED_WORK(&ir->work, ir_work);
@@ -443,6 +447,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
  err_out_free:
+	rc_free_device(rc);
 	kfree(ir);
 	return err;
 }
@@ -455,7 +460,7 @@ static int ir_remove(struct i2c_client *client)
 	cancel_delayed_work_sync(&ir->work);
 
 	/* unregister device */
-	ir_input_unregister(ir->input);
+	rc_unregister_device(ir->rc);
 
 	/* free memory */
 	kfree(ir);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 866f9d3..8914c35 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
 #include <linux/slab.h>
 
 #include "saa7134-reg.h"
@@ -45,14 +44,6 @@ MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=g
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
 
-static int repeat_delay = 500;
-module_param(repeat_delay, int, 0644);
-MODULE_PARM_DESC(repeat_delay, "delay before key repeat started");
-static int repeat_period = 33;
-module_param(repeat_period, int, 0644);
-MODULE_PARM_DESC(repeat_period, "repeat period between "
-    "keypresses when key is down");
-
 static unsigned int disable_other_ir;
 module_param(disable_other_ir, int, 0644);
 MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
@@ -523,17 +514,17 @@ void saa7134_ir_stop(struct saa7134_dev *dev)
 		__saa7134_ir_stop(dev);
 }
 
-static int saa7134_ir_open(void *priv)
+static int saa7134_ir_open(struct rc_dev *rc)
 {
-	struct saa7134_dev *dev = priv;
+	struct saa7134_dev *dev = rc->priv;
 
 	dev->remote->users++;
 	return __saa7134_ir_start(dev);
 }
 
-static void saa7134_ir_close(void *priv)
+static void saa7134_ir_close(struct rc_dev *rc)
 {
-	struct saa7134_dev *dev = priv;
+	struct saa7134_dev *dev = rc->priv;
 
 	dev->remote->users--;
 	if (!dev->remote->users)
@@ -541,9 +532,9 @@ static void saa7134_ir_close(void *priv)
 }
 
 
-int saa7134_ir_change_protocol(void *priv, u64 ir_type)
+int saa7134_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 {
-	struct saa7134_dev *dev = priv;
+	struct saa7134_dev *dev = rc->priv;
 	struct card_ir *ir = dev->remote;
 	u32 nec_gpio, rc5_gpio;
 
@@ -577,7 +568,7 @@ int saa7134_ir_change_protocol(void *priv, u64 ir_type)
 int saa7134_input_init1(struct saa7134_dev *dev)
 {
 	struct card_ir *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	char *ir_codes = NULL;
 	u32 mask_keycode = 0;
 	u32 mask_keydown = 0;
@@ -814,13 +805,13 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev) {
+	rc = rc_allocate_device();
+	if (!ir | !rc) {
 		err = -ENOMEM;
 		goto err_out_free;
 	}
 
-	ir->dev = input_dev;
+	ir->dev = rc;
 	dev->remote = ir;
 
 	ir->running = 0;
@@ -840,43 +831,41 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
-
-	ir->props.priv = dev;
-	ir->props.open = saa7134_ir_open;
-	ir->props.close = saa7134_ir_close;
+	rc->priv = dev;
+	rc->open = saa7134_ir_open;
+	rc->close = saa7134_ir_close;
 
 	if (raw_decode)
-		ir->props.driver_type = RC_DRIVER_IR_RAW;
+		rc->driver_type = RC_DRIVER_IR_RAW;
 
 	if (!raw_decode && allow_protocol_change) {
-		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
-		ir->props.change_protocol = saa7134_ir_change_protocol;
+		rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+		rc->change_protocol = saa7134_ir_change_protocol;
 	}
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->map_name = ir_codes;
+	rc->driver_name = MODULE_NAME;
+	rc->input_id.bustype = BUS_PCI;
+	rc->input_id.version = 1;
 	if (dev->pci->subsystem_vendor) {
-		input_dev->id.vendor  = dev->pci->subsystem_vendor;
-		input_dev->id.product = dev->pci->subsystem_device;
+		rc->input_id.vendor  = dev->pci->subsystem_vendor;
+		rc->input_id.product = dev->pci->subsystem_device;
 	} else {
-		input_dev->id.vendor  = dev->pci->vendor;
-		input_dev->id.product = dev->pci->device;
+		rc->input_id.vendor  = dev->pci->vendor;
+		rc->input_id.product = dev->pci->device;
 	}
-	input_dev->dev.parent = &dev->pci->dev;
+	rc->dev.parent = &dev->pci->dev;
 
-	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
+	err = rc_register_device(rc);
 	if (err)
 		goto err_out_free;
 
-	/* the remote isn't as bouncy as a keyboard */
-	ir->dev->rep[REP_DELAY] = repeat_delay;
-	ir->dev->rep[REP_PERIOD] = repeat_period;
-
 	return 0;
 
 err_out_free:
+	rc_free_device(rc);
 	dev->remote = NULL;
 	kfree(ir);
 	return err;
@@ -888,7 +877,7 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 		return;
 
 	saa7134_ir_stop(dev);
-	ir_input_unregister(dev->remote->dev);
+	rc_unregister_device(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
 }
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 6391cea..41e203f 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -37,12 +37,11 @@
 /* this was saa7134_ir and bttv_ir, moved here for
  * rc5 decoding. */
 struct card_ir {
-	struct input_dev        *dev;
+	struct rc_dev           *dev;
 	char                    name[32];
 	char                    phys[32];
 	int			users;
 	u32			running:1;
-	struct ir_dev_props	props;
 
 	/* Usual gpio signalling */
 	u32                     mask_keycode;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 86fc95e..077c1ff 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -32,55 +32,69 @@ enum rc_driver_type {
 };
 
 /**
- * struct ir_dev_props - Allow caller drivers to set special properties
- * @driver_type: specifies if the driver or hardware have already a decoder,
- *	or if it needs to use the IR raw event decoders to produce a scancode
+ * struct rc_dev - represents a remote control device
+ * @input_name - name of the input child device
+ * @input_phys - physical path to the input child device
+ * @input_id - id of the input child device (struct input_id)
+ * @dev - driver model's view of this device
+ * @driver_name - name of the hardware driver which registered this device
+ * @map_name - name of the default keymap
+ * @rc_tab - current scan/key table
+ * @devno - unique remote control device number
+ * @raw - additional data for raw pulse/space devices
+ * @input_dev - the input child device used to communicate events to userspace
+ * @driver_type: specifies if protocol decoding is done in hardware or software 
  * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
  *	devices, a mask is provided to allow its usage. Drivers should generally
- *	leave this field in blank
+ *	leave this field blank
  * @priv: driver-specific data, to be used on the callbacks
- * @change_protocol: allow changing the protocol used on hardware decoders
- * @open: callback to allow drivers to enable polling/irq when IR input device
- *	is opened.
- * @close: callback to allow drivers to disable polling/irq when IR input device
+ * @change_protocol: allows changing the protocol used on hardware decoders
+ * @open: callback to allow drivers to enable polling/irq when the input device 
  *	is opened.
+ * @close: callback to allow drivers to disable polling/irq when the input device
+ *	is closed.
+ * @keylock: protects the remaining members of the struct
+ * @keypressed: whether a key is currently pressed
+ * @keyup_jiffies: time (in jiffies) when the current keypress should be released
+ * @timer_keyup: timer for releasing a keypress
+ * @last_keycode: keycode of last keypress
+ * @last_scancode: scancode of last keypress
+ * @last_toggle: toggle value of last command
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
  * @tx_ir: transmit IR
  */
-struct ir_dev_props {
-	enum rc_driver_type	driver_type;
-	unsigned long		allowed_protos;
-	u32			scanmask;
-	void			*priv;
-	int			(*change_protocol)(void *priv, u64 ir_type);
-	int			(*open)(void *priv);
-	void			(*close)(void *priv);
-	int			(*s_tx_mask)(void *priv, u32 mask);
-	int			(*s_tx_carrier)(void *priv, u32 carrier);
-	int			(*tx_ir)(void *priv, const char *buf, u32 n);
-};
-
-struct ir_input_dev {
-	struct device			dev;		/* device */
-	char				*driver_name;	/* Name of the driver module */
-	struct ir_scancode_table	rc_tab;		/* scan/key table */
-	unsigned long			devno;		/* device number */
-	const struct ir_dev_props	*props;		/* Device properties */
-	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
-	struct input_dev		*input_dev;	/* the input device associated with this device */
-
-	/* key info - needed by IR keycode handlers */
-	spinlock_t			keylock;	/* protects the below members */
-	bool				keypressed;	/* current state */
-	unsigned long			keyup_jiffies;	/* when should the current keypress be released? */
-	struct timer_list		timer_keyup;	/* timer for releasing a keypress */
-	u32				last_keycode;	/* keycode of last command */
-	u32				last_scancode;	/* scancode of last command */
-	u8				last_toggle;	/* toggle of last command */
+struct rc_dev {
+	const char			*input_name;
+	const char			*input_phys;
+	struct input_id			input_id;
+	struct device			dev;
+	const char			*driver_name;
+	const char			*map_name;
+	struct ir_scancode_table	rc_tab;
+	unsigned long			devno;
+	struct ir_raw_event_ctrl	*raw;
+	struct input_dev		*input_dev;
+	enum rc_driver_type		driver_type;
+	unsigned long			allowed_protos;
+	u32				scanmask;
+	void				*priv;
+	int				(*change_protocol)(struct rc_dev *dev, u64 ir_type);
+	int				(*open)(struct rc_dev *dev);
+	void				(*close)(struct rc_dev *dev);
+	spinlock_t			keylock;
+	bool				keypressed;
+	unsigned long			keyup_jiffies;
+	struct timer_list		timer_keyup;
+	u32				last_keycode;
+	u32				last_scancode;
+	u8				last_toggle;
+	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
+	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
+	int				(*tx_ir)(struct rc_dev *dev, const char *buf, u32 n);
 };
 
 enum raw_event_type {
@@ -90,48 +104,13 @@ enum raw_event_type {
 	IR_STOP_EVENT   = (1 << 3),
 };
 
-#define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
-
-int __ir_input_register(struct input_dev *dev,
-		      const struct ir_scancode_table *ir_codes,
-		      const struct ir_dev_props *props,
-		      const char *driver_name);
-
-static inline int ir_input_register(struct input_dev *dev,
-		      const char *map_name,
-		      const struct ir_dev_props *props,
-		      const char *driver_name) {
-	struct ir_scancode_table *ir_codes;
-	struct ir_input_dev *ir_dev;
-	int rc;
-
-	if (!map_name)
-		return -EINVAL;
-
-	ir_codes = get_rc_map(map_name);
-	if (!ir_codes)
-		return -EINVAL;
+#define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
-	rc = __ir_input_register(dev, ir_codes, props, driver_name);
-	if (rc < 0)
-		return -EINVAL;
-
-	ir_dev = input_get_drvdata(dev);
-
-	if (!rc && ir_dev->props && ir_dev->props->change_protocol)
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    ir_codes->ir_type);
-
-	return rc;
-}
-
-void ir_input_unregister(struct input_dev *input_dev);
-
-void ir_repeat(struct input_dev *dev);
-void ir_keyup(struct input_dev *dev);
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
-void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle);
-u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
+void ir_repeat(struct rc_dev *dev);
+void ir_keyup(struct rc_dev *dev);
+void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle);
+void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
+u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
 
 struct ir_raw_event {
 	unsigned                        pulse:1;
@@ -140,14 +119,19 @@ struct ir_raw_event {
 
 #define IR_MAX_DURATION                 0x7FFFFFFF      /* a bit more than 2 seconds */
 
-void ir_raw_event_handle(struct input_dev *input_dev);
-int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
-static inline void ir_raw_event_reset(struct input_dev *input_dev)
+void ir_raw_event_handle(struct rc_dev *dev);
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
 	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
-	ir_raw_event_store(input_dev, &ev);
-	ir_raw_event_handle(input_dev);
+	ir_raw_event_store(dev, &ev);
+	ir_raw_event_handle(dev);
 }
 
+struct rc_dev *rc_allocate_device(void);
+void rc_free_device(struct rc_dev *dev);
+int rc_register_device(struct rc_dev *dev);
+void rc_unregister_device(struct rc_dev *dev);
+
 #endif /* _IR_CORE */
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 328ca88..284be03 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -9,7 +9,7 @@ struct IR_i2c {
 	char		       *ir_codes;
 
 	struct i2c_client      *c;
-	struct input_dev       *input;
+	struct rc_dev          *rc;
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 

