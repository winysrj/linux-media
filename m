Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53342 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751778AbeBZI5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 03:57:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, dri-devel@lists.freedesktop.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] cec-pin-error-inj: parse/show error injection
Date: Mon, 26 Feb 2018 09:57:04 +0100
Message-Id: <20180226085706.41526-5-hverkuil@xs4all.nl>
In-Reply-To: <20180226085706.41526-1-hverkuil@xs4all.nl>
References: <20180226085706.41526-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support to the CEC Pin framework to parse error injection commands
and to show them.

The next patch will do the actual implementation of this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/Kconfig             |   6 +
 drivers/media/cec/Makefile            |   4 +
 drivers/media/cec/cec-pin-error-inj.c | 372 ++++++++++++++++++++++++++++++++++
 drivers/media/cec/cec-pin-priv.h      |  96 +++++++++
 drivers/media/cec/cec-pin.c           |   6 +
 5 files changed, 484 insertions(+)
 create mode 100644 drivers/media/cec/cec-pin-error-inj.c

diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index 43428cec3a01..9c2b108c613a 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -4,3 +4,9 @@ config MEDIA_CEC_RC
 	depends on CEC_CORE=m || RC_CORE=y
 	---help---
 	  Pass on CEC remote control messages to the RC framework.
+
+config CEC_PIN_ERROR_INJ
+	bool "Enable CEC error injection support"
+	depends on CEC_PIN && DEBUG_FS
+	---help---
+	  This option enables CEC error injection using debugfs.
diff --git a/drivers/media/cec/Makefile b/drivers/media/cec/Makefile
index 41ee3325e1ea..29a2ab9e77c5 100644
--- a/drivers/media/cec/Makefile
+++ b/drivers/media/cec/Makefile
@@ -9,4 +9,8 @@ ifeq ($(CONFIG_CEC_PIN),y)
   cec-objs += cec-pin.o
 endif
 
+ifeq ($(CONFIG_CEC_PIN_ERROR_INJ),y)
+  cec-objs += cec-pin-error-inj.o
+endif
+
 obj-$(CONFIG_CEC_CORE) += cec.o
