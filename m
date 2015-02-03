Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:59169 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbbBCRN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 12:13:27 -0500
Received: by mail-we0-f175.google.com with SMTP id p10so46306730wes.6
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 09:13:25 -0800 (PST)
From: Pablo Anton <pablo.anton@vodalys-labs.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mchehab@osg.samsung.com,
	lars@metafoo.de, Pablo Anton <pablo.anton@vodalys-labs.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: i2c: ADV7604: Rename adv7604 prefixes.
Date: Tue,  3 Feb 2015 18:13:18 +0100
Message-Id: <1422983598-9189-1-git-send-email-pablo.anton@vodalys-labs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is confusing which parts of the driver are adv7604 specific, adv7611 specific or common for both.
This patch renames any adv7604 prefixes (both for functions and defines) to adv76xx whenever they are common.

Signed-off-by: Pablo Anton <pablo.anton@vodalys-labs.com>
Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 916 ++++++++++++++++++++++----------------------
 include/media/adv7604.h     |  83 ++--
 2 files changed, 500 insertions(+), 499 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..4837e71 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -53,41 +53,41 @@ MODULE_AUTHOR("Mats Randgaard <mats.randgaard@cisco.com>");
 MODULE_LICENSE("GPL");
 
 /* ADV7604 system clock frequency */
-#define ADV7604_fsc (28636360)
+#define ADV76xx_fsc (28636360)
 
-#define ADV7604_RGB_OUT					(1 << 1)
+#define ADV76XX_RGB_OUT					(1 << 1)
 
-#define ADV7604_OP_FORMAT_SEL_8BIT			(0 << 0)
+#define ADV76XX_OP_FORMAT_SEL_8BIT			(0 << 0)
 #define ADV7604_OP_FORMAT_SEL_10BIT			(1 << 0)
-#define ADV7604_OP_FORMAT_SEL_12BIT			(2 << 0)
+#define ADV76XX_OP_FORMAT_SEL_12BIT			(2 << 0)
 
-#define ADV7604_OP_MODE_SEL_SDR_422			(0 << 5)
+#define ADV76XX_OP_MODE_SEL_SDR_422			(0 << 5)
 #define ADV7604_OP_MODE_SEL_DDR_422			(1 << 5)
-#define ADV7604_OP_MODE_SEL_SDR_444			(2 << 5)
+#define ADV76XX_OP_MODE_SEL_SDR_444			(2 << 5)
 #define ADV7604_OP_MODE_SEL_DDR_444			(3 << 5)
-#define ADV7604_OP_MODE_SEL_SDR_422_2X			(4 << 5)
+#define ADV76XX_OP_MODE_SEL_SDR_422_2X			(4 << 5)
 #define ADV7604_OP_MODE_SEL_ADI_CM			(5 << 5)
 
-#define ADV7604_OP_CH_SEL_GBR				(0 << 5)
-#define ADV7604_OP_CH_SEL_GRB				(1 << 5)
-#define ADV7604_OP_CH_SEL_BGR				(2 << 5)
-#define ADV7604_OP_CH_SEL_RGB				(3 << 5)
-#define ADV7604_OP_CH_SEL_BRG				(4 << 5)
-#define ADV7604_OP_CH_SEL_RBG				(5 << 5)
+#define ADV76XX_OP_CH_SEL_GBR				(0 << 5)
+#define ADV76XX_OP_CH_SEL_GRB				(1 << 5)
+#define ADV76XX_OP_CH_SEL_BGR				(2 << 5)
+#define ADV76XX_OP_CH_SEL_RGB				(3 << 5)
+#define ADV76XX_OP_CH_SEL_BRG				(4 << 5)
+#define ADV76XX_OP_CH_SEL_RBG				(5 << 5)
 
-#define ADV7604_OP_SWAP_CB_CR				(1 << 0)
+#define ADV76XX_OP_SWAP_CB_CR				(1 << 0)
 
-enum adv7604_type {
+enum adv76xx_type {
 	ADV7604,
 	ADV7611,
 };
 
-struct adv7604_reg_seq {
+struct adv76xx_reg_seq {
 	unsigned int reg;
 	u8 val;
 };
 
-struct adv7604_format_info {
+struct adv76xx_format_info {
 	u32 code;
 	u8 op_ch_sel;
 	bool rgb_out;
@@ -95,8 +95,8 @@ struct adv7604_format_info {
 	u8 op_format_sel;
 };
 
-struct adv7604_chip_info {
-	enum adv7604_type type;
+struct adv76xx_chip_info {
+	enum adv76xx_type type;
 
 	bool has_afe;
 	unsigned int max_port;
@@ -110,7 +110,7 @@ struct adv7604_chip_info {
 	unsigned int tdms_lock_mask;
 	unsigned int fmt_change_digital_mask;
 
-	const struct adv7604_format_info *formats;
+	const struct adv76xx_format_info *formats;
 	unsigned int nformats;
 
 	void (*set_termination)(struct v4l2_subdev *sd, bool enable);
@@ -119,7 +119,7 @@ struct adv7604_chip_info {
 	unsigned int (*read_cable_det)(struct v4l2_subdev *sd);
 
 	/* 0 = AFE, 1 = HDMI */
-	const struct adv7604_reg_seq *recommended_settings[2];
+	const struct adv76xx_reg_seq *recommended_settings[2];
 	unsigned int num_recommended_settings[2];
 
 	unsigned long page_mask;
@@ -133,22 +133,22 @@ struct adv7604_chip_info {
  **********************************************************************
  */
 
-struct adv7604_state {
-	const struct adv7604_chip_info *info;
-	struct adv7604_platform_data pdata;
+struct adv76xx_state {
+	const struct adv76xx_chip_info *info;
+	struct adv76xx_platform_data pdata;
 
 	struct gpio_desc *hpd_gpio[4];
 
 	struct v4l2_subdev sd;
-	struct media_pad pads[ADV7604_PAD_MAX];
+	struct media_pad pads[ADV76XX_PAD_MAX];
 	unsigned int source_pad;
 
 	struct v4l2_ctrl_handler hdl;
 
-	enum adv7604_pad selected_input;
+	enum adv76xx_pad selected_input;
 
 	struct v4l2_dv_timings timings;
-	const struct adv7604_format_info *format;
+	const struct adv76xx_format_info *format;
 
 	struct {
 		u8 edid[256];
@@ -163,7 +163,7 @@ struct adv7604_state {
 	bool restart_stdi_once;
 
 	/* i2c clients */
-	struct i2c_client *i2c_clients[ADV7604_PAGE_MAX];
+	struct i2c_client *i2c_clients[ADV76XX_PAGE_MAX];
 
 	/* controls */
 	struct v4l2_ctrl *detect_tx_5v_ctrl;
@@ -173,13 +173,13 @@ struct adv7604_state {
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
 };
 
-static bool adv7604_has_afe(struct adv7604_state *state)
+static bool adv76xx_has_afe(struct adv76xx_state *state)
 {
 	return state->info->has_afe;
 }
 
 /* Supported CEA and DMT timings */
-static const struct v4l2_dv_timings adv7604_timings[] = {
+static const struct v4l2_dv_timings adv76xx_timings[] = {
 	V4L2_DV_BT_CEA_720X480P59_94,
 	V4L2_DV_BT_CEA_720X576P50,
 	V4L2_DV_BT_CEA_1280X720P24,
@@ -243,14 +243,14 @@ static const struct v4l2_dv_timings adv7604_timings[] = {
 	{ },
 };
 
-struct adv7604_video_standards {
+struct adv76xx_video_standards {
 	struct v4l2_dv_timings timings;
 	u8 vid_std;
 	u8 v_freq;
 };
 
 /* sorted by number of lines */
-static const struct adv7604_video_standards adv7604_prim_mode_comp[] = {
+static const struct adv76xx_video_standards adv7604_prim_mode_comp[] = {
 	/* { V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 }, TODO flickering */
 	{ V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
 	{ V4L2_DV_BT_CEA_1280X720P50, 0x19, 0x01 },
@@ -265,7 +265,7 @@ static const struct adv7604_video_standards adv7604_prim_mode_comp[] = {
 };
 
 /* sorted by number of lines */
-static const struct adv7604_video_standards adv7604_prim_mode_gr[] = {
+static const struct adv76xx_video_standards adv7604_prim_mode_gr[] = {
 	{ V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
 	{ V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
 	{ V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
@@ -293,7 +293,7 @@ static const struct adv7604_video_standards adv7604_prim_mode_gr[] = {
 };
 
 /* sorted by number of lines */
-static const struct adv7604_video_standards adv7604_prim_mode_hdmi_comp[] = {
+static const struct adv76xx_video_standards adv76xx_prim_mode_hdmi_comp[] = {
 	{ V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 },
 	{ V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
 	{ V4L2_DV_BT_CEA_1280X720P50, 0x13, 0x01 },
@@ -307,7 +307,7 @@ static const struct adv7604_video_standards adv7604_prim_mode_hdmi_comp[] = {
 };
 
 /* sorted by number of lines */
-static const struct adv7604_video_standards adv7604_prim_mode_hdmi_gr[] = {
+static const struct adv76xx_video_standards adv76xx_prim_mode_hdmi_gr[] = {
 	{ V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
 	{ V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
 	{ V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
@@ -328,9 +328,9 @@ static const struct adv7604_video_standards adv7604_prim_mode_hdmi_gr[] = {
 
 /* ----------------------------------------------------------------------- */
 
-static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
+static inline struct adv76xx_state *to_state(struct v4l2_subdev *sd)
 {
-	return container_of(sd, struct adv7604_state, sd);
+	return container_of(sd, struct adv76xx_state, sd);
 }
 
 static inline unsigned hblanking(const struct v4l2_bt_timings *t)
@@ -370,15 +370,15 @@ static s32 adv_smbus_read_byte_data_check(struct i2c_client *client,
 	return -EIO;
 }
 
-static s32 adv_smbus_read_byte_data(struct adv7604_state *state,
-				    enum adv7604_page page, u8 command)
+static s32 adv_smbus_read_byte_data(struct adv76xx_state *state,
+				    enum adv76xx_page page, u8 command)
 {
 	return adv_smbus_read_byte_data_check(state->i2c_clients[page],
 					      command, true);
 }
 
-static s32 adv_smbus_write_byte_data(struct adv7604_state *state,
-				     enum adv7604_page page, u8 command,
+static s32 adv_smbus_write_byte_data(struct adv76xx_state *state,
+				     enum adv76xx_page page, u8 command,
 				     u8 value)
 {
 	struct i2c_client *client = state->i2c_clients[page];
@@ -401,8 +401,8 @@ static s32 adv_smbus_write_byte_data(struct adv7604_state *state,
 	return err;
 }
 
-static s32 adv_smbus_write_i2c_block_data(struct adv7604_state *state,
-					  enum adv7604_page page, u8 command,
+static s32 adv_smbus_write_i2c_block_data(struct adv76xx_state *state,
+					  enum adv76xx_page page, u8 command,
 					  unsigned length, const u8 *values)
 {
 	struct i2c_client *client = state->i2c_clients[page];
@@ -421,16 +421,16 @@ static s32 adv_smbus_write_i2c_block_data(struct adv7604_state *state,
 
 static inline int io_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_IO, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_IO, reg);
 }
 
 static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_IO, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_IO, reg, val);
 }
 
 static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -440,30 +440,30 @@ static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 v
 
 static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AVLINK, reg);
 }
 
 static inline int avlink_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AVLINK, reg, val);
 }
 
 static inline int cec_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CEC, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_CEC, reg);
 }
 
 static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CEC, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_CEC, reg, val);
 }
 
 static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -473,73 +473,73 @@ static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8
 
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_INFOFRAME, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_INFOFRAME, reg);
 }
 
 static inline int infoframe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_INFOFRAME,
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_INFOFRAME,
 					 reg, val);
 }
 
 static inline int esdp_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_read_byte_data(state, ADV7604_PAGE_ESDP, reg);
 }
 
 static inline int esdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_ESDP, reg, val);
 }
 
 static inline int dpp_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_read_byte_data(state, ADV7604_PAGE_DPP, reg);
 }
 
 static inline int dpp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_DPP, reg, val);
 }
 
 static inline int afe_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AFE, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_AFE, reg);
 }
 
 static inline int afe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AFE, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_AFE, reg, val);
 }
 
 static inline int rep_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_REP, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_REP, reg);
 }
 
 static inline int rep_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_REP, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_REP, reg, val);
 }
 
 static inline int rep_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -549,22 +549,22 @@ static inline int rep_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8
 
 static inline int edid_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_EDID, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_EDID, reg);
 }
 
 static inline int edid_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_EDID, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_EDID, reg, val);
 }
 
 static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 {
-	struct adv7604_state *state = to_state(sd);
-	struct i2c_client *client = state->i2c_clients[ADV7604_PAGE_EDID];
+	struct adv76xx_state *state = to_state(sd);
+	struct i2c_client *client = state->i2c_clients[ADV76XX_PAGE_EDID];
 	u8 msgbuf0[1] = { 0 };
 	u8 msgbuf1[256];
 	struct i2c_msg msg[2] = {
@@ -590,19 +590,19 @@ static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 static inline int edid_write_block(struct v4l2_subdev *sd,
 					unsigned len, const u8 *val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	int err = 0;
 	int i;
 
 	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
 
 	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
-		err = adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_EDID,
+		err = adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_EDID,
 				i, I2C_SMBUS_BLOCK_MAX, val + i);
 	return err;
 }
 
-static void adv7604_set_hpd(struct adv7604_state *state, unsigned int hpd)
+static void adv76xx_set_hpd(struct adv76xx_state *state, unsigned int hpd)
 {
 	unsigned int i;
 
@@ -613,26 +613,26 @@ static void adv7604_set_hpd(struct adv7604_state *state, unsigned int hpd)
 		gpiod_set_value_cansleep(state->hpd_gpio[i], hpd & BIT(i));
 	}
 
-	v4l2_subdev_notify(&state->sd, ADV7604_HOTPLUG, &hpd);
+	v4l2_subdev_notify(&state->sd, ADV76XX_HOTPLUG, &hpd);
 }
 
-static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
+static void adv76xx_delayed_work_enable_hotplug(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct adv7604_state *state = container_of(dwork, struct adv7604_state,
+	struct adv76xx_state *state = container_of(dwork, struct adv76xx_state,
 						delayed_work_enable_hotplug);
 	struct v4l2_subdev *sd = &state->sd;
 
 	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
 
-	adv7604_set_hpd(state, state->edid.present);
+	adv76xx_set_hpd(state, state->edid.present);
 }
 
 static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_HDMI, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_HDMI, reg);
 }
 
 static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -642,9 +642,9 @@ static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
 
 static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_HDMI, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_HDMI, reg, val);
 }
 
 static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -654,23 +654,23 @@ static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8
 
 static inline int test_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_TEST, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_TEST, reg);
 }
 
 static inline int test_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_TEST, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_TEST, reg, val);
 }
 
 static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_CP, reg);
