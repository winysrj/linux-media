Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:35816 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751323AbdH3OlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 10:41:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] tc358743: add CEC support
Date: Wed, 30 Aug 2017 16:41:22 +0200
Message-Id: <20170830144122.29054-3-hverkuil@xs4all.nl>
In-Reply-To: <20170830144122.29054-1-hverkuil@xs4all.nl>
References: <20170830144122.29054-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support for the tc358743 HDMI-CSI bridge.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig    |   8 ++
 drivers/media/i2c/tc358743.c | 196 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 198 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 94153895fcd4..47113774a297 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -354,6 +354,14 @@ config VIDEO_TC358743
 	  To compile this driver as a module, choose M here: the
 	  module will be called tc358743.
 
+config VIDEO_TC358743_CEC
+	bool "Enable Toshiba TC358743 CEC support"
+	depends on VIDEO_TC358743
+	select CEC_CORE
+	---help---
+	  When selected the tc358743 will support the optional
+	  HDMI CEC feature.
+
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab..1629d5b1e8c2 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -39,6 +39,7 @@
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
 #include <linux/hdmi.h>
+#include <media/cec.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -63,6 +64,7 @@ MODULE_LICENSE("GPL");
 
 #define I2C_MAX_XFER_SIZE  (EDID_BLOCK_SIZE + 2)
 
+#define POLL_INTERVAL_CEC_MS	10
 #define POLL_INTERVAL_MS	1000
 
 static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
@@ -106,6 +108,8 @@ struct tc358743_state {
 	u8 csi_lanes_in_use;
 
 	struct gpio_desc *reset_gpio;
+
+	struct cec_adapter *cec_adap;
 };
 
 static void tc358743_enable_interrupts(struct v4l2_subdev *sd,
@@ -595,6 +599,7 @@ static void tc358743_set_ref_clk(struct v4l2_subdev *sd)
 	struct tc358743_platform_data *pdata = &state->pdata;
 	u32 sys_freq;
 	u32 lockdet_ref;
+	u32 cec_freq;
 	u16 fh_min;
 	u16 fh_max;
 
@@ -626,6 +631,15 @@ static void tc358743_set_ref_clk(struct v4l2_subdev *sd)
 	i2c_wr8_and_or(sd, NCO_F0_MOD, ~MASK_NCO_F0_MOD,
 			(pdata->refclk_hz == 27000000) ?
 			MASK_NCO_F0_MOD_27MHZ : 0x0);
+
+	/*
+	 * Trial and error suggests that the default register value
+	 * of 656 is for a 42 MHz reference clock. Use that to derive
+	 * a new value based on the actual reference clock.
+	 */
+	cec_freq = (656 * sys_freq) / 4200;
+	i2c_wr16(sd, CECHCLK, cec_freq);
+	i2c_wr16(sd, CECLCLK, cec_freq);
 }
 
 static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
@@ -814,11 +828,17 @@ static void tc358743_initial_setup(struct v4l2_subdev *sd)
 	struct tc358743_state *state = to_state(sd);
 	struct tc358743_platform_data *pdata = &state->pdata;
 
-	/* CEC and IR are not supported by this driver */
-	i2c_wr16_and_or(sd, SYSCTL, ~(MASK_CECRST | MASK_IRRST),
-			(MASK_CECRST | MASK_IRRST));
+	/*
+	 * IR is not supported by this driver.
+	 * CEC is only enabled if needed.
+	 */
+	i2c_wr16_and_or(sd, SYSCTL, ~(MASK_IRRST | MASK_CECRST),
+				     (MASK_IRRST | MASK_CECRST));
 
 	tc358743_reset(sd, MASK_CTXRST | MASK_HDMIRST);
+#ifdef CONFIG_VIDEO_TC358743_CEC
+	tc358743_reset(sd, MASK_CECRST);
+#endif
 	tc358743_sleep_mode(sd, false);
 
 	i2c_wr16(sd, FIFOCTL, pdata->fifo_level);
@@ -842,6 +862,133 @@ static void tc358743_initial_setup(struct v4l2_subdev *sd)
 	i2c_wr8(sd, VOUT_SET3, MASK_VOUT_EXTCNT);
 }
 
