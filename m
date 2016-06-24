Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Erik Andren <erik.andren@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 08/19] m5602_s5k83a: move skeletons to the .c file
Date: Fri, 24 Jun 2016 12:31:49 -0300
Message-Id: <1ab9e6000120d832e205a69c6fb27002b81aeae8.1466782238.git.mchehab@s-opensource.com>
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
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 124 +++++++++++++++++++++++++++
 drivers/media/usb/gspca/m5602/m5602_s5k83a.h | 124 ---------------------------
 2 files changed, 124 insertions(+), 124 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index bf6b215438e3..be5e25d1a2e8 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -41,6 +41,130 @@ static struct v4l2_pix_format s5k83a_modes[] = {
 	}
 };
 
+static const unsigned char preinit_s5k83a[][4] = {
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+};
+
+/* This could probably be considerably shortened.
+   I don't have the hardware to experiment with it, patches welcome
+*/
+static const unsigned char init_s5k83a[][4] = {
+	/* The following sequence is useless after a clean boot
+	   but is necessary after resume from suspend */
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x04, 0x00},
+	{SENSOR, 0xaf, 0x01, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, 0x7b, 0xff, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x01, 0x50, 0x00},
+	{SENSOR, 0x12, 0x20, 0x00},
+	{SENSOR, 0x17, 0x40, 0x00},
+	{SENSOR, 0x1c, 0x00, 0x00},
+	{SENSOR, 0x02, 0x70, 0x00},
+	{SENSOR, 0x03, 0x0b, 0x00},
+	{SENSOR, 0x04, 0xf0, 0x00},
+	{SENSOR, 0x05, 0x0b, 0x00},
+	{SENSOR, 0x06, 0x71, 0x00},
+	{SENSOR, 0x07, 0xe8, 0x00}, /* 488 */
+	{SENSOR, 0x08, 0x02, 0x00},
+	{SENSOR, 0x09, 0x88, 0x00}, /* 648 */
+	{SENSOR, 0x14, 0x00, 0x00},
+	{SENSOR, 0x15, 0x20, 0x00}, /* 32 */
+	{SENSOR, 0x19, 0x00, 0x00},
+	{SENSOR, 0x1a, 0x98, 0x00}, /* 152 */
+	{SENSOR, 0x0f, 0x02, 0x00},
+	{SENSOR, 0x10, 0xe5, 0x00}, /* 741 */
+	/* normal colors
+	(this is value after boot, but after tries can be different) */
+	{SENSOR, 0x00, 0x06, 0x00},
+};
+
+static const unsigned char start_s5k83a[][4] = {
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
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00}, /* 484 */
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7f, 0x00}, /* 639 */
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+};
+
 static void s5k83a_dump_registers(struct sd *sd);
 static int s5k83a_get_rotation(struct sd *sd, u8 *reg_data);
 static int s5k83a_set_led_indication(struct sd *sd, u8 val);
diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.h b/drivers/media/usb/gspca/m5602/m5602_s5k83a.h
index d61b918228df..3212bfe53d22 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.h
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.h
@@ -61,128 +61,4 @@ static const struct m5602_sensor s5k83a = {
 	.i2c_slave_id = 0x5a,
 	.i2c_regW = 2,
 };
-
-static const unsigned char preinit_s5k83a[][4] = {
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
-
-	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
-};
-
-/* This could probably be considerably shortened.
-   I don't have the hardware to experiment with it, patches welcome
-*/
-static const unsigned char init_s5k83a[][4] = {
-	/* The following sequence is useless after a clean boot
-	   but is necessary after resume from suspend */
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
-	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
-
-	{SENSOR, S5K83A_PAGE_MAP, 0x04, 0x00},
-	{SENSOR, 0xaf, 0x01, 0x00},
-	{SENSOR, S5K83A_PAGE_MAP, 0x00, 0x00},
-	{SENSOR, 0x7b, 0xff, 0x00},
-	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
-	{SENSOR, 0x01, 0x50, 0x00},
-	{SENSOR, 0x12, 0x20, 0x00},
-	{SENSOR, 0x17, 0x40, 0x00},
-	{SENSOR, 0x1c, 0x00, 0x00},
-	{SENSOR, 0x02, 0x70, 0x00},
-	{SENSOR, 0x03, 0x0b, 0x00},
-	{SENSOR, 0x04, 0xf0, 0x00},
-	{SENSOR, 0x05, 0x0b, 0x00},
-	{SENSOR, 0x06, 0x71, 0x00},
-	{SENSOR, 0x07, 0xe8, 0x00}, /* 488 */
-	{SENSOR, 0x08, 0x02, 0x00},
-	{SENSOR, 0x09, 0x88, 0x00}, /* 648 */
-	{SENSOR, 0x14, 0x00, 0x00},
-	{SENSOR, 0x15, 0x20, 0x00}, /* 32 */
-	{SENSOR, 0x19, 0x00, 0x00},
-	{SENSOR, 0x1a, 0x98, 0x00}, /* 152 */
-	{SENSOR, 0x0f, 0x02, 0x00},
-	{SENSOR, 0x10, 0xe5, 0x00}, /* 741 */
-	/* normal colors
-	(this is value after boot, but after tries can be different) */
-	{SENSOR, 0x00, 0x06, 0x00},
-};
-
-static const unsigned char start_s5k83a[][4] = {
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
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00}, /* 484 */
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
-	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
-	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
-	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7f, 0x00}, /* 639 */
-	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
-};
 #endif
-- 
2.7.4