diff --git a/drivers/media/cec/cec-pin-error-inj.c b/drivers/media/cec/cec-pin-error-inj.c
new file mode 100644
index 000000000000..d03d7f0c2652
--- /dev/null
+++ b/drivers/media/cec/cec-pin-error-inj.c
@@ -0,0 +1,372 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ */
+
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/sched/types.h>
+
+#include <media/cec-pin.h>
+#include "cec-pin-priv.h"
+
+u32 cec_pin_rx_error_inj(struct cec_pin *pin)
+{
+	u16 cmd = CEC_ERROR_INJ_OP_NEXT;
+
+	/* Only when 18 bits have been received do we have a valid cmd */
+	if (!pin->rx_error_inj[cmd] && pin->rx_bit >= 18)
+		cmd = pin->rx_msg.msg[1];
+	return pin->rx_error_inj[cmd] ? :
+		(pin->rx_error_inj[CEC_ERROR_INJ_OP_NEXT] ? :
+		 pin->rx_error_inj[CEC_ERROR_INJ_OP_ALL]);
+}
+
+u64 cec_pin_tx_error_inj(struct cec_pin *pin)
+{
+	u16 cmd = CEC_ERROR_INJ_OP_NEXT;
+
+	if (!pin->tx_error_inj[cmd] && pin->tx_msg.len > 1)
+		cmd = pin->tx_msg.msg[1];
+	return pin->tx_error_inj[cmd] ? :
+		(pin->tx_error_inj[CEC_ERROR_INJ_OP_NEXT] ? :
+		 pin->tx_error_inj[CEC_ERROR_INJ_OP_ALL]);
+}
+
+bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
+{
+	static const char *delims = " \t\r";
+	struct cec_pin *pin = adap->pin;
+	bool has_pos = false;
+	char *p = line;
+	char *token;
+	u32 *rx_error;
+	u64 *tx_error;
+	bool need_op;
+	u32 op;
+	u8 pos;
+	u8 v;
+
+	p = skip_spaces(p);
+	token = strsep(&p, delims);
+	if (!strcmp(token, "clear")) {
+		memset(pin->tx_error_inj, 0, sizeof(pin->tx_error_inj));
+		memset(pin->rx_error_inj, 0, sizeof(pin->rx_error_inj));
+		pin->tx_ignore_nack_until_eom = false;
+		pin->tx_custom_pulse = false;
+		pin->tx_custom_low_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		pin->tx_custom_high_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		return true;
+	}
+	if (!strcmp(token, "rx-clear")) {
+		memset(pin->rx_error_inj, 0, sizeof(pin->rx_error_inj));
+		return true;
+	}
+	if (!strcmp(token, "tx-clear")) {
+		memset(pin->tx_error_inj, 0, sizeof(pin->tx_error_inj));
+		pin->tx_ignore_nack_until_eom = false;
+		pin->tx_custom_pulse = false;
+		pin->tx_custom_low_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		pin->tx_custom_high_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		return true;
+	}
+	if (!strcmp(token, "tx-ignore-nack-until-eom")) {
+		pin->tx_ignore_nack_until_eom = true;
+		return true;
+	}
+	if (!strcmp(token, "tx-custom-pulse")) {
+		pin->tx_custom_pulse = true;
+		cec_pin_start_timer(pin);
+		return true;
+	}
+	if (!p)
+		return false;
+
+	p = skip_spaces(p);
+	if (!strcmp(token, "tx-custom-low-usecs")) {
+		u32 usecs;
+
+		if (kstrtou32(p, 0, &usecs) || usecs > 10000000)
+			return false;
+		pin->tx_custom_low_usecs = usecs;
+		return true;
+	}
+	if (!strcmp(token, "tx-custom-high-usecs")) {
+		u32 usecs;
+
+		if (kstrtou32(p, 0, &usecs) || usecs > 10000000)
+			return false;
+		pin->tx_custom_high_usecs = usecs;
+		return true;
+	}
+
+	if (!strcmp(token, "all"))
+		op = CEC_ERROR_INJ_OP_ALL;
+	else if (!strcmp(token, "next"))
+		op = CEC_ERROR_INJ_OP_NEXT;
+	else if (!kstrtou8(token, 0, &v))
+		op = v;
+	else
+		return false;
+
+	rx_error = pin->rx_error_inj + op;
+	tx_error = pin->tx_error_inj + op;
+	need_op = op <= 0xff;
+
+	token = strsep(&p, delims);
+	if (p) {
+		p = skip_spaces(p);
+		has_pos = !kstrtou8(p, 0, &pos);
+	}
+
+	if (!strcmp(token, "clear")) {
+		*rx_error = 0;
+		*tx_error = 0;
+	} else if (!strcmp(token, "rx-clear")) {
+		*rx_error = 0;
+	} else if (!strcmp(token, "rx-nack")) {
+		*rx_error |= CEC_ERROR_INJ_RX_NACK;
+	} else if (has_pos && pos < 160 && !strcmp(token, "rx-low-drive")) {
+		if (need_op && pos < 10 + 8)
+			return false;
+		*rx_error &= ~CEC_ERROR_INJ_RX_LOW_DRIVE_POS(0xff);
+		*rx_error |= CEC_ERROR_INJ_RX_LOW_DRIVE |
+			     CEC_ERROR_INJ_RX_LOW_DRIVE_POS(pos);
+	} else if (!strcmp(token, "rx-add-byte")) {
+		*rx_error |= CEC_ERROR_INJ_RX_ADD_BYTE;
+	} else if (!strcmp(token, "rx-remove-byte")) {
+		*rx_error |= CEC_ERROR_INJ_RX_REMOVE_BYTE;
+	} else if (!strcmp(token, "rx-arb-lost")) {
+		if (need_op)
+			return false;
+		if (!has_pos)
+			pos = 0x0f;
+		*rx_error &= ~CEC_ERROR_INJ_RX_ARB_LOST_POLL(0xff);
+		*rx_error |= CEC_ERROR_INJ_RX_ARB_LOST |
+			     CEC_ERROR_INJ_RX_ARB_LOST_POLL(pos);
+	} else if (!strcmp(token, "tx-clear")) {
+		*tx_error = 0;
+	} else if (!strcmp(token, "tx-no-eom")) {
+		*tx_error |= CEC_ERROR_INJ_TX_NO_EOM;
+	} else if (!strcmp(token, "tx-early-eom")) {
+		*tx_error |= CEC_ERROR_INJ_TX_EARLY_EOM;
+	} else if (has_pos && pos < 160 &&
+		   (!strcmp(token, "tx-short-bit") ||
+		    !strcmp(token, "tx-long-bit") ||
+		    !strcmp(token, "tx-custom-bit"))) {
+		if (need_op && pos < 10 + 8)
+			return false;
+		/* Invalid bit position may not be the Ack bit */
+		if ((pos % 10) == 9)
+			return false;
+		*tx_error &= ~(CEC_ERROR_INJ_TX_SHORT_BIT |
+			       CEC_ERROR_INJ_TX_LONG_BIT |
+			       CEC_ERROR_INJ_TX_CUSTOM_BIT |
+			       CEC_ERROR_INJ_TX_INVALID_BIT_POS(0xff));
+		*tx_error |= CEC_ERROR_INJ_TX_INVALID_BIT_POS(pos);
+		if (!strcmp(token, "tx-short-bit"))
+			*tx_error |= CEC_ERROR_INJ_TX_SHORT_BIT;
+		else if (!strcmp(token, "tx-long-bit"))
+			*tx_error |= CEC_ERROR_INJ_TX_LONG_BIT;
+		else
+			*tx_error |= CEC_ERROR_INJ_TX_CUSTOM_BIT;
+
+	} else if (!strcmp(token, "tx-short-start")) {
+		*tx_error |= CEC_ERROR_INJ_TX_SHORT_START;
+		*tx_error &= ~(CEC_ERROR_INJ_TX_LONG_START |
+			       CEC_ERROR_INJ_TX_CUSTOM_START);
+	} else if (!strcmp(token, "tx-long-start")) {
+		*tx_error |= CEC_ERROR_INJ_TX_LONG_START;
+		*tx_error &= ~(CEC_ERROR_INJ_TX_SHORT_START |
+			       CEC_ERROR_INJ_TX_CUSTOM_START);
+	} else if (!strcmp(token, "tx-custom-start")) {
+		*tx_error |= CEC_ERROR_INJ_TX_CUSTOM_START;
+		*tx_error &= ~(CEC_ERROR_INJ_TX_SHORT_START |
+			       CEC_ERROR_INJ_TX_LONG_START);
+	} else if (has_pos && pos < 160 && !strcmp(token, "tx-last-bit")) {
+		if (need_op && pos < 10 + 8)
+			return false;
+		*tx_error &= ~CEC_ERROR_INJ_TX_LAST_BIT_POS(0xff);
+		*tx_error |= CEC_ERROR_INJ_TX_LAST_BIT |
+			     CEC_ERROR_INJ_TX_LAST_BIT_POS(pos);
+	} else if (!strcmp(token, "tx-add-bytes") && pos) {
+		*tx_error &= ~CEC_ERROR_INJ_TX_REMOVE_BYTE;
+		*tx_error &= ~CEC_ERROR_INJ_TX_ADD_BYTES_NUM(0xff);
+		*tx_error |= CEC_ERROR_INJ_TX_ADD_BYTES |
+			     CEC_ERROR_INJ_TX_ADD_BYTES_NUM(pos);
+	} else if (!strcmp(token, "tx-remove-byte")) {
+		*tx_error &= ~CEC_ERROR_INJ_TX_ADD_BYTES;
+		*tx_error |= CEC_ERROR_INJ_TX_REMOVE_BYTE;
+	} else if (has_pos && pos < 160 && !strcmp(token, "tx-low-drive")) {
+		if (need_op && pos < 10 + 8)
+			return false;
+		*tx_error &= ~CEC_ERROR_INJ_TX_LOW_DRIVE_POS(0xff);
+		*tx_error |= CEC_ERROR_INJ_TX_LOW_DRIVE |
+			     CEC_ERROR_INJ_TX_LOW_DRIVE_POS(pos);
+	} else {
+		return false;
+	}
+	return true;
+}
+
+static void cec_pin_show_cmd(struct seq_file *sf, u32 cmd)
+{
+	if (cmd == CEC_ERROR_INJ_OP_ALL)
+		seq_puts(sf, "all ");
+	else if (cmd == CEC_ERROR_INJ_OP_NEXT)
+		seq_puts(sf, "next ");
+	else
+		seq_printf(sf, "0x%02x ", cmd);
+}
+
+int cec_pin_error_inj_show(struct cec_adapter *adap, struct seq_file *sf)
+{
+	struct cec_pin *pin = adap->pin;
+	unsigned int i;
+
+	seq_puts(sf, "# Clear error injections:\n");
+	seq_puts(sf, "#   clear:         clear all rx and tx error injections\n");
+	seq_puts(sf, "#   rx-clear:      clear all rx error injections\n");
+	seq_puts(sf, "#   tx-clear:      clear all tx error injections\n");
+	seq_puts(sf, "#   <op> clear:    clear all rx and tx error injections for <op>\n");
+	seq_puts(sf, "#   <op> rx-clear: clear all rx error injections for <op>\n");
+	seq_puts(sf, "#   <op> tx-clear: clear all tx error injections for <op>\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# RX error injection:\n");
+	seq_puts(sf, "#   <op> rx-nack:        NACK the message instead of sending an ACK\n");
+	seq_puts(sf, "#   <op> rx-low-drive <bit>: force a low-drive condition at this bit position\n");
+	seq_puts(sf, "#   <op> rx-add-byte:    add a spurious byte to the received CEC message\n");
+	seq_puts(sf, "#   <op> rx-remove-byte: remove the last byte from the received CEC message\n");
+	seq_puts(sf, "#   <op> rx-arb-lost <poll>:    generate a POLL message to trigger an arbitration lost\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# TX error injection settings:\n");
+	seq_puts(sf, "#   tx-ignore-nack-until-eom:     ignore early NACKs until EOM\n");
+	seq_puts(sf, "#   tx-custom-low-usecs <usecs>:  define the 'low' time for the custom pulse\n");
+	seq_puts(sf, "#   tx-custom-high-usecs <usecs>: define the 'high' time for the custom pulse\n");
+	seq_puts(sf, "#   tx-custom-pulse:              transmit the custom pulse once the bus is idle\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# TX error injection:\n");
+	seq_puts(sf, "#   <op> tx-no-eom:            don't set the EOM bit\n");
+	seq_puts(sf, "#   <op> tx-early-eom:         set the EOM bit one byte too soon\n");
+	seq_puts(sf, "#   <op> tx-add-bytes <num>:   append <num> (1-255) spurious bytes to the message\n");
+	seq_puts(sf, "#   <op> tx-remove-byte:       drop the last byte from the message\n");
+	seq_puts(sf, "#   <op> tx-short-bit <bit>:   make this bit shorter than allowed\n");
+	seq_puts(sf, "#   <op> tx-long-bit <bit>:    make this bit longer than allowed\n");
+	seq_puts(sf, "#   <op> tx-custom-bit <bit>:  send the custom pulse instead of this bit\n");
+	seq_puts(sf, "#   <op> tx-short-start:       send a start pulse that's too short\n");
+	seq_puts(sf, "#   <op> tx-long-start:        send a start pulse that's too long\n");
+	seq_puts(sf, "#   <op> tx-custom-start:      send the custom pulse instead of the start pulse\n");
+	seq_puts(sf, "#   <op> tx-last-bit <bit>:    stop sending after this bit\n");
+	seq_puts(sf, "#   <op> tx-low-drive <bit>:   force a low-drive condition at this bit position\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# <op>:    CEC message opcode (0-255), 'next' or 'all'\n");
+	seq_puts(sf, "# <bit>:   CEC message bit (0-159)\n");
+	seq_puts(sf, "#          10 bits per 'byte': bits 0-7: data, bit 8: EOM, bit 9: ACK\n");
+	seq_puts(sf, "# <poll>:  CEC poll message used to test arbitration lost (0x00-0xff, default 0x0f)\n");
+	seq_puts(sf, "# <usecs>: microseconds (0-10000000, default 1000)\n");
+
+	seq_puts(sf, "\nclear\n");
+
+	for (i = 0; i < ARRAY_SIZE(pin->tx_error_inj); i++) {
+		u64 e = pin->rx_error_inj[i];
+
+		if (e & CEC_ERROR_INJ_RX_NACK) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "rx-nack\n");
+		}
+		if (e & CEC_ERROR_INJ_RX_LOW_DRIVE) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "rx-low-drive %llu\n",
+				 (e & CEC_ERROR_INJ_RX_LOW_DRIVE_POS(0xff)) >>
+				 CEC_ERROR_INJ_RX_LOW_DRIVE_POS_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_RX_ADD_BYTE) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "rx-add-byte\n");
+		}
+		if (e & CEC_ERROR_INJ_RX_REMOVE_BYTE) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "rx-remove-byte\n");
+		}
+		if (e & CEC_ERROR_INJ_RX_ARB_LOST) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "rx-arb-lost 0x%02llx\n",
+				   (e & CEC_ERROR_INJ_RX_ARB_LOST_POLL(0xff)) >>
+				   CEC_ERROR_INJ_RX_ARB_LOST_POLL_OFFSET);
+		}
+
+		e = pin->tx_error_inj[i];
+
+		if (e & CEC_ERROR_INJ_TX_NO_EOM) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-no-eom\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_EARLY_EOM) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-early-eom\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_SHORT_BIT) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-short-bit %llu\n",
+				 (e & CEC_ERROR_INJ_TX_INVALID_BIT_POS(0xff)) >>
+				 CEC_ERROR_INJ_TX_INVALID_BIT_POS_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_TX_LONG_BIT) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-long-bit %llu\n",
+				 (e & CEC_ERROR_INJ_TX_INVALID_BIT_POS(0xff)) >>
+				 CEC_ERROR_INJ_TX_INVALID_BIT_POS_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_TX_CUSTOM_BIT) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-custom-bit %llu\n",
+				 (e & CEC_ERROR_INJ_TX_INVALID_BIT_POS(0xff)) >>
+				 CEC_ERROR_INJ_TX_INVALID_BIT_POS_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_TX_SHORT_START) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-short-start\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_LONG_START) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-long-start\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_CUSTOM_START) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-custom-start\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_ADD_BYTES) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-add-bytes %llu\n",
+				 (e & CEC_ERROR_INJ_TX_ADD_BYTES_NUM(0xff)) >>
+				 CEC_ERROR_INJ_TX_ADD_BYTES_NUM_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_TX_REMOVE_BYTE) {
+			cec_pin_show_cmd(sf, i);
+			seq_puts(sf, "tx-remove-byte\n");
+		}
+		if (e & CEC_ERROR_INJ_TX_LAST_BIT) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-last-bit %llu\n",
+				 (e & CEC_ERROR_INJ_TX_LAST_BIT_POS(0xff)) >>
+				 CEC_ERROR_INJ_TX_LAST_BIT_POS_OFFSET);
+		}
+		if (e & CEC_ERROR_INJ_TX_LOW_DRIVE) {
+			cec_pin_show_cmd(sf, i);
+			seq_printf(sf, "tx-low-drive %llu\n",
+				 (e & CEC_ERROR_INJ_TX_LOW_DRIVE_POS(0xff)) >>
+				 CEC_ERROR_INJ_TX_LOW_DRIVE_POS_OFFSET);
+		}
+	}
+	if (pin->tx_ignore_nack_until_eom)
+		seq_puts(sf, "tx-ignore-nack-until-eom\n");
+	if (pin->tx_custom_pulse)
+		seq_puts(sf, "tx-custom-pulse\n");
+	if (pin->tx_custom_low_usecs != CEC_TIM_CUSTOM_DEFAULT)
+		seq_printf(sf, "tx-custom-low-usecs %u\n",
+			   pin->tx_custom_low_usecs);
+	if (pin->tx_custom_high_usecs != CEC_TIM_CUSTOM_DEFAULT)
+		seq_printf(sf, "tx-custom-high-usecs %u\n",
+			   pin->tx_custom_high_usecs);
+	return 0;
+}
diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
index 4571a0001a9d..a33e7ef6cdf5 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -74,6 +74,48 @@ enum cec_pin_state {
 	CEC_PIN_STATES
 };
 
