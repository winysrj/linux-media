Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:3550 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbHRIiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:38:55 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 11/15] cec: adv7604: add cec support.
Date: Tue, 18 Aug 2015 10:26:36 +0200
Message-Id: <1a6944da4ad65ef8ee014445c779245b02557898.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Add CEC support to the adv7604 driver.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: add missing methods cec/io_write_and_or]
[k.debski@samsung.com: change adv7604 to adv76xx in added functions]
[hansverk@cisco.com: use _clr_set instead of _and_or]
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 236 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 232 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5631ec0..20b0838 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -40,6 +40,7 @@
 #include <linux/regmap.h>
 
 #include <media/adv7604.h>
+#include <media/cec.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
@@ -80,6 +81,8 @@ MODULE_LICENSE("GPL");
 
 #define ADV76XX_OP_SWAP_CB_CR				(1 << 0)
 
+#define ADV76XX_MAX_ADDRS (3)
+
 enum adv76xx_type {
 	ADV7604,
 	ADV7611,
@@ -184,6 +187,10 @@ struct adv76xx_state {
 	u16 spa_port_a[2];
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
+	u8   cec_addr[ADV76XX_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
+
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool restart_stdi_once;
@@ -430,7 +437,8 @@ static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return regmap_write(state->regmap[ADV76XX_PAGE_IO], reg, val);
 }
 
-static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask,
+				   u8 val)
 {
 	return io_write(sd, reg, (io_read(sd, reg) & ~mask) | val);
 }
@@ -463,6 +471,12 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return regmap_write(state->regmap[ADV76XX_PAGE_CEC], reg, val);
 }
 
+static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask,
+				   u8 val)
+{
+	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
+}
+
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -550,8 +564,13 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 
 static void adv76xx_set_hpd(struct adv76xx_state *state, unsigned int hpd)
 {
+	u16 connected_inputs;
 	unsigned int i;
 
+	connected_inputs = hpd & state->info->read_cable_det(&state->sd);
+	v4l2_subdev_notify(&state->sd, V4L2_SUBDEV_CEC_CONN_INPUTS,
+			   &connected_inputs);
+
 	for (i = 0; i < state->info->num_dv_ports; ++i)
 		gpiod_set_value_cansleep(state->hpd_gpio[i], hpd & BIT(i));
 
@@ -891,9 +910,12 @@ static int adv76xx_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv76xx_state *state = to_state(sd);
 	const struct adv76xx_chip_info *info = state->info;
+	u16 cable_det = info->read_cable_det(sd);
+	u16 connected_inputs = state->edid.present & cable_det;
+
+	v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_CONN_INPUTS, &connected_inputs);
 
