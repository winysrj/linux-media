Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44277 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab2EWJy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:56 -0400
Subject: [PATCH 40/43] rc-core: use struct rc_event for all rc communication
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:30 +0200
Message-ID: <20120523094530.14474.93587.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove struct ir_raw_event and use struct rc_event in all stages
of IR processing. This should help future flexibility and also
cuts down on the confusing number of structs that are flying
around in rc-*.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/technisat-usb2.c  |   15 +++-
 drivers/media/dvb/siano/smsir.c             |    7 +-
 drivers/media/rc/ene_ir.c                   |   12 ++-
 drivers/media/rc/fintek-cir.c               |   18 +++--
 drivers/media/rc/ir-jvc-decoder.c           |   48 +++++++-------
 drivers/media/rc/ir-lirc-codec.c            |   28 ++++----
 drivers/media/rc/ir-mce_kbd-decoder.c       |   34 +++++-----
 drivers/media/rc/ir-nec-decoder.c           |   51 +++++++--------
 drivers/media/rc/ir-rc5-decoder.c           |   32 +++++----
 drivers/media/rc/ir-rc6-decoder.c           |   48 +++++++-------
 drivers/media/rc/ir-sanyo-decoder.c         |   46 +++++++------
 drivers/media/rc/ir-sony-decoder.c          |   42 ++++++------
 drivers/media/rc/ite-cir.c                  |   19 ++---
 drivers/media/rc/ite-cir.h                  |    2 -
 drivers/media/rc/mceusb.c                   |   15 +++-
 drivers/media/rc/nuvoton-cir.c              |   18 +++--
 drivers/media/rc/rc-core-priv.h             |   33 +++++----
 drivers/media/rc/rc-ir-raw.c                |   90 +++++++++++++++-----------
 drivers/media/rc/rc-loopback.c              |   21 ++----
 drivers/media/rc/redrat3.c                  |   33 ++++-----
 drivers/media/rc/streamzap.c                |   62 +++++++++---------
 drivers/media/rc/winbond-cir.c              |    7 +-
 drivers/media/video/cx23885/cx23885-input.c |   11 +--
 drivers/media/video/cx23885/cx23888-ir.c    |   91 ++++++++++++++------------
 drivers/media/video/cx25840/cx25840-ir.c    |   94 ++++++++++++++-------------
 drivers/media/video/cx88/cx88-input.c       |   13 +++-
 include/media/rc-core.h                     |   16 -----
 include/media/rc-ir-raw.h                   |   34 +++++-----
 28 files changed, 477 insertions(+), 463 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index 3b8752a..5860009 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -593,7 +593,7 @@ static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 {
 	u8 buf[62], *b;
 	int ret;
-	struct ir_raw_event ev;
+	DEFINE_IR_RAW_EVENT(ev);
 
 	buf[0] = GET_IR_DATA_VENDOR_REQUEST;
 	buf[1] = 0x08;
@@ -636,16 +636,19 @@ unlock:
 	debug_dump(b, ret, deb_rc);
 #endif
 
-	ev.pulse = 0;
 	while (1) {
-		ev.pulse = !ev.pulse;
-		ev.duration = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
+		if (ev.code == RC_IR_RAW_SPACE)
+			ev.code = RC_IR_RAW_PULSE;
+		else
+			ev.code = RC_IR_RAW_SPACE;
+
+		ev.val = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
 		ir_raw_event_store(d->rc_dev, &ev);
 
 		b++;
 		if (*b == 0xff) {
-			ev.pulse = 0;
-			ev.duration = 888888*2;
+			ev.code = RC_IR_RAW_SPACE;
+			ev.val = 888888*2;
 			ir_raw_event_store(d->rc_dev, &ev);
 			break;
 		}
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index c9a627d..e619c16 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -38,12 +38,11 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 {
 	int i;
 	const s32 *samples = (const void *)buf;
+	DEFINE_IR_RAW_EVENT(ev);
 
 	for (i = 0; i < len >> 2; i++) {
-		DEFINE_IR_RAW_EVENT(ev);
-
-		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
-		ev.pulse = (samples[i] > 0) ? false : true;
+		ev.val = US_TO_NS(abs(samples[i]));
+		ev.code = (samples[i] > 0) ? RC_IR_RAW_SPACE : RC_IR_RAW_PULSE;
 
 		ir_raw_event_store(coredev->ir.dev, &ev);
 	}
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 9669311..51e704f 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -353,9 +353,11 @@ static void ene_rx_sense_carrier(struct ene_device *dev)
 	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
 						carrier, duty_cycle);
 	if (dev->carrier_detect_enabled) {
-		ev.carrier_report = true;
-		ev.carrier = carrier;
-		ev.duty_cycle = duty_cycle;
+		ev.code = RC_IR_RAW_CARRIER;
+		ev.val = carrier;
+		ir_raw_event_store(dev->rdev, &ev);
+		ev.code = RC_IR_RAW_DUTY_CYCLE;
+		ev.val = duty_cycle;
 		ir_raw_event_store(dev->rdev, &ev);
 	}
 }
@@ -795,8 +797,8 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 		dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
 
-		ev.duration = US_TO_NS(hw_sample);
-		ev.pulse = pulse;
+		ev.val = US_TO_NS(hw_sample);
+		ev.code = pulse ? RC_IR_RAW_PULSE : RC_IR_RAW_SPACE;
 		ir_raw_event_store_with_filter(dev->rdev, &ev);
 	}
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ac949ae..0eabae0 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -289,7 +289,7 @@ static int fintek_cmdsize(u8 cmd, u8 subcmd)
 /* process ir data stored in driver buffer */
 static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	DEFINE_IR_RAW_EVENT(ev);
 	u8 sample;
 	int i;
 
@@ -320,15 +320,17 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 			break;
 		case PARSE_IRDATA:
 			fintek->rem--;