+/* Error Injection */
+
+/* Receive error injection options */
+#define CEC_ERROR_INJ_RX_NACK				(1 << 0)
+#define CEC_ERROR_INJ_RX_LOW_DRIVE			(1 << 1)
+#define CEC_ERROR_INJ_RX_ADD_BYTE			(1 << 2)
+#define CEC_ERROR_INJ_RX_REMOVE_BYTE			(1 << 3)
+#define CEC_ERROR_INJ_RX_ARB_LOST			(1 << 4)
+#define CEC_ERROR_INJ_RX_LOW_DRIVE_POS_OFFSET		8
+#define CEC_ERROR_INJ_RX_LOW_DRIVE_POS(bit)		((bit) << CEC_ERROR_INJ_RX_LOW_DRIVE_POS_OFFSET)
+#define CEC_ERROR_INJ_RX_ARB_LOST_POLL_OFFSET		16
+#define CEC_ERROR_INJ_RX_ARB_LOST_POLL(poll)		((poll) << CEC_ERROR_INJ_RX_ARB_LOST_POLL_OFFSET)
+
+/* Transmit error injection options */
+#define CEC_ERROR_INJ_TX_NO_EOM				(1 << 0)
+#define CEC_ERROR_INJ_TX_EARLY_EOM			(1 << 1)
+#define CEC_ERROR_INJ_TX_SHORT_BIT			(1 << 2)
+#define CEC_ERROR_INJ_TX_LONG_BIT			(1 << 3)
+#define CEC_ERROR_INJ_TX_CUSTOM_BIT			(1 << 4)
+#define CEC_ERROR_INJ_TX_SHORT_START			(1 << 5)
+#define CEC_ERROR_INJ_TX_LONG_START			(1 << 6)
+#define CEC_ERROR_INJ_TX_CUSTOM_START			(1 << 7)
+#define CEC_ERROR_INJ_TX_LAST_BIT			(1 << 8)
+#define CEC_ERROR_INJ_TX_ADD_BYTES			(1 << 9)
+#define CEC_ERROR_INJ_TX_REMOVE_BYTE			(1 << 10)
+#define CEC_ERROR_INJ_TX_LOW_DRIVE			(1 << 11)
+#define CEC_ERROR_INJ_TX_ADD_BYTES_NUM_OFFSET		32
+#define CEC_ERROR_INJ_TX_ADD_BYTES_NUM(byte)		(((u64)byte) << CEC_ERROR_INJ_TX_ADD_BYTES_NUM_OFFSET)
+#define CEC_ERROR_INJ_TX_INVALID_BIT_POS_OFFSET		40
+#define CEC_ERROR_INJ_TX_INVALID_BIT_POS(bit)		(((u64)bit) << CEC_ERROR_INJ_TX_INVALID_BIT_POS_OFFSET)
+#define CEC_ERROR_INJ_TX_LAST_BIT_POS_OFFSET		48
+#define CEC_ERROR_INJ_TX_LAST_BIT_POS(bit)		(((u64)bit) << CEC_ERROR_INJ_TX_LAST_BIT_POS_OFFSET)
+#define CEC_ERROR_INJ_TX_LOW_DRIVE_POS_OFFSET		56
+#define CEC_ERROR_INJ_TX_LOW_DRIVE_POS(bit)		(((u64)bit) << CEC_ERROR_INJ_TX_LOW_DRIVE_POS_OFFSET)
+
+/* Special CEC op values */
+#define CEC_ERROR_INJ_OP_ALL				0x00000100
+#define CEC_ERROR_INJ_OP_NEXT				0x00000101
+
+/* The default for the low/high time of the custom pulse */
+#define CEC_TIM_CUSTOM_DEFAULT				1000
+
 #define CEC_NUM_PIN_EVENTS 128
 
 #define CEC_PIN_IRQ_UNCHANGED	0
