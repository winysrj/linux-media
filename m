Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:25057 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbHRIjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:00 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 13/15] cec: adv7511: add cec support.
Date: Tue, 18 Aug 2015 10:26:38 +0200
Message-Id: <3fc0c8f557f5d775e2ecbbba282daab569770b1f.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC support to the adv7511 driver.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 359 +++++++++++++++++++++++++++++++++++++++++++-
 include/media/adv7511.h     |   6 +-
 2 files changed, 353 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index e4900df..645d4ba 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -33,6 +33,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/adv7511.h>
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
@@ -90,12 +93,19 @@ struct adv7511_state {
 	struct v4l2_ctrl_handler hdl;
 	int chip_revision;
 	u8 i2c_edid_addr;
-	u8 i2c_cec_addr;
 	u8 i2c_pktmem_addr;
+	u8 i2c_cec_addr;
+
+	struct i2c_client *i2c_cec;
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
@@ -225,7 +235,7 @@ static int adv_smbus_read_i2c_block_data(struct i2c_client *client,
 	return ret;
 }
 
-static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
+static void adv7511_edid_rd(struct v4l2_subdev *sd, uint16_t len, uint8_t *buf)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	int i;
@@ -240,6 +250,34 @@ static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
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
@@ -413,16 +451,28 @@ static const struct v4l2_ctrl_ops adv7511_ctrl_ops = {
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
@@ -433,10 +483,18 @@ static int adv7511_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
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
@@ -524,6 +582,7 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	struct adv7511_state_edid *edid = &state->edid;
+	int i;
 
 	static const char * const states[] = {
 		"in reset",
@@ -593,7 +652,23 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
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
@@ -651,15 +726,138 @@ static int adv7511_s_power(struct v4l2_subdev *sd, int on)
 	return true;
 }
 
+static unsigned adv7511_cec_available_log_addrs(struct v4l2_subdev *sd)
+{
+	return ADV7511_MAX_ADDRS;
+}
+
+static int adv7511_cec_enable(struct v4l2_subdev *sd, bool enable)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
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
+static int adv7511_cec_log_addr(struct v4l2_subdev *sd, u8 addr)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	unsigned i, free_idx = ADV7511_MAX_ADDRS;
+
+	if (!state->cec_enabled_adap)
+		return -EIO;
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
+static int adv7511_cec_transmit(struct v4l2_subdev *sd, u32 timeout_ms, struct cec_msg *msg)
+{
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
@@ -667,6 +865,9 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 	else if (adv7511_have_hotplug(sd))
 		irqs |= MASK_ADV7511_EDID_RDY_INT;
 
+	if (state->cec_enabled_adap)
+		adv7511_wr_and_or(sd, 0x95, 0xc0, enable ? 0x39 : 0x00);
+
 	/*
 	 * This i2c write can fail (approx. 1 in 1000 writes). But it
 	 * is essential that this register is correct, so retry it
@@ -685,24 +886,82 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 	v4l2_err(sd, "Could not set interrupts: hw failure?\n");
 }
 
+static void adv_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
+{
+	if ((adv7511_cec_read(sd, 0x11) & 0x01) == 0) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: tx disabled\n", __func__);
+		return;
+	}
+
+	if (tx_raw_status & 0x10) {
+		v4l2_dbg(1, debug, sd,
+			 "%s: tx raw: arbitration lost\n", __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_ARB_LOST);
+		return;
+	}
+	if (tx_raw_status & 0x08) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: retry failed\n", __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_RETRY_TIMEOUT);
+		return;
+	}
+	if (tx_raw_status & 0x20) {
+		v4l2_dbg(1, debug, sd, "%s: tx raw: ready ok\n", __func__);
+		v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_TX_DONE,
+				   (void *)CEC_TX_STATUS_OK);
+		return;
+	}
+}
+
 /* Interrupt handler */
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
 
+	if (cec_irq & 0x38)
+		adv_cec_tx_raw_status(sd, cec_irq);
+
+	if (cec_irq & 1) {
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
+			v4l2_subdev_notify(sd, V4L2_SUBDEV_CEC_RX_MSG, &msg);
+		}
+	}
+
 	/* enable interrupts */
 	adv7511_set_isr(sd, true);
 
@@ -806,6 +1065,10 @@ static const struct v4l2_subdev_video_ops adv7511_video_ops = {
 	.s_stream = adv7511_s_stream,
 	.s_dv_timings = adv7511_s_dv_timings,
 	.g_dv_timings = adv7511_g_dv_timings,
+	.cec_available_log_addrs = adv7511_cec_available_log_addrs,
+	.cec_enable = adv7511_cec_enable,
+	.cec_log_addr = adv7511_cec_log_addr,
+	.cec_transmit = adv7511_cec_transmit,
 };
 
 /* ------------------------------ AUDIO OPS ------------------------------ */
@@ -1193,6 +1456,7 @@ static void adv7511_edid_handler(struct work_struct *work)
 	/* We failed to read the EDID, so send an event for this. */
 	ed.present = false;
 	ed.segment = adv7511_rd(sd, 0xc4);
+	ed.phys_addr = 0xffff;
 	v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
 	v4l2_dbg(1, debug, sd, "%s: no edid found\n", __func__);
 }
@@ -1333,10 +1597,36 @@ static bool edid_verify_header(struct v4l2_subdev *sd, u32 segment)
 	return !memcmp(data, hdmi_header, sizeof(hdmi_header));
 }
 
