Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753874AbcKPQnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 32/35] [media] tvp5150: Get rid of direct calls to printk()
Date: Wed, 16 Nov 2016 14:43:04 -0200
Message-Id: <3a4777867f0781fc7f8632483972ed28084cfd62.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

When returning results via v4l2_subdev_core_ops.log_status,
use dev_foo() call, instead of just calling printk()
directly, without even specifying the log message level.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvp5150.c | 218 ++++++++++++++++++++++----------------------
 1 file changed, 110 insertions(+), 108 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 569eb7c0968a..d0dbdd7ea233 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -36,6 +36,8 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
+#define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
+
 struct tvp5150 {
 	struct v4l2_subdev sd;
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -118,120 +120,120 @@ static void dump_reg_range(struct v4l2_subdev *sd, char *s, u8 init,
 
 static int tvp5150_log_status(struct v4l2_subdev *sd)
 {
-	printk("tvp5150: Video input source selection #1 = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_VD_IN_SRC_SEL_1));
-	printk("tvp5150: Analog channel controls = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_ANAL_CHL_CTL));
-	printk("tvp5150: Operation mode controls = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_OP_MODE_CTL));
-	printk("tvp5150: Miscellaneous controls = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_MISC_CTL));
-	printk("tvp5150: Autoswitch mask= 0x%02x\n",
-			tvp5150_read(sd, TVP5150_AUTOSW_MSK));
-	printk("tvp5150: Color killer threshold control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_COLOR_KIL_THSH_CTL));
-	printk("tvp5150: Luminance processing controls #1 #2 and #3 = %02x %02x %02x\n",
-			tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_1),
-			tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_2),
-			tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_3));
-	printk("tvp5150: Brightness control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_BRIGHT_CTL));
-	printk("tvp5150: Color saturation control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_SATURATION_CTL));
-	printk("tvp5150: Hue control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_HUE_CTL));
-	printk("tvp5150: Contrast control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_CONTRAST_CTL));
-	printk("tvp5150: Outputs and data rates select = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_DATA_RATE_SEL));
-	printk("tvp5150: Configuration shared pins = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_CONF_SHARED_PIN));
-	printk("tvp5150: Active video cropping start = 0x%02x%02x\n",
-			tvp5150_read(sd, TVP5150_ACT_VD_CROP_ST_MSB),
-			tvp5150_read(sd, TVP5150_ACT_VD_CROP_ST_LSB));
-	printk("tvp5150: Active video cropping stop  = 0x%02x%02x\n",
-			tvp5150_read(sd, TVP5150_ACT_VD_CROP_STP_MSB),
-			tvp5150_read(sd, TVP5150_ACT_VD_CROP_STP_LSB));
-	printk("tvp5150: Genlock/RTC = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_GENLOCK));
-	printk("tvp5150: Horizontal sync start = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_HORIZ_SYNC_START));
-	printk("tvp5150: Vertical blanking start = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_VERT_BLANKING_START));
-	printk("tvp5150: Vertical blanking stop = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_VERT_BLANKING_STOP));
-	printk("tvp5150: Chrominance processing control #1 and #2 = %02x %02x\n",
-			tvp5150_read(sd, TVP5150_CHROMA_PROC_CTL_1),
-			tvp5150_read(sd, TVP5150_CHROMA_PROC_CTL_2));
-	printk("tvp5150: Interrupt reset register B = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_RESET_REG_B));
-	printk("tvp5150: Interrupt enable register B = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_ENABLE_REG_B));
-	printk("tvp5150: Interrupt configuration register B = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INTT_CONFIG_REG_B));
-	printk("tvp5150: Video standard = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_VIDEO_STD));
-	printk("tvp5150: Chroma gain factor: Cb=0x%02x Cr=0x%02x\n",
-			tvp5150_read(sd, TVP5150_CB_GAIN_FACT),
-			tvp5150_read(sd, TVP5150_CR_GAIN_FACTOR));
-	printk("tvp5150: Macrovision on counter = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_MACROVISION_ON_CTR));
-	printk("tvp5150: Macrovision off counter = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_MACROVISION_OFF_CTR));
-	printk("tvp5150: ITU-R BT.656.%d timing(TVP5150AM1 only)\n",
-			(tvp5150_read(sd, TVP5150_REV_SELECT) & 1) ? 3 : 4);
-	printk("tvp5150: Device ID = %02x%02x\n",
-			tvp5150_read(sd, TVP5150_MSB_DEV_ID),
-			tvp5150_read(sd, TVP5150_LSB_DEV_ID));
-	printk("tvp5150: ROM version = (hex) %02x.%02x\n",
-			tvp5150_read(sd, TVP5150_ROM_MAJOR_VER),
-			tvp5150_read(sd, TVP5150_ROM_MINOR_VER));
-	printk("tvp5150: Vertical line count = 0x%02x%02x\n",
-			tvp5150_read(sd, TVP5150_VERT_LN_COUNT_MSB),
-			tvp5150_read(sd, TVP5150_VERT_LN_COUNT_LSB));
-	printk("tvp5150: Interrupt status register B = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_STATUS_REG_B));
-	printk("tvp5150: Interrupt active register B = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_ACTIVE_REG_B));
-	printk("tvp5150: Status regs #1 to #5 = %02x %02x %02x %02x %02x\n",
-			tvp5150_read(sd, TVP5150_STATUS_REG_1),
-			tvp5150_read(sd, TVP5150_STATUS_REG_2),
-			tvp5150_read(sd, TVP5150_STATUS_REG_3),
-			tvp5150_read(sd, TVP5150_STATUS_REG_4),
-			tvp5150_read(sd, TVP5150_STATUS_REG_5));
+	dprintk0(sd->dev, "tvp5150: Video input source selection #1 = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_VD_IN_SRC_SEL_1));
+	dprintk0(sd->dev, "tvp5150: Analog channel controls = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_ANAL_CHL_CTL));
+	dprintk0(sd->dev, "tvp5150: Operation mode controls = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_OP_MODE_CTL));
+	dprintk0(sd->dev, "tvp5150: Miscellaneous controls = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_MISC_CTL));
+	dprintk0(sd->dev, "tvp5150: Autoswitch mask= 0x%02x\n",
+		tvp5150_read(sd, TVP5150_AUTOSW_MSK));
+	dprintk0(sd->dev, "tvp5150: Color killer threshold control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_COLOR_KIL_THSH_CTL));
+	dprintk0(sd->dev, "tvp5150: Luminance processing controls #1 #2 and #3 = %02x %02x %02x\n",
+		tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_1),
+		tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_2),
+		tvp5150_read(sd, TVP5150_LUMA_PROC_CTL_3));
+	dprintk0(sd->dev, "tvp5150: Brightness control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_BRIGHT_CTL));
+	dprintk0(sd->dev, "tvp5150: Color saturation control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_SATURATION_CTL));
+	dprintk0(sd->dev, "tvp5150: Hue control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_HUE_CTL));
+	dprintk0(sd->dev, "tvp5150: Contrast control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_CONTRAST_CTL));
+	dprintk0(sd->dev, "tvp5150: Outputs and data rates select = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_DATA_RATE_SEL));
+	dprintk0(sd->dev, "tvp5150: Configuration shared pins = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_CONF_SHARED_PIN));
+	dprintk0(sd->dev, "tvp5150: Active video cropping start = 0x%02x%02x\n",
+		tvp5150_read(sd, TVP5150_ACT_VD_CROP_ST_MSB),
+		tvp5150_read(sd, TVP5150_ACT_VD_CROP_ST_LSB));
+	dprintk0(sd->dev, "tvp5150: Active video cropping stop  = 0x%02x%02x\n",
+		tvp5150_read(sd, TVP5150_ACT_VD_CROP_STP_MSB),
+		tvp5150_read(sd, TVP5150_ACT_VD_CROP_STP_LSB));
+	dprintk0(sd->dev, "tvp5150: Genlock/RTC = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_GENLOCK));
+	dprintk0(sd->dev, "tvp5150: Horizontal sync start = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_HORIZ_SYNC_START));
+	dprintk0(sd->dev, "tvp5150: Vertical blanking start = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_VERT_BLANKING_START));
+	dprintk0(sd->dev, "tvp5150: Vertical blanking stop = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_VERT_BLANKING_STOP));
+	dprintk0(sd->dev, "tvp5150: Chrominance processing control #1 and #2 = %02x %02x\n",
+		tvp5150_read(sd, TVP5150_CHROMA_PROC_CTL_1),
+		tvp5150_read(sd, TVP5150_CHROMA_PROC_CTL_2));
+	dprintk0(sd->dev, "tvp5150: Interrupt reset register B = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_RESET_REG_B));
+	dprintk0(sd->dev, "tvp5150: Interrupt enable register B = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_ENABLE_REG_B));
+	dprintk0(sd->dev, "tvp5150: Interrupt configuration register B = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INTT_CONFIG_REG_B));
+	dprintk0(sd->dev, "tvp5150: Video standard = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_VIDEO_STD));
+	dprintk0(sd->dev, "tvp5150: Chroma gain factor: Cb=0x%02x Cr=0x%02x\n",
+		tvp5150_read(sd, TVP5150_CB_GAIN_FACT),
+		tvp5150_read(sd, TVP5150_CR_GAIN_FACTOR));
+	dprintk0(sd->dev, "tvp5150: Macrovision on counter = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_MACROVISION_ON_CTR));
+	dprintk0(sd->dev, "tvp5150: Macrovision off counter = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_MACROVISION_OFF_CTR));
+	dprintk0(sd->dev, "tvp5150: ITU-R BT.656.%d timing(TVP5150AM1 only)\n",
+		(tvp5150_read(sd, TVP5150_REV_SELECT) & 1) ? 3 : 4);
+	dprintk0(sd->dev, "tvp5150: Device ID = %02x%02x\n",
+		tvp5150_read(sd, TVP5150_MSB_DEV_ID),
+		tvp5150_read(sd, TVP5150_LSB_DEV_ID));
+	dprintk0(sd->dev, "tvp5150: ROM version = (hex) %02x.%02x\n",
+		tvp5150_read(sd, TVP5150_ROM_MAJOR_VER),
+		tvp5150_read(sd, TVP5150_ROM_MINOR_VER));
+	dprintk0(sd->dev, "tvp5150: Vertical line count = 0x%02x%02x\n",
+		tvp5150_read(sd, TVP5150_VERT_LN_COUNT_MSB),
+		tvp5150_read(sd, TVP5150_VERT_LN_COUNT_LSB));
+	dprintk0(sd->dev, "tvp5150: Interrupt status register B = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_STATUS_REG_B));
+	dprintk0(sd->dev, "tvp5150: Interrupt active register B = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_ACTIVE_REG_B));
+	dprintk0(sd->dev, "tvp5150: Status regs #1 to #5 = %02x %02x %02x %02x %02x\n",
+		tvp5150_read(sd, TVP5150_STATUS_REG_1),
+		tvp5150_read(sd, TVP5150_STATUS_REG_2),
+		tvp5150_read(sd, TVP5150_STATUS_REG_3),
+		tvp5150_read(sd, TVP5150_STATUS_REG_4),
+		tvp5150_read(sd, TVP5150_STATUS_REG_5));
 
 	dump_reg_range(sd, "Teletext filter 1",   TVP5150_TELETEXT_FIL1_INI,
 			TVP5150_TELETEXT_FIL1_END, 8);
 	dump_reg_range(sd, "Teletext filter 2",   TVP5150_TELETEXT_FIL2_INI,
 			TVP5150_TELETEXT_FIL2_END, 8);
 
-	printk("tvp5150: Teletext filter enable = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_TELETEXT_FIL_ENA));
-	printk("tvp5150: Interrupt status register A = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_STATUS_REG_A));
-	printk("tvp5150: Interrupt enable register A = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_ENABLE_REG_A));
-	printk("tvp5150: Interrupt configuration = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_INT_CONF));
-	printk("tvp5150: VDP status register = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_VDP_STATUS_REG));
-	printk("tvp5150: FIFO word count = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FIFO_WORD_COUNT));
-	printk("tvp5150: FIFO interrupt threshold = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FIFO_INT_THRESHOLD));
-	printk("tvp5150: FIFO reset = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FIFO_RESET));
-	printk("tvp5150: Line number interrupt = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_LINE_NUMBER_INT));
-	printk("tvp5150: Pixel alignment register = 0x%02x%02x\n",
-			tvp5150_read(sd, TVP5150_PIX_ALIGN_REG_HIGH),
-			tvp5150_read(sd, TVP5150_PIX_ALIGN_REG_LOW));
-	printk("tvp5150: FIFO output control = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FIFO_OUT_CTRL));
-	printk("tvp5150: Full field enable = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FULL_FIELD_ENA));
-	printk("tvp5150: Full field mode register = 0x%02x\n",
-			tvp5150_read(sd, TVP5150_FULL_FIELD_MODE_REG));
+	dprintk0(sd->dev, "tvp5150: Teletext filter enable = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_TELETEXT_FIL_ENA));
+	dprintk0(sd->dev, "tvp5150: Interrupt status register A = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_STATUS_REG_A));
+	dprintk0(sd->dev, "tvp5150: Interrupt enable register A = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_ENABLE_REG_A));
+	dprintk0(sd->dev, "tvp5150: Interrupt configuration = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_INT_CONF));
+	dprintk0(sd->dev, "tvp5150: VDP status register = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_VDP_STATUS_REG));
+	dprintk0(sd->dev, "tvp5150: FIFO word count = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FIFO_WORD_COUNT));
+	dprintk0(sd->dev, "tvp5150: FIFO interrupt threshold = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FIFO_INT_THRESHOLD));
+	dprintk0(sd->dev, "tvp5150: FIFO reset = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FIFO_RESET));
+	dprintk0(sd->dev, "tvp5150: Line number interrupt = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_LINE_NUMBER_INT));
+	dprintk0(sd->dev, "tvp5150: Pixel alignment register = 0x%02x%02x\n",
+		tvp5150_read(sd, TVP5150_PIX_ALIGN_REG_HIGH),
+		tvp5150_read(sd, TVP5150_PIX_ALIGN_REG_LOW));
+	dprintk0(sd->dev, "tvp5150: FIFO output control = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FIFO_OUT_CTRL));
+	dprintk0(sd->dev, "tvp5150: Full field enable = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FULL_FIELD_ENA));
+	dprintk0(sd->dev, "tvp5150: Full field mode register = 0x%02x\n",
+		tvp5150_read(sd, TVP5150_FULL_FIELD_MODE_REG));
 
 	dump_reg_range(sd, "CC   data",   TVP5150_CC_DATA_INI,
 			TVP5150_CC_DATA_END, 8);
-- 
2.7.4


