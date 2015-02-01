Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51907 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbBAKJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2015 05:09:25 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so33864788wgh.8
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2015 02:09:23 -0800 (PST)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, m.chehab@samsung.com,
	lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Pablo Anton <pablo.anton@vodalys-labs.com>
Subject: [PATCH] media: i2c: ADV7604: Migrate to regmap
Date: Sun,  1 Feb 2015 11:08:59 +0100
Message-Id: <1422785339-2699-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preliminary patch in order to add support for ALSA.
It replaces all current i2c access with regmap.
Add the registers which will then be used too, as these are declared at init.

Signed-off-by: Pablo Anton <pablo.anton@vodalys-labs.com>
Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 428 +++++++++++++++++++++++++++++++++-----------
 include/media/adv7604.h     | 129 +++++++++++++
 2 files changed, 455 insertions(+), 102 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..af19544 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -43,6 +43,8 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-of.h>
 
+#include <linux/regmap.h>
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug level (0-2)");
@@ -165,6 +167,9 @@ struct adv7604_state {
 	/* i2c clients */
 	struct i2c_client *i2c_clients[ADV7604_PAGE_MAX];
 
+	/* Regmaps */
+	struct regmap *regmap[ADV7604_PAGE_MAX];
+
 	/* controls */
 	struct v4l2_ctrl *detect_tx_5v_ctrl;
 	struct v4l2_ctrl *analog_sampling_phase_ctrl;
@@ -353,84 +358,53 @@ static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 	return V4L2_DV_BT_FRAME_HEIGHT(t);
 }
 
-/* ----------------------------------------------------------------------- */
-
-static s32 adv_smbus_read_byte_data_check(struct i2c_client *client,
-		u8 command, bool check)
-{
-	union i2c_smbus_data data;
-
-	if (!i2c_smbus_xfer(client->adapter, client->addr, client->flags,
-			I2C_SMBUS_READ, command,
-			I2C_SMBUS_BYTE_DATA, &data))
-		return data.byte;
-	if (check)
-		v4l_err(client, "error reading %02x, %02x\n",
-				client->addr, command);
-	return -EIO;
-}
-
-static s32 adv_smbus_read_byte_data(struct adv7604_state *state,
-				    enum adv7604_page page, u8 command)
-{
-	return adv_smbus_read_byte_data_check(state->i2c_clients[page],
-					      command, true);
-}
-
-static s32 adv_smbus_write_byte_data(struct adv7604_state *state,
-				     enum adv7604_page page, u8 command,
-				     u8 value)
+static int regmap_read_check(struct adv7604_state *state,
+			     int client_page, u8 reg)
 {
-	struct i2c_client *client = state->i2c_clients[page];
-	union i2c_smbus_data data;
+	struct i2c_client *client = state->i2c_clients[client_page];
 	int err;
-	int i;
+	unsigned int val;
 
-	data.byte = value;
-	for (i = 0; i < 3; i++) {
-		err = i2c_smbus_xfer(client->adapter, client->addr,
-				client->flags,
-				I2C_SMBUS_WRITE, command,
-				I2C_SMBUS_BYTE_DATA, &data);
-		if (!err)
-			break;
+	err = regmap_read(state->regmap[client_page], reg, &val);
+
+	if (err) {
+		v4l_err(client, "error reading %02x, %02x\n",
+				client->addr, reg);
+		return err;
 	}
-	if (err < 0)
-		v4l_err(client, "error writing %02x, %02x, %02x\n",
-				client->addr, command, value);
-	return err;
+	return val;
 }
 
-static s32 adv_smbus_write_i2c_block_data(struct adv7604_state *state,
-					  enum adv7604_page page, u8 command,
-					  unsigned length, const u8 *values)
+/* regmap_write_block(): Write raw data with a maximum of I2C_SMBUS_BLOCK_MAX
+ * size to one or more registers.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+static int regmap_write_block(struct adv7604_state *state, int client_page,
+			      unsigned int init_reg, const void *val,
+			      size_t val_len)
 {
-	struct i2c_client *client = state->i2c_clients[page];
-	union i2c_smbus_data data;
+	struct regmap *regmap = state->regmap[client_page];
 
-	if (length > I2C_SMBUS_BLOCK_MAX)
-		length = I2C_SMBUS_BLOCK_MAX;
-	data.block[0] = length;
-	memcpy(data.block + 1, values, length);
-	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
-			      I2C_SMBUS_WRITE, command,
-			      I2C_SMBUS_I2C_BLOCK_DATA, &data);
-}
+	if (val_len > I2C_SMBUS_BLOCK_MAX)
+		val_len = I2C_SMBUS_BLOCK_MAX;
 
-/* ----------------------------------------------------------------------- */
+	return regmap_raw_write(regmap, init_reg, val, val_len);
+}
 
 static inline int io_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_IO, reg);