-	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
-				info->read_cable_det(sd));
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, cable_det);
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -1914,6 +1936,186 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void adv76xx_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	if ((cec_read(sd, 0x11) & 0x01) == 0) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: tx disabled\n", __func__);
+		return;
+	}
+
+	if (tx_raw_status & 0x02) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: arbitration lost\n",
+			 __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_ARB_LOST);
+		return;
+	}
+	if (tx_raw_status & 0x04) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: retry failed\n", __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_RETRY_TIMEOUT);
+		return;
+	}
+	if (tx_raw_status & 0x01) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: ready ok\n", __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_OK);
+		return;
+	}
+}
+
+static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)
+{
+	u8 cec_irq;
+
+	/* cec controller */
+	cec_irq = io_read(sd, 0x4d) & 0x0f;
+	if (!cec_irq)
+		return;
+
+	v4l2_dbg(1, debug, sd, "%s: cec: irq 0x%x\n", __func__, cec_irq);
+	adv76xx_cec_tx_raw_status(sd, cec_irq);
+	if (cec_irq & 0x08) {
+		struct cec_msg msg;
+
+		msg.len = cec_read(sd, 0x25) & 0x1f;
+		if (msg.len > 16)
+			msg.len = 16;
+
+		if (msg.len) {
+			u8 i;
+
+			for (i = 0; i < msg.len; i++)
+				msg.msg[i] = cec_read(sd, i + 0x15);
+			cec_write(sd, 0x26, 0x01); /* re-enable rx */
+			v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_RX_MSG, &msg);
+		}
+	}
+
+	/* note: the bit order is swapped between 0x4d and 0x4e */
+	cec_irq = ((cec_irq & 0x08) >> 3) | ((cec_irq & 0x04) >> 1) |
+		  ((cec_irq & 0x02) << 1) | ((cec_irq & 0x01) << 3);
+	io_write(sd, 0x4e, cec_irq);
+
+	if (handled)
+		*handled = true;
+}
+
+static unsigned adv76xx_cec_available_log_addrs(struct v4l2_subdev *sd)
+{
+	return ADV76XX_MAX_ADDRS;
+}
+
+static int adv76xx_cec_enable(struct v4l2_subdev *sd, bool enable)
+{
+	struct adv76xx_state *state = to_state(sd);
+
+	if (!state->cec_enabled_adap && enable) {
+		cec_write_clr_set(sd, 0x2a, 0x01, 0x01);	/* power up cec */
+		cec_write(sd, 0x2c, 0x01);	/* cec soft reset */
+		cec_write_clr_set(sd, 0x11, 0x01, 0);  /* initially disable tx */
+		/* enabled irqs: */
+		/* tx: ready */
+		/* tx: arbitration lost */
+		/* tx: retry timeout */
+		/* rx: ready */
+		io_write_clr_set(sd, 0x50, 0x0f, 0x0f);
+		cec_write(sd, 0x26, 0x01);            /* enable rx */
+	} else if (state->cec_enabled_adap && !enable) {
+		/* disable cec interrupts */
+		io_write_clr_set(sd, 0x50, 0x0f, 0x00);
+		/* disable address mask 1-3 */
+		cec_write_clr_set(sd, 0x27, 0x70, 0x00);
+		/* power down cec section */
+		cec_write_clr_set(sd, 0x2a, 0x01, 0x00);
+		state->cec_valid_addrs = 0;
+	}
+	state->cec_enabled_adap = enable;
+	adv76xx_s_detect_tx_5v_ctrl(sd);
+	return 0;
+}
+
+static int adv76xx_cec_log_addr(struct v4l2_subdev *sd, u8 addr)
+{
+	struct adv76xx_state *state = to_state(sd);
+	unsigned i, free_idx = ADV76XX_MAX_ADDRS;
+
+	if (!state->cec_enabled_adap)
+		return -EIO;
+
+	if (addr == CEC_LOG_ADDR_INVALID) {
+		cec_write_clr_set(sd, 0x27, 0x70, 0);
+		state->cec_valid_addrs = 0;
+		return 0;
+	}
+
+	for (i = 0; i < ADV76XX_MAX_ADDRS; i++) {
+		bool is_valid = state->cec_valid_addrs & (1 << i);
+
+		if (free_idx == ADV76XX_MAX_ADDRS && !is_valid)
+			free_idx = i;
+		if (is_valid && state->cec_addr[i] == addr)
+			return 0;
+	}
+	if (i == ADV76XX_MAX_ADDRS) {
+		i = free_idx;
+		if (i == ADV76XX_MAX_ADDRS)
+			return -ENXIO;
+	}
+	state->cec_addr[i] = addr;
+	state->cec_valid_addrs |= 1 << i;
+
+	switch (i) {
+	case 0:
+		/* enable address mask 0 */
+		cec_write_clr_set(sd, 0x27, 0x10, 0x10);
+		/* set address for mask 0 */
+		cec_write_clr_set(sd, 0x28, 0x0f, addr);
+		break;
+	case 1:
+		/* enable address mask 1 */
+		cec_write_clr_set(sd, 0x27, 0x20, 0x20);
+		/* set address for mask 1 */
+		cec_write_clr_set(sd, 0x28, 0xf0, addr << 4);
+		break;
+	case 2:
+		/* enable address mask 2 */
+		cec_write_clr_set(sd, 0x27, 0x40, 0x40);
+		/* set address for mask 1 */
+		cec_write_clr_set(sd, 0x29, 0x0f, addr);
+		break;
+	}
+	return 0;
+}
+
+static int adv76xx_cec_transmit(struct v4l2_subdev *sd, u32 timeout_ms, struct cec_msg *msg)
+{
+	u8 len = msg->len;
+	unsigned i;
+
+	if (len == 1)
+		/* allow for one retry for polling */
+		cec_write_clr_set(sd, 0x12, 0x07, 1);
+	else
+		/* allow for three retries */
+		cec_write_clr_set(sd, 0x12, 0x07, 3);
+
+	if (len > 16) {
+		v4l2_err(sd, "%s: len exceeded 16 (%d)\n", __func__, len);
+		return -EINVAL;
+	}
+
+	/* write data */
+	for (i = 0; i < len; i++)
+		cec_write(sd, i, msg->msg[i]);
+
+	/* set length (data + header) */
+	cec_write(sd, 0x10, len);
+	/* start transmit, enable tx */
+	cec_write(sd, 0x11, 0x01);
+	return 0;
+}
+
 static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -1959,6 +2161,9 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+	/* cec */
+	adv76xx_cec_isr(sd, handled);
+
 	/* tx 5v detect */
 	tx_5v = io_read(sd, 0x70) & info->cable_det_mask;
 	if (tx_5v) {
@@ -2266,8 +2471,19 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 			((edid_enabled & 0x02) ? "Yes" : "No"),
 			((edid_enabled & 0x04) ? "Yes" : "No"),
 			((edid_enabled & 0x08) ? "Yes" : "No"));
-	v4l2_info(sd, "CEC: %s\n", !!(cec_read(sd, 0x2a) & 0x01) ?
+	v4l2_info(sd, "CEC: %s\n", state->cec_enabled_adap ?
 			"enabled" : "disabled");
+	if (state->cec_enabled_adap) {
+		int i;
+
+		for (i = 0; i < ADV76XX_MAX_ADDRS; i++) {
+			bool is_valid = state->cec_valid_addrs & (1 << i);
+
+			if (is_valid)
+				v4l2_info(sd, "CEC Logical Address: 0x%x\n",
+					  state->cec_addr[i]);
+		}
+	}
 
 	v4l2_info(sd, "-----Signal status-----\n");
 	cable_det = info->read_cable_det(sd);
@@ -2400,6 +2616,10 @@ static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
 	.s_dv_timings = adv76xx_s_dv_timings,
 	.g_dv_timings = adv76xx_g_dv_timings,
 	.query_dv_timings = adv76xx_query_dv_timings,
+	.cec_available_log_addrs = adv76xx_cec_available_log_addrs,
+	.cec_enable = adv76xx_cec_enable,
+	.cec_log_addr = adv76xx_cec_log_addr,
+	.cec_transmit = adv76xx_cec_transmit,
 };
 
 static const struct v4l2_subdev_pad_ops adv76xx_pad_ops = {
@@ -3249,6 +3469,14 @@ static int adv76xx_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv76xx_state *state = to_state(sd);
 
+	/* disable interrupts */
+	io_write(sd, 0x40, 0);
+	io_write(sd, 0x41, 0);
+	io_write(sd, 0x46, 0);
+	io_write(sd, 0x6e, 0);
+	io_write(sd, 0x73, 0);
+	adv76xx_cec_enable(sd, false);
+
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
-- 
2.1.4

