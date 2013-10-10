Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58834 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3JJRgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 13:36:20 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so1312746eek.26
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 10:36:18 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: fix and unify the coding style of the GPIO register write sequences
Date: Thu, 10 Oct 2013 19:36:30 +0200
Message-Id: <1381426590-5295-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  102 +++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   16 ++---
 2 Dateien geändert, 59 Zeilen hinzugefügt(+), 59 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index dc65742..3765670 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -95,8 +95,8 @@ static struct em28xx_reg_seq default_digital[] = {
 /* Board Hauppauge WinTV HVR 900 analog */
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
-	{0x05,			0xff,	0x10,		10},
-	{  -1,			-1,	-1,		-1},
+	{	0x05,		0xff,	0x10,		10},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 digital */
@@ -104,20 +104,20 @@ static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x04,	0x0f,		10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 (R2) digital */
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900R2_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
 static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
-	{EM2820_R08_GPIO_CTRL,       0x69,   ~EM_GPIO_4,	 10},
-	{	-1,		-1,	-1,		 -1},
+	{EM2820_R08_GPIO_CTRL,	0x69,   ~EM_GPIO_4,	10},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
@@ -132,7 +132,7 @@ static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0x7e,	0xff,		10},
-	{  -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
@@ -140,19 +140,19 @@ static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
 	{EM2880_R04_GPO,	0x0c,	0xff,		10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		10},
-	{  -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq kworld_330u_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq kworld_330u_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Evga inDtube
@@ -170,7 +170,7 @@ static struct em28xx_reg_seq evga_indtube_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x7a,	0xff,		 1},
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		 1},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /*
@@ -185,8 +185,8 @@ static struct em28xx_reg_seq evga_indtube_digital[] = {
  * EM_GPIO_7 - currently unknown
  */
 static struct em28xx_reg_seq kworld_a340_digital[] = {
-	{EM2820_R08_GPIO_CTRL,	0x6d,		~EM_GPIO_4,	10},
-	{ -1,			-1,		-1,		-1},
+	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Pinnacle Hybrid Pro eb1a:2881 */
@@ -205,13 +205,13 @@ static struct em28xx_reg_seq pinnacle_hybrid_pro_digital[] = {
 static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* eb1a:2868 Reddo DVB-C USB TV Box
@@ -225,7 +225,7 @@ static struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
 	{EM2820_R08_GPIO_CTRL,	0x7f,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0x6f,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
-	{-1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 /* Callback for the most boards */
@@ -233,23 +233,23 @@ static struct em28xx_reg_seq default_tuner_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
 	{EM2820_R08_GPIO_CTRL,	0,		EM_GPIO_4,	10},
 	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
-	{  -1,			-1,		-1,		-1},
+	{	-1,		-1,		-1,		-1},
 };
 
 /* Mute/unmute */
 static struct em28xx_reg_seq compro_unmute_tv_gpio[] = {
-	{EM2820_R08_GPIO_CTRL,	5,		7,		10},
-	{  -1,			-1,		-1,		-1},
+	{EM2820_R08_GPIO_CTRL,	5,	7,	10},
+	{	-1,		-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq compro_unmute_svid_gpio[] = {
-	{EM2820_R08_GPIO_CTRL,	4,		7,		10},
-	{  -1,			-1,		-1,		-1},
+	{EM2820_R08_GPIO_CTRL,	4,	7,	10},
+	{	-1,		-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq compro_mute_gpio[] = {
-	{EM2820_R08_GPIO_CTRL,	6,		7,		10},
-	{  -1,			-1,		-1,		-1},
+	{EM2820_R08_GPIO_CTRL,	6,	7,	10},
+	{	-1,		-1,	-1,	-1},
 };
 
 /* Terratec AV350 */
@@ -279,21 +279,21 @@ static struct em28xx_reg_seq vc211a_enable[] = {
 static struct em28xx_reg_seq dikom_dk300_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
-	{ -1,			-1,	-1,		-1},
+	{	-1,		-1,	-1,		-1},
 };
 
 
 /* Reset for the most [digital] boards */
 static struct em28xx_reg_seq leadership_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x70,	0xff,	10},
-	{	-1,		-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq leadership_reset[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xb0,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
-	{	-1,		-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 /* 2013:024f PCTV nanoStick T2 290e
@@ -304,7 +304,7 @@ static struct em28xx_reg_seq pctv_290e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x00,	0xff,	80},
 	{EM2874_R80_GPIO_P0_CTRL,	0x40,	0xff,	80}, /* GPIO_6 = 1 */
 	{EM2874_R80_GPIO_P0_CTRL,	0xc0,	0xff,	80}, /* GPIO_7 = 1 */
-	{-1,			-1,	-1,		-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 #if 0
@@ -313,14 +313,14 @@ static struct em28xx_reg_seq terratec_h5_gpio[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	50},
-	{ -1,			-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq terratec_h5_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
-	{ -1,			-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 #endif
 
@@ -335,12 +335,12 @@ static struct em28xx_reg_seq terratec_h5_digital[] = {
  * GPIO_7 - LED (green LED)
  */
 static struct em28xx_reg_seq pctv_460e[] = {
-	{EM2874_R80_GPIO_P0_CTRL, 0x01, 0xff,  50},
-	{0x0d,            0xff, 0xff,  50},
-	{EM2874_R80_GPIO_P0_CTRL, 0x41, 0xff,  50}, /* GPIO_6=1 */
-	{0x0d,            0x42, 0xff,  50},
-	{EM2874_R80_GPIO_P0_CTRL, 0x61, 0xff,  50}, /* GPIO_5=1 */
-	{             -1,   -1,   -1,  -1},
+	{EM2874_R80_GPIO_P0_CTRL,	0x01,	0xff,	50},
+	{	0x0d,			0xff,	0xff,	50},
+	{EM2874_R80_GPIO_P0_CTRL,	0x41,	0xff,	50}, /* GPIO_6=1 */
+	{	0x0d,			0x42,	0xff,	50},
+	{EM2874_R80_GPIO_P0_CTRL,	0x61,	0xff,	50}, /* GPIO_5=1 */
+	{	-1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
@@ -352,7 +352,7 @@ static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xbe,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	20},
-	{ -1,			-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 #if 0
@@ -361,14 +361,14 @@ static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x4f,	0xff,	10}, /* xc5000 reset */
 	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0x4f,	0xff,	10},
-	{ -1,			-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 
 static struct em28xx_reg_seq hauppauge_930c_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
-	{ -1,			-1,	-1,	-1},
+	{	-1,			-1,	-1,	-1},
 };
 #endif
 
@@ -378,10 +378,10 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
  * GPIO_7 - LED, 0=active
  */
 static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
-	{EM2874_R80_GPIO_P0_CTRL,  0x83,  0xff,  100},
-	{EM2874_R80_GPIO_P0_CTRL,  0xc3,  0xff,  100}, /* GPIO_6 = 1 */
-	{EM2874_R80_GPIO_P0_CTRL,  0x43,  0xff,  000}, /* GPIO_7 = 0 */
-	{-1,                 -1,    -1,   -1},
+	{EM2874_R80_GPIO_P0_CTRL,	0x83,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xc3,	0xff,	100}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0x43,	0xff,	000}, /* GPIO_7 = 0 */
+	{	-1,			-1,	-1,	-1},
 };
 
 /* 2304:0242 PCTV QuatroStick (510e)
@@ -391,10 +391,10 @@ static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
  * GPIO_7: LED, 1=active
  */
 static struct em28xx_reg_seq pctv_510e[] = {
-	{EM2874_R80_GPIO_P0_CTRL, 0x10, 0xff, 100},
-	{EM2874_R80_GPIO_P0_CTRL, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
-	{EM2874_R80_GPIO_P0_CTRL, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
-	{             -1,   -1,   -1,  -1},
+	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
+	{	-1,			-1,	-1,	-1},
 };
 
 /* 2013:0251 PCTV QuatroStick nano (520e)
@@ -404,11 +404,11 @@ static struct em28xx_reg_seq pctv_510e[] = {
  * GPIO_7: LED, 1=active
  */
 static struct em28xx_reg_seq pctv_520e[] = {
-	{EM2874_R80_GPIO_P0_CTRL, 0x10, 0xff, 100},
-	{EM2874_R80_GPIO_P0_CTRL, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
-	{EM2874_R80_GPIO_P0_CTRL, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
-	{EM2874_R80_GPIO_P0_CTRL, 0xd4, 0xff, 000}, /* GPIO_7 = 1 */
-	{             -1,   -1,   -1,  -1},
+	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0xd4,	0xff,	000}, /* GPIO_7 = 1 */
+	{	-1,			-1,	-1,	-1},
 };
 
 /*
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index bb1e8dc..2f04e8d 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -424,7 +424,7 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 		{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0x65},
 		{EM2874_R80_GPIO_P0_CTRL,	0xfb,	0xff,	0x32},
 		{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0xb8},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 	struct em28xx_reg_seq hauppauge_hvr930c_end[] = {
 		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x01},
@@ -439,7 +439,7 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 		{EM2874_R80_GPIO_P0_CTRL,	0xcf,	0xff,	0x0b},
 		{EM2874_R80_GPIO_P0_CTRL,	0xef,	0xff,	0x65},
 
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 
 	struct {
@@ -491,13 +491,13 @@ static void terratec_h5_init(struct em28xx *dev)
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 	struct em28xx_reg_seq terratec_h5_end[] = {
 		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 	struct {
 		unsigned char r[4];
@@ -547,12 +547,12 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 	struct em28xx_reg_seq terratec_htc_stick_end[] = {
 		{EM2874_R80_GPIO_P0_CTRL,	0xb6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	50},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 
 	/*
@@ -594,13 +594,13 @@ static void terratec_htc_usb_xs_init(struct em28xx *dev)
 		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xb6,	0xff,	100},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 	struct em28xx_reg_seq terratec_htc_usb_xs_end[] = {
 		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
-		{ -1,                   -1,     -1,     -1},
+		{	-1,			-1,	-1,	-1},
 	};
 
 	/*
-- 
1.7.10.4

