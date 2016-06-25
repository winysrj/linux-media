Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53674 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbcFYNG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:06:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv19 10/14] cec: adv7604: add cec support.
Date: Sat, 25 Jun 2016 15:06:34 +0200
Message-Id: <1466859998-17640-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
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
 drivers/media/i2c/Kconfig   |   8 ++
 drivers/media/i2c/adv7604.c | 332 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 304 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 993dc50..a2c44cb 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -209,6 +209,7 @@ config VIDEO_ADV7604
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on GPIOLIB || COMPILE_TEST
 	select HDMI
+	select MEDIA_CEC_EDID
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
@@ -218,6 +219,13 @@ config VIDEO_ADV7604
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7604.
 
+config VIDEO_ADV7604_CEC
+	bool "Enable Analog Devices ADV7604 CEC support"
+	depends on VIDEO_ADV7604 && MEDIA_CEC
+	---help---
+	  When selected the adv7604 will support the optional
+	  HDMI CEC feature.
+
 config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index beb2841..3c9f001 100644
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
@@ -184,6 +187,12 @@ struct adv76xx_state {
 	u16 spa_port_a[2];
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
+
+	struct cec_adapter *cec_adap;
+	u8   cec_addr[ADV76XX_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
+
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool restart_stdi_once;
@@ -381,7 +390,8 @@ static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return regmap_write(state->regmap[ADV76XX_PAGE_IO], reg, val);
 }
 
-static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask,
+				   u8 val)
 {
 	return io_write(sd, reg, (io_read(sd, reg) & ~mask) | val);
 }
@@ -414,6 +424,12 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
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
@@ -872,9 +888,9 @@ static int adv76xx_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv76xx_state *state = to_state(sd);
 	const struct adv76xx_chip_info *info = state->info;
+	u16 cable_det = info->read_cable_det(sd);
 
-	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
-				info->read_cable_det(sd));
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, cable_det);
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -1900,6 +1916,210 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7604_CEC)
+static void adv76xx_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	struct adv76xx_state *state = to_state(sd);
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
+static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)
+{
+	struct adv76xx_state *state = to_state(sd);
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
+			cec_received_msg(state->cec_adap, &msg);
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
+static int adv76xx_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct adv76xx_state *state = adap->priv;
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
+static int adv76xx_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct adv76xx_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int i, free_idx = ADV76XX_MAX_ADDRS;
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
+static int adv76xx_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				     u32 signal_free_time, struct cec_msg *msg)
+{
+	struct adv76xx_state *state = adap->priv;
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
+static const struct cec_adap_ops adv76xx_cec_adap_ops = {
+	.adap_enable = adv76xx_cec_adap_enable,
+	.adap_log_addr = adv76xx_cec_adap_log_addr,
+	.adap_transmit = adv76xx_cec_adap_transmit,
+};
+#endif
+
 static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -1945,6 +2165,11 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7604_CEC)
+	/* cec */
+	adv76xx_cec_isr(sd, handled);
+#endif
+
 	/* tx 5v detect */
 	tx_5v = irq_reg_0x70 & info->cable_det_mask;
 	if (tx_5v) {
@@ -1994,39 +2219,12 @@ static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	return 0;
 }
 
-static int get_edid_spa_location(const u8 *edid)
-{
-	u8 d;
-
-	if ((edid[0x7e] != 1) ||
-	    (edid[0x80] != 0x02) ||
-	    (edid[0x81] != 0x03)) {
-		return -1;
-	}
-
-	/* search Vendor Specific Data Block (tag 3) */
-	d = edid[0x82] & 0x7f;
-	if (d > 4) {
-		int i = 0x84;
-		int end = 0x80 + d;
-
-		do {
-			u8 tag = edid[i] >> 5;
-			u8 len = edid[i] & 0x1f;
-
-			if ((tag == 3) && (len >= 5))
-				return i + 4;
-			i += len + 1;
-		} while (i < end);
-	}
-	return -1;
-}
-
 static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv76xx_state *state = to_state(sd);
 	const struct adv76xx_chip_info *info = state->info;
