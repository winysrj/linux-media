Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56119 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbcCRKdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 06:33:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Armin Weiss <weii@zhaw.ch>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/2] tc358840: add CEC support
Date: Fri, 18 Mar 2016 11:32:52 +0100
Message-Id: <1458297172-31867-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458297172-31867-1-git-send-email-hverkuil@xs4all.nl>
References: <1458297172-31867-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig         |   2 +-
 drivers/media/i2c/tc358840.c      | 212 +++++++++++++++++++++++++--
 drivers/media/i2c/tc358840_regs.h | 301 ++++++++++++++++++++++++--------------
 3 files changed, 396 insertions(+), 119 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 1fd6057..3243218 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -309,7 +309,7 @@ config VIDEO_TC358743
 
 config VIDEO_TC358840
 	tristate "Toshiba TC358840 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CEC
 	select HDMI
 	---help---
 	  Support for the Toshiba TC358840 HDMI to MIPI CSI-2 bridge.
diff --git a/drivers/media/i2c/tc358840.c b/drivers/media/i2c/tc358840.c
index 5ce7155..3d5ff98 100644
--- a/drivers/media/i2c/tc358840.c
+++ b/drivers/media/i2c/tc358840.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-of.h>
+#include <media/cec.h>
 
 #include <media/i2c/tc358840.h>
 #include "tc358840_regs.h"
@@ -74,6 +75,7 @@ struct tc358840_state {
 	struct media_pad pad[2];
 	struct v4l2_ctrl_handler hdl;
 	struct i2c_client *i2c_client;
+	struct cec_adapter *cec_adap;
 	bool enabled;
 
 	/* controls */
@@ -694,6 +696,7 @@ static void tc358840_set_ref_clk(struct v4l2_subdev *sd)
 
 	u32 sys_freq;
 	u32 lock_ref_freq;
+	u32 cec_freq;
 	u32 nco;
 	u16 csc;
 
@@ -723,6 +726,15 @@ static void tc358840_set_ref_clk(struct v4l2_subdev *sd)
 	csc = pdata->refclk_hz / 10000;
 	i2c_wr8(sd, SCLK_CSC0, csc & 0xFF);
 	i2c_wr8(sd, SCLK_CSC1, (csc >> 8) & 0xFF);
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
 
 static void tc358840_set_csi_mbus_config(struct v4l2_subdev *sd)
@@ -1051,6 +1063,99 @@ static void tc358840_initial_setup(struct v4l2_subdev *sd)
 	i2c_wr8_and_or(sd, VI_MODE, ~MASK_RGB_DVI, 0);
 }
 
+/* --------------- CEC --------------- */
+
+static int tc358840_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct tc358840_state *state = adap->priv;
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
+static int tc358840_cec_adap_monitor_all_enable(struct cec_adapter *adap,
+						bool enable)
+{
+	struct tc358840_state *state = adap->priv;
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
+static int tc358840_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned la = 0;
+
+	if (log_addr != CEC_LOG_ADDR_INVALID) {
+		la = i2c_rd32(sd, CECADD);
+		la |= 1 << log_addr;
+	}
+	i2c_wr32(sd, CECADD, la);
+	return 0;
+}
+
+static int tc358840_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time, struct cec_msg *msg)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned i;
+
+	i2c_wr32(sd, CECTCTL,
+		 (cec_msg_is_broadcast(msg) ? MASK_CECBRD : 0) |
+		 (signal_free_time - 1));
+	for (i = 0; i < msg->len; i++)
+		i2c_wr32(sd, CECTBUF1 + i * 4,
+			 msg->msg[i] | ((i == msg->len - 1) ? MASK_CECTEOM : 0));
+	i2c_wr32(sd, CECTEN, MASK_CECTEN);
+	return 0;
+}
+
+static int tc358840_received(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_msg reply;
+	u16 pa;
+
+	cec_msg_init(&reply, adap->log_addr[0], cec_msg_initiator(msg));
+
+	switch (msg->msg[1]) {
+	case CEC_MSG_SET_STREAM_PATH:
+		if (!adap->is_source)
+			return -ENOMSG;
+		cec_ops_set_stream_path(msg, &pa);
+		if (pa != adap->phys_addr)
+			return -ENOMSG;
+		cec_msg_active_source(&reply, adap->phys_addr);
+		cec_transmit_msg(adap, &reply, false);
+		break;
+	default:
+		return -ENOMSG;
+	}
+	return 0;
+}
+
+static const struct cec_adap_ops tc358840_cec_adap_ops = {
+	.adap_enable = tc358840_cec_adap_enable,
+	.adap_log_addr = tc358840_cec_adap_log_addr,
+	.adap_transmit = tc358840_cec_adap_transmit,
+	.adap_monitor_all_enable = tc358840_cec_adap_monitor_all_enable,
+	.received = tc358840_received,
+};
+
 /* --------------- IRQ --------------- */
 
 static void tc358840_format_change(struct v4l2_subdev *sd)
