Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:32839 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZFVRs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 13:48:28 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5MHmQMB018301
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 12:48:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] tvp514x: formatting comments as per kernel documenation
Date: Mon, 22 Jun 2009 13:48:24 -0400
Message-Id: <1245692904-23201-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Fix documentation style based on comments from Mauro.

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/tvp514x.c |  275 +++++++++++++++++++++++------------------
 1 files changed, 157 insertions(+), 118 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 6063b57..31d09aa 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -56,16 +56,14 @@ MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TVP514X linux decoder driver");
 MODULE_LICENSE("GPL");
 
-/*
- * enum tvp514x_std - enum for supported standards
- */
+/* enum tvp514x_std - enum for supported standards */
 enum tvp514x_std {
 	STD_NTSC_MJ = 0,
 	STD_PAL_BDGHIN,
 	STD_INVALID
 };
 
-/*
+/**
  * struct tvp514x_std_info - Structure to store standard informations
  * @width: Line width in pixels
  * @height:Number of active lines
@@ -80,7 +78,7 @@ struct tvp514x_std_info {
 };
 
 static struct tvp514x_reg tvp514x_reg_list_default[0x40];
-/*
+/**
  * struct tvp514x_decoder - TVP5146/47 decoder object
  * @sd: Subdevice Slave handle
  * @tvp514x_regs: copy of hw's regs with preset values.
@@ -111,18 +109,18 @@ struct tvp514x_decoder {
 	enum tvp514x_std current_std;
 	int num_stds;
 	struct tvp514x_std_info *std_list;
-	/*
-	 * Input and Output Routing parameters
-	 */
+	/* Input and Output Routing parameters */
 	u32 input;
 	u32 output;
 };
 
 /* TVP514x default register values */
 static struct tvp514x_reg tvp514x_reg_list_default[] = {
-	{TOK_WRITE, REG_INPUT_SEL, 0x05},	/* Composite selected */
+	/* Composite selected */
+	{TOK_WRITE, REG_INPUT_SEL, 0x05},
 	{TOK_WRITE, REG_AFE_GAIN_CTRL, 0x0F},
-	{TOK_WRITE, REG_VIDEO_STD, 0x00},	/* Auto mode */
+	/* Auto mode */
+	{TOK_WRITE, REG_VIDEO_STD, 0x00},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
 	{TOK_SKIP, REG_AUTOSWITCH_MASK, 0x3F},
 	{TOK_WRITE, REG_COLOR_KILLER, 0x10},
@@ -135,53 +133,73 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
 	{TOK_WRITE, REG_HUE, 0x00},
 	{TOK_WRITE, REG_CHROMA_CONTROL1, 0x00},
 	{TOK_WRITE, REG_CHROMA_CONTROL2, 0x0E},
-	{TOK_SKIP, 0x0F, 0x00},	/* Reserved */
+	/* Reserved */
+	{TOK_SKIP, 0x0F, 0x00},
 	{TOK_WRITE, REG_COMP_PR_SATURATION, 0x80},
 	{TOK_WRITE, REG_COMP_Y_CONTRAST, 0x80},
 	{TOK_WRITE, REG_COMP_PB_SATURATION, 0x80},
-	{TOK_SKIP, 0x13, 0x00},	/* Reserved */
+	/* Reserved */
+	{TOK_SKIP, 0x13, 0x00},
 	{TOK_WRITE, REG_COMP_Y_BRIGHTNESS, 0x80},
-	{TOK_SKIP, 0x15, 0x00},	/* Reserved */
-	{TOK_SKIP, REG_AVID_START_PIXEL_LSB, 0x55},	/* NTSC timing */
+	/* Reserved */
+	{TOK_SKIP, 0x15, 0x00},
+	/* NTSC timing */
+	{TOK_SKIP, REG_AVID_START_PIXEL_LSB, 0x55},
 	{TOK_SKIP, REG_AVID_START_PIXEL_MSB, 0x00},
 	{TOK_SKIP, REG_AVID_STOP_PIXEL_LSB, 0x25},
 	{TOK_SKIP, REG_AVID_STOP_PIXEL_MSB, 0x03},
-	{TOK_SKIP, REG_HSYNC_START_PIXEL_LSB, 0x00},	/* NTSC timing */
+	/* NTSC timing */
+	{TOK_SKIP, REG_HSYNC_START_PIXEL_LSB, 0x00},
 	{TOK_SKIP, REG_HSYNC_START_PIXEL_MSB, 0x00},
 	{TOK_SKIP, REG_HSYNC_STOP_PIXEL_LSB, 0x40},
 	{TOK_SKIP, REG_HSYNC_STOP_PIXEL_MSB, 0x00},
-	{TOK_SKIP, REG_VSYNC_START_LINE_LSB, 0x04},	/* NTSC timing */
+	/* NTSC timing */
+	{TOK_SKIP, REG_VSYNC_START_LINE_LSB, 0x04},
 	{TOK_SKIP, REG_VSYNC_START_LINE_MSB, 0x00},
 	{TOK_SKIP, REG_VSYNC_STOP_LINE_LSB, 0x07},
 	{TOK_SKIP, REG_VSYNC_STOP_LINE_MSB, 0x00},
-	{TOK_SKIP, REG_VBLK_START_LINE_LSB, 0x01},	/* NTSC timing */
+	/* NTSC timing */
+	{TOK_SKIP, REG_VBLK_START_LINE_LSB, 0x01},
 	{TOK_SKIP, REG_VBLK_START_LINE_MSB, 0x00},
 	{TOK_SKIP, REG_VBLK_STOP_LINE_LSB, 0x15},
 	{TOK_SKIP, REG_VBLK_STOP_LINE_MSB, 0x00},
-	{TOK_SKIP, 0x26, 0x00},	/* Reserved */
-	{TOK_SKIP, 0x27, 0x00},	/* Reserved */
+	/* Reserved */
+	{TOK_SKIP, 0x26, 0x00},
+	/* Reserved */
+	{TOK_SKIP, 0x27, 0x00},
 	{TOK_SKIP, REG_FAST_SWTICH_CONTROL, 0xCC},
-	{TOK_SKIP, 0x29, 0x00},	/* Reserved */
+	/* Reserved */
+	{TOK_SKIP, 0x29, 0x00},
 	{TOK_SKIP, REG_FAST_SWTICH_SCART_DELAY, 0x00},
-	{TOK_SKIP, 0x2B, 0x00},	/* Reserved */
+	/* Reserved */
+	{TOK_SKIP, 0x2B, 0x00},
 	{TOK_SKIP, REG_SCART_DELAY, 0x00},
 	{TOK_SKIP, REG_CTI_DELAY, 0x00},
 	{TOK_SKIP, REG_CTI_CONTROL, 0x00},
-	{TOK_SKIP, 0x2F, 0x00},	/* Reserved */
-	{TOK_SKIP, 0x30, 0x00},	/* Reserved */
-	{TOK_SKIP, 0x31, 0x00},	/* Reserved */
-	{TOK_WRITE, REG_SYNC_CONTROL, 0x00},	/* HS, VS active high */
-	{TOK_WRITE, REG_OUTPUT_FORMATTER1, 0x00},	/* 10-bit BT.656 */
-	{TOK_WRITE, REG_OUTPUT_FORMATTER2, 0x11},	/* Enable clk & data */
-	{TOK_WRITE, REG_OUTPUT_FORMATTER3, 0xEE},	/* Enable AVID & FLD */
-	{TOK_WRITE, REG_OUTPUT_FORMATTER4, 0xAF},	/* Enable VS & HS */
+	/* Reserved */
+	{TOK_SKIP, 0x2F, 0x00},
+	/* Reserved */
+	{TOK_SKIP, 0x30, 0x00},
+	/* Reserved */
+	{TOK_SKIP, 0x31, 0x00},
+	/* HS, VS active high */
+	{TOK_WRITE, REG_SYNC_CONTROL, 0x00},
+	/* 10-bit BT.656 */
+	{TOK_WRITE, REG_OUTPUT_FORMATTER1, 0x00},
+	/* Enable clk & data */
+	{TOK_WRITE, REG_OUTPUT_FORMATTER2, 0x11},
+	/* Enable AVID & FLD */
+	{TOK_WRITE, REG_OUTPUT_FORMATTER3, 0xEE},
+	/* Enable VS & HS */
+	{TOK_WRITE, REG_OUTPUT_FORMATTER4, 0xAF},
 	{TOK_WRITE, REG_OUTPUT_FORMATTER5, 0xFF},
 	{TOK_WRITE, REG_OUTPUT_FORMATTER6, 0xFF},
-	{TOK_WRITE, REG_CLEAR_LOST_LOCK, 0x01},	/* Clear status */
+	/* Clear status */
+	{TOK_WRITE, REG_CLEAR_LOST_LOCK, 0x01},
 	{TOK_TERM, 0, 0},
 };
 