+/* --------------- CEC --------------- */
+
+#ifdef CONFIG_VIDEO_TC358743_CEC
+static int tc358743_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct tc358743_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+
+	i2c_wr32(sd, CECIMSK, enable ? MASK_CECTIM | MASK_CECRIM : 0);
+	i2c_wr32(sd, CECICLR, MASK_CECTICLR | MASK_CECRICLR);
+	i2c_wr32(sd, CECEN, enable);
+	if (enable)
+		i2c_wr32(sd, CECREN, MASK_CECREN);
+	return 0;
+}
+
+static int tc358743_cec_adap_monitor_all_enable(struct cec_adapter *adap,
+						bool enable)
+{
+	struct tc358743_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	u32 reg;
+
+	reg = i2c_rd32(sd, CECRCTL1);
+	if (enable)
+		reg |= MASK_CECOTH;
+	else
+		reg &= ~MASK_CECOTH;
+	i2c_wr32(sd, CECRCTL1, reg);
+	return 0;
+}
+
+static int tc358743_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct tc358743_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int la = 0;
+
+	if (log_addr != CEC_LOG_ADDR_INVALID) {
+		la = i2c_rd32(sd, CECADD);
+		la |= 1 << log_addr;
+	}
+	i2c_wr32(sd, CECADD, la);
+	return 0;
+}
+
+static int tc358743_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time, struct cec_msg *msg)
+{
+	struct tc358743_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int i;
+
+	i2c_wr32(sd, CECTCTL,
+		 (cec_msg_is_broadcast(msg) ? MASK_CECBRD : 0) |
+		 (signal_free_time - 1));
+	for (i = 0; i < msg->len; i++)
+		i2c_wr32(sd, CECTBUF1 + i * 4,
+			msg->msg[i] | ((i == msg->len - 1) ? MASK_CECTEOM : 0));
+	i2c_wr32(sd, CECTEN, MASK_CECTEN);
+	return 0;
+}
+
+static const struct cec_adap_ops tc358743_cec_adap_ops = {
+	.adap_enable = tc358743_cec_adap_enable,
+	.adap_log_addr = tc358743_cec_adap_log_addr,
+	.adap_transmit = tc358743_cec_adap_transmit,
+	.adap_monitor_all_enable = tc358743_cec_adap_monitor_all_enable,
+};
+
+static void tc358743_cec_isr(struct v4l2_subdev *sd, u16 intstatus,
+			     bool *handled)
+{
+	struct tc358743_state *state = to_state(sd);
+	unsigned int cec_rxint, cec_txint;
+	unsigned int clr = 0;
+
+	cec_rxint = i2c_rd32(sd, CECRSTAT);
+	cec_txint = i2c_rd32(sd, CECTSTAT);
+
+	if (intstatus & MASK_CEC_RINT)
+		clr |= MASK_CECRICLR;
+	if (intstatus & MASK_CEC_TINT)
+		clr |= MASK_CECTICLR;
+	i2c_wr32(sd, CECICLR, clr);
+
+	if ((intstatus & MASK_CEC_TINT) && cec_txint) {
+		if (cec_txint & MASK_CECTIEND)
+			cec_transmit_attempt_done(state->cec_adap,
+						  CEC_TX_STATUS_OK);
+		else if (cec_txint & MASK_CECTIAL)
+			cec_transmit_attempt_done(state->cec_adap,
+						  CEC_TX_STATUS_ARB_LOST);
+		else if (cec_txint & MASK_CECTIACK)
+			cec_transmit_attempt_done(state->cec_adap,
+						  CEC_TX_STATUS_NACK);
+		else if (cec_txint & MASK_CECTIUR) {
+			/*
+			 * Not sure when this bit is set. Treat
+			 * it as an error for now.
+			 */
+			cec_transmit_attempt_done(state->cec_adap,
+						  CEC_TX_STATUS_ERROR);
+		}
+		*handled = true;
+	}
+	if ((intstatus & MASK_CEC_RINT) &&
+	    (cec_rxint & MASK_CECRIEND)) {
+		struct cec_msg msg = {};
+		unsigned int i;
+		unsigned int v;
+
+		v = i2c_rd32(sd, CECRCTR);
+		msg.len = v & 0x1f;
+		for (i = 0; i < msg.len; i++) {
+			v = i2c_rd32(sd, CECRBUF1 + i * 4);
+			msg.msg[i] = v & 0xff;
+		}
+		cec_received_msg(state->cec_adap, &msg);
+		*handled = true;
+	}
+	i2c_wr16(sd, INTSTATUS,
+		 intstatus & (MASK_CEC_RINT | MASK_CEC_TINT));
+}
+
+#endif
+
 /* --------------- IRQ --------------- */
 
 static void tc358743_format_change(struct v4l2_subdev *sd)