@@ -1321,6 +1426,7 @@ static void tc358840_hdmi_sys_int_handler(struct v4l2_subdev *sd, bool *handled)
 
 static int tc358840_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
+	struct tc358840_state *state = to_state(sd);
 	u16 intstatus;
 	unsigned retry = 10;
 
@@ -1379,6 +1485,53 @@ retry:
 		}
 	}
 
+	if (intstatus & (MASK_CEC_RINT | MASK_CEC_TINT | MASK_CEC_EINT)) {
+		unsigned cec_rxint, cec_txint;
+
+		cec_rxint = i2c_rd32(sd, CECRSTAT);
+		mdelay(1);
+		cec_txint = i2c_rd32(sd, CECTSTAT);
+		mdelay(1);
+
+		i2c_wr32(sd, CECICLR, MASK_CECTICLR | MASK_CECRICLR);
+		i2c_wr16(sd, INTSTATUS, MASK_CEC_RINT | MASK_CEC_TINT |
+			 MASK_CEC_EINT);
+
+		if ((intstatus & MASK_CEC_RINT) && (cec_rxint & MASK_CECRIEND)) {
+			struct cec_msg msg = {};
+			unsigned i;
+			unsigned v;
+
+			v = i2c_rd32(sd, CECRCTR);
+			msg.len = v & 0x1f;
+			for (i = 0; i < msg.len; i++) {
+				v = i2c_rd32(sd, CECRBUF1 + i * 4);
+				msg.msg[i] = v & 0xff;
+			}
+			cec_received_msg(state->cec_adap, &msg);
+		}
+		if ((intstatus & MASK_CEC_TINT) && cec_txint) {
+			if (cec_txint & MASK_CECTIEND)
+				cec_transmit_done(state->cec_adap,
+					CEC_TX_STATUS_OK, 0, 0, 0, 0);
+			else if (cec_txint & MASK_CECTIAL)
+				cec_transmit_done(state->cec_adap,
+					CEC_TX_STATUS_ARB_LOST, 1, 0, 0, 0);
+			else if (cec_txint & MASK_CECTIACK)
+				cec_transmit_done(state->cec_adap,
+					CEC_TX_STATUS_NACK, 0, 1, 0, 0);
+			else if (cec_txint & MASK_CECTIUR) {
+				/*
+				 * Not sure when this bit is set. Treat it as
+				 * an error for now.
+				 */
+				cec_transmit_done(state->cec_adap,
+					CEC_TX_STATUS_ERROR, 0, 0, 0, 1);
+			}
+		}
+		intstatus &= ~(MASK_CEC_RINT | MASK_CEC_TINT | MASK_CEC_EINT);
+	}
+
 	if (intstatus & MASK_CSITX0_INT) {
 		v4l2_dbg(3, debug, sd, "%s: MASK_CSITX0_INT\n", __func__);
 
@@ -2130,6 +2283,8 @@ static const struct media_entity_operations tc358840_media_ops = {
 static int tc358840_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
+	const u16 irq_mask = MASK_HDMI_INT | MASK_CEC_RINT | MASK_CEC_TINT |
+			     MASK_CEC_EINT;
 	struct tc358840_state *state;
 	struct v4l2_subdev *sd;
 	int err;
@@ -2200,6 +2355,18 @@ static int tc358840_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
+	state->cec_adap = cec_create_adapter(&tc358840_cec_adap_ops,
+		state, client->name,
+		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
+		CEC_CAP_VENDOR_ID,
+		1, &client->dev);
+/*	err = PTR_ERR_OR_ZERO(state->cec_adap);*/
+	if (IS_ERR_OR_NULL(state->cec_adap)) {
+		err = state->cec_adap ? PTR_ERR(state->cec_adap) : -ENOMEM;
+		return err;
+	}
+	state->cec_adap->available_log_addrs = CEC_MAX_LOG_ADDRS;
+
 	/* Control Handlers */
 	v4l2_ctrl_handler_init(&state->hdl, 4);
 
@@ -2257,18 +2424,6 @@ static int tc358840_probe(struct i2c_client *client,
 		}
 	}
 
-	tc358840_enable_interrupts(sd, tx_5v_power_present(sd));
-
-	/*
-	 * FIXME: Don't know what MASK_CSITX0_INT and MASK_CSITX1_INT do.
-	 * Thus, disable them for now...
-	 */
-#if 0
-	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_INT | MASK_CSITX0_INT |
-		MASK_CSITX1_INT) & 0xFFFF);
-#endif
-	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_INT) & 0xFFFF);
-
 	v4l2_ctrl_handler_setup(sd->ctrl_handler);
 
 	v4l2_info(sd, "%s found @ 7h%02X (%s)\n", client->name,
@@ -2288,10 +2443,41 @@ static int tc358840_probe(struct i2c_client *client,
 	}
 #endif
 
+	err = cec_register_adapter(state->cec_adap);
+	if (err < 0) {
+		pr_err("%s: failed to register the cec device\n", __func__);
+		cec_delete_adapter(state->cec_adap);
+		state->cec_adap = NULL;
+		goto err_hdl;
+	}
+	cec_set_phys_addr(state->cec_adap, 0);
+
+	if (tx_5v_power_present(sd))
+		cec_connected_inputs(state->cec_adap, 1);
+	err = cec_enable(state->cec_adap, true);
+	if (err < 0) {
+		pr_err("%s: failed to enable the cec adapter\n", __func__);
+		goto err_cec;
+	}
+
+	tc358840_enable_interrupts(sd, tx_5v_power_present(sd));
+
+	/*
+	 * FIXME: Don't know what MASK_CSITX0_INT and MASK_CSITX1_INT do.
+	 * Thus, disable them for now...
+	 */
+#if 0
+	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_INT | MASK_CSITX0_INT |
+		MASK_CSITX1_INT) & 0xFFFF);
+#endif
+	i2c_wr16(sd, INTMASK, ~irq_mask & 0xFFFF);
+
 	err = v4l2_async_register_subdev(sd);
 	if (err == 0)
 		return 0;
 