-/*
+/**
  * List of image formats supported by TVP5146/47 decoder
  * Currently we are using 8 bit mode only, but can be
  * extended to 10/20 bit mode.
@@ -196,7 +214,7 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
 	},
 };
 
-/*
+/**
  * Supported standards -
  *
  * Currently supports two standards only, need to add support for rest of the
@@ -239,8 +257,11 @@ static inline struct tvp514x_decoder *to_decoder(struct v4l2_subdev *sd)
 }
 
 
-/*
- * Read a value from a register in an TVP5146/47 decoder device.
+/**
+ * tvp514x_read_reg() - Read a value from a register in an TVP5146/47.
+ * @sd: ptr to v4l2_subdev struct
+ * @reg: TVP5146/47 register address	 
+ *
  * Returns value read if successful, or non-zero (-1) otherwise.
  */
 static int tvp514x_read_reg(struct v4l2_subdev *sd, u8 reg)
@@ -263,6 +284,11 @@ read_again:
 	return err;
 }
 
+/**
+ * dump_reg() - dump the register content of TVP5146/47.
+ * @sd: ptr to v4l2_subdev struct
+ * @reg: TVP5146/47 register address	 
+ */
 static inline void dump_reg(struct v4l2_subdev *sd, u8 reg)
 {
 	u32 val;
@@ -271,7 +297,12 @@ static inline void dump_reg(struct v4l2_subdev *sd, u8 reg)
 	v4l2_info(sd, "Reg(0x%.2X): 0x%.2X\n", reg, val);
 }
 