+	return regmap_read_check(state, ADV7604_PAGE_IO, reg);
 }
 
 static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_IO, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_IO], reg, val);
 }
 
 static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -442,28 +416,28 @@ static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AVLINK, reg);
+	return regmap_read_check(state, ADV7604_PAGE_AVLINK, reg);
 }
 
 static inline int avlink_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AVLINK, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_AVLINK], reg, val);
 }
 
 static inline int cec_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CEC, reg);
+	return regmap_read_check(state, ADV7604_PAGE_CEC, reg);
 }
 
 static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CEC, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_CEC], reg, val);
 }
 
 static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -475,71 +449,70 @@ static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_INFOFRAME, reg);
+	return regmap_read_check(state, ADV7604_PAGE_INFOFRAME, reg);
 }
 
 static inline int infoframe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_INFOFRAME,
-					 reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_INFOFRAME], reg, val);
 }
 
 static inline int esdp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_ESDP, reg);
+	return regmap_read_check(state, ADV7604_PAGE_ESDP, reg);
 }
 
 static inline int esdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_ESDP, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_ESDP], reg, val);
 }
 
 static inline int dpp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_DPP, reg);
+	return regmap_read_check(state, ADV7604_PAGE_DPP, reg);
 }
 
 static inline int dpp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_DPP, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_DPP], reg, val);
 }
 
 static inline int afe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AFE, reg);
+	return regmap_read_check(state, ADV7604_PAGE_AFE, reg);
 }
 
 static inline int afe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AFE, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_AFE], reg, val);
 }
 
 static inline int rep_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_REP, reg);
+	return regmap_read_check(state, ADV7604_PAGE_REP, reg);
 }
 
 static inline int rep_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_REP, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_REP], reg, val);
 }
 
 static inline int rep_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -551,14 +524,14 @@ static inline int edid_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_EDID, reg);
+	return regmap_read_check(state, ADV7604_PAGE_AVLINK, reg);
 }
 
 static inline int edid_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_EDID, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_EDID], reg, val);
 }
 
 static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
@@ -588,17 +561,26 @@ static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 }
 
 static inline int edid_write_block(struct v4l2_subdev *sd,
-					unsigned len, const u8 *val)
+					unsigned int total_len, const u8 *val)
 {
 	struct adv7604_state *state = to_state(sd);
 	int err = 0;
-	int i;
+	int i = 0;
+	int len = 0;
 
-	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
+	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n",
+				__func__, total_len);
+
+	while (!err && i < total_len) {
+		len = (total_len - i) > I2C_SMBUS_BLOCK_MAX ?
+				I2C_SMBUS_BLOCK_MAX :
+				(total_len - i);
+
+		err = regmap_write_block(state, ADV7604_PAGE_EDID,
+				i, val + i, len);
+		i += len;
+	}
 
-	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
-		err = adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_EDID,
-				i, I2C_SMBUS_BLOCK_MAX, val + i);
 	return err;
 }
 
@@ -632,7 +614,7 @@ static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_HDMI, reg);
+	return regmap_read_check(state, ADV7604_PAGE_HDMI, reg);
 }
 
 static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -644,7 +626,7 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_HDMI, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_HDMI], reg, val);
 }
 
 static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -656,21 +638,21 @@ static inline int test_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_TEST, reg);
+	return regmap_read_check(state, ADV7604_PAGE_TEST, reg);
 }
 
 static inline int test_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_TEST, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_TEST], reg, val);
 }
 
 static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CP, reg);
+	return regmap_read_check(state, ADV7604_PAGE_CP, reg);
 }
 
 static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -682,7 +664,7 @@ static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CP, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_CP], reg, val);
 }
 
 static inline int cp_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -694,14 +676,14 @@ static inline int vdp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_VDP, reg);
+	return regmap_read_check(state, ADV7604_PAGE_VDP, reg);
 }
 
 static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_VDP, reg, val);
+	return regmap_write(state->regmap[ADV7604_PAGE_VDP], reg, val);
 }
 
 #define ADV7604_REG(page, offset)	(((page) << 8) | (offset))