+err_cec:
+	cec_unregister_adapter(state->cec_adap);
 err_hdl:
 	v4l2_ctrl_handler_free(&state->hdl);
 	return err;
@@ -2300,12 +2486,14 @@ err_hdl:
 static int tc358840_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tc358840_state *state = to_state(sd);
 
 	v4l_dbg(1, debug, client, "%s()\n", __func__);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&sd->entity);
 #endif
+	cec_unregister_adapter(state->cec_adap);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tc358840_regs.h b/drivers/media/i2c/tc358840_regs.h
index b37f6b1..c375c88 100644
--- a/drivers/media/i2c/tc358840_regs.h
+++ b/drivers/media/i2c/tc358840_regs.h
@@ -22,8 +22,8 @@
 
 /* *** General (16 bit) *** */
 #define CHIPID_ADDR				0x0000
-#define MASK_CHIPID				0xFF00
-#define MASK_REVID				0x00FF
+#define MASK_CHIPID				0xff00
+#define MASK_REVID				0x00ff
 #define TC358840_CHIPID				0x4700
 
 #define SYSCTL					0x0002
@@ -35,7 +35,7 @@
 #define MASK_IRRST				(1 << 11)
 #define MASK_SPLRST				(1 << 12)
 #define MASK_ABRST				(1 << 14)
-#define MASK_RESET_ALL				0x5F80
+#define MASK_RESET_ALL				0x5f80
 
 #define CONFCTL0				0x0004
 #define MASK_VTX0EN				(1 << 0)
@@ -81,7 +81,7 @@
 #define MASK_HDMI_INT				(1 << 9)
 #define MASK_AMUTE_INT				(1 << 10)
 #define MASK_CSITX1_INT				(1 << 11)
-#define MASK_INT_STATUS_MASK_ALL		0x0F3F
+#define MASK_INT_STATUS_MASK_ALL		0x0f3f
 
 /* *** Interrupt and MASKs (8 bit) *** */
 #define HDMI_INT0				0x8500
@@ -184,8 +184,8 @@
 #define MASK_GBD_ACLR				0x40
 #define MASK_GBD_PKERR				0x80
 
-#define MISC_INT				0x850B
-#define MISC_INTM				0x851B
+#define MISC_INT				0x850b
+#define MISC_INTM				0x851b
 #define MASK_AUDIO_MUTE				0x01
 #define MASK_SYNC_CHG				0x02
 #define MASK_NO_VS				0x04
@@ -213,7 +213,7 @@
 #define MASK_S_V_INTERLACE			0x01
 
 #define VI_STATUS3				0x8528
-#define MASK_S_V_COLOR				0x1F
+#define MASK_S_V_COLOR				0x1f
 #define MASK_RGB_FULL				0x00
 #define MASK_RGB_LIMITED			0x01
 #define MASK_YCBCR601_FULL			0x02
@@ -222,14 +222,14 @@
 #define MASK_ADOBE_RGB_LIMITED			0x05
 #define MASK_YCBCR709_FULL			0x06
 #define MASK_YCBCR709_LIMITED			0x07
