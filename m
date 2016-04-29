Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45092 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbcD2Nw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 09:52:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv16 11/13] cec: adv7511: add cec support.
Date: Fri, 29 Apr 2016 15:52:26 +0200
Message-Id: <1461937948-22936-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support to the adv7511 driver.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig   |   9 +
 drivers/media/i2c/adv7511.c | 401 +++++++++++++++++++++++++++++++++++++++++++-
 include/media/i2c/adv7511.h |   6 +-
 3 files changed, 403 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 5168454..6c2acb6 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -465,6 +465,7 @@ config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
+	select MEDIA_CEC_EDID
 	---help---
 	  Support for the Analog Devices ADV7511 video encoder.
 
@@ -473,6 +474,14 @@ config VIDEO_ADV7511
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7511.
 
+config VIDEO_ADV7511_CEC
+	bool "Enable Analog Devices ADV7511 CEC support"
+	depends on VIDEO_ADV7511 && MEDIA_CEC
+	default y
+	---help---
+	  When selected the adv7511 will support the optional
+	  HDMI CEC feature.
+
 config VIDEO_AD9389B
 	tristate "Analog Devices AD9389B encoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 39271c3..002117b 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -33,6 +33,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/i2c/adv7511.h>
+#include <media/cec.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -59,6 +60,8 @@ MODULE_LICENSE("GPL v2");
 #define ADV7511_MIN_PIXELCLOCK 20000000
 #define ADV7511_MAX_PIXELCLOCK 225000000
 
+#define ADV7511_MAX_ADDRS (3)
+
 /*
 **********************************************************************
 *
@@ -90,12 +93,20 @@ struct adv7511_state {
 	struct v4l2_ctrl_handler hdl;
 	int chip_revision;
 	u8 i2c_edid_addr;
-	u8 i2c_cec_addr;
 	u8 i2c_pktmem_addr;
+	u8 i2c_cec_addr;
+
+	struct i2c_client *i2c_cec;
+	struct cec_adapter *cec_adap;
+	u8   cec_addr[ADV7511_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
+
 	/* Is the adv7511 powered on? */
 	bool power_on;
 	/* Did we receive hotplug and rx-sense signals? */
 	bool have_monitor;
+	bool enabled_irq;
 	/* timings from s_dv_timings */
 	struct v4l2_dv_timings dv_timings;
 	u32 fmt_code;
@@ -227,7 +238,7 @@ static int adv_smbus_read_i2c_block_data(struct i2c_client *client,
 	return ret;
 }
 
-static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
+static void adv7511_edid_rd(struct v4l2_subdev *sd, uint16_t len, uint8_t *buf)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	int i;
@@ -242,6 +253,34 @@ static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
 		v4l2_err(sd, "%s: i2c read error\n", __func__);
 }
 
