Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaDQONm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 40/49] adv7604: Store I2C addresses and clients in arrays
Date: Thu, 17 Apr 2014 16:13:11 +0200
Message-Id: <1397744000-23967-41-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows replacing duplicate code blocks by loops over the arrays.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 248 +++++++++++++-------------------------------
 include/media/adv7604.h     |  30 +++---
 2 files changed, 88 insertions(+), 190 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1547909..fc71c17 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -159,18 +159,7 @@ struct adv7604_state {
 	bool restart_stdi_once;
 
 	/* i2c clients */
-	struct i2c_client *i2c_avlink;
-	struct i2c_client *i2c_cec;
-	struct i2c_client *i2c_infoframe;
-	struct i2c_client *i2c_esdp;
-	struct i2c_client *i2c_dpp;
-	struct i2c_client *i2c_afe;
-	struct i2c_client *i2c_repeater;
-	struct i2c_client *i2c_edid;
-	struct i2c_client *i2c_hdmi;
-	struct i2c_client *i2c_test;
-	struct i2c_client *i2c_cp;
-	struct i2c_client *i2c_vdp;
+	struct i2c_client *i2c_clients[ADV7604_PAGE_MAX];
 
 	/* controls */
 	struct v4l2_ctrl *detect_tx_5v_ctrl;
@@ -377,14 +366,18 @@ static s32 adv_smbus_read_byte_data_check(struct i2c_client *client,
 	return -EIO;
 }
 
-static s32 adv_smbus_read_byte_data(struct i2c_client *client, u8 command)
+static s32 adv_smbus_read_byte_data(struct adv7604_state *state,
+				    enum adv7604_page page, u8 command)
 {
-	return adv_smbus_read_byte_data_check(client, command, true);
+	return adv_smbus_read_byte_data_check(state->i2c_clients[page],
+					      command, true);
 }
 
-static s32 adv_smbus_write_byte_data(struct i2c_client *client,
-					u8 command, u8 value)
+static s32 adv_smbus_write_byte_data(struct adv7604_state *state,
+				     enum adv7604_page page, u8 command,
+				     u8 value)
 {
+	struct i2c_client *client = state->i2c_clients[page];
 	union i2c_smbus_data data;
 	int err;
 	int i;
@@ -404,9 +397,11 @@ static s32 adv_smbus_write_byte_data(struct i2c_client *client,
 	return err;
 }
 
-static s32 adv_smbus_write_i2c_block_data(struct i2c_client *client,
-	       u8 command, unsigned length, const u8 *values)
+static s32 adv_smbus_write_i2c_block_data(struct adv7604_state *state,
+					  enum adv7604_page page, u8 command,
+					  unsigned length, const u8 *values)
 {
+	struct i2c_client *client = state->i2c_clients[page];
 	union i2c_smbus_data data;
 
 	if (length > I2C_SMBUS_BLOCK_MAX)
@@ -422,16 +417,16 @@ static s32 adv_smbus_write_i2c_block_data(struct i2c_client *client,
 
 static inline int io_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(client, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_IO, reg);
 }
 
 static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(client, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_IO, reg, val);
 }
 
 static inline int io_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -443,28 +438,28 @@ static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_avlink, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AVLINK, reg);
 }
 
 static inline int avlink_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_avlink, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AVLINK, reg, val);
 }
 
 static inline int cec_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_cec, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CEC, reg);
 }
 
 static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_cec, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CEC, reg, val);
 }
 
 static inline int cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -476,70 +471,71 @@ static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_infoframe, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_INFOFRAME, reg);
 }
 
 static inline int infoframe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_infoframe, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_INFOFRAME,
