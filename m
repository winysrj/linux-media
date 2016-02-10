Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40753 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbcBJNIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 08:08:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv12 13/17] cec: adv7842: add cec support
Date: Wed, 10 Feb 2016 13:51:47 +0100
Message-Id: <1455108711-29850-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support to the adv7842 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 268 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 251 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 5fbb788..b62707b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -39,6 +39,7 @@
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
 #include <linux/hdmi.h>
+#include <media/cec.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
@@ -79,6 +80,8 @@ MODULE_LICENSE("GPL");
 
 #define ADV7842_OP_SWAP_CB_CR				(1 << 0)
 
+#define ADV7842_MAX_ADDRS (3)
+
 /*
 **********************************************************************
 *
@@ -142,6 +145,10 @@ struct adv7842_state {
 	struct v4l2_ctrl *free_run_color_ctrl_manual;
 	struct v4l2_ctrl *free_run_color_ctrl;
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
+
+	u8   cec_addr[ADV7842_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
 };
 
 /* Unsupported timings. This device cannot support 720p30. */
@@ -418,9 +425,9 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_cec, reg, val);
 }
 
-static inline int cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return cec_write(sd, reg, (cec_read(sd, reg) & mask) | val);
+	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
 }
 
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
@@ -696,6 +703,18 @@ adv7842_get_dv_timings_cap(struct v4l2_subdev *sd)
 
 /* ----------------------------------------------------------------------- */
 
+static u16 adv7842_read_cable_det(struct v4l2_subdev *sd)
+{
+	u8 reg = io_read(sd, 0x6f);
+	u16 val = 0;
+
+	if (reg & 0x02)
+		val |= 1; /* port A */
+	if (reg & 0x01)
+		val |= 2; /* port B */
+	return val;
+}
+
 static void adv7842_delayed_work_enable_hotplug(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
@@ -703,8 +722,13 @@ static void adv7842_delayed_work_enable_hotplug(struct work_struct *work)
 			struct adv7842_state, delayed_work_enable_hotplug);
 	struct v4l2_subdev *sd = &state->sd;
 	int present = state->hdmi_edid.present;
+	u16 connected_inputs;
 	u8 mask = 0;
 
+	connected_inputs = present & adv7842_read_cable_det(sd);
+	v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_CONN_INPUTS,
+			   &connected_inputs);
+
 	v4l2_dbg(2, debug, sd, "%s: enable hotplug on ports: 0x%x\n",
 			__func__, present);
 
@@ -983,20 +1007,16 @@ static int adv7842_s_register(struct v4l2_subdev *sd,
 static int adv7842_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
-	int prev = v4l2_ctrl_g_ctrl(state->detect_tx_5v_ctrl);
-	u8 reg_io_6f = io_read(sd, 0x6f);
-	int val = 0;
+	u16 cable_det = adv7842_read_cable_det(sd);
+	u16 connected_inputs;
 
-	if (reg_io_6f & 0x02)
-		val |= 1; /* port A */
-	if (reg_io_6f & 0x01)
-		val |= 2; /* port B */
+	v4l2_dbg(1, debug, sd, "%s: 0x%x\n", __func__, cable_det);
 
-	v4l2_dbg(1, debug, sd, "%s: 0x%x -> 0x%x\n", __func__, prev, val);
+	connected_inputs = state->hdmi_edid.present & cable_det;
+	v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_CONN_INPUTS,
+			   &connected_inputs);
 
-	if (val != prev)
-		return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, val);
-	return 0;
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, cable_det);
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -2157,6 +2177,196 @@ static void adv7842_irq_enable(struct v4l2_subdev *sd, bool enable)
 	}
 }
 