-			init_ir_raw_event(&rawir);
-			rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
-			rawir.duration = US_TO_NS((sample & BUF_SAMPLE_MASK)
+			init_ir_raw_event(&ev);
+			ev.code = RC_IR_RAW_SPACE;
+			if (sample & BUF_PULSE_BIT)
+				ev.code = RC_IR_RAW_PULSE;
+			ev.val = US_TO_NS((sample & BUF_SAMPLE_MASK)
 					  * CIR_SAMPLE_PERIOD);
 
-			fit_dbg("Storing %s with duration %d",
-				rawir.pulse ? "pulse" : "space",
-				rawir.duration);
-			ir_raw_event_store_with_filter(fintek->rdev, &rawir);
+			fit_dbg("Storing %s with duration %llu",
+				ev.code == RC_IR_RAW_PULSE ? "pulse" : "space",
+				(long long unsigned)ev.val);
+			ir_raw_event_store_with_filter(fintek->rdev, &ev);
 			break;
 		}
 
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 30bcf18..dd1c8db 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -39,37 +39,39 @@ enum jvc_state {
 /**
  * ir_jvc_decode() - Decode one JVC pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:   the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_jvc_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
 	if (!(dev->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	if (!geq_margin(ev.duration, JVC_UNIT, JVC_UNIT / 2))
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
+	if (!geq_margin(ev.val, JVC_UNIT, JVC_UNIT / 2))
 		goto out;
 
 	IR_dprintk(2, "JVC decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
 again:
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, JVC_HEADER_PULSE, JVC_UNIT / 2))
+		if (!eq_margin(ev.val, JVC_HEADER_PULSE, JVC_UNIT / 2))
 			break;
 
 		data->count = 0;
@@ -79,34 +81,34 @@ again:
 		return 0;
 
 	case STATE_HEADER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!eq_margin(ev.duration, JVC_HEADER_SPACE, JVC_UNIT / 2))
+		if (!eq_margin(ev.val, JVC_HEADER_SPACE, JVC_UNIT / 2))
 			break;
 
 		data->state = STATE_BIT_PULSE;
 		return 0;
 
 	case STATE_BIT_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, JVC_BIT_PULSE, JVC_UNIT / 2))
+		if (!eq_margin(ev.val, JVC_BIT_PULSE, JVC_UNIT / 2))
 			break;
 
 		data->state = STATE_BIT_SPACE;
 		return 0;
 
 	case STATE_BIT_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
 		data->bits <<= 1;
-		if (eq_margin(ev.duration, JVC_BIT_1_SPACE, JVC_UNIT / 2)) {
+		if (eq_margin(ev.val, JVC_BIT_1_SPACE, JVC_UNIT / 2)) {
 			data->bits |= 1;
 			decrease_duration(&ev, JVC_BIT_1_SPACE);
-		} else if (eq_margin(ev.duration, JVC_BIT_0_SPACE, JVC_UNIT / 2))
+		} else if (eq_margin(ev.val, JVC_BIT_0_SPACE, JVC_UNIT / 2))
 			decrease_duration(&ev, JVC_BIT_0_SPACE);
 		else
 			break;
@@ -119,20 +121,20 @@ again:
 		return 0;
 
 	case STATE_TRAILER_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, JVC_TRAILER_PULSE, JVC_UNIT / 2))
+		if (!eq_margin(ev.val, JVC_TRAILER_PULSE, JVC_UNIT / 2))
 			break;
 
 		data->state = STATE_TRAILER_SPACE;
 		return 0;
 
 	case STATE_TRAILER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!geq_margin(ev.duration, JVC_TRAILER_SPACE, JVC_UNIT / 2))
+		if (!geq_margin(ev.val, JVC_TRAILER_SPACE, JVC_UNIT / 2))
 			break;
 
 		if (data->first) {
@@ -156,10 +158,10 @@ again:
 		return 0;
 
 	case STATE_CHECK_REPEAT:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (eq_margin(ev.duration, JVC_HEADER_PULSE, JVC_UNIT / 2))
+		if (eq_margin(ev.val, JVC_HEADER_PULSE, JVC_UNIT / 2))
 			data->state = STATE_INACTIVE;
   else
 			data->state = STATE_BIT_PULSE;
@@ -168,7 +170,7 @@ again:
 
 out:
 	IR_dprintk(1, "JVC decode failed at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index a5b0368..52b27db 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -25,12 +25,12 @@
 /**
  * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
  *		      lircd userspace daemon for decoding.
- * @input_dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the lirc interfaces aren't wired up.
  */
-static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_lirc_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
@@ -42,29 +42,29 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return -EINVAL;
 
 	/* Packet start */
-	if (ev.reset)
+	if (ev.code == RC_IR_RAW_RESET)
 		return 0;
 
 	/* Carrier reports */
-	if (ev.carrier_report) {
-		sample = LIRC_FREQUENCY(ev.carrier);
+	if (ev.code == RC_IR_RAW_CARRIER) {
+		sample = LIRC_FREQUENCY(ev.val);
 		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
 
 	/* Packet end */
-	} else if (ev.timeout) {
+	} else if (ev.code == RC_IR_RAW_STOP) {
 
 		if (lirc->gap)
 			return 0;
 
 		lirc->gap_start = ktime_get();
 		lirc->gap = true;
-		lirc->gap_duration = ev.duration;
+		lirc->gap_duration = 0;
 
 		if (!lirc->send_timeout_reports)
 			return 0;
 
-		sample = LIRC_TIMEOUT(ev.duration / 1000);
-		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
+		sample = LIRC_TIMEOUT(0);
+		IR_dprintk(2, "timeout report\n");
 
 	/* Normal sample */
 	} else {
@@ -86,10 +86,10 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			lirc->gap = false;
 		}
 
-		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
-					LIRC_SPACE(ev.duration / 1000);
+		sample = is_pulse(ev) ? LIRC_PULSE(ev.val / 1000) :
+					LIRC_SPACE(ev.val / 1000);
 		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
-			   TO_US(ev.duration), TO_STR(ev.pulse));
+			   TO_US(ev.val), TO_STR(ev.code));
 	}
 
 	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
@@ -410,7 +410,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->rbuf = rbuf;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
-	drv->code_length = sizeof(struct ir_raw_event) * 8;
+	drv->code_length = sizeof(struct rc_event) * 8;
 	drv->fops = &lirc_fops;
 	drv->dev = &dev->dev;
 	drv->owner = THIS_MODULE;
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 9f3c9b5..f3d7dba 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -206,11 +206,11 @@ static void ir_mce_kbd_process_mouse_data(struct input_dev *idev, u32 scancode)
 /**
  * ir_mce_kbd_decode() - Decode one mce_kbd pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_mce_kbd_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u32 scancode;
@@ -219,32 +219,34 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
+	if (!geq_margin(ev.val, MCIR2_UNIT, MCIR2_UNIT / 2))
 		goto out;
 
 again:
 	IR_dprintk(2, "started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
-	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
+	if (!geq_margin(ev.val, MCIR2_UNIT, MCIR2_UNIT / 2))
 		return 0;
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
 		/* Note: larger margin on first pulse since each MCIR2_UNIT
 		   is quite short and some hardware takes some time to
 		   adjust to the signal */
-		if (!eq_margin(ev.duration, MCIR2_PREFIX_PULSE, MCIR2_UNIT))
+		if (!eq_margin(ev.val, MCIR2_PREFIX_PULSE, MCIR2_UNIT))
 			break;
 
 		data->state = STATE_HEADER_BIT_START;
@@ -253,11 +255,11 @@ again:
 		return 0;
 
 	case STATE_HEADER_BIT_START:
-		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
+		if (geq_margin(ev.val, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
 			break;
 
 		data->header <<= 1;
-		if (ev.pulse)
+		if (is_pulse(ev))
 			data->header |= 1;
 		data->count++;
 		data->state = STATE_HEADER_BIT_END;
@@ -292,11 +294,11 @@ again:
 		goto again;
 
 	case STATE_BODY_BIT_START:
-		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
+		if (geq_margin(ev.val, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
 			break;
 
 		data->body <<= 1;
-		if (ev.pulse)
+		if (is_pulse(ev))
 			data->body |= 1;
 		data->count++;
 		data->state = STATE_BODY_BIT_END;
@@ -315,7 +317,7 @@ again:
 		goto again;
 
 	case STATE_FINISHED:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
 		switch (data->wanted_bits) {
@@ -348,7 +350,7 @@ again:
 
 out:
 	IR_dprintk(1, "failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	input_sync(data->idev);
 	return -EINVAL;
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index c92b229..cf2feea 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -41,11 +41,11 @@ enum nec_state {
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
- * This function returns -EINVAL if the pulse violates the state machine
+ * This function returns -EINVAL if the event violates the state machine
  */
-static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_nec_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
@@ -54,25 +54,27 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!(dev->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
 	IR_dprintk(2, "NEC decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2)) {
+		if (eq_margin(ev.val, NEC_HEADER_PULSE, NEC_UNIT / 2)) {
 			data->is_nec_x = false;
 			data->necx_repeat = false;
-		} else if (eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
+		} else if (eq_margin(ev.val, NECX_HEADER_PULSE, NEC_UNIT / 2))
 			data->is_nec_x = true;
 		else
 			break;
@@ -82,13 +84,13 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_HEADER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT / 2)) {
+		if (eq_margin(ev.val, NEC_HEADER_SPACE, NEC_UNIT / 2)) {
 			data->state = STATE_BIT_PULSE;
 			return 0;
-		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
+		} else if (eq_margin(ev.val, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
 			rc_repeat(dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
@@ -98,22 +100,21 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		break;
 
 	case STATE_BIT_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, NEC_BIT_PULSE, NEC_UNIT / 2))
+		if (!eq_margin(ev.val, NEC_BIT_PULSE, NEC_UNIT / 2))
 			break;
 
 		data->state = STATE_BIT_SPACE;
 		return 0;
 
 	case STATE_BIT_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
 		if (data->necx_repeat && data->count == NECX_REPEAT_BITS &&
-			geq_margin(ev.duration,
-			NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
+		    geq_margin(ev.val, NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
 				IR_dprintk(1, "Repeat last key\n");
 				rc_repeat(dev);
 				data->state = STATE_INACTIVE;
@@ -123,9 +124,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->necx_repeat = false;
 
 		data->bits <<= 1;
-		if (eq_margin(ev.duration, NEC_BIT_1_SPACE, NEC_UNIT / 2))
+		if (eq_margin(ev.val, NEC_BIT_1_SPACE, NEC_UNIT / 2))
 			data->bits |= 1;
-		else if (!eq_margin(ev.duration, NEC_BIT_0_SPACE, NEC_UNIT / 2))
+		else if (!eq_margin(ev.val, NEC_BIT_0_SPACE, NEC_UNIT / 2))
 			break;
 		data->count++;
 
@@ -137,20 +138,20 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_TRAILER_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
+		if (!eq_margin(ev.val, NEC_TRAILER_PULSE, NEC_UNIT / 2))
 			break;
 
 		data->state = STATE_TRAILER_SPACE;
 		return 0;
 
 	case STATE_TRAILER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
+		if (!geq_margin(ev.val, NEC_TRAILER_SPACE, NEC_UNIT / 2))
 			break;
 
 		address     = bitrev8((data->bits >> 24) & 0xff);
@@ -171,7 +172,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 	IR_dprintk(1, "NEC decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->count, data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 9594b8f..c11eced 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -42,11 +42,11 @@ enum rc5_state {
 /**
  * ir_rc5_decode() - Decode one RC-5 pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_rc5_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
@@ -56,26 +56,28 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
+	if (!geq_margin(ev.val, RC5_UNIT, RC5_UNIT / 2))
 		goto out;
 
 again:
 	IR_dprintk(2, "RC5(x) decode started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
-	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
+	if (!geq_margin(ev.val, RC5_UNIT, RC5_UNIT / 2))
 		return 0;
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
 		data->state = STATE_BIT_START;
@@ -84,16 +86,16 @@ again:
 		goto again;
 
 	case STATE_BIT_START:
-		if (!ev.pulse && geq_margin(ev.duration, RC5_TRAILER, RC5_UNIT / 2)) {
+		if (is_space(ev) && geq_margin(ev.val, RC5_TRAILER, RC5_UNIT / 2)) {
 			data->state = STATE_FINISHED;
 			goto again;
 		}
 
-		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
+		if (!eq_margin(ev.val, RC5_BIT_START, RC5_UNIT / 2))
 			break;
 
 		data->bits <<= 1;
-		if (!ev.pulse)
+		if (is_space(ev))
 			data->bits |= 1;
 		data->count++;
 		data->state = STATE_BIT_END;
@@ -112,7 +114,7 @@ again:
 		goto again;
 
 	case STATE_CHECK_RC5X:
-		if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 2)) {
+		if (is_space(ev) && geq_margin(ev.val, RC5X_SPACE, RC5_UNIT / 2)) {
 			data->is_rc5x = true;
 			decrease_duration(&ev, RC5X_SPACE);
 		} else
@@ -121,7 +123,7 @@ again:
 		goto again;
 
 	case STATE_FINISHED:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
 		if (data->is_rc5x && data->count == RC5X_NBITS) {
@@ -166,7 +168,7 @@ again:
 
 out:
 	IR_dprintk(1, "RC5(x) decode failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 571107e..daf0c23 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -79,11 +79,11 @@ static enum rc6_mode rc6_mode(struct rc6_dec *data)
 /**
  * ir_rc6_decode() - Decode one RC6 pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_rc6_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct rc6_dec *data = &dev->raw->rc6;
 	u32 scancode;
@@ -95,32 +95,34 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
+	if (!geq_margin(ev.val, RC6_UNIT, RC6_UNIT / 2))
 		goto out;
 
 again:
 	IR_dprintk(2, "RC6 decode started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
-	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
+	if (!geq_margin(ev.val, RC6_UNIT, RC6_UNIT / 2))
 		return 0;
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
 		/* Note: larger margin on first pulse since each RC6_UNIT
 		   is quite short and some hardware takes some time to
 		   adjust to the signal */
-		if (!eq_margin(ev.duration, RC6_PREFIX_PULSE, RC6_UNIT))
+		if (!eq_margin(ev.val, RC6_PREFIX_PULSE, RC6_UNIT))
 			break;
 
 		data->state = STATE_PREFIX_SPACE;
@@ -128,10 +130,10 @@ again:
 		return 0;
 
 	case STATE_PREFIX_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!eq_margin(ev.duration, RC6_PREFIX_SPACE, RC6_UNIT / 2))
+		if (!eq_margin(ev.val, RC6_PREFIX_SPACE, RC6_UNIT / 2))
 			break;
 
 		data->state = STATE_HEADER_BIT_START;
@@ -139,11 +141,11 @@ again:
 		return 0;
 
 	case STATE_HEADER_BIT_START:
-		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
+		if (!eq_margin(ev.val, RC6_BIT_START, RC6_UNIT / 2))
 			break;
 
 		data->header <<= 1;
-		if (ev.pulse)
+		if (is_pulse(ev))
 			data->header |= 1;
 		data->count++;
 		data->state = STATE_HEADER_BIT_END;
@@ -162,16 +164,16 @@ again:
 		goto again;
 
 	case STATE_TOGGLE_START:
-		if (!eq_margin(ev.duration, RC6_TOGGLE_START, RC6_UNIT / 2))
+		if (!eq_margin(ev.val, RC6_TOGGLE_START, RC6_UNIT / 2))
 			break;
 
-		data->toggle = ev.pulse;
+		data->toggle = is_pulse(ev);
 		data->state = STATE_TOGGLE_END;
 		return 0;
 
 	case STATE_TOGGLE_END:
 		if (!is_transition(&ev, &dev->raw->prev_ev) ||
-		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
+		    !geq_margin(ev.val, RC6_TOGGLE_END, RC6_UNIT / 2))
 			break;
 
 		if (!(data->header & RC6_STARTBIT_MASK)) {
@@ -198,17 +200,17 @@ again:
 		goto again;
 
 	case STATE_BODY_BIT_START:
-		if (eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2)) {
+		if (eq_margin(ev.val, RC6_BIT_START, RC6_UNIT / 2)) {
 			/* Discard LSB's that won't fit in data->body */
 			if (data->count++ < CHAR_BIT * sizeof data->body) {
 				data->body <<= 1;
-				if (ev.pulse)
+				if (is_pulse(ev))
 					data->body |= 1;
 			}
 			data->state = STATE_BODY_BIT_END;
 			return 0;
-		} else if (RC6_MODE_6A == rc6_mode(data) && !ev.pulse &&
-				geq_margin(ev.duration, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
+		} else if (RC6_MODE_6A == rc6_mode(data) && is_space(ev) &&
+				geq_margin(ev.val, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
 			data->state = STATE_FINISHED;
 			goto again;
 		}
@@ -227,7 +229,7 @@ again:
 		goto again;
 
 	case STATE_FINISHED:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
 		switch (rc6_mode(data)) {
@@ -277,7 +279,7 @@ again:
 
 out:
 	IR_dprintk(1, "RC6 decode failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 17ee339..4cdbd6d 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -48,11 +48,11 @@ enum sanyo_state {
 /**
  * ir_sanyo_decode() - Decode one SANYO pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_sanyo_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct sanyo_dec *data = &dev->raw->sanyo;
 	u32 scancode;
@@ -61,24 +61,24 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!(dev->enabled_protocols & RC_BIT_SANYO))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset) {
-			IR_dprintk(1, "SANYO event reset received. reset to state 0\n");
-			data->state = STATE_INACTIVE;
-		}
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
 	IR_dprintk(2, "SANYO decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (eq_margin(ev.duration, SANYO_HEADER_PULSE, SANYO_UNIT / 2)) {
+		if (eq_margin(ev.val, SANYO_HEADER_PULSE, SANYO_UNIT / 2)) {
 			data->count = 0;
 			data->state = STATE_HEADER_SPACE;
 			return 0;
@@ -87,10 +87,10 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 
 	case STATE_HEADER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (eq_margin(ev.duration, SANYO_HEADER_SPACE, SANYO_UNIT / 2)) {
+		if (eq_margin(ev.val, SANYO_HEADER_SPACE, SANYO_UNIT / 2)) {
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		}
@@ -98,20 +98,20 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		break;
 
 	case STATE_BIT_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, SANYO_BIT_PULSE, SANYO_UNIT / 2))
+		if (!eq_margin(ev.val, SANYO_BIT_PULSE, SANYO_UNIT / 2))
 			break;
 
 		data->state = STATE_BIT_SPACE;
 		return 0;
 
 	case STATE_BIT_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
+		if (!data->count && geq_margin(ev.val, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
 			rc_repeat(dev);
 			IR_dprintk(1, "SANYO repeat last key\n");
 			data->state = STATE_INACTIVE;
@@ -119,9 +119,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		}
 
 		data->bits <<= 1;
-		if (eq_margin(ev.duration, SANYO_BIT_1_SPACE, SANYO_UNIT / 2))
+		if (eq_margin(ev.val, SANYO_BIT_1_SPACE, SANYO_UNIT / 2))
 			data->bits |= 1;
-		else if (!eq_margin(ev.duration, SANYO_BIT_0_SPACE, SANYO_UNIT / 2))
+		else if (!eq_margin(ev.val, SANYO_BIT_0_SPACE, SANYO_UNIT / 2))
 			break;
 		data->count++;
 
@@ -133,20 +133,20 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_TRAILER_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, SANYO_TRAILER_PULSE, SANYO_UNIT / 2))
+		if (!eq_margin(ev.val, SANYO_TRAILER_PULSE, SANYO_UNIT / 2))
 			break;
 
 		data->state = STATE_TRAILER_SPACE;
 		return 0;
 
 	case STATE_TRAILER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!geq_margin(ev.duration, SANYO_TRAILER_SPACE, SANYO_UNIT / 2))
+		if (!geq_margin(ev.val, SANYO_TRAILER_SPACE, SANYO_UNIT / 2))
 			break;
 
 		address     = bitrev16((data->bits >> 29) & 0x1fff) >> 3;
@@ -169,7 +169,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 	IR_dprintk(1, "SANYO decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->count, data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index f360e40..8f1be85 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -35,11 +35,11 @@ enum sony_state {
 /**
  * ir_sony_decode() - Decode one Sony pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @ev:         the struct ir_raw_event descriptor of the pulse/space
+ * @ev:         the struct rc_event descriptor of the event
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
+static int ir_sony_decode(struct rc_dev *dev, struct rc_event ev)
 {
 	struct sony_dec *data = &dev->raw->sony;
 	u32 scancode;
@@ -50,25 +50,27 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
+	if (ev.code == RC_IR_RAW_RESET) {
+		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2))
+	if (!is_ir_raw_timing_event(ev))
+		return 0;
+
+	if (!geq_margin(ev.val, SONY_UNIT, SONY_UNIT / 2))
 		goto out;
 
 	IR_dprintk(2, "Sony decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
-		if (!eq_margin(ev.duration, SONY_HEADER_PULSE, SONY_UNIT / 2))
+		if (!eq_margin(ev.val, SONY_HEADER_PULSE, SONY_UNIT / 2))
 			break;
 
 		data->count = 0;
@@ -76,23 +78,23 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_HEADER_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!eq_margin(ev.duration, SONY_HEADER_SPACE, SONY_UNIT / 2))
+		if (!eq_margin(ev.val, SONY_HEADER_SPACE, SONY_UNIT / 2))
 			break;
 
 		data->state = STATE_BIT_PULSE;
 		return 0;
 
 	case STATE_BIT_PULSE:
-		if (!ev.pulse)
+		if (is_space(ev))
 			break;
 
 		data->bits <<= 1;
-		if (eq_margin(ev.duration, SONY_BIT_1_PULSE, SONY_UNIT / 2))
+		if (eq_margin(ev.val, SONY_BIT_1_PULSE, SONY_UNIT / 2))
 			data->bits |= 1;
-		else if (!eq_margin(ev.duration, SONY_BIT_0_PULSE, SONY_UNIT / 2))
+		else if (!eq_margin(ev.val, SONY_BIT_0_PULSE, SONY_UNIT / 2))
 			break;
 
 		data->count++;
@@ -100,15 +102,15 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_BIT_SPACE:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!geq_margin(ev.duration, SONY_BIT_SPACE, SONY_UNIT / 2))
+		if (!geq_margin(ev.val, SONY_BIT_SPACE, SONY_UNIT / 2))
 			break;
 
 		decrease_duration(&ev, SONY_BIT_SPACE);
 
-		if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2)) {
+		if (!geq_margin(ev.val, SONY_UNIT, SONY_UNIT / 2)) {
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		}
@@ -117,10 +119,10 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		/* Fall through */
 
 	case STATE_FINISHED:
-		if (ev.pulse)
+		if (is_pulse(ev))
 			break;
 
-		if (!geq_margin(ev.duration, SONY_TRAILER_SPACE, SONY_UNIT / 2))
+		if (!geq_margin(ev.val, SONY_TRAILER_SPACE, SONY_UNIT / 2))
 			break;
 
 		switch (data->count) {
@@ -158,7 +160,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 out:
 	IR_dprintk(1, "Sony decode failed at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+		   data->state, TO_US(ev.val), TO_STR(ev.code));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 51fb845..dcef9e5 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -190,16 +190,15 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 	size = length << 3;
 	next_one = find_next_bit_le(ldata, size, 0);
 	if (next_one > 0) {
-		ev.pulse = true;
-		ev.duration =
-		    ITE_BITS_TO_NS(next_one, sample_period);
+		ev.code = RC_IR_RAW_PULSE;
+		ev.val = ITE_BITS_TO_NS(next_one, sample_period);
 		ir_raw_event_store_with_filter(dev->rdev, &ev);
 	}
 
 	while (next_one < size) {
 		next_zero = find_next_zero_bit_le(ldata, size, next_one + 1);
-		ev.pulse = false;
-		ev.duration = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
+		ev.code = RC_IR_RAW_SPACE;
+		ev.val = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
 		ir_raw_event_store_with_filter(dev->rdev, &ev);
 
 		if (next_zero < size) {
@@ -207,12 +206,10 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 			    find_next_bit_le(ldata,
 						     size,
 						     next_zero + 1);
-			ev.pulse = true;
-			ev.duration =
-			    ITE_BITS_TO_NS(next_one - next_zero,
-					   sample_period);
-			ir_raw_event_store_with_filter
-			    (dev->rdev, &ev);
+			ev.code = RC_IR_RAW_PULSE;
+			ev.val = ITE_BITS_TO_NS(next_one - next_zero,
+						sample_period);
+			ir_raw_event_store_with_filter(dev->rdev, &ev);
 		} else
 			next_one = size;
 	}
diff --git a/drivers/media/rc/ite-cir.h b/drivers/media/rc/ite-cir.h
index aa899a0..5c1fa57 100644
--- a/drivers/media/rc/ite-cir.h
+++ b/drivers/media/rc/ite-cir.h
@@ -125,7 +125,7 @@ struct ite_dev_params {
 struct ite_dev {
 	struct pnp_dev *pdev;
 	struct rc_dev *rdev;
-	struct ir_raw_event rawir;
+	struct rc_event rawir;
 
 	/* sync data */
 	spinlock_t lock;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 952ea01..4652c11 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -959,13 +959,16 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		case PARSE_IRDATA:
 			ir->rem--;
 			init_ir_raw_event(&rawir);
-			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
-			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
-					 * US_TO_NS(MCE_TIME_UNIT);
+			if (ir->buf_in[i] & MCE_PULSE_BIT)
+				rawir.code = RC_IR_RAW_PULSE;
+			else
+				rawir.code = RC_IR_RAW_SPACE;
+			rawir.val = (ir->buf_in[i] & MCE_PULSE_MASK) *
+				    US_TO_NS(MCE_TIME_UNIT);
 
-			mce_dbg(ir->dev, "Storing %s with duration %d\n",
-				rawir.pulse ? "pulse" : "space",
-				rawir.duration);
+			mce_dbg(ir->dev, "Storing %s with duration %llu\n",
+				rawir.code == RC_IR_RAW_PULSE ? "pulse" : "space",
+				(long long unsigned)rawir.val);
 
 			ir_raw_event_store_with_filter(ir->rc, &rawir);
 			break;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 4c37ade..aae1a09 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -612,7 +612,7 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
  */
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	DEFINE_IR_RAW_EVENT(ev);
 	u32 carrier;
 	u8 sample;
 	int i;
@@ -627,19 +627,19 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
-	init_ir_raw_event(&rawir);
-
 	for (i = 0; i < nvt->pkts; i++) {
 		sample = nvt->buf[i];
 
-		rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
-		rawir.duration = US_TO_NS((sample & BUF_LEN_MASK)
-					  * SAMPLE_PERIOD);
+		ev.code = RC_IR_RAW_SPACE;
+		if (sample & BUF_PULSE_BIT)
+			ev.code = RC_IR_RAW_PULSE;
+		ev.val = US_TO_NS((sample & BUF_LEN_MASK) * SAMPLE_PERIOD);
 
-		nvt_dbg("Storing %s with duration %d",
-			rawir.pulse ? "pulse" : "space", rawir.duration);
+		nvt_dbg("Storing %s with duration %llu",
+			ev.code == RC_IR_RAW_PULSE ? "pulse" : "space",
+			(long long unsigned)ev.val);
 
-		ir_raw_event_store_with_filter(nvt->rdev, &rawir);
+		ir_raw_event_store_with_filter(nvt->rdev, &ev);
 
 		/*
 		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 54af19a..376030e 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -26,7 +26,7 @@ struct ir_raw_handler {
 	struct list_head list;
 
 	unsigned protocols; /* which are handled by this handler */
-	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
+	int (*decode)(struct rc_dev *dev, struct rc_event event);
 
 	/* These two should only be used by the lirc decoder */
 	int (*raw_register)(struct rc_dev *dev);
@@ -39,14 +39,14 @@ struct ir_raw_handler {
 struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
-	DECLARE_KFIFO(kfifo, struct ir_raw_event, RC_MAX_IR_EVENTS); /* for pulse/space durations */
+	DECLARE_KFIFO(kfifo, struct rc_event, RC_MAX_IR_EVENTS); /* for pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
 
 	/* raw decoder state follows */
-	struct ir_raw_event prev_ev;
-	struct ir_raw_event this_ev;
+	struct rc_event prev_ev;
+	struct rc_event this_ev;
 	struct nec_dec {
 		int state;
 		unsigned count;
@@ -121,27 +121,28 @@ static inline bool eq_margin(unsigned d1, unsigned d2, unsigned margin)
 	return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
 }
 
-static inline bool is_transition(struct ir_raw_event *x, struct ir_raw_event *y)
+static inline bool is_transition(struct rc_event *x, struct rc_event *y)
 {
-	return x->pulse != y->pulse;
+	return x->code != y->code;
 }
 
-static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
+static inline void decrease_duration(struct rc_event *ev, unsigned duration)
 {
-	if (duration > ev->duration)
-		ev->duration = 0;
-	else
-		ev->duration -= duration;
+	ev->val -= min_t(u64, ev->val, duration);
 }
 
-/* Returns true if event is normal pulse/space event */
-static inline bool is_timing_event(struct ir_raw_event ev)
+static inline bool is_pulse(struct rc_event ev)
 {
-	return !ev.carrier_report && !ev.reset;
+	return ev.code == RC_IR_RAW_PULSE;
 }
 
-#define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
-#define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
+static inline bool is_space(struct rc_event ev)
+{
+	return ev.code == RC_IR_RAW_SPACE;
+}
+
+#define TO_US(duration)			((unsigned)DIV_ROUND_CLOSEST((duration), 1000))
+#define TO_STR(code)			((code == RC_IR_RAW_PULSE) ? "pulse" : "space")
 
 /*
  * Routines from rc-raw.c to be used internally and by decoders
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e6a6eea..6a60ad6 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -33,12 +33,12 @@ static atomic_t available_protocols = ATOMIC_INIT(0);
 
 static int ir_raw_event_thread(void *data)
 {
-	struct ir_raw_event ev;
+	struct rc_event ev;
 	struct ir_raw_handler *handler;
 	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
 
 	while (!kthread_should_stop()) {
-		if (kfifo_out(&raw->kfifo, &ev, 1) == 0) {
+		if (!kfifo_get(&raw->kfifo, &ev)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			continue;
@@ -57,36 +57,29 @@ static int ir_raw_event_thread(void *data)
 /**
  * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
  * @dev:	the struct rc_dev device descriptor
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct rc_event descriptor of the event
  *
- * This routine (which may be called from an interrupt context) stores a
- * pulse/space duration for the raw ir decoding state machines. Pulses are
- * signalled as positive values and spaces as negative values. A zero value
- * will reset the decoding state machines. Drivers are responsible for
- * synchronizing calls to this function.
+ * This routine (which may be called from an interrupt context) stores an
+ * event for the raw ir decoding state machines and interested userspace
+ * processes.
+ *
+ * Drivers are responsible for synchronizing calls to this function.
  */
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
+int ir_raw_event_store(struct rc_dev *dev, struct rc_event *ev)
 {
 	if (!dev->raw)
 		return -EINVAL;
 
-	IR_dprintk(2, "sample: (%05dus %s)\n",
-		   TO_US(ev->duration), TO_STR(ev->pulse));
-
-	if (ev->reset)
-		rc_event(dev, RC_IR_RAW, RC_IR_RAW_RESET, 1);
-	else if (ev->carrier_report)
-		rc_event(dev, RC_IR_RAW, RC_IR_RAW_CARRIER, ev->carrier);
-	else if (ev->timeout)
-		rc_event(dev, RC_IR_RAW, RC_IR_RAW_STOP, 1);
-	else if (ev->pulse)
-		rc_event(dev, RC_IR_RAW, RC_IR_RAW_PULSE, ev->duration);
-	else
-		rc_event(dev, RC_IR_RAW, RC_IR_RAW_SPACE, ev->duration);
+	if (ev->type != RC_IR_RAW)
+		return -EINVAL;
+
+	if (ev->reserved)
+		return -EINVAL;
 
-	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
+	if (!kfifo_put(&dev->raw->kfifo, ev))
 		return -ENOMEM;
 
+	rc_event(dev, ev->type, ev->code, ev->val);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store);
@@ -122,15 +115,15 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
-		ev.duration = delta;
+		ev.val = delta;
 
 	if (type & IR_START_EVENT)
 		ir_raw_event_reset(dev);
 	else if (dev->raw->last_type & IR_SPACE) {
-		ev.pulse = false;
+		ev.code = RC_IR_RAW_SPACE;
 		rc = ir_raw_event_store(dev, &ev);
 	} else if (dev->raw->last_type & IR_PULSE) {
-		ev.pulse = true;
+		ev.code = RC_IR_RAW_PULSE;
 		rc = ir_raw_event_store(dev, &ev);
 	} else
 		return 0;
@@ -144,36 +137,42 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
 /**
  * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
  * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
+ * @ev:		the struct rc_event descriptor of the event
  *
  * This routine (which may be called from an interrupt context) works
  * in similar manner to ir_raw_event_store_edge.
  * This routine is intended for devices with limited internal buffer
  * It automerges samples of same type, and handles timeouts
  */
-int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct rc_event *ev)
 {
 	if (!dev->raw)
 		return -EINVAL;
 
 	/* Ignore spaces in idle mode */
-	if (dev->idle && !ev->pulse)
-		return 0;
-	else if (dev->idle)
+	if (dev->idle) {
+		if (ev->code == RC_IR_RAW_SPACE)
+			return 0;
 		ir_raw_event_set_idle(dev, false);
+	}
 
-	if (!dev->raw->this_ev.duration)
+	if (!is_ir_raw_timing_event(*ev)) {
+		ir_raw_event_store(dev, &dev->raw->this_ev);
+		return 0;
+	}
+
+	if (!dev->raw->this_ev.val)
 		dev->raw->this_ev = *ev;
-	else if (ev->pulse == dev->raw->this_ev.pulse)
-		dev->raw->this_ev.duration += ev->duration;
+	else if (ev->code == dev->raw->this_ev.code)
+		dev->raw->this_ev.val += ev->val;
 	else {
 		ir_raw_event_store(dev, &dev->raw->this_ev);
 		dev->raw->this_ev = *ev;
 	}
 
 	/* Enter idle mode if nessesary */
-	if (!ev->pulse && dev->timeout &&
-	    dev->raw->this_ev.duration >= dev->timeout)
+	if (ev->code == RC_IR_RAW_SPACE && dev->timeout &&
+	    dev->raw->this_ev.val >= dev->timeout)
 		ir_raw_event_set_idle(dev, true);
 
 	return 0;
@@ -187,17 +186,30 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
  */
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
 {
+	DEFINE_IR_RAW_EVENT(ev);
+
 	if (!dev->raw)
 		return;
 
+	if (dev->idle == idle)
+		return;
+
 	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
 
+
 	if (idle) {
-		dev->raw->this_ev.timeout = true;
-		ir_raw_event_store(dev, &dev->raw->this_ev);
-		init_ir_raw_event(&dev->raw->this_ev);
+		if (dev->raw->this_ev.val > 0)
+			ir_raw_event_store(dev, &dev->raw->this_ev);
+		ev.code = RC_IR_RAW_STOP;
+		ev.val = 1;
+	} else {
+		ev.code = RC_IR_RAW_START;
+		ev.val = 1;
 	}
 
+	init_ir_raw_event(&dev->raw->this_ev);
+	ir_raw_event_store(dev, &ev);
+
 	if (dev->s_idle)
 		dev->s_idle(dev, idle);
 
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 45ef966..f0e6e35 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -53,8 +53,7 @@ static int loop_tx_ir(struct rc_dev *dev)
 {
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
-	struct rc_event event;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct rc_event ev;
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
 	    lodev->txcarrier > lodev->rxcarriermax) {
@@ -74,21 +73,17 @@ static int loop_tx_ir(struct rc_dev *dev)
 		return 0;
 	}
 
-	while (kfifo_get(&dev->txfifo, &event)) {
-		if (is_ir_raw_timing_event(event))
+	while (kfifo_get(&dev->txfifo, &ev)) {
+		if (!is_ir_raw_timing_event(ev))
 			continue;
-		init_ir_raw_event(&rawir);
-		rawir.duration = event.val;
-		if (event.code == RC_IR_RAW_PULSE)
-			rawir.pulse = true;
-		ir_raw_event_store_with_filter(dev, &rawir);
+		ir_raw_event_store_with_filter(dev, &ev);
 	}
 
 	/* Fake a silence long enough to cause us to go idle */
-	init_ir_raw_event(&rawir);
-	rawir.pulse = false;
-	rawir.duration = dev->timeout;
-	ir_raw_event_store_with_filter(dev, &rawir);
+	init_ir_raw_event(&ev);
+	ev.code = RC_IR_RAW_SPACE;
+	ev.val = dev->timeout;
+	ir_raw_event_store_with_filter(dev, &ev);
 
 	ir_raw_event_handle(dev);
 
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 760f13e..548603b 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -414,7 +414,7 @@ static void redrat3_rx_timeout(unsigned long data)
 
 static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	DEFINE_IR_RAW_EVENT(ev);
 	struct redrat3_signal_header header;
 	struct device *dev;
 	int i, trailer = 0;
@@ -488,34 +488,27 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 		single_len = redrat3_len_to_us((u32)be16_to_cpu(val));
 
 		/* we should always get pulse/space/pulse/space samples */
-		if (i % 2)
-			rawir.pulse = false;
-		else
-			rawir.pulse = true;
+		ev.code = i % 2 ? RC_IR_RAW_SPACE : RC_IR_RAW_PULSE;
+		ev.val = min_t(u64, IR_MAX_DURATION, US_TO_NS(single_len));
 
-		rawir.duration = US_TO_NS(single_len);
 		/* Save initial pulse length to fudge trailer */
 		if (i == 0)
-			trailer = rawir.duration;
-		/* cap the value to IR_MAX_DURATION */
-		rawir.duration &= IR_MAX_DURATION;
+			trailer = single_len;
 
-		rr3_dbg(dev, "storing %s with duration %d (i: %d)\n",
-			rawir.pulse ? "pulse" : "space", rawir.duration, i);
-		ir_raw_event_store_with_filter(rr3->rc, &rawir);
+		rr3_dbg(dev, "storing %s with duration %llu (i: %d)\n",
+			ev.code == RC_IR_RAW_PULSE ? "pulse" : "space",
+			(long long unsigned)ev.val, i);
+		ir_raw_event_store_with_filter(rr3->rc, &ev);
 	}
 
 	/* add a trailing space, if need be */
 	if (i % 2) {
-		rawir.pulse = false;
+		ev.code = RC_IR_RAW_SPACE;
 		/* this duration is made up, and may not be ideal... */
-		if (trailer < US_TO_NS(1000))
-			rawir.duration = US_TO_NS(2800);
-		else
-			rawir.duration = trailer;
-		rr3_dbg(dev, "storing trailing space with duration %d\n",
-			rawir.duration);
-		ir_raw_event_store_with_filter(rr3->rc, &rawir);
+		ev.val = US_TO_NS(trailer < 1000 ? 2800 : trailer);
+		rr3_dbg(dev, "storing trailing space with duration %llu\n",
+			(long long unsigned)ev.val);
+		ir_raw_event_store_with_filter(rr3->rc, &ev);
 	}
 
 	rr3_dbg(dev, "calling ir_raw_event_handle\n");
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 4156197..9049383 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -129,17 +129,18 @@ static struct usb_driver streamzap_driver = {
 	.id_table =	streamzap_table,
 };
 
-static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
+static void sz_push(struct streamzap_ir *sz, struct rc_event ev)
 {
 	dev_dbg(sz->dev, "Storing %s with duration %u us\n",
-		(rawir.pulse ? "pulse" : "space"), rawir.duration);
-	ir_raw_event_store_with_filter(sz->rdev, &rawir);
+		(ev.code == RC_IR_RAW_PULSE ? "pulse" : "space"),
+		(unsigned)(ev.val / 1000));
+	ir_raw_event_store_with_filter(sz->rdev, &ev);
 }
 
 static void sz_push_full_pulse(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	DEFINE_IR_RAW_EVENT(ev);
 
 	if (sz->idle) {
 		long deltv;
@@ -148,31 +149,29 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 		do_gettimeofday(&sz->signal_start);
 
 		deltv = sz->signal_start.tv_sec - sz->signal_last.tv_sec;
-		rawir.pulse = false;
+		ev.code = RC_IR_RAW_SPACE;
 		if (deltv > 15) {
 			/* really long time */
-			rawir.duration = IR_MAX_DURATION;
+			ev.val = IR_MAX_DURATION;
 		} else {
-			rawir.duration = (int)(deltv * 1000000 +
-				sz->signal_start.tv_usec -
-				sz->signal_last.tv_usec);
-			rawir.duration -= sz->sum;
-			rawir.duration = US_TO_NS(rawir.duration);
-			rawir.duration &= IR_MAX_DURATION;
+			ev.val = (deltv * 1000000 +
+				  sz->signal_start.tv_usec -
+				  sz->signal_last.tv_usec);
+			ev.val -= sz->sum;
+			ev.val = min_t(u64, US_TO_NS(ev.val), IR_MAX_DURATION);
 		}
-		sz_push(sz, rawir);
+		sz_push(sz, ev);
 
 		sz->idle = false;
 		sz->sum = 0;
 	}
 
-	rawir.pulse = true;
-	rawir.duration = ((int) value) * SZ_RESOLUTION;
-	rawir.duration += SZ_RESOLUTION / 2;
-	sz->sum += rawir.duration;
-	rawir.duration = US_TO_NS(rawir.duration);
-	rawir.duration &= IR_MAX_DURATION;
-	sz_push(sz, rawir);
+	ev.code = RC_IR_RAW_PULSE;
+	ev.val = value * SZ_RESOLUTION;
+	ev.val += SZ_RESOLUTION / 2;
+	sz->sum += ev.val;
+	ev.val = min_t(u64, US_TO_NS(ev.val), IR_MAX_DURATION);
+	sz_push(sz, ev);
 }
 
 static void sz_push_half_pulse(struct streamzap_ir *sz,
@@ -184,14 +183,13 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
 static void sz_push_full_space(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
-
-	rawir.pulse = false;
-	rawir.duration = ((int) value) * SZ_RESOLUTION;
-	rawir.duration += SZ_RESOLUTION / 2;
-	sz->sum += rawir.duration;
-	rawir.duration = US_TO_NS(rawir.duration);
-	sz_push(sz, rawir);
+	DEFINE_IR_RAW_EVENT(ev);
+
+	ev.code = RC_IR_RAW_SPACE;
+	ev.val = value * SZ_RESOLUTION + SZ_RESOLUTION / 2;
+	sz->sum += ev.val;
+	ev.val = US_TO_NS(ev.val);
+	sz_push(sz, ev);
 }
 
 static void sz_push_half_space(struct streamzap_ir *sz,
@@ -258,13 +256,13 @@ static void streamzap_callback(struct urb *urb)
 			break;
 		case FullSpace:
 			if (sz->buf_in[i] == SZ_TIMEOUT) {
-				DEFINE_IR_RAW_EVENT(rawir);
+				DEFINE_IR_RAW_EVENT(ev);
 
-				rawir.pulse = false;
-				rawir.duration = sz->rdev->timeout;
+				ev.code = RC_IR_RAW_STOP;
+				ev.val = 1;
 				sz->idle = true;
 				if (sz->timeout_enabled)
-					sz_push(sz, rawir);
+					sz_push(sz, ev);
 				ir_raw_event_handle(sz->rdev);
 				ir_raw_event_reset(sz->rdev);
 			} else {
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 76a8104..d141f8e 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -208,7 +208,6 @@ struct wbcir_data {
 	/* RX state */
 	enum wbcir_rxstate rxstate;
 	struct led_trigger *rxtrigger;
-	struct ir_raw_event rxev;
 
 	/* TX state */
 	enum wbcir_txstate txstate;
@@ -355,8 +354,8 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		irdata = inb(data->sbase + WBCIR_REG_SP3_RXDATA);
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
-		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
+		rawir.code = irdata & 0x80 ? RC_IR_RAW_SPACE : RC_IR_RAW_PULSE;
+		rawir.val = US_TO_NS((irdata & 0x7F) * 10);
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
@@ -917,9 +916,7 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/* Clear RX state */
 	data->rxstate = WBCIR_RXSTATE_INACTIVE;
-	data->rxev.duration = 0;
 	ir_raw_event_reset(data->dev);
-	ir_raw_event_handle(data->dev);
 
 	/*
 	 * Check TX state, if we did a suspend/resume cycle while TX was
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index dbf0d34..fb41795 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -51,18 +51,17 @@ static void cx23885_input_process_measurements(struct cx23885_dev *dev,
 	ssize_t num;
 	int count, i;
 	bool handle = false;
-	struct ir_raw_event ir_core_event[64];
+	struct rc_event ev[64];
 
 	do {
 		num = 0;
-		v4l2_subdev_call(dev->sd_ir, ir, rx_read, (u8 *) ir_core_event,
-				 sizeof(ir_core_event), &num);
+		v4l2_subdev_call(dev->sd_ir, ir, rx_read, (u8 *)ev,
+				 sizeof(rc_event), &num);
 
-		count = num / sizeof(struct ir_raw_event);
+		count = num / sizeof(struct rc_event);
 
 		for (i = 0; i < count; i++) {
-			ir_raw_event_store(kernel_ir->rc,
-					   &ir_core_event[i]);
+			ir_raw_event_store(kernel_ir->rc, &ev[i]);
 			handle = true;
 		}
 	} while (num != 0);
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index f3609a2..2e6ffe8 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -116,12 +116,12 @@ MODULE_PARM_DESC(ir_888_debug, "enable debug messages [CX23888 IR controller]");
 
 /*
  * We use this union internally for convenience, but callers to tx_write
- * and rx_read will be expecting records of type struct ir_raw_event.
- * Always ensure the size of this union is dictated by struct ir_raw_event.
+ * and rx_read will be expecting records of type struct rc_event.
+ * Always ensure the size of this union is dictated by struct rc_event.
  */
 union cx23888_ir_fifo_rec {
 	u32 hw_fifo_data;
-	struct ir_raw_event ir_core_data;
+	struct rc_event ir_core_data;
 };
 
 #define CX23888_IR_RX_KFIFO_SIZE    (256 * sizeof(union cx23888_ir_fifo_rec))
@@ -662,57 +662,62 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
 }
 
 /* Receiver */
-static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
-			      ssize_t *num)
+static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t bufsize,
+			      ssize_t *bytes_read)
 {
 	struct cx23888_ir_state *state = to_state(sd);
-	bool invert = (bool) atomic_read(&state->rx_invert);
-	u16 divider = (u16) atomic_read(&state->rxclk_divider);
-
-	unsigned int i, n;
-	union cx23888_ir_fifo_rec *p;
-	unsigned u, v, w;
-
-	n = count / sizeof(union cx23888_ir_fifo_rec)
-		* sizeof(union cx23888_ir_fifo_rec);
-	if (n == 0) {
-		*num = 0;
-		return 0;
-	}
-
-	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
-
-	n /= sizeof(union cx23888_ir_fifo_rec);
-	*num = n * sizeof(union cx23888_ir_fifo_rec);
-
-	for (p = (union cx23888_ir_fifo_rec *) buf, i = 0; i < n; p++, i++) {
+	bool invert = (bool)atomic_read(&state->rx_invert);
+	u16 divider = (u16)atomic_read(&state->rxclk_divider);
+	struct rc_event *ev = (struct rc_event *)buf;
+	union cx23888_ir_fifo_rec rec;
+	unsigned max_events;
+	unsigned events = 0;
+	bool pulse, timeout;
+	u64 val;
+
+	max_events = bufsize / sizeof(union cx23888_ir_fifo_rec);
+
+	while (events + 2 <= max_events) {
+		if (kfifo_out_spinlocked(&state->rx_kfifo, &rec, sizeof(rec),
+					 &state->rx_kfifo_lock) != sizeof(rec))
+			break;
 
-		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
+		if (rec.hw_fifo_data & FIFO_RXTX_RTO) {
 			/* Assume RTO was because of no IR light input */
-			u = 0;
-			w = 1;
+			pulse = false;
+			timeout = true;
 		} else {
-			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
+			pulse = (rec.hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
 			if (invert)
-				u = u ? 0 : 1;
-			w = 0;
+				pulse = !pulse;
+			timeout = false;
 		}
 
-		v = (unsigned) pulse_width_count_to_ns(
-				  (u16) (p->hw_fifo_data & FIFO_RXTX), divider);
-		if (v > IR_MAX_DURATION)
-			v = IR_MAX_DURATION;
-
-		init_ir_raw_event(&p->ir_core_data);
-		p->ir_core_data.pulse = u;
-		p->ir_core_data.duration = v;
-		p->ir_core_data.timeout = w;
+		val = min_t(u64, IR_MAX_DURATION,
+			    pulse_width_count_to_ns(rec.hw_fifo_data & FIFO_RXTX,
+						    divider));
+
+		if (val) {
+			init_ir_raw_event(ev);
+			ev->code = pulse ? RC_IR_RAW_PULSE : RC_IR_RAW_SPACE;
+			ev->val = val;
+			events++;
+			ev++;
+			v4l2_dbg(2, ir_888_debug, sd, "rx read: %10llu ns %s\n",
+				 (long long unsigned)val, pulse ? "pulse" : "space");
+		}
 
-		v4l2_dbg(2, ir_888_debug, sd, "rx read: %10u ns  %s  %s\n",
-			 v, u ? "mark" : "space", w ? "(timed out)" : "");
-		if (w)
+		if (timeout) {
+			init_ir_raw_event(ev);
+			ev->code = RC_IR_RAW_STOP;
+			ev->val = 1;
+			events++;
+			ev++;
 			v4l2_dbg(2, ir_888_debug, sd, "rx read: end of rx\n");
+		}
 	}
+
+	*bytes_read = events * sizeof(union cx23888_ir_fifo_rec);
 	return 0;
 }
 
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index cd3aca7..101d150 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -98,12 +98,12 @@ MODULE_PARM_DESC(ir_debug, "enable integrated IR debug messages");
 
 /*
  * We use this union internally for convenience, but callers to tx_write
- * and rx_read will be expecting records of type struct ir_raw_event.
- * Always ensure the size of this union is dictated by struct ir_raw_event.
+ * and rx_read will be expecting records of type struct rc_event.
+ * Always ensure the size of this union is dictated by struct rc_event.
  */
 union cx25840_ir_fifo_rec {
 	u32 hw_fifo_data;
-	struct ir_raw_event ir_core_data;
+	struct rc_event ir_core_data;
 };
 
 #define CX25840_IR_RX_KFIFO_SIZE    (256 * sizeof(union cx25840_ir_fifo_rec))
@@ -659,63 +659,67 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
 }
 
 /* Receiver */
-static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
-			      ssize_t *num)
+static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t bufsize,
+			      ssize_t *bytes_read)
 {
-	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct cx25840_ir_state *state = to_ir_state(sd);
 	bool invert;
 	u16 divider;
-	unsigned int i, n;
-	union cx25840_ir_fifo_rec *p;
-	unsigned u, v, w;
-
-	if (ir_state == NULL)
+	struct rc_event *ev = (struct rc_event *)buf;
+	union cx25840_ir_fifo_rec rec;
+	unsigned max_events;
+	unsigned events = 0;
+	bool pulse, timeout;
+	u64 val;
+
+	if (!state)
 		return -ENODEV;
 
-	invert = (bool) atomic_read(&ir_state->rx_invert);
-	divider = (u16) atomic_read(&ir_state->rxclk_divider);
-
-	n = count / sizeof(union cx25840_ir_fifo_rec)
-		* sizeof(union cx25840_ir_fifo_rec);
-	if (n == 0) {
-		*num = 0;
-		return 0;
-	}
-
-	n = kfifo_out_locked(&ir_state->rx_kfifo, buf, n,
-			     &ir_state->rx_kfifo_lock);
+	invert = (bool)atomic_read(&state->rx_invert);
+	divider = (u16)atomic_read(&state->rxclk_divider);
+	max_events = bufsize / sizeof(union cx25840_ir_fifo_rec);
 
-	n /= sizeof(union cx25840_ir_fifo_rec);
-	*num = n * sizeof(union cx25840_ir_fifo_rec);
-
-	for (p = (union cx25840_ir_fifo_rec *) buf, i = 0; i < n; p++, i++) {
+	while (events + 2 <= max_events) {
+		if (kfifo_out_spinlocked(&state->rx_kfifo, &rec, sizeof(rec),
+					 &state->rx_kfifo_lock) != sizeof(rec))
+			break;
 
-		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
+		if (rec.hw_fifo_data & FIFO_RXTX_RTO) {
 			/* Assume RTO was because of no IR light input */
-			u = 0;
-			w = 1;
+			pulse = false;
+			timeout = true;
 		} else {
-			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
+			pulse = (rec.hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
 			if (invert)
-				u = u ? 0 : 1;
-			w = 0;
+				pulse = !pulse;
+			timeout = false;
 		}
 
-		v = (unsigned) pulse_width_count_to_ns(
-				  (u16) (p->hw_fifo_data & FIFO_RXTX), divider);
-		if (v > IR_MAX_DURATION)
-			v = IR_MAX_DURATION;
-
-		init_ir_raw_event(&p->ir_core_data);
-		p->ir_core_data.pulse = u;
-		p->ir_core_data.duration = v;
-		p->ir_core_data.timeout = w;
+		val = min_t(u64, IR_MAX_DURATION,
+			    pulse_width_count_to_ns(rec.hw_fifo_data & FIFO_RXTX,
+						    divider));
+
+		if (val) {
+			init_ir_raw_event(ev);
+			ev->code = pulse ? RC_IR_RAW_PULSE : RC_IR_RAW_SPACE;
+			ev->val = val;
+			events++;
+			ev++;
+			v4l2_dbg(2, ir_debug, sd, "rx read: %10llu ns %s\n",
+				 (long long unsigned)val, pulse ? "pulse" : "space");
+		}
 
-		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s  %s\n",
-			 v, u ? "mark" : "space", w ? "(timed out)" : "");
-		if (w)
+		if (timeout) {
+			init_ir_raw_event(ev);
+			ev->code = RC_IR_RAW_STOP;
+			ev->val = 1;
+			events++;
+			ev++;
 			v4l2_dbg(2, ir_debug, sd, "rx read: end of rx\n");
+		}
 	}
+
+	*bytes_read = events * sizeof(union cx25840_ir_fifo_rec);
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 158c1b6..befc2e1 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -510,7 +510,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	struct cx88_IR *ir = core->ir;
 	u32 samples;
 	unsigned todo, bits;
-	struct ir_raw_event ev;
+	DEFINE_IR_RAW_EVENT(ev);
 
 	if (!ir || !ir->sampling)
 		return;
@@ -527,9 +527,14 @@ void cx88_ir_irq(struct cx88_core *core)
 
 	init_ir_raw_event(&ev);
 	for (todo = 32; todo > 0; todo -= bits) {
-		ev.pulse = samples & 0x80000000 ? false : true;
-		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
-		ev.duration = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
+		if (samples & 0x80000000) {
+			ev.code = RC_IR_RAW_PULSE;
+			bits = min(todo, 32U - fls(samples));
+		} else {
+			ev.code = RC_IR_RAW_SPACE;
+			bits = min(todo, 32U - fls(~samples));
+		}
+		ev.val = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
 		ir_raw_event_store_with_filter(ir->dev, &ev);
 		samples <<= bits;
 	}
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index d8cad87..ea3dcf4 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -199,22 +199,6 @@ struct rc_keymap_entry {
 	};
 };
 
-struct ir_raw_event {
-	union {
-		u32             duration;
-
-		struct {
-			u32     carrier;
-			u8      duty_cycle;
-		};
-	};
-
-	unsigned                pulse:1;
-	unsigned                reset:1;
-	unsigned                timeout:1;
-	unsigned                carrier_report:1;
-};
-
 /**
  * struct rc_event - used to communicate rc events to userspace
  * @type:	the event type
diff --git a/include/media/rc-ir-raw.h b/include/media/rc-ir-raw.h
index 7fd0693..4521d95 100644
--- a/include/media/rc-ir-raw.h
+++ b/include/media/rc-ir-raw.h
@@ -29,17 +29,19 @@ enum raw_event_type {
 	IR_STOP_EVENT   = (1 << 3),
 };
 
-#define DEFINE_IR_RAW_EVENT(event) \
-	struct ir_raw_event event = { \
-		{ .duration = 0 } , \
-		.pulse = 0, \
-		.reset = 0, \
-		.timeout = 0, \
-		.carrier_report = 0 }
+#define DEFINE_IR_RAW_EVENT(ev)			\
+	struct rc_event ev = {			\
+		.type = RC_IR_RAW,		\
+		.code = RC_IR_RAW_PULSE,	\
+		.reserved = 0,			\
+		.val = 0 }
 
-static inline void init_ir_raw_event(struct ir_raw_event *ev)
+static inline void init_ir_raw_event(struct rc_event *ev)
 {
-	memset(ev, 0, sizeof(*ev));
+	ev->type = RC_IR_RAW;
+	ev->code = RC_IR_RAW_PULSE;
+	ev->reserved = 0;
+	ev->val = 0;
 }
 
 #define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
@@ -48,19 +50,21 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
 
 void ir_raw_event_handle(struct rc_dev *dev);
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
+int ir_raw_event_store(struct rc_dev *dev, struct rc_event *ev);
 int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
-int ir_raw_event_store_with_filter(struct rc_dev *dev,
-				struct ir_raw_event *ev);
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct rc_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 int rc_register_ir_raw_device(struct rc_dev *dev);
 void rc_unregister_ir_raw_device(struct rc_dev *dev);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.reset = true;
-
+	struct rc_event ev = {
+		.type = RC_IR_RAW,
+		.code = RC_IR_RAW_RESET,
+		.reserved = 0,
+		.val = 1
+	};
 	ir_raw_event_store(dev, &ev);
 	ir_raw_event_handle(dev);
 }

