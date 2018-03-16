Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:54896 "EHLO
        resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751578AbeCPT5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 15:57:05 -0400
From: A Sun <as1033x@comcast.net>
Subject: [PATCH v3 1/1] media: mceusb: add IR learning support features (IR
 carrier frequency measurement and wide-band/short-range receiver)
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20f4d234-c62f-12ab-5e15-639f7d981f56@comcast.net>
 <20180313103816.7oyjr7imb4hk7q65@gofer.mess.org>
 <aa4be7ab-b643-9dc9-6a06-7981d314583e@comcast.net>
 <20180315124606.yvugyfb4cn2f6byz@gofer.mess.org>
Message-ID: <d420c9be-2577-fc62-b06b-616290d19804@comcast.net>
Date: Fri, 16 Mar 2018 15:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20180315124606.yvugyfb4cn2f6byz@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

patch v3 revisions:
 . Add rx2 parameter to mceusb_model. Enables device specific
   adjustments for carrier cycle counting during IR carrier frequency
   measurement.
 . When disabling RX carrier report, revert device to normal
   non-learning mode IR receiver if learning mode (wide-band receiver)
   was not explicitly enabled.

patch v2 revisions:
 . Carrier frequency measurement results were consistently low in patch v1.
   Improve measurement accuracy by adjusting IR carrier cycle count
   assuming 1 missed count per IR "on" pulse.
   Adjustments may need to be hardware specific, so future refinements
   may be necessary.
 . Remove unneeded argument "enable" validation in
   mceusb_set_rx_wideband() and mceusb_set_rx_carrier_report().
 . In mceusb_set_rx_carrier_report(), when enabling RX carrier report feature,
   also implicitly enable RX wide-band (short-range) receiver.
   Maintains consistency with winbond-cir, redrat3, ene-cir, IR receivers.
 . Comment revisions and style corrections.
---

Windows Media Center IR transceivers include two IR receivers;
wide-band/short-range and narrow-band/long-range. The short-range
(5cm distance) receiver is for IR learning and has IR carrier
frequency measuring ability.

Add mceusb driver support to select the short range IR receiver
and enable pass through of its IR carrier frequency measurements.

RC and LIRC already support these mceusb driver additions.

Test platform:

Linux raspberrypi 4.9.59-v7+ #1047 SMP Sun Oct 29 12:19:23 GMT 2017 armv7l GNU/Linux
mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
mceusb 1-1.2:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x1 active)

Sony TV remote control

ir-ctl from v4l-utils

pi@raspberrypi:~ $ ir-ctl -V
IR raw version 1.12.3
pi@raspberrypi:~ $ ir-ctl -m -r
...
pulse 650
space 550
pulse 650
space 600
pulse 600
space 600
pulse 1200
space 600
pulse 650
space 550
pulse 650
space 600
pulse 600
space 600
pulse 550
carrier 40004
space 16777215
^C
pi@raspberrypi:~ $ exit

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 152 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 140 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a9187b0b4..f8c23d577 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -42,7 +42,7 @@
 #include <linux/pm_wakeup.h>
 #include <media/rc-core.h>
 
-#define DRIVER_VERSION	"1.93"
+#define DRIVER_VERSION	"1.94"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
 #define DRIVER_DESC	"Windows Media Center Ed. eHome Infrared Transceiver " \
 			"device driver"