-/*
+/**
+ * tvp514x_write_reg() - Write a value to a register in TVP5146/47
+ * @sd: ptr to v4l2_subdev struct
+ * @reg: TVP5146/47 register address
+ * @val: value to be written to the register
+ *
  * Write a value to a register in an TVP5146/47 decoder device.
  * Returns zero if successful, or non-zero otherwise.
  */
@@ -295,14 +326,16 @@ write_again:
 	return err;
 }
 
-/*
- * tvp514x_write_regs : Initializes a list of TVP5146/47 registers
+/**
+ * tvp514x_write_regs() : Initializes a list of TVP5146/47 registers
+ * @sd: ptr to v4l2_subdev struct
+ * @reglist: list of TVP5146/47 registers and values
+ *
+ * Initializes a list of TVP5146/47 registers:-
  *		if token is TOK_TERM, then entire write operation terminates
  *		if token is TOK_DELAY, then a delay of 'val' msec is introduced
  *		if token is TOK_SKIP, then the register write is skipped
  *		if token is TOK_WRITE, then the register write is performed
- *
- * reglist - list of registers to be written
  * Returns zero if successful, or non-zero otherwise.
  */
 static int tvp514x_write_regs(struct v4l2_subdev *sd,
@@ -329,9 +362,12 @@ static int tvp514x_write_regs(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/*
- * tvp514x_get_current_std:
- * Returns the current standard detected by TVP5146/47
+/**
+ * tvp514x_get_current_std() : Get the current standard detected by TVP5146/47
+ * @sd: ptr to v4l2_subdev struct
+ * 
+ * Get current standard detected by TVP5146/47, STD_INVALID if there is no 
+ * standard detected. 
  */
 static enum tvp514x_std tvp514x_get_current_std(struct v4l2_subdev *sd)
 {
@@ -342,7 +378,8 @@ static enum tvp514x_std tvp514x_get_current_std(struct v4l2_subdev *sd)
 		/* use the standard status register */
 		std_status = tvp514x_read_reg(sd, REG_VIDEO_STD_STATUS);
 	else
-		std_status = std;	/* use the standard register itself */
+		/* use the standard register itself */
+		std_status = std;
 
 	switch (std_status & VIDEO_STD_MASK) {
 	case VIDEO_STD_NTSC_MJ_BIT:
@@ -358,9 +395,7 @@ static enum tvp514x_std tvp514x_get_current_std(struct v4l2_subdev *sd)
 	return STD_INVALID;
 }
 
-/*
- * TVP5146/47 register dump function
- */
+/* TVP5146/47 register dump function */
 static void tvp514x_reg_dump(struct v4l2_subdev *sd)
 {
 	dump_reg(sd, REG_INPUT_SEL);
@@ -407,8 +442,11 @@ static void tvp514x_reg_dump(struct v4l2_subdev *sd)
 	dump_reg(sd, REG_CLEAR_LOST_LOCK);
 }
 
-/*
- * Configure the TVP5146/47 with the current register settings
+/**
+ * tvp514x_configure() - Configure the TVP5146/47 registers 
+ * @sd: ptr to v4l2_subdev struct
+ * @decoder: ptr to tvp514x_decoder structure
+ *
  * Returns zero if successful, or non-zero otherwise.
  */
 static int tvp514x_configure(struct v4l2_subdev *sd,
@@ -428,8 +466,11 @@ static int tvp514x_configure(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/*
- * Detect if an tvp514x is present, and if so which revision.
+/**
+ * tvp514x_detect() - Detect if an tvp514x is present, and if so which revision.
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @decoder: pointer to tvp514x_decoder structure
+ *
  * A device is considered to be detected if the chip ID (LSB and MSB)
  * registers match the expected values.
  * Any value of the rom version register is accepted.
@@ -468,13 +509,8 @@ static int tvp514x_detect(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/*
- * Following are decoder interface functions implemented by
- * TVP5146/47 decoder driver.
- */
-
-/*
- * tvp514x_querystd - V4L2 decoder interface handler for VIDIOC_QUERYSTD ioctl
+/**
+ * tvp514x_querystd() - V4L2 decoder interface handler for querystd
  * @sd: pointer to standard V4L2 sub-device structure
  * @std_id: standard V4L2 std_id ioctl enum
  *
@@ -546,8 +582,8 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	return 0;
 }
 
-/*
- * tvp514x_s_std - V4L2 decoder interface handler for VIDIOC_S_STD ioctl
+/**
+ * tvp514x_s_std() - V4L2 decoder interface handler for s_std
  * @sd: pointer to standard V4L2 sub-device structure
  * @std_id: standard V4L2 v4l2_std_id ioctl enum
  *
@@ -580,10 +616,12 @@ static int tvp514x_s_std(struct v4l2_subdev *sd, v4l2_std_id std_id)
 	return 0;
 }
 
-/*
- * tvp514x_s_routing - V4L2 decoder interface handler for VIDIOC_S_INPUT ioctl
+/**
+ * tvp514x_s_routing() - V4L2 decoder interface handler for s_routing
  * @sd: pointer to standard V4L2 sub-device structure
- * @index: number of the input
+ * @input: input selector for routing the signal
+ * @output: output selector for routing the signal
+ * @config: config value. Not used
  *
  * If index is valid, selects the requested input. Otherwise, returns -EINVAL if
  * the input is not supported or there is no active signal present in the
@@ -602,7 +640,8 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 
 	if ((input >= INPUT_INVALID) ||
 			(output >= OUTPUT_INVALID))
-		return -EINVAL;	/* Index out of bound */
+		/* Index out of bound */
+		return -EINVAL;
 
 	input_sel = input;
 	output_sel = output;
@@ -659,7 +698,7 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 		lock_mask = STATUS_HORZ_SYNC_LOCK_BIT |
 			STATUS_VIRT_SYNC_LOCK_BIT;
 		break;
-	/*Need to add other interfaces*/
+	/* Need to add other interfaces*/
 	default:
 		return -EINVAL;
 	}
@@ -676,7 +715,8 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 		sync_lock_status = tvp514x_read_reg(sd,
 				REG_STATUS1);
 		if (lock_mask == (sync_lock_status & lock_mask))
-			break;	/* Input detected */
+			/* Input detected */
+			break;
 	}
 
 	if ((current_std == STD_INVALID) || (try_count < 0))
@@ -692,8 +732,8 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/*
- * tvp514x_queryctrl - V4L2 decoder interface handler for VIDIOC_QUERYCTRL ioctl
+/**
+ * tvp514x_queryctrl() - V4L2 decoder interface handler for queryctrl
  * @sd: pointer to standard V4L2 sub-device structure
  * @qctrl: standard V4L2 v4l2_queryctrl structure
  *
@@ -710,13 +750,13 @@ tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
 
 	switch (qctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		/* Brightness supported is (0-255),
-		 */
+		/* Brightness supported is (0-255), */
 		err = v4l2_ctrl_query_fill(qctrl, 0, 255, 1, 128);
 		break;
 	case V4L2_CID_CONTRAST:
 	case V4L2_CID_SATURATION:
-		/* Saturation and Contrast supported is -
+		/**
+		 * Saturation and Contrast supported is -
 		 *	Contrast: 0 - 255 (Default - 128)
 		 *	Saturation: 0 - 255 (Default - 128)
 		 */
@@ -729,7 +769,7 @@ tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
 		err = v4l2_ctrl_query_fill(qctrl, -180, 180, 180, 0);
 		break;
 	case V4L2_CID_AUTOGAIN:
-		/*
+		/**
 		 * Auto Gain supported is -
 		 * 	0 - 1 (Default - 1)
 		 */
@@ -747,8 +787,8 @@ tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
 	return err;
 }
 
-/*
- * tvp514x_g_ctrl - V4L2 decoder interface handler for VIDIOC_G_CTRL ioctl
+/**
+ * tvp514x_g_ctrl() - V4L2 decoder interface handler for g_ctrl
  * @sd: pointer to standard V4L2 sub-device structure
  * @ctrl: pointer to v4l2_control structure
  *
@@ -802,8 +842,8 @@ tvp514x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-/*
- * tvp514x_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL ioctl
+/**
+ * tvp514x_s_ctrl() - V4L2 decoder interface handler for s_ctrl
  * @sd: pointer to standard V4L2 sub-device structure
  * @ctrl: pointer to v4l2_control structure
  *
@@ -903,8 +943,8 @@ tvp514x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return err;
 }
 
-/*
- * tvp514x_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
+/**
+ * tvp514x_enum_fmt_cap() - V4L2 decoder interface handler for enum_fmt
  * @sd: pointer to standard V4L2 sub-device structure
  * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
  *
@@ -921,10 +961,12 @@ tvp514x_enum_fmt_cap(struct v4l2_subdev *sd, struct v4l2_fmtdesc *fmt)
 
 	index = fmt->index;
 	if ((index >= decoder->num_fmts) || (index < 0))
-		return -EINVAL;	/* Index out of bound */
+		/* Index out of bound */
+		return -EINVAL;
 
 	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;	/* only capture is supported */
+		/* only capture is supported */
+		return -EINVAL;
 
 	memcpy(fmt, &decoder->fmt_list[index],
 		sizeof(struct v4l2_fmtdesc));
@@ -935,8 +977,8 @@ tvp514x_enum_fmt_cap(struct v4l2_subdev *sd, struct v4l2_fmtdesc *fmt)
 	return 0;
 }
 
-/*
- * tvp514x_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
+/**
+ * tvp514x_try_fmt_cap() - V4L2 decoder interface handler for try_fmt 
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
  *
@@ -956,6 +998,7 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 		return -EINVAL;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
 		f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	pix = &f->fmt.pix;
@@ -975,7 +1018,8 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 			break;
 	}
 	if (ifmt == decoder->num_fmts)
-		ifmt = 0;	/* None of the format matched, select default */
+		/* None of the format matched, select default */
+		ifmt = 0;
 	pix->pixelformat = decoder->fmt_list[ifmt].pixelformat;
 
 	pix->field = V4L2_FIELD_INTERLACED;
@@ -991,8 +1035,8 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	return 0;
 }
 
