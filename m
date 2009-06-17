Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZFQUye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:54:34 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-omap@vger.kernel.org,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH - V3] TVP514x: Migration to sub-device framework
Date: Wed, 17 Jun 2009 16:54:27 -0400
Message-Id: <1245272067-8788-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch converts TVP514x driver to sub-device framework
from V4L2-int framework. 

NOTE: Please note that this patch was tested on DM355 and DM6446
and not tested on OMAP platform

Changes from v2 based on review comments (Taken over this work from
Vaibhav)

	- removed __exit for tvp514x_remove
	- removed v4l2_i2c_driver_data and use new model similar to ths7303
	- changed state to streaming

TODO:
	- Add support for some basic video/core functionality like,
	  .g_chip_ident
	  .reset
	  .g_input_status
	- Migration of OMAP master driver to validate this driver
	- validate on OMAP boards

Reviewed by :Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository
 
 drivers/media/video/tvp514x.c      |  875 ++++++++++++++----------------------
 drivers/media/video/tvp514x_regs.h |   10 -
 include/media/tvp514x.h            |    4 -
 3 files changed, 349 insertions(+), 540 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 3750f7f..6063b57 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -31,7 +31,10 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-int-device.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
 #include <media/tvp514x.h>
 
 #include "tvp514x_regs.h"
@@ -49,13 +52,11 @@ static int debug;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
-#define dump_reg(client, reg, val)				\
-	do {							\
-		val = tvp514x_read_reg(client, reg);		\
-		v4l_info(client, "Reg(0x%.2X): 0x%.2X\n", reg, val); \
-	} while (0)
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("TVP514X linux decoder driver");
+MODULE_LICENSE("GPL");
 
-/**
+/*
  * enum tvp514x_std - enum for supported standards
  */
 enum tvp514x_std {
@@ -64,15 +65,7 @@ enum tvp514x_std {
 	STD_INVALID
 };
 
-/**
- * enum tvp514x_state - enum for different decoder states
- */
-enum tvp514x_state {
-	STATE_NOT_DETECTED,
-	STATE_DETECTED
-};
-
-/**
+/*
  * struct tvp514x_std_info - Structure to store standard informations
  * @width: Line width in pixels
  * @height:Number of active lines
@@ -87,35 +80,29 @@ struct tvp514x_std_info {
 };
 
 static struct tvp514x_reg tvp514x_reg_list_default[0x40];
-/**
+/*
  * struct tvp514x_decoder - TVP5146/47 decoder object
- * @v4l2_int_device: Slave handle
- * @tvp514x_slave: Slave pointer which is used by @v4l2_int_device
+ * @sd: Subdevice Slave handle
  * @tvp514x_regs: copy of hw's regs with preset values.
  * @pdata: Board specific
- * @client: I2C client data
- * @id: Entry from I2C table
  * @ver: Chip version
- * @state: TVP5146/47 decoder state - detected or not-detected
+ * @streaming: TVP5146/47 decoder streaming - enabled or disabled.
  * @pix: Current pixel format
  * @num_fmts: Number of formats
  * @fmt_list: Format list
  * @current_std: Current standard
  * @num_stds: Number of standards
  * @std_list: Standards list
- * @route: input and output routing at chip level
+ * @input: Input routing at chip level
+ * @output: Output routing at chip level
  */
 struct tvp514x_decoder {
-	struct v4l2_int_device v4l2_int_device;
-	struct v4l2_int_slave tvp514x_slave;
+	struct v4l2_subdev sd;
 	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
 	const struct tvp514x_platform_data *pdata;
-	struct i2c_client *client;
-
-	struct i2c_device_id *id;
 
 	int ver;
-	enum tvp514x_state state;
+	int streaming;
 
 	struct v4l2_pix_format pix;
 	int num_fmts;
@@ -124,8 +111,11 @@ struct tvp514x_decoder {
 	enum tvp514x_std current_std;
 	int num_stds;
 	struct tvp514x_std_info *std_list;
-
-	struct v4l2_routing route;
+	/*
+	 * Input and Output Routing parameters
+	 */
+	u32 input;
+	u32 output;
 };
 
 /* TVP514x default register values */
@@ -191,7 +181,8 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
 	{TOK_TERM, 0, 0},
 };
 
-/* List of image formats supported by TVP5146/47 decoder
+/*
+ * List of image formats supported by TVP5146/47 decoder
  * Currently we are using 8 bit mode only, but can be
  * extended to 10/20 bit mode.
  */
@@ -240,35 +231,29 @@ static struct tvp514x_std_info tvp514x_std_list[] = {
 	},
 	/* Standard: need to add for additional standard */
 };
-/*
- * Control structure for Auto Gain
- *     This is temporary data, will get replaced once
- *     v4l2_ctrl_query_fill supports it.
- */
-static const struct v4l2_queryctrl tvp514x_autogain_ctrl = {
-	.id = V4L2_CID_AUTOGAIN,
-	.name = "Gain, Automatic",
-	.type = V4L2_CTRL_TYPE_BOOLEAN,
-	.minimum = 0,
-	.maximum = 1,
-	.step = 1,
-	.default_value = 1,
-};
+
+
+static inline struct tvp514x_decoder *to_decoder(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tvp514x_decoder, sd);
+}
+
 
 /*
  * Read a value from a register in an TVP5146/47 decoder device.
  * Returns value read if successful, or non-zero (-1) otherwise.
  */