+static inline int adv7511_cec_read(struct v4l2_subdev *sd, u8 reg)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	return i2c_smbus_read_byte_data(state->i2c_cec, reg);
+}
+
+static int adv7511_cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	int ret;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		ret = i2c_smbus_write_byte_data(state->i2c_cec, reg, val);
+		if (ret == 0)
+			return 0;
+	}
+	v4l2_err(sd, "%s: I2C Write Problem\n", __func__);
+	return ret;
+}
+
+static inline int adv7511_cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask,
+				   u8 val)
+{
+	return adv7511_cec_write(sd, reg, (adv7511_cec_read(sd, reg) & mask) | val);
+}
+
 static int adv7511_pktmem_rd(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
@@ -425,16 +464,28 @@ static const struct v4l2_ctrl_ops adv7511_ctrl_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static void adv7511_inv_register(struct v4l2_subdev *sd)
 {
+	struct adv7511_state *state = get_adv7511_state(sd);
+
 	v4l2_info(sd, "0x000-0x0ff: Main Map\n");
+	if (state->i2c_cec)
+		v4l2_info(sd, "0x100-0x1ff: CEC Map\n");
 }
 
 static int adv7511_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
+	struct adv7511_state *state = get_adv7511_state(sd);
+
 	reg->size = 1;
 	switch (reg->reg >> 8) {
 	case 0:
 		reg->val = adv7511_rd(sd, reg->reg & 0xff);
 		break;
+	case 1:
+		if (state->i2c_cec) {
+			reg->val = adv7511_cec_read(sd, reg->reg & 0xff);
+			break;
+		}
+		/* fall through */
 	default:
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
 		adv7511_inv_register(sd);
@@ -445,10 +496,18 @@ static int adv7511_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int adv7511_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
+	struct adv7511_state *state = get_adv7511_state(sd);
+
 	switch (reg->reg >> 8) {
 	case 0:
 		adv7511_wr(sd, reg->reg & 0xff, reg->val & 0xff);
 		break;
+	case 1:
+		if (state->i2c_cec) {
+			adv7511_cec_write(sd, reg->reg & 0xff, reg->val & 0xff);
+			break;
+		}
+		/* fall through */
 	default:
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
 		adv7511_inv_register(sd);
@@ -536,6 +595,7 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	struct adv7511_state_edid *edid = &state->edid;
+	int i;
 
 	static const char * const states[] = {
 		"in reset",
@@ -605,7 +665,23 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 	else
 		v4l2_info(sd, "no timings set\n");
 	v4l2_info(sd, "i2c edid addr: 0x%x\n", state->i2c_edid_addr);
+
+	if (state->i2c_cec == NULL)
+		return 0;
+
 	v4l2_info(sd, "i2c cec addr: 0x%x\n", state->i2c_cec_addr);
+
+	v4l2_info(sd, "CEC: %s\n", state->cec_enabled_adap ?
+			"enabled" : "disabled");
+	if (state->cec_enabled_adap) {
+		for (i = 0; i < ADV7511_MAX_ADDRS; i++) {
+			bool is_valid = state->cec_valid_addrs & (1 << i);
+
+			if (is_valid)
+				v4l2_info(sd, "CEC Logical Address: 0x%x\n",
+					  state->cec_addr[i]);
+		}
+	}
 	v4l2_info(sd, "i2c pktmem addr: 0x%x\n", state->i2c_pktmem_addr);
 	return 0;
 }
@@ -663,15 +739,197 @@ static int adv7511_s_power(struct v4l2_subdev *sd, int on)
 	return true;
 }
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7511_CEC)
+static int adv7511_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct adv7511_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+
+	if (state->i2c_cec == NULL)
+		return -EIO;
+
+	if (!state->cec_enabled_adap && enable) {
+		/* power up cec section */
+		adv7511_cec_write_and_or(sd, 0x4e, 0xfc, 0x01);
+		/* legacy mode and clear all rx buffers */
+		adv7511_cec_write(sd, 0x4a, 0x07);
+		adv7511_cec_write(sd, 0x4a, 0);
+		adv7511_cec_write_and_or(sd, 0x11, 0xfe, 0); /* initially disable tx */
+		/* enabled irqs: */
+		/* tx: ready */
+		/* tx: arbitration lost */
+		/* tx: retry timeout */
+		/* rx: ready 1 */
+		if (state->enabled_irq)
+			adv7511_wr_and_or(sd, 0x95, 0xc0, 0x39);
+	} else if (state->cec_enabled_adap && !enable) {
+		if (state->enabled_irq)
+			adv7511_wr_and_or(sd, 0x95, 0xc0, 0x00);
+		/* disable address mask 1-3 */
+		adv7511_cec_write_and_or(sd, 0x4b, 0x8f, 0x00);
+		/* power down cec section */
+		adv7511_cec_write_and_or(sd, 0x4e, 0xfc, 0x00);
+		state->cec_valid_addrs = 0;
+	}
+	state->cec_enabled_adap = enable;
+	return 0;
+}
+
+static int adv7511_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct adv7511_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned i, free_idx = ADV7511_MAX_ADDRS;
+
+	if (!state->cec_enabled_adap)
+		return addr == CEC_LOG_ADDR_INVALID ? 0 : -EIO;
+
+	if (addr == CEC_LOG_ADDR_INVALID) {
+		adv7511_cec_write_and_or(sd, 0x4b, 0x8f, 0);
+		state->cec_valid_addrs = 0;
+		return 0;
+	}
+
+	for (i = 0; i < ADV7511_MAX_ADDRS; i++) {
+		bool is_valid = state->cec_valid_addrs & (1 << i);
+
+		if (free_idx == ADV7511_MAX_ADDRS && !is_valid)
+			free_idx = i;
+		if (is_valid && state->cec_addr[i] == addr)
+			return 0;
+	}
+	if (i == ADV7511_MAX_ADDRS) {
+		i = free_idx;
+		if (i == ADV7511_MAX_ADDRS)
+			return -ENXIO;
+	}
+	state->cec_addr[i] = addr;
+	state->cec_valid_addrs |= 1 << i;
+
+	switch (i) {
+	case 0:
+		/* enable address mask 0 */
+		adv7511_cec_write_and_or(sd, 0x4b, 0xef, 0x10);
+		/* set address for mask 0 */
+		adv7511_cec_write_and_or(sd, 0x4c, 0xf0, addr);
+		break;
+	case 1:
+		/* enable address mask 1 */
+		adv7511_cec_write_and_or(sd, 0x4b, 0xdf, 0x20);
+		/* set address for mask 1 */
+		adv7511_cec_write_and_or(sd, 0x4c, 0x0f, addr << 4);
+		break;
+	case 2:
+		/* enable address mask 2 */
+		adv7511_cec_write_and_or(sd, 0x4b, 0xbf, 0x40);
+		/* set address for mask 1 */
+		adv7511_cec_write_and_or(sd, 0x4d, 0xf0, addr);
+		break;
+	}
+	return 0;
+}
+
+static int adv7511_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				     u32 signal_free_time, struct cec_msg *msg)
+{
+	struct adv7511_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	u8 len = msg->len;
+	unsigned i;
+
+	v4l2_dbg(1, debug, sd, "%s: len %d\n", __func__, len);
+
+	if (len > 16) {
+		v4l2_err(sd, "%s: len exceeded 16 (%d)\n", __func__, len);
+		return -EINVAL;
+	}
+
+	/*
+	 * The number of retries is the number of attempts - 1, but retry
+	 * at least once. It's not clear if a value of 0 is allowed, so
+	 * let's do at least one retry.
+	 */
+	adv7511_cec_write_and_or(sd, 0x12, ~0x70, max(1, attempts - 1) << 4);
+
+	/* blocking, clear cec tx irq status */
+	adv7511_wr_and_or(sd, 0x97, 0xc7, 0x38);
+
+	/* write data */
+	for (i = 0; i < len; i++)
+		adv7511_cec_write(sd, i, msg->msg[i]);
+
+	/* set length (data + header) */
+	adv7511_cec_write(sd, 0x10, len);
+	/* start transmit, enable tx */
+	adv7511_cec_write(sd, 0x11, 0x01);
+	return 0;
+}
+
+static void adv_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	if ((adv7511_cec_read(sd, 0x11) & 0x01) == 0) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: tx disabled\n", __func__);
+		return;
+	}
+
+	if (tx_raw_status & 0x10) {
+		v4l2_dbg(1, debug, sd,
+			 "%s: tx raw: arbitration lost\n", __func__);
+		cec_transmit_done(state->cec_adap, CEC_TX_STATUS_ARB_LOST,
+				  1, 0, 0, 0);
+		return;
+	}
+	if (tx_raw_status & 0x08) {
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
+		nack_cnt = adv7511_cec_read(sd, 0x14) & 0xf;
+		if (nack_cnt)
+			status |= CEC_TX_STATUS_NACK;
+		low_drive_cnt = adv7511_cec_read(sd, 0x14) >> 4;
+		if (low_drive_cnt)
+			status |= CEC_TX_STATUS_LOW_DRIVE;
+		cec_transmit_done(state->cec_adap, status,
+				  0, nack_cnt, low_drive_cnt, 0);
+		return;
+	}
+	if (tx_raw_status & 0x20) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: ready ok\n", __func__);
+		cec_transmit_done(state->cec_adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
+		return;
+	}
+}
+
+static const struct cec_adap_ops adv7511_cec_adap_ops = {
+	.adap_enable = adv7511_cec_adap_enable,
+	.adap_log_addr = adv7511_cec_adap_log_addr,
+	.adap_transmit = adv7511_cec_adap_transmit,
+};
+#endif
+
 /* Enable interrupts */
 static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 {
+	struct adv7511_state *state = get_adv7511_state(sd);
 	u8 irqs = MASK_ADV7511_HPD_INT | MASK_ADV7511_MSEN_INT;
 	u8 irqs_rd;
 	int retries = 100;
 
 	v4l2_dbg(2, debug, sd, "%s: %s\n", __func__, enable ? "enable" : "disable");
 
+	if (state->enabled_irq == enable)
+		return;
+	state->enabled_irq = enable;
+
 	/* The datasheet says that the EDID ready interrupt should be
 	   disabled if there is no hotplug. */
 	if (!enable)
@@ -679,6 +937,9 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 	else if (adv7511_have_hotplug(sd))
 		irqs |= MASK_ADV7511_EDID_RDY_INT;
 
+	if (state->cec_enabled_adap)
+		adv7511_wr_and_or(sd, 0x95, 0xc0, enable ? 0x39 : 0x00);
+
 	/*
 	 * This i2c write can fail (approx. 1 in 1000 writes). But it
 	 * is essential that this register is correct, so retry it
@@ -701,20 +962,53 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 static int adv7511_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	u8 irq_status;
+	u8 cec_irq;
 
 	/* disable interrupts to prevent a race condition */
 	adv7511_set_isr(sd, false);
 	irq_status = adv7511_rd(sd, 0x96);
+	cec_irq = adv7511_rd(sd, 0x97);
 	/* clear detected interrupts */
 	adv7511_wr(sd, 0x96, irq_status);
+	adv7511_wr(sd, 0x97, cec_irq);
 
-	v4l2_dbg(1, debug, sd, "%s: irq 0x%x\n", __func__, irq_status);
+	v4l2_dbg(1, debug, sd, "%s: irq 0x%x, cec-irq 0x%x\n", __func__,
+		 irq_status, cec_irq);
 
 	if (irq_status & (MASK_ADV7511_HPD_INT | MASK_ADV7511_MSEN_INT))
 		adv7511_check_monitor_present_status(sd);
 	if (irq_status & MASK_ADV7511_EDID_RDY_INT)
 		adv7511_check_edid_status(sd);
 
+#if IS_ENABLED(CONFIG_VIDEO_ADV7511_CEC)
+	if (cec_irq & 0x38)
+		adv_cec_tx_raw_status(sd, cec_irq);
+
+	if (cec_irq & 1) {
+		struct adv7511_state *state = get_adv7511_state(sd);
+		struct cec_msg msg;
+
+		msg.len = adv7511_cec_read(sd, 0x25) & 0x1f;
+
+		v4l2_dbg(1, debug, sd, "%s: cec msg len %d\n", __func__,
+			 msg.len);
+
+		if (msg.len > 16)
+			msg.len = 16;
+
+		if (msg.len) {
+			u8 i;
+
+			for (i = 0; i < msg.len; i++)
+				msg.msg[i] = adv7511_cec_read(sd, i + 0x15);
+
+			adv7511_cec_write(sd, 0x4a, 1); /* toggle to re-enable rx 1 */
+			adv7511_cec_write(sd, 0x4a, 0);
+			cec_received_msg(state->cec_adap, &msg);
+		}
+	}
+#endif
+
 	/* enable interrupts */
 	adv7511_set_isr(sd, true);
 
@@ -1183,6 +1477,8 @@ static void adv7511_notify_no_edid(struct v4l2_subdev *sd)
 	/* We failed to read the EDID, so send an event for this. */
 	ed.present = false;
 	ed.segment = adv7511_rd(sd, 0xc4);
+	ed.phys_addr = CEC_PHYS_ADDR_INVALID;
+	cec_s_phys_addr(state->cec_adap, ed.phys_addr, false);
 	v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
 	v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, 0x0);
 }