+static void adv7842_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
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
+		tx_done.arb_lost_cnt = 1;
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE, &tx_done);
+		return;
+	}
+	if (tx_raw_status & 0x04) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: retry failed\n", __func__);
+		/*
+		 * We set this status bit since this hardware performs
+		 * retransmissions.
+		 */
+		tx_done.status = CEC_TX_STATUS_MAX_RETRIES;
+		tx_done.nack_cnt = cec_read(sd, 0x14) & 0xf;
+		if (tx_done.nack_cnt)
+			tx_done.status |= CEC_TX_STATUS_NACK;
+		tx_done.low_drive_cnt = cec_read(sd, 0x14) >> 4;
+		if (tx_done.low_drive_cnt)
+			tx_done.status |= CEC_TX_STATUS_LOW_DRIVE;
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
+static void adv7842_cec_isr(struct v4l2_subdev *sd, bool *handled)
+{
+	u8 cec_irq;
+
+	/* cec controller */
+	cec_irq = io_read(sd, 0x93) & 0x0f;
+	if (!cec_irq)
+		return;
+
+	v4l2_dbg(1, debug, sd, "%s: cec: irq 0x%x\n", __func__, cec_irq);
+	adv7842_cec_tx_raw_status(sd, cec_irq);
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
+	io_write(sd, 0x94, cec_irq);
+
+	if (handled)
+		*handled = true;
+}
+
+static unsigned adv7842_cec_adap_available_log_addrs(struct v4l2_subdev *sd)
+{
+	return ADV7842_MAX_ADDRS;
+}
+
+static int adv7842_cec_adap_enable(struct v4l2_subdev *sd, bool enable)
+{
+	struct adv7842_state *state = to_state(sd);
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
+		io_write_clr_set(sd, 0x96, 0x0f, 0x0f);
+		cec_write(sd, 0x26, 0x01);            /* enable rx */
+	} else if (state->cec_enabled_adap && !enable) {
+		/* disable cec interrupts */
+		io_write_clr_set(sd, 0x96, 0x0f, 0x00);
+		/* disable address mask 1-3 */
+		cec_write_clr_set(sd, 0x27, 0x70, 0x00);
+		/* power down cec section */
+		cec_write_clr_set(sd, 0x2a, 0x01, 0x00);
+		state->cec_valid_addrs = 0;
+	}
+	state->cec_enabled_adap = enable;
+	return 0;
+}
+
+static int adv7842_cec_adap_log_addr(struct v4l2_subdev *sd, u8 addr)
+{
+	struct adv7842_state *state = to_state(sd);
+	unsigned i, free_idx = ADV7842_MAX_ADDRS;
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
+	for (i = 0; i < ADV7842_MAX_ADDRS; i++) {
+		bool is_valid = state->cec_valid_addrs & (1 << i);
+
+		if (free_idx == ADV7842_MAX_ADDRS && !is_valid)
+			free_idx = i;
+		if (is_valid && state->cec_addr[i] == addr)
+			return 0;
+	}
+	if (i == ADV7842_MAX_ADDRS) {
+		i = free_idx;
+		if (i == ADV7842_MAX_ADDRS)
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
+static int adv7842_cec_adap_transmit(struct v4l2_subdev *sd, u8 attempts,
+				     u32 signal_free_time_ms, struct cec_msg *msg)
+{
+	u8 len = msg->len;
+	unsigned i;
+
+	/*
+	 * The number of retries is the number of attempts - 1, but retry
+	 * at least once. It's not clear if a value of 0 is allowed, so
+	 * let's do at least one retry.
+	 */
+	cec_write_clr_set(sd, 0x12, 0x70, max(1, attempts - 1) << 4);
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
 static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -2228,6 +2438,9 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+	/* cec */
+	adv7842_cec_isr(sd, handled);
+
 	/* tx 5v detect */
 	if (irq_status[2] & 0x3) {
 		v4l2_dbg(1, debug, sd, "%s: irq tx_5v\n", __func__);
@@ -2308,10 +2521,12 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
 	case ADV7842_EDID_PORT_A:
 	case ADV7842_EDID_PORT_B:
 		memset(&state->hdmi_edid.edid, 0, 256);
-		if (e->blocks)
+		if (e->blocks) {
 			state->hdmi_edid.present |= 0x04 << e->pad;
-		else
+		} else {
 			state->hdmi_edid.present &= ~(0x04 << e->pad);
+			adv7842_s_detect_tx_5v_ctrl(sd);
+		}
 		memcpy(&state->hdmi_edid.edid, e->edid, 128 * e->blocks);
 		err = edid_write_hdmi_segment(sd, e->pad);
 		break;
@@ -2496,8 +2711,19 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "HPD A %s, B %s\n",
 		  reg_io_0x21 & 0x02 ? "enabled" : "disabled",
 		  reg_io_0x21 & 0x01 ? "enabled" : "disabled");
-	v4l2_info(sd, "CEC %s\n", !!(cec_read(sd, 0x2a) & 0x01) ?
+	v4l2_info(sd, "CEC: %s\n", state->cec_enabled_adap ?
 			"enabled" : "disabled");
+	if (state->cec_enabled_adap) {
+		int i;
+
+		for (i = 0; i < ADV7842_MAX_ADDRS; i++) {
+			bool is_valid = state->cec_valid_addrs & (1 << i);
+
+			if (is_valid)
+				v4l2_info(sd, "CEC Logical Address: 0x%x\n",
+					  state->cec_addr[i]);
+		}
+	}
 
 	v4l2_info(sd, "-----Signal status-----\n");
 	if (state->hdmi_port_a) {
@@ -3047,6 +3273,13 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 	.query_dv_timings = adv7842_query_dv_timings,
 };
 
+static const struct v4l2_subdev_cec_ops adv7842_cec_ops = {
+	.adap_available_log_addrs = adv7842_cec_adap_available_log_addrs,
+	.adap_enable = adv7842_cec_adap_enable,
+	.adap_log_addr = adv7842_cec_adap_log_addr,
+	.adap_transmit = adv7842_cec_adap_transmit,
+};
+
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
 	.enum_mbus_code = adv7842_enum_mbus_code,
 	.get_fmt = adv7842_get_format,
@@ -3061,6 +3294,7 @@ static const struct v4l2_subdev_ops adv7842_ops = {
 	.core = &adv7842_core_ops,
 	.video = &adv7842_video_ops,
 	.pad = &adv7842_pad_ops,
+	.cec = &adv7842_cec_ops,
 };
 
 /* -------------------------- custom ctrls ---------------------------------- */
@@ -3341,7 +3575,7 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-
+	adv7842_cec_adap_enable(sd, false);
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_device_unregister_subdev(sd);
-- 
2.7.0