-static int tvp514x_read_reg(struct i2c_client *client, u8 reg)
+static int tvp514x_read_reg(struct v4l2_subdev *sd, u8 reg)
 {
-	int err;
-	int retry = 0;
+	int err, retry = 0;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
 read_again:
 
 	err = i2c_smbus_read_byte_data(client, reg);
 	if (err == -1) {
 		if (retry <= I2C_RETRY_COUNT) {
-			v4l_warn(client, "Read: retry ... %d\n", retry);
+			v4l2_warn(sd, "Read: retry ... %d\n", retry);
 			retry++;
 			msleep_interruptible(10);
 			goto read_again;
@@ -278,20 +263,29 @@ read_again:
 	return err;
 }
 
+static inline void dump_reg(struct v4l2_subdev *sd, u8 reg)
+{
+	u32 val;
+
+	val = tvp514x_read_reg(sd, reg);
+	v4l2_info(sd, "Reg(0x%.2X): 0x%.2X\n", reg, val);
+}
+
 /*
  * Write a value to a register in an TVP5146/47 decoder device.
  * Returns zero if successful, or non-zero otherwise.
  */
-static int tvp514x_write_reg(struct i2c_client *client, u8 reg, u8 val)
+static int tvp514x_write_reg(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
-	int err;
-	int retry = 0;
+	int err, retry = 0;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
 write_again:
 
 	err = i2c_smbus_write_byte_data(client, reg, val);
 	if (err) {
 		if (retry <= I2C_RETRY_COUNT) {
-			v4l_warn(client, "Write: retry ... %d\n", retry);
+			v4l2_warn(sd, "Write: retry ... %d\n", retry);
 			retry++;
 			msleep_interruptible(10);
 			goto write_again;
@@ -311,7 +305,7 @@ write_again:
  * reglist - list of registers to be written
  * Returns zero if successful, or non-zero otherwise.
  */
-static int tvp514x_write_regs(struct i2c_client *client,
+static int tvp514x_write_regs(struct v4l2_subdev *sd,
 			      const struct tvp514x_reg reglist[])
 {
 	int err;
@@ -326,9 +320,9 @@ static int tvp514x_write_regs(struct i2c_client *client,
 		if (next->token == TOK_SKIP)
 			continue;
 
-		err = tvp514x_write_reg(client, next->reg, (u8) next->val);
+		err = tvp514x_write_reg(sd, next->reg, (u8) next->val);
 		if (err) {
-			v4l_err(client, "Write failed. Err[%d]\n", err);
+			v4l2_err(sd, "Write failed. Err[%d]\n", err);
 			return err;
 		}
 	}
@@ -339,17 +333,15 @@ static int tvp514x_write_regs(struct i2c_client *client,
  * tvp514x_get_current_std:
  * Returns the current standard detected by TVP5146/47
  */
-static enum tvp514x_std tvp514x_get_current_std(struct tvp514x_decoder
-						*decoder)
+static enum tvp514x_std tvp514x_get_current_std(struct v4l2_subdev *sd)
 {
 	u8 std, std_status;
 
-	std = tvp514x_read_reg(decoder->client, REG_VIDEO_STD);
-	if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT) {
+	std = tvp514x_read_reg(sd, REG_VIDEO_STD);
+	if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT)
 		/* use the standard status register */
-		std_status = tvp514x_read_reg(decoder->client,
-				REG_VIDEO_STD_STATUS);
-	} else
+		std_status = tvp514x_read_reg(sd, REG_VIDEO_STD_STATUS);
+	else
 		std_status = std;	/* use the standard register itself */
 
 	switch (std_status & VIDEO_STD_MASK) {
@@ -369,70 +361,69 @@ static enum tvp514x_std tvp514x_get_current_std(struct tvp514x_decoder
 /*
  * TVP5146/47 register dump function
  */
-static void tvp514x_reg_dump(struct tvp514x_decoder *decoder)
+static void tvp514x_reg_dump(struct v4l2_subdev *sd)
 {
-	u8 value;
-
-	dump_reg(decoder->client, REG_INPUT_SEL, value);
-	dump_reg(decoder->client, REG_AFE_GAIN_CTRL, value);
-	dump_reg(decoder->client, REG_VIDEO_STD, value);
-	dump_reg(decoder->client, REG_OPERATION_MODE, value);
-	dump_reg(decoder->client, REG_COLOR_KILLER, value);
-	dump_reg(decoder->client, REG_LUMA_CONTROL1, value);
-	dump_reg(decoder->client, REG_LUMA_CONTROL2, value);
-	dump_reg(decoder->client, REG_LUMA_CONTROL3, value);
-	dump_reg(decoder->client, REG_BRIGHTNESS, value);
-	dump_reg(decoder->client, REG_CONTRAST, value);
-	dump_reg(decoder->client, REG_SATURATION, value);
-	dump_reg(decoder->client, REG_HUE, value);
-	dump_reg(decoder->client, REG_CHROMA_CONTROL1, value);
-	dump_reg(decoder->client, REG_CHROMA_CONTROL2, value);
-	dump_reg(decoder->client, REG_COMP_PR_SATURATION, value);
-	dump_reg(decoder->client, REG_COMP_Y_CONTRAST, value);
-	dump_reg(decoder->client, REG_COMP_PB_SATURATION, value);
-	dump_reg(decoder->client, REG_COMP_Y_BRIGHTNESS, value);
-	dump_reg(decoder->client, REG_AVID_START_PIXEL_LSB, value);
-	dump_reg(decoder->client, REG_AVID_START_PIXEL_MSB, value);
-	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_LSB, value);
-	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_MSB, value);
-	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_LSB, value);
-	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_MSB, value);
-	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_LSB, value);
-	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_MSB, value);
-	dump_reg(decoder->client, REG_VSYNC_START_LINE_LSB, value);
-	dump_reg(decoder->client, REG_VSYNC_START_LINE_MSB, value);
-	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_LSB, value);
-	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_MSB, value);
-	dump_reg(decoder->client, REG_VBLK_START_LINE_LSB, value);
-	dump_reg(decoder->client, REG_VBLK_START_LINE_MSB, value);
-	dump_reg(decoder->client, REG_VBLK_STOP_LINE_LSB, value);
-	dump_reg(decoder->client, REG_VBLK_STOP_LINE_MSB, value);
-	dump_reg(decoder->client, REG_SYNC_CONTROL, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER1, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER2, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER3, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER4, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER5, value);
-	dump_reg(decoder->client, REG_OUTPUT_FORMATTER6, value);
-	dump_reg(decoder->client, REG_CLEAR_LOST_LOCK, value);
+	dump_reg(sd, REG_INPUT_SEL);
+	dump_reg(sd, REG_AFE_GAIN_CTRL);
+	dump_reg(sd, REG_VIDEO_STD);
+	dump_reg(sd, REG_OPERATION_MODE);
+	dump_reg(sd, REG_COLOR_KILLER);
+	dump_reg(sd, REG_LUMA_CONTROL1);
+	dump_reg(sd, REG_LUMA_CONTROL2);
+	dump_reg(sd, REG_LUMA_CONTROL3);
+	dump_reg(sd, REG_BRIGHTNESS);
+	dump_reg(sd, REG_CONTRAST);
+	dump_reg(sd, REG_SATURATION);
+	dump_reg(sd, REG_HUE);
+	dump_reg(sd, REG_CHROMA_CONTROL1);
+	dump_reg(sd, REG_CHROMA_CONTROL2);
+	dump_reg(sd, REG_COMP_PR_SATURATION);
+	dump_reg(sd, REG_COMP_Y_CONTRAST);
+	dump_reg(sd, REG_COMP_PB_SATURATION);
+	dump_reg(sd, REG_COMP_Y_BRIGHTNESS);
+	dump_reg(sd, REG_AVID_START_PIXEL_LSB);
+	dump_reg(sd, REG_AVID_START_PIXEL_MSB);
+	dump_reg(sd, REG_AVID_STOP_PIXEL_LSB);
+	dump_reg(sd, REG_AVID_STOP_PIXEL_MSB);
+	dump_reg(sd, REG_HSYNC_START_PIXEL_LSB);
+	dump_reg(sd, REG_HSYNC_START_PIXEL_MSB);
+	dump_reg(sd, REG_HSYNC_STOP_PIXEL_LSB);
+	dump_reg(sd, REG_HSYNC_STOP_PIXEL_MSB);
+	dump_reg(sd, REG_VSYNC_START_LINE_LSB);
+	dump_reg(sd, REG_VSYNC_START_LINE_MSB);
+	dump_reg(sd, REG_VSYNC_STOP_LINE_LSB);
+	dump_reg(sd, REG_VSYNC_STOP_LINE_MSB);
+	dump_reg(sd, REG_VBLK_START_LINE_LSB);
+	dump_reg(sd, REG_VBLK_START_LINE_MSB);
+	dump_reg(sd, REG_VBLK_STOP_LINE_LSB);
+	dump_reg(sd, REG_VBLK_STOP_LINE_MSB);
+	dump_reg(sd, REG_SYNC_CONTROL);
+	dump_reg(sd, REG_OUTPUT_FORMATTER1);
+	dump_reg(sd, REG_OUTPUT_FORMATTER2);
+	dump_reg(sd, REG_OUTPUT_FORMATTER3);
+	dump_reg(sd, REG_OUTPUT_FORMATTER4);
+	dump_reg(sd, REG_OUTPUT_FORMATTER5);
+	dump_reg(sd, REG_OUTPUT_FORMATTER6);
+	dump_reg(sd, REG_CLEAR_LOST_LOCK);
 }
 
 /*
  * Configure the TVP5146/47 with the current register settings
  * Returns zero if successful, or non-zero otherwise.
  */
-static int tvp514x_configure(struct tvp514x_decoder *decoder)
+static int tvp514x_configure(struct v4l2_subdev *sd,
+		struct tvp514x_decoder *decoder)
 {
 	int err;
 
 	/* common register initialization */
 	err =
-	    tvp514x_write_regs(decoder->client, decoder->tvp514x_regs);
+	    tvp514x_write_regs(sd, decoder->tvp514x_regs);
 	if (err)
 		return err;
 
 	if (debug)
-		tvp514x_reg_dump(decoder);
+		tvp514x_reg_dump(sd);
 
 	return 0;
 }
@@ -445,15 +436,17 @@ static int tvp514x_configure(struct tvp514x_decoder *decoder)
  * Returns ENODEV error number if no device is detected, or zero
  * if a device is detected.
  */
-static int tvp514x_detect(struct tvp514x_decoder *decoder)
+static int tvp514x_detect(struct v4l2_subdev *sd,
+		struct tvp514x_decoder *decoder)
 {
 	u8 chip_id_msb, chip_id_lsb, rom_ver;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	chip_id_msb = tvp514x_read_reg(decoder->client, REG_CHIP_ID_MSB);
-	chip_id_lsb = tvp514x_read_reg(decoder->client, REG_CHIP_ID_LSB);
-	rom_ver = tvp514x_read_reg(decoder->client, REG_ROM_VERSION);
+	chip_id_msb = tvp514x_read_reg(sd, REG_CHIP_ID_MSB);
+	chip_id_lsb = tvp514x_read_reg(sd, REG_CHIP_ID_LSB);
+	rom_ver = tvp514x_read_reg(sd, REG_ROM_VERSION);
 
-	v4l_dbg(1, debug, decoder->client,
+	v4l2_dbg(1, debug, sd,
 		 "chip id detected msb:0x%x lsb:0x%x rom version:0x%x\n",
 		 chip_id_msb, chip_id_lsb, rom_ver);
 	if ((chip_id_msb != TVP514X_CHIP_ID_MSB)
@@ -462,19 +455,16 @@ static int tvp514x_detect(struct tvp514x_decoder *decoder)
 		/* We didn't read the values we expected, so this must not be
 		 * an TVP5146/47.
 		 */
-		v4l_err(decoder->client,
-			"chip id mismatch msb:0x%x lsb:0x%x\n",
-			chip_id_msb, chip_id_lsb);
+		v4l2_err(sd, "chip id mismatch msb:0x%x lsb:0x%x\n",
+				chip_id_msb, chip_id_lsb);
 		return -ENODEV;
 	}
 
 	decoder->ver = rom_ver;
-	decoder->state = STATE_DETECTED;
 
-	v4l_info(decoder->client,
-			"%s found at 0x%x (%s)\n", decoder->client->name,
-			decoder->client->addr << 1,
-			decoder->client->adapter->name);
+	v4l2_info(sd, "%s (Version - 0x%.2x) found at 0x%x (%s)\n",
+			client->name, decoder->ver,
+			client->addr << 1, client->adapter->name);
 	return 0;
 }
 
@@ -483,17 +473,17 @@ static int tvp514x_detect(struct tvp514x_decoder *decoder)
  * TVP5146/47 decoder driver.
  */
 
-/**
- * ioctl_querystd - V4L2 decoder interface handler for VIDIOC_QUERYSTD ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_querystd - V4L2 decoder interface handler for VIDIOC_QUERYSTD ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @std_id: standard V4L2 std_id ioctl enum
  *
  * Returns the current standard detected by TVP5146/47. If no active input is
  * detected, returns -EINVAL
  */
-static int ioctl_querystd(struct v4l2_int_device *s, v4l2_std_id *std_id)
+static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	enum tvp514x_std current_std;
 	enum tvp514x_input input_sel;
 	u8 sync_lock_status, lock_mask;
@@ -502,11 +492,11 @@ static int ioctl_querystd(struct v4l2_int_device *s, v4l2_std_id *std_id)
 		return -EINVAL;
 
 	/* get the current standard */
-	current_std = tvp514x_get_current_std(decoder);
+	current_std = tvp514x_get_current_std(sd);
 	if (current_std == STD_INVALID)
 		return -EINVAL;
 
-	input_sel = decoder->route.input;
+	input_sel = decoder->input;
 
 	switch (input_sel) {
 	case INPUT_CVBS_VI1A:
@@ -544,42 +534,39 @@ static int ioctl_querystd(struct v4l2_int_device *s, v4l2_std_id *std_id)
 		return -EINVAL;
 	}
 	/* check whether signal is locked */
-	sync_lock_status = tvp514x_read_reg(decoder->client, REG_STATUS1);
+	sync_lock_status = tvp514x_read_reg(sd, REG_STATUS1);
 	if (lock_mask != (sync_lock_status & lock_mask))
 		return -EINVAL;	/* No input detected */
 
 	decoder->current_std = current_std;
 	*std_id = decoder->std_list[current_std].standard.id;
 
-	v4l_dbg(1, debug, decoder->client, "Current STD: %s",
+	v4l2_dbg(1, debug, sd, "Current STD: %s",
 			decoder->std_list[current_std].standard.name);
 	return 0;
 }
 
-/**
- * ioctl_s_std - V4L2 decoder interface handler for VIDIOC_S_STD ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_s_std - V4L2 decoder interface handler for VIDIOC_S_STD ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @std_id: standard V4L2 v4l2_std_id ioctl enum
  *
  * If std_id is supported, sets the requested standard. Otherwise, returns
  * -EINVAL
  */
-static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id *std_id)
+static int tvp514x_s_std(struct v4l2_subdev *sd, v4l2_std_id std_id)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int err, i;
 
-	if (std_id == NULL)
-		return -EINVAL;
-
 	for (i = 0; i < decoder->num_stds; i++)
-		if (*std_id & decoder->std_list[i].standard.id)
+		if (std_id & decoder->std_list[i].standard.id)
 			break;
 
 	if ((i == decoder->num_stds) || (i == STD_INVALID))
 		return -EINVAL;
 
-	err = tvp514x_write_reg(decoder->client, REG_VIDEO_STD,
+	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
 				decoder->std_list[i].video_std);
 	if (err)
 		return err;
@@ -588,24 +575,24 @@ static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id *std_id)
 	decoder->tvp514x_regs[REG_VIDEO_STD].val =
 		decoder->std_list[i].video_std;
 
