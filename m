Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57862 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab0GTBWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:22:19 -0400
Subject: [PATCH 12/17] cx25840: Add support for CX2388[57] A/V core
 integrated IR controllers
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:22:09 -0400
Message-ID: <1279588929.31145.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is primarily a port of the integrated IR controller code in
cx23885/cx23888-ir.c.  Right now, only the CX2388[57] AV core will
really try to set up IR. This IR support, by design, still requires the
bridge driver to do final IO pin mux configuration and setup of the IR
controller parameters.

For the CX2388[578] chips, enabling the AV Core for IR also starts
sending Audio and Video interrupts to the bridge driver.  For
CX2388[578] chips audio and video interrupts are ignored and
acknowledged when they happen.

IR interrupt handling and status logging is exluded for the CX23888
which does not have an IR controller on the AV core.

Note that experimentation reveals that the IR irq enables on the
CX23885 have an inverted logic sense.  The CX23887 likely suffers from
the same quirk.  For these chips, those irq enable bits are handled
as interrupt disables.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx25840/Makefile       |    2 +-
 drivers/media/video/cx25840/cx25840-core.c |  128 +++
 drivers/media/video/cx25840/cx25840-core.h |   28 +
 drivers/media/video/cx25840/cx25840-ir.c   | 1262 ++++++++++++++++++++++++++++
 4 files changed, 1419 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/cx25840/cx25840-ir.c

diff --git a/drivers/media/video/cx25840/Makefile b/drivers/media/video/cx25840/Makefile
index 6e8665b..2ee96d3 100644
--- a/drivers/media/video/cx25840/Makefile
+++ b/drivers/media/video/cx25840/Makefile
@@ -1,5 +1,5 @@
 cx25840-objs    := cx25840-core.o cx25840-audio.o cx25840-firmware.o \
-		   cx25840-vbi.o
+		   cx25840-vbi.o cx25840-ir.o
 
 obj-$(CONFIG_VIDEO_CX25840) += cx25840.o
 
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 46a046d..9fab0b1 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -15,6 +15,9 @@
  *
  * CX23885 support by Steven Toth <stoth@linuxtv.org>.
  *
+ * CX2388[578] IRQ handling, IO Pin mux configuration and other small fixes are
+ * Copyright (C) 2010 Andy Walls <awalls@md.metrocast.net>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
@@ -48,6 +51,28 @@ MODULE_DESCRIPTION("Conexant CX25840 audio/video decoder driver");
 MODULE_AUTHOR("Ulf Eklund, Chris Kennedy, Hans Verkuil, Tyler Trafford");
 MODULE_LICENSE("GPL");
 
+#define CX25840_VID_INT_STAT_REG 0x410
+#define CX25840_VID_INT_STAT_BITS 0x0000ffff
+#define CX25840_VID_INT_MASK_BITS 0xffff0000
+#define CX25840_VID_INT_MASK_SHFT 16
+#define CX25840_VID_INT_MASK_REG 0x412
+
+#define CX23885_AUD_MC_INT_MASK_REG 0x80c
+#define CX23885_AUD_MC_INT_STAT_BITS 0xffff0000
+#define CX23885_AUD_MC_INT_CTRL_BITS 0x0000ffff
+#define CX23885_AUD_MC_INT_STAT_SHFT 16
+
+#define CX25840_AUD_INT_CTRL_REG 0x812
+#define CX25840_AUD_INT_STAT_REG 0x813
+
+#define CX23885_PIN_CTRL_IRQ_REG 0x123
+#define CX23885_PIN_CTRL_IRQ_IR_STAT  0x40
+#define CX23885_PIN_CTRL_IRQ_AUD_STAT 0x20
+#define CX23885_PIN_CTRL_IRQ_VID_STAT 0x10
+
+#define CX25840_IR_STATS_REG	0x210
+#define CX25840_IR_IRQEN_REG	0x214
+
 static int cx25840_debug;
 
 module_param_named(debug,cx25840_debug, int, 0644);
@@ -137,6 +162,14 @@ int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned and_mask,
 			     or_value);
 }
 
+int cx25840_and_or4(struct i2c_client *client, u16 addr, u32 and_mask,
+		    u32 or_value)
+{
+	return cx25840_write4(client, addr,
+			      (cx25840_read4(client, addr) & and_mask) |
+			      or_value);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static int set_input(struct i2c_client *client, enum cx25840_video_input vid_input,
@@ -592,6 +625,13 @@ static void cx23885_initialize(struct i2c_client *client)
 
 	/* start microcontroller */
 	cx25840_and_or(client, 0x803, ~0x10, 0x10);
+
+	/* Disable and clear video interrupts - we don't use them */
+	cx25840_write4(client, CX25840_VID_INT_STAT_REG, 0xffffffff);
+
+	/* Disable and clear audio interrupts - we don't use them */
+	cx25840_write(client, CX25840_AUD_INT_CTRL_REG, 0xff);
+	cx25840_write(client, CX25840_AUD_INT_STAT_REG, 0xff);
 }
 
 /* ----------------------------------------------------------------------- */
@@ -1748,9 +1788,93 @@ static int cx25840_log_status(struct v4l2_subdev *sd)
 	log_video_status(client);
 	if (!is_cx2583x(state))
 		log_audio_status(client);
+	cx25840_ir_log_status(sd);
 	return 0;
 }
 