-#define MASK_XVYCC601_FULL			0x0A
-#define MASK_XVYCC601_LIMITED			0x0B
-#define MASK_XVYCC709_FULL			0x0E
-#define MASK_XVYCC709_LIMITED			0x0F
+#define MASK_XVYCC601_FULL			0x0a
+#define MASK_XVYCC601_LIMITED			0x0b
+#define MASK_XVYCC709_FULL			0x0e
+#define MASK_XVYCC709_LIMITED			0x0f
 #define MASK_SYCC601_FULL			0x12
 #define MASK_SYCC601_LIMITED			0x13
-#define MASK_ADOBE_YCC601_FULL			0x1A
-#define MASK_ADOBE_YCC601_LIMITED		0x1B
+#define MASK_ADOBE_YCC601_FULL			0x1a
+#define MASK_ADOBE_YCC601_LIMITED		0x1b
 #define MASK_LIMITED                            0x01
 
 
@@ -240,7 +240,7 @@
 #define CSITX_CLKEN				0x0108
 #define MASK_CSITX_EN				(1 << 0)
 
-#define PPICLKEN				0x010C
+#define PPICLKEN				0x010c
 #define MASK_HSTXCLKEN				0x00000001
 
 #define MODECONF				0x0110	/* Not in Ref. v1.5 */
@@ -259,7 +259,7 @@
 #define MASK_LANES				0x00000007
 #define MASK_CLANEEN				(1 << 4)
 
-#define CSITX_START				0x011C
+#define CSITX_START				0x011c
 #define LINEINITCNT				0x0120
 #define HSTOCNT					0x0124
 
@@ -286,12 +286,12 @@
 #define CSI_TATO_COUNT				0x0130	/* Not in Ref. v1.5 */
 #define CSI_PRESP_BTA_COUNT			0x0134	/* Not in Ref. v1.5 */
 #define CSI_PRESP_LPR_COUNT			0x0138	/* Not in Ref. v1.5 */
-#define CSI_PRESP_LPW_COUNT			0x013C	/* Not in Ref. v1.5 */
+#define CSI_PRESP_LPW_COUNT			0x013c	/* Not in Ref. v1.5 */
 
 #define HSREADCNT				0x0140	/* Not in Ref. v1.5 */
 #define HSWRITECNT				0x0144	/* Not in Ref. v1.5 */
 #define PERIRSTCNT				0x0148	/* Not in Ref. v1.5 */
-#define LRXHTOCNT				0x014C	/* Not in Ref. v1.5 */
+#define LRXHTOCNT				0x014c	/* Not in Ref. v1.5 */
 
 #define FUNCMODE				0x0150
 #define MASK_CONTCLKMODE			(1 << 5)
@@ -307,19 +307,19 @@
 
 #define HSYNCSTOPCNT				0x0168	/* Not in Ref. v1.5 */
 #define VHDELAY					0x0170	/* Not in Ref. v1.5 */
-#define RX_STATE_INT_MASK			0x01A4	/* Not in Ref. v1.5 */
-#define LPRX_THRESH_COUNT			0x010C	/* Not in Ref. v1.5 */
+#define RX_STATE_INT_MASK			0x01a4	/* Not in Ref. v1.5 */
+#define LPRX_THRESH_COUNT			0x010c	/* Not in Ref. v1.5 */
 #define APPERRMASK				0x0214	/* Not in Ref. v1.5 */
-#define RX_ERR_INT_MASK				0x021C	/* Not in Ref. v1.5 */
+#define RX_ERR_INT_MASK				0x021c	/* Not in Ref. v1.5 */
 #define LPTX_INT_MASK				0x0224	/* Not in Ref. v1.5 */
 
 #define LPTXTIMECNT				0x0254
 #define TCLK_HEADERCNT				0x0258
-#define TCLK_TRAILCNT				0x025C
+#define TCLK_TRAILCNT				0x025c
 #define THS_HEADERCNT				0x0260
 #define TWAKEUP					0x0264
 #define TCLK_POSTCNT				0x0268
-#define THS_TRAILCNT				0x026C
+#define THS_TRAILCNT				0x026c
 #define HSTXVREGCNT				0x0270
 
 #define HSTXVREGEN				0x0274
@@ -330,32 +330,121 @@
 #define MASK_CLM_HSTXVREGEN			0x0001
 
 #define BTA_COUNT				0x0278	/* Not in Ref. v1.5 */
-#define DPHY_TX_ADJUST				0x027C	/* Not in Ref. v1.5 */
+#define DPHY_TX_ADJUST				0x027c	/* Not in Ref. v1.5 */
 
