Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37570 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbcFYNHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:07:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv19 11/14] cec: adv7842: add cec support
Date: Sat, 25 Jun 2016 15:06:35 +0200
Message-Id: <1466859998-17640-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support to the adv7842 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig   |   8 +
 drivers/media/i2c/adv7842.c | 368 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 313 insertions(+), 63 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index a2c44cb..0179d10 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -230,6 +230,7 @@ config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
+	select MEDIA_CEC_EDID
 	---help---
 	  Support for the Analog Devices ADV7842 video decoder.
 
@@ -239,6 +240,13 @@ config VIDEO_ADV7842
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7842.
 
+config VIDEO_ADV7842_CEC
+	bool "Enable Analog Devices ADV7842 CEC support"
+	depends on VIDEO_ADV7842 && MEDIA_CEC
+	---help---
+	  When selected the adv7842 will support the optional
+	  HDMI CEC feature.
+
 config VIDEO_BT819
 	tristate "BT819A VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index ecaacb0..ad7dcfc 100644
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
@@ -142,6 +145,11 @@ struct adv7842_state {
 	struct v4l2_ctrl *free_run_color_ctrl_manual;
 	struct v4l2_ctrl *free_run_color_ctrl;
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
+
+	struct cec_adapter *cec_adap;
+	u8   cec_addr[ADV7842_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
 };
 
 /* Unsupported timings. This device cannot support 720p30. */
@@ -418,9 +426,9 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_cec, reg, val);
 }
 
-static inline int cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return cec_write(sd, reg, (cec_read(sd, reg) & mask) | val);
+	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
 }
 
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
@@ -696,6 +704,18 @@ adv7842_get_dv_timings_cap(struct v4l2_subdev *sd)
 
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
@@ -762,50 +782,18 @@ static int edid_write_vga_segment(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int edid_spa_location(const u8 *edid)
-{
-	u8 d;
-
-	/*
-	 * TODO, improve and update for other CEA extensions
-	 * currently only for 1 segment (256 bytes),
-	 * i.e. 1 extension block and CEA revision 3.
-	 */
-	if ((edid[0x7e] != 1) ||
-	    (edid[0x80] != 0x02) ||
-	    (edid[0x81] != 0x03)) {
-		return -EINVAL;
-	}
-	/*
-	 * search Vendor Specific Data Block (tag 3)
-	 */
-	d = edid[0x82] & 0x7f;
-	if (d > 4) {
-		int i = 0x84;
-		int end = 0x80 + d;
-		do {
-			u8 tag = edid[i]>>5;
-			u8 len = edid[i] & 0x1f;
-
-			if ((tag == 3) && (len >= 5))
-				return i + 4;
-			i += len + 1;
-		} while (i < end);
-	}
-	return -EINVAL;
-}
-
 static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct adv7842_state *state = to_state(sd);
-	const u8 *val = state->hdmi_edid.edid;
-	int spa_loc = edid_spa_location(val);
+	const u8 *edid = state->hdmi_edid.edid;
+	int spa_loc;
+	u16 pa;
 	int err = 0;
 	int i;
 
-	v4l2_dbg(2, debug, sd, "%s: write EDID on port %c (spa at 0x%x)\n",
-			__func__, (port == ADV7842_EDID_PORT_A) ? 'A' : 'B', spa_loc);
+	v4l2_dbg(2, debug, sd, "%s: write EDID on port %c\n",
+			__func__, (port == ADV7842_EDID_PORT_A) ? 'A' : 'B');
 
 	/* HPA disable on port A and B */
 	io_write_and_or(sd, 0x20, 0xcf, 0x00);
@@ -816,24 +804,33 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	if (!state->hdmi_edid.present)
 		return 0;
 
+	pa = cec_get_edid_phys_addr(edid, 256, &spa_loc);
+	err = cec_phys_addr_validate(pa, &pa, NULL);
+	if (err)
+		return err;
+
+	/*
+	 * Return an error if no location of the source physical address
+	 * was found.
+	 */
+	if (spa_loc == 0)
+		return -EINVAL;
+
 	/* edid segment pointer '0' for HDMI ports */
 	rep_write_and_or(sd, 0x77, 0xef, 0x00);
 
 	for (i = 0; !err && i < 256; i += I2C_SMBUS_BLOCK_MAX)
 		err = adv_smbus_write_i2c_block_data(state->i2c_edid, i,
-						     I2C_SMBUS_BLOCK_MAX, val + i);
+						     I2C_SMBUS_BLOCK_MAX, edid + i);
 	if (err)
 		return err;
 
