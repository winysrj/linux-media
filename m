Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:57280 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932278AbdJXPXQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 11:23:16 -0400
Received: by mail-pg0-f66.google.com with SMTP id m18so14785620pgd.13
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 08:23:16 -0700 (PDT)
Date: Tue, 24 Oct 2017 08:23:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        Sean Young <sean@mess.org>, James Hogan <jhogan@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: rc: Convert timers to use timer_setup()
Message-ID: <20171024152314.GA105003@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sean Young <sean@mess.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Antti Seppälä" <a.seppala@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David Härdeman" <david@hardeman.nu>
Cc: Andi Shyti <andi.shyti@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/rc/ene_ir.c             |  7 +++----
 drivers/media/rc/igorplugusb.c        |  6 +++---
 drivers/media/rc/img-ir/img-ir-hw.c   | 13 ++++++-------
 drivers/media/rc/img-ir/img-ir-raw.c  |  6 +++---
 drivers/media/rc/imon.c               |  7 +++----
 drivers/media/rc/ir-mce_kbd-decoder.c |  7 +++----
 drivers/media/rc/rc-ir-raw.c          |  8 ++++----
 drivers/media/rc/rc-main.c            |  7 +++----
 drivers/media/rc/sir_ir.c             |  4 ++--
 9 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index af7ba23e16e1..71b8c9bbf6c4 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -670,9 +670,9 @@ static void ene_tx_sample(struct ene_device *dev)
 }
 
 /* timer to simulate tx done interrupt */
-static void ene_tx_irqsim(unsigned long data)
+static void ene_tx_irqsim(struct timer_list *t)
 {
-	struct ene_device *dev = (struct ene_device *)data;
+	struct ene_device *dev = from_timer(dev, t, tx_sim_timer);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
@@ -1045,8 +1045,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	if (!dev->hw_learning_and_tx_capable && txsim) {
 		dev->hw_learning_and_tx_capable = true;
-		setup_timer(&dev->tx_sim_timer, ene_tx_irqsim,
-						(long unsigned int)dev);
+		timer_setup(&dev->tx_sim_timer, ene_tx_irqsim, 0);
 		pr_warn("Simulation of TX activated\n");
 	}
 
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index 4b715eb995f8..f563ddd7f739 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -137,9 +137,9 @@ static void igorplugusb_cmd(struct igorplugusb *ir, int cmd)
 		dev_err(ir->dev, "submit urb failed: %d", ret);
 }
 
-static void igorplugusb_timer(unsigned long data)
+static void igorplugusb_timer(struct timer_list *t)
 {
-	struct igorplugusb *ir = (struct igorplugusb *)data;
+	struct igorplugusb *ir = from_timer(ir, t, timer);
 
 	igorplugusb_cmd(ir, GET_INFRACODE);
 }
@@ -174,7 +174,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 
 	ir->dev = &intf->dev;
 
-	setup_timer(&ir->timer, igorplugusb_timer, (unsigned long)ir);
+	timer_setup(&ir->timer, igorplugusb_timer, 0);
 
 	ir->request.bRequest = GET_INFRACODE;
 	ir->request.bRequestType = USB_TYPE_VENDOR | USB_DIR_IN;
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 82fdf4cc0824..f54bc5d23893 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -867,9 +867,9 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 }
 
 /* timer function to end waiting for repeat. */
