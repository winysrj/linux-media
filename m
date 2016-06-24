Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcFXPcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Erik Andren <erik.andren@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 06/19] m5602_mt9m111: move skeletons to the .c file
Date: Fri, 24 Jun 2016 12:31:47 -0300
Message-Id: <349e4dc59aa17d21ce23640fdd710c0997453fe9.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header file has some private static structures that
are used only by the C file. Move those structures to the C file,
in order to shut up gcc 6.1 warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c | 144 ++++++++++++++++++++++++++
 drivers/media/usb/gspca/m5602/m5602_mt9m111.h | 144 --------------------------
 2 files changed, 144 insertions(+), 144 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
index 27fcef11aef4..7d01ddd7ed01 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
@@ -23,6 +23,150 @@
 static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl);
 static void mt9m111_dump_registers(struct sd *sd);
 
+static const unsigned char preinit_mt9m111[][4] = {
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET,
+		MT9M111_RESET |
+		MT9M111_RESTART |
+		MT9M111_ANALOG_STANDBY |
+		MT9M111_CHIP_DISABLE,
+		MT9M111_SHOW_BAD_FRAMES |
+		MT9M111_RESTART_BAD_FRAMES |
+		MT9M111_SYNCHRONIZE_CHANGES},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00}
+};
+
+static const unsigned char init_mt9m111[][4] = {
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00,
+			MT9M111_CP_OPERATING_MODE_CTL},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00,
+				MT9M111_2D_DEFECT_CORRECTION_ENABLE},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00,
+				MT9M111_2D_DEFECT_CORRECTION_ENABLE},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{SENSOR, 0xd0, 0x00, 0x40},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, MT9M111_SEL_CONTEXT_B},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d}, /* 13 */
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x12}, /* 18 */
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x00}, /* 1024 */
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x10}, /* 1296 */
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x60}, /* 352 */
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11}, /* 17 */
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x60}, /* 352 */
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11}, /* 17 */
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x0f}, /* 271 */
+	{SENSOR, 0x30, 0x04, 0x00},
+	/* Set number of blank rows chosen to 400 */
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0x90},
+};
+
+static const unsigned char start_mt9m111[][4] = {
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+};
+
 static struct v4l2_pix_format mt9m111_modes[] = {
 	{
 		640,
diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.h b/drivers/media/usb/gspca/m5602/m5602_mt9m111.h
index 07448d35e3cd..781a16311822 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.h
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.h
@@ -126,148 +126,4 @@ static const struct m5602_sensor mt9m111 = {
 	.disconnect = mt9m111_disconnect,
 	.start = mt9m111_start,
 };
-
-static const unsigned char preinit_mt9m111[][4] = {
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
-
-	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
-	{SENSOR, MT9M111_SC_RESET,
-		MT9M111_RESET |
-		MT9M111_RESTART |
-		MT9M111_ANALOG_STANDBY |
-		MT9M111_CHIP_DISABLE,
-		MT9M111_SHOW_BAD_FRAMES |
-		MT9M111_RESTART_BAD_FRAMES |
-		MT9M111_SYNCHRONIZE_CHANGES},
-
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
-
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
-
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00}
-};
-
-static const unsigned char init_mt9m111[][4] = {
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
-
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
-
-	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
-	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
-	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
-	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
-	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00,
-			MT9M111_CP_OPERATING_MODE_CTL},
-	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
-	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00,
-				MT9M111_2D_DEFECT_CORRECTION_ENABLE},
-	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00,
-				MT9M111_2D_DEFECT_CORRECTION_ENABLE},
-	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
-	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
-	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
-	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
-	{SENSOR, 0xcd, 0x00, 0x0e},
-	{SENSOR, 0xd0, 0x00, 0x40},
-
-	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
-	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
-	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
-
-	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
-	{SENSOR, 0x33, 0x03, 0x49},
-	{SENSOR, 0x34, 0xc0, 0x19},
-	{SENSOR, 0x3f, 0x20, 0x20},
-	{SENSOR, 0x40, 0x20, 0x20},
-	{SENSOR, 0x5a, 0xc0, 0x0a},
-	{SENSOR, 0x70, 0x7b, 0x0a},
-	{SENSOR, 0x71, 0xff, 0x00},
-	{SENSOR, 0x72, 0x19, 0x0e},
-	{SENSOR, 0x73, 0x18, 0x0f},
-	{SENSOR, 0x74, 0x57, 0x32},
-	{SENSOR, 0x75, 0x56, 0x34},
-	{SENSOR, 0x76, 0x73, 0x35},
-	{SENSOR, 0x77, 0x30, 0x12},
-	{SENSOR, 0x78, 0x79, 0x02},
-	{SENSOR, 0x79, 0x75, 0x06},
-	{SENSOR, 0x7a, 0x77, 0x0a},
-	{SENSOR, 0x7b, 0x78, 0x09},
-	{SENSOR, 0x7c, 0x7d, 0x06},
-	{SENSOR, 0x7d, 0x31, 0x10},
-	{SENSOR, 0x7e, 0x00, 0x7e},
-	{SENSOR, 0x80, 0x59, 0x04},
-	{SENSOR, 0x81, 0x59, 0x04},
-	{SENSOR, 0x82, 0x57, 0x0a},
-	{SENSOR, 0x83, 0x58, 0x0b},
-	{SENSOR, 0x84, 0x47, 0x0c},
-	{SENSOR, 0x85, 0x48, 0x0e},
-	{SENSOR, 0x86, 0x5b, 0x02},
-	{SENSOR, 0x87, 0x00, 0x5c},
-	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, MT9M111_SEL_CONTEXT_B},
-	{SENSOR, 0x60, 0x00, 0x80},
-	{SENSOR, 0x61, 0x00, 0x00},
-	{SENSOR, 0x62, 0x00, 0x00},
-	{SENSOR, 0x63, 0x00, 0x00},
-	{SENSOR, 0x64, 0x00, 0x00},
-
-	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d}, /* 13 */
-	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x12}, /* 18 */
-	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x00}, /* 1024 */
-	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x10}, /* 1296 */
-	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x60}, /* 352 */
-	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11}, /* 17 */
-	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x60}, /* 352 */
-	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11}, /* 17 */
-	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x0f}, /* 271 */
-	{SENSOR, 0x30, 0x04, 0x00},
-	/* Set number of blank rows chosen to 400 */
-	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0x90},
-};
-
-static const unsigned char start_mt9m111[][4] = {
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
-	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
-	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
-	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-};
 #endif
-- 
2.7.4