@@ -116,8 +158,62 @@ struct cec_pin {
 	u32				timer_300ms_overruns;
 	u32				timer_max_overrun;
 	u32				timer_sum_overrun;
+
+	u32				tx_custom_low_usecs;
+	u32				tx_custom_high_usecs;
+	bool				tx_ignore_nack_until_eom;
+	bool				tx_custom_pulse;
+	bool				tx_generated_poll;
+	bool				tx_post_eom;
+	u8				tx_extra_bytes;
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+	u32				rx_error_inj[CEC_ERROR_INJ_OP_NEXT + 1];
+	u64				tx_error_inj[CEC_ERROR_INJ_OP_NEXT + 1];
+#endif
 };
 
 void cec_pin_start_timer(struct cec_pin *pin);
 
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line);
+int cec_pin_error_inj_show(struct cec_adapter *adap, struct seq_file *sf);
+
+u32 cec_pin_rx_error_inj(struct cec_pin *pin);
+u64 cec_pin_tx_error_inj(struct cec_pin *pin);
+
+static inline void cec_pin_rx_next_clear(struct cec_pin *pin)
+{
+	pin->rx_error_inj[CEC_ERROR_INJ_OP_NEXT] = 0;
+}
+
+static inline void cec_pin_tx_next_clear(struct cec_pin *pin)
+{
+	pin->tx_error_inj[CEC_ERROR_INJ_OP_NEXT] = 0;
+}
+
+void cec_pin_error_inj(struct cec_pin *pin);
+#else
+static inline u32 cec_pin_rx_error_inj(struct cec_pin *pin)
+{
+	return 0;
+}
+
+static inline u64 cec_pin_tx_error_inj(struct cec_pin *pin)
+{
+	return 0;
+}
+
+static inline void cec_pin_rx_next_clear(struct cec_pin *pin)
+{
+}
+
+static inline void cec_pin_tx_next_clear(struct cec_pin *pin)
+{
+}
+
+static inline void cec_pin_error_inj(struct cec_pin *pin)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 67d6ea9f56b6..7920ea1c940b 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -771,6 +771,10 @@ static const struct cec_adap_ops cec_pin_adap_ops = {
 	.adap_transmit = cec_pin_adap_transmit,
 	.adap_status = cec_pin_adap_status,
 	.adap_free = cec_pin_adap_free,
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+	.error_inj_parse_line = cec_pin_error_inj_parse_line,
+	.error_inj_show = cec_pin_error_inj_show,
+#endif
 };
 
 struct cec_adapter *cec_pin_allocate_adapter(const struct cec_pin_ops *pin_ops,
@@ -785,6 +789,8 @@ struct cec_adapter *cec_pin_allocate_adapter(const struct cec_pin_ops *pin_ops,
 	hrtimer_init(&pin->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	pin->timer.function = cec_pin_timer;
 	init_waitqueue_head(&pin->kthread_waitq);
+	pin->tx_custom_low_usecs = CEC_TIM_CUSTOM_DEFAULT;
+	pin->tx_custom_high_usecs = CEC_TIM_CUSTOM_DEFAULT;
 
 	adap = cec_allocate_adapter(&cec_pin_adap_ops, priv, name,
 			    caps | CEC_CAP_MONITOR_ALL | CEC_CAP_MONITOR_PIN,
-- 
2.15.1
