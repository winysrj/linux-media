Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55845 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604AbcBEP2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 10:28:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv11 12/17] cec: adv7604: add cec support.
Date: Fri,  5 Feb 2016 16:27:55 +0100
Message-Id: <1454686080-39018-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1454686080-39018-1-git-send-email-hverkuil@xs4all.nl>
References: <1454686080-39018-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support to the adv7604 driver.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: add missing methods cec/io_write_and_or]
[k.debski@samsung.com: change adv7604 to adv76xx in added functions]
[hansverk@cisco.com: use _clr_set instead of _and_or]
---
 drivers/media/i2c/adv7604.c | 243 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 239 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f8dd750..884fc92 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -40,6 +40,7 @@
 #include <linux/regmap.h>
 
 #include <media/i2c/adv7604.h>
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
 
-	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
-				info->read_cable_det(sd));
+	v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_CONN_INPUTS,
+			   &connected_inputs);
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, cable_det);
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -1914,6 +1936,189 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void adv76xx_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	struct v4l2_subdev_cec_tx_done tx_done = {};
+
+	if ((cec_read(sd, 0x11) & 0x01) == 0) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: tx disabled\n", __func__);
+		return;
+	}
+
+	if (tx_raw_status & 0x02) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: arbitration lost\n",
+			 __func__);
+		tx_done.status = CEC_TX_STATUS_ARB_LOST;
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE, &tx_done);
+		return;
+	}
+	if (tx_raw_status & 0x04) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: retry failed\n", __func__);
+		tx_done.status = CEC_TX_STATUS_MAX_RETRIES;
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE, &tx_done);
+		return;
+	}
+	if (tx_raw_status & 0x01) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: ready ok\n", __func__);
+		tx_done.status = CEC_TX_STATUS_OK;
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE, &tx_done);
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
+static unsigned adv76xx_cec_adap_available_log_addrs(struct v4l2_subdev *sd)
+{
+	return ADV76XX_MAX_ADDRS;
+}
+
+static int adv76xx_cec_adap_enable(struct v4l2_subdev *sd, bool enable)
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
+static int adv76xx_cec_adap_log_addr(struct v4l2_subdev *sd, u8 addr)
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
+static int adv76xx_cec_adap_transmit(struct v4l2_subdev *sd, u8 *retries,
+				     u32 signal_free_time_ms, struct cec_msg *msg)
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
@@ -1959,6 +2164,9 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+	/* cec */
+	adv76xx_cec_isr(sd, handled);
+
 	/* tx 5v detect */
 	tx_5v = io_read(sd, 0x70) & info->cable_det_mask;
 	if (tx_5v) {
@@ -2266,8 +2474,19 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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
@@ -2402,6 +2621,13 @@ static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
 	.query_dv_timings = adv76xx_query_dv_timings,
 };
 
+static const struct v4l2_subdev_cec_ops adv76xx_cec_ops = {
+	.adap_available_log_addrs = adv76xx_cec_adap_available_log_addrs,
+	.adap_enable = adv76xx_cec_adap_enable,
+	.adap_log_addr = adv76xx_cec_adap_log_addr,
+	.adap_transmit = adv76xx_cec_adap_transmit,
+};
+
 static const struct v4l2_subdev_pad_ops adv76xx_pad_ops = {
 	.enum_mbus_code = adv76xx_enum_mbus_code,
 	.get_fmt = adv76xx_get_format,
@@ -2416,6 +2642,7 @@ static const struct v4l2_subdev_ops adv76xx_ops = {
 	.core = &adv76xx_core_ops,
 	.video = &adv76xx_video_ops,
 	.pad = &adv76xx_pad_ops,
+	.cec = &adv76xx_cec_ops,
 };
 
 /* -------------------------- custom ctrls ---------------------------------- */
@@ -3249,6 +3476,14 @@ static int adv76xx_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv76xx_state *state = to_state(sd);
 
+	/* disable interrupts */
+	io_write(sd, 0x40, 0);
+	io_write(sd, 0x41, 0);
+	io_write(sd, 0x46, 0);
+	io_write(sd, 0x6e, 0);
+	io_write(sd, 0x73, 0);
+	adv76xx_cec_adap_enable(sd, false);
+
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
-- 
2.7.0

