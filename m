Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51159 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdHZIbY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:31:24 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: serial_ir: fix tx timing calculation on 32-bit
Date: Sat, 26 Aug 2017 09:31:22 +0100
Message-Id: <20170826083122.25812-3-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the calculation to where it is needed, so the result doesn't
need to be stored in the device struct.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/serial_ir.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

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
 
-- 
2.13.5