+static int cx23885_irq_handler(struct v4l2_subdev *sd, u32 status,
+			       bool *handled)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	u8 irq_stat, aud_stat, aud_en, ir_stat, ir_en;
+	u32 vid_stat, aud_mc_stat;
+	bool block_handled;
+	int ret = 0;
+
+	irq_stat = cx25840_read(c, CX23885_PIN_CTRL_IRQ_REG);
+	v4l_dbg(2, cx25840_debug, c, "AV Core IRQ status (entry): %s %s %s\n",
+		irq_stat & CX23885_PIN_CTRL_IRQ_IR_STAT ? "ir" : "  ",
+		irq_stat & CX23885_PIN_CTRL_IRQ_AUD_STAT ? "aud" : "   ",
+		irq_stat & CX23885_PIN_CTRL_IRQ_VID_STAT ? "vid" : "   ");
+
+	if ((is_cx23885(state) || is_cx23887(state))) {
+		ir_stat = cx25840_read(c, CX25840_IR_STATS_REG);
+		ir_en = cx25840_read(c, CX25840_IR_IRQEN_REG);
+		v4l_dbg(2, cx25840_debug, c,
+			"AV Core ir IRQ status: %#04x disables: %#04x\n",
+			ir_stat, ir_en);
+		if (irq_stat & CX23885_PIN_CTRL_IRQ_IR_STAT) {
+			block_handled = false;
+			ret = cx25840_ir_irq_handler(sd,
+						     status, &block_handled);
+			if (block_handled)
+				*handled = true;
+		}
+	}
+
+	aud_stat = cx25840_read(c, CX25840_AUD_INT_STAT_REG);
+	aud_en = cx25840_read(c, CX25840_AUD_INT_CTRL_REG);
+	v4l_dbg(2, cx25840_debug, c,
+		"AV Core audio IRQ status: %#04x disables: %#04x\n",
+		aud_stat, aud_en);
+	aud_mc_stat = cx25840_read4(c, CX23885_AUD_MC_INT_MASK_REG);
+	v4l_dbg(2, cx25840_debug, c,
+		"AV Core audio MC IRQ status: %#06x enables: %#06x\n",
+		aud_mc_stat >> CX23885_AUD_MC_INT_STAT_SHFT,
+		aud_mc_stat & CX23885_AUD_MC_INT_CTRL_BITS);
+	if (irq_stat & CX23885_PIN_CTRL_IRQ_AUD_STAT) {
+		if (aud_stat) {
+			cx25840_write(c, CX25840_AUD_INT_STAT_REG, aud_stat);
+			*handled = true;
+		}
+	}
+
+	vid_stat = cx25840_read4(c, CX25840_VID_INT_STAT_REG);
+	v4l_dbg(2, cx25840_debug, c,
+		"AV Core video IRQ status: %#06x disables: %#06x\n",
+		vid_stat & CX25840_VID_INT_STAT_BITS,
+		vid_stat >> CX25840_VID_INT_MASK_SHFT);
+	if (irq_stat & CX23885_PIN_CTRL_IRQ_VID_STAT) {
+		if (vid_stat & CX25840_VID_INT_STAT_BITS) {
+			cx25840_write4(c, CX25840_VID_INT_STAT_REG, vid_stat);
+			*handled = true;
+		}
+	}
+
+	irq_stat = cx25840_read(c, CX23885_PIN_CTRL_IRQ_REG);
+	v4l_dbg(2, cx25840_debug, c, "AV Core IRQ status (exit): %s %s %s\n",
+		irq_stat & CX23885_PIN_CTRL_IRQ_IR_STAT ? "ir" : "  ",
+		irq_stat & CX23885_PIN_CTRL_IRQ_AUD_STAT ? "aud" : "   ",
+		irq_stat & CX23885_PIN_CTRL_IRQ_VID_STAT ? "vid" : "   ");
+
+	return ret;
+}
+
+static int cx25840_irq_handler(struct v4l2_subdev *sd, u32 status,
+			       bool *handled)
+{
+	struct cx25840_state *state = to_state(sd);
+
+	*handled = false;
+
+	/* Only support the CX2388[578] AV Core for now */
+	if (is_cx2388x(state))
+		return cx23885_irq_handler(sd, status, handled);
+
+	return -ENODEV;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
@@ -1767,6 +1891,7 @@ static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.g_register = cx25840_g_register,
 	.s_register = cx25840_s_register,
 #endif
+	.interrupt_service_routine = cx25840_irq_handler,
 };
 
 static const struct v4l2_subdev_tuner_ops cx25840_tuner_ops = {
@@ -1801,6 +1926,7 @@ static const struct v4l2_subdev_ops cx25840_ops = {
 	.audio = &cx25840_audio_ops,
 	.video = &cx25840_video_ops,
 	.vbi = &cx25840_vbi_ops,
+	.ir = &cx25840_ir_ops,
 };
 
 /* ----------------------------------------------------------------------- */
@@ -1942,6 +2068,7 @@ static int cx25840_probe(struct i2c_client *client,
 	state->id = id;
 	state->rev = device_id;
 
+	cx25840_ir_probe(sd);
 	return 0;
 }
 
@@ -1949,6 +2076,7 @@ static int cx25840_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
+	cx25840_ir_remove(sd);
 	v4l2_device_unregister_subdev(sd);
 	kfree(to_state(sd));
 	return 0;
diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/video/cx25840/cx25840-core.h
index 04393b9..8f47322 100644
--- a/drivers/media/video/cx25840/cx25840-core.h
+++ b/drivers/media/video/cx25840/cx25840-core.h
@@ -34,6 +34,8 @@
    providing this information. */
 #define CX25840_CID_ENABLE_PVR150_WORKAROUND (V4L2_CID_PRIVATE_BASE+0)
 
+struct cx25840_ir_state;
+
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
@@ -52,6 +54,7 @@ struct cx25840_state {
 	int is_initialized;
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
 	struct work_struct fw_work;   /* work entry for fw load */
+	struct cx25840_ir_state *ir_state;
 };
 
 static inline struct cx25840_state *to_state(struct v4l2_subdev *sd)
@@ -77,6 +80,21 @@ static inline bool is_cx2388x(struct cx25840_state *state)
 	       state->id == V4L2_IDENT_CX23888_AV;
 }
 
+static inline bool is_cx23885(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX23885_AV;
+}
+
+static inline bool is_cx23887(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX23887_AV;
+}
+
+static inline bool is_cx23888(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX23888_AV;
+}
+
 /* ----------------------------------------------------------------------- */
 /* cx25850-core.c 							   */
 int cx25840_write(struct i2c_client *client, u16 addr, u8 value);
@@ -84,6 +102,8 @@ int cx25840_write4(struct i2c_client *client, u16 addr, u32 value);
 u8 cx25840_read(struct i2c_client *client, u16 addr);
 u32 cx25840_read4(struct i2c_client *client, u16 addr);
 int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned mask, u8 value);
+int cx25840_and_or4(struct i2c_client *client, u16 addr, u32 and_mask,
+		    u32 or_value);
 void cx25840_std_setup(struct i2c_client *client);
 
 /* ----------------------------------------------------------------------- */
@@ -104,4 +124,12 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *fmt);
 int cx25840_decode_vbi_line(struct v4l2_subdev *sd, struct v4l2_decode_vbi_line *vbi);
 