-	v4l_dbg(1, debug, decoder->client, "Standard set to: %s",
+	v4l2_dbg(1, debug, sd, "Standard set to: %s",
 			decoder->std_list[i].standard.name);
 	return 0;
 }
 
-/**
- * ioctl_s_routing - V4L2 decoder interface handler for VIDIOC_S_INPUT ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_s_routing - V4L2 decoder interface handler for VIDIOC_S_INPUT ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @index: number of the input
  *
  * If index is valid, selects the requested input. Otherwise, returns -EINVAL if
  * the input is not supported or there is no active signal present in the
  * selected input.
  */
-static int ioctl_s_routing(struct v4l2_int_device *s,
-				struct v4l2_routing *route)
+static int tvp514x_s_routing(struct v4l2_subdev *sd,
+				u32 input, u32 output, u32 config)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int err;
 	enum tvp514x_input input_sel;
 	enum tvp514x_output output_sel;
@@ -613,20 +600,20 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 	u8 sync_lock_status, lock_mask;
 	int try_count = LOCK_RETRY_COUNT;
 
-	if ((!route) || (route->input >= INPUT_INVALID) ||
-			(route->output >= OUTPUT_INVALID))
+	if ((input >= INPUT_INVALID) ||
+			(output >= OUTPUT_INVALID))
 		return -EINVAL;	/* Index out of bound */
 