-	int spa_loc;
+	unsigned int spa_loc;
+	u16 pa;
 	int err;
 	int i;
 
@@ -2057,6 +2255,10 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		edid->blocks = 2;
 		return -E2BIG;
 	}
+	pa = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
+	err = cec_phys_addr_validate(pa, &pa, NULL);
+	if (err)
+		return err;
 
 	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 0x%x\n",
 			__func__, edid->pad, state->edid.present);
@@ -2066,9 +2268,12 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	adv76xx_set_hpd(state, 0);
 	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, 0x00);
 
-	spa_loc = get_edid_spa_location(edid->edid);
-	if (spa_loc < 0)
-		spa_loc = 0xc0; /* Default value [REF_02, p. 116] */
+	/*
+	 * Return an error if no location of the source physical address
+	 * was found.
+	 */
+	if (spa_loc == 0)
+		return -EINVAL;
 
 	switch (edid->pad) {
 	case ADV76XX_PAD_HDMI_PORT_A:
@@ -2128,6 +2333,7 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		v4l2_err(sd, "error enabling edid (0x%x)\n", state->edid.present);
 		return -EIO;
 	}
+	cec_s_phys_addr(state->cec_adap, pa, false);
 
 	/* enable hotplug after 100 ms */
 	queue_delayed_work(state->work_queues,
@@ -2252,8 +2458,19 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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
@@ -2363,6 +2580,24 @@ static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
 	}
 }
 
+static int adv76xx_registered(struct v4l2_subdev *sd)
+{
+	struct adv76xx_state *state = to_state(sd);
+	int err;
+
+	err = cec_register_adapter(state->cec_adap);
+	if (err)
+		cec_delete_adapter(state->cec_adap);
+	return err;
+}
+
+static void adv76xx_unregistered(struct v4l2_subdev *sd)
+{
+	struct adv76xx_state *state = to_state(sd);
+
+	cec_unregister_adapter(state->cec_adap);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
@@ -2406,6 +2641,11 @@ static const struct v4l2_subdev_ops adv76xx_ops = {
 	.pad = &adv76xx_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops adv76xx_int_ops = {
+	.registered = adv76xx_registered,
+	.unregistered = adv76xx_unregistered,
+};
+
 /* -------------------------- custom ctrls ---------------------------------- */
 
 static const struct v4l2_ctrl_config adv7604_ctrl_analog_sampling_phase = {
@@ -3069,6 +3309,7 @@ static int adv76xx_probe(struct i2c_client *client,
 		id->name, i2c_adapter_id(client->adapter),
 		client->addr);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->internal_ops = &adv76xx_int_ops;
 
 	/* Configure IO Regmap region */
 	err = configure_regmap(state, ADV76XX_PAGE_IO);
@@ -3212,6 +3453,18 @@ static int adv76xx_probe(struct i2c_client *client,
 	err = adv76xx_core_init(sd);
 	if (err)
 		goto err_entity;
+
+#if IS_ENABLED(CONFIG_VIDEO_ADV7604_CEC)
+	state->cec_adap = cec_allocate_adapter(&adv76xx_cec_adap_ops,
+		state, dev_name(&client->dev),
+		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV76XX_MAX_ADDRS,
+		&client->dev);
+	err = PTR_ERR_OR_ZERO(state->cec_adap);
+	if (err)
+		goto err_entity;
+#endif
+
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 			client->addr << 1, client->adapter->name);
 
@@ -3240,6 +3493,13 @@ static int adv76xx_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv76xx_state *state = to_state(sd);
 
+	/* disable interrupts */
+	io_write(sd, 0x40, 0);
+	io_write(sd, 0x41, 0);
+	io_write(sd, 0x46, 0);
+	io_write(sd, 0x6e, 0);
+	io_write(sd, 0x73, 0);
+
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
-- 
2.8.1

