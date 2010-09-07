Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56271 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab0IGVwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 17:52:19 -0400
Subject: [PATCH 4/5] rc-core: make struct rc_dev the primary interface for rc
	drivers
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jarod@redhat.com
Date: Tue, 07 Sep 2010 23:51:59 +0200
Message-ID: <20100907215159.30935.42677.stgit@localhost.localdomain>
In-Reply-To: <20100907214943.30935.29895.stgit@localhost.localdomain>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ene_ir.c                   |  121 ++---
 drivers/media/IR/ene_ir.h                   |    3 
 drivers/media/IR/imon.c                     |   54 +-
 drivers/media/IR/ir-core-priv.h             |   10 
 drivers/media/IR/ir-jvc-decoder.c           |   13 
 drivers/media/IR/ir-lirc-codec.c            |  111 ++--
 drivers/media/IR/ir-nec-decoder.c           |   15 -
 drivers/media/IR/ir-rc5-decoder.c           |   13 
 drivers/media/IR/ir-rc5-sz-decoder.c        |   13 
 drivers/media/IR/ir-rc6-decoder.c           |   17 -
 drivers/media/IR/ir-sony-decoder.c          |   11 
 drivers/media/IR/mceusb.c                   |   93 +--
 drivers/media/IR/rc-core.c                  |  726 ++++++++++++---------------
 drivers/media/IR/streamzap.c                |   68 +--
 drivers/media/dvb/dm1105/dm1105.c           |   40 +
 drivers/media/dvb/dvb-usb/dib0700.h         |    2 
 drivers/media/dvb/dvb-usb/dib0700_core.c    |   11 
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  116 +---
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c  |   78 ++-
 drivers/media/dvb/dvb-usb/dvb-usb.h         |   12 
 drivers/media/dvb/mantis/mantis_common.h    |    4 
 drivers/media/dvb/mantis/mantis_input.c     |   74 ++-
 drivers/media/dvb/siano/smscoreapi.c        |    2 
 drivers/media/dvb/siano/smsir.c             |   52 +-
 drivers/media/dvb/siano/smsir.h             |    3 
 drivers/media/dvb/ttpci/budget-ci.c         |   49 +-
 drivers/media/video/bt8xx/bttv-input.c      |   41 +-
 drivers/media/video/cx23885/cx23885-input.c |   64 +-
 drivers/media/video/cx23885/cx23885.h       |    3 
 drivers/media/video/cx88/cx88-input.c       |   78 +--
 drivers/media/video/em28xx/em28xx-input.c   |   72 +--
 drivers/media/video/ir-kbd-i2c.c            |   25 +
 drivers/media/video/saa7134/saa7134-input.c |   72 +--
 drivers/staging/tm6000/tm6000-input.c       |   87 +--
 include/media/ir-common.h                   |    3 
 include/media/ir-core.h                     |  192 +++----
 include/media/ir-kbd-i2c.h                  |    2 
 37 files changed, 1069 insertions(+), 1281 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 5447750..48b128e 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -263,13 +263,13 @@ static void ene_rx_set_inputs(struct ene_device *dev)
 			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
 
 	if (dev->rx_fan_input_inuse) {
-		dev->props->rx_resolution = ENE_SAMPLE_PERIOD_FAN * 1000;
+		dev->rc->rx_resolution = ENE_SAMPLE_PERIOD_FAN * 1000;
 
-		dev->props->timeout =
+		dev->rc->timeout =
 			ENE_FAN_VALUE_MASK * ENE_SAMPLE_PERIOD_FAN * 1000;
 	} else {
-		dev->props->rx_resolution = sample_period * 1000;
-		dev->props->timeout = ENE_MAXGAP * 1000;
+		dev->rc->rx_resolution = sample_period * 1000;
+		dev->rc->timeout = ENE_MAXGAP * 1000;
 	}
 }
 
@@ -305,8 +305,8 @@ static void ene_rx_enable(struct ene_device *dev)
 			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
 
 	/* enter idle mode */
-	ir_raw_event_set_idle(dev->idev, 1);
-	ir_raw_event_reset(dev->idev);
+	ir_raw_event_set_idle(dev->rc, 1);
+	ir_raw_event_reset(dev->rc);
 
 }
 
@@ -322,8 +322,8 @@ static void ene_rx_disable(struct ene_device *dev)
 	/* disable hardware IRQ and firmware flag */
 	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
 
-	ir_raw_event_set_idle(dev->idev, 1);
-	ir_raw_event_reset(dev->idev);
+	ir_raw_event_set_idle(dev->rc, 1);
+	ir_raw_event_reset(dev->rc);
 }
 
 
@@ -561,7 +561,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 #if 0
 	/* TODO */
 	if (dev->carrier_detect_enabled && carrier)
-		ir_raw_event_report_frequency(dev->idev, carrier);
+		ir_raw_event_report_frequency(dev->rc, carrier);
 #endif
 
 	for (i = 0; i < ENE_SAMPLES_SIZE; i++) {
@@ -598,10 +598,10 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 		ev.duration = hw_sample * 1000;
 		ev.pulse = pulse;
-		ir_raw_event_store_with_filter(dev->idev, &ev);
+		ir_raw_event_store_with_filter(dev->rc, &ev);
 	}
 
-	ir_raw_event_handle(dev->idev);
+	ir_raw_event_handle(dev->rc);
 unlock:
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 	return retval;
@@ -624,9 +624,9 @@ static void ene_setup_settings(struct ene_device *dev)
 }
 
 /* outside interface: called on first open*/
-static int ene_open(void *data)
+static int ene_open(struct rc_dev *rc)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
@@ -638,9 +638,9 @@ static int ene_open(void *data)
 }
 
 /* outside interface: called on device close*/
-static void ene_close(void *data)
+static void ene_close(struct rc_dev *rc)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
@@ -650,9 +650,9 @@ static void ene_close(void *data)
 }
 
 /* outside interface: set transmitter mask */
-static int ene_set_tx_mask(void *data, u32 tx_mask)
+static int ene_set_tx_mask(struct rc_dev *rc, u32 tx_mask)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 	ene_dbg("TX: attempt to set transmitter mask %02x", tx_mask);
 
@@ -670,9 +670,9 @@ static int ene_set_tx_mask(void *data, u32 tx_mask)
 }
 
 /* outside interface : set tx carrier */
-static int ene_set_tx_carrier(void *data, u32 carrier)
+static int ene_set_tx_carrier(struct rc_dev *rc, u32 carrier)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 	u32 period = 1000000 / carrier; /* (1 / freq) (* # usec in 1 sec) */
 
@@ -698,9 +698,9 @@ static int ene_set_tx_carrier(void *data, u32 carrier)
 
 
 /* outside interface: enable learning mode */
-static int ene_set_learning_mode(void *data, int enable)
+static int ene_set_learning_mode(struct rc_dev *rc, int enable)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 	if (enable == dev->learning_enabled)
 		return 0;
@@ -713,18 +713,17 @@ static int ene_set_learning_mode(void *data, int enable)
 }
 
 /* outside interface: set rec carrier */
-static int ene_set_rec_carrier(void *data, u32 min, u32 max)
+static int ene_set_rec_carrier(struct rc_dev *rc, u32 min, u32 max)
 {
-	struct ene_device *dev = (struct ene_device *)data;
-	ene_set_learning_mode(dev,
+	ene_set_learning_mode(rc,
 		max > ENE_NORMAL_RX_HI || min < ENE_NORMAL_RX_LOW);
 	return 0;
 }
 
 /* outside interface: enable or disable idle mode */
-static void ene_rx_set_idle(void *data, int idle)
+static void ene_rx_set_idle(struct rc_dev *rc, int idle)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	ene_dbg("%sabling idle mode", idle ? "en" : "dis");
 
 	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
@@ -734,9 +733,9 @@ static void ene_rx_set_idle(void *data, int idle)
 
 
 /* outside interface: transmit */
-static int ene_transmit(void *data, int *buf, u32 n)
+static int ene_transmit(struct rc_dev *rc, int *buf, u32 n)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = (struct ene_device *)rc->priv;
 	unsigned long flags;
 
 	dev->tx_buffer = buf;
@@ -775,17 +774,15 @@ static int ene_transmit(void *data, int *buf, u32 n)
 static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 {
 	int error = -ENOMEM;
-	struct ir_dev_props *ir_props;
-	struct input_dev *input_dev;
+	struct rc_dev *rc;
 	struct ene_device *dev;
 
 	/* allocate memory */
-	input_dev = input_allocate_device();
-	ir_props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
+	rc = rc_allocate_device();
 
-	if (!input_dev || !ir_props || !dev)
-		goto error;
+	if (!dev || !rc)
+		goto error_free;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -828,21 +825,22 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 			"Simulation of TX activated\n");
 	}
 
-	ir_props->driver_type = RC_DRIVER_IR_RAW;
-	ir_props->allowed_protos = IR_TYPE_ALL;
-	ir_props->priv = dev;
-	ir_props->open = ene_open;
-	ir_props->close = ene_close;
-	ir_props->min_timeout = ENE_MINGAP * 1000;
-	ir_props->max_timeout = ENE_MAXGAP * 1000;
-	ir_props->timeout = ENE_MAXGAP * 1000;
+	rc->driver_name = ENE_DRIVER_NAME;
+	rc->map_name = RC_MAP_RC6_MCE;
+	rc->driver_type = RC_DRIVER_IR_RAW;
+	rc->allowed_protos = IR_TYPE_ALL;
+	rc->priv = dev;
+	rc->open = ene_open;
+	rc->close = ene_close;
+	rc->min_timeout = ENE_MINGAP * 1000;
+	rc->max_timeout = ENE_MAXGAP * 1000;
+	rc->timeout = ENE_MAXGAP * 1000;
 
 	if (dev->hw_revision == ENE_HW_B)
-		ir_props->s_idle = ene_rx_set_idle;
+		rc->s_idle = ene_rx_set_idle;
 
 
-	dev->props = ir_props;
-	dev->idev = input_dev;
+	dev->rc = rc;
 
 	/* don't allow too short/long sample periods */
 	if (sample_period < 5 || sample_period > 0x7F)
@@ -859,21 +857,21 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 			sample_period = 75;
 	}
 
-	ir_props->rx_resolution = sample_period * 1000;
+	rc->rx_resolution = sample_period * 1000;
 
 	if (dev->hw_learning_and_tx_capable) {
 
-		ir_props->s_learning_mode = ene_set_learning_mode;
+		rc->s_learning_mode = ene_set_learning_mode;
 
 		if (input == 0)
-			ir_props->s_rx_carrier_range = ene_set_rec_carrier;
+			rc->s_rx_carrier_range = ene_set_rec_carrier;
 
 		init_completion(&dev->tx_complete);
-		ir_props->tx_ir = ene_transmit;
-		ir_props->s_tx_mask = ene_set_tx_mask;
-		ir_props->s_tx_carrier = ene_set_tx_carrier;
-		ir_props->tx_resolution = ENE_TX_SMPL_PERIOD * 1000;
-		/* ir_props->s_carrier_report = ene_set_carrier_report; */
+		rc->tx_ir = ene_transmit;
+		rc->s_tx_mask = ene_set_tx_mask;
+		rc->s_tx_carrier = ene_set_tx_carrier;
+		rc->tx_resolution = ENE_TX_SMPL_PERIOD * 1000;
+		/* rc->s_carrier_report = ene_set_carrier_report; */
 	}
 
 
@@ -881,17 +879,15 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	device_set_wakeup_enable(&pnp_dev->dev, 1);
 
 	if (dev->hw_learning_and_tx_capable)
-		input_dev->name = "ENE eHome Infrared Remote Transceiver";
+		dev->rc->input_name = "ENE eHome Infrared Remote Transceiver";
 	else
-		input_dev->name = "ENE eHome Infrared Remote Receiver";
+		dev->rc->input_name = "ENE eHome Infrared Remote Receiver";
 
 
-	error = -ENODEV;
-	if (ir_input_register(input_dev, RC_MAP_RC6_MCE, ir_props,
-							ENE_DRIVER_NAME))
+	error = rc_register_device(rc);
+	if (error)
 		goto error;
 
-
 	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
 	return 0;
 error:
