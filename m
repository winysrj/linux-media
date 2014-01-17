Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48368 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaAQOAG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:06 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 03/15] media: rc: add raw decoder for Sharp protocol
Date: Fri, 17 Jan 2014 13:58:48 +0000
Message-ID: <1389967140-20704-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a raw decoder for the Sharp protocol. It uses a pulse distance
modulation with a pulse of 320us and a bit period of 2ms for a logical 1
and 1ms for a logical 0. The first part of the message consists of a
5-bit address, an 8-bit command, and two other bits, followed by a 40ms
gap before the echo message which is an inverted version of the main
message except for the address bits.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- new patch (suggested by Mauro).
---
 drivers/media/rc/Kconfig            |   9 ++
 drivers/media/rc/Makefile           |   1 +
 drivers/media/rc/ir-sharp-decoder.c | 200 ++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h     |   6 ++
 4 files changed, 216 insertions(+)
 create mode 100644 drivers/media/rc/ir-sharp-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 904f113..3b25887 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -106,6 +106,15 @@ config IR_SANYO_DECODER
 	   uses the Sanyo protocol (Sanyo, Aiwa, Chinon remotes),
 	   and you need software decoding support.
 
+config IR_SHARP_DECODER
+	tristate "Enable IR raw decoder for the Sharp protocol"
+	depends on RC_CORE
+	default y
+
+	---help---
+	   Enable this option if you have an infrared remote control which
+	   uses the Sharp protocol, and you need software decoding support.
+
 config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index f4eb32c..36dafed 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 obj-$(CONFIG_IR_RC5_SZ_DECODER) += ir-rc5-sz-decoder.o
 obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
+obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
new file mode 100644
index 0000000..4c17be5
--- /dev/null
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -0,0 +1,200 @@
+/* ir-sharp-decoder.c - handle Sharp IR Pulse/Space protocol
+ *
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * Based on NEC decoder:
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/bitrev.h>
+#include <linux/module.h>
+#include "rc-core-priv.h"
+
+#define SHARP_NBITS		15
+#define SHARP_UNIT		40000  /* ns */
+#define SHARP_BIT_PULSE		(8    * SHARP_UNIT) /* 320us */
+#define SHARP_BIT_0_PERIOD	(25   * SHARP_UNIT) /* 1ms (680us space) */
+#define SHARP_BIT_1_PERIOD	(50   * SHARP_UNIT) /* 2ms (1680ms space) */
+#define SHARP_ECHO_SPACE	(1000 * SHARP_UNIT) /* 40 ms */
+#define SHARP_TRAILER_SPACE	(125  * SHARP_UNIT) /* 5 ms (even longer) */
+
+enum sharp_state {
+	STATE_INACTIVE,
+	STATE_BIT_PULSE,
+	STATE_BIT_SPACE,
+	STATE_TRAILER_PULSE,
+	STATE_ECHO_SPACE,
+	STATE_TRAILER_SPACE,
+};
+
+/**
+ * ir_sharp_decode() - Decode one Sharp pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct sharp_dec *data = &dev->raw->sharp;
+	u32 msg, echo, address, command, scancode;
+
+	if (!(dev->enabled_protocols & RC_BIT_SHARP))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	IR_dprintk(2, "Sharp decode started at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
+			       SHARP_BIT_PULSE / 2))
+			break;
+
+		data->count = 0;
+		data->pulse_len = ev.duration;
+		data->state = STATE_BIT_SPACE;
+		return 0;
+
+	case STATE_BIT_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
+			       SHARP_BIT_PULSE / 2))
+			break;
+
+		data->pulse_len = ev.duration;
+		data->state = STATE_BIT_SPACE;
+		return 0;
+
+	case STATE_BIT_SPACE:
+		if (ev.pulse)
+			break;
+
+		data->bits <<= 1;
+		if (eq_margin(data->pulse_len + ev.duration, SHARP_BIT_1_PERIOD,
+			      SHARP_BIT_PULSE * 2))
+			data->bits |= 1;
+		else if (!eq_margin(data->pulse_len + ev.duration,
+				    SHARP_BIT_0_PERIOD, SHARP_BIT_PULSE * 2))
+			break;
+		data->count++;
+
+		if (data->count == SHARP_NBITS ||
+		    data->count == SHARP_NBITS * 2)
+			data->state = STATE_TRAILER_PULSE;
+		else
+			data->state = STATE_BIT_PULSE;
+
+		return 0;
+
+	case STATE_TRAILER_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
+			       SHARP_BIT_PULSE / 2))
+			break;
+
+		if (data->count == SHARP_NBITS) {
+			/* exp,chk bits should be 1,0 */
+			if ((data->bits & 0x3) != 0x2)
+				break;
+			data->state = STATE_ECHO_SPACE;
+		} else {
+			data->state = STATE_TRAILER_SPACE;
+		}
+		return 0;
+
+	case STATE_ECHO_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SHARP_ECHO_SPACE,
+			       SHARP_ECHO_SPACE / 4))
+			break;
+
+		data->state = STATE_BIT_PULSE;
+
+		return 0;
+
+	case STATE_TRAILER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, SHARP_TRAILER_SPACE,
+				SHARP_BIT_PULSE / 2))
+			break;
+
+		/* Validate - command, ext, chk should be inverted in 2nd */
+		msg = (data->bits >> 15) & 0x7fff;
+		echo = data->bits & 0x7fff;
+		if ((msg ^ echo) != 0x3ff) {
+			IR_dprintk(1,
+				   "Sharp checksum error: received 0x%04x, 0x%04x\n",
+				   msg, echo);
+			break;
+		}
+
+		address = bitrev8((msg >> 7) & 0xf8);
+		command = bitrev8((msg >> 2) & 0xff);
+
+		scancode = address << 8 | command;
+		IR_dprintk(1, "Sharp scancode 0x%04x\n", scancode);
+
+		rc_keydown(dev, scancode, 0);
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	IR_dprintk(1, "Sharp decode failed at count %d state %d (%uus %s)\n",
+		   data->count, data->state, TO_US(ev.duration),
+		   TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static struct ir_raw_handler sharp_handler = {
+	.protocols	= RC_BIT_SHARP,
+	.decode		= ir_sharp_decode,
+};
+
+static int __init ir_sharp_decode_init(void)
+{
+	ir_raw_handler_register(&sharp_handler);
+
+	pr_info("IR Sharp protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_sharp_decode_exit(void)
+{
+	ir_raw_handler_unregister(&sharp_handler);
+}
+
+module_init(ir_sharp_decode_init);
+module_exit(ir_sharp_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Hogan <james.hogan@imgtec.com>");
+MODULE_DESCRIPTION("Sharp IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 70a180b..c40d666 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -88,6 +88,12 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		u64 bits;
 	} sanyo;
+	struct sharp_dec {
+		int state;
+		unsigned count;
+		u32 bits;
+		unsigned int pulse_len;
+	} sharp;
 	struct mce_kbd_dec {
 		struct input_dev *idev;
 		struct timer_list rx_timeout;
-- 
1.8.3.2