-static void img_ir_end_timer(unsigned long arg)
+static void img_ir_end_timer(struct timer_list *t)
 {
-	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+	struct img_ir_priv *priv = from_timer(priv, t, hw.end_timer);
 
 	spin_lock_irq(&priv->lock);
 	img_ir_end_repeat(priv);
@@ -881,9 +881,9 @@ static void img_ir_end_timer(unsigned long arg)
  * cleared when invalid interrupts were generated due to a quirk in the
  * img-ir decoder.
  */
-static void img_ir_suspend_timer(unsigned long arg)
+static void img_ir_suspend_timer(struct timer_list *t)
 {
-	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+	struct img_ir_priv *priv = from_timer(priv, t, hw.suspend_timer);
 
 	spin_lock_irq(&priv->lock);
 	/*
@@ -1055,9 +1055,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	img_ir_probe_hw_caps(priv);
 
 	/* Set up the end timer */
-	setup_timer(&hw->end_timer, img_ir_end_timer, (unsigned long)priv);
-	setup_timer(&hw->suspend_timer, img_ir_suspend_timer,
-				(unsigned long)priv);
+	timer_setup(&hw->end_timer, img_ir_end_timer, 0);
+	timer_setup(&hw->suspend_timer, img_ir_suspend_timer, 0);
 
 	/* Register a clock notifier */
 	if (!IS_ERR(priv->clk)) {
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index 64714efc1145..6e545680d3b6 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -67,9 +67,9 @@ void img_ir_isr_raw(struct img_ir_priv *priv, u32 irq_status)
  * order to be assured of the final space. If there are no edges for a certain
  * time we use this timer to emit a final sample to satisfy them.
  */
-static void img_ir_echo_timer(unsigned long arg)
+static void img_ir_echo_timer(struct timer_list *t)
 {
-	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+	struct img_ir_priv *priv = from_timer(priv, t, raw.timer);
 
 	spin_lock_irq(&priv->lock);
 
@@ -107,7 +107,7 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
 	int error;
 
 	/* Set up the echo timer */
-	setup_timer(&raw->timer, img_ir_echo_timer, (unsigned long)priv);
+	timer_setup(&raw->timer, img_ir_echo_timer, 0);
 
 	/* Allocate raw decoder */
 	raw->rdev = rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 9724fe8110e3..86d22de92cd4 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1090,9 +1090,9 @@ static void usb_tx_callback(struct urb *urb)
 /**
  * report touchscreen input
  */
-static void imon_touch_display_timeout(unsigned long data)
+static void imon_touch_display_timeout(struct timer_list *t)
 {
-	struct imon_context *ictx = (struct imon_context *)data;
+	struct imon_context *ictx = from_timer(ictx, t, ttimer);
 
 	if (ictx->display_type != IMON_DISPLAY_TYPE_VGA)
 		return;
@@ -2411,8 +2411,7 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	mutex_lock(&ictx->lock);
 
 	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA) {
-		setup_timer(&ictx->ttimer, imon_touch_display_timeout,
-			    (unsigned long)ictx);
+		timer_setup(&ictx->ttimer, imon_touch_display_timeout, 0);
 	}
 
 	ictx->usbdev_intf1 = usb_get_dev(interface_to_usbdev(intf));
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 7c572a643656..69d6264d54e6 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -115,9 +115,9 @@ static unsigned char kbd_keycodes[256] = {
 	KEY_RESERVED
 };
 
-static void mce_kbd_rx_timeout(unsigned long data)
+static void mce_kbd_rx_timeout(struct timer_list *t)
 {
-	struct mce_kbd_dec *mce_kbd = (struct mce_kbd_dec *)data;
+	struct mce_kbd_dec *mce_kbd = from_timer(mce_kbd, t, rx_timeout);
 	int i;
 	unsigned char maskcode;
 
@@ -389,8 +389,7 @@ static int ir_mce_kbd_register(struct rc_dev *dev)
 	set_bit(EV_MSC, idev->evbit);
 	set_bit(MSC_SCAN, idev->mscbit);
 
-	setup_timer(&mce_kbd->rx_timeout, mce_kbd_rx_timeout,
-		    (unsigned long)mce_kbd);
+	timer_setup(&mce_kbd->rx_timeout, mce_kbd_rx_timeout, 0);
 
 	input_set_drvdata(idev, mce_kbd);
 
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 503bc425a187..f6e5ba4fbb49 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -471,9 +471,10 @@ int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 }
 EXPORT_SYMBOL(ir_raw_encode_scancode);
 
-static void edge_handle(unsigned long arg)
+static void edge_handle(struct timer_list *t)
 {
-	struct rc_dev *dev = (struct rc_dev *)arg;
+	struct ir_raw_event_ctrl *raw = from_timer(raw, t, edge_handle);
+	struct rc_dev *dev = raw->dev;
 	ktime_t interval = ktime_sub(ktime_get(), dev->raw->last_event);
 
 	if (ktime_to_ns(interval) >= dev->timeout) {
@@ -513,8 +514,7 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
-	setup_timer(&dev->raw->edge_handle, edge_handle,
-		    (unsigned long)dev);
+	timer_setup(&dev->raw->edge_handle, edge_handle, 0);
 	INIT_KFIFO(dev->raw->kfifo);
 
 	return 0;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cb78e5702bef..17950e29d4e3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -630,9 +630,9 @@ EXPORT_SYMBOL_GPL(rc_keyup);
  * This routine will generate a keyup event some time after a keydown event
  * is generated when no further activity has been detected.
  */
-static void ir_timer_keyup(unsigned long cookie)
+static void ir_timer_keyup(struct timer_list *t)
 {
-	struct rc_dev *dev = (struct rc_dev *)cookie;
+	struct rc_dev *dev = from_timer(dev, t, timer_keyup);
 	unsigned long flags;
 
 	/*
@@ -1570,8 +1570,7 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 		dev->input_dev->setkeycode = ir_setkeycode;
 		input_set_drvdata(dev->input_dev, dev);
 
-		setup_timer(&dev->timer_keyup, ir_timer_keyup,
-			    (unsigned long)dev);
+		timer_setup(&dev->timer_keyup, ir_timer_keyup, 0);
 
 		spin_lock_init(&dev->rc_map.lock);
 		spin_lock_init(&dev->keylock);
diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index bc906fb128d5..76120664b700 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -120,7 +120,7 @@ static void add_read_queue(int flag, unsigned long val)
 }
 
 /* SECTION: Hardware */
-static void sir_timeout(unsigned long data)
+static void sir_timeout(struct timer_list *unused)
 {
 	/*
 	 * if last received signal was a pulse, but receiving stopped
@@ -321,7 +321,7 @@ static int sir_ir_probe(struct platform_device *dev)
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
 	rcdev->dev.parent = &sir_ir_dev->dev;
 
-	setup_timer(&timerlist, sir_timeout, 0);
+	timer_setup(&timerlist, sir_timeout, 0);
 
 	/* get I/O port access and IRQ line */
 	if (!devm_request_region(&sir_ir_dev->dev, io, 8, KBUILD_MODNAME)) {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
