Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51240 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3FCSKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 14:10:32 -0400
Received: by mail-ee0-f44.google.com with SMTP id c13so412206eek.31
        for <linux-media@vger.kernel.org>; Mon, 03 Jun 2013 11:10:31 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] em28xx: extend GPIO register definitions for the em25xx, em276x/7x/8x, em2874/174/84
Date: Mon,  3 Jun 2013 20:12:02 +0200
Message-Id: <1370283125-2231-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em25xx/em276x/7x/8x provides 4 GPIO register sets,
each of them consisting of separate read and a write registers.
The same registers are also used by the em2874/174/84.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   88 +++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   62 +++++++++++-----------
 drivers/media/usb/em28xx/em28xx-reg.h   |   15 +++++-
 3 Dateien geändert, 89 Zeilen hinzugefügt(+), 76 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 927956b..a2230cc 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -286,14 +286,14 @@ static struct em28xx_reg_seq dikom_dk300_digital[] = {
 
 /* Reset for the most [digital] boards */
 static struct em28xx_reg_seq leadership_digital[] = {
-	{EM2874_R80_GPIO,	0x70,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0x70,	0xff,	10},
 	{	-1,		-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq leadership_reset[] = {
-	{EM2874_R80_GPIO,	0xf0,	0xff,	10},
-	{EM2874_R80_GPIO,	0xb0,	0xff,	10},
-	{EM2874_R80_GPIO,	0xf0,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xb0,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
 	{	-1,		-1,	-1,	-1},
 };
 
@@ -302,25 +302,25 @@ static struct em28xx_reg_seq leadership_reset[] = {
  * GPIO_7 - LED
  */
 static struct em28xx_reg_seq pctv_290e[] = {
-	{EM2874_R80_GPIO,	0x00,	0xff,		80},
-	{EM2874_R80_GPIO,	0x40,	0xff,		80}, /* GPIO_6 = 1 */
-	{EM2874_R80_GPIO,	0xc0,	0xff,		80}, /* GPIO_7 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0x00,	0xff,	80},
+	{EM2874_R80_GPIO_P0_CTRL,	0x40,	0xff,	80}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0xc0,	0xff,	80}, /* GPIO_7 = 1 */
 	{-1,			-1,	-1,		-1},
 };
 
 #if 0
 static struct em28xx_reg_seq terratec_h5_gpio[] = {
 	{EM28XX_R08_GPIO,	0xff,	0xff,	10},
-	{EM2874_R80_GPIO,	0xf6,	0xff,	100},
-	{EM2874_R80_GPIO,	0xf2,	0xff,	50},
-	{EM2874_R80_GPIO,	0xf6,	0xff,	50},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	50},
 	{ -1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq terratec_h5_digital[] = {
-	{EM2874_R80_GPIO,	0xf6,	0xff,	10},
-	{EM2874_R80_GPIO,	0xe6,	0xff,	100},
-	{EM2874_R80_GPIO,	0xa6,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
 	{ -1,			-1,	-1,	-1},
 };
 #endif
@@ -336,39 +336,39 @@ static struct em28xx_reg_seq terratec_h5_digital[] = {
  * GPIO_7 - LED (green LED)
  */
 static struct em28xx_reg_seq pctv_460e[] = {
-	{EM2874_R80_GPIO, 0x01, 0xff,  50},
+	{EM2874_R80_GPIO_P0_CTRL, 0x01, 0xff,  50},
 	{0x0d,            0xff, 0xff,  50},
-	{EM2874_R80_GPIO, 0x41, 0xff,  50}, /* GPIO_6=1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x41, 0xff,  50}, /* GPIO_6=1 */
 	{0x0d,            0x42, 0xff,  50},
-	{EM2874_R80_GPIO, 0x61, 0xff,  50}, /* GPIO_5=1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x61, 0xff,  50}, /* GPIO_5=1 */
 	{             -1,   -1,   -1,  -1},
 };
 
 static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
-	{EM2874_R80_GPIO,	0xff,	0xff,	10},
-	{EM2874_R80_GPIO,	0xfd,	0xff,	10}, /* xc5000 reset */
-	{EM2874_R80_GPIO,	0xf9,	0xff,	35},
-	{EM2874_R80_GPIO,	0xfd,	0xff,	10},
-	{EM2874_R80_GPIO,	0xff,	0xff,	10},
-	{EM2874_R80_GPIO,	0xfe,	0xff,	10},
-	{EM2874_R80_GPIO,	0xbe,	0xff,	10},
-	{EM2874_R80_GPIO,	0xfe,	0xff,	20},
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	10}, /* xc5000 reset */
+	{EM2874_R80_GPIO_P0_CTRL,	0xf9,	0xff,	35},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xbe,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	20},
 	{ -1,			-1,	-1,	-1},
 };
 
 #if 0
 static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
-	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
-	{EM2874_R80_GPIO,	0x4f,	0xff,	10}, /* xc5000 reset */
-	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
-	{EM2874_R80_GPIO,	0x4f,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0x4f,	0xff,	10}, /* xc5000 reset */
+	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0x4f,	0xff,	10},
 	{ -1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq hauppauge_930c_digital[] = {
-	{EM2874_R80_GPIO,	0xf6,	0xff,	10},
-	{EM2874_R80_GPIO,	0xe6,	0xff,	100},
-	{EM2874_R80_GPIO,	0xa6,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
 	{ -1,			-1,	-1,	-1},
 };
 #endif
@@ -379,9 +379,9 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
  * GPIO_7 - LED, 0=active
  */
 static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
-	{EM2874_R80_GPIO,  0x83,  0xff,  100},
-	{EM2874_R80_GPIO,  0xc3,  0xff,  100}, /* GPIO_6 = 1 */
-	{EM2874_R80_GPIO,  0x43,  0xff,  000}, /* GPIO_7 = 0 */
+	{EM2874_R80_GPIO_P0_CTRL,  0x83,  0xff,  100},
+	{EM2874_R80_GPIO_P0_CTRL,  0xc3,  0xff,  100}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,  0x43,  0xff,  000}, /* GPIO_7 = 0 */
 	{-1,                 -1,    -1,   -1},
 };
 
@@ -392,9 +392,9 @@ static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
  * GPIO_7: LED, 1=active
  */
 static struct em28xx_reg_seq pctv_510e[] = {
-	{EM2874_R80_GPIO, 0x10, 0xff, 100},
-	{EM2874_R80_GPIO, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
-	{EM2874_R80_GPIO, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x10, 0xff, 100},
+	{EM2874_R80_GPIO_P0_CTRL, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
 	{             -1,   -1,   -1,  -1},
 };
 
@@ -405,10 +405,10 @@ static struct em28xx_reg_seq pctv_510e[] = {
  * GPIO_7: LED, 1=active
  */
 static struct em28xx_reg_seq pctv_520e[] = {
-	{EM2874_R80_GPIO, 0x10, 0xff, 100},
-	{EM2874_R80_GPIO, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
-	{EM2874_R80_GPIO, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
-	{EM2874_R80_GPIO, 0xd4, 0xff, 000}, /* GPIO_7 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x10, 0xff, 100},
+	{EM2874_R80_GPIO_P0_CTRL, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL, 0xd4, 0xff, 000}, /* GPIO_7 = 1 */
 	{             -1,   -1,   -1,  -1},
 };
 
@@ -2948,13 +2948,13 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2874:
 			chip_name = "em2874";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
+			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		case CHIP_ID_EM28174:
 			chip_name = "em28174";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
+			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2964,7 +2964,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2884:
 			chip_name = "em2884";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
+			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 42ede68..69aed82 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -421,23 +421,23 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 	int i;
 
 	struct em28xx_reg_seq hauppauge_hvr930c_init[] = {
-		{EM2874_R80_GPIO,	0xff,	0xff,	0x65},
-		{EM2874_R80_GPIO,	0xfb,	0xff,	0x32},
-		{EM2874_R80_GPIO,	0xff,	0xff,	0xb8},
+		{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0x65},
+		{EM2874_R80_GPIO_P0_CTRL,	0xfb,	0xff,	0x32},
+		{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0xb8},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct em28xx_reg_seq hauppauge_hvr930c_end[] = {
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x01},
-		{EM2874_R80_GPIO,	0xaf,	0xff,	0x65},
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x76},
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x01},
-		{EM2874_R80_GPIO,	0xcf,	0xff,	0x0b},
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x40},
-
-		{EM2874_R80_GPIO,	0xcf,	0xff,	0x65},
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x65},
-		{EM2874_R80_GPIO,	0xcf,	0xff,	0x0b},
-		{EM2874_R80_GPIO,	0xef,	0xff,	0x65},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x01},
+		{EM2874_R80_GPIO_P0_CTRL,	0xaf,	0xff,	0x65},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x76},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x01},
+		{EM2874_R80_GPIO_P0_CTRL,	0xcf,	0xff,	0x0b},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x40},
+
+		{EM2874_R80_GPIO_P0_CTRL,	0xcf,	0xff,	0x65},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x65},
+		{EM2874_R80_GPIO_P0_CTRL,	0xcf,	0xff,	0x0b},
+		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x65},
 
 		{ -1,                   -1,     -1,     -1},
 	};