-#define MIPICLKEN				0x02A0
+#define MIPICLKEN				0x02a0
 #define MASK_MP_ENABLE				0x00000001
 #define MASK_MP_CKEN				0x00000002
 
-#define PLLCONF					0x02AC
+#define PLLCONF					0x02ac
 #define MASK_LFBREN				(1 << 9)
 #define MASK_MPLBW				0x00030000
 #define MASK_MPLBW_25				(0 << 16)
 #define MASK_MPLBW_33				(1 << 16)
 #define MASK_MPLBW_50				(2 << 16)
 #define MASK_MPLBW_MAX				(3 << 16)
-#define MASK_PLL_FBD				0x000000FF
+#define MASK_PLL_FBD				0x000000ff
 #define SET_PLL_FBD(fbd)			(((fbd) - 1) & MASK_PLL_FBD)
-#define MASK_PLL_FRS				0x00000C00
+#define MASK_PLL_FRS				0x00000c00
 #define SET_PLL_FRS(frs)			(((frs) << 10) & MASK_PLL_FRS)
-#define MASK_PLL_PRD				0x0000F000
+#define MASK_PLL_PRD				0x0000f000
 #define SET_PLL_PRD(prd)			((((prd) - 1) << 12) & \
 						  MASK_PLL_PRD)
 #define MASK_PLL_LBW				0x00030000
 #define SET_PLL_LBW(lbw)			((((lbw) - 1) << 16) & \
 						  MASK_PLL_LBW)
 
-#define CECEN                                 0x0600
-#define MASK_CECEN                            0x0001
+/* *** CEC (32 bit) *** */
+#define CECHCLK					0x0028	/* 16 bits */
+#define MASK_CECHCLK				(0x7ff << 0)
+
+#define CECLCLK					0x002a	/* 16 bits */
+#define MASK_CECLCLK				(0x7ff << 0)
+
+#define CECEN					0x0600
+#define MASK_CECEN				0x0001
+
+#define CECADD					0x0604
+#define CECRST					0x0608
+#define MASK_CECRESET				0x0001
+
+#define CECREN					0x060c
+#define MASK_CECREN				0x0001
+
+#define CECRCTL1				0x0614
+#define MASK_CECACKDIS				(1 << 24)
+#define MASK_CECHNC				(3 << 20)
+#define MASK_CECLNC				(7 << 16)
+#define MASK_CECMIN				(7 << 12)
+#define MASK_CECMAX				(7 << 8)
+#define MASK_CECDAT				(7 << 4)
+#define MASK_CECTOUT				(3 << 2)
+#define MASK_CECRIHLD				(1 << 1)
+#define MASK_CECOTH				(1 << 0)
+
+#define CECRCTL2				0x0618
+#define MASK_CECSWAV3				(7 << 12)
+#define MASK_CECSWAV2				(7 << 8)
+#define MASK_CECSWAV1				(7 << 4)
+#define MASK_CECSWAV0				(7 << 0)
+
+#define CECRCTL3				0x061c
+#define MASK_CECWAV3				(7 << 20)
+#define MASK_CECWAV2				(7 << 16)
+#define MASK_CECWAV1				(7 << 12)
+#define MASK_CECWAV0				(7 << 8)
+#define MASK_CECACKEI				(1 << 4)
+#define MASK_CECMINEI				(1 << 3)
+#define MASK_CECMAXEI				(1 << 2)
+#define MASK_CECRSTEI				(1 << 1)
+#define MASK_CECWAVEI				(1 << 0)
+
+#define CECTEN					0x0620
+#define MASK_CECTBUSY				(1 << 1)
+#define MASK_CECTEN				(1 << 0)
+
+#define CECTCTL					0x0628
+#define MASK_CECSTRS				(7 << 20)
+#define MASK_CECSPRD				(7 << 16)
+#define MASK_CECDTRS				(7 << 12)
+#define MASK_CECDPRD				(15 << 8)
+#define MASK_CECBRD				(1 << 4)
+#define MASK_CECFREE				(15 << 0)
+
+#define CECRSTAT				0x062c
+#define MASK_CECRIWA				(1 << 6)
+#define MASK_CECRIOR				(1 << 5)
+#define MASK_CECRIACK				(1 << 4)
+#define MASK_CECRIMIN				(1 << 3)
+#define MASK_CECRIMAX				(1 << 2)
+#define MASK_CECRISTA				(1 << 1)
+#define MASK_CECRIEND				(1 << 0)
+
+#define CECTSTAT				0x0630
+#define MASK_CECTIUR				(1 << 4)
+#define MASK_CECTIACK				(1 << 3)
+#define MASK_CECTIAL				(1 << 2)
+#define MASK_CECTIEND				(1 << 1)
+
+#define CECRBUF1				0x0634
+#define MASK_CECRACK				(1 << 9)
+#define MASK_CECEOM				(1 << 8)
+#define MASK_CECRBYTE				(0xff << 0)
+
+#define CECTBUF1				0x0674
+#define MASK_CECTEOM				(1 << 8)
+#define MASK_CECTBYTE				(0xff << 0)
+
+#define CECRCTR					0x06b4
+#define MASK_CECRCTR				(0x1f << 0)
+
+#define CECIMSK					0x06c0
+#define MASK_CECTIM				(1 << 1)
+#define MASK_CECRIM				(1 << 0)
+
+#define CECICLR					0x06cc
+#define MASK_CECTICLR				(1 << 1)
+#define MASK_CECRICLR				(1 << 0)
 
 /* *** Split Control (16 bit) *** */
 #define SPLITTX0_CTRL				0x5000
