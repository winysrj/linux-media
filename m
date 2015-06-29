Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:57996 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbbF2K0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:26:20 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: [PATCHv7 12/15] adv7842: add cec support
Date: Mon, 29 Jun 2015 12:14:57 +0200
Message-Id: <1435572900-56998-13-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC support to the adv7842 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 211 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 208 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4cf79b2..0ef01bd 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -39,6 +39,7 @@
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
 #include <linux/hdmi.h>
+#include <media/cec.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dv-timings.h>
@@ -78,6 +79,8 @@ MODULE_LICENSE("GPL");
 
 #define ADV7842_OP_SWAP_CB_CR				(1 << 0)
 
+#define ADV7842_MAX_ADDRS (3)
+
 /*
 **********************************************************************
 *
@@ -141,6 +144,10 @@ struct adv7842_state {
 	struct v4l2_ctrl *free_run_color_ctrl_manual;
 	struct v4l2_ctrl *free_run_color_ctrl;
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
+
+	u8   cec_addr[ADV7842_MAX_ADDRS];
+	u8   cec_valid_addrs;
+	bool cec_enabled_adap;
 };
 
 /* Unsupported timings. This device cannot support 720p30. */
@@ -417,9 +424,9 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_cec, reg, val);
 }
 
-static inline int cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return cec_write(sd, reg, (cec_read(sd, reg) & mask) | val);
+	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
 }
 
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
@@ -2157,6 +2164,185 @@ static void adv7842_irq_enable(struct v4l2_subdev *sd, bool enable)
 	}
 }
 
+static void adv7842_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
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
+static void adv7842_cec_isr(struct v4l2_subdev *sd, bool *handled)
+{
+	struct cec_msg msg;
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
+static unsigned adv7842_cec_available_log_addrs(struct v4l2_subdev *sd)
+{
+	return ADV7842_MAX_ADDRS;
+}
+
+static int adv7842_cec_enable(struct v4l2_subdev *sd, bool enable)
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
+static int adv7842_cec_log_addr(struct v4l2_subdev *sd, u8 addr)
+{
+	struct adv7842_state *state = to_state(sd);
+	unsigned i, free_idx = ADV7842_MAX_ADDRS;
+
+	if (!state->cec_enabled_adap)
+		return -EIO;
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
+static int adv7842_cec_transmit(struct v4l2_subdev *sd, struct cec_msg *msg)
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
+	/* For some reason sometimes the
+	 * transmit won't start.
+	 * Doing it twice seems to help ?
+	*/
+	cec_write(sd, 0x11, 0x01);
+	return 0;
+}
+
+static void adv7842_cec_transmit_timed_out(struct v4l2_subdev *sd)
+{
+	cec_write_clr_set(sd, 0x11, 0x01, 0);  /* disable tx */
+}
+
 static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -2229,6 +2415,9 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+	/* cec */
+	adv7842_cec_isr(sd, handled);
+
 	/* tx 5v detect */
 	if (irq_status[2] & 0x3) {
 		v4l2_dbg(1, debug, sd, "%s: irq tx_5v\n", __func__);
@@ -2497,8 +2686,19 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
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
@@ -3030,6 +3230,11 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 	.s_dv_timings = adv7842_s_dv_timings,
 	.g_dv_timings = adv7842_g_dv_timings,
 	.query_dv_timings = adv7842_query_dv_timings,
+	.cec_available_log_addrs = adv7842_cec_available_log_addrs,
+	.cec_enable = adv7842_cec_enable,
+	.cec_log_addr = adv7842_cec_log_addr,
+	.cec_transmit = adv7842_cec_transmit,
+	.cec_transmit_timed_out = adv7842_cec_transmit_timed_out,
 };
 
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
-- 
2.1.4