-	if (spa_loc < 0)
-		spa_loc = 0xc0; /* Default value [REF_02, p. 199] */
-
 	if (port == ADV7842_EDID_PORT_A) {
-		rep_write(sd, 0x72, val[spa_loc]);
-		rep_write(sd, 0x73, val[spa_loc + 1]);
+		rep_write(sd, 0x72, edid[spa_loc]);
+		rep_write(sd, 0x73, edid[spa_loc + 1]);
 	} else {
-		rep_write(sd, 0x74, val[spa_loc]);
-		rep_write(sd, 0x75, val[spa_loc + 1]);
+		rep_write(sd, 0x74, edid[spa_loc]);
+		rep_write(sd, 0x75, edid[spa_loc + 1]);
 	}
 	rep_write(sd, 0x76, spa_loc & 0xff);
 	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc >> 2) & 0x40);
@@ -853,6 +850,7 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 				(port == ADV7842_EDID_PORT_A) ? 'A' : 'B');
 		return -EIO;
 	}
+	cec_s_phys_addr(state->cec_adap, pa, false);
 
 	/* enable hotplug after 200 ms */
 	queue_delayed_work(state->work_queues,
@@ -983,20 +981,11 @@ static int adv7842_s_register(struct v4l2_subdev *sd,
 static int adv7842_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
-	int prev = v4l2_ctrl_g_ctrl(state->detect_tx_5v_ctrl);
-	u8 reg_io_6f = io_read(sd, 0x6f);
-	int val = 0;
-
-	if (reg_io_6f & 0x02)
-		val |= 1; /* port A */
-	if (reg_io_6f & 0x01)
-		val |= 2; /* port B */
+	u16 cable_det = adv7842_read_cable_det(sd);
 
-	v4l2_dbg(1, debug, sd, "%s: 0x%x -> 0x%x\n", __func__, prev, val);
+	v4l2_dbg(1, debug, sd, "%s: 0x%x\n", __func__, cable_det);
 
-	if (val != prev)
-		return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, val);
-	return 0;
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, cable_det);
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -2170,6 +2159,207 @@ static void adv7842_irq_enable(struct v4l2_subdev *sd, bool enable)
 	}
 }
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC)
+static void adv7842_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	struct adv7842_state *state = to_state(sd);
+
+	if ((cec_read(sd, 0x11) & 0x01) == 0) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: tx disabled\n", __func__);
+		return;
+	}
+
+	if (tx_raw_status & 0x02) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: arbitration lost\n",
+			 __func__);
+		cec_transmit_done(state->cec_adap, CEC_TX_STATUS_ARB_LOST,
+				  1, 0, 0, 0);
+		return;
+	}
+	if (tx_raw_status & 0x04) {
+		u8 status;
+		u8 nack_cnt;
+		u8 low_drive_cnt;
+
+		v4l2_dbg(1, debug, sd, "%s: tx raw: retry failed\n", __func__);
+		/*
+		 * We set this status bit since this hardware performs
+		 * retransmissions.
+		 */
+		status = CEC_TX_STATUS_MAX_RETRIES;
+		nack_cnt = cec_read(sd, 0x14) & 0xf;
+		if (nack_cnt)
+			status |= CEC_TX_STATUS_NACK;
+		low_drive_cnt = cec_read(sd, 0x14) >> 4;
+		if (low_drive_cnt)
+			status |= CEC_TX_STATUS_LOW_DRIVE;
+		cec_transmit_done(state->cec_adap, status,
+				  0, nack_cnt, low_drive_cnt, 0);
+		return;
+	}
+	if (tx_raw_status & 0x01) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: ready ok\n", __func__);
+		cec_transmit_done(state->cec_adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
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
+		struct adv7842_state *state = to_state(sd);
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
+			cec_received_msg(state->cec_adap, &msg);
+		}
+	}
+
+	io_write(sd, 0x94, cec_irq);
+
+	if (handled)
+		*handled = true;
+}
+
+static int adv7842_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct adv7842_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+
+	if (!state->cec_enabled_adap && enable) {
+		cec_write_clr_set(sd, 0x2a, 0x01, 0x01); /* power up cec */
+		cec_write(sd, 0x2c, 0x01);	/* cec soft reset */
+		cec_write_clr_set(sd, 0x11, 0x01, 0); /* initially disable tx */
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
+static int adv7842_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct adv7842_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int i, free_idx = ADV7842_MAX_ADDRS;
+
+	if (!state->cec_enabled_adap)
+		return addr == CEC_LOG_ADDR_INVALID ? 0 : -EIO;
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
+static int adv7842_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				     u32 signal_free_time, struct cec_msg *msg)
+{
+	struct adv7842_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	u8 len = msg->len;
+	unsigned int i;
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
+static const struct cec_adap_ops adv7842_cec_adap_ops = {
+	.adap_enable = adv7842_cec_adap_enable,
+	.adap_log_addr = adv7842_cec_adap_log_addr,
+	.adap_transmit = adv7842_cec_adap_transmit,
+};
+#endif
+
 static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -2241,6 +2431,11 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC)
