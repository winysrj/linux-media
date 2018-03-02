Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60146 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752819AbeCBTfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:11 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/8] media: em28xx: constify most static structs
Date: Fri,  2 Mar 2018 16:34:45 -0300
Message-Id: <ceedef1de02f7d3ac43492d95894f837f4a3fb2e.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several em28xx static structs that can now be constified.

That caused a significant reduction at data segment:

Before:
   text	   data	    bss	    dec	    hex	filename
  85017	  59588	    576	 145181	  2371d	drivers/media/usb/em28xx/em28xx.o

After:
   text	   data	    bss	    dec	    hex	filename
 112345	  32292	    576	 145213	  2373d	drivers/media/usb/em28xx/em28xx.o

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 106 ++++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-core.c  |   2 +-
 drivers/media/usb/em28xx/em28xx-input.c |   6 +-
 drivers/media/usb/em28xx/em28xx.h       |  16 ++---
 4 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 91c2198c8a2c..02af067d7451 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -81,26 +81,26 @@ static void em28xx_pre_card_setup(struct em28xx *dev);
  */
 
 /* Reset for the most [analog] boards */
-static struct em28xx_reg_seq default_analog[] = {
+const static struct em28xx_reg_seq default_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,   ~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Reset for the most [digital] boards */
-static struct em28xx_reg_seq default_digital[] = {
+const static struct em28xx_reg_seq default_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 analog */
-static struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] = {
+const static struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
 	{	0x05,		0xff,	0x10,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 digital */
-static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
+const static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x04,	0x0f,		10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
@@ -108,14 +108,14 @@ static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
 };
 
 /* Board Hauppauge WinTV HVR 900 (R2) digital */
-static struct em28xx_reg_seq hauppauge_wintv_hvr_900R2_digital[] = {
+const static struct em28xx_reg_seq hauppauge_wintv_hvr_900R2_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
-static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
+const static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x69,   ~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
@@ -126,7 +126,7 @@ static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
    Analog - No input analog */
 
 /* Board - EM2882 Kworld 315U digital */
-static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
+const static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
@@ -135,7 +135,7 @@ static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
+const static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
@@ -143,13 +143,13 @@ static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq kworld_330u_analog[] = {
+const static struct em28xx_reg_seq kworld_330u_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq kworld_330u_digital[] = {
+const static struct em28xx_reg_seq kworld_330u_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
@@ -161,12 +161,12 @@ static struct em28xx_reg_seq kworld_330u_digital[] = {
    GPIO4 - xc3028 reset
    GOP3  - s5h1409 reset
  */
-static struct em28xx_reg_seq evga_indtube_analog[] = {
+const static struct em28xx_reg_seq evga_indtube_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x79,   0xff,		60},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq evga_indtube_digital[] = {
+const static struct em28xx_reg_seq evga_indtube_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x7a,	0xff,		 1},
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		 1},
@@ -184,12 +184,12 @@ static struct em28xx_reg_seq evga_indtube_digital[] = {
  * EM_GPIO_6 - currently unknown
  * EM_GPIO_7 - currently unknown
  */
-static struct em28xx_reg_seq kworld_a340_digital[] = {
+const static struct em28xx_reg_seq kworld_a340_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
+const static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xbe,	0xff,	100},
@@ -198,25 +198,25 @@ static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
 };
 
 /* Pinnacle Hybrid Pro eb1a:2881 */
-static struct em28xx_reg_seq pinnacle_hybrid_pro_analog[] = {
+const static struct em28xx_reg_seq pinnacle_hybrid_pro_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0xfd,   ~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq pinnacle_hybrid_pro_digital[] = {
+const static struct em28xx_reg_seq pinnacle_hybrid_pro_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x04,	0xff,	       100},/* zl10353 reset */
 	{EM2880_R04_GPO,	0x0c,	0xff,		 1},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
+const static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
+const static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
@@ -226,7 +226,7 @@ static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
    0-5: not used
    6:   demod reset, active low
    7:   LED on, active high */
-static struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
+const static struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
 	{EM28XX_R06_I2C_CLK,    0x45,   0xff,		  10}, /*400 KHz*/
 	{EM2874_R80_GPIO_P0_CTRL, 0x00,   0xff,		  100},/*Demod reset*/
 	{EM2874_R80_GPIO_P0_CTRL, 0x40,   0xff,		  10},
@@ -236,7 +236,7 @@ static struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
 /* eb1a:2868 Reddo DVB-C USB TV Box
    GPIO4 - CU1216L NIM
    Other GPIOs seems to be don't care. */
-static struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
+const static struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
 	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0xde,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
@@ -248,7 +248,7 @@ static struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
 };
 
 /* Callback for the most boards */
-static struct em28xx_reg_seq default_tuner_gpio[] = {
+const static struct em28xx_reg_seq default_tuner_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
 	{EM2820_R08_GPIO_CTRL,	0,		EM_GPIO_4,	10},
 	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
@@ -256,58 +256,58 @@ static struct em28xx_reg_seq default_tuner_gpio[] = {
 };
 
 /* Mute/unmute */
-static struct em28xx_reg_seq compro_unmute_tv_gpio[] = {
+const static struct em28xx_reg_seq compro_unmute_tv_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	5,	7,	10},
 	{	-1,		-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq compro_unmute_svid_gpio[] = {
+const static struct em28xx_reg_seq compro_unmute_svid_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	4,	7,	10},
 	{	-1,		-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq compro_mute_gpio[] = {
+const static struct em28xx_reg_seq compro_mute_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	6,	7,	10},
 	{	-1,		-1,	-1,	-1},
 };
 
 /* Terratec AV350 */
-static struct em28xx_reg_seq terratec_av350_mute_gpio[] = {
+const static struct em28xx_reg_seq terratec_av350_mute_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0x7f,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq terratec_av350_unmute_gpio[] = {
+const static struct em28xx_reg_seq terratec_av350_unmute_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq silvercrest_reg_seq[] = {
+const static struct em28xx_reg_seq silvercrest_reg_seq[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0x01,	0xf7,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq vc211a_enable[] = {
+const static struct em28xx_reg_seq vc211a_enable[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0x07,		10},
 	{EM2820_R08_GPIO_CTRL,	0xff,	0x0f,		10},
 	{EM2820_R08_GPIO_CTRL,	0xff,	0x0b,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
-static struct em28xx_reg_seq dikom_dk300_digital[] = {
+const static struct em28xx_reg_seq dikom_dk300_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Reset for the most [digital] boards */
-static struct em28xx_reg_seq leadership_digital[] = {
+const static struct em28xx_reg_seq leadership_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x70,	0xff,	10},
 	{	-1,			-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq leadership_reset[] = {
+const static struct em28xx_reg_seq leadership_reset[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xb0,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf0,	0xff,	10},
@@ -318,7 +318,7 @@ static struct em28xx_reg_seq leadership_reset[] = {
  * GPIO_6 - demod reset
  * GPIO_7 - LED
  */
-static struct em28xx_reg_seq pctv_290e[] = {
+const static struct em28xx_reg_seq pctv_290e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x00,	0xff,	80},
 	{EM2874_R80_GPIO_P0_CTRL,	0x40,	0xff,	80}, /* GPIO_6 = 1 */
 	{EM2874_R80_GPIO_P0_CTRL,	0xc0,	0xff,	80}, /* GPIO_7 = 1 */
@@ -326,7 +326,7 @@ static struct em28xx_reg_seq pctv_290e[] = {
 };
 
 #if 0
-static struct em28xx_reg_seq terratec_h5_gpio[] = {
+const static struct em28xx_reg_seq terratec_h5_gpio[] = {
 	{EM2820_R08_GPIO_CTRL,		0xff,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
@@ -334,7 +334,7 @@ static struct em28xx_reg_seq terratec_h5_gpio[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq terratec_h5_digital[] = {
+const static struct em28xx_reg_seq terratec_h5_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
@@ -352,7 +352,7 @@ static struct em28xx_reg_seq terratec_h5_digital[] = {
  * GPIO_6 - RESET_DEM
  * GPIO_7 - LED (green LED)
  */
-static struct em28xx_reg_seq pctv_460e[] = {
+const static struct em28xx_reg_seq pctv_460e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x01,	0xff,	50},
 	{	0x0d,			0xff,	0xff,	50},
 	{EM2874_R80_GPIO_P0_CTRL,	0x41,	0xff,	50}, /* GPIO_6=1 */
@@ -361,7 +361,7 @@ static struct em28xx_reg_seq pctv_460e[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
+const static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	10}, /* xc5000 reset */
 	{EM2874_R80_GPIO_P0_CTRL,	0xf9,	0xff,	35},
@@ -384,7 +384,7 @@ static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
  * GPIO 6 = #RESET_DEM
  * GPIO 7 = P07_LED (green LED)
  */
-static struct em28xx_reg_seq pctv_461e[] = {
+const static struct em28xx_reg_seq pctv_461e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,      0x7f, 0xff,    0},
 	{0x0d,                 0xff, 0xff,    0},
 	{EM2874_R80_GPIO_P0_CTRL,      0x3f, 0xff,  100}, /* reset demod */
@@ -396,7 +396,7 @@ static struct em28xx_reg_seq pctv_461e[] = {
 };
 
 #if 0
-static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
+const static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0x4f,	0xff,	10}, /* xc5000 reset */
 	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
@@ -404,7 +404,7 @@ static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq hauppauge_930c_digital[] = {
+const static struct em28xx_reg_seq hauppauge_930c_digital[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xa6,	0xff,	10},
@@ -417,7 +417,7 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
  * GPIO_6 - demod reset, 0=active
  * GPIO_7 - LED, 0=active
  */
-static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
+const static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x83,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xc3,	0xff,	100}, /* GPIO_6 = 1 */
 	{EM2874_R80_GPIO_P0_CTRL,	0x43,	0xff,	000}, /* GPIO_7 = 0 */
@@ -430,7 +430,7 @@ static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
  * GPIO_6: demod reset, 0=active
  * GPIO_7: LED, 1=active
  */
-static struct em28xx_reg_seq pctv_510e[] = {
+const static struct em28xx_reg_seq pctv_510e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
 	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
@@ -443,7 +443,7 @@ static struct em28xx_reg_seq pctv_510e[] = {
  * GPIO_6: demod reset, 0=active
  * GPIO_7: LED, 1=active
  */
-static struct em28xx_reg_seq pctv_520e[] = {
+const static struct em28xx_reg_seq pctv_520e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
 	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
@@ -460,13 +460,13 @@ static struct em28xx_reg_seq pctv_520e[] = {
  * reg 0x81/0x85:
  * GPIO_7: snapshot button, 0=pressed, 1=unpressed
  */
-static struct em28xx_reg_seq speedlink_vad_laplace_reg_seq[] = {
+const static struct em28xx_reg_seq speedlink_vad_laplace_reg_seq[] = {
 	{EM2820_R08_GPIO_CTRL,		0xf7,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xb2,	10},
 	{	-1,			-1,	-1,	-1},
 };
 
-static struct em28xx_reg_seq pctv_292e[] = {
+const static struct em28xx_reg_seq pctv_292e[] = {
 	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,      0},
 	{0x0d,                         0xff, 0xff,    950},
 	{EM2874_R80_GPIO_P0_CTRL,      0xbd, 0xff,    100},
@@ -478,7 +478,7 @@ static struct em28xx_reg_seq pctv_292e[] = {
 	{-1,                             -1,   -1,     -1},
 };
 
-static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
+const static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0},
 	{0x0d,				0xff,	0xff,	600},
 	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	10},
@@ -492,7 +492,7 @@ static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
 	{-1,                             -1,   -1,     -1},
 };
 
-static struct em28xx_reg_seq plex_px_bcud[] = {
+const static struct em28xx_reg_seq plex_px_bcud[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0},
 	{0x0d,				0xff,	0xff,	0},
 	{EM2874_R50_IR_CONFIG,		0x01,	0xff,	0},
@@ -517,7 +517,7 @@ static struct em28xx_reg_seq plex_px_bcud[] = {
  * GPIO_5: Reset #2, 0=active
  * GPIO_6: Reset #1, 0=active
  */
-static struct em28xx_reg_seq hauppauge_dualhd_dvb[] = {
+const static struct em28xx_reg_seq hauppauge_dualhd_dvb[] = {
 	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,      0},
 	{0x0d,                         0xff, 0xff,    200},
 	{0x50,                         0x04, 0xff,    300},
@@ -534,7 +534,7 @@ static struct em28xx_reg_seq hauppauge_dualhd_dvb[] = {
 /*
  *  Button definitions
  */
-static struct em28xx_button std_snapshot_button[] = {
+const static struct em28xx_button std_snapshot_button[] = {
 	{
 		.role         = EM28XX_BUTTON_SNAPSHOT,
 		.reg_r        = EM28XX_R0C_USBSUSP,
@@ -545,7 +545,7 @@ static struct em28xx_button std_snapshot_button[] = {
 	{-1, 0, 0, 0, 0},
 };
 
-static struct em28xx_button speedlink_vad_laplace_buttons[] = {
+const static struct em28xx_button speedlink_vad_laplace_buttons[] = {
 	{
 		.role     = EM28XX_BUTTON_SNAPSHOT,
 		.reg_r    = EM2874_R85_GPIO_P1_STATE,
@@ -629,7 +629,7 @@ static struct em28xx_led hauppauge_dualhd_leds[] = {
 /*
  *  Board definitions
  */
-struct em28xx_board em28xx_boards[] = {
+const struct em28xx_board em28xx_boards[] = {
 	[EM2750_BOARD_UNKNOWN] = {
 		.name          = "EM2710/EM2750/EM2751 webcam grabber",
 		.xclk          = EM28XX_XCLK_FREQUENCY_20MHZ,
@@ -2626,7 +2626,7 @@ MODULE_DEVICE_TABLE(usb, em28xx_id_table);
 /*
  * EEPROM hash table for devices with generic USB IDs
  */
-static struct em28xx_hash_table em28xx_eeprom_hash[] = {
+const static struct em28xx_hash_table em28xx_eeprom_hash[] = {
 	/* P/N: SA 60002070465 Tuner: TVF7533-MF */
 	{0x6ce05a8f, EM2820_BOARD_PROLINK_PLAYTV_USB2, TUNER_YMEC_TVF_5533MF},
 	{0x72cc5a8b, EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2, TUNER_YMEC_TVF_5533MF},
@@ -2639,7 +2639,7 @@ static struct em28xx_hash_table em28xx_eeprom_hash[] = {
 };
 
 /* I2C devicelist hash table for devices with generic USB IDs */
-static struct em28xx_hash_table em28xx_i2c_hash[] = {
+const static struct em28xx_hash_table em28xx_i2c_hash[] = {
 	{0xb06a32c3, EM2800_BOARD_TERRATEC_CINERGY_200, TUNER_LG_PAL_NEW_TAPC},
 	{0xf51200e3, EM2800_BOARD_VGEAR_POCKETTV, TUNER_LG_PAL_NEW_TAPC},
 	{0x1ba50080, EM2860_BOARD_SAA711X_REFERENCE_DESIGN, TUNER_ABSENT},
@@ -2671,7 +2671,7 @@ EXPORT_SYMBOL_GPL(em28xx_tuner_callback);
 
 static inline void em28xx_set_xclk_i2c_speed(struct em28xx *dev)
 {
-	struct em28xx_board *board = &em28xx_boards[dev->model];
+	const struct em28xx_board *board = &em28xx_boards[dev->model];
 	u8 xclk = board->xclk, i2c_speed = board->i2c_speed;
 
 	/* Those are the default values for the majority of boards
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 92c99b0320b3..ee8ef066d1ac 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -691,7 +691,7 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 	return rc;
 }
 
-int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio)
+int em28xx_gpio_set(struct em28xx *dev, const struct em28xx_reg_seq *gpio)
 {
 	int rc = 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 046223de1e91..270cd68df4a2 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -515,7 +515,8 @@ static void em28xx_query_buttons(struct work_struct *work)
 		j = 0;
 		while (dev->board.buttons[j].role >= 0 &&
 		       dev->board.buttons[j].role < EM28XX_NUM_BUTTON_ROLES) {
-			struct em28xx_button *button = &dev->board.buttons[j];
+			const struct em28xx_button *button = &dev->board.buttons[j];
+
 			/* Check if button uses the current address */
 			if (button->reg_r != dev->button_polling_addresses[i]) {
 				j++;
@@ -618,7 +619,8 @@ static void em28xx_init_buttons(struct em28xx *dev)
 	dev->button_polling_interval = EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL;
 	while (dev->board.buttons[i].role >= 0 &&
 	       dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
-		struct em28xx_button *button = &dev->board.buttons[i];
+		const struct em28xx_button *button = &dev->board.buttons[i];
+
 		/* Check if polling address is already on the list */
 		addr_new = true;
 		for (j = 0; j < dev->num_button_polling_addresses; j++) {
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index d64de57769f0..b23f323b5c99 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -383,7 +383,7 @@ struct em28xx_input {
 	unsigned int vmux;
 	enum em28xx_amux amux;
 	enum em28xx_aout aout;
-	struct em28xx_reg_seq *gpio;
+	const struct em28xx_reg_seq *gpio;
 };
 
 #define INPUT(nr) (&em28xx_boards[dev->model].input[nr])
@@ -447,10 +447,10 @@ struct em28xx_board {
 	unsigned int tda9887_conf;
 
 	/* GPIO sequences */
-	struct em28xx_reg_seq *dvb_gpio;
-	struct em28xx_reg_seq *suspend_gpio;
-	struct em28xx_reg_seq *tuner_gpio;
-	struct em28xx_reg_seq *mute_gpio;
+	const struct em28xx_reg_seq *dvb_gpio;
+	const struct em28xx_reg_seq *suspend_gpio;
+	const struct em28xx_reg_seq *tuner_gpio;
+	const struct em28xx_reg_seq *mute_gpio;
 
 	unsigned int is_em2800:1;
 	unsigned int has_msp34xx:1;
@@ -476,7 +476,7 @@ struct em28xx_board {
 	struct em28xx_led	  *leds;
 
 	/* Buttons */
-	struct em28xx_button	  *buttons;
+	const struct em28xx_button *buttons;
 };
 
 struct em28xx_eeprom {
@@ -780,7 +780,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
-int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
+int em28xx_gpio_set(struct em28xx *dev, const struct em28xx_reg_seq *gpio);
 int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
 void em28xx_init_extension(struct em28xx *dev);
@@ -789,7 +789,7 @@ int em28xx_suspend_extension(struct em28xx *dev);
 int em28xx_resume_extension(struct em28xx *dev);
 
 /* Provided by em28xx-cards.c */
-extern struct em28xx_board em28xx_boards[];
+extern const struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
-- 
2.14.3
