Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35600 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932400AbeDBUAd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 16:00:33 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
To: mchehab@kernel.org
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: i2c: tvp5150: Add a space after commas
Date: Tue,  3 Apr 2018 00:29:03 +0430
Message-Id: <20180402195907.14368-2-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
References: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves checkpatch.pl errors:
    ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 134 ++++++++++++++++++++++----------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 2476d812f669..af56a5a6db65 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -319,136 +319,136 @@ struct i2c_reg_value {
 /* Default values as sugested at TVP5150AM1 datasheet */
 static const struct i2c_reg_value tvp5150_init_default[] = {
 	{ /* 0x00 */
-		TVP5150_VD_IN_SRC_SEL_1,0x00
+		TVP5150_VD_IN_SRC_SEL_1, 0x00
 	},
 	{ /* 0x01 */
-		TVP5150_ANAL_CHL_CTL,0x15
+		TVP5150_ANAL_CHL_CTL, 0x15
 	},
 	{ /* 0x02 */
-		TVP5150_OP_MODE_CTL,0x00
+		TVP5150_OP_MODE_CTL, 0x00
 	},
 	{ /* 0x03 */
-		TVP5150_MISC_CTL,0x01
+		TVP5150_MISC_CTL, 0x01
 	},
 	{ /* 0x06 */
-		TVP5150_COLOR_KIL_THSH_CTL,0x10
+		TVP5150_COLOR_KIL_THSH_CTL, 0x10
 	},
 	{ /* 0x07 */
-		TVP5150_LUMA_PROC_CTL_1,0x60
+		TVP5150_LUMA_PROC_CTL_1, 0x60
 	},
 	{ /* 0x08 */
-		TVP5150_LUMA_PROC_CTL_2,0x00
+		TVP5150_LUMA_PROC_CTL_2, 0x00
 	},
 	{ /* 0x09 */
-		TVP5150_BRIGHT_CTL,0x80
+		TVP5150_BRIGHT_CTL, 0x80
 	},
 	{ /* 0x0a */
-		TVP5150_SATURATION_CTL,0x80
+		TVP5150_SATURATION_CTL, 0x80
 	},
 	{ /* 0x0b */
-		TVP5150_HUE_CTL,0x00
+		TVP5150_HUE_CTL, 0x00
 	},
 	{ /* 0x0c */
-		TVP5150_CONTRAST_CTL,0x80
+		TVP5150_CONTRAST_CTL, 0x80
 	},
 	{ /* 0x0d */
-		TVP5150_DATA_RATE_SEL,0x47
+		TVP5150_DATA_RATE_SEL, 0x47
 	},
 	{ /* 0x0e */
-		TVP5150_LUMA_PROC_CTL_3,0x00
+		TVP5150_LUMA_PROC_CTL_3, 0x00
 	},
 	{ /* 0x0f */
-		TVP5150_CONF_SHARED_PIN,0x08
+		TVP5150_CONF_SHARED_PIN, 0x08
 	},
 	{ /* 0x11 */
-		TVP5150_ACT_VD_CROP_ST_MSB,0x00
+		TVP5150_ACT_VD_CROP_ST_MSB, 0x00
 	},
 	{ /* 0x12 */
-		TVP5150_ACT_VD_CROP_ST_LSB,0x00
+		TVP5150_ACT_VD_CROP_ST_LSB, 0x00
 	},
 	{ /* 0x13 */
-		TVP5150_ACT_VD_CROP_STP_MSB,0x00
+		TVP5150_ACT_VD_CROP_STP_MSB, 0x00
 	},
 	{ /* 0x14 */
-		TVP5150_ACT_VD_CROP_STP_LSB,0x00
+		TVP5150_ACT_VD_CROP_STP_LSB, 0x00
 	},
 	{ /* 0x15 */
-		TVP5150_GENLOCK,0x01
+		TVP5150_GENLOCK, 0x01
 	},
 	{ /* 0x16 */
-		TVP5150_HORIZ_SYNC_START,0x80
+		TVP5150_HORIZ_SYNC_START, 0x80
 	},
 	{ /* 0x18 */
-		TVP5150_VERT_BLANKING_START,0x00
+		TVP5150_VERT_BLANKING_START, 0x00
 	},
 	{ /* 0x19 */
-		TVP5150_VERT_BLANKING_STOP,0x00
+		TVP5150_VERT_BLANKING_STOP, 0x00
 	},
 	{ /* 0x1a */
-		TVP5150_CHROMA_PROC_CTL_1,0x0c
+		TVP5150_CHROMA_PROC_CTL_1, 0x0c
 	},
 	{ /* 0x1b */
-		TVP5150_CHROMA_PROC_CTL_2,0x14
+		TVP5150_CHROMA_PROC_CTL_2, 0x14
 	},
 	{ /* 0x1c */
-		TVP5150_INT_RESET_REG_B,0x00
+		TVP5150_INT_RESET_REG_B, 0x00
 	},
 	{ /* 0x1d */
-		TVP5150_INT_ENABLE_REG_B,0x00
+		TVP5150_INT_ENABLE_REG_B, 0x00
 	},
 	{ /* 0x1e */
-		TVP5150_INTT_CONFIG_REG_B,0x00
+		TVP5150_INTT_CONFIG_REG_B, 0x00
 	},
 	{ /* 0x28 */
-		TVP5150_VIDEO_STD,0x00
+		TVP5150_VIDEO_STD, 0x00
 	},
 	{ /* 0x2e */
-		TVP5150_MACROVISION_ON_CTR,0x0f
+		TVP5150_MACROVISION_ON_CTR, 0x0f
 	},
 	{ /* 0x2f */
-		TVP5150_MACROVISION_OFF_CTR,0x01
+		TVP5150_MACROVISION_OFF_CTR, 0x01
 	},
 	{ /* 0xbb */
-		TVP5150_TELETEXT_FIL_ENA,0x00
+		TVP5150_TELETEXT_FIL_ENA, 0x00
 	},
 	{ /* 0xc0 */
-		TVP5150_INT_STATUS_REG_A,0x00
+		TVP5150_INT_STATUS_REG_A, 0x00
 	},
 	{ /* 0xc1 */
-		TVP5150_INT_ENABLE_REG_A,0x00
+		TVP5150_INT_ENABLE_REG_A, 0x00
 	},
 	{ /* 0xc2 */
-		TVP5150_INT_CONF,0x04
+		TVP5150_INT_CONF, 0x04
 	},
 	{ /* 0xc8 */
-		TVP5150_FIFO_INT_THRESHOLD,0x80
+		TVP5150_FIFO_INT_THRESHOLD, 0x80
 	},
 	{ /* 0xc9 */
-		TVP5150_FIFO_RESET,0x00
+		TVP5150_FIFO_RESET, 0x00
 	},
 	{ /* 0xca */
-		TVP5150_LINE_NUMBER_INT,0x00
+		TVP5150_LINE_NUMBER_INT, 0x00
 	},
 	{ /* 0xcb */
-		TVP5150_PIX_ALIGN_REG_LOW,0x4e
+		TVP5150_PIX_ALIGN_REG_LOW, 0x4e
 	},
 	{ /* 0xcc */
-		TVP5150_PIX_ALIGN_REG_HIGH,0x00
+		TVP5150_PIX_ALIGN_REG_HIGH, 0x00
 	},
 	{ /* 0xcd */
-		TVP5150_FIFO_OUT_CTRL,0x01
+		TVP5150_FIFO_OUT_CTRL, 0x01
 	},
 	{ /* 0xcf */
-		TVP5150_FULL_FIELD_ENA,0x00
+		TVP5150_FULL_FIELD_ENA, 0x00
 	},
 	{ /* 0xd0 */
-		TVP5150_LINE_MODE_INI,0x00
+		TVP5150_LINE_MODE_INI, 0x00
 	},
 	{ /* 0xfc */
-		TVP5150_FULL_FIELD_MODE_REG,0x7f
+		TVP5150_FULL_FIELD_MODE_REG, 0x7f
 	},
 	{ /* end of data */
-		0xff,0xff
+		0xff, 0xff
 	}
 };
 
@@ -456,27 +456,27 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 static const struct i2c_reg_value tvp5150_init_enable[] = {
 	{
 		TVP5150_CONF_SHARED_PIN, 2
-	},{	/* Automatic offset and AGC enabled */
+	}, {	/* Automatic offset and AGC enabled */
 		TVP5150_ANAL_CHL_CTL, 0x15
-	},{	/* Activate YCrCb output 0x9 or 0xd ? */
+	}, {	/* Activate YCrCb output 0x9 or 0xd ? */
 		TVP5150_MISC_CTL, TVP5150_MISC_CTL_GPCL |
 				  TVP5150_MISC_CTL_INTREQ_OE |
 				  TVP5150_MISC_CTL_YCBCR_OE |
 				  TVP5150_MISC_CTL_SYNC_OE |
 				  TVP5150_MISC_CTL_VBLANK |
 				  TVP5150_MISC_CTL_CLOCK_OE,
-	},{	/* Activates video std autodetection for all standards */
+	}, {	/* Activates video std autodetection for all standards */
 		TVP5150_AUTOSW_MSK, 0x0
-	},{	/* Default format: 0x47. For 4:2:2: 0x40 */
+	}, {	/* Default format: 0x47. For 4:2:2: 0x40 */
 		TVP5150_DATA_RATE_SEL, 0x47
-	},{
+	}, {
 		TVP5150_CHROMA_PROC_CTL_1, 0x0c
-	},{
+	}, {
 		TVP5150_CHROMA_PROC_CTL_2, 0x54
-	},{	/* Non documented, but initialized on WinTV USB2 */
+	}, {	/* Non documented, but initialized on WinTV USB2 */
 		0x27, 0x20
-	},{
-		0xff,0xff
+	}, {
+		0xff, 0xff
 	}
 };
 
@@ -506,72 +506,72 @@ static struct i2c_vbi_ram_value vbi_ram_default[] =
 	   yet supported are placed under #if 0 */
 #if 0
 	[0] = {0x010, /* Teletext, SECAM, WST System A */
-		{V4L2_SLICED_TELETEXT_SECAM,6,23,1},
+		{V4L2_SLICED_TELETEXT_SECAM, 6, 23, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0xe7, 0x2e, 0x20, 0x26,
 		  0xe6, 0xb4, 0x0e, 0x00, 0x00, 0x00, 0x10, 0x00 }
 	},
 #endif
 	[1] = {0x030, /* Teletext, PAL, WST System B */
-		{V4L2_SLICED_TELETEXT_B,6,22,1},
+		{V4L2_SLICED_TELETEXT_B, 6, 22, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0x27, 0x2e, 0x20, 0x2b,
 		  0xa6, 0x72, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00 }
 	},
 #if 0
 	[2] = {0x050, /* Teletext, PAL, WST System C */
-		{V4L2_SLICED_TELETEXT_PAL_C,6,22,1},
+		{V4L2_SLICED_TELETEXT_PAL_C, 6, 22, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0xe7, 0x2e, 0x20, 0x22,
 		  0xa6, 0x98, 0x0d, 0x00, 0x00, 0x00, 0x10, 0x00 }
 	},
 	[3] = {0x070, /* Teletext, NTSC, WST System B */
-		{V4L2_SLICED_TELETEXT_NTSC_B,10,21,1},
+		{V4L2_SLICED_TELETEXT_NTSC_B, 10, 21, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0x27, 0x2e, 0x20, 0x23,
 		  0x69, 0x93, 0x0d, 0x00, 0x00, 0x00, 0x10, 0x00 }
 	},
 	[4] = {0x090, /* Tetetext, NTSC NABTS System C */
-		{V4L2_SLICED_TELETEXT_NTSC_C,10,21,1},
+		{V4L2_SLICED_TELETEXT_NTSC_C, 10, 21, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0xe7, 0x2e, 0x20, 0x22,
 		  0x69, 0x93, 0x0d, 0x00, 0x00, 0x00, 0x15, 0x00 }
 	},
 	[5] = {0x0b0, /* Teletext, NTSC-J, NABTS System D */
-		{V4L2_SLICED_TELETEXT_NTSC_D,10,21,1},
+		{V4L2_SLICED_TELETEXT_NTSC_D, 10, 21, 1},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0xa7, 0x2e, 0x20, 0x23,
 		  0x69, 0x93, 0x0d, 0x00, 0x00, 0x00, 0x10, 0x00 }
 	},
 	[6] = {0x0d0, /* Closed Caption, PAL/SECAM */
-		{V4L2_SLICED_CAPTION_625,22,22,1},
+		{V4L2_SLICED_CAPTION_625, 22, 22, 1},
 		{ 0xaa, 0x2a, 0xff, 0x3f, 0x04, 0x51, 0x6e, 0x02,
 		  0xa6, 0x7b, 0x09, 0x00, 0x00, 0x00, 0x27, 0x00 }
 	},
 #endif
 	[7] = {0x0f0, /* Closed Caption, NTSC */
-		{V4L2_SLICED_CAPTION_525,21,21,1},
+		{V4L2_SLICED_CAPTION_525, 21, 21, 1},
 		{ 0xaa, 0x2a, 0xff, 0x3f, 0x04, 0x51, 0x6e, 0x02,
 		  0x69, 0x8c, 0x09, 0x00, 0x00, 0x00, 0x27, 0x00 }
 	},
 	[8] = {0x110, /* Wide Screen Signal, PAL/SECAM */
-		{V4L2_SLICED_WSS_625,23,23,1},
+		{V4L2_SLICED_WSS_625, 23, 23, 1},
 		{ 0x5b, 0x55, 0xc5, 0xff, 0x00, 0x71, 0x6e, 0x42,
 		  0xa6, 0xcd, 0x0f, 0x00, 0x00, 0x00, 0x3a, 0x00 }
 	},
 #if 0
 	[9] = {0x130, /* Wide Screen Signal, NTSC C */
-		{V4L2_SLICED_WSS_525,20,20,1},
+		{V4L2_SLICED_WSS_525, 20, 20, 1},
 		{ 0x38, 0x00, 0x3f, 0x00, 0x00, 0x71, 0x6e, 0x43,
 		  0x69, 0x7c, 0x08, 0x00, 0x00, 0x00, 0x39, 0x00 }
 	},
 	[10] = {0x150, /* Vertical Interval Timecode (VITC), PAL/SECAM */
-		{V4l2_SLICED_VITC_625,6,22,0},
+		{V4l2_SLICED_VITC_625, 6, 22, 0},
 		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x8f, 0x6d, 0x49,
 		  0xa6, 0x85, 0x08, 0x00, 0x00, 0x00, 0x4c, 0x00 }
 	},
 	[11] = {0x170, /* Vertical Interval Timecode (VITC), NTSC */
-		{V4l2_SLICED_VITC_525,10,20,0},
+		{V4l2_SLICED_VITC_525, 10, 20, 0},
 		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x8f, 0x6d, 0x49,
 		  0x69, 0x94, 0x08, 0x00, 0x00, 0x00, 0x4c, 0x00 }
 	},
 #endif
 	[12] = {0x190, /* Video Program System (VPS), PAL */
-		{V4L2_SLICED_VPS,16,16,0},
+		{V4L2_SLICED_VPS, 16, 16, 0},
 		{ 0xaa, 0xaa, 0xff, 0xff, 0xba, 0xce, 0x2b, 0x0d,
 		  0xa6, 0xda, 0x0b, 0x00, 0x00, 0x00, 0x60, 0x00 }
 	},
@@ -655,7 +655,7 @@ static int tvp5150_g_sliced_vbi_cap(struct v4l2_subdev *sd,
  *	MSB = field2
  */
 static int tvp5150_set_vbi(struct v4l2_subdev *sd,
-			unsigned int type,u8 flags, int line,
+			unsigned int type, u8 flags, int line,
 			const int fields)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-- 
2.15.0
