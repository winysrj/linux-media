Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41419 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934165AbeCENvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 08:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/7] cec-pin-error-inj: parse/show error injection
Date: Mon,  5 Mar 2018 14:51:36 +0100
Message-Id: <20180305135139.95652-5-hverkuil@xs4all.nl>
In-Reply-To: <20180305135139.95652-1-hverkuil@xs4all.nl>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
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
 drivers/media/cec/cec-pin-error-inj.c | 341 ++++++++++++++++++++++++++++++++++
 drivers/media/cec/cec-pin-priv.h      |  71 +++++++
 drivers/media/cec/cec-pin.c           |   6 +
 5 files changed, 428 insertions(+)
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
index 000000000000..10f73def9df5
--- /dev/null
+++ b/drivers/media/cec/cec-pin-error-inj.c
@@ -0,0 +1,341 @@
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
+struct cec_error_inj_cmd {
+	unsigned int mode_offset;
+	int arg_idx;
+	const char *cmd;
+};
+
+static const struct cec_error_inj_cmd cec_error_inj_cmds[] = {
+	{ CEC_ERROR_INJ_RX_NACK_OFFSET, -1, "rx-nack" },
+	{ CEC_ERROR_INJ_RX_LOW_DRIVE_OFFSET,
+	  CEC_ERROR_INJ_RX_LOW_DRIVE_ARG_IDX, "rx-low-drive" },
+	{ CEC_ERROR_INJ_RX_ADD_BYTE_OFFSET, -1, "rx-add-byte" },
+	{ CEC_ERROR_INJ_RX_REMOVE_BYTE_OFFSET, -1, "rx-remove-byte" },
+	{ CEC_ERROR_INJ_RX_ARB_LOST_OFFSET,
+	  CEC_ERROR_INJ_RX_ARB_LOST_ARG_IDX, "rx-arb-lost" },
+
+	{ CEC_ERROR_INJ_TX_NO_EOM_OFFSET, -1, "tx-no-eom" },
+	{ CEC_ERROR_INJ_TX_EARLY_EOM_OFFSET, -1, "tx-early-eom" },
+	{ CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET,
+	  CEC_ERROR_INJ_TX_ADD_BYTES_ARG_IDX, "tx-add-bytes" },
+	{ CEC_ERROR_INJ_TX_REMOVE_BYTE_OFFSET, -1, "tx-remove-byte" },
+	{ CEC_ERROR_INJ_TX_SHORT_BIT_OFFSET,
+	  CEC_ERROR_INJ_TX_SHORT_BIT_ARG_IDX, "tx-short-bit" },
+	{ CEC_ERROR_INJ_TX_LONG_BIT_OFFSET,
+	  CEC_ERROR_INJ_TX_LONG_BIT_ARG_IDX, "tx-long-bit" },
+	{ CEC_ERROR_INJ_TX_CUSTOM_BIT_OFFSET,
+	  CEC_ERROR_INJ_TX_CUSTOM_BIT_ARG_IDX, "tx-custom-bit" },
+	{ CEC_ERROR_INJ_TX_SHORT_START_OFFSET, -1, "tx-short-start" },
+	{ CEC_ERROR_INJ_TX_LONG_START_OFFSET, -1, "tx-long-start" },
+	{ CEC_ERROR_INJ_TX_CUSTOM_START_OFFSET, -1, "tx-custom-start" },
+	{ CEC_ERROR_INJ_TX_LAST_BIT_OFFSET,
+	  CEC_ERROR_INJ_TX_LAST_BIT_ARG_IDX, "tx-last-bit" },
+	{ CEC_ERROR_INJ_TX_LOW_DRIVE_OFFSET,
+	  CEC_ERROR_INJ_TX_LOW_DRIVE_ARG_IDX, "tx-low-drive" },
+	{ 0, -1, NULL }
+};
+
+u16 cec_pin_rx_error_inj(struct cec_pin *pin)
+{
+	u16 cmd = CEC_ERROR_INJ_OP_ANY;
+
+	/* Only when 18 bits have been received do we have a valid cmd */
+	if (!(pin->error_inj[cmd] & CEC_ERROR_INJ_RX_MASK) &&
+	    pin->rx_bit >= 18)
+		cmd = pin->rx_msg.msg[1];
+	return (pin->error_inj[cmd] & CEC_ERROR_INJ_RX_MASK) ? cmd :
+		CEC_ERROR_INJ_OP_ANY;
+}
+
+u16 cec_pin_tx_error_inj(struct cec_pin *pin)
+{
+	u16 cmd = CEC_ERROR_INJ_OP_ANY;
+
+	if (!(pin->error_inj[cmd] & CEC_ERROR_INJ_TX_MASK) &&
+	    pin->tx_msg.len > 1)
+		cmd = pin->tx_msg.msg[1];
+	return (pin->error_inj[cmd] & CEC_ERROR_INJ_TX_MASK) ? cmd :
+		CEC_ERROR_INJ_OP_ANY;
+}
+
+bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
+{
+	static const char *delims = " \t\r";
+	struct cec_pin *pin = adap->pin;
+	unsigned int i;
+	bool has_pos = false;
+	char *p = line;
+	char *token;
+	char *comma;
+	u64 *error;
+	u8 *args;
+	bool has_op;
+	u32 op;
+	u8 mode;
+	u8 pos;
+	u8 v;
+
+	p = skip_spaces(p);
+	token = strsep(&p, delims);
+	if (!strcmp(token, "clear")) {
+		memset(pin->error_inj, 0, sizeof(pin->error_inj));
+		pin->rx_toggle = pin->tx_toggle = false;
+		pin->tx_ignore_nack_until_eom = false;
+		pin->tx_custom_pulse = false;
+		pin->tx_custom_low_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		pin->tx_custom_high_usecs = CEC_TIM_CUSTOM_DEFAULT;
+		return true;
+	}
+	if (!strcmp(token, "rx-clear")) {
+		for (i = 0; i <= CEC_ERROR_INJ_OP_ANY; i++)
+			pin->error_inj[i] &= ~CEC_ERROR_INJ_RX_MASK;
+		pin->rx_toggle = false;
+		return true;
+	}
+	if (!strcmp(token, "tx-clear")) {
+		for (i = 0; i <= CEC_ERROR_INJ_OP_ANY; i++)
+			pin->error_inj[i] &= ~CEC_ERROR_INJ_TX_MASK;
+		pin->tx_toggle = false;
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
+	comma = strchr(token, ',');
+	if (comma)
+		*comma++ = '\0';
+	if (!strcmp(token, "any"))
+		op = CEC_ERROR_INJ_OP_ANY;
+	else if (!kstrtou8(token, 0, &v))
+		op = v;
+	else
+		return false;
+	mode = CEC_ERROR_INJ_MODE_ONCE;
+	if (comma) {
+		if (!strcmp(comma, "off"))
+			mode = CEC_ERROR_INJ_MODE_OFF;
+		else if (!strcmp(comma, "once"))
+			mode = CEC_ERROR_INJ_MODE_ONCE;
+		else if (!strcmp(comma, "always"))
+			mode = CEC_ERROR_INJ_MODE_ALWAYS;
+		else if (!strcmp(comma, "toggle"))
+			mode = CEC_ERROR_INJ_MODE_TOGGLE;
+		else
+			return false;
+	}
+
+	error = pin->error_inj + op;
+	args = pin->error_inj_args[op];
+	has_op = op <= 0xff;
+
+	token = strsep(&p, delims);
+	if (p) {
+		p = skip_spaces(p);
+		has_pos = !kstrtou8(p, 0, &pos);
+	}
+
+	if (!strcmp(token, "clear")) {
+		*error = 0;
+		return true;
+	}
+	if (!strcmp(token, "rx-clear")) {
+		*error &= ~CEC_ERROR_INJ_RX_MASK;
+		return true;
+	}
+	if (!strcmp(token, "tx-clear")) {
+		*error &= ~CEC_ERROR_INJ_TX_MASK;
+		return true;
+	}
+
+	for (i = 0; cec_error_inj_cmds[i].cmd; i++) {
+		const char *cmd = cec_error_inj_cmds[i].cmd;
+		unsigned int mode_offset;
+		u64 mode_mask;
+		int arg_idx;
+		bool is_bit_pos = true;
+
+		if (strcmp(token, cmd))
+			continue;
+
+		mode_offset = cec_error_inj_cmds[i].mode_offset;
+		mode_mask = CEC_ERROR_INJ_MODE_MASK << mode_offset;
+		arg_idx = cec_error_inj_cmds[i].arg_idx;
+
+		if (mode_offset == CEC_ERROR_INJ_RX_ARB_LOST_OFFSET ||
+		    mode_offset == CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET)
+			is_bit_pos = false;
+
+		if (mode_offset == CEC_ERROR_INJ_RX_ARB_LOST_OFFSET) {
+			if (has_op)
+				return false;
+			if (!has_pos)
+				pos = 0x0f;
+		}
+		if (arg_idx >= 0 && is_bit_pos) {
+			if (!has_pos || pos >= 160)
+				return false;
+			if (has_op && pos < 10 + 8)
+				return false;
+			/* Invalid bit position may not be the Ack bit */
+			if ((mode_offset == CEC_ERROR_INJ_TX_SHORT_BIT_OFFSET ||
+			     mode_offset == CEC_ERROR_INJ_TX_LONG_BIT_OFFSET ||
+			     mode_offset == CEC_ERROR_INJ_TX_CUSTOM_BIT_OFFSET) &&
+			    (pos % 10) == 9)
+				return false;
+		}
+		*error &= ~mode_mask;
+		*error |= (u64)mode << mode_offset;
+		if (arg_idx >= 0)
+			args[arg_idx] = pos;
+		return true;
+	}
+	return false;
+}
+
+static void cec_pin_show_cmd(struct seq_file *sf, u32 cmd, u8 mode)
+{
+	if (cmd == CEC_ERROR_INJ_OP_ANY)
+		seq_puts(sf, "any,");
+	else
+		seq_printf(sf, "0x%02x,", cmd);
+	switch (mode) {
+	case CEC_ERROR_INJ_MODE_ONCE:
+		seq_puts(sf, "once ");
+		break;
+	case CEC_ERROR_INJ_MODE_ALWAYS:
+		seq_puts(sf, "always ");
+		break;
+	case CEC_ERROR_INJ_MODE_TOGGLE:
+		seq_puts(sf, "toggle ");
+		break;
+	default:
+		seq_puts(sf, "off ");
+		break;
+	}
+}
+
+int cec_pin_error_inj_show(struct cec_adapter *adap, struct seq_file *sf)
+{
+	struct cec_pin *pin = adap->pin;
+	unsigned int i, j;
+
+	seq_puts(sf, "# Clear error injections:\n");
+	seq_puts(sf, "#   clear          clear all rx and tx error injections\n");
+	seq_puts(sf, "#   rx-clear       clear all rx error injections\n");
+	seq_puts(sf, "#   tx-clear       clear all tx error injections\n");
+	seq_puts(sf, "#   <op> clear     clear all rx and tx error injections for <op>\n");
+	seq_puts(sf, "#   <op> rx-clear  clear all rx error injections for <op>\n");
+	seq_puts(sf, "#   <op> tx-clear  clear all tx error injections for <op>\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# RX error injection:\n");
+	seq_puts(sf, "#   <op>[,<mode>] rx-nack              NACK the message instead of sending an ACK\n");
+	seq_puts(sf, "#   <op>[,<mode>] rx-low-drive <bit>   force a low-drive condition at this bit position\n");
+	seq_puts(sf, "#   <op>[,<mode>] rx-add-byte          add a spurious byte to the received CEC message\n");
+	seq_puts(sf, "#   <op>[,<mode>] rx-remove-byte       remove the last byte from the received CEC message\n");
+	seq_puts(sf, "#   <op>[,<mode>] rx-arb-lost <poll>   generate a POLL message to trigger an arbitration lost\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# TX error injection settings:\n");
+	seq_puts(sf, "#   tx-ignore-nack-until-eom           ignore early NACKs until EOM\n");
+	seq_puts(sf, "#   tx-custom-low-usecs <usecs>        define the 'low' time for the custom pulse\n");
+	seq_puts(sf, "#   tx-custom-high-usecs <usecs>       define the 'high' time for the custom pulse\n");
+	seq_puts(sf, "#   tx-custom-pulse                    transmit the custom pulse once the bus is idle\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# TX error injection:\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-no-eom            don't set the EOM bit\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-early-eom         set the EOM bit one byte too soon\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-add-bytes <num>   append <num> (1-255) spurious bytes to the message\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-remove-byte       drop the last byte from the message\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-short-bit <bit>   make this bit shorter than allowed\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-long-bit <bit>    make this bit longer than allowed\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-custom-bit <bit>  send the custom pulse instead of this bit\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-short-start       send a start pulse that's too short\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-long-start        send a start pulse that's too long\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-custom-start      send the custom pulse instead of the start pulse\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-last-bit <bit>    stop sending after this bit\n");
+	seq_puts(sf, "#   <op>[,<mode>] tx-low-drive <bit>   force a low-drive condition at this bit position\n");
+	seq_puts(sf, "#\n");
+	seq_puts(sf, "# <op>       CEC message opcode (0-255) or 'any'\n");
+	seq_puts(sf, "# <mode>     'once' (default), 'always', 'toggle' or 'off'\n");
+	seq_puts(sf, "# <bit>      CEC message bit (0-159)\n");
+	seq_puts(sf, "#            10 bits per 'byte': bits 0-7: data, bit 8: EOM, bit 9: ACK\n");
+	seq_puts(sf, "# <poll>     CEC poll message used to test arbitration lost (0x00-0xff, default 0x0f)\n");
+	seq_puts(sf, "# <usecs>    microseconds (0-10000000, default 1000)\n");
+
+	seq_puts(sf, "\nclear\n");
+
+	for (i = 0; i < ARRAY_SIZE(pin->error_inj); i++) {
+		u64 e = pin->error_inj[i];
+
+		for (j = 0; cec_error_inj_cmds[j].cmd; j++) {
+			const char *cmd = cec_error_inj_cmds[j].cmd;
+			unsigned int mode;
+			unsigned int mode_offset;
+			int arg_idx;
+
+			mode_offset = cec_error_inj_cmds[j].mode_offset;
+			arg_idx = cec_error_inj_cmds[j].arg_idx;
+			mode = (e >> mode_offset) & CEC_ERROR_INJ_MODE_MASK;
+			if (!mode)
+				continue;
+			cec_pin_show_cmd(sf, i, mode);
+			seq_puts(sf, cmd);
+			if (arg_idx >= 0)
+				seq_printf(sf, " %u", pin->error_inj_args[i][arg_idx]);
+			seq_puts(sf, "\n");
+		}
+	}
+
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
index 4571a0001a9d..779384f18689 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -74,6 +74,55 @@ enum cec_pin_state {
 	CEC_PIN_STATES
 };
 
+/* Error Injection */
+
+/* Error injection modes */
+#define CEC_ERROR_INJ_MODE_OFF				0
+#define CEC_ERROR_INJ_MODE_ONCE				1
+#define CEC_ERROR_INJ_MODE_ALWAYS			2
+#define CEC_ERROR_INJ_MODE_TOGGLE			3
+#define CEC_ERROR_INJ_MODE_MASK				3ULL
+
+/* Receive error injection options */
+#define CEC_ERROR_INJ_RX_NACK_OFFSET			0
+#define CEC_ERROR_INJ_RX_LOW_DRIVE_OFFSET		2
+#define CEC_ERROR_INJ_RX_ADD_BYTE_OFFSET		4
+#define CEC_ERROR_INJ_RX_REMOVE_BYTE_OFFSET		6
+#define CEC_ERROR_INJ_RX_ARB_LOST_OFFSET		8
+#define CEC_ERROR_INJ_RX_MASK				0xffffULL
+
+/* Transmit error injection options */
+#define CEC_ERROR_INJ_TX_NO_EOM_OFFSET			16
+#define CEC_ERROR_INJ_TX_EARLY_EOM_OFFSET		18
+#define CEC_ERROR_INJ_TX_SHORT_BIT_OFFSET		20
+#define CEC_ERROR_INJ_TX_LONG_BIT_OFFSET		22
+#define CEC_ERROR_INJ_TX_CUSTOM_BIT_OFFSET		24
+#define CEC_ERROR_INJ_TX_SHORT_START_OFFSET		26
+#define CEC_ERROR_INJ_TX_LONG_START_OFFSET		28
+#define CEC_ERROR_INJ_TX_CUSTOM_START_OFFSET		30
+#define CEC_ERROR_INJ_TX_LAST_BIT_OFFSET		32
+#define CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET		34
+#define CEC_ERROR_INJ_TX_REMOVE_BYTE_OFFSET		36
+#define CEC_ERROR_INJ_TX_LOW_DRIVE_OFFSET		38
+#define CEC_ERROR_INJ_TX_MASK				0xffffffffffff0000ULL
+
+#define CEC_ERROR_INJ_RX_LOW_DRIVE_ARG_IDX		0
+#define CEC_ERROR_INJ_RX_ARB_LOST_ARG_IDX		1
+
+#define CEC_ERROR_INJ_TX_ADD_BYTES_ARG_IDX		2
+#define CEC_ERROR_INJ_TX_SHORT_BIT_ARG_IDX		3
+#define CEC_ERROR_INJ_TX_LONG_BIT_ARG_IDX		4
+#define CEC_ERROR_INJ_TX_CUSTOM_BIT_ARG_IDX		5
+#define CEC_ERROR_INJ_TX_LAST_BIT_ARG_IDX		6
+#define CEC_ERROR_INJ_TX_LOW_DRIVE_ARG_IDX		7
+#define CEC_ERROR_INJ_NUM_ARGS				8
+
+/* Special CEC op values */
+#define CEC_ERROR_INJ_OP_ANY				0x00000100
+
+/* The default for the low/high time of the custom pulse */
+#define CEC_TIM_CUSTOM_DEFAULT				1000
+
 #define CEC_NUM_PIN_EVENTS 128
 
 #define CEC_PIN_IRQ_UNCHANGED	0
@@ -98,8 +147,10 @@ struct cec_pin {
 	u32				tx_bit;
 	bool				tx_nacked;
 	u32				tx_signal_free_time;
+	bool				tx_toggle;
 	struct cec_msg			rx_msg;
 	u32				rx_bit;
+	bool				rx_toggle;
 
 	struct cec_msg			work_rx_msg;
 	u8				work_tx_status;
@@ -116,8 +167,28 @@ struct cec_pin {
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
+	u64				error_inj[CEC_ERROR_INJ_OP_ANY + 1];
+	u8				error_inj_args[CEC_ERROR_INJ_OP_ANY + 1][CEC_ERROR_INJ_NUM_ARGS];
+#endif
 };
 
 void cec_pin_start_timer(struct cec_pin *pin);
 
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line);
+int cec_pin_error_inj_show(struct cec_adapter *adap, struct seq_file *sf);
+
+u16 cec_pin_rx_error_inj(struct cec_pin *pin);
+u16 cec_pin_tx_error_inj(struct cec_pin *pin);
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
2.16.1