+	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_CP, reg);
 }
 
 static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
@@ -680,9 +680,9 @@ static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
 
 static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CP, reg, val);
+	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_CP, reg, val);
 }
 
 static inline int cp_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
@@ -692,25 +692,25 @@ static inline int cp_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 v
 
 static inline int vdp_read(struct v4l2_subdev *sd, u8 reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_read_byte_data(state, ADV7604_PAGE_VDP, reg);
 }
 
 static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_VDP, reg, val);
 }
 
-#define ADV7604_REG(page, offset)	(((page) << 8) | (offset))
-#define ADV7604_REG_SEQ_TERM		0xffff
+#define ADV76XX_REG(page, offset)	(((page) << 8) | (offset))
+#define ADV76XX_REG_SEQ_TERM		0xffff
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int adv7604_read_reg(struct v4l2_subdev *sd, unsigned int reg)
+static int adv76xx_read_reg(struct v4l2_subdev *sd, unsigned int reg)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	unsigned int page = reg >> 8;
 
 	if (!(BIT(page) & state->info->page_mask))
@@ -722,9 +722,9 @@ static int adv7604_read_reg(struct v4l2_subdev *sd, unsigned int reg)
 }
 #endif
 
-static int adv7604_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
+static int adv76xx_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	unsigned int page = reg >> 8;
 
 	if (!(BIT(page) & state->info->page_mask))
@@ -735,91 +735,91 @@ static int adv7604_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
 	return adv_smbus_write_byte_data(state, page, reg, val);
 }
 
-static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
-				  const struct adv7604_reg_seq *reg_seq)
+static void adv76xx_write_reg_seq(struct v4l2_subdev *sd,
+				  const struct adv76xx_reg_seq *reg_seq)
 {
 	unsigned int i;
 
-	for (i = 0; reg_seq[i].reg != ADV7604_REG_SEQ_TERM; i++)
-		adv7604_write_reg(sd, reg_seq[i].reg, reg_seq[i].val);
+	for (i = 0; reg_seq[i].reg != ADV76XX_REG_SEQ_TERM; i++)
+		adv76xx_write_reg(sd, reg_seq[i].reg, reg_seq[i].val);
 }
 
 /* -----------------------------------------------------------------------------
  * Format helpers
  */
 