@@ -1296,6 +1443,15 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 		intstatus &= ~MASK_HDMI_INT;
 	}
 
+#ifdef CONFIG_VIDEO_TC358743_CEC
+	if (intstatus & (MASK_CEC_RINT | MASK_CEC_TINT)) {
+		tc358743_cec_isr(sd, intstatus, handled);
+		i2c_wr16(sd, INTSTATUS,
+			 intstatus & (MASK_CEC_RINT | MASK_CEC_TINT));
+		intstatus &= ~(MASK_CEC_RINT | MASK_CEC_TINT);
+	}
+#endif
+
 	if (intstatus & MASK_CSI_INT) {
 		u32 csi_int = i2c_rd32(sd, CSI_INT);
 
@@ -1328,10 +1484,15 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 static void tc358743_irq_poll_timer(unsigned long arg)
 {
 	struct tc358743_state *state = (struct tc358743_state *)arg;
+	unsigned int msecs;
 
 	schedule_work(&state->work_i2c_poll);
-
-	mod_timer(&state->timer, jiffies + msecs_to_jiffies(POLL_INTERVAL_MS));
+	/*
+	 * If CEC is present, then we need to poll more frequently,
+	 * otherwise we will miss CEC messages.
+	 */
+	msecs = state->cec_adap ? POLL_INTERVAL_CEC_MS : POLL_INTERVAL_MS;
+	mod_timer(&state->timer, jiffies + msecs_to_jiffies(msecs));
 }
 
 static void tc358743_work_i2c_poll(struct work_struct *work)
@@ -1867,6 +2028,7 @@ static int tc358743_probe(struct i2c_client *client,
 	struct tc358743_state *state;
 	struct tc358743_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_subdev *sd;
+	u16 irq_mask = MASK_HDMI_MSK | MASK_CSI_MSK;
 	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -1945,6 +2107,17 @@ static int tc358743_probe(struct i2c_client *client,
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
 			tc358743_delayed_work_enable_hotplug);
 
+#ifdef CONFIG_VIDEO_TC358743_CEC
+	state->cec_adap = cec_allocate_adapter(&tc358743_cec_adap_ops,
+		state, dev_name(&client->dev),
+		CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL, CEC_MAX_LOG_ADDRS);
+	if (IS_ERR(state->cec_adap)) {
+		err = state->cec_adap ? PTR_ERR(state->cec_adap) : -ENOMEM;
+		goto err_hdl;
+	}
+	irq_mask |= MASK_CEC_RMSK | MASK_CEC_TMSK;
+#endif
+
 	tc358743_initial_setup(sd);
 
 	tc358743_s_dv_timings(sd, &default_timing);
@@ -1971,8 +2144,17 @@ static int tc358743_probe(struct i2c_client *client,
 		add_timer(&state->timer);
 	}
 
+	err = cec_register_adapter(state->cec_adap, &client->dev);
+	if (err < 0) {
+		pr_err("%s: failed to register the cec device\n", __func__);
+		cec_delete_adapter(state->cec_adap);
+		state->cec_adap = NULL;
+		goto err_work_queues;
+	}
+
 	tc358743_enable_interrupts(sd, tx_5v_power_present(sd));
-	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_MSK | MASK_CSI_MSK) & 0xffff);
+	i2c_wr16(sd, INTMASK, ~irq_mask);
+	cec_s_phys_addr(state->cec_adap, 0, false);
 
 	err = v4l2_ctrl_handler_setup(sd->ctrl_handler);
 	if (err)
@@ -1984,6 +2166,7 @@ static int tc358743_probe(struct i2c_client *client,
 	return 0;
 
 err_work_queues:
+	cec_unregister_adapter(state->cec_adap);
 	if (!state->i2c_client->irq)
 		flush_work(&state->work_i2c_poll);
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
@@ -2004,6 +2187,7 @@ static int tc358743_remove(struct i2c_client *client)
 		flush_work(&state->work_i2c_poll);
 	}
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cec_unregister_adapter(state->cec_adap);
 	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	mutex_destroy(&state->confctl_mutex);
-- 
2.14.1