@@ -198,6 +198,13 @@ struct mceusb_model {
 	u32 mce_gen3:1;
 	u32 tx_mask_normal:1;
 	u32 no_tx:1;
+	/*
+	 * 2nd IR receiver (short-range, wideband) for learning mode:
+	 *     0, absent 2nd receiver (rx2)
+	 *     1, rx2 present
+	 *     2, rx2 which under counts IR carrier cycles
+	 */
+	u32 rx2;
 
 	int ir_intfnum;
 
@@ -209,9 +216,11 @@ static const struct mceusb_model mceusb_model[] = {
 	[MCE_GEN1] = {
 		.mce_gen1 = 1,
 		.tx_mask_normal = 1,
+		.rx2 = 2,
 	},
 	[MCE_GEN2] = {
 		.mce_gen2 = 1,
+		.rx2 = 2,
 	},
 	[MCE_GEN2_NO_TX] = {
 		.mce_gen2 = 1,
@@ -220,10 +229,12 @@ static const struct mceusb_model mceusb_model[] = {
 	[MCE_GEN2_TX_INV] = {
 		.mce_gen2 = 1,
 		.tx_mask_normal = 1,
+		.rx2 = 1,
 	},
 	[MCE_GEN3] = {
 		.mce_gen3 = 1,
 		.tx_mask_normal = 1,
+		.rx2 = 2,
 	},
 	[POLARIS_EVK] = {
 		/*
@@ -232,6 +243,7 @@ static const struct mceusb_model mceusb_model[] = {
 		 * to allow testing it
 		 */
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
+		.rx2 = 2,
 	},
 	[CX_HYBRID_TV] = {
 		.no_tx = 1, /* tx isn't wired up at all */
@@ -244,10 +256,12 @@ static const struct mceusb_model mceusb_model[] = {
 	[MULTIFUNCTION] = {
 		.mce_gen2 = 1,
 		.ir_intfnum = 2,
+		.rx2 = 2,
 	},
 	[TIVO_KIT] = {
 		.mce_gen2 = 1,
 		.rc_map = RC_MAP_TIVO,
+		.rx2 = 2,
 	},
 	[EVROMEDIA_FULL_HYBRID_FULLHD] = {
 		.name = "Evromedia USB Full Hybrid Full HD",
@@ -427,7 +441,8 @@ struct mceusb_dev {
 	struct rc_dev *rc;
 
 	/* optional features we can enable */
-	bool learning_enabled;
+	bool carrier_report_enabled;
+	bool wideband_rx_enabled;	/* aka learning mode, short-range rx */
 
 	/* core device bits */
 	struct device *dev;
@@ -458,6 +473,7 @@ struct mceusb_dev {
 		u32 tx_mask_normal:1;
 		u32 microsoft_gen1:1;
 		u32 no_tx:1;
+		u32 rx2;
 	} flags;
 
 	/* transmit support */
@@ -474,6 +490,11 @@ struct mceusb_dev {
 	u8 num_rxports;		/* number of receive sensors */
 	u8 txports_cabled;	/* bitmask of transmitters with cable */
 	u8 rxports_active;	/* bitmask of active receive sensors */
+	bool learning_active;	/* wideband rx is active */
+
+	/* receiver carrier frequency detection support */
+	u32 pulse_tunit;	/* IR pulse "on" cumulative time units */
+	u32 pulse_count;	/* pulse "on" count in measurement interval */
 
 	/*
 	 * support for async error handler mceusb_deferred_kevent()
@@ -684,8 +705,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, u8 *buf, int buf_len,
 		/* aka MCE_RSP_EQIRRXCFCNT */
 			if (out)
 				dev_dbg(dev, "Get receive sensor");
-			else if (ir->learning_enabled)
-				dev_dbg(dev, "RX pulse count: %d",
+			else
+				dev_dbg(dev, "RX carrier cycle count: %d",
 					((data[0] << 8) | data[1]));
 			break;
 		case MCE_RSP_EQIRNUMPORTS:
@@ -956,14 +977,78 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 }
 
 /*
+ * Select or deselect the 2nd receiver port.
+ * Second receiver is learning mode, wide-band, short-range receiver.
+ * Only one receiver (long or short range) may be active at a time.
+ */
+static int mceusb_set_rx_wideband(struct rc_dev *dev, int enable)
+{
+	struct mceusb_dev *ir = dev->priv;
+	unsigned char cmdbuf[3] = { MCE_CMD_PORT_IR,
+				    MCE_CMD_SETIRRXPORTEN, 0x00 };
+
+	dev_dbg(ir->dev, "select %s-range receive sensor",
+		enable ? "short" : "long");
+	if (enable) {
+		ir->wideband_rx_enabled = true;
+		cmdbuf[2] = 2;	/* port 2 is short range receiver */
+	} else {
+		ir->wideband_rx_enabled = false;
+		cmdbuf[2] = 1;	/* port 1 is long range receiver */
+	}
+	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+	/* response from device sets ir->learning_active */
+
+	return 0;
+}
+
+/*
+ * Enable/disable receiver carrier frequency pass through reporting.
+ * Only the short-range receiver has carrier frequency measuring capability.
+ * Implicitly select this receiver when enabling carrier frequency reporting.
+ */
+static int mceusb_set_rx_carrier_report(struct rc_dev *dev, int enable)
+{
+	struct mceusb_dev *ir = dev->priv;
+	unsigned char cmdbuf[3] = { MCE_CMD_PORT_IR,
+				    MCE_CMD_SETIRRXPORTEN, 0x00 };
+
+	dev_dbg(ir->dev, "%s short-range receiver carrier reporting",
+		enable ? "enable" : "disable");
+	if (enable) {
+		ir->carrier_report_enabled = true;
+		if (!ir->learning_active) {
+			cmdbuf[2] = 2;	/* port 2 is short range receiver */
+			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+		}
+	} else {
+		ir->carrier_report_enabled = false;
+		/*
+		 * Revert to normal (long-range) receiver only if the
+		 * wideband (short-range) receiver wasn't explicitly
+		 * enabled.
+		 */
+		if (ir->learning_active && !ir->wideband_rx_enabled) {
+			cmdbuf[2] = 1;	/* port 1 is long range receiver */
+			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+		}
+	}
+
+	return 0;
+}
+
+/*
  * We don't do anything but print debug spew for many of the command bits
  * we receive from the hardware, but some of them are useful information
  * we want to store so that we can use them.
  */
 static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 {
+	DEFINE_IR_RAW_EVENT(rawir);
 	u8 hi = ir->buf_in[index + 1] & 0xff;
 	u8 lo = ir->buf_in[index + 2] & 0xff;
+	u32 carrier_cycles;
+	u32 cycles_fix;
 
 	switch (ir->buf_in[index]) {
 	/* the one and only 5-byte return value command */
@@ -980,6 +1065,33 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		ir->num_txports = hi;
 		ir->num_rxports = lo;
 		break;
+	case MCE_RSP_EQIRRXCFCNT:
+		/*
+		 * The carrier cycle counter can overflow and wrap around
+		 * without notice from the device. So frequency measurement
+		 * will be inaccurate with long duration IR.
+		 *
+		 * The long-range (non learning) receiver always reports
+		 * zero count so we always ignore its report.
+		 */
+		if (ir->carrier_report_enabled && ir->learning_active &&
+		    ir->pulse_tunit > 0) {
+			carrier_cycles = (hi << 8 | lo);
+			/*
+			 * Adjust carrier cycle count by adding
+			 * 1 missed count per pulse "on"
+			 */
+			cycles_fix = ir->flags.rx2 == 2 ? ir->pulse_count : 0;
+			rawir.carrier_report = 1;
+			rawir.carrier = (1000000u / MCE_TIME_UNIT) *
+					(carrier_cycles + cycles_fix) /
+					ir->pulse_tunit;
+			dev_dbg(ir->dev, "RX carrier frequency %u Hz (pulse count = %u, cycles = %u, duration = %u, rx2 = %u)",
+				rawir.carrier, ir->pulse_count, carrier_cycles,
+				ir->pulse_tunit, ir->flags.rx2);
+			ir_raw_event_store(ir->rc, &rawir);
+		}
+		break;
 
 	/* 1-byte return value commands */
 	case MCE_RSP_EQEMVER:
@@ -989,8 +1101,12 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		ir->tx_mask = hi;
 		break;
 	case MCE_RSP_EQIRRXPORTEN:
-		ir->learning_enabled = ((hi & 0x02) == 0x02);
-		ir->rxports_active = hi;
+		ir->learning_active = ((hi & 0x02) == 0x02);
+		if (ir->rxports_active != hi) {
+			dev_info(ir->dev, "%s-range (0x%x) receiver active",
+				 ir->learning_active ? "short" : "long", hi);
+			ir->rxports_active = hi;
+		}
 		break;
 	case MCE_RSP_CMD_ILLEGAL:
 		ir->need_reset = true;
@@ -1027,12 +1143,16 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->rem--;
 			init_ir_raw_event(&rawir);
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
-			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
-					 * US_TO_NS(MCE_TIME_UNIT);
+			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK);
+			if (rawir.pulse) {
+				ir->pulse_tunit += rawir.duration;
+				ir->pulse_count++;
+			}
+			rawir.duration *= US_TO_NS(MCE_TIME_UNIT);
 
-			dev_dbg(ir->dev, "Storing %s with duration %u",
+			dev_dbg(ir->dev, "Storing %s %u ns (%02x)",
 				rawir.pulse ? "pulse" : "space",
-				rawir.duration);
+				rawir.duration,	ir->buf_in[i]);
 
 			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
 				event = true;
@@ -1053,10 +1173,13 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
 			mceusb_dev_printdata(ir, ir->buf_in, buf_len,
 					     i, ir->rem + 1, false);
-			if (ir->rem)
+			if (ir->rem) {
 				ir->parser_state = PARSE_IRDATA;
-			else
+			} else {
 				ir_raw_event_reset(ir->rc);
+				ir->pulse_tunit = 0;
+				ir->pulse_count = 0;
+			}
 			break;
 		}
 
@@ -1292,6 +1415,10 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
 		rc->tx_ir = mceusb_tx_ir;
 	}
+	if (ir->flags.rx2 > 0) {
+		rc->s_learning_mode = mceusb_set_rx_wideband;
+		rc->s_carrier_report = mceusb_set_rx_carrier_report;
+	}
 	rc->driver_name = DRIVER_NAME;
 
 	switch (le16_to_cpu(udev->descriptor.idVendor)) {
@@ -1406,6 +1533,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_normal = tx_mask_normal;
 	ir->flags.no_tx = mceusb_model[model].no_tx;
+	ir->flags.rx2 = mceusb_model[model].rx2;
 	ir->model = model;
 
 	/* Saving usb interface data for use by the transmitter routine */
-- 
2.11.0