@@ -1406,13 +1702,16 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 
 		v4l2_dbg(1, debug, sd, "%s: edid complete with %d segment(s)\n", __func__, state->edid.segments);
 		state->edid.complete = true;
-
+		ed.phys_addr = cec_get_edid_phys_addr(state->edid.data,
+						      state->edid.segments * 256,
+						      NULL);
 		/* report when we have all segments
 		   but report only for segment 0
 		 */
 		ed.present = true;
 		ed.segment = 0;
 		state->edid_detect_counter++;
+		cec_s_phys_addr(state->cec_adap, ed.phys_addr, false);
 		v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
 		return ed.present;
 	}
@@ -1420,17 +1719,43 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 	return false;
 }
 
+static int adv7511_registered(struct v4l2_subdev *sd)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	int err;
+
+	err = cec_register_adapter(state->cec_adap);
+	if (err)
+		cec_delete_adapter(state->cec_adap);
+	return err;
+}
+
+static void adv7511_unregistered(struct v4l2_subdev *sd)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	cec_unregister_adapter(state->cec_adap);
+}
+
+static const struct v4l2_subdev_internal_ops adv7511_int_ops = {
+	.registered = adv7511_registered,
+	.unregistered = adv7511_unregistered,
+};
+
 /* ----------------------------------------------------------------------- */
 /* Setup ADV7511 */
 static void adv7511_init_setup(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	struct adv7511_state_edid *edid = &state->edid;
+	u32 cec_clk = state->pdata.cec_clk;
+	u8 ratio;
 
 	v4l2_dbg(1, debug, sd, "%s\n", __func__);
 
 	/* clear all interrupts */
 	adv7511_wr(sd, 0x96, 0xff);
+	adv7511_wr(sd, 0x97, 0xff);
 	/*
 	 * Stop HPD from resetting a lot of registers.
 	 * It might leave the chip in a partly un-initialized state,
@@ -1442,6 +1767,25 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)
 	adv7511_set_isr(sd, false);
 	adv7511_s_stream(sd, false);
 	adv7511_s_audio_stream(sd, false);
+
+	if (state->i2c_cec == NULL)
+		return;
+
+	v4l2_dbg(1, debug, sd, "%s: cec_clk %d\n", __func__, cec_clk);
+
+	/* cec soft reset */
+	adv7511_cec_write(sd, 0x50, 0x01);
+	adv7511_cec_write(sd, 0x50, 0x00);
+
+	/* legacy mode */
+	adv7511_cec_write(sd, 0x4a, 0x00);
+
+	if (cec_clk % 750000 != 0)
+		v4l2_err(sd, "%s: cec_clk %d, not multiple of 750 Khz\n",
+			 __func__, cec_clk);
+
+	ratio = (cec_clk / 750000) - 1;
+	adv7511_cec_write(sd, 0x4e, ratio << 2);
 }
 
 static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -1476,6 +1820,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 			 client->addr << 1);
 
 	v4l2_i2c_subdev_init(sd, client, &adv7511_ops);