-	input_sel = route->input;
-	output_sel = route->output;
+	input_sel = input;
+	output_sel = output;
 
-	err = tvp514x_write_reg(decoder->client, REG_INPUT_SEL, input_sel);
+	err = tvp514x_write_reg(sd, REG_INPUT_SEL, input_sel);
 	if (err)
 		return err;
 
-	output_sel |= tvp514x_read_reg(decoder->client,
+	output_sel |= tvp514x_read_reg(sd,
 			REG_OUTPUT_FORMATTER1) & 0x7;
-	err = tvp514x_write_reg(decoder->client, REG_OUTPUT_FORMATTER1,
+	err = tvp514x_write_reg(sd, REG_OUTPUT_FORMATTER1,
 			output_sel);
 	if (err)
 		return err;
@@ -637,7 +624,7 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 	/* Clear status */
 	msleep(LOCK_RETRY_DELAY);
 	err =
-	    tvp514x_write_reg(decoder->client, REG_CLEAR_LOST_LOCK, 0x01);
+	    tvp514x_write_reg(sd, REG_CLEAR_LOST_LOCK, 0x01);
 	if (err)
 		return err;
 
@@ -682,11 +669,11 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 		msleep(LOCK_RETRY_DELAY);
 
 		/* get the current standard for future reference */
-		current_std = tvp514x_get_current_std(decoder);
+		current_std = tvp514x_get_current_std(sd);
 		if (current_std == STD_INVALID)
 			continue;
 
-		sync_lock_status = tvp514x_read_reg(decoder->client,
+		sync_lock_status = tvp514x_read_reg(sd,
 				REG_STATUS1);
 		if (lock_mask == (sync_lock_status & lock_mask))
 			break;	/* Input detected */
@@ -696,28 +683,26 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 		return -EINVAL;
 
 	decoder->current_std = current_std;
-	decoder->route.input = route->input;
-	decoder->route.output = route->output;
+	decoder->input = input;
+	decoder->output = output;
 
-	v4l_dbg(1, debug, decoder->client,
-			"Input set to: %d, std : %d",
+	v4l2_dbg(1, debug, sd, "Input set to: %d, std : %d",
 			input_sel, current_std);
 
 	return 0;
 }
 
-/**
- * ioctl_queryctrl - V4L2 decoder interface handler for VIDIOC_QUERYCTRL ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_queryctrl - V4L2 decoder interface handler for VIDIOC_QUERYCTRL ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @qctrl: standard V4L2 v4l2_queryctrl structure
  *
  * If the requested control is supported, returns the control information.
  * Otherwise, returns -EINVAL if the control is not supported.
  */
 static int
-ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl *qctrl)
+tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
 {
-	struct tvp514x_decoder *decoder = s->priv;
 	int err = -EINVAL;
 
 	if (qctrl == NULL)
@@ -744,30 +729,27 @@ ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl *qctrl)
 		err = v4l2_ctrl_query_fill(qctrl, -180, 180, 180, 0);
 		break;
 	case V4L2_CID_AUTOGAIN:
-		/* Autogain is either 0 or 1*/
-		memcpy(qctrl, &tvp514x_autogain_ctrl,
-				sizeof(struct v4l2_queryctrl));
-		err = 0;
+		/*
+		 * Auto Gain supported is -
+		 * 	0 - 1 (Default - 1)
+		 */
+		err = v4l2_ctrl_query_fill(qctrl, 0, 1, 1, 1);
 		break;
 	default:
-		v4l_err(decoder->client,
-			"invalid control id %d\n", qctrl->id);
+		v4l2_err(sd, "invalid control id %d\n", qctrl->id);
 		return err;
 	}
 
-	v4l_dbg(1, debug, decoder->client,
-			"Query Control: %s : Min - %d, Max - %d, Def - %d",
-			qctrl->name,
-			qctrl->minimum,
-			qctrl->maximum,
+	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def - %d",
+			qctrl->name, qctrl->minimum, qctrl->maximum,
 			qctrl->default_value);
 
 	return err;
 }
 
-/**
- * ioctl_g_ctrl - V4L2 decoder interface handler for VIDIOC_G_CTRL ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_g_ctrl - V4L2 decoder interface handler for VIDIOC_G_CTRL ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @ctrl: pointer to v4l2_control structure
  *
  * If the requested control is supported, returns the control's current
@@ -775,9 +757,9 @@ ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl *qctrl)
  * supported.
  */
 static int
-ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
+tvp514x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	if (ctrl == NULL)
 		return -EINVAL;
@@ -811,74 +793,70 @@ ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 
 		break;
 	default:
-		v4l_err(decoder->client,
-			"invalid control id %d\n", ctrl->id);
+		v4l2_err(sd, "invalid control id %d\n", ctrl->id);
 		return -EINVAL;
 	}
 
-	v4l_dbg(1, debug, decoder->client,
-			"Get Control: ID - %d - %d",
+	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d",
 			ctrl->id, ctrl->value);
 	return 0;
 }
 
-/**
- * ioctl_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @ctrl: pointer to v4l2_control structure
  *
  * If the requested control is supported, sets the control's current
  * value in HW. Otherwise, returns -EINVAL if the control is not supported.
  */
 static int
-ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
+tvp514x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int err = -EINVAL, value;
 
 	if (ctrl == NULL)
 		return err;
 
-	value = (__s32) ctrl->value;
+	value = ctrl->value;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
 		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l_err(decoder->client,
-					"invalid brightness setting %d\n",
+			v4l2_err(sd, "invalid brightness setting %d\n",
 					ctrl->value);
 			return -ERANGE;
 		}