+static int get_edid_spa_location(const u8 *edid)
+{
+	u8 d;
+
+	if (edid[0x7e] != 1 || edid[0x80] != 0x02 || edid[0x81] != 0x03)
+		return -1;
+
+	/* search Vendor Specific Data Block (tag 3) */
+	d = edid[0x82] & 0x7f;
+	if (d > 4) {
+		int i = 0x84;
+		int end = 0x80 + d;
+
+		do {
+			u8 tag = edid[i] >> 5;
+			u8 len = edid[i] & 0x1f;
+
+			if (tag == 3 && len >= 5)
+				return i + 4;
+			i += len + 1;
+		} while (i < end);
+	}
+	return -1;
+}
+
 static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	u8 edidRdy = adv7511_rd(sd, 0xc5);
+	int offset;
 
 	v4l2_dbg(1, debug, sd, "%s: edid ready (retries: %d)\n",
 			 __func__, EDID_MAX_RETRIES - state->edid.read_retries);
@@ -1382,6 +1672,12 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 
 		v4l2_dbg(1, debug, sd, "%s: edid complete with %d segment(s)\n", __func__, state->edid.segments);
 		state->edid.complete = true;
+		offset = get_edid_spa_location(state->edid.data);
+		if (offset > 0)
+			ed.phys_addr = (state->edid.data[offset] << 8) |
+					state->edid.data[offset + 1];
+		else
+			ed.phys_addr = 0xffff;
 
 		/* report when we have all segments
 		   but report only for segment 0
@@ -1403,11 +1699,14 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)
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
@@ -1419,6 +1718,25 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)
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
@@ -1495,26 +1813,47 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
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
@@ -1534,6 +1873,9 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 
 err_unreg_pktmem:
 	i2c_unregister_device(state->i2c_pktmem);
+err_unreg_cec:
+	if (state->i2c_cec)
+		i2c_unregister_device(state->i2c_cec);
 err_unreg_edid:
 	i2c_unregister_device(state->i2c_edid);
 err_entity:
@@ -1555,9 +1897,12 @@ static int adv7511_remove(struct i2c_client *client)
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
diff --git a/include/media/adv7511.h b/include/media/adv7511.h
index d83b91d..61c3d71 100644
--- a/include/media/adv7511.h
+++ b/include/media/adv7511.h
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
2.1.4

