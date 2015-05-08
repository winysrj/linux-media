Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51746 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbbEHLNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:13:14 -0400
Message-ID: <554C9A32.5020106@xs4all.nl>
Date: Fri, 08 May 2015 13:12:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v6b 09/11] cec: adv7604: add cec support.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

I've updated this patch so that it uses _clr_set instead of _and_or for the CEC
register access code.

---

Add CEC support to the adv7604 driver.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: add missing methods cec/io_write_and_or]
[k.debski@samsung.com: change adv7604 to adv76xx in added functions]
[hansverk@cisco.com: use _clr_set instead of _and_or]
---
 drivers/media/i2c/adv7604.c | 200 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 199 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c1be0f7..dc1c82a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 
 #include <media/adv7604.h>
+#include <media/cec.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dv-timings.h>
@@ -77,6 +78,8 @@ MODULE_LICENSE("GPL");
 
 #define ADV76XX_OP_SWAP_CB_CR				(1 << 0)
 
+#define ADV76XX_MAX_ADDRS (3)
+
 enum adv76xx_type {
 	ADV7604,
 	ADV7611,
@@ -173,6 +176,10 @@ struct adv76xx_state {
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
@@ -438,7 +445,8 @@ static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_IO, reg, val);
 }
 
-static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask,
+				   u8 val)
 {
 	return io_write(sd, reg, (io_read(sd, reg) & ~mask) | val);
 }
@@ -471,6 +479,12 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_CEC, reg, val);
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
@@ -1884,6 +1898,183 @@ static int adv76xx_set_format(struct v4l2_subdev *sd,
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
+	struct cec_msg msg;
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
+		cec_write_clr_set(sd, 0x27, 0x70, 0x70);
+		/* power down cec section */
+		cec_write_clr_set(sd, 0x2a, 0x01, 0x00);
+		state->cec_valid_addrs = 0;
+	}
+	state->cec_enabled_adap = enable;
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
+		cec_write_and_or(sd, 0x27, 0x20, 0x20);
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
+static int adv76xx_cec_transmit(struct v4l2_subdev *sd, struct cec_msg *msg)
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
+static void adv76xx_cec_transmit_timed_out(struct v4l2_subdev *sd)
+{
+	cec_write_clr_set(sd, 0x11, 0x01, 0);  /* disable tx */
+}
+
 static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -1929,6 +2120,9 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 
+	/* cec */
+	adv76xx_cec_isr(sd, handled);
+
 	/* tx 5v detect */
 	tx_5v = io_read(sd, 0x70) & info->cable_det_mask;
 	if (tx_5v) {
@@ -2323,6 +2517,10 @@ static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
 	.s_dv_timings = adv76xx_s_dv_timings,
 	.g_dv_timings = adv76xx_g_dv_timings,
 	.query_dv_timings = adv76xx_query_dv_timings,
+	.cec_enable = adv76xx_cec_enable,
+	.cec_log_addr = adv76xx_cec_log_addr,
+	.cec_transmit = adv76xx_cec_transmit,
+	.cec_transmit_timed_out = adv76xx_cec_transmit_timed_out,
 };
 
 static const struct v4l2_subdev_pad_ops adv76xx_pad_ops = {
-- 
2.1.4