-static const struct adv7604_format_info adv7604_formats[] = {
-	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
-	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+static const struct adv76xx_format_info adv7604_formats[] = {
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV76XX_OP_CH_SEL_RGB, true, false,
+	  ADV76XX_OP_MODE_SEL_SDR_444 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV10_2X10, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YVYU10_2X10, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_UYVY10_1X20, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_VYUY10_1X20, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YUYV10_1X20, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YVYU10_1X20, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
 };
 
-static const struct adv7604_format_info adv7611_formats[] = {
-	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
-	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
-	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+static const struct adv76xx_format_info adv7611_formats[] = {
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV76XX_OP_CH_SEL_RGB, true, false,
+	  ADV76XX_OP_MODE_SEL_SDR_444 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
 };
 
-static const struct adv7604_format_info *
-adv7604_format_info(struct adv7604_state *state, u32 code)
+static const struct adv76xx_format_info *
+adv76xx_format_info(struct adv76xx_state *state, u32 code)
 {
 	unsigned int i;
 
@@ -835,7 +835,7 @@ adv7604_format_info(struct adv7604_state *state, u32 code)
 
 static inline bool is_analog_input(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return state->selected_input == ADV7604_PAD_VGA_RGB ||
 	       state->selected_input == ADV7604_PAD_VGA_COMP;
@@ -843,9 +843,9 @@ static inline bool is_analog_input(struct v4l2_subdev *sd)
 
 static inline bool is_digital_input(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	return state->selected_input == ADV7604_PAD_HDMI_PORT_A ||
+	return state->selected_input == ADV76XX_PAD_HDMI_PORT_A ||
 	       state->selected_input == ADV7604_PAD_HDMI_PORT_B ||
 	       state->selected_input == ADV7604_PAD_HDMI_PORT_C ||
 	       state->selected_input == ADV7604_PAD_HDMI_PORT_D;
@@ -854,7 +854,7 @@ static inline bool is_digital_input(struct v4l2_subdev *sd)
 /* ----------------------------------------------------------------------- */
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static void adv7604_inv_register(struct v4l2_subdev *sd)
+static void adv76xx_inv_register(struct v4l2_subdev *sd)
 {
 	v4l2_info(sd, "0x000-0x0ff: IO Map\n");
 	v4l2_info(sd, "0x100-0x1ff: AVLink Map\n");
@@ -871,15 +871,15 @@ static void adv7604_inv_register(struct v4l2_subdev *sd)
 	v4l2_info(sd, "0xc00-0xcff: VDP Map\n");
 }
 
-static int adv7604_g_register(struct v4l2_subdev *sd,
+static int adv76xx_g_register(struct v4l2_subdev *sd,
 					struct v4l2_dbg_register *reg)
 {
 	int ret;
 
-	ret = adv7604_read_reg(sd, reg->reg);
+	ret = adv76xx_read_reg(sd, reg->reg);
 	if (ret < 0) {
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
-		adv7604_inv_register(sd);
+		adv76xx_inv_register(sd);
 		return ret;
 	}
 
@@ -889,15 +889,15 @@ static int adv7604_g_register(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7604_s_register(struct v4l2_subdev *sd,
+static int adv76xx_s_register(struct v4l2_subdev *sd,
 					const struct v4l2_dbg_register *reg)
 {
 	int ret;
 
-	ret = adv7604_write_reg(sd, reg->reg, reg->val);
+	ret = adv76xx_write_reg(sd, reg->reg, reg->val);
 	if (ret < 0) {
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
-		adv7604_inv_register(sd);
+		adv76xx_inv_register(sd);
 		return ret;
 	}
 
@@ -922,10 +922,10 @@ static unsigned int adv7611_read_cable_det(struct v4l2_subdev *sd)
 	return value & 1;
 }
 
-static int adv7604_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
+static int adv76xx_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 
 	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
 				info->read_cable_det(sd));
@@ -933,7 +933,7 @@ static int adv7604_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 		u8 prim_mode,
-		const struct adv7604_video_standards *predef_vid_timings,
+		const struct adv76xx_video_standards *predef_vid_timings,
 		const struct v4l2_dv_timings *timings)
 {
 	int i;
@@ -954,12 +954,12 @@ static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	int err;
 
 	v4l2_dbg(1, debug, sd, "%s", __func__);
 
-	if (adv7604_has_afe(state)) {
+	if (adv76xx_has_afe(state)) {
 		/* reset to default values */
 		io_write(sd, 0x16, 0x43);
 		io_write(sd, 0x17, 0x5a);
@@ -985,10 +985,10 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 					0x02, adv7604_prim_mode_gr, timings);
 	} else if (is_digital_input(sd)) {
 		err = find_and_set_predefined_video_timings(sd,
-				0x05, adv7604_prim_mode_hdmi_comp, timings);
+				0x05, adv76xx_prim_mode_hdmi_comp, timings);
 		if (err)
 			err = find_and_set_predefined_video_timings(sd,
-					0x06, adv7604_prim_mode_hdmi_gr, timings);
+					0x06, adv76xx_prim_mode_hdmi_gr, timings);
 	} else {
 		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
 				__func__, state->selected_input);
@@ -1002,7 +1002,7 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		const struct v4l2_bt_timings *bt)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	u32 width = htotal(bt);
 	u32 height = vtotal(bt);
 	u16 cp_start_sav = bt->hsync + bt->hbackporch - 4;
@@ -1010,7 +1010,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 	u16 cp_start_vbi = height - bt->vfrontporch;
 	u16 cp_end_vbi = bt->vsync + bt->vbackporch;
 	u16 ch1_fr_ll = (((u32)bt->pixelclock / 100) > 0) ?
-		((width * (ADV7604_fsc / 100)) / ((u32)bt->pixelclock / 100)) : 0;
+		((width * (ADV76xx_fsc / 100)) / ((u32)bt->pixelclock / 100)) : 0;
 	const u8 pll[2] = {
 		0xc0 | ((width >> 8) & 0x1f),
 		width & 0xff
@@ -1028,7 +1028,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
 		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
-		if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_IO,
+		if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_IO,
 						   0x16, 2, pll))
 			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
 
@@ -1059,9 +1059,9 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 	cp_write(sd, 0xac, (height & 0x0f) << 4);
 }
 
-static void adv7604_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 offset_a, u16 offset_b, u16 offset_c)
+static void adv76xx_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 offset_a, u16 offset_b, u16 offset_c)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	u8 offset_buf[4];
 
 	if (auto_offset) {
@@ -1080,14 +1080,14 @@ static void adv7604_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 off
 	offset_buf[3] = offset_c & 0x0ff;
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
+	if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_CP,
 					   0x77, 4, offset_buf))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x77, 0x78, 0x79, 0x7a\n", __func__);
 }
 
-static void adv7604_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a, u16 gain_b, u16 gain_c)
+static void adv76xx_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a, u16 gain_b, u16 gain_c)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	u8 gain_buf[4];
 	u8 gain_man = 1;
 	u8 agc_mode_man = 1;
@@ -1110,14 +1110,14 @@ static void adv7604_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a,
 	gain_buf[3] = ((gain_c & 0x0ff));
 
 	/* Registers must be written in this order with no i2c access in between */
-	if (adv_smbus_write_i2c_block_data(state, ADV7604_PAGE_CP,
+	if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_CP,
 					   0x73, 4, gain_buf))
 		v4l2_err(sd, "%s: i2c error writing to CP reg 0x73, 0x74, 0x75, 0x76\n", __func__);
 }
 
 static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	bool rgb_output = io_read(sd, 0x02) & 0x02;
 	bool hdmi_signal = hdmi_read(sd, 0x05) & 0x80;
 
@@ -1125,8 +1125,8 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			__func__, state->rgb_quantization_range,
 			rgb_output, hdmi_signal);
 
-	adv7604_set_gain(sd, true, 0x0, 0x0, 0x0);
-	adv7604_set_offset(sd, true, 0x0, 0x0, 0x0);
+	adv76xx_set_gain(sd, true, 0x0, 0x0, 0x0);
+	adv76xx_set_offset(sd, true, 0x0, 0x0, 0x0);
 
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
@@ -1162,10 +1162,10 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			io_write_clr_set(sd, 0x02, 0xf0, 0x10);
 
 			if (is_digital_input(sd) && rgb_output) {
-				adv7604_set_offset(sd, false, 0x40, 0x40, 0x40);
+				adv76xx_set_offset(sd, false, 0x40, 0x40, 0x40);
 			} else {
-				adv7604_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
-				adv7604_set_offset(sd, false, 0x70, 0x70, 0x70);
+				adv76xx_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
+				adv76xx_set_offset(sd, false, 0x70, 0x70, 0x70);
 			}
 		}
 		break;
@@ -1195,21 +1195,21 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 
 		/* Adjust gain/offset for DVI-D signals only */
 		if (rgb_output) {
-			adv7604_set_offset(sd, false, 0x40, 0x40, 0x40);
+			adv76xx_set_offset(sd, false, 0x40, 0x40, 0x40);
 		} else {
-			adv7604_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
-			adv7604_set_offset(sd, false, 0x70, 0x70, 0x70);
+			adv76xx_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
+			adv76xx_set_offset(sd, false, 0x70, 0x70, 0x70);
 		}
 		break;
 	}
 }
 
-static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
+static int adv76xx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd =
-		&container_of(ctrl->handler, struct adv7604_state, hdl)->sd;
+		&container_of(ctrl->handler, struct adv76xx_state, hdl)->sd;
 
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -1229,7 +1229,7 @@ static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 		set_rgb_quantization_range(sd);
 		return 0;
 	case V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE:
-		if (!adv7604_has_afe(state))
+		if (!adv76xx_has_afe(state))
 			return -EINVAL;
 		/* Set the analog sampling phase. This is needed to find the
 		   best sampling phase for analog video: an application or
@@ -1261,15 +1261,15 @@ static inline bool no_power(struct v4l2_subdev *sd)
 
 static inline bool no_signal_tmds(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	return !(io_read(sd, 0x6a) & (0x10 >> state->selected_input));
 }
 
 static inline bool no_lock_tmds(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 
 	return (io_read(sd, 0x6a) & info->tdms_lock_mask) != info->tdms_lock_mask;
 }
@@ -1281,13 +1281,13 @@ static inline bool is_hdmi(struct v4l2_subdev *sd)
 
 static inline bool no_lock_sspd(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	/*
 	 * Chips without a AFE don't expose registers for the SSPD, so just assume
 	 * that we have a lock.
 	 */
-	if (adv7604_has_afe(state))
+	if (adv76xx_has_afe(state))
 		return false;
 
 	/* TODO channel 2 */