@@ -488,15 +488,15 @@ static void terratec_h5_init(struct em28xx *dev)
 	int i;
 	struct em28xx_reg_seq terratec_h5_init[] = {
 		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
-		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
-		{EM2874_R80_GPIO,	0xf2,	0xff,	50},
-		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct em28xx_reg_seq terratec_h5_end[] = {
-		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
-		{EM2874_R80_GPIO,	0xa6,	0xff,	50},
-		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct {
@@ -544,14 +544,14 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 	 */
 	struct em28xx_reg_seq terratec_htc_stick_init[] = {
 		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
-		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
-		{EM2874_R80_GPIO,	0xe6,	0xff,	50},
-		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct em28xx_reg_seq terratec_htc_stick_end[] = {
-		{EM2874_R80_GPIO,	0xb6,	0xff,	100},
-		{EM2874_R80_GPIO,	0xf6,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xb6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	50},
 		{ -1,                   -1,     -1,     -1},
 	};
 
@@ -591,15 +591,15 @@ static void terratec_htc_usb_xs_init(struct em28xx *dev)
 
 	struct em28xx_reg_seq terratec_htc_usb_xs_init[] = {
 		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
-		{EM2874_R80_GPIO,	0xb2,	0xff,	100},
-		{EM2874_R80_GPIO,	0xb2,	0xff,	50},
-		{EM2874_R80_GPIO,	0xb6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xb6,	0xff,	100},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct em28xx_reg_seq terratec_htc_usb_xs_end[] = {
-		{EM2874_R80_GPIO,	0xa6,	0xff,	100},
-		{EM2874_R80_GPIO,	0xa6,	0xff,	50},
-		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	100},
+		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	50},
+		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 		{ -1,                   -1,     -1,     -1},
 	};
 
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 622871d..0233c5b 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -193,7 +193,20 @@
 #define EM2874_R50_IR_CONFIG    0x50
 #define EM2874_R51_IR           0x51
 #define EM2874_R5F_TS_ENABLE    0x5f
-#define EM2874_R80_GPIO         0x80
+
+/* em2874/174/84, em25xx, em276x/7x/8x GPIO registers */
+/*
+ * NOTE: not all ports are bonded out;
+ * Some ports are multiplexed with special function I/O
+ */
+#define EM2874_R80_GPIO_P0_CTRL    0x80
+#define EM2874_R81_GPIO_P1_CTRL    0x81
+#define EM2874_R82_GPIO_P2_CTRL    0x82
+#define EM2874_R83_GPIO_P3_CTRL    0x83
+#define EM2874_R84_GPIO_P0_STATE   0x84
+#define EM2874_R85_GPIO_P1_STATE   0x85
+#define EM2874_R86_GPIO_P2_STATE   0x86
+#define EM2874_R87_GPIO_P3_STATE   0x87
 
 /* em2874 IR config register (0x50) */
 #define EM2874_IR_NEC           0x00
-- 
1.7.10.4