+/* ----------------------------------------------------------------------- */
+/* cx25850-ir.c                                                            */
+extern const struct v4l2_subdev_ir_ops cx25840_ir_ops;
+int cx25840_ir_log_status(struct v4l2_subdev *sd);
+int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled);
+int cx25840_ir_probe(struct v4l2_subdev *sd);
+int cx25840_ir_remove(struct v4l2_subdev *sd);
+
 #endif
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
new file mode 100644
index 0000000..308e87e
--- /dev/null
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -0,0 +1,1262 @@
+/*
+ *  Driver for the Conexant CX2584x Audio/Video decoder chip and related cores
+ *
+ *  Integrated Consumer Infrared Controller
+ *
+ *  Copyright (C) 2010  Andy Walls <awalls@md.metrocast.net>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <media/cx25840.h>
+
+#include "cx25840-core.h"
+
+static unsigned int ir_debug;
+module_param(ir_debug, int, 0644);
+MODULE_PARM_DESC(ir_debug, "enable integrated IR debug messages");
+
+#define CX25840_IR_REG_BASE 	0x200
+
+#define CX25840_IR_CNTRL_REG	0x200
+#define CNTRL_WIN_3_3	0x00000000
+#define CNTRL_WIN_4_3	0x00000001
+#define CNTRL_WIN_3_4	0x00000002
+#define CNTRL_WIN_4_4	0x00000003
+#define CNTRL_WIN	0x00000003
+#define CNTRL_EDG_NONE	0x00000000
+#define CNTRL_EDG_FALL	0x00000004
+#define CNTRL_EDG_RISE	0x00000008
+#define CNTRL_EDG_BOTH	0x0000000C
+#define CNTRL_EDG	0x0000000C
+#define CNTRL_DMD	0x00000010
+#define CNTRL_MOD	0x00000020
+#define CNTRL_RFE	0x00000040
+#define CNTRL_TFE	0x00000080
+#define CNTRL_RXE	0x00000100
+#define CNTRL_TXE	0x00000200
+#define CNTRL_RIC	0x00000400
+#define CNTRL_TIC	0x00000800
+#define CNTRL_CPL	0x00001000
+#define CNTRL_LBM	0x00002000
+#define CNTRL_R		0x00004000
+
+#define CX25840_IR_TXCLK_REG	0x204
+#define TXCLK_TCD	0x0000FFFF
+
+#define CX25840_IR_RXCLK_REG	0x208
+#define RXCLK_RCD	0x0000FFFF
+
+#define CX25840_IR_CDUTY_REG	0x20C
+#define CDUTY_CDC	0x0000000F
+
+#define CX25840_IR_STATS_REG	0x210
+#define STATS_RTO	0x00000001
+#define STATS_ROR	0x00000002
+#define STATS_RBY	0x00000004
+#define STATS_TBY	0x00000008
+#define STATS_RSR	0x00000010
+#define STATS_TSR	0x00000020
+
+#define CX25840_IR_IRQEN_REG	0x214
+#define IRQEN_RTE	0x00000001
+#define IRQEN_ROE	0x00000002
+#define IRQEN_RSE	0x00000010
+#define IRQEN_TSE	0x00000020
+#define IRQEN_MSK	0x00000033
+
+#define CX25840_IR_FILTR_REG	0x218
+#define FILTR_LPF	0x0000FFFF
+
+#define CX25840_IR_FIFO_REG	0x23C
+#define FIFO_RXTX	0x0000FFFF
+#define FIFO_RXTX_LVL	0x00010000
+#define FIFO_RXTX_RTO	0x0001FFFF
+#define FIFO_RX_NDV	0x00020000
+#define FIFO_RX_DEPTH	8
+#define FIFO_TX_DEPTH	8
+
+#define CX25840_VIDCLK_FREQ	108000000 /* 108 MHz, BT.656 */
+#define CX25840_IR_REFCLK_FREQ	(CX25840_VIDCLK_FREQ / 2)
+
+#define CX25840_IR_RX_KFIFO_SIZE	(512 * sizeof(u32))
+#define CX25840_IR_TX_KFIFO_SIZE	(512 * sizeof(u32))
+
+struct cx25840_ir_state {
+	struct i2c_client *c;
+
+	struct v4l2_subdev_ir_parameters rx_params;
+	struct mutex rx_params_lock; /* protects Rx parameter settings cache */
+	atomic_t rxclk_divider;
+	atomic_t rx_invert;
+
+	struct kfifo rx_kfifo;
+	spinlock_t rx_kfifo_lock; /* protect Rx data kfifo */
+
+	struct v4l2_subdev_ir_parameters tx_params;
+	struct mutex tx_params_lock; /* protects Tx parameter settings cache */
+	atomic_t txclk_divider;
+};
+
+static inline struct cx25840_ir_state *to_ir_state(struct v4l2_subdev *sd)
+{
+	struct cx25840_state *state = to_state(sd);
+	return state ? state->ir_state : NULL;
+}
+
+
+/*
+ * Rx and Tx Clock Divider register computations
+ *
+ * Note the largest clock divider value of 0xffff corresponds to:
+ * 	(0xffff + 1) * 1000 / 108/2 MHz = 1,213,629.629... ns
+ * which fits in 21 bits, so we'll use unsigned int for time arguments.
+ */
+static inline u16 count_to_clock_divider(unsigned int d)
+{
+	if (d > RXCLK_RCD + 1)
+		d = RXCLK_RCD;
+	else if (d < 2)
+		d = 1;
+	else
+		d--;
+	return (u16) d;
+}
+
+static inline u16 ns_to_clock_divider(unsigned int ns)
+{
+	return count_to_clock_divider(
+		DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ / 1000000 * ns, 1000));
+}
+
+static inline unsigned int clock_divider_to_ns(unsigned int divider)
+{
+	/* Period of the Rx or Tx clock in ns */
+	return DIV_ROUND_CLOSEST((divider + 1) * 1000,
+				 CX25840_IR_REFCLK_FREQ / 1000000);
+}
+
+static inline u16 carrier_freq_to_clock_divider(unsigned int freq)
+{
+	return count_to_clock_divider(
+			  DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ, freq * 16));
+}
+
+static inline unsigned int clock_divider_to_carrier_freq(unsigned int divider)
+{
+	return DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ, (divider + 1) * 16);
+}
+
+static inline u16 freq_to_clock_divider(unsigned int freq,
+					unsigned int rollovers)
+{
+	return count_to_clock_divider(
+		   DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ, freq * rollovers));
+}
+
+static inline unsigned int clock_divider_to_freq(unsigned int divider,
+						 unsigned int rollovers)
+{
+	return DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ,
+				 (divider + 1) * rollovers);
+}
+
+/*
+ * Low Pass Filter register calculations
+ *
+ * Note the largest count value of 0xffff corresponds to:
+ * 	0xffff * 1000 / 108/2 MHz = 1,213,611.11... ns
+ * which fits in 21 bits, so we'll use unsigned int for time arguments.
+ */
+static inline u16 count_to_lpf_count(unsigned int d)
+{
+	if (d > FILTR_LPF)
+		d = FILTR_LPF;
+	else if (d < 4)
+		d = 0;
+	return (u16) d;
+}
+
+static inline u16 ns_to_lpf_count(unsigned int ns)
+{
+	return count_to_lpf_count(
+		DIV_ROUND_CLOSEST(CX25840_IR_REFCLK_FREQ / 1000000 * ns, 1000));
+}
+
+static inline unsigned int lpf_count_to_ns(unsigned int count)
+{
+	/* Duration of the Low Pass Filter rejection window in ns */
+	return DIV_ROUND_CLOSEST(count * 1000,
+				 CX25840_IR_REFCLK_FREQ / 1000000);
+}
+
+static inline unsigned int lpf_count_to_us(unsigned int count)
+{
+	/* Duration of the Low Pass Filter rejection window in us */
+	return DIV_ROUND_CLOSEST(count, CX25840_IR_REFCLK_FREQ / 1000000);
+}
+
+/*
+ * FIFO register pulse width count compuations
+ */
+static u32 clock_divider_to_resolution(u16 divider)
+{
+	/*
+	 * Resolution is the duration of 1 tick of the readable portion of
+	 * of the pulse width counter as read from the FIFO.  The two lsb's are
+	 * not readable, hence the << 2.  This function returns ns.
+	 */
+	return DIV_ROUND_CLOSEST((1 << 2)  * ((u32) divider + 1) * 1000,
+				 CX25840_IR_REFCLK_FREQ / 1000000);
+}
+
+static u64 pulse_width_count_to_ns(u16 count, u16 divider)
+{
+	u64 n;
+	u32 rem;
+
+	/*
+	 * The 2 lsb's of the pulse width timer count are not readable, hence
+	 * the (count << 2) | 0x3
+	 */
+	n = (((u64) count << 2) | 0x3) * (divider + 1) * 1000; /* millicycles */
+	rem = do_div(n, CX25840_IR_REFCLK_FREQ / 1000000);     /* / MHz => ns */
+	if (rem >= CX25840_IR_REFCLK_FREQ / 1000000 / 2)
+		n++;
+	return n;
+}
+
+#if 0
+/* Keep as we will need this for Transmit functionality */
+static u16 ns_to_pulse_width_count(u32 ns, u16 divider)
+{
+	u64 n;
+	u32 d;
+	u32 rem;
+
+	/*
+	 * The 2 lsb's of the pulse width timer count are not accessable, hence
+	 * the (1 << 2)
+	 */
+	n = ((u64) ns) * CX25840_IR_REFCLK_FREQ / 1000000; /* millicycles */
+	d = (1 << 2) * ((u32) divider + 1) * 1000; /* millicycles/count */
+	rem = do_div(n, d);
+	if (rem >= d / 2)
+		n++;
+
+	if (n > FIFO_RXTX)
+		n = FIFO_RXTX;
+	else if (n == 0)
+		n = 1;
+	return (u16) n;
+}
+
+#endif
+static unsigned int pulse_width_count_to_us(u16 count, u16 divider)
+{
+	u64 n;
+	u32 rem;
+
+	/*
+	 * The 2 lsb's of the pulse width timer count are not readable, hence
+	 * the (count << 2) | 0x3
+	 */
+	n = (((u64) count << 2) | 0x3) * (divider + 1);    /* cycles      */
+	rem = do_div(n, CX25840_IR_REFCLK_FREQ / 1000000); /* / MHz => us */
+	if (rem >= CX25840_IR_REFCLK_FREQ / 1000000 / 2)
+		n++;
+	return (unsigned int) n;
+}
+
+/*
+ * Pulse Clocks computations: Combined Pulse Width Count & Rx Clock Counts
+ *
+ * The total pulse clock count is an 18 bit pulse width timer count as the most
+ * significant part and (up to) 16 bit clock divider count as a modulus.
+ * When the Rx clock divider ticks down to 0, it increments the 18 bit pulse
+ * width timer count's least significant bit.
+ */
+static u64 ns_to_pulse_clocks(u32 ns)
+{
+	u64 clocks;
+	u32 rem;
+	clocks = CX25840_IR_REFCLK_FREQ / 1000000 * (u64) ns; /* millicycles  */
+	rem = do_div(clocks, 1000);                         /* /1000 = cycles */
+	if (rem >= 1000 / 2)
+		clocks++;
+	return clocks;
+}
+
+static u16 pulse_clocks_to_clock_divider(u64 count)
+{
+	u32 rem;
+
+	rem = do_div(count, (FIFO_RXTX << 2) | 0x3);
+
+	/* net result needs to be rounded down and decremented by 1 */
+	if (count > RXCLK_RCD + 1)
+		count = RXCLK_RCD;
+	else if (count < 2)
+		count = 1;
+	else
+		count--;
+	return (u16) count;
+}
+
+/*
+ * IR Control Register helpers
+ */
+enum tx_fifo_watermark {
+	TX_FIFO_HALF_EMPTY = 0,
+	TX_FIFO_EMPTY      = CNTRL_TIC,
+};
+
+enum rx_fifo_watermark {
+	RX_FIFO_HALF_FULL = 0,
+	RX_FIFO_NOT_EMPTY = CNTRL_RIC,
+};
+
+static inline void control_tx_irq_watermark(struct i2c_client *c,
+					    enum tx_fifo_watermark level)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_TIC, level);
+}
+
+static inline void control_rx_irq_watermark(struct i2c_client *c,
+					    enum rx_fifo_watermark level)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_RIC, level);
+}
+
+static inline void control_tx_enable(struct i2c_client *c, bool enable)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~(CNTRL_TXE | CNTRL_TFE),
+			enable ? (CNTRL_TXE | CNTRL_TFE) : 0);
+}
+
+static inline void control_rx_enable(struct i2c_client *c, bool enable)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~(CNTRL_RXE | CNTRL_RFE),
+			enable ? (CNTRL_RXE | CNTRL_RFE) : 0);
+}
+
+static inline void control_tx_modulation_enable(struct i2c_client *c,
+						bool enable)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_MOD,
+			enable ? CNTRL_MOD : 0);
+}
+
+static inline void control_rx_demodulation_enable(struct i2c_client *c,
+						  bool enable)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_DMD,
+			enable ? CNTRL_DMD : 0);
+}
+
+static inline void control_rx_s_edge_detection(struct i2c_client *c,
+					       u32 edge_types)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_EDG_BOTH,
+			edge_types & CNTRL_EDG_BOTH);
+}
+
+static void control_rx_s_carrier_window(struct i2c_client *c,
+					unsigned int carrier,
+					unsigned int *carrier_range_low,
+					unsigned int *carrier_range_high)
+{
+	u32 v;
+	unsigned int c16 = carrier * 16;
+
+	if (*carrier_range_low < DIV_ROUND_CLOSEST(c16, 16 + 3)) {
+		v = CNTRL_WIN_3_4;
+		*carrier_range_low = DIV_ROUND_CLOSEST(c16, 16 + 4);
+	} else {
+		v = CNTRL_WIN_3_3;
+		*carrier_range_low = DIV_ROUND_CLOSEST(c16, 16 + 3);
+	}
+
+	if (*carrier_range_high > DIV_ROUND_CLOSEST(c16, 16 - 3)) {
+		v |= CNTRL_WIN_4_3;
+		*carrier_range_high = DIV_ROUND_CLOSEST(c16, 16 - 4);
+	} else {
+		v |= CNTRL_WIN_3_3;
+		*carrier_range_high = DIV_ROUND_CLOSEST(c16, 16 - 3);
+	}
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_WIN, v);
+}
+
+static inline void control_tx_polarity_invert(struct i2c_client *c,
+					      bool invert)
+{
+	cx25840_and_or4(c, CX25840_IR_CNTRL_REG, ~CNTRL_CPL,
+			invert ? CNTRL_CPL : 0);
+}
+
+/*
+ * IR Rx & Tx Clock Register helpers
+ */
+static unsigned int txclk_tx_s_carrier(struct i2c_client *c,
+				       unsigned int freq,
+				       u16 *divider)
+{
+	*divider = carrier_freq_to_clock_divider(freq);
+	cx25840_write4(c, CX25840_IR_TXCLK_REG, *divider);
+	return clock_divider_to_carrier_freq(*divider);
+}
+
+static unsigned int rxclk_rx_s_carrier(struct i2c_client *c,
+				       unsigned int freq,
+				       u16 *divider)
+{
+	*divider = carrier_freq_to_clock_divider(freq);
+	cx25840_write4(c, CX25840_IR_RXCLK_REG, *divider);
+	return clock_divider_to_carrier_freq(*divider);
+}
+
+static u32 txclk_tx_s_max_pulse_width(struct i2c_client *c, u32 ns,
+				      u16 *divider)
+{
+	u64 pulse_clocks;
+
+	if (ns > V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS)
+		ns = V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS;
+	pulse_clocks = ns_to_pulse_clocks(ns);
+	*divider = pulse_clocks_to_clock_divider(pulse_clocks);
+	cx25840_write4(c, CX25840_IR_TXCLK_REG, *divider);
+	return (u32) pulse_width_count_to_ns(FIFO_RXTX, *divider);
+}
+
+static u32 rxclk_rx_s_max_pulse_width(struct i2c_client *c, u32 ns,
+				      u16 *divider)
+{
+	u64 pulse_clocks;
+
+	if (ns > V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS)
+		ns = V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS;
+	pulse_clocks = ns_to_pulse_clocks(ns);
+	*divider = pulse_clocks_to_clock_divider(pulse_clocks);
+	cx25840_write4(c, CX25840_IR_RXCLK_REG, *divider);
+	return (u32) pulse_width_count_to_ns(FIFO_RXTX, *divider);
+}
+
+/*
+ * IR Tx Carrier Duty Cycle register helpers
+ */
+static unsigned int cduty_tx_s_duty_cycle(struct i2c_client *c,
+					  unsigned int duty_cycle)
+{
+	u32 n;
+	n = DIV_ROUND_CLOSEST(duty_cycle * 100, 625); /* 16ths of 100% */
+	if (n != 0)
+		n--;
+	if (n > 15)
+		n = 15;
+	cx25840_write4(c, CX25840_IR_CDUTY_REG, n);
+	return DIV_ROUND_CLOSEST((n + 1) * 100, 16);
+}
+
+/*
+ * IR Filter Register helpers
+ */
+static u32 filter_rx_s_min_width(struct i2c_client *c, u32 min_width_ns)
+{
+	u32 count = ns_to_lpf_count(min_width_ns);
+	cx25840_write4(c, CX25840_IR_FILTR_REG, count);
+	return lpf_count_to_ns(count);
+}
+
+/*
+ * IR IRQ Enable Register helpers
+ */
+static inline void irqenable_rx(struct v4l2_subdev *sd, u32 mask)
+{
+	struct cx25840_state *state = to_state(sd);
+
+	if (is_cx23885(state) || is_cx23887(state))
+		mask ^= IRQEN_MSK;
+	mask &= (IRQEN_RTE | IRQEN_ROE | IRQEN_RSE);
+	cx25840_and_or4(state->c, CX25840_IR_IRQEN_REG,
+			~(IRQEN_RTE | IRQEN_ROE | IRQEN_RSE), mask);
+}
+
+static inline void irqenable_tx(struct v4l2_subdev *sd, u32 mask)
+{
+	struct cx25840_state *state = to_state(sd);
+
+	if (is_cx23885(state) || is_cx23887(state))
+		mask ^= IRQEN_MSK;
+	mask &= IRQEN_TSE;
+	cx25840_and_or4(state->c, CX25840_IR_IRQEN_REG, ~IRQEN_TSE, mask);
+}
+
+/*
+ * V4L2 Subdevice IR Ops
+ */
+int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c = NULL;
+	unsigned long flags;
+
+	u32 rx_data[FIFO_RX_DEPTH];
+	int i, j, k;
+	u32 events, v;
+	int tsr, rsr, rto, ror, tse, rse, rte, roe, kror;
+	u32 cntrl, irqen, stats;
+
+	*handled = false;
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	c = ir_state->c;
+
+	/* Only support the IR controller for the CX2388[57] AV Core for now */
+	if (!(is_cx23885(state) || is_cx23887(state)))
+		return -ENODEV;
+
+	cntrl = cx25840_read4(c, CX25840_IR_CNTRL_REG);
+	irqen = cx25840_read4(c, CX25840_IR_IRQEN_REG);
+	if (is_cx23885(state) || is_cx23887(state))
+		irqen ^= IRQEN_MSK;
+	stats = cx25840_read4(c, CX25840_IR_STATS_REG);
+
+	tsr = stats & STATS_TSR; /* Tx FIFO Service Request */
+	rsr = stats & STATS_RSR; /* Rx FIFO Service Request */
+	rto = stats & STATS_RTO; /* Rx Pulse Width Timer Time Out */
+	ror = stats & STATS_ROR; /* Rx FIFO Over Run */
+
+	tse = irqen & IRQEN_TSE; /* Tx FIFO Service Request IRQ Enable */
+	rse = irqen & IRQEN_RSE; /* Rx FIFO Service Reuqest IRQ Enable */
+	rte = irqen & IRQEN_RTE; /* Rx Pulse Width Timer Time Out IRQ Enable */
+	roe = irqen & IRQEN_ROE; /* Rx FIFO Over Run IRQ Enable */
+
+	v4l2_dbg(2, ir_debug, sd, "IR IRQ Status:  %s %s %s %s %s %s\n",
+		 tsr ? "tsr" : "   ", rsr ? "rsr" : "   ",
+		 rto ? "rto" : "   ", ror ? "ror" : "   ",
+		 stats & STATS_TBY ? "tby" : "   ",
+		 stats & STATS_RBY ? "rby" : "   ");
+
+	v4l2_dbg(2, ir_debug, sd, "IR IRQ Enables: %s %s %s %s\n",
+		 tse ? "tse" : "   ", rse ? "rse" : "   ",
+		 rte ? "rte" : "   ", roe ? "roe" : "   ");
+
+	/*
+	 * Transmitter interrupt service
+	 */
+	if (tse && tsr) {
+		/*
+		 * TODO:
+		 * Check the watermark threshold setting
+		 * Pull FIFO_TX_DEPTH or FIFO_TX_DEPTH/2 entries from tx_kfifo
+		 * Push the data to the hardware FIFO.
+		 * If there was nothing more to send in the tx_kfifo, disable
+		 *	the TSR IRQ and notify the v4l2_device.
+		 * If there was something in the tx_kfifo, check the tx_kfifo
+		 *      level and notify the v4l2_device, if it is low.
+		 */
+		/* For now, inhibit TSR interrupt until Tx is implemented */
+		irqenable_tx(sd, 0);
+		events = V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ;
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_TX_NOTIFY, &events);
+		*handled = true;
+	}
+
+	/*
+	 * Receiver interrupt service
+	 */
+	kror = 0;
+	if ((rse && rsr) || (rte && rto)) {
+		/*
+		 * Receive data on RSR to clear the STATS_RSR.
+		 * Receive data on RTO, since we may not have yet hit the RSR
+		 * watermark when we receive the RTO.
+		 */
+		for (i = 0, v = FIFO_RX_NDV;
+		     (v & FIFO_RX_NDV) && !kror; i = 0) {
+			for (j = 0;
+			     (v & FIFO_RX_NDV) && j < FIFO_RX_DEPTH; j++) {
+				v = cx25840_read4(c, CX25840_IR_FIFO_REG);
+				rx_data[i++] = v & ~FIFO_RX_NDV;
+			}
+			if (i == 0)
+				break;
+			j = i * sizeof(u32);
+			k = kfifo_in_locked(&ir_state->rx_kfifo,
+					    (unsigned char *) rx_data, j,
+					    &ir_state->rx_kfifo_lock);
+			if (k != j)
+				kror++; /* rx_kfifo over run */
+		}
+		*handled = true;
+	}
+
+	events = 0;
+	v = 0;
+	if (kror) {
+		events |= V4L2_SUBDEV_IR_RX_SW_FIFO_OVERRUN;
+		v4l2_err(sd, "IR receiver software FIFO overrun\n");
+	}
+	if (roe && ror) {
+		/*
+		 * The RX FIFO Enable (CNTRL_RFE) must be toggled to clear
+		 * the Rx FIFO Over Run status (STATS_ROR)
+		 */
+		v |= CNTRL_RFE;
+		events |= V4L2_SUBDEV_IR_RX_HW_FIFO_OVERRUN;
+		v4l2_err(sd, "IR receiver hardware FIFO overrun\n");
+	}
+	if (rte && rto) {
+		/*
+		 * The IR Receiver Enable (CNTRL_RXE) must be toggled to clear
+		 * the Rx Pulse Width Timer Time Out (STATS_RTO)
+		 */
+		v |= CNTRL_RXE;
+		events |= V4L2_SUBDEV_IR_RX_END_OF_RX_DETECTED;
+	}
+	if (v) {
+		/* Clear STATS_ROR & STATS_RTO as needed by reseting hardware */
+		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl & ~v);
+		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl);
+		*handled = true;
+	}
+	spin_lock_irqsave(&ir_state->rx_kfifo_lock, flags);
+	if (kfifo_len(&ir_state->rx_kfifo) >= CX25840_IR_RX_KFIFO_SIZE / 2)
+		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
+	spin_unlock_irqrestore(&ir_state->rx_kfifo_lock, flags);
+
+	if (events)
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
+	return 0;
+}
+
+/* Receiver */
+static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
+			      ssize_t *num)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	bool invert;
+	u16 divider;
+	unsigned int i, n;
+	u32 *p;
+	u32 u, v;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	invert = (bool) atomic_read(&ir_state->rx_invert);
+	divider = (u16) atomic_read(&ir_state->rxclk_divider);
+
+	n = count / sizeof(u32) * sizeof(u32);
+	if (n == 0) {
+		*num = 0;
+		return 0;
+	}
+
+	n = kfifo_out_locked(&ir_state->rx_kfifo, buf, n,
+			     &ir_state->rx_kfifo_lock);
+
+	n /= sizeof(u32);
+	*num = n * sizeof(u32);
+
+	for (p = (u32 *) buf, i = 0; i < n; p++, i++) {
+		if ((*p & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
+			*p = V4L2_SUBDEV_IR_PULSE_RX_SEQ_END;
+			v4l2_dbg(2, ir_debug, sd, "rx read: end of rx\n");
+			continue;
+		}
+
+		u = (*p & FIFO_RXTX_LVL) ? V4L2_SUBDEV_IR_PULSE_LEVEL_MASK : 0;
+		if (invert)
+			u = u ? 0 : V4L2_SUBDEV_IR_PULSE_LEVEL_MASK;
+
+		v = (u32) pulse_width_count_to_ns((u16) (*p & FIFO_RXTX),
+						  divider);
+		if (v >= V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS)
+			v = V4L2_SUBDEV_IR_PULSE_MAX_WIDTH_NS - 1;
+
+		*p = u | v;
+
+		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s\n",
+			 v, u ? "mark" : "space");
+	}
+	return 0;
+}
+
+static int cx25840_ir_rx_g_parameters(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_ir_parameters *p)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	mutex_lock(&ir_state->rx_params_lock);
+	memcpy(p, &ir_state->rx_params,
+				      sizeof(struct v4l2_subdev_ir_parameters));
+	mutex_unlock(&ir_state->rx_params_lock);
+	return 0;
+}
+
+static int cx25840_ir_rx_shutdown(struct v4l2_subdev *sd)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	c = ir_state->c;
+	mutex_lock(&ir_state->rx_params_lock);
+
+	/* Disable or slow down all IR Rx circuits and counters */
+	irqenable_rx(sd, 0);
+	control_rx_enable(c, false);
+	control_rx_demodulation_enable(c, false);
+	control_rx_s_edge_detection(c, CNTRL_EDG_NONE);
+	filter_rx_s_min_width(c, 0);
+	cx25840_write4(c, CX25840_IR_RXCLK_REG, RXCLK_RCD);
+
+	ir_state->rx_params.shutdown = true;
+
+	mutex_unlock(&ir_state->rx_params_lock);
+	return 0;
+}
+
+static int cx25840_ir_rx_s_parameters(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_ir_parameters *p)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c;
+	struct v4l2_subdev_ir_parameters *o;
+	u16 rxclk_divider;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	if (p->shutdown)
+		return cx25840_ir_rx_shutdown(sd);
+
+	if (p->mode != V4L2_SUBDEV_IR_MODE_PULSE_WIDTH)
+		return -ENOSYS;
+
+	c = ir_state->c;
+	o = &ir_state->rx_params;
+
+	mutex_lock(&ir_state->rx_params_lock);
+
+	o->shutdown = p->shutdown;
+
+	p->mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH;
+	o->mode = p->mode;
+
+	p->bytes_per_data_element = sizeof(u32);
+	o->bytes_per_data_element = p->bytes_per_data_element;
+
+	/* Before we tweak the hardware, we have to disable the receiver */
+	irqenable_rx(sd, 0);
+	control_rx_enable(c, false);
+
+	control_rx_demodulation_enable(c, p->modulation);
+	o->modulation = p->modulation;
+
+	if (p->modulation) {
+		p->carrier_freq = rxclk_rx_s_carrier(c, p->carrier_freq,
+						     &rxclk_divider);
+
+		o->carrier_freq = p->carrier_freq;
+
+		p->duty_cycle = 50;
+		o->duty_cycle = p->duty_cycle;
+
+		control_rx_s_carrier_window(c, p->carrier_freq,
+					    &p->carrier_range_lower,
+					    &p->carrier_range_upper);
+		o->carrier_range_lower = p->carrier_range_lower;
+		o->carrier_range_upper = p->carrier_range_upper;
+	} else {
+		p->max_pulse_width =
+			    rxclk_rx_s_max_pulse_width(c, p->max_pulse_width,
+						       &rxclk_divider);
+		o->max_pulse_width = p->max_pulse_width;
+	}
+	atomic_set(&ir_state->rxclk_divider, rxclk_divider);
+
+	p->noise_filter_min_width =
+			    filter_rx_s_min_width(c, p->noise_filter_min_width);
+	o->noise_filter_min_width = p->noise_filter_min_width;
+
+	p->resolution = clock_divider_to_resolution(rxclk_divider);
+	o->resolution = p->resolution;
+
+	/* FIXME - make this dependent on resolution for better performance */
+	control_rx_irq_watermark(c, RX_FIFO_HALF_FULL);
+
+	control_rx_s_edge_detection(c, CNTRL_EDG_BOTH);
+
+	o->invert_level = p->invert_level;
+	atomic_set(&ir_state->rx_invert, p->invert_level);
+
+	o->interrupt_enable = p->interrupt_enable;
+	o->enable = p->enable;
+	if (p->enable) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ir_state->rx_kfifo_lock, flags);
+		kfifo_reset(&ir_state->rx_kfifo);
+		spin_unlock_irqrestore(&ir_state->rx_kfifo_lock, flags);
+		if (p->interrupt_enable)
+			irqenable_rx(sd, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
+		control_rx_enable(c, p->enable);
+	}
+
+	mutex_unlock(&ir_state->rx_params_lock);
+	return 0;
+}
+
+/* Transmitter */
+static int cx25840_ir_tx_write(struct v4l2_subdev *sd, u8 *buf, size_t count,
+			       ssize_t *num)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	c = ir_state->c;
+#if 0
+	/*
+	 * FIXME - the code below is an incomplete and untested sketch of what
+	 * may need to be done.  The critical part is to get 4 (or 8) pulses
+	 * from the tx_kfifo, or converted from ns to the proper units from the
+	 * input, and push them off to the hardware Tx FIFO right away, if the
+	 * HW TX fifo needs service.  The rest can be pushed to the tx_kfifo in
+	 * a less critical timeframe.  Also watch out for overruning the
+	 * tx_kfifo - don't let it happen and let the caller know not all his
+	 * pulses were written.
+	 */
+	u32 *ns_pulse = (u32 *) buf;
+	unsigned int n;
+	u32 fifo_pulse[FIFO_TX_DEPTH];
+	u32 mark;
+
+	/* Compute how much we can fit in the tx kfifo */
+	n = CX25840_IR_TX_KFIFO_SIZE - kfifo_len(ir_state->tx_kfifo);
+	n = min(n, (unsigned int) count);
+	n /= sizeof(u32);
+
+	/* FIXME - turn on Tx Fifo service interrupt
+	 * check hardware fifo level, and other stuff
+	 */
+	for (i = 0; i < n; ) {
+		for (j = 0; j < FIFO_TX_DEPTH / 2 && i < n; j++) {
+			mark = ns_pulse[i] & V4L2_SUBDEV_IR_PULSE_LEVEL_MASK;
+			fifo_pulse[j] = ns_to_pulse_width_count(
+					 ns_pulse[i] &
+					       ~V4L2_SUBDEV_IR_PULSE_LEVEL_MASK,
+					 ir_state->txclk_divider);
+			if (mark)
+				fifo_pulse[j] &= FIFO_RXTX_LVL;
+			i++;
+		}
+		kfifo_put(ir_state->tx_kfifo, (u8 *) fifo_pulse,
+							       j * sizeof(u32));
+	}
+	*num = n * sizeof(u32);
+#else
+	/* For now enable the Tx FIFO Service interrupt & pretend we did work */
+	irqenable_tx(sd, IRQEN_TSE);
+	*num = count;
+#endif
+	return 0;
+}
+
+static int cx25840_ir_tx_g_parameters(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_ir_parameters *p)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	mutex_lock(&ir_state->tx_params_lock);
+	memcpy(p, &ir_state->tx_params,
+				      sizeof(struct v4l2_subdev_ir_parameters));
+	mutex_unlock(&ir_state->tx_params_lock);
+	return 0;
+}
+
+static int cx25840_ir_tx_shutdown(struct v4l2_subdev *sd)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	c = ir_state->c;
+	mutex_lock(&ir_state->tx_params_lock);
+
+	/* Disable or slow down all IR Tx circuits and counters */
+	irqenable_tx(sd, 0);
+	control_tx_enable(c, false);
+	control_tx_modulation_enable(c, false);
+	cx25840_write4(c, CX25840_IR_TXCLK_REG, TXCLK_TCD);
+
+	ir_state->tx_params.shutdown = true;
+
+	mutex_unlock(&ir_state->tx_params_lock);
+	return 0;
+}
+
+static int cx25840_ir_tx_s_parameters(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_ir_parameters *p)
+{
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+	struct i2c_client *c;
+	struct v4l2_subdev_ir_parameters *o;
+	u16 txclk_divider;
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	if (p->shutdown)
+		return cx25840_ir_tx_shutdown(sd);
+
+	if (p->mode != V4L2_SUBDEV_IR_MODE_PULSE_WIDTH)
+		return -ENOSYS;
+
+	c = ir_state->c;
+	o = &ir_state->tx_params;
+	mutex_lock(&ir_state->tx_params_lock);
+
+	o->shutdown = p->shutdown;
+
+	p->mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH;
+	o->mode = p->mode;
+
+	p->bytes_per_data_element = sizeof(u32);
+	o->bytes_per_data_element = p->bytes_per_data_element;
+
+	/* Before we tweak the hardware, we have to disable the transmitter */
+	irqenable_tx(sd, 0);
+	control_tx_enable(c, false);
+
+	control_tx_modulation_enable(c, p->modulation);
+	o->modulation = p->modulation;
+
+	if (p->modulation) {
+		p->carrier_freq = txclk_tx_s_carrier(c, p->carrier_freq,
+						     &txclk_divider);
+		o->carrier_freq = p->carrier_freq;
+
+		p->duty_cycle = cduty_tx_s_duty_cycle(c, p->duty_cycle);
+		o->duty_cycle = p->duty_cycle;
+	} else {
+		p->max_pulse_width =
+			    txclk_tx_s_max_pulse_width(c, p->max_pulse_width,
+						       &txclk_divider);
+		o->max_pulse_width = p->max_pulse_width;
+	}
+	atomic_set(&ir_state->txclk_divider, txclk_divider);
+
+	p->resolution = clock_divider_to_resolution(txclk_divider);
+	o->resolution = p->resolution;
+
+	/* FIXME - make this dependent on resolution for better performance */
+	control_tx_irq_watermark(c, TX_FIFO_HALF_EMPTY);
+
+	control_tx_polarity_invert(c, p->invert_carrier_sense);
+	o->invert_carrier_sense = p->invert_carrier_sense;
+
+	/*
+	 * FIXME: we don't have hardware help for IO pin level inversion
+	 * here like we have on the CX23888.
+	 * Act on this with some mix of logical inversion of data levels,
+	 * carrier polarity, and carrier duty cycle.
+	 */
+	o->invert_level = p->invert_level;
+
+	o->interrupt_enable = p->interrupt_enable;
+	o->enable = p->enable;
+	if (p->enable) {
+		/* reset tx_fifo here */
+		if (p->interrupt_enable)
+			irqenable_tx(sd, IRQEN_TSE);
+		control_tx_enable(c, p->enable);
+	}
+
+	mutex_unlock(&ir_state->tx_params_lock);
+	return 0;
+}
+
+
+/*
+ * V4L2 Subdevice Core Ops support
+ */
+int cx25840_ir_log_status(struct v4l2_subdev *sd)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct i2c_client *c = state->c;
+	char *s;
+	int i, j;
+	u32 cntrl, txclk, rxclk, cduty, stats, irqen, filtr;
+
+	/* The CX23888 chip doesn't have an IR controller on the A/V core */
+	if (is_cx23888(state))
+		return 0;
+
+	cntrl = cx25840_read4(c, CX25840_IR_CNTRL_REG);
+	txclk = cx25840_read4(c, CX25840_IR_TXCLK_REG) & TXCLK_TCD;
+	rxclk = cx25840_read4(c, CX25840_IR_RXCLK_REG) & RXCLK_RCD;
+	cduty = cx25840_read4(c, CX25840_IR_CDUTY_REG) & CDUTY_CDC;
+	stats = cx25840_read4(c, CX25840_IR_STATS_REG);
+	irqen = cx25840_read4(c, CX25840_IR_IRQEN_REG);
+	if (is_cx23885(state) || is_cx23887(state))
+		irqen ^= IRQEN_MSK;
+	filtr = cx25840_read4(c, CX25840_IR_FILTR_REG) & FILTR_LPF;
+
+	v4l2_info(sd, "IR Receiver:\n");
+	v4l2_info(sd, "\tEnabled:                           %s\n",
+		  cntrl & CNTRL_RXE ? "yes" : "no");
+	v4l2_info(sd, "\tDemodulation from a carrier:       %s\n",
+		  cntrl & CNTRL_DMD ? "enabled" : "disabled");
+	v4l2_info(sd, "\tFIFO:                              %s\n",
+		  cntrl & CNTRL_RFE ? "enabled" : "disabled");
+	switch (cntrl & CNTRL_EDG) {
+	case CNTRL_EDG_NONE:
+		s = "disabled";
+		break;
+	case CNTRL_EDG_FALL:
+		s = "falling edge";
+		break;
+	case CNTRL_EDG_RISE:
+		s = "rising edge";
+		break;
+	case CNTRL_EDG_BOTH:
+		s = "rising & falling edges";
+		break;
+	default:
+		s = "??? edge";
+		break;
+	}
+	v4l2_info(sd, "\tPulse timers' start/stop trigger:  %s\n", s);
+	v4l2_info(sd, "\tFIFO data on pulse timer overflow: %s\n",
+		  cntrl & CNTRL_R ? "not loaded" : "overflow marker");
+	v4l2_info(sd, "\tFIFO interrupt watermark:          %s\n",
+		  cntrl & CNTRL_RIC ? "not empty" : "half full or greater");
+	v4l2_info(sd, "\tLoopback mode:                     %s\n",
+		  cntrl & CNTRL_LBM ? "loopback active" : "normal receive");
+	if (cntrl & CNTRL_DMD) {
+		v4l2_info(sd, "\tExpected carrier (16 clocks):      %u Hz\n",
+			  clock_divider_to_carrier_freq(rxclk));
+		switch (cntrl & CNTRL_WIN) {
+		case CNTRL_WIN_3_3:
+			i = 3;
+			j = 3;
+			break;
+		case CNTRL_WIN_4_3:
+			i = 4;
+			j = 3;
+			break;
+		case CNTRL_WIN_3_4:
+			i = 3;
+			j = 4;
+			break;
+		case CNTRL_WIN_4_4:
+			i = 4;
+			j = 4;
+			break;
+		default:
+			i = 0;
+			j = 0;
+			break;
+		}
+		v4l2_info(sd, "\tNext carrier edge window:          16 clocks "
+			  "-%1d/+%1d, %u to %u Hz\n", i, j,
+			  clock_divider_to_freq(rxclk, 16 + j),
+			  clock_divider_to_freq(rxclk, 16 - i));
+	} else {
+		v4l2_info(sd, "\tMax measurable pulse width:        %u us, "
+			  "%llu ns\n",
+			  pulse_width_count_to_us(FIFO_RXTX, rxclk),
+			  pulse_width_count_to_ns(FIFO_RXTX, rxclk));
+	}
+	v4l2_info(sd, "\tLow pass filter:                   %s\n",
+		  filtr ? "enabled" : "disabled");
+	if (filtr)
+		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, "
+			  "%u ns\n",
+			  lpf_count_to_us(filtr),
+			  lpf_count_to_ns(filtr));
+	v4l2_info(sd, "\tPulse width timer timed-out:       %s\n",
+		  stats & STATS_RTO ? "yes" : "no");
+	v4l2_info(sd, "\tPulse width timer time-out intr:   %s\n",
+		  irqen & IRQEN_RTE ? "enabled" : "disabled");
+	v4l2_info(sd, "\tFIFO overrun:                      %s\n",
+		  stats & STATS_ROR ? "yes" : "no");
+	v4l2_info(sd, "\tFIFO overrun interrupt:            %s\n",
+		  irqen & IRQEN_ROE ? "enabled" : "disabled");
+	v4l2_info(sd, "\tBusy:                              %s\n",
+		  stats & STATS_RBY ? "yes" : "no");
+	v4l2_info(sd, "\tFIFO service requested:            %s\n",
+		  stats & STATS_RSR ? "yes" : "no");
+	v4l2_info(sd, "\tFIFO service request interrupt:    %s\n",
+		  irqen & IRQEN_RSE ? "enabled" : "disabled");
+
+	v4l2_info(sd, "IR Transmitter:\n");
+	v4l2_info(sd, "\tEnabled:                           %s\n",
+		  cntrl & CNTRL_TXE ? "yes" : "no");
+	v4l2_info(sd, "\tModulation onto a carrier:         %s\n",
+		  cntrl & CNTRL_MOD ? "enabled" : "disabled");
+	v4l2_info(sd, "\tFIFO:                              %s\n",
+		  cntrl & CNTRL_TFE ? "enabled" : "disabled");
+	v4l2_info(sd, "\tFIFO interrupt watermark:          %s\n",
+		  cntrl & CNTRL_TIC ? "not empty" : "half full or less");
+	v4l2_info(sd, "\tCarrier polarity:                  %s\n",
+		  cntrl & CNTRL_CPL ? "space:burst mark:noburst"
+				    : "space:noburst mark:burst");
+	if (cntrl & CNTRL_MOD) {
+		v4l2_info(sd, "\tCarrier (16 clocks):               %u Hz\n",
+			  clock_divider_to_carrier_freq(txclk));
+		v4l2_info(sd, "\tCarrier duty cycle:                %2u/16\n",
+			  cduty + 1);
+	} else {
+		v4l2_info(sd, "\tMax pulse width:                   %u us, "
+			  "%llu ns\n",
+			  pulse_width_count_to_us(FIFO_RXTX, txclk),
+			  pulse_width_count_to_ns(FIFO_RXTX, txclk));
+	}
+	v4l2_info(sd, "\tBusy:                              %s\n",
+		  stats & STATS_TBY ? "yes" : "no");
+	v4l2_info(sd, "\tFIFO service requested:            %s\n",
+		  stats & STATS_TSR ? "yes" : "no");
+	v4l2_info(sd, "\tFIFO service request interrupt:    %s\n",
+		  irqen & IRQEN_TSE ? "enabled" : "disabled");
+
+	return 0;
+}
+
+
+const struct v4l2_subdev_ir_ops cx25840_ir_ops = {
+	.rx_read = cx25840_ir_rx_read,
+	.rx_g_parameters = cx25840_ir_rx_g_parameters,
+	.rx_s_parameters = cx25840_ir_rx_s_parameters,
+
+	.tx_write = cx25840_ir_tx_write,
+	.tx_g_parameters = cx25840_ir_tx_g_parameters,
+	.tx_s_parameters = cx25840_ir_tx_s_parameters,
+};
+
+
+static const struct v4l2_subdev_ir_parameters default_rx_params = {
+	.bytes_per_data_element = sizeof(u32),
+	.mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH,
+
+	.enable = false,
+	.interrupt_enable = false,
+	.shutdown = true,
+
+	.modulation = true,
+	.carrier_freq = 36000, /* 36 kHz - RC-5, and RC-6 carrier */
+
+	/* RC-5: 666,667 ns = 1/36 kHz * 32 cycles * 1 mark * 0.75 */
+	/* RC-6: 333,333 ns = 1/36 kHz * 16 cycles * 1 mark * 0.75 */
+	.noise_filter_min_width = 333333, /* ns */
+	.carrier_range_lower = 35000,
+	.carrier_range_upper = 37000,
+	.invert_level = false,
+};
+
+static const struct v4l2_subdev_ir_parameters default_tx_params = {
+	.bytes_per_data_element = sizeof(u32),
+	.mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH,
+
+	.enable = false,
+	.interrupt_enable = false,
+	.shutdown = true,
+
+	.modulation = true,
+	.carrier_freq = 36000, /* 36 kHz - RC-5 carrier */
+	.duty_cycle = 25,      /* 25 %   - RC-5 carrier */
+	.invert_level = false,
+	.invert_carrier_sense = false,
+};
+
+int cx25840_ir_probe(struct v4l2_subdev *sd)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct cx25840_ir_state *ir_state;
+	struct v4l2_subdev_ir_parameters default_params;
+
+	/* Only init the IR controller for the CX2388[57] AV Core for now */
+	if (!(is_cx23885(state) || is_cx23887(state)))
+		return 0;
+
+	ir_state = kzalloc(sizeof(struct cx25840_ir_state), GFP_KERNEL);
+	if (ir_state == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&ir_state->rx_kfifo_lock);
+	if (kfifo_alloc(&ir_state->rx_kfifo,
+			CX25840_IR_RX_KFIFO_SIZE, GFP_KERNEL)) {
+		kfree(ir_state);
+		return -ENOMEM;
+	}
+
+	ir_state->c = state->c;
+	state->ir_state = ir_state;
+
+	/* Ensure no interrupts arrive yet */
+	if (is_cx23885(state) || is_cx23887(state))
+		cx25840_write4(ir_state->c, CX25840_IR_IRQEN_REG, IRQEN_MSK);
+	else
+		cx25840_write4(ir_state->c, CX25840_IR_IRQEN_REG, 0);
+
+	mutex_init(&ir_state->rx_params_lock);
+	memcpy(&default_params, &default_rx_params,
+		       sizeof(struct v4l2_subdev_ir_parameters));
+	v4l2_subdev_call(sd, ir, rx_s_parameters, &default_params);
+
+	mutex_init(&ir_state->tx_params_lock);
+	memcpy(&default_params, &default_tx_params,
+		       sizeof(struct v4l2_subdev_ir_parameters));
+	v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
+
+	return 0;
+}
+
+int cx25840_ir_remove(struct v4l2_subdev *sd)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct cx25840_ir_state *ir_state = to_ir_state(sd);
+
+	if (ir_state == NULL)
+		return -ENODEV;
+
+	cx25840_ir_rx_shutdown(sd);
+	cx25840_ir_tx_shutdown(sd);
+
+	kfifo_free(&ir_state->rx_kfifo);
+	kfree(ir_state);
+	state->ir_state = NULL;
+	return 0;
+}
-- 
1.7.1.1


