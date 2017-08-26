Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40253 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbdHZImV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:42:21 -0400
Date: Sat, 26 Aug 2017 09:42:20 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.14] ktime_t accessor functions
Message-ID: <20170826084219.jwcbrym3g4nvztbe@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Without the ktime_t accessor functions, the pre-v4.10 media_build broken.
Also there is a fix for the serial_ir on 32-bit builds.

Please merge where you see fit. 

Thanks

Sean

The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.14c

for you to fetch changes up to e4ea3e4bd643d133a5a3e7b708a7c7cf0f93586e:

  media: serial_ir: fix tx timing calculation on 32-bit (2017-08-26 09:26:29 +0100)

----------------------------------------------------------------
Jasmin Jessich (1):
      media: rc: use ktime accessor functions

Sean Young (2):
      media: rc: gpio-ir-tx: use ktime accessor functions
      media: serial_ir: fix tx timing calculation on 32-bit

 drivers/media/rc/gpio-ir-tx.c | 12 +++++++-----
 drivers/media/rc/rc-ir-raw.c  | 11 ++++++-----
 drivers/media/rc/serial_ir.c  | 34 ++++++++++++++--------------------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
index 0b83408a2e18..cd476cab9782 100644
--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -98,15 +98,17 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 			// pulse
 			ktime_t last = ktime_add_us(edge, txbuf[i]);
 
-			while (ktime_get() < last) {
+			while (ktime_before(ktime_get(), last)) {
 				gpiod_set_value(gpio_ir->gpio, 1);
-				edge += pulse;
-				delta = edge - ktime_get();
+				edge = ktime_add_ns(edge, pulse);
+				delta = ktime_to_ns(ktime_sub(edge,
+							      ktime_get()));
 				if (delta > 0)
 					ndelay(delta);
 				gpiod_set_value(gpio_ir->gpio, 0);
-				edge += space;
-				delta = edge - ktime_get();
+				edge = ktime_add_ns(edge, space);
+				delta = ktime_to_ns(ktime_sub(edge,
+							      ktime_get()));
 				if (delta > 0)
 					ndelay(delta);
 			}
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index f495709e28fb..503bc425a187 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -106,7 +106,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 		return -EINVAL;
 
 	now = ktime_get();
-	ev.duration = ktime_sub(now, dev->raw->last_event);
+	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
 	ev.pulse = !pulse;
 
 	rc = ir_raw_event_store(dev, &ev);
@@ -474,18 +474,19 @@ EXPORT_SYMBOL(ir_raw_encode_scancode);
 static void edge_handle(unsigned long arg)
 {
 	struct rc_dev *dev = (struct rc_dev *)arg;
-	ktime_t interval = ktime_get() - dev->raw->last_event;
+	ktime_t interval = ktime_sub(ktime_get(), dev->raw->last_event);
 
-	if (interval >= dev->timeout) {
+	if (ktime_to_ns(interval) >= dev->timeout) {
 		DEFINE_IR_RAW_EVENT(ev);
 
 		ev.timeout = true;
-		ev.duration = interval;
+		ev.duration = ktime_to_ns(interval);
 
 		ir_raw_event_store(dev, &ev);
 	} else {
 		mod_timer(&dev->raw->edge_handle,
-			  jiffies + nsecs_to_jiffies(dev->timeout - interval));
+			  jiffies + nsecs_to_jiffies(dev->timeout -
+						     ktime_to_ns(interval)));
 	}
 
 	ir_raw_event_handle(dev);
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 4b8d5f38baf6..8b66926bc16a 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -139,10 +139,8 @@ struct serial_ir {
 	struct platform_device *pdev;
 	struct timer_list timeout_timer;
 
-	unsigned int freq;
+	unsigned int carrier;
 	unsigned int duty_cycle;
-
-	unsigned int pulse_width, space_width;
 };
 
 static struct serial_ir serial_ir;
@@ -183,18 +181,6 @@ static void off(void)
 		soutp(UART_MCR, hardware[type].off);
 }
 
-static void init_timing_params(unsigned int new_duty_cycle,
-			       unsigned int new_freq)
-{
-	serial_ir.duty_cycle = new_duty_cycle;
-	serial_ir.freq = new_freq;
-
-	serial_ir.pulse_width = DIV_ROUND_CLOSEST(
-		new_duty_cycle * NSEC_PER_SEC, new_freq * 100l);
-	serial_ir.space_width = DIV_ROUND_CLOSEST(
-		(100l - new_duty_cycle) * NSEC_PER_SEC, new_freq * 100l);
-}
-
 static void send_pulse_irdeo(unsigned int length, ktime_t target)
 {
 	long rawbits;
@@ -241,13 +227,20 @@ static void send_pulse_homebrew_softcarrier(unsigned int length, ktime_t edge)
 	 * ndelay(s64) does not compile; so use s32 rather than s64.
 	 */
 	s32 delta;
+	unsigned int pulse, space;
+
+	/* Ensure the dividend fits into 32 bit */
+	pulse = DIV_ROUND_CLOSEST(serial_ir.duty_cycle * (NSEC_PER_SEC / 100),
+				  serial_ir.carrier);
+	space = DIV_ROUND_CLOSEST((100 - serial_ir.duty_cycle) *
+				  (NSEC_PER_SEC / 100), serial_ir.carrier);
 
 	for (;;) {
 		now = ktime_get();
 		if (ktime_compare(now, target) >= 0)
 			break;
 		on();
-		edge = ktime_add_ns(edge, serial_ir.pulse_width);
+		edge = ktime_add_ns(edge, pulse);
 		delta = ktime_to_ns(ktime_sub(edge, now));
 		if (delta > 0)
 			ndelay(delta);
@@ -255,7 +248,7 @@ static void send_pulse_homebrew_softcarrier(unsigned int length, ktime_t edge)
 		off();
 		if (ktime_compare(now, target) >= 0)
 			break;
-		edge = ktime_add_ns(edge, serial_ir.space_width);
+		edge = ktime_add_ns(edge, space);
 		delta = ktime_to_ns(ktime_sub(edge, now));
 		if (delta > 0)
 			ndelay(delta);
@@ -580,7 +573,8 @@ static int serial_ir_probe(struct platform_device *dev)
 		return result;
 
 	/* Initialize pulse/space widths */
-	init_timing_params(50, 38000);
+	serial_ir.duty_cycle = 50;
+	serial_ir.carrier = 38000;
 
 	/* If pin is high, then this must be an active low receiver. */
 	if (sense == -1) {
@@ -684,7 +678,7 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 
 static int serial_ir_tx_duty_cycle(struct rc_dev *dev, u32 cycle)
 {
-	init_timing_params(cycle, serial_ir.freq);
+	serial_ir.duty_cycle = cycle;
 	return 0;
 }
 
@@ -693,7 +687,7 @@ static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
 	if (carrier > 500000 || carrier < 20000)
 		return -EINVAL;
 
-	init_timing_params(serial_ir.duty_cycle, carrier);
+	serial_ir.carrier = carrier;
 	return 0;
 }
 