-/*
- * tvp514x_s_fmt_cap - V4L2 decoder interface handler for VIDIOC_S_FMT ioctl
+/**
+ * tvp514x_s_fmt_cap() - V4L2 decoder interface handler for s_fmt
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
  *
@@ -1011,7 +1055,8 @@ tvp514x_s_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 		return -EINVAL;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;	/* only capture is supported */
+		/* only capture is supported */
+		return -EINVAL;
 
 	pix = &f->fmt.pix;
 	rval = tvp514x_try_fmt_cap(sd, f);
@@ -1023,8 +1068,8 @@ tvp514x_s_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	return rval;
 }
 
-/*
- * tvp514x_g_fmt_cap - V4L2 decoder interface handler for tvp514x_g_fmt_cap
+/**
+ * tvp514x_g_fmt_cap() - V4L2 decoder interface handler for tvp514x_g_fmt_cap
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 v4l2_format structure
  *
@@ -1040,7 +1085,8 @@ tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 		return -EINVAL;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;	/* only capture is supported */
+		/* only capture is supported */
+		return -EINVAL;
 
 	f->fmt.pix = decoder->pix;
 
@@ -1051,8 +1097,8 @@ tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	return 0;
 }
 
-/*
- * tvp514x_g_parm - V4L2 decoder interface handler for VIDIOC_G_PARM ioctl
+/**
+ * tvp514x_g_parm() - V4L2 decoder interface handler for g_parm
  * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
  *
@@ -1069,7 +1115,8 @@ tvp514x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 		return -EINVAL;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;	/* only capture is supported */
+		/* only capture is supported */
+		return -EINVAL;
 
 	memset(a, 0, sizeof(*a));
 	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1089,8 +1136,8 @@ tvp514x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 	return 0;
 }
 