@@ -367,9 +456,9 @@
 #define SPLITTX0_WC				0x5008	/*Removed in rev. 1.1*/
 #define SPLITTX1_WC				0x5088	/*Removed in rev. 1.1*/
 
-#define SPLITTX0_SPLIT				0x500C
-#define SPLITTX1_SPLIT				0x508C
-#define MASK_FPXV				0x0FFF
+#define SPLITTX0_SPLIT				0x500c
+#define SPLITTX1_SPLIT				0x508c
+#define MASK_FPXV				0x0fff
 /* NOTE: Only available for TX0 */
 #define MASK_TX1SEL				0x4000
 /* NOTE: Only available for TX0 */
@@ -388,7 +477,7 @@
 #define PHY_RST					0x8414
 #define MASK_RESET_CTRL				0x01	/* Reset active low */
 
-#define APPL_CTL				0x84F0
+#define APPL_CTL				0x84f0
 #define MASK_APLL_ON				0x01
 #define MASK_APLL_CPCTL				0x30
 #define MASK_APLL_CPCTL_HIZ			0x00
@@ -396,7 +485,7 @@
 #define MASK_APLL_CPCTL_HFIX			0x20
 #define MASK_APLL_CPCTL_NORMAL			0x30
 
-#define DDCIO_CTL				0x84F4
+#define DDCIO_CTL				0x84f4
 #define MASK_DDC_PWR_ON				(1 << 0)
 
 /** *** HDMI Clock (8 bit) *** */
@@ -410,7 +499,7 @@
 #define LOCK_REF_FREQC				0x8632
 
 #define FS_SET					0x8621
-#define MASK_FS					0x0F
+#define MASK_FS					0x0f
 
 #define NCO_F0_MOD				0x8670
 #define MASK_NCO_F0_MOD_42MHZ			0x00
@@ -426,31 +515,31 @@
 #define NCO_44F0C				0x8677
 #define NCO_44F0D				0x8678
 
-#define SCLK_CSC0				0x8A0C
-#define SCLK_CSC1				0x8A0D
-
-#define HDCP_MODE                             0x8560
-#define MASK_MODE_RST_TN                      0x20
-#define MASK_LINE_REKEY                       0x10
-#define MASK_AUTO_CLR                         0x04
-
-#define HDCP_REG1                             0x8563 /* Not in REF_01 */
-#define MASK_AUTH_UNAUTH_SEL                  0x70
-#define MASK_AUTH_UNAUTH_SEL_12_FRAMES        0x70
-#define MASK_AUTH_UNAUTH_SEL_8_FRAMES         0x60
-#define MASK_AUTH_UNAUTH_SEL_4_FRAMES         0x50
-#define MASK_AUTH_UNAUTH_SEL_2_FRAMES         0x40
-#define MASK_AUTH_UNAUTH_SEL_64_FRAMES        0x30
-#define MASK_AUTH_UNAUTH_SEL_32_FRAMES        0x20
-#define MASK_AUTH_UNAUTH_SEL_16_FRAMES        0x10
-#define MASK_AUTH_UNAUTH_SEL_ONCE             0x00
-#define MASK_AUTH_UNAUTH                      0x01
-#define MASK_AUTH_UNAUTH_AUTO                 0x01
-
-#define HDCP_REG2                             0x8564 /* Not in REF_01 */
-#define MASK_AUTO_P3_RESET                    0x0F
-#define SET_AUTO_P3_RESET_FRAMES(n)          (n & MASK_AUTO_P3_RESET)
-#define MASK_AUTO_P3_RESET_OFF                0x00
+#define SCLK_CSC0				0x8a0c
+#define SCLK_CSC1				0x8a0d
+
+#define HDCP_MODE				0x8560
+#define MASK_MODE_RST_TN			0x20
+#define MASK_LINE_REKEY				0x10
+#define MASK_AUTO_CLR				0x04
+
+#define HDCP_REG1				0x8563 /* Not in REF_01 */
+#define MASK_AUTH_UNAUTH_SEL			0x70
+#define MASK_AUTH_UNAUTH_SEL_12_FRAMES		0x70
+#define MASK_AUTH_UNAUTH_SEL_8_FRAMES		0x60
+#define MASK_AUTH_UNAUTH_SEL_4_FRAMES		0x50
+#define MASK_AUTH_UNAUTH_SEL_2_FRAMES		0x40
+#define MASK_AUTH_UNAUTH_SEL_64_FRAMES		0x30
+#define MASK_AUTH_UNAUTH_SEL_32_FRAMES		0x20
+#define MASK_AUTH_UNAUTH_SEL_16_FRAMES		0x10
+#define MASK_AUTH_UNAUTH_SEL_ONCE		0x00
+#define MASK_AUTH_UNAUTH			0x01
+#define MASK_AUTH_UNAUTH_AUTO			0x01
+
+#define HDCP_REG2				0x8564 /* Not in REF_01 */
+#define MASK_AUTO_P3_RESET			0x0f
+#define SET_AUTO_P3_RESET_FRAMES(n)		(n & MASK_AUTO_P3_RESET)
+#define MASK_AUTO_P3_RESET_OFF			0x00
 
 
 /* *** VI *** */