+					 reg, val);
 }
 
 static inline int esdp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_esdp, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_ESDP, reg);
 }
 
 static inline int esdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_esdp, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_ESDP, reg, val);
 }
 
 static inline int dpp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_dpp, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_DPP, reg);
 }
 
 static inline int dpp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_dpp, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_DPP, reg, val);
 }
 
 static inline int afe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_afe, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AFE, reg);
 }
 
 static inline int afe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_afe, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AFE, reg, val);
 }
 
 static inline int rep_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_repeater, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_REP, reg);
 }
 
 static inline int rep_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_repeater, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_REP, reg, val);
 }
 
 static inline int rep_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -551,20 +547,20 @@ static inline int edid_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_edid, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_EDID, reg);
 }
 
 static inline int edid_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_edid, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_EDID, reg, val);
 }
 
 static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 {
 	struct adv7604_state *state = to_state(sd);
-	struct i2c_client *client = state->i2c_edid;
+	struct i2c_client *client = state->i2c_clients[ADV7604_PAGE_EDID];
 	u8 msgbuf0[1] = { 0 };
 	u8 msgbuf1[256];
 	struct i2c_msg msg[2] = {
@@ -597,8 +593,8 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
 
 	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
-		err = adv_smbus_write_i2c_block_data(state->i2c_edid, i,
-				I2C_SMBUS_BLOCK_MAX, val + i);
+		err = adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_EDID,
+				i, I2C_SMBUS_BLOCK_MAX, val + i);
 	return err;
 }
 
@@ -618,7 +614,7 @@ static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_hdmi, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_HDMI, reg);
 }
 
 static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -630,7 +626,7 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_hdmi, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_HDMI, reg, val);
 }
 
 static inline int hdmi_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -642,21 +638,21 @@ static inline int test_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_test, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_TEST, reg);
 }
 
 static inline int test_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_test, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_TEST, reg, val);
 }
 
 static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_cp, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CP, reg);
 }
 
 static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -668,7 +664,7 @@ static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_cp, reg, val);
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CP, reg, val);
 }
 
 static inline int cp_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -680,32 +676,15 @@ static inline int vdp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state->i2c_vdp, reg);
+	return adv_smbus_read_byte_data(state, ADV7604_PAGE_VDP, reg);
 }
 
 static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state->i2c_vdp, reg, val);
-}
-
-enum {
-	ADV7604_PAGE_IO,
-	ADV7604_PAGE_AVLINK,
-	ADV7604_PAGE_CEC,
-	ADV7604_PAGE_INFOFRAME,
-	ADV7604_PAGE_ESDP,
-	ADV7604_PAGE_DPP,
-	ADV7604_PAGE_AFE,
-	ADV7604_PAGE_REP,
-	ADV7604_PAGE_EDID,
-	ADV7604_PAGE_HDMI,
-	ADV7604_PAGE_TEST,
-	ADV7604_PAGE_CP,
-	ADV7604_PAGE_VDP,
-	ADV7604_PAGE_TERM,
-};
+	return adv_smbus_write_byte_data(state, ADV7604_PAGE_VDP, reg, val);
+}
 
 #define ADV7604_REG(page, offset)	(((page) << 8) | (offset))
 #define ADV7604_REG_SEQ_TERM		0xffff
@@ -721,36 +700,7 @@ static int adv7604_read_reg(struct v4l2_subdev *sd, unsigned int reg)
 
 	reg &= 0xff;
 
-	switch (page) {
-	case ADV7604_PAGE_IO:
-		return io_read(sd, reg);
-	case ADV7604_PAGE_AVLINK:
-		return avlink_read(sd, reg);
-	case ADV7604_PAGE_CEC:
-		return cec_read(sd, reg);
-	case ADV7604_PAGE_INFOFRAME:
-		return infoframe_read(sd, reg);
-	case ADV7604_PAGE_ESDP:
-		return esdp_read(sd, reg);
-	case ADV7604_PAGE_DPP:
-		return dpp_read(sd, reg);
-	case ADV7604_PAGE_AFE:
-		return afe_read(sd, reg);
-	case ADV7604_PAGE_REP:
-		return rep_read(sd, reg);
-	case ADV7604_PAGE_EDID:
-		return edid_read(sd, reg);
-	case ADV7604_PAGE_HDMI:
-		return hdmi_read(sd, reg);
-	case ADV7604_PAGE_TEST:
-		return test_read(sd, reg);
-	case ADV7604_PAGE_CP:
-		return cp_read(sd, reg);
-	case ADV7604_PAGE_VDP:
-		return vdp_read(sd, reg);
-	}
-
-	return -EINVAL;
+	return adv_smbus_read_byte_data(state, page, reg);
 }
 #endif
 
@@ -764,36 +714,7 @@ static int adv7604_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
 
 	reg &= 0xff;
 