-		err = tvp514x_write_reg(decoder->client, REG_BRIGHTNESS,
+		err = tvp514x_write_reg(sd, REG_BRIGHTNESS,
 				value);
 		if (err)
 			return err;
+
 		decoder->tvp514x_regs[REG_BRIGHTNESS].val = value;
 		break;
 	case V4L2_CID_CONTRAST:
 		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l_err(decoder->client,
-					"invalid contrast setting %d\n",
+			v4l2_err(sd, "invalid contrast setting %d\n",
 					ctrl->value);
 			return -ERANGE;
 		}
-		err = tvp514x_write_reg(decoder->client, REG_CONTRAST,
-				value);
+		err = tvp514x_write_reg(sd, REG_CONTRAST, value);
 		if (err)
 			return err;
+
 		decoder->tvp514x_regs[REG_CONTRAST].val = value;
 		break;
 	case V4L2_CID_SATURATION:
 		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l_err(decoder->client,
-					"invalid saturation setting %d\n",
+			v4l2_err(sd, "invalid saturation setting %d\n",
 					ctrl->value);
 			return -ERANGE;
 		}
-		err = tvp514x_write_reg(decoder->client, REG_SATURATION,
-				value);
+		err = tvp514x_write_reg(sd, REG_SATURATION, value);
 		if (err)
 			return err;
+
 		decoder->tvp514x_regs[REG_SATURATION].val = value;
 		break;
 	case V4L2_CID_HUE:
@@ -889,15 +867,13 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 		else if (value == 0)
 			value = 0;
 		else {
-			v4l_err(decoder->client,
-					"invalid hue setting %d\n",
-					ctrl->value);
+			v4l2_err(sd, "invalid hue setting %d\n", ctrl->value);
 			return -ERANGE;
 		}
-		err = tvp514x_write_reg(decoder->client, REG_HUE,
-				value);
+		err = tvp514x_write_reg(sd, REG_HUE, value);
 		if (err)
 			return err;
+
 		decoder->tvp514x_regs[REG_HUE].val = value;
 		break;
 	case V4L2_CID_AUTOGAIN:
@@ -906,41 +882,38 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 		else if (value == 0)
 			value = 0x0C;
 		else {
-			v4l_err(decoder->client,
-					"invalid auto gain setting %d\n",
+			v4l2_err(sd, "invalid auto gain setting %d\n",
 					ctrl->value);
 			return -ERANGE;
 		}
-		err = tvp514x_write_reg(decoder->client, REG_AFE_GAIN_CTRL,
-				value);
+		err = tvp514x_write_reg(sd, REG_AFE_GAIN_CTRL, value);
 		if (err)
 			return err;
+
 		decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val = value;
 		break;
 	default:
-		v4l_err(decoder->client,
-			"invalid control id %d\n", ctrl->id);
+		v4l2_err(sd, "invalid control id %d\n", ctrl->id);
 		return err;
 	}
 
-	v4l_dbg(1, debug, decoder->client,
-			"Set Control: ID - %d - %d",
+	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d",
 			ctrl->id, ctrl->value);
 
 	return err;
 }
 
-/**
- * ioctl_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
  *
  * Implement the VIDIOC_ENUM_FMT ioctl to enumerate supported formats
  */
 static int
-ioctl_enum_fmt_cap(struct v4l2_int_device *s, struct v4l2_fmtdesc *fmt)
+tvp514x_enum_fmt_cap(struct v4l2_subdev *sd, struct v4l2_fmtdesc *fmt)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int index;
 
 	if (fmt == NULL)
@@ -956,16 +929,15 @@ ioctl_enum_fmt_cap(struct v4l2_int_device *s, struct v4l2_fmtdesc *fmt)
 	memcpy(fmt, &decoder->fmt_list[index],
 		sizeof(struct v4l2_fmtdesc));
 
-	v4l_dbg(1, debug, decoder->client,
-			"Current FMT: index - %d (%s)",
+	v4l2_dbg(1, debug, sd, "Current FMT: index - %d (%s)",
 			decoder->fmt_list[index].index,
 			decoder->fmt_list[index].description);
 	return 0;
 }
 
-/**
- * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
  *
  * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type. This
@@ -973,9 +945,9 @@ ioctl_enum_fmt_cap(struct v4l2_int_device *s, struct v4l2_fmtdesc *fmt)
  * without actually making it take effect.
  */
 static int
-ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
+tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int ifmt;
 	struct v4l2_pix_format *pix;
 	enum tvp514x_std current_std;
@@ -989,7 +961,7 @@ ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
 	pix = &f->fmt.pix;
 
 	/* Calculate height and width based on current standard */
-	current_std = tvp514x_get_current_std(decoder);
+	current_std = tvp514x_get_current_std(sd);
 	if (current_std == STD_INVALID)
 		return -EINVAL;
 
@@ -1012,17 +984,16 @@ ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->priv = 0;
 
-	v4l_dbg(1, debug, decoder->client,
-			"Try FMT: pixelformat - %s, bytesperline - %d"
+	v4l2_dbg(1, debug, sd, "Try FMT: pixelformat - %s, bytesperline - %d"
 			"Width - %d, Height - %d",
 			decoder->fmt_list[ifmt].description, pix->bytesperline,
 			pix->width, pix->height);
 	return 0;
 }
 
-/**
- * ioctl_s_fmt_cap - V4L2 decoder interface handler for VIDIOC_S_FMT ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_s_fmt_cap - V4L2 decoder interface handler for VIDIOC_S_FMT ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
  *
  * If the requested format is supported, configures the HW to use that
@@ -1030,9 +1001,9 @@ ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
  * correctly configured.
  */
 static int
-ioctl_s_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
+tvp514x_s_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	struct v4l2_pix_format *pix;
 	int rval;
 
@@ -1043,7 +1014,7 @@ ioctl_s_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
 		return -EINVAL;	/* only capture is supported */
 
 	pix = &f->fmt.pix;
-	rval = ioctl_try_fmt_cap(s, f);
+	rval = tvp514x_try_fmt_cap(sd, f);
 	if (rval)
 		return rval;
 
@@ -1052,18 +1023,18 @@ ioctl_s_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
 	return rval;
 }
 
-/**
- * ioctl_g_fmt_cap - V4L2 decoder interface handler for ioctl_g_fmt_cap
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_g_fmt_cap - V4L2 decoder interface handler for tvp514x_g_fmt_cap
+ * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 v4l2_format structure
  *
  * Returns the decoder's current pixel format in the v4l2_format
  * parameter.
  */
 static int
-ioctl_g_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
+tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	if (f == NULL)
 		return -EINVAL;
@@ -1073,25 +1044,24 @@ ioctl_g_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
 
 	f->fmt.pix = decoder->pix;
 
-	v4l_dbg(1, debug, decoder->client,
-			"Current FMT: bytesperline - %d"
+	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
 			"Width - %d, Height - %d",
 			decoder->pix.bytesperline,
 			decoder->pix.width, decoder->pix.height);
 	return 0;
 }
 
-/**
- * ioctl_g_parm - V4L2 decoder interface handler for VIDIOC_G_PARM ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_g_parm - V4L2 decoder interface handler for VIDIOC_G_PARM ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
  *
  * Returns the decoder's video CAPTURE parameters.
  */
 static int
-ioctl_g_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
+tvp514x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	struct v4l2_captureparm *cparm;
 	enum tvp514x_std current_std;
 
