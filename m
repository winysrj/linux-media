Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Erik Andren <erik.andren@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 09/19] m5602_po1030: move skeletons to the .c file
Date: Fri, 24 Jun 2016 12:31:50 -0300
Message-Id: <804c7812effb9e0a5ce580567308d652379cb367.1466782238.git.mchehab@s-opensource.com>
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
 drivers/media/usb/gspca/m5602/m5602_po1030.c | 104 +++++++++++++++++++++++++++
 drivers/media/usb/gspca/m5602/m5602_po1030.h | 104 ---------------------------
 2 files changed, 104 insertions(+), 104 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/media/usb/gspca/m5602/m5602_po1030.c
index 4bf5c43424b7..a0a90dd34ca8 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -23,6 +23,110 @@
 static int po1030_s_ctrl(struct v4l2_ctrl *ctrl);
 static void po1030_dump_registers(struct sd *sd);
 
+static const unsigned char preinit_po1030[][3] = {
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+
+	{SENSOR, PO1030_AUTOCTRL2, PO1030_SENSOR_RESET | (1 << 2)},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00}
+};
+
+static const unsigned char init_po1030[][3] = {
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+
+	{SENSOR, PO1030_AUTOCTRL2, PO1030_SENSOR_RESET | (1 << 2)},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+
+	{SENSOR, PO1030_AUTOCTRL2, 0x04},
+
+	{SENSOR, PO1030_OUTFORMCTRL2, PO1030_RAW_RGB_BAYER},
+	{SENSOR, PO1030_AUTOCTRL1, PO1030_WEIGHT_WIN_2X},
+
+	{SENSOR, PO1030_CONTROL2, 0x03},
+	{SENSOR, 0x21, 0x90},
+	{SENSOR, PO1030_YTARGET, 0x60},
+	{SENSOR, 0x59, 0x13},
+	{SENSOR, PO1030_OUTFORMCTRL1, PO1030_HREF_ENABLE},
+	{SENSOR, PO1030_EDGE_ENH_OFF, 0x00},
+	{SENSOR, PO1030_EGA, 0x80},
+	{SENSOR, 0x78, 0x14},
+	{SENSOR, 0x6f, 0x01},
+	{SENSOR, PO1030_GLOBALGAINMAX, 0x14},
+	{SENSOR, PO1030_Cb_U_GAIN, 0x38},
+	{SENSOR, PO1030_Cr_V_GAIN, 0x38},
+	{SENSOR, PO1030_CONTROL1, PO1030_SHUTTER_MODE |
+				  PO1030_AUTO_SUBSAMPLING |
+				  PO1030_FRAME_EQUAL},
+	{SENSOR, PO1030_GC0, 0x10},
+	{SENSOR, PO1030_GC1, 0x20},
+	{SENSOR, PO1030_GC2, 0x40},
+	{SENSOR, PO1030_GC3, 0x60},
+	{SENSOR, PO1030_GC4, 0x80},
+	{SENSOR, PO1030_GC5, 0xa0},
+	{SENSOR, PO1030_GC6, 0xc0},
+	{SENSOR, PO1030_GC7, 0xff},
+
+	/* Set the width to 751 */
+	{SENSOR, PO1030_FRAMEWIDTH_H, 0x02},
+	{SENSOR, PO1030_FRAMEWIDTH_L, 0xef},
+
+	/* Set the height to 540 */
+	{SENSOR, PO1030_FRAMEHEIGHT_H, 0x02},
+	{SENSOR, PO1030_FRAMEHEIGHT_L, 0x1c},
+
+	/* Set the x window to 1 */
+	{SENSOR, PO1030_WINDOWX_H, 0x00},
+	{SENSOR, PO1030_WINDOWX_L, 0x01},
+
+	/* Set the y window to 1 */
+	{SENSOR, PO1030_WINDOWY_H, 0x00},
+	{SENSOR, PO1030_WINDOWY_L, 0x01},
+
+	/* with a very low lighted environment increase the exposure but
+	 * decrease the FPS (Frame Per Second) */
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00},
+};
+
 static struct v4l2_pix_format po1030_modes[] = {
 	{
 		640,
diff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.h b/drivers/media/usb/gspca/m5602/m5602_po1030.h
index a6ab76149bd0..981a91aa7450 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.h
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.h
@@ -167,108 +167,4 @@ static const struct m5602_sensor po1030 = {
 	.start = po1030_start,
 	.disconnect = po1030_disconnect,
 };
-
-static const unsigned char preinit_po1030[][3] = {
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
-
-	{SENSOR, PO1030_AUTOCTRL2, PO1030_SENSOR_RESET | (1 << 2)},
-
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x00}
-};
-
-static const unsigned char init_po1030[][3] = {
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
-
-	{SENSOR, PO1030_AUTOCTRL2, PO1030_SENSOR_RESET | (1 << 2)},
-
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
-
-	{SENSOR, PO1030_AUTOCTRL2, 0x04},
-
-	{SENSOR, PO1030_OUTFORMCTRL2, PO1030_RAW_RGB_BAYER},
-	{SENSOR, PO1030_AUTOCTRL1, PO1030_WEIGHT_WIN_2X},
-
-	{SENSOR, PO1030_CONTROL2, 0x03},
-	{SENSOR, 0x21, 0x90},
-	{SENSOR, PO1030_YTARGET, 0x60},
-	{SENSOR, 0x59, 0x13},
-	{SENSOR, PO1030_OUTFORMCTRL1, PO1030_HREF_ENABLE},
-	{SENSOR, PO1030_EDGE_ENH_OFF, 0x00},
-	{SENSOR, PO1030_EGA, 0x80},
-	{SENSOR, 0x78, 0x14},
-	{SENSOR, 0x6f, 0x01},
-	{SENSOR, PO1030_GLOBALGAINMAX, 0x14},
-	{SENSOR, PO1030_Cb_U_GAIN, 0x38},
-	{SENSOR, PO1030_Cr_V_GAIN, 0x38},
-	{SENSOR, PO1030_CONTROL1, PO1030_SHUTTER_MODE |
-				  PO1030_AUTO_SUBSAMPLING |
-				  PO1030_FRAME_EQUAL},
-	{SENSOR, PO1030_GC0, 0x10},
-	{SENSOR, PO1030_GC1, 0x20},
-	{SENSOR, PO1030_GC2, 0x40},
-	{SENSOR, PO1030_GC3, 0x60},
-	{SENSOR, PO1030_GC4, 0x80},
-	{SENSOR, PO1030_GC5, 0xa0},
-	{SENSOR, PO1030_GC6, 0xc0},
-	{SENSOR, PO1030_GC7, 0xff},
-
-	/* Set the width to 751 */
-	{SENSOR, PO1030_FRAMEWIDTH_H, 0x02},
-	{SENSOR, PO1030_FRAMEWIDTH_L, 0xef},
-
-	/* Set the height to 540 */
-	{SENSOR, PO1030_FRAMEHEIGHT_H, 0x02},
-	{SENSOR, PO1030_FRAMEHEIGHT_L, 0x1c},
-
-	/* Set the x window to 1 */
-	{SENSOR, PO1030_WINDOWX_H, 0x00},
-	{SENSOR, PO1030_WINDOWX_L, 0x01},
-
-	/* Set the y window to 1 */
-	{SENSOR, PO1030_WINDOWY_H, 0x00},
-	{SENSOR, PO1030_WINDOWY_L, 0x01},
-
-	/* with a very low lighted environment increase the exposure but
-	 * decrease the FPS (Frame Per Second) */
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00},
-};
 #endif
-- 
2.7.4