-/*
- * tvp514x_s_parm - V4L2 decoder interface handler for VIDIOC_S_PARM ioctl
+/**
+ * tvp514x_s_parm() - V4L2 decoder interface handler for s_parm
  * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
  *
@@ -1108,7 +1155,8 @@ tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 		return -EINVAL;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;	/* only capture is supported */
+		/* only capture is supported */
+		return -EINVAL;
 
 	timeperframe = &a->parm.capture.timeperframe;
 
@@ -1125,8 +1173,8 @@ tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 	return 0;
 }
 
-/*
- * tvp514x_s_stream - V4L2 decoder interface handler for vidioc_int_s_power_num
+/**
+ * tvp514x_s_stream() - V4L2 decoder i/f handler for s_stream  
  * @sd: pointer to standard V4L2 sub-device structure
  * @enable: streaming enable or disable
  *
@@ -1216,7 +1264,8 @@ static struct tvp514x_decoder tvp514x_dev = {
 	.fmt_list = tvp514x_fmt_list,
 	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
 
-	.pix = {/* Default to NTSC 8-bit YUV 422 */
+	.pix = {
+		/* Default to NTSC 8-bit YUV 422 */
 		.width = NTSC_NUM_ACTIVE_PIXELS,
 		.height = NTSC_NUM_ACTIVE_LINES,
 		.pixelformat = V4L2_PIX_FMT_UYVY,
@@ -1233,8 +1282,8 @@ static struct tvp514x_decoder tvp514x_dev = {
 
 };
 
-/*
- * tvp514x_probe - decoder driver i2c probe handler
+/**
+ * tvp514x_probe() - decoder driver i2c probe handler
  * @client: i2c driver client device structure
  * @id: i2c driver id table
  *
@@ -1260,20 +1309,16 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!decoder)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the tvp514x_decoder with default configuration
-	 */
+	/* Initialize the tvp514x_decoder with default configuration */
 	*decoder = tvp514x_dev;
 	/* Copy default register configuration */
 	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
 			sizeof(tvp514x_reg_list_default));
 
