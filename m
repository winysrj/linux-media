Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:53692 "EHLO
        resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932110AbeCKJsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 05:48:39 -0400
From: A Sun <as1033x@comcast.net>
Subject: [PATCH] [media] mceusb: add IR learning support features (IR carrier
 frequency measurement and wide-band/short range receiver)
To: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <20f4d234-c62f-12ab-5e15-639f7d981f56@comcast.net>
Date: Sun, 11 Mar 2018 05:40:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


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
pi@raspberrypi:~ $ ir-ctl -w -m -d /dev/lirc0 -r
...
pulse 600
space 600
pulse 1250
space 550
pulse 650
space 600
pulse 550
space 600
pulse 600
space 600
pulse 650
carrier 38803
space 16777215
^C
pi@raspberrypi:~ $ exit

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 90 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a9187b0b4..8bbb0f2da 100644
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
@@ -427,6 +427,7 @@ struct mceusb_dev {
 	struct rc_dev *rc;
 
 	/* optional features we can enable */
+	bool carrier_report_enabled;
 	bool learning_enabled;
 
 	/* core device bits */
@@ -475,6 +476,9 @@ struct mceusb_dev {
 	u8 txports_cabled;	/* bitmask of transmitters with cable */
 	u8 rxports_active;	/* bitmask of active receive sensors */
 
+	/* receiver carrier frequency detection support */
+	u32 pulse_tunit;	/* IR pulse "on" cumulative time units */
+
 	/*
 	 * support for async error handler mceusb_deferred_kevent()
 	 * where usb_clear_halt(), usb_reset_configuration(),
@@ -956,12 +960,60 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
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
+	if (enable != 0 && enable != 1)
+		return -EINVAL;
+
+	/*
+	 * cmdbuf[2] is receiver port number
+	 * port 1 is long range receiver
+	 * port 2 is short range receiver
+	 */
+	cmdbuf[2] = enable + 1;
+	dev_dbg(ir->dev, "select %s-range receive sensor",
+		enable ? "short" : "long");
+	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+
+	return 0;
+}
+
+/*
+ * Enable/disable receiver carrier frequency pass through reporting.
+ * Frequency measurement only works with the short-range receiver.
+ * The long-range receiver always reports no carrier frequency
+ * (MCE_RSP_EQIRRXCFCNT, 0, 0) so we always ignore its report.
+ */
+static int mceusb_set_rx_carrier_report(struct rc_dev *dev, int enable)
+{
+	struct mceusb_dev *ir = dev->priv;
+
+	if (enable != 0 && enable != 1)
+		return -EINVAL;
+
+	dev_dbg(ir->dev, "%s short-range receiver carrier reporting",
+		enable ? "enable" : "disable");
+	ir->carrier_report_enabled = (enable == 1);
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
 
@@ -980,6 +1032,18 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		ir->num_txports = hi;
 		ir->num_rxports = lo;
 		break;
+	case MCE_RSP_EQIRRXCFCNT:
+		if (ir->carrier_report_enabled && ir->learning_enabled
+		    && ir->pulse_tunit > 0) {
+			init_ir_raw_event(&rawir);
+			rawir.carrier_report = 1;
+			rawir.carrier = (1000000u / MCE_TIME_UNIT) *
+					(hi << 8 | lo) / ir->pulse_tunit;
+			dev_dbg(ir->dev, "RX carrier frequency %u Hz (pulse %u time units)",
+				rawir.carrier, ir->pulse_tunit);
+			ir_raw_event_store(ir->rc, &rawir);
+		}
+		break;
 
 	/* 1-byte return value commands */
 	case MCE_RSP_EQEMVER:
@@ -990,7 +1054,11 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		break;
 	case MCE_RSP_EQIRRXPORTEN:
 		ir->learning_enabled = ((hi & 0x02) == 0x02);
-		ir->rxports_active = hi;
+		if (ir->rxports_active != hi) {
+			dev_info(ir->dev, "%s-range (0x%x) receiver active",
+				 ir->learning_enabled ? "short" : "long", hi);
+			ir->rxports_active = hi;
+		}
 		break;
 	case MCE_RSP_CMD_ILLEGAL:
 		ir->need_reset = true;
@@ -1027,12 +1095,14 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->rem--;
 			init_ir_raw_event(&rawir);
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
-			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
-					 * US_TO_NS(MCE_TIME_UNIT);
+			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK);
+			if (rawir.pulse)
+				ir->pulse_tunit += rawir.duration;
+			rawir.duration *= US_TO_NS(MCE_TIME_UNIT);
 
-			dev_dbg(ir->dev, "Storing %s with duration %u",
+			dev_dbg(ir->dev, "Storing %s %u ns (%02x)",
 				rawir.pulse ? "pulse" : "space",
-				rawir.duration);
+				rawir.duration,	ir->buf_in[i]);
 
 			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
 				event = true;
@@ -1053,10 +1123,12 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
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
+			}
 			break;
 		}
 
@@ -1287,6 +1359,8 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->priv = ir;
 	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	rc->timeout = MS_TO_NS(100);
+	rc->s_learning_mode = mceusb_set_rx_wideband;
+	rc->s_carrier_report = mceusb_set_rx_carrier_report;
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
-- 
2.11.0