@@ -1319,9 +1319,9 @@ static inline bool no_signal(struct v4l2_subdev *sd)
 
 static inline bool no_lock_cp(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	if (!adv7604_has_afe(state))
+	if (!adv76xx_has_afe(state))
 		return false;
 
 	/* CP has detected a non standard number of lines on the incoming
@@ -1329,7 +1329,7 @@ static inline bool no_lock_cp(struct v4l2_subdev *sd)
 	return io_read(sd, 0x12) & 0x01;
 }
 
-static int adv7604_g_input_status(struct v4l2_subdev *sd, u32 *status)
+static int adv76xx_g_input_status(struct v4l2_subdev *sd, u32 *status)
 {
 	*status = 0;
 	*status |= no_power(sd) ? V4L2_IN_ST_NO_POWER : 0;
@@ -1354,22 +1354,22 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 		struct stdi_readback *stdi,
 		struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
-	u32 hfreq = (ADV7604_fsc * 8) / stdi->bl;
+	struct adv76xx_state *state = to_state(sd);
+	u32 hfreq = (ADV76xx_fsc * 8) / stdi->bl;
 	u32 pix_clk;
 	int i;
 
-	for (i = 0; adv7604_timings[i].bt.height; i++) {
-		if (vtotal(&adv7604_timings[i].bt) != stdi->lcf + 1)
+	for (i = 0; adv76xx_timings[i].bt.height; i++) {
+		if (vtotal(&adv76xx_timings[i].bt) != stdi->lcf + 1)
 			continue;
-		if (adv7604_timings[i].bt.vsync != stdi->lcvs)
+		if (adv76xx_timings[i].bt.vsync != stdi->lcvs)
 			continue;
 
-		pix_clk = hfreq * htotal(&adv7604_timings[i].bt);
+		pix_clk = hfreq * htotal(&adv76xx_timings[i].bt);
 
-		if ((pix_clk < adv7604_timings[i].bt.pixelclock + 1000000) &&
-		    (pix_clk > adv7604_timings[i].bt.pixelclock - 1000000)) {
-			*timings = adv7604_timings[i];
+		if ((pix_clk < adv76xx_timings[i].bt.pixelclock + 1000000) &&
+		    (pix_clk > adv76xx_timings[i].bt.pixelclock - 1000000)) {
+			*timings = adv76xx_timings[i];
 			return 0;
 		}
 	}
@@ -1395,8 +1395,8 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 
 static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	u8 polarity;
 
 	if (no_lock_stdi(sd) || no_lock_sspd(sd)) {
@@ -1410,7 +1410,7 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 	stdi->lcvs = cp_read(sd, 0xb3) >> 3;
 	stdi->interlaced = io_read(sd, 0x12) & 0x10;
 
-	if (adv7604_has_afe(state)) {
+	if (adv76xx_has_afe(state)) {
 		/* read SSPD */
 		polarity = cp_read(sd, 0xb5);
 		if ((polarity & 0x03) == 0x01) {
@@ -1449,26 +1449,26 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 	return 0;
 }
 
-static int adv7604_enum_dv_timings(struct v4l2_subdev *sd,
+static int adv76xx_enum_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_enum_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
-	if (timings->index >= ARRAY_SIZE(adv7604_timings) - 1)
+	if (timings->index >= ARRAY_SIZE(adv76xx_timings) - 1)
 		return -EINVAL;
 
 	if (timings->pad >= state->source_pad)
 		return -EINVAL;
 
 	memset(timings->reserved, 0, sizeof(timings->reserved));
-	timings->timings = adv7604_timings[timings->index];
+	timings->timings = adv76xx_timings[timings->index];
 	return 0;
 }
 
-static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
+static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings_cap *cap)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	if (cap->pad >= state->source_pad)
 		return -EINVAL;
@@ -1479,7 +1479,7 @@ static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 	cap->bt.min_pixelclock = 25000000;
 
 	switch (cap->pad) {
-	case ADV7604_PAD_HDMI_PORT_A:
+	case ADV76XX_PAD_HDMI_PORT_A:
 	case ADV7604_PAD_HDMI_PORT_B:
 	case ADV7604_PAD_HDMI_PORT_C:
 	case ADV7604_PAD_HDMI_PORT_D:
@@ -1500,16 +1500,16 @@ static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 }
 
 /* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
-   if the format is listed in adv7604_timings[] */
-static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
+   if the format is listed in adv76xx_timings[] */
+static void adv76xx_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
 	int i;
 