+	sd->internal_ops = &adv7511_int_ops;
 
 	hdl = &state->hdl;
 	v4l2_ctrl_handler_init(hdl, 10);
@@ -1516,26 +1861,47 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	chip_id[0] = adv7511_rd(sd, 0xf5);
 	chip_id[1] = adv7511_rd(sd, 0xf6);
 	if (chip_id[0] != 0x75 || chip_id[1] != 0x11) {
-		v4l2_err(sd, "chip_id != 0x7511, read 0x%02x%02x\n", chip_id[0], chip_id[1]);
+		v4l2_err(sd, "chip_id != 0x7511, read 0x%02x%02x\n", chip_id[0],
+			 chip_id[1]);
 		err = -EIO;
 		goto err_entity;
 	}
 
-	state->i2c_edid = i2c_new_dummy(client->adapter, state->i2c_edid_addr >> 1);
+	state->i2c_edid = i2c_new_dummy(client->adapter,
+					state->i2c_edid_addr >> 1);
 	if (state->i2c_edid == NULL) {
 		v4l2_err(sd, "failed to register edid i2c client\n");
 		err = -ENOMEM;
 		goto err_entity;
 	}
 
+	adv7511_wr(sd, 0xe1, state->i2c_cec_addr);
+	if (state->pdata.cec_clk < 3000000 ||
+	    state->pdata.cec_clk > 100000000) {
+		v4l2_err(sd, "%s: cec_clk %u outside range, disabling cec\n",
+				__func__, state->pdata.cec_clk);
+		state->pdata.cec_clk = 0;
+	}
+
+	if (state->pdata.cec_clk) {
+		state->i2c_cec = i2c_new_dummy(client->adapter,
+					       state->i2c_cec_addr >> 1);
+		if (state->i2c_cec == NULL) {
+			v4l2_err(sd, "failed to register cec i2c client\n");
+			goto err_unreg_edid;
+		}
+		adv7511_wr(sd, 0xe2, 0x00); /* power up cec section */
+	} else {
+		adv7511_wr(sd, 0xe2, 0x01); /* power down cec section */
+	}
+
 	state->i2c_pktmem = i2c_new_dummy(client->adapter, state->i2c_pktmem_addr >> 1);
 	if (state->i2c_pktmem == NULL) {
 		v4l2_err(sd, "failed to register pktmem i2c client\n");
 		err = -ENOMEM;
-		goto err_unreg_edid;
+		goto err_unreg_cec;
 	}
 