@@ -1105,7 +1075,7 @@ ioctl_g_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
 	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	/* get the current standard */
-	current_std = tvp514x_get_current_std(decoder);
+	current_std = tvp514x_get_current_std(sd);
 	if (current_std == STD_INVALID)
 		return -EINVAL;
 
@@ -1119,18 +1089,18 @@ ioctl_g_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
 	return 0;
 }
 
-/**
- * ioctl_s_parm - V4L2 decoder interface handler for VIDIOC_S_PARM ioctl
- * @s: pointer to standard V4L2 device structure
+/*
+ * tvp514x_s_parm - V4L2 decoder interface handler for VIDIOC_S_PARM ioctl
+ * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
  *
  * Configures the decoder to use the input parameters, if possible. If
  * not possible, returns the appropriate error code.
  */
 static int
-ioctl_s_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
+tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 {
-	struct tvp514x_decoder *decoder = s->priv;
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 	struct v4l2_fract *timeperframe;
 	enum tvp514x_std current_std;
 
@@ -1143,7 +1113,7 @@ ioctl_s_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
 	timeperframe = &a->parm.capture.timeperframe;
 
 	/* get the current standard */
-	current_std = tvp514x_get_current_std(decoder);
+	current_std = tvp514x_get_current_std(sd);
 	if (current_std == STD_INVALID)
 		return -EINVAL;
 
@@ -1155,112 +1125,59 @@ ioctl_s_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
 	return 0;
 }
 
-/**
- * ioctl_g_ifparm - V4L2 decoder interface handler for vidioc_int_g_ifparm_num
- * @s: pointer to standard V4L2 device structure
- * @p: pointer to standard V4L2 vidioc_int_g_ifparm_num ioctl structure
- *
- * Gets slave interface parameters.
- * Calculates the required xclk value to support the requested
- * clock parameters in p. This value is returned in the p
- * parameter.
- */
-static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
-{
-	struct tvp514x_decoder *decoder = s->priv;
-	int rval;
-
-	if (p == NULL)
-		return -EINVAL;
-
-	if (NULL == decoder->pdata->ifparm)
-		return -EINVAL;
-
-	rval = decoder->pdata->ifparm(p);
-	if (rval) {
-		v4l_err(decoder->client, "g_ifparm.Err[%d]\n", rval);
-		return rval;
-	}
-
-	p->u.bt656.clock_curr = TVP514X_XCLK_BT656;
-
-	return 0;
-}
-
-/**
- * ioctl_g_priv - V4L2 decoder interface handler for vidioc_int_g_priv_num
- * @s: pointer to standard V4L2 device structure
- * @p: void pointer to hold decoder's private data address
- *
- * Returns device's (decoder's) private data area address in p parameter
- */
-static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
-{
-	struct tvp514x_decoder *decoder = s->priv;
-
-	if (NULL == decoder->pdata->priv_data_set)
-		return -EINVAL;
-
-	return decoder->pdata->priv_data_set(p);
-}
-
-/**
- * ioctl_s_power - V4L2 decoder interface handler for vidioc_int_s_power_num
- * @s: pointer to standard V4L2 device structure
- * @on: power state to which device is to be set
+/*
+ * tvp514x_s_stream - V4L2 decoder interface handler for vidioc_int_s_power_num
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @enable: streaming enable or disable
  *
- * Sets devices power state to requrested state, if possible.
+ * Sets streaming to enable or disable, if possible.
  */
-static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
+static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct tvp514x_decoder *decoder = s->priv;
 	int err = 0;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 
-	switch (on) {
-	case V4L2_POWER_OFF:
-		/* Power Down Sequence */
-		err =
-		    tvp514x_write_reg(decoder->client, REG_OPERATION_MODE,
-					0x01);
-		/* Disable mux for TVP5146/47 decoder data path */
-		if (decoder->pdata->power_set)
-			err |= decoder->pdata->power_set(on);
-		decoder->state = STATE_NOT_DETECTED;
-		break;
+	if (decoder->streaming == enable)
+		return 0;
 
-	case V4L2_POWER_STANDBY:
-		if (decoder->pdata->power_set)
-			err = decoder->pdata->power_set(on);
+	switch (enable) {
+	case 0:
+	{
+		/* Power Down Sequence */
+		err = tvp514x_write_reg(sd, REG_OPERATION_MODE, 0x01);
+		if (err) {
+			v4l2_err(sd, "Unable to turn off decoder\n");
+			return err;
+		}
+		decoder->streaming = enable;
 		break;
+	}
+	case 1:
+	{
+		struct tvp514x_reg *int_seq = (struct tvp514x_reg *)
+				client->driver->id_table->driver_data;
 
-	case V4L2_POWER_ON:
-		/* Enable mux for TVP5146/47 decoder data path */
-		if ((decoder->pdata->power_set) &&
-				(decoder->state == STATE_NOT_DETECTED)) {
-			int i;
-			struct tvp514x_init_seq *int_seq =
-				(struct tvp514x_init_seq *)
-				decoder->id->driver_data;
-
-			err = decoder->pdata->power_set(on);
-
-			/* Power Up Sequence */
-			for (i = 0; i < int_seq->no_regs; i++) {
-				err |= tvp514x_write_reg(decoder->client,
-						int_seq->init_reg_seq[i].reg,
-						int_seq->init_reg_seq[i].val);
-			}
-			/* Detect the sensor is not already detected */
-			err |= tvp514x_detect(decoder);
-			if (err) {
-				v4l_err(decoder->client,
-						"Unable to detect decoder\n");
-				return err;
-			}
+		/* Power Up Sequence */
+		err = tvp514x_write_regs(sd, int_seq);
+		if (err) {
+			v4l2_err(sd, "Unable to turn on decoder\n");
+			return err;
+		}
+		/* Detect if not already detected */
+		err = tvp514x_detect(sd, decoder);
+		if (err) {
+			v4l2_err(sd, "Unable to detect decoder\n");
+			return err;
 		}
-		err |= tvp514x_configure(decoder);
+		err = tvp514x_configure(sd, decoder);
+		if (err) {
+			v4l2_err(sd, "Unable to configure decoder\n");
+			return err;
+		}
+		decoder->streaming = enable;
 		break;
-
+	}
 	default:
 		err = -ENODEV;
 		break;
@@ -1269,93 +1186,37 @@ static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
 	return err;
 }
 
-/**
- * ioctl_init - V4L2 decoder interface handler for VIDIOC_INT_INIT
- * @s: pointer to standard V4L2 device structure
- *
- * Initialize the decoder device (calls tvp514x_configure())
- */
-static int ioctl_init(struct v4l2_int_device *s)
-{
-	struct tvp514x_decoder *decoder = s->priv;
-
-	/* Set default standard to auto */
-	decoder->tvp514x_regs[REG_VIDEO_STD].val =
-	    VIDEO_STD_AUTO_SWITCH_BIT;
-
-	return tvp514x_configure(decoder);
-}
-
-/**
- * ioctl_dev_exit - V4L2 decoder interface handler for vidioc_int_dev_exit_num
- * @s: pointer to standard V4L2 device structure
- *
- * Delinitialise the dev. at slave detach. The complement of ioctl_dev_init.
- */
-static int ioctl_dev_exit(struct v4l2_int_device *s)
-{
-	return 0;
-}
-
-/**
- * ioctl_dev_init - V4L2 decoder interface handler for vidioc_int_dev_init_num
- * @s: pointer to standard V4L2 device structure
- *
- * Initialise the device when slave attaches to the master. Returns 0 if
- * TVP5146/47 device could be found, otherwise returns appropriate error.
- */
-static int ioctl_dev_init(struct v4l2_int_device *s)
-{
-	struct tvp514x_decoder *decoder = s->priv;
-	int err;
-
-	err = tvp514x_detect(decoder);
-	if (err < 0) {
-		v4l_err(decoder->client,
-			"Unable to detect decoder\n");
-		return err;
-	}
-
-	v4l_info(decoder->client,
-		 "chip version 0x%.2x detected\n", decoder->ver);
+static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
+	.queryctrl = tvp514x_queryctrl,
+	.g_ctrl = tvp514x_g_ctrl,
+	.s_ctrl = tvp514x_s_ctrl,
+	.s_std = tvp514x_s_std,
+};
 
-	return 0;
-}
+static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
+	.s_routing = tvp514x_s_routing,
+	.querystd = tvp514x_querystd,
+	.enum_fmt = tvp514x_enum_fmt_cap,
+	.g_fmt = tvp514x_g_fmt_cap,
+	.try_fmt = tvp514x_try_fmt_cap,
+	.s_fmt = tvp514x_s_fmt_cap,
+	.g_parm = tvp514x_g_parm,
+	.s_parm = tvp514x_s_parm,
+	.s_stream = tvp514x_s_stream,
+};
 