@@ -900,8 +896,8 @@ error:
 	if (dev->hw_io)
 		release_region(dev->hw_io, ENE_MAX_IO);
 
-	input_free_device(input_dev);
-	kfree(ir_props);
+error_free:
+	rc_free_device(rc);
 	kfree(dev);
 	return error;
 }
@@ -918,8 +914,7 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_MAX_IO);
-	ir_input_unregister(dev->idev);
-	kfree(dev->props);
+	rc_unregister_device(dev->rc);
 	kfree(dev);
 }
 
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
index 54c76af..3414211 100644
--- a/drivers/media/IR/ene_ir.h
+++ b/drivers/media/IR/ene_ir.h
@@ -189,8 +189,7 @@
 
 struct ene_device {
 	struct pnp_dev *pnp_dev;
-	struct input_dev *idev;
-	struct ir_dev_props *props;
+	struct rc_dev *rc;
 	int in_use;
 
 	/* hw IO settings */
diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index e1e0ca1..69352f5 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -86,7 +86,6 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 struct imon_context {
 	struct device *dev;
-	struct ir_dev_props *props;
 	/* Newer devices have two interfaces */
 	struct usb_device *usbdev_intf0;
 	struct usb_device *usbdev_intf1;
@@ -121,7 +120,7 @@ struct imon_context {
 	u16 vendor;			/* usb vendor ID */
 	u16 product;			/* usb product ID */
 
-	struct input_dev *rdev;		/* input device for remote */
+	struct rc_dev *rdev;		/* rc device for remote */
 	struct input_dev *idev;		/* input device for front panel/knob and
 					 * remote (fake) mouse
 					 */
@@ -983,16 +982,16 @@ static void imon_touch_display_timeout(unsigned long data)
  * really just RC-6), but only one or the other at a time, as the signals
  * are decoded onboard the receiver.
  */
-int imon_ir_change_protocol(void *priv, u64 ir_type)
+int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 {
 	int retval;
-	struct imon_context *ictx = priv;
+	struct imon_context *ictx = rc->priv;
 	struct device *dev = ictx->dev;
 	bool pad_mouse;
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (ir_type && !(ir_type & ictx->props->allowed_protos))
+	if (ir_type && !(ir_type & ictx->rdev->allowed_protos))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
@@ -1653,15 +1652,13 @@ static void usb_rx_callback_intf1(struct urb *urb)
 	usb_submit_urb(ictx->rx_urb_intf1, GFP_ATOMIC);
 }
 
-static struct input_dev *imon_init_rdev(struct imon_context *ictx)
+static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 {
-	struct input_dev *rdev;
-	struct ir_dev_props *props;
+	struct rc_dev *rdev;
 	int ret;
 
-	rdev = input_allocate_device();
-	props = kzalloc(sizeof(*props), GFP_KERNEL);
-	if (!rdev || !props) {
+	rdev = rc_allocate_device();
+	if (!rdev) {
 		dev_err(ictx->dev, "remote control dev allocation failed\n");
 		goto out;
 	}
@@ -1672,20 +1669,18 @@ static struct input_dev *imon_init_rdev(struct imon_context *ictx)
 		      sizeof(ictx->phys_rdev));
 	strlcat(ictx->phys_rdev, "/input0", sizeof(ictx->phys_rdev));
 
-	rdev->name = ictx->name_rdev;
-	rdev->phys = ictx->phys_rdev;
-	usb_to_input_id(ictx->usbdev_intf0, &rdev->id);
+	rdev->input_name = ictx->name_rdev;
+	rdev->input_phys = ictx->phys_rdev;
+	usb_to_input_id(ictx->usbdev_intf0, &rdev->input_id);
 	rdev->dev.parent = ictx->dev;
-	rdev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	input_set_drvdata(rdev, ictx);
-
-	props->priv = ictx;
-	props->driver_type = RC_DRIVER_SCANCODE;
-	props->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6; /* iMON PAD or MCE */
-	props->change_protocol = imon_ir_change_protocol;
-	ictx->props = props;
-
-	ret = ir_input_register(rdev, RC_MAP_IMON_PAD, props, MOD_NAME);
+	rdev->priv = ictx;
+	rdev->driver_type = RC_DRIVER_SCANCODE;
+	rdev->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6; /* iMON PAD or MCE */
+	rdev->change_protocol = imon_ir_change_protocol;
+	rdev->driver_name = MOD_NAME;
+	rdev->map_name = RC_MAP_IMON_PAD;
+
+	ret = rc_register_device(rdev);
 	if (ret < 0) {
 		dev_err(ictx->dev, "remote input dev register failed\n");
 		goto out;
@@ -1694,8 +1689,7 @@ static struct input_dev *imon_init_rdev(struct imon_context *ictx)
 	return rdev;
 
 out:
-	kfree(props);
-	input_free_device(rdev);
+	rc_free_device(rdev);
 	return NULL;
 }
 
@@ -1966,7 +1960,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	return ictx;
 
 urb_submit_failed:
-	ir_input_unregister(ictx->rdev);
+	rc_unregister_device(ictx->rdev);
 rdev_setup_failed:
 	input_unregister_device(ictx->idev);
 idev_setup_failed:
@@ -2105,7 +2099,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
 
 	ictx->display_type = detected_display_type;
-	ictx->props->allowed_protos = allowed_protos;
+	ictx->rdev->allowed_protos = allowed_protos;
 	ictx->ir_type = allowed_protos;
 }
 
@@ -2268,7 +2262,7 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	}
 
 	/* set IR protocol/remote type */
-	ret = imon_ir_change_protocol(ictx, ictx->ir_type);
+	ret = imon_ir_change_protocol(ictx->rdev, ictx->ir_type);
 	if (ret) {
 		dev_warn(dev, "%s: failed to set IR protocol, falling back "
 			 "to standard iMON protocol mode\n", __func__);
@@ -2330,7 +2324,7 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 		ictx->dev_present_intf0 = false;
 		usb_kill_urb(ictx->rx_urb_intf0);
 		input_unregister_device(ictx->idev);
-		ir_input_unregister(ictx->rdev);
+		rc_unregister_device(ictx->rdev);
 		if (ictx->display_supported) {
 			if (ictx->display_type == IMON_DISPLAY_TYPE_LCD)
 				usb_deregister_dev(interface, &imon_lcd_class);
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index c1b1a25..22c8dff 100644
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
@@ -83,7 +83,7 @@ struct ir_raw_event_ctrl {
 		unsigned wanted_bits;
 	} rc5_sz;
 	struct lirc_codec {
-		struct ir_input_dev *ir_dev;
+		struct rc_dev *dev;
 		struct lirc_driver *drv;
 		int carrier_low;
 	} lirc;
diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
index 77a89c4..8c01837 100644
--- a/drivers/media/IR/ir-jvc-decoder.c
+++ b/drivers/media/IR/ir-jvc-decoder.c
@@ -37,17 +37,16 @@ enum jvc_state {
 
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
@@ -139,12 +138,12 @@ again:
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
index 77b5946..6d132c6 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -24,20 +24,19 @@
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
 	int sample;
 
-	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
+	if (!(dev->raw->enabled_protocols & IR_TYPE_LIRC))
 		return 0;
 
-	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
+	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
 	if (IS_RESET(ev))
@@ -50,10 +49,8 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (ev.pulse)
 		sample |= PULSE_BIT;
 
-	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
-			  (unsigned char *) &sample);
-	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
-
+	lirc_buffer_write(dev->raw->lirc.drv->rbuf, (unsigned char *)&sample);
+	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
 
 	return 0;
 }
@@ -62,7 +59,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 				   size_t n, loff_t *ppos)
 {
 	struct lirc_codec *lirc;
-	struct ir_input_dev *ir_dev;
+	struct rc_dev *dev;
 	int *txbuf; /* buffer with values to transmit */
 	int ret = 0, count;
 
@@ -81,14 +78,14 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 	if (IS_ERR(txbuf))
 		return PTR_ERR(txbuf);
 
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
+		ret = dev->tx_ir(dev, txbuf, (u32)n);
 
 out:
 	kfree(txbuf);
@@ -99,21 +96,18 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			unsigned long __user arg)
 {
 	struct lirc_codec *lirc;
-	struct ir_input_dev *ir_dev;
+	struct rc_dev *dev;
 	int ret = 0;
-	void *drv_data;
 	unsigned long val = 0;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
 		return -EFAULT;
 
-	ir_dev = lirc->ir_dev;
-	if (!ir_dev || !ir_dev->props || !ir_dev->props->priv)
+	dev = lirc->dev;
+	if (!dev || !dev->priv)
 		return -EFAULT;
 
-	drv_data = ir_dev->props->priv;
-
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, (unsigned long *)arg);
 		if (ret)
@@ -134,77 +128,76 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
-		if (ir_dev->props->s_tx_mask)
-			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
+		if (dev->s_tx_mask)
+			ret = dev->s_tx_mask(dev, (u32)val);
 		else
 			return -EINVAL;
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
-		if (ir_dev->props->s_tx_carrier)
-			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
+		if (dev->s_tx_carrier)
+			dev->s_tx_carrier(dev, (u32)val);
 		else
 			return -EINVAL;
 		break;
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
-		if (!ir_dev->props->s_tx_duty_cycle)
+		if (!dev->s_tx_duty_cycle)
 			return -ENOSYS;
 
 		if (val <= 0 || val >= 100)
 			return -EINVAL;
 
-		ir_dev->props->s_tx_duty_cycle(ir_dev->props->priv, val);
+		dev->s_tx_duty_cycle(dev, val);
 		break;
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
-		if (ir_dev->props->s_rx_carrier_range)
-			ret = ir_dev->props->s_rx_carrier_range(
-				ir_dev->props->priv,
-				ir_dev->raw->lirc.carrier_low, val);
+		if (dev->s_rx_carrier_range)
+			ret = dev->s_rx_carrier_range(dev,
+						      dev->raw->lirc.carrier_low,
+						      val);
 		else
 			return -ENOSYS;
 
 		if (!ret)
-			ir_dev->raw->lirc.carrier_low = 0;
+			dev->raw->lirc.carrier_low = 0;
 		break;
 
 	case LIRC_SET_REC_CARRIER_RANGE:
 		if (val >= 0)
-			ir_dev->raw->lirc.carrier_low = val;
+			dev->raw->lirc.carrier_low = val;
 		break;
 
 
 	case LIRC_GET_REC_RESOLUTION:
-		val = ir_dev->props->rx_resolution;
+		val = dev->rx_resolution;
 		break;
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
-		if (ir_dev->props->s_learning_mode)
-			return ir_dev->props->s_learning_mode(
-				ir_dev->props->priv, !!val);
+		if (dev->s_learning_mode)
+			return dev->s_learning_mode(dev, !!val);
 		else
 			return -ENOSYS;
 
 	/* Generic timeout support */
 	case LIRC_GET_MIN_TIMEOUT:
-		if (!ir_dev->props->max_timeout)
+		if (!dev->min_timeout)
 			return -ENOSYS;
-		val = ir_dev->props->min_timeout / 1000;
+		val = dev->min_timeout / 1000;
 		break;
 
 	case LIRC_GET_MAX_TIMEOUT:
-		if (!ir_dev->props->max_timeout)
+		if (!dev->max_timeout)
 			return -ENOSYS;
-		val = ir_dev->props->max_timeout / 1000;
+		val = dev->max_timeout / 1000;
 		break;
 
 	case LIRC_SET_REC_TIMEOUT:
-		if (val < ir_dev->props->min_timeout ||
-		    val > ir_dev->props->max_timeout)
+		if (val < dev->min_timeout ||
+		    val > dev->max_timeout)
 			return -EINVAL;
-		ir_dev->props->timeout = val * 1000;
+		dev->timeout = val * 1000;
 		break;
 
 	default:
@@ -237,9 +230,8 @@ static struct file_operations lirc_fops = {
 	.release	= lirc_dev_fop_close,
 };
 
-static int ir_lirc_register(struct input_dev *input_dev)
+static int ir_lirc_register(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct lirc_driver *drv;
 	struct lirc_buffer *rbuf;
 	int rc = -ENOMEM;
@@ -258,40 +250,40 @@ static int ir_lirc_register(struct input_dev *input_dev)
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
 
-		if (ir_dev->props->s_tx_duty_cycle)
+		if (dev->s_tx_duty_cycle)
 			features |= LIRC_CAN_SET_REC_DUTY_CYCLE;
 	}
 
-	if (ir_dev->props->s_rx_carrier_range)
+	if (dev->s_rx_carrier_range)
 		features |= LIRC_CAN_SET_REC_CARRIER |
 			LIRC_CAN_SET_REC_CARRIER_RANGE;
 
-	if (ir_dev->props->s_learning_mode)
+	if (dev->s_learning_mode)
 		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
 
-	if (ir_dev->props->max_timeout)
+	if (dev->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
 
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
@@ -300,8 +292,8 @@ static int ir_lirc_register(struct input_dev *input_dev)
 		goto lirc_register_failed;
 	}
 
-	ir_dev->raw->lirc.drv = drv;
-	ir_dev->raw->lirc.ir_dev = ir_dev;
+	dev->raw->lirc.drv = drv;
+	dev->raw->lirc.dev = dev;
 	return 0;
 
 lirc_register_failed:
@@ -313,10 +305,9 @@ rbuf_alloc_failed:
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
index d597421..5dc7fb5 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -39,19 +39,18 @@ enum nec_state {
 
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
@@ -88,7 +87,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			ir_repeat(input_dev);
+			ir_repeat(dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
 			return 0;
@@ -114,7 +113,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 			geq_margin(ev.duration,
 			NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
 				IR_dprintk(1, "Repeat last key\n");
-				ir_repeat(input_dev);
+				ir_repeat(dev);
 				data->state = STATE_INACTIVE;
 				return 0;
 
@@ -178,7 +177,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
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
diff --git a/drivers/media/IR/ir-rc5-sz-decoder.c b/drivers/media/IR/ir-rc5-sz-decoder.c
index 68f11d6..8a14229 100644
--- a/drivers/media/IR/ir-rc5-sz-decoder.c
+++ b/drivers/media/IR/ir-rc5-sz-decoder.c
@@ -36,19 +36,18 @@ enum rc5_sz_state {
 
 /**
  * ir_rc5_sz_decode() - Decode one RC-5 Streamzap pulse or space
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_sz_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct rc5_sz_dec *data = &ir_dev->raw->rc5_sz;
+	struct rc5_sz_dec *data = &dev->raw->rc5_sz;
 	u8 toggle, command, system;
 	u32 scancode;
 
-        if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5_SZ))
+        if (!(dev->raw->enabled_protocols & IR_TYPE_RC5_SZ))
                 return 0;
 
 	if (IS_RESET(ev)) {
@@ -90,7 +89,7 @@ again:
 		return 0;
 
 	case STATE_BIT_END:
-		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
+		if (!is_transition(&ev, &dev->raw->prev_ev))
 			break;
 
 		if (data->count == data->wanted_bits)
@@ -114,7 +113,7 @@ again:
 		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
 			   scancode, toggle);
 
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
index bc620e1..c53aa8c 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -38,7 +38,6 @@
 #include <linux/usb.h>
 #include <linux/input.h>
 #include <media/ir-core.h>
-#include <media/ir-common.h>
 
 #define DRIVER_VERSION	"1.91"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
@@ -231,13 +230,12 @@ static struct usb_device_id std_tx_mask_list[] = {
 
 /* data structure for each usb transceiver */
 struct mceusb_dev {
-	/* ir-core bits */
-	struct ir_dev_props *props;
+	/* rc-core bits */
+	struct rc_dev *rc;
 	struct ir_raw_event rawir;
 
 	/* core device bits */
 	struct device *dev;
-	struct input_dev *idev;
 
 	/* usb */
 	struct usb_device *usbdev;
@@ -518,9 +516,9 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 }
 
 /* Send data out the IR blaster port(s) */
-static int mceusb_tx_ir(void *priv, int *txbuf, u32 n)
+static int mceusb_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
 {
-	struct mceusb_dev *ir = priv;
+	struct mceusb_dev *ir = dev->priv;
 	int i, ret = 0;
 	int count, cmdcount = 0;
 	unsigned char *cmdbuf; /* MCE command buffer */
@@ -603,9 +601,9 @@ out:
 }
 
 /* Sets active IR outputs -- mce devices typically (all?) have two */
-static int mceusb_set_tx_mask(void *priv, u32 mask)
+static int mceusb_set_tx_mask(struct rc_dev *dev, u32 mask)
 {
-	struct mceusb_dev *ir = priv;
+	struct mceusb_dev *ir = dev->priv;
 
 	if (ir->flags.tx_mask_inverted)
 		ir->tx_mask = (mask != 0x03 ? mask ^ 0x03 : mask) << 1;
@@ -616,9 +614,9 @@ static int mceusb_set_tx_mask(void *priv, u32 mask)
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
@@ -710,14 +708,14 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
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
 
@@ -860,24 +858,16 @@ static void mceusb_get_parameters(struct mceusb_dev *ir)
 	mce_sync_in(ir, NULL, maxp);
 }
 
-static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
+static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 {
-	struct input_dev *idev;
-	struct ir_dev_props *props;
 	struct device *dev = ir->dev;
-	int ret = -ENODEV;
-
-	idev = input_allocate_device();
-	if (!idev) {
-		dev_err(dev, "remote input dev allocation failed\n");
-		goto idev_alloc_failed;
-	}
+	struct rc_dev *rc;
+	int ret;
 
-	ret = -ENOMEM;
-	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
-	if (!props) {
-		dev_err(dev, "remote ir dev props allocation failed\n");
-		goto props_alloc_failed;
+	rc = rc_allocate_device();
+	if (!rc) {
+		dev_err(dev, "remote dev allocation failed\n");
+		goto out;
 	}
 
 	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
@@ -885,33 +875,30 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
 
-	idev->name = ir->name;
 	usb_make_path(ir->usbdev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
-	idev->phys = ir->phys;
 
-	props->priv = ir;
-	props->driver_type = RC_DRIVER_IR_RAW;
-	props->allowed_protos = IR_TYPE_ALL;
-	props->s_tx_mask = mceusb_set_tx_mask;
-	props->s_tx_carrier = mceusb_set_tx_carrier;
-	props->tx_ir = mceusb_tx_ir;
-
-	ir->props = props;
-
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
-		dev_err(dev, "remote input device register failed\n");
-		goto irdev_failed;
+		dev_err(dev, "remote dev registration failed\n");
+		goto out;
 	}
 
-	return idev;
+	return rc;
 
-irdev_failed:
-	kfree(props);
-props_alloc_failed:
-	input_free_device(idev);
-idev_alloc_failed:
+out:
+	rc_free_device(rc);
 	return NULL;
 }
 
@@ -1012,9 +999,9 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	ir->idev = mceusb_init_input_dev(ir);
-	if (!ir->idev)
-		goto input_dev_fail;
+	ir->rc = mceusb_init_rc_dev(ir);
+	if (!ir->rc)
+		goto rc_dev_fail;
 
 	/* flush buffers on the device */
 	mce_sync_in(ir, NULL, maxp);
@@ -1034,7 +1021,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mceusb_get_parameters(ir);
 
-	mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
+	mceusb_set_tx_mask(ir->rc, MCE_DEFAULT_TX_MASK);
 
 	usb_set_intfdata(intf, ir);
 
@@ -1044,7 +1031,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	return 0;
 
 	/* Error-handling path */
-input_dev_fail:
+rc_dev_fail:
 	usb_free_urb(ir->urb_in);
 urb_in_alloc_fail:
 	usb_free_coherent(dev, maxp, ir->buf_in, ir->dma_in);
@@ -1068,7 +1055,7 @@ static void __devexit mceusb_dev_disconnect(struct usb_interface *intf)
 		return;
 
 	ir->usbdev = NULL;
-	ir_input_unregister(ir->idev);
+	rc_unregister_device(ir->rc);
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
diff --git a/drivers/media/IR/rc-core.c b/drivers/media/IR/rc-core.c
index 1f441a6..737a694 100644
--- a/drivers/media/IR/rc-core.c
+++ b/drivers/media/IR/rc-core.c
@@ -24,11 +24,6 @@
 #include <linux/device.h>
 #include "ir-core-priv.h"
 
-#define IRRCV_NUM_DEVICES	256
-
-/* bit array to represent IR sysfs device number */
-static unsigned long ir_core_dev_number;
-
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
@@ -56,10 +51,6 @@ static struct work_struct wq_load;
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
-/* Forward declarations */
-static int ir_register_class(struct input_dev *input_dev);
-static void ir_unregister_class(struct input_dev *input_dev);
-
 static struct rc_keymap *seek_rc_map(const char *name)
 {
 	struct rc_keymap *map = NULL;
@@ -149,7 +140,7 @@ static int ir_raw_event_thread(void *data)
 
 		while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
 			list_for_each_entry(handler, &ir_raw_handler_list, list)
-				handler->decode(raw->input_dev, ev);
+				handler->decode(raw->dev, ev);
 			raw->prev_ev = ev;
 		}
 
@@ -164,7 +155,7 @@ static int ir_raw_event_thread(void *data)
 
 /**
  * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This routine (which may be called from an interrupt context) stores a
@@ -172,17 +163,15 @@ static int ir_raw_event_thread(void *data)
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
 
 	IR_dprintk(2, "sample: (05%dus %s)\n",
 		TO_US(ev->duration), TO_STR(ev->pulse));
 
-	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
 		return -ENOMEM;
 
 	return 0;
@@ -191,7 +180,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
 
 /**
  * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @type:	the type of the event that has occurred
  *
  * This routine (which may be called from an interrupt context) is used to
@@ -200,50 +189,49 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
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
  * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
- * @input_dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @type:	the type of the event that has occurred
  *
  * This routine (which may be called from an interrupt context) works
@@ -251,49 +239,43 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
  * This routine is intended for devices with limited internal buffer
  * It automerges samples of same type, and handles timeouts
  */
-int ir_raw_event_store_with_filter(struct input_dev *input_dev,
-						struct ir_raw_event *ev)
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_event_ctrl *raw = ir->raw;
+	struct ir_raw_event_ctrl *raw = dev->raw;
 
-	if (!raw || !ir->props)
+	if (!raw)
 		return -EINVAL;
 
 	/* Ignore spaces in idle mode */
-	if (ir->idle && !ev->pulse)
+	if (dev->idle && !ev->pulse)
 		return 0;
-	else if (ir->idle)
-		ir_raw_event_set_idle(input_dev, 0);
+	else if (dev->idle)
+		ir_raw_event_set_idle(dev, 0);
 
 	if (!raw->this_ev.duration) {
 		raw->this_ev = *ev;
 	} else if (ev->pulse == raw->this_ev.pulse) {
 		raw->this_ev.duration += ev->duration;
 	} else {
-		ir_raw_event_store(input_dev, &raw->this_ev);
+		ir_raw_event_store(dev, &raw->this_ev);
 		raw->this_ev = *ev;
 	}
 
 	/* Enter idle mode if nessesary */
-	if (!ev->pulse && ir->props->timeout &&
-		raw->this_ev.duration >= ir->props->timeout)
-		ir_raw_event_set_idle(input_dev, 1);
+	if (!ev->pulse && dev->timeout &&
+		raw->this_ev.duration >= dev->timeout)
+		ir_raw_event_set_idle(dev, 1);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
 
-void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
+void ir_raw_event_set_idle(struct rc_dev *dev, int idle)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_event_ctrl *raw = ir->raw;
+	struct ir_raw_event_ctrl *raw = dev->raw;
 	ktime_t now;
 	u64 delta;
 
-	if (!ir->props)
-		return;
-
-	if (!ir->raw)
+	if (!raw)
 		goto out;
 
 	if (idle) {
@@ -303,7 +285,7 @@ void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
 		IR_dprintk(2, "exit idle mode\n");
 
 		now = ktime_get();
-		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
+		delta = ktime_to_ns(ktime_sub(now, raw->last_event));
 
 		WARN_ON(raw->this_ev.pulse);
 
@@ -311,112 +293,96 @@ void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
 			min(raw->this_ev.duration + delta,
 						(u64)IR_MAX_DURATION);
 
-		ir_raw_event_store(input_dev, &raw->this_ev);
+		ir_raw_event_store(dev, &raw->this_ev);
 
 		if (raw->this_ev.duration == IR_MAX_DURATION)
-			ir_raw_event_reset(input_dev);
+			ir_raw_event_reset(dev);
 
 		raw->this_ev.duration = 0;
 	}
 out:
-	if (ir->props->s_idle)
-		ir->props->s_idle(ir->props->priv, idle);
-	ir->idle = idle;
+	if (dev->s_idle)
+		dev->s_idle(dev, idle);
+	dev->idle = idle;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
 
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
+	if (!dev->raw)
 		return;
 
-	wake_up_process(ir->raw->thread);
+	wake_up_process(dev->raw->thread);
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
-/* used internally by the sysfs interface */
-static u64 ir_raw_get_allowed_protocols(void)
-{
-	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
-	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-	return protocols;
-}
-
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
-
-	ir->raw->enabled_protocols = ~0;
-	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
+	dev->raw->dev = dev;
+	dev->raw->enabled_protocols = ~0;
+	rc = kfifo_alloc(&dev->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
-	if (rc < 0) {
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return rc;
-	}
-
-	ir->raw->thread = kthread_run(ir_raw_event_thread, ir->raw,
-			"rc%u",  (unsigned int)ir->devno);
+	if (rc < 0)
+		goto out_free;
 
-	if (IS_ERR(ir->raw->thread)) {
-		int ret = PTR_ERR(ir->raw->thread);
+	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+				       "rc%u", (unsigned int)dev->devno);
 
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return ret;
+	if (IS_ERR(dev->raw->thread)) {
+		rc = PTR_ERR(dev->raw->thread);
+		goto out_free;
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir->raw->list, &ir_raw_client_list);
+	list_add_tail(&dev->raw->list, &ir_raw_client_list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_register)
-			handler->raw_register(ir->raw->input_dev);
+			handler->raw_register(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
+
+out_free:
+	kfree(dev->raw);
+	dev->raw = NULL;
+	return rc;
 }
 
-static void ir_raw_event_unregister(struct input_dev *input_dev)
+static void ir_raw_event_unregister(struct rc_dev *dev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 	struct ir_raw_handler *handler;
 
-	if (!ir->raw)
+	if (!dev->raw)
 		return;
 
-	kthread_stop(ir->raw->thread);
+	kthread_stop(dev->raw->thread);
 
 	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir->raw->list);
+	list_del(&dev->raw->list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
-			handler->raw_unregister(ir->raw->input_dev);
+			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
-	kfifo_free(&ir->raw->kfifo);
-	kfree(ir->raw);
-	ir->raw = NULL;
+	kfifo_free(&dev->raw->kfifo);
+	kfree(dev->raw);
+	dev->raw = NULL;
 }
 
 /*
@@ -431,7 +397,7 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->input_dev);
+			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 
@@ -447,7 +413,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	list_del(&ir_raw_handler->list);
 	if (ir_raw_handler->raw_unregister)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->input_dev);
+			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 }
@@ -529,7 +495,7 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 /**
  * ir_do_setkeycode() - internal function to set a keycode in the
  *			scancode->keycode table
- * @dev:	the struct input_dev device descriptor
+ * @dev:	the struct rc_dev device descriptor
  * @rc_tab:	the struct ir_scancode_table to set the keycode in
  * @scancode:	the scancode for the ir command
  * @keycode:	the keycode for the ir command
@@ -539,14 +505,13 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
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
@@ -555,9 +520,8 @@ static int ir_do_setkeycode(struct input_dev *dev,
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
@@ -598,16 +562,16 @@ static int ir_do_setkeycode(struct input_dev *dev,
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
@@ -618,20 +582,20 @@ static int ir_do_setkeycode(struct input_dev *dev,
 
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
@@ -641,19 +605,18 @@ static int ir_setkeycode(struct input_dev *dev,
 
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
@@ -671,21 +634,21 @@ static int ir_setkeytable(struct input_dev *dev,
 
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
@@ -713,7 +676,7 @@ static int ir_getkeycode(struct input_dev *dev,
 
 /**
  * ir_g_keycode_from_table() - gets the keycode that corresponds to a scancode
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode that we're seeking
  *
  * This routine is used by the input routines when a key is pressed at the
@@ -721,64 +684,64 @@ static int ir_getkeycode(struct input_dev *dev,
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
+			   dev->input_name ? dev->input_name : "unspecified device",
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
-	
+
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
@@ -791,43 +754,42 @@ static void ir_timer_keyup(unsigned long cookie)
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
 
-	input_event(dev, EV_MSC, MSC_SCAN, ir->last_scancode);
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 
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
- * @dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode of the keypress
  * @keycode:	the keycode of the keypress
  * @toggle:	the toggle value of the keypress
@@ -835,40 +797,38 @@ EXPORT_SYMBOL_GPL(ir_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct input_dev *dev, int scancode,
+static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
-	input_event(dev, EV_MSC, MSC_SCAN, scancode);
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
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
+		   dev->input_name, keycode, scancode);
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
@@ -877,27 +837,26 @@ static void ir_do_keydown(struct input_dev *dev, int scancode,
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
@@ -907,168 +866,31 @@ EXPORT_SYMBOL_GPL(ir_keydown);
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
+	struct rc_dev *dev = input_get_drvdata(input_dev);
 
-	ir_dev->props->close(ir_dev->props->priv);
+	return dev->close(dev);
 }
 
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
-		      struct ir_dev_props *props,
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
-	set_bit(EV_MSC, input_dev->evbit);
-	set_bit(MSC_SCAN, input_dev->mscbit);
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
-	if (ir_dev->props)
-		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
-			rc = ir_raw_event_register(input_dev);
-			if (rc < 0)
-				goto out_event;
-		}
-
-	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
-		   driver_name, rc_tab->name,
-		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
-			" in raw mode" : "");
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
-
-	if (!ir_dev)
-		return;
-
-	IR_dprintk(1, "Freed keycode table\n");
-
-	del_timer_sync(&ir_dev->timer_keyup);
-	if (ir_dev->props)
-		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
-			ir_raw_event_unregister(input_dev);
-
-	rc_tab = &ir_dev->rc_tab;
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
-
-	ir_unregister_class(input_dev);
-
-	kfree(ir_dev->driver_name);
-	kfree(ir_dev);
-}
-EXPORT_SYMBOL_GPL(ir_input_unregister);
-
 /* class for /sys/class/rc */
 static char *ir_devnode(struct device *dev, mode_t *mode)
 {
@@ -1098,7 +920,7 @@ static struct {
 
 /**
  * show_protocols() - shows the current IR protocol(s)
- * @d:		the device descriptor
+ * @device:	the device descriptor
  * @mattr:	the device attribute struct (unused)
  * @buf:	a pointer to the output buffer
  *
@@ -1107,20 +929,22 @@ static struct {
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  */
-static ssize_t show_protocols(struct device *d,
+static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct rc_dev *dev = to_rc_dev(device);
 	u64 allowed, enabled;
 	char *tmp = buf;
 	int i;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = ir_dev->rc_tab.ir_type;
-		allowed = ir_dev->props->allowed_protos;
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		enabled = dev->rc_tab.ir_type;
+		allowed = dev->allowed_protos;
 	} else {
-		enabled = ir_dev->raw->enabled_protocols;
-		allowed = ir_raw_get_allowed_protocols();
+		enabled = dev->raw->enabled_protocols;
+		mutex_lock(&ir_raw_handler_lock);
+		allowed = available_protocols;
+		mutex_unlock(&ir_raw_handler_lock);
 	}
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
@@ -1142,7 +966,7 @@ static ssize_t show_protocols(struct device *d,
 
 /**
  * store_protocols() - changes the current IR protocol(s)
- * @d:		the device descriptor
+ * @device:	the device descriptor
  * @mattr:	the device attribute struct (unused)
  * @buf:	a pointer to the input buffer
  * @len:	length of the input buffer
@@ -1156,12 +980,12 @@ static ssize_t show_protocols(struct device *d,
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  */
-static ssize_t store_protocols(struct device *d,
+static ssize_t store_protocols(struct device *device,
 			       struct device_attribute *mattr,
 			       const char *data,
 			       size_t len)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct rc_dev *dev = to_rc_dev(device);
 	bool enable, disable;
 	const char *tmp;
 	u64 type;
@@ -1169,10 +993,10 @@ static ssize_t store_protocols(struct device *d,
 	int rc, i, count = 0;
 	unsigned long flags;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
+	if (dev->driver_type == RC_DRIVER_SCANCODE)
+		type = dev->rc_tab.ir_type;
 	else
-		type = ir_dev->raw->enabled_protocols;
+		type = dev->raw->enabled_protocols;
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -1223,9 +1047,8 @@ static ssize_t store_protocols(struct device *d,
 		return -EINVAL;
 	}
 
-	if (ir_dev->props && ir_dev->props->change_protocol) {
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    type);
+	if (dev->change_protocol) {
+		rc = dev->change_protocol(dev, type);
 		if (rc < 0) {
 			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 				   (long long)type);
@@ -1233,12 +1056,12 @@ static ssize_t store_protocols(struct device *d,
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
 
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
@@ -1247,6 +1070,14 @@ static ssize_t store_protocols(struct device *d,
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
@@ -1256,12 +1087,12 @@ static ssize_t store_protocols(struct device *d,
 
 static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
-	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
+	struct rc_dev *dev = to_rc_dev(device);
 
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
@@ -1288,76 +1119,167 @@ static const struct attribute_group *rc_dev_attr_groups[] = {
 
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
+	struct rc_dev *dev;
+
+	dev = kzalloc(sizeof(struct rc_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->input_dev = input_allocate_device();
+	if (!dev->input_dev) {
+		kfree(dev);
+		return NULL;
+	}
+
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
+	__module_get(THIS_MODULE);
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
 	const char *path;
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int devno = find_first_zero_bit(&ir_core_dev_number,
-					IRRCV_NUM_DEVICES);
+	int rc;
+	
+	if (!dev->map_name)
+		return -EINVAL;
 
-	if (unlikely(devno < 0))
-		return devno;
+	rc_tab = get_rc_map(dev->map_name);
+	if (!rc_tab)
+		rc_tab = get_rc_map(RC_MAP_EMPTY);
+	if (!rc_tab || !rc_tab->scan || rc_tab->size == 0)
+		return -EINVAL;
 
-	ir_dev->dev.type = &rc_dev_type;
+	if (dev->open)
+		dev->input_dev->open = ir_open;
+	if (dev->close)
+		dev->input_dev->close = ir_close;
 
-	ir_dev->dev.class = &ir_input_class;
-	ir_dev->dev.parent = input_dev->dev.parent;
-	dev_set_name(&ir_dev->dev, "rc%d", devno);
-	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	rc = device_register(&ir_dev->dev);
-	if (rc)
-		return rc;
+	dev->rc_tab.name = rc_tab->name;
+	dev->rc_tab.ir_type = rc_tab->ir_type;
+	dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
+					       sizeof(struct ir_scancode));
+	dev->rc_tab.size = dev->rc_tab.alloc / sizeof(struct ir_scancode);
+	dev->rc_tab.scan = kmalloc(dev->rc_tab.alloc, GFP_KERNEL);
 
+	if (!dev->rc_tab.scan)
+		return -ENOMEM;
 
-	input_dev->dev.parent = &ir_dev->dev;
-	rc = input_register_device(input_dev);
-	if (rc < 0) {
-		device_del(&ir_dev->dev);
-		return rc;
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   dev->rc_tab.size, dev->rc_tab.alloc);
+
+	set_bit(EV_KEY, dev->input_dev->evbit);
+	set_bit(EV_REP, dev->input_dev->evbit);
+	set_bit(EV_MSC, dev->input_dev->evbit);
+	set_bit(MSC_SCAN, dev->input_dev->mscbit);
+
+	if (ir_setkeytable(dev, &dev->rc_tab, rc_tab)) {
+		rc = -ENOMEM;
+		goto out_table;
 	}
 
-	__module_get(THIS_MODULE);
+	dev->devno = (unsigned long)(atomic_inc_return(&devno) - 1);
+	dev_set_name(&dev->dev, "rc%ld", dev->devno);
+	dev_set_drvdata(&dev->dev, dev);
 
-	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
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
+
+	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&ir_dev->dev),
-		input_dev->name ? input_dev->name : "Unspecified device",
-		path ? path : "N/A");
+	       dev_name(&dev->dev),
+	       dev->input_name ? dev->input_name : "unspecified device",
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
+	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode: %s)\n",
+		   dev->devno, dev->driver_name, rc_tab->name,
+		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
 
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
diff --git a/drivers/media/IR/streamzap.c b/drivers/media/IR/streamzap.c
index 2cf57e6..a67b6ce 100644
--- a/drivers/media/IR/streamzap.c
+++ b/drivers/media/IR/streamzap.c
@@ -86,12 +86,12 @@ enum StreamzapDecoderState {
 /* structure to hold our device specific stuff */
 struct streamzap_ir {
 
-	/* ir-core */
-	struct ir_dev_props *props;
+	/* rc-core */
+	struct rc_dev *rc;
+	struct ir_raw_event rawir;
 
 	/* core device info */
 	struct device *dev;
-	struct input_dev *idev;
 
 	/* usb */
 	struct usb_device	*usbdev;
@@ -140,7 +140,7 @@ static struct usb_driver streamzap_driver = {
 
 static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 {
-	ir_raw_event_store(sz->idev, &rawir);
+	ir_raw_event_store(sz->rc, &rawir);
 }
 
 static void sz_push_full_pulse(struct streamzap_ir *sz,
@@ -277,7 +277,7 @@ static void streamzap_callback(struct urb *urb)
 				sz->idle = true;
 				if (sz->timeout_enabled)
 					sz_push(sz, rawir);
-				ir_raw_event_handle(sz->idev);
+				ir_raw_event_handle(sz->rc);
 			} else {
 				sz_push_full_space(sz, sz->buf_in[i]);
 			}
@@ -300,23 +300,16 @@ static void streamzap_callback(struct urb *urb)
 	return;
 }
 
-static struct input_dev *streamzap_init_input_dev(struct streamzap_ir *sz)
+static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 {
-	struct input_dev *idev;
-	struct ir_dev_props *props;
+	struct rc_dev *rc;
 	struct device *dev = sz->dev;
 	int ret;
 
-	idev = input_allocate_device();
-	if (!idev) {
-		dev_err(dev, "remote input dev allocation failed\n");
-		goto idev_alloc_failed;
-	}
-
-	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
-	if (!props) {
-		dev_err(dev, "remote ir dev props allocation failed\n");
-		goto props_alloc_failed;
+	rc = rc_allocate_device();
+	if (!rc) {
+		dev_err(dev, "remote rc dev allocation failed\n");
+		goto out;
 	}
 
 	snprintf(sz->name, sizeof(sz->name), "Streamzap PC Remote Infrared "
@@ -324,30 +317,27 @@ static struct input_dev *streamzap_init_input_dev(struct streamzap_ir *sz)
 		 le16_to_cpu(sz->usbdev->descriptor.idVendor),
 		 le16_to_cpu(sz->usbdev->descriptor.idProduct));
 
-	idev->name = sz->name;
+	rc->input_name = sz->name;
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
-	idev->phys = sz->phys;
-
-	props->priv = sz;
-	props->driver_type = RC_DRIVER_IR_RAW;
-	props->allowed_protos = IR_TYPE_ALL;
+	rc->input_phys = sz->phys;
 
-	sz->props = props;
+	rc->driver_name = DRIVER_NAME;
+	rc->map_name = RC_MAP_STREAMZAP;
+	rc->priv = sz;
+	rc->driver_type = RC_DRIVER_IR_RAW;
+	rc->allowed_protos = IR_TYPE_ALL;
 
-	ret = ir_input_register(idev, RC_MAP_STREAMZAP, props, DRIVER_NAME);
+	ret = rc_register_device(rc);
 	if (ret < 0) {
-		dev_err(dev, "remote input device register failed\n");
-		goto irdev_failed;
+		dev_err(dev, "remote device registration failed\n");
+		goto out;
 	}
 
-	return idev;
+	return rc;
 
-irdev_failed:
-	kfree(props);
-props_alloc_failed:
-	input_free_device(idev);
-idev_alloc_failed:
+out:
+	rc_free_device(rc);
 	return NULL;
 }
 
@@ -436,9 +426,9 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	sz->idev = streamzap_init_input_dev(sz);
-	if (!sz->idev)
-		goto input_dev_fail;
+	sz->rc = streamzap_init_rc_dev(sz);
+	if (!sz->rc)
+		goto free_urb_in;
 
 	sz->idle = true;
 	sz->decoder_state = PulseSpace;
@@ -473,7 +463,7 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 
-input_dev_fail:
+free_urb_in:
 	usb_free_urb(sz->urb_in);
 free_buf_in:
 	usb_free_coherent(usbdev, maxp, sz->buf_in, sz->dma_in);
@@ -504,7 +494,7 @@ static void streamzap_disconnect(struct usb_interface *interface)
 		return;
 
 	sz->usbdev = NULL;
-	ir_input_unregister(sz->idev);
+	rc_unregister_device(sz->rc);
 	usb_kill_urb(sz->urb_in);
 	usb_free_urb(sz->urb_in);
 	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index bca07c0..2a99191 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -266,7 +266,7 @@ static void dm1105_card_list(struct pci_dev *pci)
 
 /* infrared remote control */
 struct infrared {
-	struct input_dev	*input_dev;
+	struct rc_dev		*dev;
 	char			input_phys[32];
 	struct work_struct	work;
 	u32			ir_command;
@@ -532,7 +532,7 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	ir_keydown(ir->input_dev, data, 0);
+	ir_keydown(ir->dev, data, 0);
 }
 
 /* work handler */
@@ -593,46 +593,48 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 
 int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
-	struct input_dev *input_dev;
-	char *ir_codes = RC_MAP_DM1105_NEC;
+	struct rc_dev *dev;
 	int err = -ENOMEM;
 
-	input_dev = input_allocate_device();
-	if (!input_dev)
+	dev = rc_allocate_device();
+	if (!dev)
 		return -ENOMEM;
 
-	dm1105->ir.input_dev = input_dev;
 	snprintf(dm1105->ir.input_phys, sizeof(dm1105->ir.input_phys),
 		"pci-%s/ir0", pci_name(dm1105->pdev));
 
-	input_dev->name = "DVB on-card IR receiver";
-	input_dev->phys = dm1105->ir.input_phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	dev->driver_name = MODULE_NAME;
+	dev->map_name = RC_MAP_DM1105_NEC;
+	dev->driver_type = RC_DRIVER_SCANCODE;
+	dev->input_name = "DVB on-card IR receiver";
+	dev->input_phys = dm1105->ir.input_phys;
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
 
-	input_dev->dev.parent = &dm1105->pdev->dev;
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
diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index c2c9d23..0621fea 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -60,7 +60,7 @@ extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold);
-extern int dib0700_change_protocol(void *priv, u64 ir_type);
+extern int dib0700_change_protocol(struct rc_dev *rc, u64 ir_type);
 
 extern int dib0700_device_count;
 extern int dvb_usb_dib0700_ir_proto;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index fe81834..3b58f45 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -471,9 +471,9 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return dib0700_ctrl_wr(adap->dev, b, 4);
 }
 
-int dib0700_change_protocol(void *priv, u64 ir_type)
+int dib0700_change_protocol(struct rc_dev *rc, u64 ir_type)
 {
-	struct dvb_usb_device *d = priv;
+	struct dvb_usb_device *d = rc->priv;
 	struct dib0700_state *st = d->priv;
 	u8 rc_setup[3] = { REQUEST_SET_RC, 0, 0 };
 	int new_proto, ret;
@@ -535,7 +535,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	if (d == NULL)
 		return;
 
-	if (d->rc_input_dev == NULL) {
+	if (d->rc_dev == NULL) {
 		/* This will occur if disable_rc_polling=1 */
 		usb_free_urb(purb);
 		return;
@@ -600,7 +600,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	ir_keydown(d->rc_input_dev, keycode, toggle);
+	ir_keydown(d->rc_dev, keycode, toggle);
 
 resubmit:
 	/* Clean the buffer before we requeue */
@@ -673,9 +673,6 @@ static int dib0700_probe(struct usb_interface *intf,
 			else
 				dev->props.rc.core.bulk_mode = false;
 
-			/* Need a higher delay, to avoid wrong repeat */
-			dev->rc_input_dev->rep[REP_DELAY] = 500;
-
 			dib0700_rc_setup(dev);
 
 			return 0;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index f634d2e..2d93857 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -520,13 +520,13 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 			d->last_event = keycode;
 		}
 
-		ir_keydown(d->rc_input_dev, keycode, 0);
+		ir_keydown(d->rc_dev, keycode, 0);
 		break;
 	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
 		keycode = key[3-2] << 8 | key[3-3];
 		toggle = key[3-1];
-		ir_keydown(d->rc_input_dev, keycode, toggle);
+		ir_keydown(d->rc_dev, keycode, toggle);
 
 		break;
 	}
@@ -1872,12 +1872,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -1908,12 +1904,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -1969,12 +1961,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2013,12 +2001,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2091,12 +2075,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2137,12 +2117,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2207,12 +2183,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2256,12 +2228,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2327,12 +2295,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2365,12 +2329,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2435,12 +2395,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2481,12 +2437,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 2,
@@ -2532,12 +2484,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos   = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2571,12 +2519,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.rc_props = {
-				.allowed_protos = IR_TYPE_RC5 |
-						  IR_TYPE_RC6 |
-						  IR_TYPE_NEC,
-				.change_protocol = dib0700_change_protocol,
-			},
+			.allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6 | IR_TYPE_NEC,
+			.change_protocol = dib0700_change_protocol,
 		},
 	},
 };
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index b579fed..2c816c7 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -106,10 +106,10 @@ static void legacy_dvb_usb_read_remote_control(struct work_struct *work)
 			d->last_event = event;
 		case REMOTE_KEY_REPEAT:
 			deb_rc("key repeated\n");
-			input_event(d->rc_input_dev, EV_KEY, event, 1);
-			input_sync(d->rc_input_dev);
-			input_event(d->rc_input_dev, EV_KEY, d->last_event, 0);
-			input_sync(d->rc_input_dev);
+			input_event(d->input_dev, EV_KEY, event, 1);
+			input_sync(d->input_dev);
+			input_event(d->input_dev, EV_KEY, d->last_event, 0);
+			input_sync(d->input_dev);
 			break;
 		default:
 			break;
@@ -154,10 +154,22 @@ schedule:
 	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc.legacy.rc_interval));
 }
 
-static int legacy_dvb_usb_remote_init(struct dvb_usb_device *d,
-				      struct input_dev *input_dev)
+static int legacy_dvb_usb_remote_init(struct dvb_usb_device *d)
 {
 	int i, err, rc_interval;
+	struct input_dev *input_dev;
+
+	input_dev = input_allocate_device();
+	if (!input_dev)
+		return -ENOMEM;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	input_dev->name = "IR-receiver inside an USB DVB receiver";
+	input_dev->phys = d->rc_phys;
+	usb_to_input_id(d->udev, &input_dev->id);
+	input_dev->dev.parent = &d->udev->dev;
+	d->input_dev = input_dev;
+	d->rc_dev = NULL;
 
 	input_dev->getkeycode = legacy_dvb_usb_getkeycode;
 	input_dev->setkeycode = legacy_dvb_usb_setkeycode;
@@ -221,18 +233,34 @@ static void dvb_usb_read_remote_control(struct work_struct *work)
 			      msecs_to_jiffies(d->props.rc.core.rc_interval));
 }
 
-static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d,
-				       struct input_dev *input_dev)
+static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 {
 	int err, rc_interval;
+	struct rc_dev *dev;
+
+	dev = rc_allocate_device();
+	if (!dev)
+		return -ENOMEM;
 
-	d->props.rc.core.rc_props.priv = d;
-	err = ir_input_register(input_dev,
-				 d->props.rc.core.rc_codes,
-				 &d->props.rc.core.rc_props,
-				 d->props.rc.core.module_name);
-	if (err < 0)
+	dev->driver_name = d->props.rc.core.module_name;
+	dev->map_name = d->props.rc.core.rc_codes;
+	dev->change_protocol = d->props.rc.core.change_protocol;
+	dev->allowed_protos = d->props.rc.core.allowed_protos;
+	dev->driver_type = RC_DRIVER_SCANCODE;
+	usb_to_input_id(d->udev, &dev->input_id);
+	dev->input_name = "IR-receiver inside an USB DVB receiver";
+	dev->input_phys = d->rc_phys;
+	dev->dev.parent = &d->udev->dev;
+	dev->priv = d;
+
+	err = rc_register_device(dev);
+	if (err < 0) {
+		rc_free_device(dev);
 		return err;
+	}
+
+	d->input_dev = NULL;
+	d->rc_dev = dev;
 
 	if (!d->props.rc.core.rc_query || d->props.rc.core.bulk_mode)
 		return 0;
@@ -251,7 +279,6 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d,
 
 int dvb_usb_remote_init(struct dvb_usb_device *d)
 {
-	struct input_dev *input_dev;
 	int err;
 
 	if (dvb_usb_disable_rc_polling)
@@ -267,26 +294,15 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
 	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
 
-	input_dev = input_allocate_device();
-	if (!input_dev)
-		return -ENOMEM;
-
-	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->name = "IR-receiver inside an USB DVB receiver";
-	input_dev->phys = d->rc_phys;
-	usb_to_input_id(d->udev, &input_dev->id);
-	input_dev->dev.parent = &d->udev->dev;
-
 	/* Start the remote-control polling. */
 	if (d->props.rc.legacy.rc_interval < 40)
 		d->props.rc.legacy.rc_interval = 100; /* default */
 
-	d->rc_input_dev = input_dev;
-
 	if (d->props.rc.mode == DVB_RC_LEGACY)
-		err = legacy_dvb_usb_remote_init(d, input_dev);
+		err = legacy_dvb_usb_remote_init(d);
 	else
-		err = rc_core_dvb_usb_remote_init(d, input_dev);
+		err = rc_core_dvb_usb_remote_init(d);
+
 	if (err)
 		return err;
 
@@ -301,9 +317,9 @@ int dvb_usb_remote_exit(struct dvb_usb_device *d)
 		cancel_rearming_delayed_work(&d->rc_query_work);
 		flush_scheduled_work();
 		if (d->props.rc.mode == DVB_RC_LEGACY)
-			input_unregister_device(d->rc_input_dev);
+			input_unregister_device(d->input_dev);
 		else
-			ir_input_unregister(d->rc_input_dev);
+			rc_unregister_device(d->rc_dev);
 	}
 	d->state &= ~DVB_USB_STATE_REMOTE;
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 34f7b3b..83aa982 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -180,18 +180,20 @@ struct dvb_rc_legacy {
  * struct dvb_rc properties of remote controller, using rc-core
  * @rc_codes: name of rc codes table
  * @protocol: type of protocol(s) currently used by the driver
+ * @allowed_protos: protocol(s) supported by the driver
+ * @change_protocol: callback to change protocol
  * @rc_query: called to query an event event.
  * @rc_interval: time in ms between two queries.
- * @rc_props: remote controller properties
  * @bulk_mode: device supports bulk mode for RC (disable polling mode)
  */
 struct dvb_rc {
 	char *rc_codes;
 	u64 protocol;
+	u64 allowed_protos;
+	int (*change_protocol)(struct rc_dev *dev, u64 ir_type);
 	char *module_name;
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
-	struct ir_dev_props rc_props;
 	bool bulk_mode;				/* uses bulk mode */
 };
 
@@ -385,7 +387,8 @@ struct dvb_usb_adapter {
  *
  * @i2c_adap: device's i2c_adapter if it uses I2CoverUSB
  *
- * @rc_input_dev: input device for the remote control.
+ * @rc_dev: rc device for the remote control (rc-core mode)
+ * @input_dev: input device for the remote control (legacy mode)
  * @rc_query_work: struct work_struct frequent rc queries
  * @last_event: last triggered event
  * @last_state: last state (no, pressed, repeat)
@@ -418,7 +421,8 @@ struct dvb_usb_device {
 	struct dvb_usb_adapter adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];
 
 	/* remote control */
-	struct input_dev *rc_input_dev;
+	struct rc_dev *rc_dev;
+	struct input_dev *input_dev;
 	char rc_phys[64];
 	struct delayed_work rc_query_work;
 	u32 last_event;
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
index a99489b..a056240 100644
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
@@ -95,53 +95,61 @@ static struct ir_scancode mantis_ir_table[] = {
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
-		return -ENOMEM;
-	}
-
-	sprintf(name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
-	sprintf(dev, "pci-%s/ir0", pci_name(mantis->pdev));
+	err = ir_register_map(&ir_mantis_map);
+	if (err)
+		goto out;
 
-	rc->name = name;
-	rc->phys = dev;
+	dev = rc_allocate_device();
+	if (!dev) {
+		dprintk(MANTIS_ERROR, 1, "Remote device allocation failed");
+		err = -ENOMEM;
+		goto out_map;
+	}
 
-	rc->id.bustype	= BUS_PCI;
-	rc->id.vendor	= mantis->vendor_id;
-	rc->id.product	= mantis->device_id;
-	rc->id.version	= 1;
-	rc->dev		= mantis->pdev->dev;
+	sprintf(mantis->input_name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
+	sprintf(mantis->input_phys, "pci-%s/ir0", pci_name(mantis->pdev));
 
-	err = __ir_input_register(rc, &ir_mantis, NULL, MODULE_NAME);
-	if (err) {
-		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret = %d", err);
-		input_free_device(rc);
-		return -ENODEV;
-	}
+	dev->input_name         = mantis->input_name;
+	dev->input_phys         = mantis->input_phys;
+	dev->input_id.bustype   = BUS_PCI;
+	dev->input_id.vendor    = mantis->vendor_id;
+	dev->input_id.product   = mantis->device_id;
+	dev->input_id.version   = 1;
+	dev->driver_name        = MODULE_NAME;
+	dev->map_name           = RC_MAP_MANTIS;
+	dev->dev.parent         = &mantis->pdev->dev;
 
-	mantis->rc = rc;
+	err = rc_register_device(dev);
+	if (err)
+		goto out_dev;
 
+	mantis->rc = dev;
 	return 0;
+
+out_dev:
+	rc_free_device(dev);
+out_map:
+	ir_unregister_map(&ir_mantis_map);
+out:
+	return err;
 }
 
 int mantis_exit(struct mantis_pci *mantis)
 {
-	struct input_dev *rc = mantis->rc;
-
-	ir_input_unregister(rc);
-
+	rc_unregister_device(mantis->rc);
 	return 0;
 }
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index d93468c..030a96e 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -438,7 +438,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 	int rc;
 	void *buffer;
 
-	coredev->ir.input_dev = NULL;
+	coredev->ir.dev = NULL;
 	ir_io = sms_get_board(smscore_get_board_id(coredev))->board_cfg.ir;
 	if (ir_io) {/* only if IR port exist we use IR sub-module */
 		sms_info("IR loading");
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index d0e4639..4986b27 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -45,25 +45,24 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
 		ev.pulse = (samples[i] > 0) ? false : true;
 
-		ir_raw_event_store(coredev->ir.input_dev, &ev);
+		ir_raw_event_store(coredev->ir.dev, &ev);
 	}
-	ir_raw_event_handle(coredev->ir.input_dev);
+	ir_raw_event_handle(coredev->ir.dev);
 }
 
 int sms_ir_init(struct smscore_device_t *coredev)
 {
-	struct input_dev *input_dev;
+	int err;
 	int board_id = smscore_get_board_id(coredev);
+	struct rc_dev *dev;
 
-	sms_log("Allocating input device");
-	input_dev = input_allocate_device();
-	if (!input_dev)	{
+	sms_log("Allocating rc device");
+	dev = rc_allocate_device();
+	if (!dev) {
 		sms_err("Not enough memory");
 		return -ENOMEM;
 	}
 
-	coredev->ir.input_dev = input_dev;
-
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
 	sms_log("IR port %d, timeout %d ms",
@@ -75,38 +74,41 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
 	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
 
-	input_dev->name = coredev->ir.name;
-	input_dev->phys = coredev->ir.phys;
-	input_dev->dev.parent = coredev->device;
+	dev->input_name = coredev->ir.name;
+	dev->input_phys = coredev->ir.phys;
+	dev->dev.parent = coredev->device;
 
 #if 0
 	/* TODO: properly initialize the parameters bellow */
-	input_dev->id.bustype = BUS_USB;
-	input_dev->id.version = 1;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	dev->input_id.bustype = BUS_USB;
+	dev->input_id.version = 1;
+	dev->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	dev->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
 #endif
 
-	coredev->ir.props.priv = coredev;
-	coredev->ir.props.driver_type = RC_DRIVER_IR_RAW;
-	coredev->ir.props.allowed_protos = IR_TYPE_ALL;
+	dev->priv = coredev;
+	dev->driver_type = RC_DRIVER_IR_RAW;
+	dev->allowed_protos = IR_TYPE_ALL;
+	dev->map_name = sms_get_board(board_id)->rc_codes;
+	dev->driver_name = MODULE_NAME;
 
-	sms_log("Input device (IR) %s is set for key events", input_dev->name);
+	sms_log("Input device (IR) %s is set for key events", dev->input_name);
 
-	if (ir_input_register(input_dev, sms_get_board(board_id)->rc_codes,
-			      &coredev->ir.props, MODULE_NAME)) {
+	err = rc_register_device(dev);
+	if (err < 0) {
 		sms_err("Failed to register device");
-		input_free_device(input_dev);
-		return -EACCES;
+		rc_free_device(dev);
+		return err;
 	}
 
+	coredev->ir.dev = dev;
 	return 0;
 }
 
 void sms_ir_exit(struct smscore_device_t *coredev)
 {
-	if (coredev->ir.input_dev)
-		ir_input_unregister(coredev->ir.input_dev);
+	if (coredev->ir.dev)
+		rc_unregister_device(coredev->ir.dev);
 
 	sms_log("");
 }
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/dvb/siano/smsir.h
index 926e247..c2f68a4 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -35,13 +35,12 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 struct smscore_device_t;
 
 struct ir_t {
-	struct input_dev *input_dev;
+	struct rc_dev *dev;
 	char name[40];
 	char phys[32];
 
 	char *rc_codes;
 	u64 protocol;
-	struct ir_dev_props props;
 
 	u32 timeout;
 	u32 controller;
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 13ac9e3..53e94bf 100644
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
@@ -218,23 +215,22 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1019:
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
@@ -248,13 +244,12 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
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
index 9ca3bbe..3cba630 100644
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
@@ -241,15 +237,15 @@ int bttv_input_init(struct bttv *btv)
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
@@ -355,44 +351,43 @@ int bttv_input_init(struct bttv *btv)
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
@@ -403,7 +398,7 @@ void bttv_input_fini(struct bttv *btv)
 		return;
 
 	bttv_ir_stop(btv);
-	ir_input_unregister(btv->remote->dev);
+	rc_unregister_device(btv->remote->dev);
 	kfree(btv->remote);
 	btv->remote = NULL;
 }
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index bb61870..f1bb3a8 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -35,7 +35,6 @@
  *  02110-1301, USA.
  */
 
-#include <linux/input.h>
 #include <linux/slab.h>
 #include <media/ir-core.h>
 #include <media/v4l2-subdev.h>
@@ -62,16 +61,16 @@ static void cx23885_input_process_measurements(struct cx23885_dev *dev,
 		count = num / sizeof(struct ir_raw_event);
 
 		for (i = 0; i < count; i++) {
-			ir_raw_event_store(kernel_ir->inp_dev,
+			ir_raw_event_store(kernel_ir->rc,
 					   &ir_core_event[i]);
 			handle = true;
 		}
 	} while (num != 0);
 
 	if (overrun)
-		ir_raw_event_reset(kernel_ir->inp_dev);
+		ir_raw_event_reset(kernel_ir->rc);
 	else if (handle)
-		ir_raw_event_handle(kernel_ir->inp_dev);
+		ir_raw_event_handle(kernel_ir->rc);
 }
 
 void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
@@ -197,9 +196,9 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	return 0;
 }
 
-static int cx23885_input_ir_open(void *priv)
+static int cx23885_input_ir_open(struct rc_dev *rc)
 {
-	struct cx23885_kernel_ir *kernel_ir = priv;
+	struct cx23885_kernel_ir *kernel_ir = rc->priv;
 
 	if (kernel_ir->cx == NULL)
 		return -ENODEV;
@@ -234,9 +233,9 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 	flush_scheduled_work();
 }
 
-static void cx23885_input_ir_close(void *priv)
+static void cx23885_input_ir_close(struct rc_dev *rc)
 {
-	struct cx23885_kernel_ir *kernel_ir = priv;
+	struct cx23885_kernel_ir *kernel_ir = rc->priv;
 
 	if (kernel_ir->cx != NULL)
 		cx23885_input_ir_stop(kernel_ir->cx);
@@ -245,9 +244,7 @@ static void cx23885_input_ir_close(void *priv)
 int cx23885_input_init(struct cx23885_dev *dev)
 {
 	struct cx23885_kernel_ir *kernel_ir;
-	struct input_dev *inp_dev;
-	struct ir_dev_props *props;
-
+	struct rc_dev *rc;
 	char *rc_map;
 	enum rc_driver_type driver_type;
 	unsigned long allowed_protos;
@@ -294,37 +291,36 @@ int cx23885_input_init(struct cx23885_dev *dev)
 				    pci_name(dev->pci));
 
 	/* input device */
-	inp_dev = input_allocate_device();
-	if (inp_dev == NULL) {
+	rc = rc_allocate_device();
+	if (!rc) {
 		ret = -ENOMEM;
 		goto err_out_free;
 	}
 
-	kernel_ir->inp_dev = inp_dev;
-	inp_dev->name = kernel_ir->name;
-	inp_dev->phys = kernel_ir->phys;
-	inp_dev->id.bustype = BUS_PCI;
-	inp_dev->id.version = 1;
+	kernel_ir->rc = rc;
+	rc->input_name = kernel_ir->name;
+	rc->input_phys = kernel_ir->phys;
+	rc->input_id.bustype = BUS_PCI;
+	rc->input_id.version = 1;
 	if (dev->pci->subsystem_vendor) {
-		inp_dev->id.vendor  = dev->pci->subsystem_vendor;
-		inp_dev->id.product = dev->pci->subsystem_device;
+		rc->input_id.vendor  = dev->pci->subsystem_vendor;
+		rc->input_id.product = dev->pci->subsystem_device;
 	} else {
-		inp_dev->id.vendor  = dev->pci->vendor;
-		inp_dev->id.product = dev->pci->device;
+		rc->input_id.vendor  = dev->pci->vendor;
+		rc->input_id.product = dev->pci->device;
 	}
-	inp_dev->dev.parent = &dev->pci->dev;
-
-	/* kernel ir device properties */
-	props = &kernel_ir->props;
-	props->driver_type = driver_type;
-	props->allowed_protos = allowed_protos;
-	props->priv = kernel_ir;
-	props->open = cx23885_input_ir_open;
-	props->close = cx23885_input_ir_close;
+	rc->dev.parent = &dev->pci->dev;
+	rc->driver_type = driver_type;
+	rc->allowed_protos = allowed_protos;
+	rc->priv = kernel_ir;
+	rc->open = cx23885_input_ir_open;
+	rc->close = cx23885_input_ir_close;
+	rc->map_name = rc_map;
+	rc->driver_name = MODULE_NAME;
 
 	/* Go */
 	dev->kernel_ir = kernel_ir;
-	ret = ir_input_register(inp_dev, rc_map, props, MODULE_NAME);
+	ret = rc_register_device(rc);
 	if (ret)
 		goto err_out_stop;
 
@@ -333,7 +329,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 err_out_stop:
 	cx23885_input_ir_stop(dev);
 	dev->kernel_ir = NULL;
-	/* TODO: double check clean-up of kernel_ir->inp_dev */
+	rc_free_device(rc);
 err_out_free:
 	kfree(kernel_ir->phys);
 	kfree(kernel_ir->name);
@@ -348,7 +344,7 @@ void cx23885_input_fini(struct cx23885_dev *dev)
 
 	if (dev->kernel_ir == NULL)
 		return;
-	ir_input_unregister(dev->kernel_ir->inp_dev);
+	rc_unregister_device(dev->kernel_ir->rc);
 	kfree(dev->kernel_ir->phys);
 	kfree(dev->kernel_ir->name);
 	kfree(dev->kernel_ir);
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index ed94b17..f350d88 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -310,8 +310,7 @@ struct cx23885_kernel_ir {
 	char			*name;
 	char			*phys;
 
-	struct input_dev	*inp_dev;
-	struct ir_dev_props	props;
+	struct rc_dev		*rc;
 };
 
 struct cx23885_dev {
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 45cf079..9cbf190 100644
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
+static int cx88_ir_open(struct rc_dev *rc)
 {
-	struct cx88_core *core = priv;
+	struct cx88_core *core = rc->priv;
 
 	core->ir->users++;
 	return __cx88_ir_start(core);
 }
 
-static void cx88_ir_close(void *priv)
+static void cx88_ir_close(struct rc_dev *rc)
 {
-	struct cx88_core *core = priv;
+	struct cx88_core *core = rc->priv;
 
 	core->ir->users--;
 	if (!core->ir->users)
@@ -241,7 +239,7 @@ static void cx88_ir_close(void *priv)
 int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	struct cx88_IR *ir;
-	struct input_dev *input_dev;
+	struct rc_dev *dev;
 	char *ir_codes = NULL;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
@@ -249,11 +247,11 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 				 */
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev)
+	dev = rc_allocate_device();
+	if (!ir || !dev)
 		goto err_out_free;
 
-	ir->input = input_dev;
+	ir->dev = dev;
 
 	/* detect & configure */
 	switch (core->boardnr) {
@@ -429,35 +427,39 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_PCI;
-	input_dev->id.version = 1;
+	dev->input_name = ir->name;
+	dev->input_phys = ir->phys;
+	dev->input_id.bustype = BUS_PCI;
+	dev->input_id.version = 1;
 	if (pci->subsystem_vendor) {
-		input_dev->id.vendor = pci->subsystem_vendor;
-		input_dev->id.product = pci->subsystem_device;
+		dev->input_id.vendor = pci->subsystem_vendor;
+		dev->input_id.product = pci->subsystem_device;
 	} else {
-		input_dev->id.vendor = pci->vendor;
-		input_dev->id.product = pci->device;
+		dev->input_id.vendor = pci->vendor;
+		dev->input_id.product = pci->device;
 	}
-	input_dev->dev.parent = &pci->dev;
+	dev->dev.parent = &pci->dev;
+	dev->map_name = ir_codes;
+	dev->driver_name = MODULE_NAME;
+
 	/* record handles to ourself */
 	ir->core = core;
 	core->ir = ir;
 
-	ir->props.priv = core;
-	ir->props.open = cx88_ir_open;
-	ir->props.close = cx88_ir_close;
-	ir->props.scanmask = hardware_mask;
+	dev->priv = core;
+	dev->open = cx88_ir_open;
+	dev->close = cx88_ir_close;
+	dev->scanmask = hardware_mask;
 
 	/* all done */
-	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
+	err = rc_register_device(dev);
 	if (err)
 		goto err_out_free;
 
 	return 0;
 
  err_out_free:
+	rc_free_device(dev);
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
index 6759cd5..b7d3999 100644
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
+static int em28xx_ir_start(struct rc_dev *rc)
 {
-	struct em28xx_IR *ir = priv;
+	struct em28xx_IR *ir = rc->priv;
 
 	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 	schedule_delayed_work(&ir->work, 0);
@@ -341,17 +336,17 @@ static int em28xx_ir_start(void *priv)
 	return 0;
 }
 
-static void em28xx_ir_stop(void *priv)
+static void em28xx_ir_stop(struct rc_dev *rc)
 {
-	struct em28xx_IR *ir = priv;
+	struct em28xx_IR *ir = rc->priv;
 
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
@@ -400,28 +395,27 @@ int em28xx_ir_init(struct em28xx *dev)
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
-
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
 
@@ -435,27 +429,27 @@ int em28xx_ir_init(struct em28xx *dev)
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
+	rc->dev.parent = &dev->udev->dev;
+	rc->map_name = dev->board.ir_codes;
+	rc->driver_name = MODULE_NAME;
 
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
@@ -468,8 +462,8 @@ int em28xx_ir_fini(struct em28xx *dev)
 	if (!ir)
 		return 0;
 
-	em28xx_ir_stop(ir);
-	ir_input_unregister(ir->input);
+	em28xx_ir_stop(ir->rc);
+	rc_unregister_device(ir->rc);
 	kfree(ir);
 
 	/* done */
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index edd414d..12253db 100644
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
@@ -425,16 +425,18 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
 
 	printk(MODULE_NAME ": %s detected at %s [%s]\n",
-	       ir->input->name, ir->input->phys, adap->name);
+	       ir->name, ir->phys, adap->name);
 
 	/* start polling via eventd */
 	INIT_DELAYED_WORK(&ir->work, ir_work);
@@ -443,6 +445,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
  err_out_free:
+	rc_free_device(rc);
 	kfree(ir);
 	return err;
 }
@@ -455,7 +458,7 @@ static int ir_remove(struct i2c_client *client)
 	cancel_delayed_work_sync(&ir->work);
 
 	/* unregister device */
-	ir_input_unregister(ir->input);
+	rc_unregister_device(ir->rc);
 
 	/* free memory */
 	kfree(ir);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index a63721b..3a1cbee 100644
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
@@ -820,13 +811,13 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev) {
+	rc = rc_allocate_device();
+	if (!ir || !rc) {
 		err = -ENOMEM;
 		goto err_out_free;
 	}
 
-	ir->dev = input_dev;
+	ir->dev = rc;
 	dev->remote = ir;
 
 	ir->running = 0;
@@ -846,43 +837,40 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
-
-	ir->props.priv = dev;
-	ir->props.open = saa7134_ir_open;
-	ir->props.close = saa7134_ir_close;
-
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
+	rc->map_name = ir_codes;
+	rc->driver_name = MODULE_NAME;
 
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
@@ -894,7 +882,7 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 		return;
 
 	saa7134_ir_stop(dev);
-	ir_input_unregister(dev->remote->dev);
+	rc_unregister_device(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
 }
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 49b9205..4ee88ae 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -50,7 +50,7 @@ struct tm6000_ir_poll_result {
 
 struct tm6000_IR {
 	struct tm6000_core	*dev;
-	struct ir_input_dev	*input;
+	struct rc_dev		*rc;
 	char			name[32];
 	char			phys[32];
 
@@ -63,9 +63,6 @@ struct tm6000_IR {
 	u8			key:1;
 
 	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
-
-	/* IR device properties */
-	struct ir_dev_props	props;
 };
 
 
@@ -182,7 +179,7 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 		poll_result.rc_data[0], poll_result.rc_data[1]);
 
 	if (poll_result.rc_data[0] != 0xff && ir->key == 1) {
-		ir_keydown(ir->input->input_dev,
+		ir_keydown(ir->rc,
 			   poll_result.rc_data[0] | poll_result.rc_data[1] << 8,
 			   0);
 		ir->key = 0;
@@ -198,9 +195,9 @@ static void tm6000_ir_work(struct work_struct *work)
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
-static int tm6000_ir_start(void *priv)
+static int tm6000_ir_start(struct rc_dev *rc)
 {
-	struct tm6000_IR *ir = priv;
+	struct tm6000_IR *ir = rc->priv;
 
 	INIT_DELAYED_WORK(&ir->work, tm6000_ir_work);
 	schedule_delayed_work(&ir->work, 0);
@@ -208,16 +205,16 @@ static int tm6000_ir_start(void *priv)
 	return 0;
 }
 
-static void tm6000_ir_stop(void *priv)
+static void tm6000_ir_stop(struct rc_dev *rc)
 {
-	struct tm6000_IR *ir = priv;
+	struct tm6000_IR *ir = rc->priv;
 
 	cancel_delayed_work_sync(&ir->work);
 }
 
-int tm6000_ir_change_protocol(void *priv, u64 ir_type)
+int tm6000_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 {
-	struct tm6000_IR *ir = priv;
+	struct tm6000_IR *ir = rc->priv;
 
 	ir->get_key = default_polling_getkey;
 
@@ -229,9 +226,9 @@ int tm6000_ir_change_protocol(void *priv, u64 ir_type)
 int tm6000_ir_init(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir;
-	struct ir_input_dev *ir_input_dev;
+	struct rc_dev *rc;
 	int err = -ENOMEM;
-	int pipe, size, rc;
+	int pipe, size;
 
 	if (!enable_ir)
 		return -ENODEV;
@@ -243,24 +240,22 @@ int tm6000_ir_init(struct tm6000_core *dev)
 		return 0;
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	ir_input_dev = kzalloc(sizeof(*ir_input_dev), GFP_KERNEL);
-	ir_input_dev->input_dev = input_allocate_device();
-	if (!ir || !ir_input_dev || !ir_input_dev->input_dev)
-		goto err_out_free;
+	rc = rc_allocate_device();
+	if (!ir | !rc)
+		goto out;
 
 	/* record handles to ourself */
 	ir->dev = dev;
 	dev->ir = ir;
-
-	ir->input = ir_input_dev;
+	ir->rc = rc;
 
 	/* input einrichten */
-	ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
-	ir->props.priv = ir;
-	ir->props.change_protocol = tm6000_ir_change_protocol;
-	ir->props.open = tm6000_ir_start;
-	ir->props.close = tm6000_ir_stop;
-	ir->props.driver_type = RC_DRIVER_SCANCODE;
+	rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+	rc->priv = ir;
+	rc->change_protocol = tm6000_ir_change_protocol;
+	rc->open = tm6000_ir_start;
+	rc->close = tm6000_ir_stop;
+	rc->driver_type = RC_DRIVER_SCANCODE;
 
 	ir->polling = 50;
 
@@ -270,16 +265,17 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	tm6000_ir_change_protocol(ir, IR_TYPE_UNKNOWN);
-
-	ir_input_dev->input_dev->name = ir->name;
-	ir_input_dev->input_dev->phys = ir->phys;
-	ir_input_dev->input_dev->id.bustype = BUS_USB;
-	ir_input_dev->input_dev->id.version = 1;
-	ir_input_dev->input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	ir_input_dev->input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	tm6000_ir_change_protocol(rc, IR_TYPE_UNKNOWN);
 
-	ir_input_dev->input_dev->dev.parent = &dev->udev->dev;
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->input_id.bustype = BUS_USB;
+	rc->input_id.version = 1;
+	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	rc->map_name = dev->ir_codes;
+	rc->driver_name = "tm6000";
+	rc->dev.parent = &dev->udev->dev;
 
 	if (&dev->int_in) {
 		dprintk("IR over int\n");
@@ -296,35 +292,32 @@ int tm6000_ir_init(struct tm6000_core *dev)
 		ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 		if (ir->int_urb->transfer_buffer == NULL) {
 			usb_free_urb(ir->int_urb);
-			goto err_out_stop;
+			goto out;
 		}
 		dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
 		usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
 			ir->int_urb->transfer_buffer, size,
 			tm6000_ir_urb_received, dev,
 			dev->int_in.endp->desc.bInterval);
-		rc = usb_submit_urb(ir->int_urb, GFP_KERNEL);
-		if (rc) {
+		err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+		if (err) {
 			kfree(ir->int_urb->transfer_buffer);
 			usb_free_urb(ir->int_urb);
-			err = rc;
-			goto err_out_stop;
+			goto out;
 		}
 		ir->urb_data = kzalloc(size, GFP_KERNEL);
 	}
 
 	/* ir register */
-	err = ir_input_register(ir->input->input_dev, dev->ir_codes,
-		&ir->props, "tm6000");
+	err = rc_register_device(rc);
 	if (err)
-		goto err_out_stop;
+		goto out;
 
 	return 0;
 
-err_out_stop:
+out:
 	dev->ir = NULL;
-err_out_free:
-	kfree(ir_input_dev);
+	rc_free_device(rc);
 	kfree(ir);
 	return err;
 }
@@ -338,7 +331,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	if (!ir)
 		return 0;
 
-	ir_input_unregister(ir->input->input_dev);
+	rc_unregister_device(ir->rc);
 
 	if (ir->int_urb) {
 		usb_kill_urb(ir->int_urb);
@@ -349,8 +342,6 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 		ir->urb_data = NULL;
 	}
 
-	kfree(ir->input);
-	ir->input = NULL;
 	kfree(ir);
 	dev->ir = NULL;
 
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index f27538c..357efc6 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -36,12 +36,11 @@
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
index 834874d..dbc1b13 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -32,21 +32,38 @@ enum rc_driver_type {
 };
 
 /**
- * struct ir_dev_props - Allow caller drivers to set special properties
- * @driver_type: specifies if the driver or hardware have already a decoder,
- *	or if it needs to use the IR raw event decoders to produce a scancode
+ * struct rc_dev - represents a remote control device
+ * @input_name: name of the input child device
+ * @input_phys: physical path to the input child device
+ * @input_id: id of the input child device (struct input_id)
+ * @dev: driver model's view of this device
+ * @driver_name: name of the hardware driver which registered this device
+ * @map_name: name of the default keymap
+ * @rc_tab: current scan/key table
+ * @devno: unique remote control device number
+ * @raw: additional data for raw pulse/space devices
+ * @input_dev: the input child device used to communicate events to userspace
+ * @driver_type: specifies if protocol decoding is done in hardware or software
+ * @idle: used to keep track of RX state
  * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
- *	scancode to the application. As this is a hardware limit, we can't do
- *	anything with it. Yet, as the same keycode table can be used with other
- *	devices, a mask is provided to allow its usage. Drivers should generally
- *	leave this field in blank
+ *     scancode to the application. As this is a hardware limit, we can't do
+ *     anything with it. Yet, as the same keycode table can be used with other
+ *     devices, a mask is provided to allow its usage. Drivers should generally
+ *     leave this field blank
+ * @priv: driver-specific data
+ * @keylock: protects the remaining members of the struct
+ * @keypressed: whether a key is currently pressed
+ * @keyup_jiffies: time (in jiffies) when the current keypress should be released
+ * @timer_keyup: timer for releasing a keypress
+ * @last_keycode: keycode of last keypress
+ * @last_scancode: scancode of last keypress
+ * @last_toggle: toggle value of last command
  * @timeout: optional time after which device stops sending data
  * @min_timeout: minimum timeout supported by device
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
- * @priv: driver-specific data, to be used on the callbacks
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -55,55 +72,53 @@ enum rc_driver_type {
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
  * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
- * @s_rx_carrier: inform driver about carrier it is expected to handle
+ * @s_rx_carrier_range: inform driver about carrier it is expected to handle
  * @tx_ir: transmit IR
- * @s_idle: optional: enable/disable hardware idle mode, upon which,
+ * @s_idle: enable/disable hardware idle mode, upon which,
 	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  */
-struct ir_dev_props {
-	enum rc_driver_type	driver_type;
-	unsigned long		allowed_protos;
-	u32			scanmask;
-
-	u32			timeout;
-	u32			min_timeout;
-	u32			max_timeout;
-
-	u32			rx_resolution;
-	u32			tx_resolution;
-
-	void			*priv;
-	int			(*change_protocol)(void *priv, u64 ir_type);
-	int			(*open)(void *priv);
-	void			(*close)(void *priv);
-	int			(*s_tx_mask)(void *priv, u32 mask);
-	int			(*s_tx_carrier)(void *priv, u32 carrier);
-	int			(*s_tx_duty_cycle)(void *priv, u32 duty_cycle);
-	int			(*s_rx_carrier_range)(void *priv, u32 min, u32 max);
-	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
-	void			(*s_idle)(void *priv, int enable);
-	int			(*s_learning_mode)(void *priv, int enable);
-};
-
-struct ir_input_dev {
-	struct device			dev;		/* device */
-	char				*driver_name;	/* Name of the driver module */
-	struct ir_scancode_table	rc_tab;		/* scan/key table */
-	unsigned long			devno;		/* device number */
-	struct ir_dev_props		*props;		/* Device properties */
-	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
-	struct input_dev		*input_dev;	/* the input device associated with this device */
+struct rc_dev {
+	const char                      *input_name;
+	const char                      *input_phys;
+	struct input_id                 input_id;
+	struct device                   dev;
+	const char                      *driver_name;
+	const char                      *map_name;
+	struct ir_scancode_table        rc_tab;
+	unsigned long                   devno;
+	struct ir_raw_event_ctrl        *raw;
+	struct input_dev                *input_dev;
+	enum rc_driver_type             driver_type;
 	bool				idle;
-
-	/* key info - needed by IR keycode handlers */
-	spinlock_t			keylock;	/* protects the below members */
-	bool				keypressed;	/* current state */
-	unsigned long			keyup_jiffies;	/* when should the current keypress be released? */
-	struct timer_list		timer_keyup;	/* timer for releasing a keypress */
-	u32				last_keycode;	/* keycode of last command */
-	u32				last_scancode;	/* scancode of last command */
-	u8				last_toggle;	/* toggle of last command */
+	unsigned long			allowed_protos;
+	u32				scanmask;
+	void				*priv;
+
+	spinlock_t			keylock;
+	bool				keypressed;
+	unsigned long			keyup_jiffies;
+	struct timer_list		timer_keyup;
+	u32				last_keycode;
+	u32				last_scancode;
+	u8				last_toggle;
+
+	u32				timeout;
+	u32				min_timeout;
+	u32				max_timeout;
+	u32				rx_resolution;
+	u32				tx_resolution;
+
+	int				(*change_protocol)(struct rc_dev *dev, u64 ir_type);
+	int				(*open)(struct rc_dev *dev);
+	void				(*close)(struct rc_dev *dev);
+	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
+	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
+	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
+	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
+	int				(*tx_ir)(struct rc_dev *dev, int *txbuf, u32 n);
+	void				(*s_idle)(struct rc_dev *dev, int enable);
+	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 };
 
 enum raw_event_type {
@@ -113,52 +128,13 @@ enum raw_event_type {
 	IR_STOP_EVENT   = (1 << 3),
 };
 
-#define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
-
-int __ir_input_register(struct input_dev *dev,
-		      const struct ir_scancode_table *ir_codes,
-		      struct ir_dev_props *props,
-		      const char *driver_name);
-
-static inline int ir_input_register(struct input_dev *dev,
-		      const char *map_name,
-		      struct ir_dev_props *props,
-		      const char *driver_name) {
-	struct ir_scancode_table *ir_codes;
-	struct ir_input_dev *ir_dev;
-	int rc;
-
-	if (!map_name)
-		return -EINVAL;
-
-	ir_codes = get_rc_map(map_name);
-	if (!ir_codes) {
-		ir_codes = get_rc_map(RC_MAP_EMPTY);
-
-		if (!ir_codes)
-			return -EINVAL;
-	}
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
@@ -167,18 +143,22 @@ struct ir_raw_event {
 
 #define IR_MAX_DURATION                 0x7FFFFFFF      /* a bit more than 2 seconds */
 
-void ir_raw_event_handle(struct input_dev *input_dev);
-int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
-int ir_raw_event_store_with_filter(struct input_dev *input_dev,
-				struct ir_raw_event *ev);
-void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
+void ir_raw_event_handle(struct rc_dev *dev);
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev);
+void ir_raw_event_set_idle(struct rc_dev *dev, int idle);
 
-static inline void ir_raw_event_reset(struct input_dev *input_dev)
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
index 88769e9..fe9b268 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -9,7 +9,7 @@ struct IR_i2c {
 	char		       *ir_codes;
 
 	struct i2c_client      *c;
-	struct input_dev       *input;
+	struct rc_dev          *rc;
 
 	/* Used to avoid fast repeating */
 	unsigned char          old;