-	for (i = 0; adv7604_timings[i].bt.width; i++) {
-		if (v4l2_match_dv_timings(timings, &adv7604_timings[i],
+	for (i = 0; adv76xx_timings[i].bt.width; i++) {
+		if (v4l2_match_dv_timings(timings, &adv76xx_timings[i],
 					is_digital_input(sd) ? 250000 : 1000000)) {
-			*timings = adv7604_timings[i];
+			*timings = adv76xx_timings[i];
 			break;
 		}
 	}
@@ -1547,11 +1547,11 @@ static unsigned int adv7611_read_hdmi_pixelclock(struct v4l2_subdev *sd)
 	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
 }
 
-static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
+static int adv76xx_query_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	struct v4l2_bt_timings *bt = &timings->bt;
 	struct stdi_readback stdi;
 
@@ -1595,7 +1595,7 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 			bt->il_vsync = hdmi_read16(sd, 0x30, 0x1fff) / 2;
 			bt->il_vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
 		}
-		adv7604_fill_optional_dv_timings_fields(sd, timings);
+		adv76xx_fill_optional_dv_timings_fields(sd, timings);
 	} else {
 		/* find format
 		 * Since LCVS values are inaccurate [REF_03, p. 275-276],
@@ -1652,16 +1652,16 @@ found:
 	}
 
 	if (debug > 1)
-		v4l2_print_dv_timings(sd->name, "adv7604_query_dv_timings: ",
+		v4l2_print_dv_timings(sd->name, "adv76xx_query_dv_timings: ",
 				      timings, true);
 
 	return 0;
 }
 
-static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
+static int adv76xx_s_dv_timings(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	struct v4l2_bt_timings *bt;
 	int err;
 
@@ -1682,7 +1682,7 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 		return -ERANGE;
 	}
 
-	adv7604_fill_optional_dv_timings_fields(sd, timings);
+	adv76xx_fill_optional_dv_timings_fields(sd, timings);
 
 	state->timings = *timings;
 
@@ -1699,15 +1699,15 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 	set_rgb_quantization_range(sd);
 
 	if (debug > 1)
-		v4l2_print_dv_timings(sd->name, "adv7604_s_dv_timings: ",
+		v4l2_print_dv_timings(sd->name, "adv76xx_s_dv_timings: ",
 				      timings, true);
 	return 0;
 }
 
-static int adv7604_g_dv_timings(struct v4l2_subdev *sd,
+static int adv76xx_g_dv_timings(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	*timings = state->timings;
 	return 0;
@@ -1725,7 +1725,7 @@ static void adv7611_set_termination(struct v4l2_subdev *sd, bool enable)
 
 static void enable_input(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	if (is_analog_input(sd)) {
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
@@ -1742,7 +1742,7 @@ static void enable_input(struct v4l2_subdev *sd)
 
 static void disable_input(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	hdmi_write_clr_set(sd, 0x1a, 0x10, 0x10); /* Mute audio */
 	msleep(16); /* 512 samples with >= 32 kHz sample rate [REF_03, c. 7.16.10] */
@@ -1752,11 +1752,11 @@ static void disable_input(struct v4l2_subdev *sd)
 
 static void select_input(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 
 	if (is_analog_input(sd)) {
-		adv7604_write_reg_seq(sd, info->recommended_settings[0]);
+		adv76xx_write_reg_seq(sd, info->recommended_settings[0]);
 
 		afe_write(sd, 0x00, 0x08); /* power up ADC */
 		afe_write(sd, 0x01, 0x06); /* power up Analog Front End */
@@ -1764,9 +1764,9 @@ static void select_input(struct v4l2_subdev *sd)
 	} else if (is_digital_input(sd)) {
 		hdmi_write(sd, 0x00, state->selected_input & 0x03);
 
-		adv7604_write_reg_seq(sd, info->recommended_settings[1]);
+		adv76xx_write_reg_seq(sd, info->recommended_settings[1]);
 
-		if (adv7604_has_afe(state)) {
+		if (adv76xx_has_afe(state)) {
 			afe_write(sd, 0x00, 0xff); /* power down ADC */
 			afe_write(sd, 0x01, 0xfe); /* power down Analog Front End */
 			afe_write(sd, 0xc8, 0x40); /* phase control */
@@ -1781,10 +1781,10 @@ static void select_input(struct v4l2_subdev *sd)
 	}
 }
 
-static int adv7604_s_routing(struct v4l2_subdev *sd,
+static int adv76xx_s_routing(struct v4l2_subdev *sd,
 		u32 input, u32 output, u32 config)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	v4l2_dbg(2, debug, sd, "%s: input %d, selected input %d",
 			__func__, input, state->selected_input);
@@ -1806,11 +1806,11 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7604_enum_mbus_code(struct v4l2_subdev *sd,
+static int adv76xx_enum_mbus_code(struct v4l2_subdev *sd,
 				  struct v4l2_subdev_fh *fh,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	if (code->index >= state->info->nformats)
 		return -EINVAL;
@@ -1820,7 +1820,7 @@ static int adv7604_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static void adv7604_fill_format(struct adv7604_state *state,
+static void adv76xx_fill_format(struct adv76xx_state *state,
 				struct v4l2_mbus_framefmt *format)
 {
 	memset(format, 0, sizeof(*format));
@@ -1841,7 +1841,7 @@ static void adv7604_fill_format(struct adv7604_state *state,
  *
  * The following table gives the op_ch_value from the format component order
  * (expressed as op_ch_sel value in column) and the bus reordering (expressed as
- * adv7604_bus_order value in row).
+ * adv76xx_bus_order value in row).
  *
  *           |	GBR(0)	GRB(1)	BGR(2)	RGB(3)	BRG(4)	RBG(5)
  * ----------+-------------------------------------------------
@@ -1852,11 +1852,11 @@ static void adv7604_fill_format(struct adv7604_state *state,
  * BRG (ROR) |	BRG	RBG	GRB	GBR	RGB	BGR
  * GBR (ROL) |	RGB	BGR	RBG	BRG	GBR	GRB
  */
-static unsigned int adv7604_op_ch_sel(struct adv7604_state *state)
+static unsigned int adv76xx_op_ch_sel(struct adv76xx_state *state)
 {
 #define _SEL(a,b,c,d,e,f)	{ \
-	ADV7604_OP_CH_SEL_##a, ADV7604_OP_CH_SEL_##b, ADV7604_OP_CH_SEL_##c, \
-	ADV7604_OP_CH_SEL_##d, ADV7604_OP_CH_SEL_##e, ADV7604_OP_CH_SEL_##f }
+	ADV76XX_OP_CH_SEL_##a, ADV76XX_OP_CH_SEL_##b, ADV76XX_OP_CH_SEL_##c, \
+	ADV76XX_OP_CH_SEL_##d, ADV76XX_OP_CH_SEL_##e, ADV76XX_OP_CH_SEL_##f }
 #define _BUS(x)			[ADV7604_BUS_ORDER_##x]
 
 	static const unsigned int op_ch_sel[6][6] = {
@@ -1871,28 +1871,28 @@ static unsigned int adv7604_op_ch_sel(struct adv7604_state *state)
 	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel >> 5];
 }
 
-static void adv7604_setup_format(struct adv7604_state *state)
+static void adv76xx_setup_format(struct adv76xx_state *state)
 {
 	struct v4l2_subdev *sd = &state->sd;
 
 	io_write_clr_set(sd, 0x02, 0x02,
-			state->format->rgb_out ? ADV7604_RGB_OUT : 0);
+			state->format->rgb_out ? ADV76XX_RGB_OUT : 0);
 	io_write(sd, 0x03, state->format->op_format_sel |
 		 state->pdata.op_format_mode_sel);
-	io_write_clr_set(sd, 0x04, 0xe0, adv7604_op_ch_sel(state));
+	io_write_clr_set(sd, 0x04, 0xe0, adv76xx_op_ch_sel(state));
 	io_write_clr_set(sd, 0x05, 0x01,
-			state->format->swap_cb_cr ? ADV7604_OP_SWAP_CB_CR : 0);
+			state->format->swap_cb_cr ? ADV76XX_OP_SWAP_CB_CR : 0);
 }
 
-static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int adv76xx_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_format *format)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	if (format->pad != state->source_pad)
 		return -EINVAL;
 
-	adv7604_fill_format(state, &format->format);
+	adv76xx_fill_format(state, &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
@@ -1906,20 +1906,20 @@ static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int adv76xx_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_format *format)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_format_info *info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_format_info *info;
 
 	if (format->pad != state->source_pad)
 		return -EINVAL;
 
-	info = adv7604_format_info(state, format->format.code);
+	info = adv76xx_format_info(state, format->format.code);
 	if (info == NULL)
-		info = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
+		info = adv76xx_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
-	adv7604_fill_format(state, &format->format);
+	adv76xx_fill_format(state, &format->format);
 	format->format.code = info->code;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -1929,16 +1929,16 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		fmt->code = format->format.code;
 	} else {
 		state->format = info;
-		adv7604_setup_format(state);
+		adv76xx_setup_format(state);
 	}
 
 	return 0;
 }
 
-static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
+static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	const u8 irq_reg_0x43 = io_read(sd, 0x43);
 	const u8 irq_reg_0x6b = io_read(sd, 0x6b);
 	const u8 irq_reg_0x70 = io_read(sd, 0x70);
@@ -1966,7 +1966,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
 			__func__, fmt_change, fmt_change_digital);
 
-		v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
+		v4l2_subdev_notify(sd, ADV76XX_FMT_CHANGE, NULL);
 
 		if (handled)
 			*handled = true;
@@ -1985,22 +1985,22 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	if (tx_5v) {
 		v4l2_dbg(1, debug, sd, "%s: tx_5v: 0x%x\n", __func__, tx_5v);
 		io_write(sd, 0x71, tx_5v);
-		adv7604_s_detect_tx_5v_ctrl(sd);
+		adv76xx_s_detect_tx_5v_ctrl(sd);
 		if (handled)
 			*handled = true;
 	}
 	return 0;
 }
 
-static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
+static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 	u8 *data = NULL;
 
 	memset(edid->reserved, 0, sizeof(edid->reserved));
 
 	switch (edid->pad) {
-	case ADV7604_PAD_HDMI_PORT_A:
+	case ADV76XX_PAD_HDMI_PORT_A:
 	case ADV7604_PAD_HDMI_PORT_B:
 	case ADV7604_PAD_HDMI_PORT_C:
 	case ADV7604_PAD_HDMI_PORT_D:
@@ -2058,10 +2058,10 @@ static int get_edid_spa_location(const u8 *edid)
 	return -1;
 }
 
-static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
+static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	int spa_loc;
 	int err;
 	int i;
@@ -2075,7 +2075,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	if (edid->blocks == 0) {
 		/* Disable hotplug and I2C access to EDID RAM from DDC port */
 		state->edid.present &= ~(1 << edid->pad);
-		adv7604_set_hpd(state, state->edid.present);
+		adv76xx_set_hpd(state, state->edid.present);
 		rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, state->edid.present);
 
 		/* Fall back to a 16:9 aspect ratio */
@@ -2099,7 +2099,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 
 	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
-	adv7604_set_hpd(state, 0);
+	adv76xx_set_hpd(state, 0);
 	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, 0x00);
 
 	spa_loc = get_edid_spa_location(edid->edid);
@@ -2107,7 +2107,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		spa_loc = 0xc0; /* Default value [REF_02, p. 116] */
 
 	switch (edid->pad) {
-	case ADV7604_PAD_HDMI_PORT_A:
+	case ADV76XX_PAD_HDMI_PORT_A:
 		state->spa_port_a[0] = edid->edid[spa_loc];
 		state->spa_port_a[1] = edid->edid[spa_loc + 1];
 		break;
@@ -2150,7 +2150,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return err;
 	}
 
-	/* adv7604 calculates the checksums and enables I2C access to internal
+	/* adv76xx calculates the checksums and enables I2C access to internal
 	   EDID RAM from DDC port. */
 	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, state->edid.present);
 
@@ -2214,10 +2214,10 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 		buf[8], buf[9], buf[10], buf[11], buf[12], buf[13]);
 }
 
-static int adv7604_log_status(struct v4l2_subdev *sd)
+static int adv76xx_log_status(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	struct v4l2_dv_timings timings;
 	struct stdi_readback stdi;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
@@ -2289,7 +2289,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 				stdi.lcf, stdi.bl, stdi.lcvs,
 				stdi.interlaced ? "interlaced" : "progressive",
 				stdi.hs_pol, stdi.vs_pol);