-static struct v4l2_int_ioctl_desc tvp514x_ioctl_desc[] = {
-	{vidioc_int_dev_init_num, (v4l2_int_ioctl_func*) ioctl_dev_init},
-	{vidioc_int_dev_exit_num, (v4l2_int_ioctl_func*) ioctl_dev_exit},
-	{vidioc_int_s_power_num, (v4l2_int_ioctl_func*) ioctl_s_power},
-	{vidioc_int_g_priv_num, (v4l2_int_ioctl_func*) ioctl_g_priv},
-	{vidioc_int_g_ifparm_num, (v4l2_int_ioctl_func*) ioctl_g_ifparm},
-	{vidioc_int_init_num, (v4l2_int_ioctl_func*) ioctl_init},
-	{vidioc_int_enum_fmt_cap_num,
-	 (v4l2_int_ioctl_func *) ioctl_enum_fmt_cap},
-	{vidioc_int_try_fmt_cap_num,
-	 (v4l2_int_ioctl_func *) ioctl_try_fmt_cap},
-	{vidioc_int_g_fmt_cap_num,
-	 (v4l2_int_ioctl_func *) ioctl_g_fmt_cap},
-	{vidioc_int_s_fmt_cap_num,
-	 (v4l2_int_ioctl_func *) ioctl_s_fmt_cap},
-	{vidioc_int_g_parm_num, (v4l2_int_ioctl_func *) ioctl_g_parm},
-	{vidioc_int_s_parm_num, (v4l2_int_ioctl_func *) ioctl_s_parm},
-	{vidioc_int_queryctrl_num,
-	 (v4l2_int_ioctl_func *) ioctl_queryctrl},
-	{vidioc_int_g_ctrl_num, (v4l2_int_ioctl_func *) ioctl_g_ctrl},
-	{vidioc_int_s_ctrl_num, (v4l2_int_ioctl_func *) ioctl_s_ctrl},
-	{vidioc_int_querystd_num, (v4l2_int_ioctl_func *) ioctl_querystd},
-	{vidioc_int_s_std_num, (v4l2_int_ioctl_func *) ioctl_s_std},
-	{vidioc_int_s_video_routing_num,
-		(v4l2_int_ioctl_func *) ioctl_s_routing},
+static const struct v4l2_subdev_ops tvp514x_ops = {
+	.core = &tvp514x_core_ops,
+	.video = &tvp514x_video_ops,
 };
 
 static struct tvp514x_decoder tvp514x_dev = {
-	.state = STATE_NOT_DETECTED,
+	.streaming = 0,
 
 	.fmt_list = tvp514x_fmt_list,
 	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
 
-	.pix = {		/* Default to NTSC 8-bit YUV 422 */
+	.pix = {/* Default to NTSC 8-bit YUV 422 */
 		.width = NTSC_NUM_ACTIVE_PIXELS,
 		.height = NTSC_NUM_ACTIVE_LINES,
 		.pixelformat = V4L2_PIX_FMT_UYVY,
@@ -1369,20 +1230,13 @@ static struct tvp514x_decoder tvp514x_dev = {
 	.current_std = STD_NTSC_MJ,
 	.std_list = tvp514x_std_list,
 	.num_stds = ARRAY_SIZE(tvp514x_std_list),
-	.v4l2_int_device = {
-		.module = THIS_MODULE,
-		.name = TVP514X_MODULE_NAME,
-		.type = v4l2_int_type_slave,
-	},
-	.tvp514x_slave = {
-		.ioctls = tvp514x_ioctl_desc,
-		.num_ioctls = ARRAY_SIZE(tvp514x_ioctl_desc),
-	},
+
 };
 
-/**
+/*
  * tvp514x_probe - decoder driver i2c probe handler
  * @client: i2c driver client device structure
+ * @id: i2c driver id table
  *
  * Register decoder as an i2c client device and V4L2
  * device.
@@ -1391,82 +1245,71 @@ static int
 tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct tvp514x_decoder *decoder;
-	int err;
+	struct v4l2_subdev *sd;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
+	if (!client->dev.platform_data) {
+		v4l2_err(client, "No platform data!!\n");
+		return -ENODEV;
+	}
+
 	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 
-	if (!client->dev.platform_data) {
-		v4l_err(client, "No platform data!!\n");
-		err = -ENODEV;
-		goto out_free;
-	}
-
+	/*
+	 * Initialize the tvp514x_decoder with default configuration
+	 */
 	*decoder = tvp514x_dev;
-	decoder->v4l2_int_device.priv = decoder;
-	decoder->pdata = client->dev.platform_data;
-	decoder->v4l2_int_device.u.slave = &decoder->tvp514x_slave;
+	/* Copy default register configuration */
 	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
 			sizeof(tvp514x_reg_list_default));
+
+	/*
+	 * Copy board specific information here
+	 */
+	decoder->pdata = client->dev.platform_data;
+
 	/*
 	 * Fetch platform specific data, and configure the
 	 * tvp514x_reg_list[] accordingly. Since this is one
 	 * time configuration, no need to preserve.
 	 */
 	decoder->tvp514x_regs[REG_OUTPUT_FORMATTER2].val |=
-			(decoder->pdata->clk_polarity << 1);
+		(decoder->pdata->clk_polarity << 1);
 	decoder->tvp514x_regs[REG_SYNC_CONTROL].val |=
-			((decoder->pdata->hs_polarity << 2) |
-			(decoder->pdata->vs_polarity << 3));
-	/*
-	 * Save the id data, required for power up sequence
-	 */
-	decoder->id = (struct i2c_device_id *)id;
-	/* Attach to Master */
-	strcpy(decoder->v4l2_int_device.u.slave->attach_to,
-			decoder->pdata->master);
-	decoder->client = client;
-	i2c_set_clientdata(client, decoder);
+		((decoder->pdata->hs_polarity << 2) |
+		 (decoder->pdata->vs_polarity << 3));
+	/* Set default standard to auto */
+	decoder->tvp514x_regs[REG_VIDEO_STD].val =
+		VIDEO_STD_AUTO_SWITCH_BIT;
 
 	/* Register with V4L2 layer as slave device */
-	err = v4l2_int_device_register(&decoder->v4l2_int_device);
-	if (err) {
-		i2c_set_clientdata(client, NULL);
-		v4l_err(client,
-			"Unable to register to v4l2. Err[%d]\n", err);
-		goto out_free;
-
-	} else
-		v4l_info(client, "Registered to v4l2 master %s!!\n",
-				decoder->pdata->master);
+	sd = &decoder->sd;
+	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
+
+	v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
+
 	return 0;
 
-out_free:
-	kfree(decoder);
-	return err;
 }
 
-/**
+/*
  * tvp514x_remove - decoder driver i2c remove handler
  * @client: i2c driver client device structure
  *
  * Unregister decoder as an i2c client device and V4L2
  * device. Complement of tvp514x_probe().
  */
-static int __exit tvp514x_remove(struct i2c_client *client)
+static int tvp514x_remove(struct i2c_client *client)
 {
-	struct tvp514x_decoder *decoder = i2c_get_clientdata(client);
-
-	if (!client->adapter)
-		return -ENODEV;	/* our client isn't attached */
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tvp514x_decoder *decoder = to_decoder(sd);
 
-	v4l2_int_device_unregister(&decoder->v4l2_int_device);
-	i2c_set_clientdata(client, NULL);
+	v4l2_device_unregister_subdev(sd);
 	kfree(decoder);
 	return 0;
 }
@@ -1485,11 +1328,9 @@ static const struct tvp514x_reg tvp5146_init_reg_seq[] = {
 	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
+	{TOK_TERM, 0, 0},
 };
-static const struct tvp514x_init_seq tvp5146_init = {
-	.no_regs = ARRAY_SIZE(tvp5146_init_reg_seq),
-	.init_reg_seq = tvp5146_init_reg_seq,
-};
+
 /*
  * TVP5147 Init/Power on Sequence
  */
@@ -1512,22 +1353,18 @@ static const struct tvp514x_reg tvp5147_init_reg_seq[] =	{
 	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
+	{TOK_TERM, 0, 0},
 };
-static const struct tvp514x_init_seq tvp5147_init = {
-	.no_regs = ARRAY_SIZE(tvp5147_init_reg_seq),
-	.init_reg_seq = tvp5147_init_reg_seq,
-};
+
 /*
  * TVP5146M2/TVP5147M1 Init/Power on Sequence
  */
 static const struct tvp514x_reg tvp514xm_init_reg_seq[] = {
 	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
+	{TOK_TERM, 0, 0},
 };
-static const struct tvp514x_init_seq tvp514xm_init = {
-	.no_regs = ARRAY_SIZE(tvp514xm_init_reg_seq),
-	.init_reg_seq = tvp514xm_init_reg_seq,
-};
+
 /*
  * I2C Device Table -
  *
@@ -1535,48 +1372,34 @@ static const struct tvp514x_init_seq tvp514xm_init = {
  * driver_data - Driver data
  */
 static const struct i2c_device_id tvp514x_id[] = {
-	{"tvp5146", (unsigned long)&tvp5146_init},
-	{"tvp5146m2", (unsigned long)&tvp514xm_init},
-	{"tvp5147", (unsigned long)&tvp5147_init},
-	{"tvp5147m1", (unsigned long)&tvp514xm_init},
+	{"tvp5146", (unsigned long)tvp5146_init_reg_seq},
+	{"tvp5146m2", (unsigned long)tvp514xm_init_reg_seq},
+	{"tvp5147", (unsigned long)tvp5147_init_reg_seq},
+	{"tvp5147m1", (unsigned long)tvp514xm_init_reg_seq},
 	{},
 };
 
 MODULE_DEVICE_TABLE(i2c, tvp514x_id);
 
-static struct i2c_driver tvp514x_i2c_driver = {
+static struct i2c_driver tvp514x_driver = {
 	.driver = {
-		   .name = TVP514X_MODULE_NAME,
-		   .owner = THIS_MODULE,
-		   },
+		.owner = THIS_MODULE,
+		.name = TVP514X_MODULE_NAME,
+	},
 	.probe = tvp514x_probe,
-	.remove = __exit_p(tvp514x_remove),
+	.remove = tvp514x_remove,
 	.id_table = tvp514x_id,
 };
 
-/**
- * tvp514x_init
- *
- * Module init function
- */
 static int __init tvp514x_init(void)
 {
-	return i2c_add_driver(&tvp514x_i2c_driver);
+	return i2c_add_driver(&tvp514x_driver);
 }
 
-/**
- * tvp514x_cleanup
- *
- * Module exit function
- */
-static void __exit tvp514x_cleanup(void)
+static void __exit tvp514x_exit(void)
 {
-	i2c_del_driver(&tvp514x_i2c_driver);
+	i2c_del_driver(&tvp514x_driver);
 }
 
 module_init(tvp514x_init);
-module_exit(tvp514x_cleanup);
-
-MODULE_AUTHOR("Texas Instruments");
-MODULE_DESCRIPTION("TVP514X linux decoder driver");
-MODULE_LICENSE("GPL");
+module_exit(tvp514x_exit);
diff --git a/drivers/media/video/tvp514x_regs.h b/drivers/media/video/tvp514x_regs.h
index 351620a..18f29ad 100644
--- a/drivers/media/video/tvp514x_regs.h
+++ b/drivers/media/video/tvp514x_regs.h
@@ -284,14 +284,4 @@ struct tvp514x_reg {
 	u32 val;
 };
 
-/**
- * struct tvp514x_init_seq - Structure for TVP5146/47/46M2/47M1 power up
- *		Sequence.
- * @ no_regs - Number of registers to write for power up sequence.
- * @ init_reg_seq - Array of registers and respective value to write.
- */
-struct tvp514x_init_seq {
-	unsigned int no_regs;
-	const struct tvp514x_reg *init_reg_seq;
-};
 #endif				/* ifndef _TVP514X_REGS_H */
diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
index 5e7ee96..74387e8 100644
--- a/include/media/tvp514x.h
+++ b/include/media/tvp514x.h
@@ -104,10 +104,6 @@ enum tvp514x_output {
  * @ vs_polarity: VSYNC Polarity configuration for current interface.
  */
 struct tvp514x_platform_data {
-	char *master;
-	int (*power_set) (enum v4l2_power on);
-	int (*ifparm) (struct v4l2_ifparm *p);
-	int (*priv_data_set) (void *);
 	/* Interface control params */
 	bool clk_polarity;
 	bool hs_polarity;
-- 
1.6.0.4