@@ -460,58 +549,58 @@
 
 #define DE_HSIZE_LO				0x8582
 #define DE_HSIZE_HI				0x8583
-#define DE_VSIZE_LO				0x858C
-#define DE_VSIZE_HI				0x858D
+#define DE_VSIZE_LO				0x858c
+#define DE_VSIZE_HI				0x858d
 
-#define IN_HSIZE_LO				0x858E
-#define IN_HSIZE_HI				0x858F
+#define IN_HSIZE_LO				0x858e
+#define IN_HSIZE_HI				0x858f
 
 #define IN_VSIZE_LO				0x8590
 #define IN_VSIZE_HI				0x8591
 
-#define FV_CNT_LO				0x85C1	/* Not in Ref. v1.5 */
-#define FV_CNT_HI				0x85C2	/* Not in Ref. v1.5 */
+#define FV_CNT_LO				0x85c1	/* Not in Ref. v1.5 */
+#define FV_CNT_HI				0x85c2	/* Not in Ref. v1.5 */
 
-#define HDCP_REG3                             0x85D1 /* Not in REF_01 */
-#define KEY_RD_CMD                            0x01
+#define HDCP_REG3				0x85d1 /* Not in REF_01 */
+#define KEY_RD_CMD				0x01
 
 /* *** EDID (8 bit) *** */
-#define EDID_MODE				0x85E0
+#define EDID_MODE				0x85e0
 #define MASK_DIRECT				0x00
 #define MASK_RAM_DDC2B				(1 << 0)
 #define MASK_RAM_EDDC				(1 << 1)
 #define MASK_EDID_MODE_ALL			0x03
 
-#define EDID_LEN1				0x85E3
-#define EDID_LEN2				0x85E4
+#define EDID_LEN1				0x85e3
+#define EDID_LEN2				0x85e4
 
-#define EDID_RAM				0x8C00
+#define EDID_RAM				0x8c00
 
 /* *** HDCP *** */
 #define BKSV					0x8800
 
-#define BCAPS                                 0x8840
-#define MASK_HDMI_RSVD                        0x80
-#define MASK_REPEATER                         0x40
-#define MASK_READY                            0x20
-#define MASK_FASTI2C                          0x10
-#define MASK_1_1_FEA                          0x02
-#define MASK_FAST_REAU                        0x01
+#define BCAPS					0x8840
+#define MASK_HDMI_RSVD				0x80
+#define MASK_REPEATER				0x40
+#define MASK_READY				0x20
+#define MASK_FASTI2C				0x10
+#define MASK_1_1_FEA				0x02
+#define MASK_FAST_REAU				0x01
 
-#define BSTATUS0                              0x8841
-#define BSTATUS1                              0x8842
-#define MASK_HDMI_MODE                        0x10
-#define MASK_MAX_EXCED                        0x08
+#define BSTATUS0				0x8841
+#define BSTATUS1				0x8842
+#define MASK_HDMI_MODE				0x10
+#define MASK_MAX_EXCED				0x08
 
 /* *** Video Output Format (8 bit) *** */
-#define VOUT_FMT				0x8A00
+#define VOUT_FMT				0x8a00
 #define MASK_OUTFMT_444_RGB			(0 << 0)
 #define MASK_OUTFMT_422				(1 << 0)
 #define MASK_OUTFMT_THROUGH			(2 << 0)
 #define MASK_422FMT_NORMAL			(0 << 4)
 #define MASK_422FMT_HDMITHROUGH			(1 << 4)
 