-	adv7511_wr(sd, 0xe2, 0x01); /* power down cec section */
 	state->work_queue = create_singlethread_workqueue(sd->name);
 	if (state->work_queue == NULL) {
 		v4l2_err(sd, "could not create workqueue\n");
@@ -1546,6 +1912,19 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	INIT_DELAYED_WORK(&state->edid_handler, adv7511_edid_handler);
 
 	adv7511_init_setup(sd);
+
+#if IS_ENABLED(CONFIG_VIDEO_ADV7511_CEC)
+	state->cec_adap = cec_allocate_adapter(&adv7511_cec_adap_ops,
+		state, dev_name(&client->dev), CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC,
+		ADV7511_MAX_ADDRS, &client->dev);
+	err = PTR_ERR_OR_ZERO(state->cec_adap);
+	if (err) {
+		destroy_workqueue(state->work_queue);
+		goto err_unreg_pktmem;
+	}
+#endif
+
 	adv7511_set_isr(sd, true);
 	adv7511_check_monitor_present_status(sd);
 
@@ -1555,6 +1934,9 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 
 err_unreg_pktmem:
 	i2c_unregister_device(state->i2c_pktmem);
+err_unreg_cec:
+	if (state->i2c_cec)
+		i2c_unregister_device(state->i2c_cec);
 err_unreg_edid:
 	i2c_unregister_device(state->i2c_edid);
 err_entity:
@@ -1576,9 +1958,12 @@ static int adv7511_remove(struct i2c_client *client)
 	v4l2_dbg(1, debug, sd, "%s removed @ 0x%x (%s)\n", client->name,
 		 client->addr << 1, client->adapter->name);
 
+	adv7511_set_isr(sd, false);
 	adv7511_init_setup(sd);
 	cancel_delayed_work(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
+	if (state->i2c_cec)
+		i2c_unregister_device(state->i2c_cec);
 	i2c_unregister_device(state->i2c_pktmem);
 	destroy_workqueue(state->work_queue);
 	v4l2_device_unregister_subdev(sd);
diff --git a/include/media/i2c/adv7511.h b/include/media/i2c/adv7511.h
index d83b91d..61c3d71 100644
--- a/include/media/i2c/adv7511.h
+++ b/include/media/i2c/adv7511.h
@@ -32,11 +32,7 @@ struct adv7511_monitor_detect {
 struct adv7511_edid_detect {
 	int present;
 	int segment;
-};
-
-struct adv7511_cec_arg {
-	void *arg;
-	u32 f_flags;
+	uint16_t phys_addr;
 };
 
 struct adv7511_platform_data {
-- 
2.8.1