@@ -712,13 +694,15 @@ static int adv7604_read_reg(struct v4l2_subdev *sd, unsigned int reg)
 {
 	struct adv7604_state *state = to_state(sd);
 	unsigned int page = reg >> 8;
+	unsigned int val;
 
 	if (!(BIT(page) & state->info->page_mask))
 		return -EINVAL;
 
 	reg &= 0xff;
+	regmap_read(state->regmap[page], reg, &val);
 
-	return adv_smbus_read_byte_data(state, page, reg);
+	return val;
 }
 #endif
 
@@ -732,7 +716,7 @@ static int adv7604_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
 
 	reg &= 0xff;
 
-	return adv_smbus_write_byte_data(state, page, reg, val);
+	return regmap_write(state->regmap[page], reg, val);
 }
 
 static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
@@ -1028,8 +1012,8 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
 		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
-		if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_IO,
-						   0x16, 2, pll))
+		if (regmap_raw_write(state->regmap[ADV7604_PAGE_IO],
+					       0x16, pll, 2))
 			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
 
 		/* active video - horizontal timing */
@@ -1080,8 +1064,8 @@ static void adv7604_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 off
 	offset_buf[3] = offset_c & 0x0ff;
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
-					   0x77, 4, offset_buf))
+	if (regmap_raw_write(state->regmap[ADV7604_PAGE_CP],
+			     0x77, offset_buf, 4))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x77, 0x78, 0x79, 0x7a\n", __func__);
 }
 
@@ -1110,8 +1094,8 @@ static void adv7604_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a,
 	gain_buf[3] = ((gain_c & 0x0ff));
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
-					   0x73, 4, gain_buf))
+	if (regmap_raw_write(state->regmap[ADV7604_PAGE_CP],
+			     0x73, gain_buf, 4))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x73, 0x74, 0x75, 0x76\n", __func__);
 }
 
@@ -2742,6 +2726,229 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	return 0;
 }
 