+	/* cec */
+	adv7842_cec_isr(sd, handled);
+#endif
+
 	/* tx 5v detect */
 	if (irq_status[2] & 0x3) {
 		v4l2_dbg(1, debug, sd, "%s: irq tx_5v\n", __func__);
@@ -2321,10 +2516,12 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
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
@@ -2509,8 +2706,19 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
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
@@ -3031,6 +3239,24 @@ static int adv7842_subscribe_event(struct v4l2_subdev *sd,
 	}
 }
 
+static int adv7842_registered(struct v4l2_subdev *sd)
+{
+	struct adv7842_state *state = to_state(sd);
+	int err;
+
+	err = cec_register_adapter(state->cec_adap);
+	if (err)
+		cec_delete_adapter(state->cec_adap);
+	return err;
+}
+
+static void adv7842_unregistered(struct v4l2_subdev *sd)
+{
+	struct adv7842_state *state = to_state(sd);
+
+	cec_unregister_adapter(state->cec_adap);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops adv7842_ctrl_ops = {
@@ -3077,6 +3303,11 @@ static const struct v4l2_subdev_ops adv7842_ops = {
 	.pad = &adv7842_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops adv7842_int_ops = {
+	.registered = adv7842_registered,
+	.unregistered = adv7842_unregistered,
+};
+
 /* -------------------------- custom ctrls ---------------------------------- */
 
 static const struct v4l2_ctrl_config adv7842_ctrl_analog_sampling_phase = {
@@ -3241,6 +3472,7 @@ static int adv7842_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->internal_ops = &adv7842_int_ops;
 	state->mode = pdata->mode;
 
 	state->hdmi_port_a = pdata->input == ADV7842_SELECT_HDMI_PORT_A;
@@ -3331,6 +3563,17 @@ static int adv7842_probe(struct i2c_client *client,
 	if (err)
 		goto err_entity;
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC)
+	state->cec_adap = cec_allocate_adapter(&adv7842_cec_adap_ops,
+		state, dev_name(&client->dev),
+		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV7842_MAX_ADDRS,
+		&client->dev);
+	err = PTR_ERR_OR_ZERO(state->cec_adap);
+	if (err)
+		goto err_entity;
+#endif
+
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 		  client->addr << 1, client->adapter->name);
 	return 0;
@@ -3355,7 +3598,6 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_device_unregister_subdev(sd);
-- 
2.8.1