-#define VOUT_FIL				0x8A01
+#define VOUT_FIL				0x8a01
 #define MASK_422FIL				0x07
 #define MASK_422FIL_2_TAP			(0 << 0)
 #define MASK_422FIL_3_TAP			(1 << 0)
@@ -524,13 +613,13 @@
 #define MASK_444FIL_REPEAT			(0 << 4)
 #define MASK_444FIL_2_TAP			(1 << 4)
 
-#define VOUT_SYNC0				0x8A02
+#define VOUT_SYNC0				0x8a02
 #define MASK_MODE_2				(2 << 0)
 #define MASK_MODE_3				(3 << 0)
 #define MASK_M3_HSIZE				0x30
-#define MASK_M3_VSIZE				0xC0
+#define MASK_M3_VSIZE				0xc0
 
-#define VOUT_CSC				0x8A08
+#define VOUT_CSC				0x8a08
 #define MASK_CSC_MODE				0x03
 #define MASK_CSC_MODE_OFF			(0 << 0)
 #define MASK_CSC_MODE_BUILTIN			(1 << 0)
@@ -657,12 +746,12 @@
 #define MASK_HPD_OUT0				(1 << 0)
 #define MASK_HPD_CTL0				(1 << 4)
 
-#define INIT_END				0x854A
+#define INIT_END				0x854a
 #define MASK_INIT_END				0x01
 
 /* *** Video Mute *** */
-#define VI_MUTE					0x857F
-#define MASK_AUTO_MUTE				0xC0
+#define VI_MUTE					0x857f
+#define MASK_AUTO_MUTE				0xc0
 #define MASK_VI_MUTE				0x10
 #define MASK_VI_BLACK				0x01
 
@@ -677,20 +766,20 @@
 #define MASK_AUD_INT_MODE			0x02
 #define MASK_AVI_INT_MODE			0x01
 
-#define NO_PKT_LIMIT				0x870B
-#define MASK_NO_ACP_LIMIT			0xF0
+#define NO_PKT_LIMIT				0x870b
+#define MASK_NO_ACP_LIMIT			0xf0
 #define SET_NO_ACP_LIMIT_MS(milliseconds)	((((milliseconds)/80) << 4) & \
 						  MASK_NO_ACP_LIMIT)
 
-#define NO_PKT_CLR				0x870C
+#define NO_PKT_CLR				0x870c
 #define MASK_NO_VS_CLR				0x40
 #define MASK_NO_SPD_CLR				0x20
 #define MASK_NO_ACP_CLR				0x10
 #define MASK_NO_AVI_CLR1			0x02
 #define MASK_NO_AVI_CLR0			0x01
 
-#define ERR_PK_LIMIT				0x870D
-#define NO_PKT_LIMIT2				0x870E
+#define ERR_PK_LIMIT				0x870d
+#define NO_PKT_LIMIT2				0x870e
 #define PK_AVI_0HEAD				0x8710
 #define PK_AVI_1HEAD				0x8711
 #define PK_AVI_2HEAD				0x8712
@@ -701,12 +790,12 @@
 #define PK_AVI_4BYTE				0x8717
 #define PK_AVI_5BYTE				0x8718
 #define PK_AVI_6BYTE				0x8719
-#define PK_AVI_7BYTE				0x871A
-#define PK_AVI_8BYTE				0x871B
-#define PK_AVI_9BYTE				0x871C
-#define PK_AVI_10BYTE				0x871D
-#define PK_AVI_11BYTE				0x871E
-#define PK_AVI_12BYTE				0x871F
+#define PK_AVI_7BYTE				0x871a
+#define PK_AVI_8BYTE				0x871b
+#define PK_AVI_9BYTE				0x871c
+#define PK_AVI_10BYTE				0x871d
+#define PK_AVI_11BYTE				0x871e
+#define PK_AVI_12BYTE				0x871f
 #define PK_AVI_13BYTE				0x8720
 #define PK_AVI_14BYTE				0x8721
 #define PK_AVI_15BYTE				0x8722
@@ -717,9 +806,9 @@
 /* *** Color Bar (16 bit) *** */
 #define CB_CTL					0x7000
 #define CB_HSW					0x7008
-#define CB_VSW					0x700A
-#define CB_HTOTOAL				0x700C
-#define CB_VTOTOAL				0x700E
+#define CB_VSW					0x700a
+#define CB_HTOTOAL				0x700c
+#define CB_VTOTOAL				0x700e
 #define CB_HACT					0x7010
 #define CB_VACT					0x7012
 #define CB_HSTART				0x7014
-- 
2.7.0