+static bool adv7611_hdmi_writable(struct device *dev, unsigned int reg)
+{
+
+	switch (reg) {
+	case ADV76XX_HDMI_REGISTER_00:
+	case ADV76XX_HDMI_REGISTER_01:
+	case ADV76XX_HDMI_REGISTER_03:
+	case ADV76XX_HDMI_REGISTER_0D:
+	case ADV76XX_AUDIO_MUTE_SPEED:
+	case ADV76XX_HDMI_REGISTER_10:
+	case ADV76XX_AUDIO_FIFO_ALM_OST_FULL_THRES_HOLD:
+	case ADV76XX_AUDIO_FIFO_ALM_OST_EMPTY_THRE_SHOLD:
+	case ADV76XX_AUDIO_COAST_MASK:
+	case ADV76XX_MUTE_MASK_21_16:
+	case ADV76XX_MUTE_MASK_15_8:
+	case ADV76XX_MUTE_MASK_7_0:
+	case ADV76XX_MUTE_CTRL:
+	case ADV76XX_DEEPCOLOR_FIFO_DEBUG_1:
+	case ADV76XX_REGISTER_1DH:
+	case ADV7611_REGISTER_3CH:
+	case ADV76XX_REGISTER_40H:
+	case ADV76XX_REGISTER_41H:
+	case ADV76XX_REGISTER_47H:
+	case ADV76XX_REGISTER_48H:
+	case ADV7611_REGISTER_4CH:
+	case ADV76XX_HDMI_REGISTER_50:
+	case ADV76XX_FILT_5V_DET_REG:
+	case ADV76XX_REGISTER_5AH:
+	case ADV7611_HPA_DELAY_SEL_3_0:
+	case ADV7611_DSD_MAP_ROT_2_0:
+	case ADV7611_DDC_PAD:
+	case ADV7611_HDMI_REGISTER_02:
+	case ADV76XX_EQ_DYNAMIC_FREQ:
+	case ADV76XX_EQ_DYN1_LF:
+	case ADV76XX_EQ_DYN1_HF:
+	case ADV76XX_EQ_DYN2_LF:
+	case ADV76XX_EQ_DYN2_HF:
+	case ADV76XX_EQ_DYN3_LF:
+	case ADV76XX_EQ_DYN3_HF:
+	case ADV76XX_EQ_DYNAMIC_ENABLE:
+		return true;
+	}
+
+	return false;
+}
+
+/* Default register values for the adv7611 device */
+static const struct reg_default adv7611_hdmi_reg_defaults[] = {
+	{},
+};
+
+static const struct regmap_config adv76xx_regmap[] = {
+	{
+		.name			= "io",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= ADV7611_IO_MAX_REG_OFFSET,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "avlink",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "cec",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "infoframe",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "esdp",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "epp",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "afe",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= ADV76XX_DPLL_MAX_REG_OFFSET,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "rep",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "edid",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+
+	{
+		.name			= "hdmi",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+		.writeable_reg		= adv7611_hdmi_writable,
+
+		.max_register		= ADV76XX_HDMI_MAX_REG_OFFSET,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "test",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "cp",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+	{
+		.name			= "vdp",
+		.reg_bits		= 8,
+		.val_bits		= 8,
+
+		.max_register		= 0xff,
+		.cache_type		= REGCACHE_NONE,
+		.reg_defaults		= adv7611_hdmi_reg_defaults,
+		.num_reg_defaults	= ARRAY_SIZE(adv7611_hdmi_reg_defaults),
+	},
+};
+
+static int configure_regmap(struct adv7604_state *state, int region)
+{
+	int err;
+
+	if (!state->i2c_clients[region])
+		return -ENODEV;
+
+	if (!state->regmap[region]) {
+
+		state->regmap[region] =
+			devm_regmap_init_i2c(state->i2c_clients[region],
+					     &adv76xx_regmap[region]);
+
+		if (IS_ERR(state->regmap[region])) {
+			err = PTR_ERR(state->regmap[region]);
+			v4l_err(state->i2c_clients[region],
+					"Error initializing regmap %d with error %d\n",
+					region, err);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int configure_regmaps(struct adv7604_state *state)
+{
+	int i, err;
+
+	for (i = 0 ; i < ADV7604_PAGE_MAX; i++) {
+		err = configure_regmap(state, i);
+		if (err && (err != -ENODEV))
+			return err;
+	}
+	return 0;
+}
+
 static int adv7604_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -2751,7 +2958,7 @@ static int adv7604_probe(struct i2c_client *client,
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
 	unsigned int i;
-	u16 val;
+	unsigned int val, val2;
 	int err;
 
 	/* Check if the adapter supports the needed features */
@@ -2815,22 +3022,34 @@ static int adv7604_probe(struct i2c_client *client,
 		client->addr);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
+	/* Configure IO Regmap region */
+	err = configure_regmap(state, ADV7604_PAGE_IO);
+
+	if (err) {
+		v4l2_info(sd, "Error configuring IO regmap region\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Verify that the chip is present. On ADV7604 the RD_INFO register only
 	 * identifies the revision, while on ADV7611 it identifies the model as
 	 * well. Use the HDMI slave address on ADV7604 and RD_INFO on ADV7611.
 	 */
 	if (state->info->type == ADV7604) {
-		val = adv_smbus_read_byte_data_check(client, 0xfb, false);
+		regmap_read(state->regmap[ADV7604_PAGE_IO], 0xfb, &val);
 		if (val != 0x68) {
 			v4l2_info(sd, "not an adv7604 on address 0x%x\n",
 					client->addr << 1);
 			return -ENODEV;
 		}
 	} else {
-		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
-		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
-		if (val != 0x2051) {
+		regmap_read(state->regmap[ADV7604_PAGE_IO],
+					ADV7611_RD_INFO, &val);
+		val2 = val << 8;
+		regmap_read(state->regmap[ADV7604_PAGE_IO],
+					ADV7611_RD_INFO_2, &val);
+		val2 |= val;
+		if (val2 != 0x2051) {
 			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
 					client->addr << 1);
 			return -ENODEV;
@@ -2921,6 +3140,11 @@ static int adv7604_probe(struct i2c_client *client,
 	if (err)
 		goto err_work_queues;
 
+	/* Configure regmaps */
+	err = configure_regmaps(state);
+	if (err)
+		goto err_entity;
+
 	err = adv7604_core_init(sd);
 	if (err)
 		goto err_entity;
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index aa1c447..afb2f61 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -23,6 +23,118 @@
 
 #include <linux/types.h>
 
+/* IO Registers definition */
+enum adv7611_io_reg {
+	ADV7611_HDMI_LVL_RAW_STATUS_2 = 0x65,
+	ADV7611_IO_MAX_REG_OFFSET = 0xFF,
+	ADV7611_RD_INFO	= 0xEA,
+	ADV7611_RD_INFO_2 = 0xEB,
+};
+
+/* DPLL Afe */
+enum adv76xx_dpll_reg {
+	ADV76XX_DPLL_MAX_REG_OFFSET = 0xC8,
+	ADV76XX_AUDIO_MISC = 0xA0,
+	ADV76XX_MCLK_FS = 0xB5,
+};
+
+/* Specifics HDMI registers for ADV7611 */
+enum adv7611_hdmi_reg {
+	ADV7611_PACKETS_DETECTED_2 = 0x18,
+	ADV7611_PACKETS_DETECTED_3 = 0x19,
+	ADV7611_REGISTER_3CH = 0x3C,
+	ADV7611_REGISTER_4CH = 0x4C,
+	ADV7611_HPA_DELAY_SEL_3_0 = 0x6C,
+	ADV7611_DSD_MAP_ROT_2_0 = 0x6D,
+	ADV7611_DST_MAP_ROT_2_0 = 0x6E,
+	ADV7611_DDC_PAD = 0x73,
+	ADV7611_HDMI_REGISTER_02 = 0x83,
+};
+
+/* HDMI Registers definition */
+enum adv76xx_hdmi_reg {
+	ADV76XX_HDMI_MAX_REG_OFFSET = 0x96,
+	ADV76XX_HDMI_REGISTER_00 = 0x00,
+	ADV76XX_HDMI_REGISTER_01 = 0x01,
+	ADV76XX_HDMI_REGISTER_03 = 0x03,
+	ADV76XX_HDMI_REGISTER_04 = 0x04,
+	ADV76XX_HDMI_REGISTER_05 = 0x05,
+	ADV76XX_LINE_WIDTH_1 = 0x07,
+	ADV76XX_LINE_WIDTH_2 = 0x08,
+	ADV76XX_FIELD0_HEIGHT_1 = 0x09,
+	ADV76XX_FIELD0_HEIGHT_2 = 0x0A,
+	ADV76XX_FIELD1_HEIGHT_1 = 0x0B,
+	ADV76XX_FIELD1_HEIGHT_2 = 0x0C,
+	ADV76XX_HDMI_REGISTER_0D = 0x0D,
+	ADV76XX_AUDIO_MUTE_SPEED = 0X0F,
+	ADV76XX_HDMI_REGISTER_10 = 0x10,
+	ADV76XX_AUDIO_FIFO_ALM_OST_FULL_THRES_HOLD = 0x11,
+	ADV76XX_AUDIO_FIFO_ALM_OST_EMPTY_THRE_SHOLD = 0x12,
+	ADV76XX_AUDIO_COAST_MASK = 0x13,
+	ADV76XX_MUTE_MASK_21_16 = 0x14,
+	ADV76XX_MUTE_MASK_15_8 = 0x15,
+	ADV76XX_MUTE_MASK_7_0 = 0x16,
+	ADV76XX_MUTE_CTRL = 0x1A,
+	ADV76XX_DEEPCOLOR_FIFO_DEBUG_1 = 0x1B,
+	ADV76XX_DEEPCOLOR_FIFO_DEBUG_2 = 0x1C,
+	ADV76XX_REGISTER_1DH = 0x1D,
+	ADV76XX_TOTAL_LINE_WIDTH_1 = 0x1E,
+	ADV76XX_TOTAL_LINE_WIDTH_2 = 0x1F,
+	ADV76XX_HSYNC_FRONT_PORCH_1 = 0x20,
+	ADV76XX_HSYNC_FRONT_PORCH_2 = 0x21,
+	ADV76XX_HSYNC_PULSE_WIDTH_1 = 0x22,
+	ADV76XX_HSYNC_PULSE_WIDTH_2 = 0x23,
+	ADV76XX_HSYNC_BACK_PORCH_1 = 0x24,
+	ADV76XX_HSYNC_BACK_PORCH_2 = 0x25,
+	ADV76XX_FIELD0_TOTAL_HEIGHT_1 = 0x26,
+	ADV76XX_FIELD0_TOTAL_HEIGHT_2 = 0x27,
+	ADV76XX_FIELD1_TOTAL_HEIGHT_1 = 0x28,
+	ADV76XX_FIELD1_TOTAL_HEIGHT_2 = 0x29,
+	ADV76XX_FIELD0_VS_FRONT_PORCH_1 = 0x2A,
+	ADV76XX_FIELD0_VS_FRONT_PORCH_2 = 0x2B,
+	ADV76XX_FIELD1_VS_FRONT_PORCH_1 = 0x2C,
+	ADV76XX_FIELD1_VS_FRONT_PORCH_2 = 0x2D,
+	ADV76XX_FIELD0_VS_PULSE_WIDTH_1 = 0x2E,
+	ADV76XX_FIELD0_VS_PULSE_WIDTH_2 = 0x2F,
+	ADV76XX_FIELD1_VS_PULSE_WIDTH_1 = 0x30,
+	ADV76XX_FIELD1_VS_PULSE_WIDTH_2 = 0x31,
+	ADV76XX_FIELD0_VS_BACK_PORCH_1 = 0x32,
+	ADV76XX_FIELD0_VS_BACK_PORCH_2 = 0x33,
+	ADV76XX_FIELD1_VS_BACK_PORCH_1 = 0x34,
+	ADV76XX_FIELD1_VS_BACK_PORCH_2 = 0x35,
+	ADV76XX_CHANNEL_STATUS_DATA_1 = 0x36,
+	ADV76XX_CHANNEL_STATUS_DATA_2 = 0x37,
+	ADV76XX_CHANNEL_STATUS_DATA_3 = 0x38,
+	ADV76XX_CHANNEL_STATUS_DATA_4 = 0x39,
+	ADV76XX_CHANNEL_STATUS_DATA_5 = 0x3A,
+	ADV76XX_REGISTER_40H = 0x40,
+	ADV76XX_REGISTER_41H = 0x41,
+	ADV76XX_REGISTER_47H = 0x47,
+	ADV76XX_REGISTER_48H = 0x48,
+	ADV76XX_HDMI_REGISTER_50 = 0x50,
+	ADV76XX_TMDSFREQ_8_1 = 0x51,
+	ADV76XX_TMDSFREQ_FRAC = 0x52,
+	ADV76XX_HDMI_COLORSPACE = 0x53,
+	ADV76XX_FILT_5V_DET_REG = 0x56,
+	ADV76XX_REGISTER_5AH = 0x5A,
+	ADV76XX_CTS_N_1	= 0x5B,
+	ADV76XX_CTS_N_2	= 0x5C,
+	ADV76XX_CTS_N_3	= 0x5D,
+	ADV76XX_CTS_N_4	= 0x5E,
+	ADV76XX_CTS_N_5	= 0x5F,
+	ADV76XX_HPA_DELAY_SEL_3_0 = 0x6C,
+	ADV76XX_DSD_MAP_ROT_2_0 = 0x6D,
+	ADV76XX_DST_MAP_ROT_2_0 = 0x6E,
+	ADV76XX_EQ_DYNAMIC_FREQ	 = 0x8C,
+	ADV76XX_EQ_DYN1_LF = 0x8D,
+	ADV76XX_EQ_DYN1_HF = 0x8E,
+	ADV76XX_EQ_DYN2_LF = 0x90,
+	ADV76XX_EQ_DYN2_HF = 0x91,
+	ADV76XX_EQ_DYN3_LF = 0x93,
+	ADV76XX_EQ_DYN3_HF = 0x94,
+	ADV76XX_EQ_DYNAMIC_ENABLE = 0x96,
+};
+
 /* Analog input muxing modes (AFE register 0x02, [2:0]) */
 enum adv7604_ain_sel {
 	ADV7604_AIN1_2_3_NC_SYNC_1_2 = 0,
@@ -66,6 +178,23 @@ enum adv7604_op_format_mode_sel {
 	ADV7604_OP_FORMAT_MODE2 = 0x08,
 };
 
+/* Select output format (HDMI register 0x03, [6:5]) */
+enum adv76xx_i2s_mode_sel {
+	ADV76XX_I2SOUTMODE_MASK = 0x60,
+	ADV76XX_I2SOUTMODE_I2S = 0x00,
+	ADV76XX_I2SOUTMODE_RJ = 0x01 << 5,
+	ADV76XX_I2SOUTMODE_LJ = 0x02 << 5,
+	ADV76XX_I2SOUTMODE_SPDIF = 0x03 << 5,
+};
+
+/* Audio Package detection (HDMI register 0x18, [3:0]) */
+enum adv76xx_audio_pckt_det {
+	ADV76XX_AUDIO_SAMPLE_PCKT_DET = 0x01,
+	ADV76XX_DSD_PACKET_DET = 0x02,
+	ADV7611_DST_AUDIO_PCKT_DET = 0x04,
+	ADV76XX_HBR_AUDIO_PCKT_DET = 0x08,
+};
+
 enum adv7604_drive_strength {
 	ADV7604_DR_STR_MEDIUM_LOW = 1,
 	ADV7604_DR_STR_MEDIUM_HIGH = 2,
-- 
2.2.2