-	if (adv7604_query_dv_timings(sd, &timings))
+	if (adv76xx_query_dv_timings(sd, &timings))
 		v4l2_info(sd, "No video detected\n");
 	else
 		v4l2_print_dv_timings(sd->name, "Detected format: ",
@@ -2355,47 +2355,47 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_ctrl_ops adv7604_ctrl_ops = {
-	.s_ctrl = adv7604_s_ctrl,
+static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
+	.s_ctrl = adv76xx_s_ctrl,
 };
 
-static const struct v4l2_subdev_core_ops adv7604_core_ops = {
-	.log_status = adv7604_log_status,
-	.interrupt_service_routine = adv7604_isr,
+static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
+	.log_status = adv76xx_log_status,
+	.interrupt_service_routine = adv76xx_isr,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.g_register = adv7604_g_register,
-	.s_register = adv7604_s_register,
+	.g_register = adv76xx_g_register,
+	.s_register = adv76xx_s_register,
 #endif
 };
 
-static const struct v4l2_subdev_video_ops adv7604_video_ops = {
-	.s_routing = adv7604_s_routing,
-	.g_input_status = adv7604_g_input_status,
-	.s_dv_timings = adv7604_s_dv_timings,
-	.g_dv_timings = adv7604_g_dv_timings,
-	.query_dv_timings = adv7604_query_dv_timings,
+static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
+	.s_routing = adv76xx_s_routing,
+	.g_input_status = adv76xx_g_input_status,
+	.s_dv_timings = adv76xx_s_dv_timings,
+	.g_dv_timings = adv76xx_g_dv_timings,
+	.query_dv_timings = adv76xx_query_dv_timings,
 };
 
-static const struct v4l2_subdev_pad_ops adv7604_pad_ops = {
-	.enum_mbus_code = adv7604_enum_mbus_code,
-	.get_fmt = adv7604_get_format,
-	.set_fmt = adv7604_set_format,
-	.get_edid = adv7604_get_edid,
-	.set_edid = adv7604_set_edid,
-	.dv_timings_cap = adv7604_dv_timings_cap,
-	.enum_dv_timings = adv7604_enum_dv_timings,
+static const struct v4l2_subdev_pad_ops adv76xx_pad_ops = {
+	.enum_mbus_code = adv76xx_enum_mbus_code,
+	.get_fmt = adv76xx_get_format,
+	.set_fmt = adv76xx_set_format,
+	.get_edid = adv76xx_get_edid,
+	.set_edid = adv76xx_set_edid,
+	.dv_timings_cap = adv76xx_dv_timings_cap,
+	.enum_dv_timings = adv76xx_enum_dv_timings,
 };
 
-static const struct v4l2_subdev_ops adv7604_ops = {
-	.core = &adv7604_core_ops,
-	.video = &adv7604_video_ops,
-	.pad = &adv7604_pad_ops,
+static const struct v4l2_subdev_ops adv76xx_ops = {
+	.core = &adv76xx_core_ops,
+	.video = &adv76xx_video_ops,
+	.pad = &adv76xx_pad_ops,
 };
 
 /* -------------------------- custom ctrls ---------------------------------- */
 
 static const struct v4l2_ctrl_config adv7604_ctrl_analog_sampling_phase = {
-	.ops = &adv7604_ctrl_ops,
+	.ops = &adv76xx_ctrl_ops,
 	.id = V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE,
 	.name = "Analog Sampling Phase",
 	.type = V4L2_CTRL_TYPE_INTEGER,
@@ -2405,8 +2405,8 @@ static const struct v4l2_ctrl_config adv7604_ctrl_analog_sampling_phase = {
 	.def = 0,
 };
 
-static const struct v4l2_ctrl_config adv7604_ctrl_free_run_color_manual = {
-	.ops = &adv7604_ctrl_ops,
+static const struct v4l2_ctrl_config adv76xx_ctrl_free_run_color_manual = {
+	.ops = &adv76xx_ctrl_ops,
 	.id = V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL,
 	.name = "Free Running Color, Manual",
 	.type = V4L2_CTRL_TYPE_BOOLEAN,
@@ -2416,8 +2416,8 @@ static const struct v4l2_ctrl_config adv7604_ctrl_free_run_color_manual = {
 	.def = false,
 };
 
-static const struct v4l2_ctrl_config adv7604_ctrl_free_run_color = {
-	.ops = &adv7604_ctrl_ops,
+static const struct v4l2_ctrl_config adv76xx_ctrl_free_run_color = {
+	.ops = &adv76xx_ctrl_ops,
 	.id = V4L2_CID_ADV_RX_FREE_RUN_COLOR,
 	.name = "Free Running Color",
 	.type = V4L2_CTRL_TYPE_INTEGER,
@@ -2429,11 +2429,11 @@ static const struct v4l2_ctrl_config adv7604_ctrl_free_run_color = {
 
 /* ----------------------------------------------------------------------- */
 
-static int adv7604_core_init(struct v4l2_subdev *sd)
+static int adv76xx_core_init(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
-	const struct adv7604_chip_info *info = state->info;
-	struct adv7604_platform_data *pdata = &state->pdata;
+	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
+	struct adv76xx_platform_data *pdata = &state->pdata;
 
 	hdmi_write(sd, 0x48,
 		(pdata->disable_pwrdnb ? 0x80 : 0) |
@@ -2461,7 +2461,7 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	io_write_clr_set(sd, 0x05, 0x0e, pdata->blank_data << 3 |
 			pdata->insert_av_codes << 2 |
 			pdata->replicate_av_codes << 1);
-	adv7604_setup_format(state);
+	adv76xx_setup_format(state);
 
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 
@@ -2491,7 +2491,7 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
 
-	if (adv7604_has_afe(state)) {
+	if (adv76xx_has_afe(state)) {
 		afe_write(sd, 0x02, pdata->ain_sel); /* Select analog input muxing mode */
 		io_write_clr_set(sd, 0x30, 1 << 4, pdata->output_bus_lsb_to_msb << 4);
 	}
@@ -2516,7 +2516,7 @@ static void adv7611_setup_irqs(struct v4l2_subdev *sd)
 	io_write(sd, 0x41, 0xd0); /* STDI irq for any change, disable INT2 */
 }
 
-static void adv7604_unregister_clients(struct adv7604_state *state)
+static void adv76xx_unregister_clients(struct adv76xx_state *state)
 {
 	unsigned int i;
 
@@ -2526,7 +2526,7 @@ static void adv7604_unregister_clients(struct adv7604_state *state)
 	}
 }
 
-static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
+static struct i2c_client *adv76xx_dummy_client(struct v4l2_subdev *sd,
 							u8 addr, u8 io_reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -2536,74 +2536,74 @@ static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
 	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
 }
 
-static const struct adv7604_reg_seq adv7604_recommended_settings_afe[] = {
+static const struct adv76xx_reg_seq adv7604_recommended_settings_afe[] = {
 	/* reset ADI recommended settings for HDMI: */
 	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3d), 0x00 }, /* DDC bus active pull-up control */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3e), 0x74 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0x74 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x63 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x93), 0x88 }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x94), 0x2e }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x96), 0x00 }, /* enable automatic EQ changing */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x3d), 0x00 }, /* DDC bus active pull-up control */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x3e), 0x74 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x57), 0x74 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x58), 0x63 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x93), 0x88 }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x94), 0x2e }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x96), 0x00 }, /* enable automatic EQ changing */
 
 	/* set ADI recommended settings for digitizer */
 	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
-	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x12), 0x7b }, /* ADC noise shaping filter controls */
-	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x0c), 0x1f }, /* CP core gain controls */
-	{ ADV7604_REG(ADV7604_PAGE_CP, 0x3e), 0x04 }, /* CP core pre-gain control */
-	{ ADV7604_REG(ADV7604_PAGE_CP, 0xc3), 0x39 }, /* CP coast control. Graphics mode */
-	{ ADV7604_REG(ADV7604_PAGE_CP, 0x40), 0x5c }, /* CP core pre-gain control. Graphics mode */
+	{ ADV76XX_REG(ADV76XX_PAGE_AFE, 0x12), 0x7b }, /* ADC noise shaping filter controls */
+	{ ADV76XX_REG(ADV76XX_PAGE_AFE, 0x0c), 0x1f }, /* CP core gain controls */
+	{ ADV76XX_REG(ADV76XX_PAGE_CP, 0x3e), 0x04 }, /* CP core pre-gain control */
+	{ ADV76XX_REG(ADV76XX_PAGE_CP, 0xc3), 0x39 }, /* CP coast control. Graphics mode */
+	{ ADV76XX_REG(ADV76XX_PAGE_CP, 0x40), 0x5c }, /* CP core pre-gain control. Graphics mode */
 
-	{ ADV7604_REG_SEQ_TERM, 0 },
+	{ ADV76XX_REG_SEQ_TERM, 0 },
 };
 
-static const struct adv7604_reg_seq adv7604_recommended_settings_hdmi[] = {
+static const struct adv76xx_reg_seq adv7604_recommended_settings_hdmi[] = {
 	/* set ADI recommended settings for HDMI: */
 	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x84 }, /* HDMI filter optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3d), 0x10 }, /* DDC bus active pull-up control */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3e), 0x39 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xb6 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x03 }, /* TMDS PLL optimization */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x93), 0x8b }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x94), 0x2d }, /* equaliser */
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x96), 0x01 }, /* enable automatic EQ changing */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x0d), 0x84 }, /* HDMI filter optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x3d), 0x10 }, /* DDC bus active pull-up control */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x3e), 0x39 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x57), 0xb6 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x58), 0x03 }, /* TMDS PLL optimization */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x93), 0x8b }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x94), 0x2d }, /* equaliser */
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x96), 0x01 }, /* enable automatic EQ changing */
 
 	/* reset ADI recommended settings for digitizer */
 	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
-	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x12), 0xfb }, /* ADC noise shaping filter controls */
-	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x0c), 0x0d }, /* CP core gain controls */
+	{ ADV76XX_REG(ADV76XX_PAGE_AFE, 0x12), 0xfb }, /* ADC noise shaping filter controls */
+	{ ADV76XX_REG(ADV76XX_PAGE_AFE, 0x0c), 0x0d }, /* CP core gain controls */
 
-	{ ADV7604_REG_SEQ_TERM, 0 },
+	{ ADV76XX_REG_SEQ_TERM, 0 },
 };
 
-static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
+static const struct adv76xx_reg_seq adv7611_recommended_settings_hdmi[] = {
 	/* ADV7611 Register Settings Recommendations Rev 1.5, May 2014 */
-	{ ADV7604_REG(ADV7604_PAGE_CP, 0x6c), 0x00 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x9b), 0x03 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x08 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x85), 0x1f },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x87), 0x70 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xda },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x01 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x03), 0x98 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4c), 0x44 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x04 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x1e },
-
-	{ ADV7604_REG_SEQ_TERM, 0 },
+	{ ADV76XX_REG(ADV76XX_PAGE_CP, 0x6c), 0x00 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x9b), 0x03 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x6f), 0x08 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x85), 0x1f },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x87), 0x70 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x57), 0xda },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x58), 0x01 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x03), 0x98 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x4c), 0x44 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8d), 0x04 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x8e), 0x1e },
+
+	{ ADV76XX_REG_SEQ_TERM, 0 },
 };
 