-	/*
-	 * Copy board specific information here
-	 */
+	/* Copy board specific information here */
 	decoder->pdata = client->dev.platform_data;
 
-	/*
+	/**
 	 * Fetch platform specific data, and configure the
 	 * tvp514x_reg_list[] accordingly. Since this is one
 	 * time configuration, no need to preserve.
@@ -1297,8 +1342,8 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 }
 
-/*
- * tvp514x_remove - decoder driver i2c remove handler
+/**
+ * tvp514x_remove() - decoder driver i2c remove handler
  * @client: i2c driver client device structure
  *
  * Unregister decoder as an i2c client device and V4L2
@@ -1313,9 +1358,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	kfree(decoder);
 	return 0;
 }
-/*
- * TVP5146 Init/Power on Sequence
- */
+/* TVP5146 Init/Power on Sequence */
 static const struct tvp514x_reg tvp5146_init_reg_seq[] = {
 	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x02},
 	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
@@ -1331,9 +1374,7 @@ static const struct tvp514x_reg tvp5146_init_reg_seq[] = {
 	{TOK_TERM, 0, 0},
 };
 
-/*
- * TVP5147 Init/Power on Sequence
- */
+/* TVP5147 Init/Power on Sequence */
 static const struct tvp514x_reg tvp5147_init_reg_seq[] =	{
 	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x02},
 	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
@@ -1356,16 +1397,14 @@ static const struct tvp514x_reg tvp5147_init_reg_seq[] =	{
 	{TOK_TERM, 0, 0},
 };
 
-/*
- * TVP5146M2/TVP5147M1 Init/Power on Sequence
- */
+/* TVP5146M2/TVP5147M1 Init/Power on Sequence */
 static const struct tvp514x_reg tvp514xm_init_reg_seq[] = {
 	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
 	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
 	{TOK_TERM, 0, 0},
 };
 
-/*
+/**
  * I2C Device Table -
  *
  * name - Name of the actual device/chip.
-- 
1.6.0.4