-	switch (page) {
-	case ADV7604_PAGE_IO:
-		return io_write(sd, reg, val);
-	case ADV7604_PAGE_AVLINK:
-		return avlink_write(sd, reg, val);
-	case ADV7604_PAGE_CEC:
-		return cec_write(sd, reg, val);
-	case ADV7604_PAGE_INFOFRAME:
-		return infoframe_write(sd, reg, val);
-	case ADV7604_PAGE_ESDP:
-		return esdp_write(sd, reg, val);
-	case ADV7604_PAGE_DPP:
-		return dpp_write(sd, reg, val);
-	case ADV7604_PAGE_AFE:
-		return afe_write(sd, reg, val);
-	case ADV7604_PAGE_REP:
-		return rep_write(sd, reg, val);
-	case ADV7604_PAGE_EDID:
-		return edid_write(sd, reg, val);
-	case ADV7604_PAGE_HDMI:
-		return hdmi_write(sd, reg, val);
-	case ADV7604_PAGE_TEST:
-		return test_write(sd, reg, val);
-	case ADV7604_PAGE_CP:
-		return cp_write(sd, reg, val);
-	case ADV7604_PAGE_VDP:
-		return vdp_write(sd, reg, val);
-	}
-
-	return -EINVAL;
+	return adv_smbus_write_byte_data(state, page, reg, val);
 }
 
 static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
@@ -1064,7 +985,6 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		const struct v4l2_bt_timings *bt)
 {
 	struct adv7604_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u32 width = htotal(bt);
 	u32 height = vtotal(bt);
 	u16 cp_start_sav = bt->hsync + bt->hbackporch - 4;
@@ -1090,7 +1010,8 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
 		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
-		if (adv_smbus_write_i2c_block_data(client, 0x16, 2, pll))
+		if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_IO,
+						   0x16, 2, pll))
 			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
 
 		/* active video - horizontal timing */
@@ -1141,7 +1062,8 @@ static void adv7604_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 off
 	offset_buf[3] = offset_c & 0x0ff;
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state->i2c_cp, 0x77, 4, offset_buf))
+	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
+					   0x77, 4, offset_buf))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x77, 0x78, 0x79, 0x7a\n", __func__);
 }
 
@@ -1170,7 +1092,8 @@ static void adv7604_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a,
 	gain_buf[3] = ((gain_c & 0x0ff));
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state->i2c_cp, 0x73, 4, gain_buf))
+	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
+					   0x73, 4, gain_buf))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x73, 0x74, 0x75, 0x76\n", __func__);
 }
 
@@ -2571,30 +2494,12 @@ static void adv7611_setup_irqs(struct v4l2_subdev *sd)
 
 static void adv7604_unregister_clients(struct adv7604_state *state)
 {
-	if (state->i2c_avlink)
-		i2c_unregister_device(state->i2c_avlink);
-	if (state->i2c_cec)
-		i2c_unregister_device(state->i2c_cec);
-	if (state->i2c_infoframe)
-		i2c_unregister_device(state->i2c_infoframe);
-	if (state->i2c_esdp)
-		i2c_unregister_device(state->i2c_esdp);
-	if (state->i2c_dpp)
-		i2c_unregister_device(state->i2c_dpp);
-	if (state->i2c_afe)
-		i2c_unregister_device(state->i2c_afe);
-	if (state->i2c_repeater)
-		i2c_unregister_device(state->i2c_repeater);
-	if (state->i2c_edid)
-		i2c_unregister_device(state->i2c_edid);
-	if (state->i2c_hdmi)
-		i2c_unregister_device(state->i2c_hdmi);
-	if (state->i2c_test)
-		i2c_unregister_device(state->i2c_test);
-	if (state->i2c_cp)
-		i2c_unregister_device(state->i2c_cp);
-	if (state->i2c_vdp)
-		i2c_unregister_device(state->i2c_vdp);
+	unsigned int i;
+
+	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i) {
+		if (state->i2c_clients[i])
+			i2c_unregister_device(state->i2c_clients[i]);
+	}
 }
 
 static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
@@ -2761,6 +2666,7 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 
 	state->info = &adv7604_chip_info[id->driver_data];
+	state->i2c_clients[ADV7604_PAGE_IO] = client;
 
 	/* initialize variables */
 	state->restart_stdi_once = true;
@@ -2852,34 +2758,20 @@ static int adv7604_probe(struct i2c_client *client,
 		goto err_hdl;
 	}
 