-static const struct adv7604_chip_info adv7604_chip_info[] = {
+static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 	[ADV7604] = {
 		.type = ADV7604,
 		.has_afe = true,
@@ -2629,18 +2629,18 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		    [0] = ARRAY_SIZE(adv7604_recommended_settings_afe),
 		    [1] = ARRAY_SIZE(adv7604_recommended_settings_hdmi),
 		},
-		.page_mask = BIT(ADV7604_PAGE_IO) | BIT(ADV7604_PAGE_AVLINK) |
-			BIT(ADV7604_PAGE_CEC) | BIT(ADV7604_PAGE_INFOFRAME) |
+		.page_mask = BIT(ADV76XX_PAGE_IO) | BIT(ADV7604_PAGE_AVLINK) |
+			BIT(ADV76XX_PAGE_CEC) | BIT(ADV76XX_PAGE_INFOFRAME) |
 			BIT(ADV7604_PAGE_ESDP) | BIT(ADV7604_PAGE_DPP) |
-			BIT(ADV7604_PAGE_AFE) | BIT(ADV7604_PAGE_REP) |
-			BIT(ADV7604_PAGE_EDID) | BIT(ADV7604_PAGE_HDMI) |
-			BIT(ADV7604_PAGE_TEST) | BIT(ADV7604_PAGE_CP) |
+			BIT(ADV76XX_PAGE_AFE) | BIT(ADV76XX_PAGE_REP) |
+			BIT(ADV76XX_PAGE_EDID) | BIT(ADV76XX_PAGE_HDMI) |
+			BIT(ADV76XX_PAGE_TEST) | BIT(ADV76XX_PAGE_CP) |
 			BIT(ADV7604_PAGE_VDP),
 	},
 	[ADV7611] = {
 		.type = ADV7611,
 		.has_afe = false,
-		.max_port = ADV7604_PAD_HDMI_PORT_A,
+		.max_port = ADV76XX_PAD_HDMI_PORT_A,
 		.num_dv_ports = 1,
 		.edid_enable_reg = 0x74,
 		.edid_status_reg = 0x76,
@@ -2660,34 +2660,34 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		.num_recommended_settings = {
 		    [1] = ARRAY_SIZE(adv7611_recommended_settings_hdmi),
 		},
-		.page_mask = BIT(ADV7604_PAGE_IO) | BIT(ADV7604_PAGE_CEC) |
-			BIT(ADV7604_PAGE_INFOFRAME) | BIT(ADV7604_PAGE_AFE) |
-			BIT(ADV7604_PAGE_REP) |  BIT(ADV7604_PAGE_EDID) |
-			BIT(ADV7604_PAGE_HDMI) | BIT(ADV7604_PAGE_CP),
+		.page_mask = BIT(ADV76XX_PAGE_IO) | BIT(ADV76XX_PAGE_CEC) |
+			BIT(ADV76XX_PAGE_INFOFRAME) | BIT(ADV76XX_PAGE_AFE) |
+			BIT(ADV76XX_PAGE_REP) |  BIT(ADV76XX_PAGE_EDID) |
+			BIT(ADV76XX_PAGE_HDMI) | BIT(ADV76XX_PAGE_CP),
 	},
 };
 
-static struct i2c_device_id adv7604_i2c_id[] = {
-	{ "adv7604", (kernel_ulong_t)&adv7604_chip_info[ADV7604] },
-	{ "adv7611", (kernel_ulong_t)&adv7604_chip_info[ADV7611] },
+static struct i2c_device_id adv76xx_i2c_id[] = {
+	{ "adv7604", (kernel_ulong_t)&adv76xx_chip_info[ADV7604] },
+	{ "adv7611", (kernel_ulong_t)&adv76xx_chip_info[ADV7611] },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
+MODULE_DEVICE_TABLE(i2c, adv76xx_i2c_id);
 
-static struct of_device_id adv7604_of_id[] __maybe_unused = {
-	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
+static struct of_device_id adv76xx_of_id[] __maybe_unused = {
+	{ .compatible = "adi,adv7611", .data = &adv76xx_chip_info[ADV7611] },
 	{ }
 };
-MODULE_DEVICE_TABLE(of, adv7604_of_id);
+MODULE_DEVICE_TABLE(of, adv76xx_of_id);
 
-static int adv7604_parse_dt(struct adv7604_state *state)
+static int adv76xx_parse_dt(struct adv76xx_state *state)
 {
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
 
-	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
+	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
 
 	/* Parse the endpoint. */
 	endpoint = of_graph_get_next_endpoint(np, NULL);
@@ -2714,20 +2714,20 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	}
 
 	/* Disable the interrupt for now as no DT-based board uses it. */
-	state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
+	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
 
 	/* Use the default I2C addresses. */
 	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
-	state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
-	state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_CEC] = 0x40;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_INFOFRAME] = 0x3e;
 	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
 	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
-	state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
-	state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
-	state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
-	state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
-	state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
-	state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_AFE] = 0x26;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_REP] = 0x32;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_EDID] = 0x36;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_HDMI] = 0x34;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_TEST] = 0x30;
+	state->pdata.i2c_addresses[ADV76XX_PAGE_CP] = 0x22;
 	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
 
 	/* Hardcode the remaining platform data fields. */
@@ -2742,12 +2742,12 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	return 0;
 }
 
-static int adv7604_probe(struct i2c_client *client,
+static int adv76xx_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	static const struct v4l2_dv_timings cea640x480 =
 		V4L2_DV_BT_CEA_640X480P59_94;
-	struct adv7604_state *state;
+	struct adv76xx_state *state;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
 	unsigned int i;
@@ -2757,16 +2757,16 @@ static int adv7604_probe(struct i2c_client *client,
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
-	v4l_dbg(1, debug, client, "detecting adv7604 client on address 0x%x\n",
+	v4l_dbg(1, debug, client, "detecting adv76xx client on address 0x%x\n",
 			client->addr << 1);
 
 	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state) {
-		v4l_err(client, "Could not allocate adv7604_state memory!\n");
+		v4l_err(client, "Could not allocate adv76xx_state memory!\n");
 		return -ENOMEM;
 	}
 
-	state->i2c_clients[ADV7604_PAGE_IO] = client;
+	state->i2c_clients[ADV76XX_PAGE_IO] = client;
 
 	/* initialize variables */
 	state->restart_stdi_once = true;
@@ -2775,18 +2775,18 @@ static int adv7604_probe(struct i2c_client *client,
 	if (IS_ENABLED(CONFIG_OF) && client->dev.of_node) {
 		const struct of_device_id *oid;
 
-		oid = of_match_node(adv7604_of_id, client->dev.of_node);
+		oid = of_match_node(adv76xx_of_id, client->dev.of_node);
 		state->info = oid->data;
 
-		err = adv7604_parse_dt(state);
+		err = adv76xx_parse_dt(state);
 		if (err < 0) {
 			v4l_err(client, "DT parsing error\n");
 			return err;
 		}
 	} else if (client->dev.platform_data) {
-		struct adv7604_platform_data *pdata = client->dev.platform_data;
+		struct adv76xx_platform_data *pdata = client->dev.platform_data;
 
-		state->info = (const struct adv7604_chip_info *)id->driver_data;
+		state->info = (const struct adv76xx_chip_info *)id->driver_data;
 		state->pdata = *pdata;
 	} else {
 		v4l_err(client, "No platform data!\n");
@@ -2806,10 +2806,10 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 
 	state->timings = cea640x480;
-	state->format = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
+	state->format = adv76xx_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
 	sd = &state->sd;
-	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
+	v4l2_i2c_subdev_init(sd, client, &adv76xx_ops);
 	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
 		id->name, i2c_adapter_id(client->adapter),
 		client->addr);
@@ -2839,15 +2839,15 @@ static int adv7604_probe(struct i2c_client *client,
 
 	/* control handlers */
 	hdl = &state->hdl;
-	v4l2_ctrl_handler_init(hdl, adv7604_has_afe(state) ? 9 : 8);
+	v4l2_ctrl_handler_init(hdl, adv76xx_has_afe(state) ? 9 : 8);
 
-	v4l2_ctrl_new_std(hdl, &adv7604_ctrl_ops,
+	v4l2_ctrl_new_std(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
-	v4l2_ctrl_new_std(hdl, &adv7604_ctrl_ops,
+	v4l2_ctrl_new_std(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_CONTRAST, 0, 255, 1, 128);
-	v4l2_ctrl_new_std(hdl, &adv7604_ctrl_ops,
+	v4l2_ctrl_new_std(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_SATURATION, 0, 255, 1, 128);
-	v4l2_ctrl_new_std(hdl, &adv7604_ctrl_ops,
+	v4l2_ctrl_new_std(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_HUE, 0, 128, 1, 0);
 
 	/* private controls */
@@ -2855,18 +2855,18 @@ static int adv7604_probe(struct i2c_client *client,
 			V4L2_CID_DV_RX_POWER_PRESENT, 0,
 			(1 << state->info->num_dv_ports) - 1, 0, 0);
 	state->rgb_quantization_range_ctrl =
-		v4l2_ctrl_new_std_menu(hdl, &adv7604_ctrl_ops,
+		v4l2_ctrl_new_std_menu(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
 			0, V4L2_DV_RGB_RANGE_AUTO);
 
 	/* custom controls */
-	if (adv7604_has_afe(state))
+	if (adv76xx_has_afe(state))
 		state->analog_sampling_phase_ctrl =
 			v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_analog_sampling_phase, NULL);
 	state->free_run_color_manual_ctrl =
-		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_free_run_color_manual, NULL);
+		v4l2_ctrl_new_custom(hdl, &adv76xx_ctrl_free_run_color_manual, NULL);
 	state->free_run_color_ctrl =
-		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_free_run_color, NULL);
+		v4l2_ctrl_new_custom(hdl, &adv76xx_ctrl_free_run_color, NULL);
 
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
@@ -2875,22 +2875,22 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 	state->detect_tx_5v_ctrl->is_private = true;
 	state->rgb_quantization_range_ctrl->is_private = true;
-	if (adv7604_has_afe(state))
+	if (adv76xx_has_afe(state))
 		state->analog_sampling_phase_ctrl->is_private = true;
 	state->free_run_color_manual_ctrl->is_private = true;
 	state->free_run_color_ctrl->is_private = true;
 
-	if (adv7604_s_detect_tx_5v_ctrl(sd)) {
+	if (adv76xx_s_detect_tx_5v_ctrl(sd)) {
 		err = -ENODEV;
 		goto err_hdl;
 	}
 
-	for (i = 1; i < ADV7604_PAGE_MAX; ++i) {
+	for (i = 1; i < ADV76XX_PAGE_MAX; ++i) {
 		if (!(BIT(i) & state->info->page_mask))
 			continue;
 
 		state->i2c_clients[i] =
-			adv7604_dummy_client(sd, state->pdata.i2c_addresses[i],
+			adv76xx_dummy_client(sd, state->pdata.i2c_addresses[i],
 					     0xf2 + i);
 		if (state->i2c_clients[i] == NULL) {
 			err = -ENOMEM;
@@ -2908,7 +2908,7 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
-			adv7604_delayed_work_enable_hotplug);
+			adv76xx_delayed_work_enable_hotplug);
 
 	state->source_pad = state->info->num_dv_ports
 			  + (state->info->has_afe ? 2 : 0);
@@ -2921,7 +2921,7 @@ static int adv7604_probe(struct i2c_client *client,
 	if (err)
 		goto err_work_queues;
 
-	err = adv7604_core_init(sd);
+	err = adv76xx_core_init(sd);
 	if (err)
 		goto err_entity;
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
@@ -2939,7 +2939,7 @@ err_work_queues:
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 err_i2c:
-	adv7604_unregister_clients(state);
+	adv76xx_unregister_clients(state);
 err_hdl:
 	v4l2_ctrl_handler_free(hdl);
 	return err;
@@ -2947,32 +2947,32 @@ err_hdl:
 
 /* ----------------------------------------------------------------------- */
 
-static int adv7604_remove(struct i2c_client *client)
+static int adv76xx_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct adv7604_state *state = to_state(sd);
+	struct adv76xx_state *state = to_state(sd);
 
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
-	adv7604_unregister_clients(to_state(sd));
+	adv76xx_unregister_clients(to_state(sd));
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
 
-static struct i2c_driver adv7604_driver = {
+static struct i2c_driver adv76xx_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
-		.name = "adv7604",
-		.of_match_table = of_match_ptr(adv7604_of_id),
+		.name = "adv76xx",
+		.of_match_table = of_match_ptr(adv76xx_of_id),
 	},
-	.probe = adv7604_probe,
-	.remove = adv7604_remove,
-	.id_table = adv7604_i2c_id,
+	.probe = adv76xx_probe,
+	.remove = adv76xx_remove,
+	.id_table = adv76xx_i2c_id,
 };
 
-module_i2c_driver(adv7604_driver);
+module_i2c_driver(adv76xx_driver);
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index aa1c447..9ecf353 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -47,16 +47,16 @@ enum adv7604_bus_order {
 };
 
 /* Input Color Space (IO register 0x02, [7:4]) */
-enum adv7604_inp_color_space {
-	ADV7604_INP_COLOR_SPACE_LIM_RGB = 0,
-	ADV7604_INP_COLOR_SPACE_FULL_RGB = 1,
-	ADV7604_INP_COLOR_SPACE_LIM_YCbCr_601 = 2,
-	ADV7604_INP_COLOR_SPACE_LIM_YCbCr_709 = 3,
-	ADV7604_INP_COLOR_SPACE_XVYCC_601 = 4,
-	ADV7604_INP_COLOR_SPACE_XVYCC_709 = 5,
-	ADV7604_INP_COLOR_SPACE_FULL_YCbCr_601 = 6,
-	ADV7604_INP_COLOR_SPACE_FULL_YCbCr_709 = 7,
-	ADV7604_INP_COLOR_SPACE_AUTO = 0xf,
+enum adv76xx_inp_color_space {
+	ADV76XX_INP_COLOR_SPACE_LIM_RGB = 0,
+	ADV76XX_INP_COLOR_SPACE_FULL_RGB = 1,
+	ADV76XX_INP_COLOR_SPACE_LIM_YCbCr_601 = 2,
+	ADV76XX_INP_COLOR_SPACE_LIM_YCbCr_709 = 3,
+	ADV76XX_INP_COLOR_SPACE_XVYCC_601 = 4,
+	ADV76XX_INP_COLOR_SPACE_XVYCC_709 = 5,
+	ADV76XX_INP_COLOR_SPACE_FULL_YCbCr_601 = 6,
+	ADV76XX_INP_COLOR_SPACE_FULL_YCbCr_709 = 7,
+	ADV76XX_INP_COLOR_SPACE_AUTO = 0xf,
 };
 
 /* Select output format (IO register 0x03, [4:2]) */
@@ -66,38 +66,39 @@ enum adv7604_op_format_mode_sel {
 	ADV7604_OP_FORMAT_MODE2 = 0x08,
 };
 
-enum adv7604_drive_strength {
-	ADV7604_DR_STR_MEDIUM_LOW = 1,
-	ADV7604_DR_STR_MEDIUM_HIGH = 2,
-	ADV7604_DR_STR_HIGH = 3,
+enum adv76xx_drive_strength {
+	ADV76XX_DR_STR_MEDIUM_LOW = 1,
+	ADV76XX_DR_STR_MEDIUM_HIGH = 2,
+	ADV76XX_DR_STR_HIGH = 3,
 };
 
-enum adv7604_int1_config {
-	ADV7604_INT1_CONFIG_OPEN_DRAIN,
-	ADV7604_INT1_CONFIG_ACTIVE_LOW,
-	ADV7604_INT1_CONFIG_ACTIVE_HIGH,
-	ADV7604_INT1_CONFIG_DISABLED,
+/* INT1 Configuration (IO register 0x40, [1:0]) */
+enum adv76xx_int1_config {
+	ADV76XX_INT1_CONFIG_OPEN_DRAIN,
+	ADV76XX_INT1_CONFIG_ACTIVE_LOW,
+	ADV76XX_INT1_CONFIG_ACTIVE_HIGH,
+	ADV76XX_INT1_CONFIG_DISABLED,
 };
 
-enum adv7604_page {
-	ADV7604_PAGE_IO,
+enum adv76xx_page {
+	ADV76XX_PAGE_IO,
 	ADV7604_PAGE_AVLINK,
-	ADV7604_PAGE_CEC,
-	ADV7604_PAGE_INFOFRAME,
+	ADV76XX_PAGE_CEC,
+	ADV76XX_PAGE_INFOFRAME,
 	ADV7604_PAGE_ESDP,
 	ADV7604_PAGE_DPP,
-	ADV7604_PAGE_AFE,
-	ADV7604_PAGE_REP,
-	ADV7604_PAGE_EDID,
-	ADV7604_PAGE_HDMI,
-	ADV7604_PAGE_TEST,
-	ADV7604_PAGE_CP,
+	ADV76XX_PAGE_AFE,
+	ADV76XX_PAGE_REP,
+	ADV76XX_PAGE_EDID,
+	ADV76XX_PAGE_HDMI,
+	ADV76XX_PAGE_TEST,
+	ADV76XX_PAGE_CP,
 	ADV7604_PAGE_VDP,
-	ADV7604_PAGE_MAX,
+	ADV76XX_PAGE_MAX,
 };
 
 /* Platform dependent definition */
-struct adv7604_platform_data {
+struct adv76xx_platform_data {
 	/* DIS_PWRDNB: 1 if the PWRDNB pin is unused and unconnected */
 	unsigned disable_pwrdnb:1;
 
@@ -116,7 +117,7 @@ struct adv7604_platform_data {
 	enum adv7604_op_format_mode_sel op_format_mode_sel;
 
 	/* Configuration of the INT1 pin */
-	enum adv7604_int1_config int1_config;
+	enum adv76xx_int1_config int1_config;
 
 	/* IO register 0x02 */
 	unsigned alt_gamma:1;
@@ -134,9 +135,9 @@ struct adv7604_platform_data {
 	unsigned inv_llc_pol:1;
 
 	/* IO register 0x14 */
-	enum adv7604_drive_strength dr_str_data;
-	enum adv7604_drive_strength dr_str_clk;
-	enum adv7604_drive_strength dr_str_sync;
+	enum adv76xx_drive_strength dr_str_data;
+	enum adv76xx_drive_strength dr_str_clk;
+	enum adv76xx_drive_strength dr_str_sync;
 
 	/* IO register 0x30 */
 	unsigned output_bus_lsb_to_msb:1;
@@ -145,11 +146,11 @@ struct adv7604_platform_data {
 	unsigned hdmi_free_run_mode;
 
 	/* i2c addresses: 0 == use default */
-	u8 i2c_addresses[ADV7604_PAGE_MAX];
+	u8 i2c_addresses[ADV76XX_PAGE_MAX];
 };
 
-enum adv7604_pad {
-	ADV7604_PAD_HDMI_PORT_A = 0,
+enum adv76xx_pad {
+	ADV76XX_PAD_HDMI_PORT_A = 0,
 	ADV7604_PAD_HDMI_PORT_B = 1,
 	ADV7604_PAD_HDMI_PORT_C = 2,
 	ADV7604_PAD_HDMI_PORT_D = 3,
@@ -158,7 +159,7 @@ enum adv7604_pad {
 	/* The source pad is either 1 (ADV7611) or 6 (ADV7604) */
 	ADV7604_PAD_SOURCE = 6,
 	ADV7611_PAD_SOURCE = 1,
-	ADV7604_PAD_MAX = 7,
+	ADV76XX_PAD_MAX = 7,
 };
 
 #define V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE	(V4L2_CID_DV_CLASS_BASE + 0x1000)
@@ -166,7 +167,7 @@ enum adv7604_pad {
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 0x1002)
 
 /* notify events */
-#define ADV7604_HOTPLUG		1
-#define ADV7604_FMT_CHANGE	2
+#define ADV76XX_HOTPLUG		1
+#define ADV76XX_FMT_CHANGE	2
 
 #endif
-- 
2.1.2