-	state->i2c_cec = adv7604_dummy_client(sd, pdata->i2c_cec, 0xf4);
-	state->i2c_infoframe = adv7604_dummy_client(sd, pdata->i2c_infoframe, 0xf5);
-	state->i2c_afe = adv7604_dummy_client(sd, pdata->i2c_afe, 0xf8);
-	state->i2c_repeater = adv7604_dummy_client(sd, pdata->i2c_repeater, 0xf9);
-	state->i2c_edid = adv7604_dummy_client(sd, pdata->i2c_edid, 0xfa);
-	state->i2c_hdmi = adv7604_dummy_client(sd, pdata->i2c_hdmi, 0xfb);
-	state->i2c_cp = adv7604_dummy_client(sd, pdata->i2c_cp, 0xfd);
-	if (!state->i2c_cec || !state->i2c_infoframe || !state->i2c_afe ||
-	    !state->i2c_repeater || !state->i2c_edid || !state->i2c_hdmi ||
-	    !state->i2c_cp) {
-		err = -ENOMEM;
-		v4l2_err(sd, "failed to create digital i2c clients\n");
-		goto err_i2c;
-	}
+	for (i = 1; i < ADV7604_PAGE_MAX; ++i) {
+		if (!(BIT(i) & state->info->page_mask))
+			continue;
 
-	if (adv7604_has_afe(state)) {
-		state->i2c_avlink = adv7604_dummy_client(sd, pdata->i2c_avlink, 0xf3);
-		state->i2c_esdp = adv7604_dummy_client(sd, pdata->i2c_esdp, 0xf6);
-		state->i2c_dpp = adv7604_dummy_client(sd, pdata->i2c_dpp, 0xf7);
-		state->i2c_test = adv7604_dummy_client(sd, pdata->i2c_test, 0xfc);
-		state->i2c_vdp = adv7604_dummy_client(sd, pdata->i2c_vdp, 0xfe);
-		if (!state->i2c_avlink || !state->i2c_esdp || !state->i2c_dpp ||
-		    !state->i2c_test || !state->i2c_vdp) {
+		state->i2c_clients[i] =
+			adv7604_dummy_client(sd, pdata->i2c_addresses[i],
+					     0xf2 + i);
+		if (state->i2c_clients[i] == NULL) {
 			err = -ENOMEM;
-			v4l2_err(sd, "failed to create analog i2c clients\n");
+			v4l2_err(sd, "failed to create i2c client %u\n", i);
 			goto err_i2c;
 		}
 	}
+
 	/* work queues */
 	state->work_queues = create_singlethread_workqueue(client->name);
 	if (!state->work_queues) {
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index d8b2cb8..276135b 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -79,6 +79,23 @@ enum adv7604_int1_config {
 	ADV7604_INT1_CONFIG_DISABLED,
 };
 
+enum adv7604_page {
+	ADV7604_PAGE_IO,
+	ADV7604_PAGE_AVLINK,
+	ADV7604_PAGE_CEC,
+	ADV7604_PAGE_INFOFRAME,
+	ADV7604_PAGE_ESDP,
+	ADV7604_PAGE_DPP,
+	ADV7604_PAGE_AFE,
+	ADV7604_PAGE_REP,
+	ADV7604_PAGE_EDID,
+	ADV7604_PAGE_HDMI,
+	ADV7604_PAGE_TEST,
+	ADV7604_PAGE_CP,
+	ADV7604_PAGE_VDP,
+	ADV7604_PAGE_MAX,
+};
+
 /* Platform dependent definition */
 struct adv7604_platform_data {
 	/* DIS_PWRDNB: 1 if the PWRDNB pin is unused and unconnected */
@@ -125,18 +142,7 @@ struct adv7604_platform_data {
 	unsigned hdmi_free_run_mode;
 
 	/* i2c addresses: 0 == use default */
-	u8 i2c_avlink;
-	u8 i2c_cec;
-	u8 i2c_infoframe;
-	u8 i2c_esdp;
-	u8 i2c_dpp;
-	u8 i2c_afe;
-	u8 i2c_repeater;
-	u8 i2c_edid;
-	u8 i2c_hdmi;
-	u8 i2c_test;
-	u8 i2c_cp;
-	u8 i2c_vdp;
+	u8 i2c_addresses[ADV7604_PAGE_MAX];
 };
 
 enum adv7604_pad {
-- 
1.8.3.2

