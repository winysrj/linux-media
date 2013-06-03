Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43929 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3FCSKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 14:10:35 -0400
Received: by mail-ea0-f172.google.com with SMTP id g14so1551977eak.3
        for <linux-media@vger.kernel.org>; Mon, 03 Jun 2013 11:10:33 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] em28xx: improve em2820-em2873/83 GPIO port register definitions and descriptions
Date: Mon,  3 Jun 2013 20:12:03 +0200
Message-Id: <1370283125-2231-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- add definition for GPIO register 0x09 (reading/input)
- extend the information the chip variants that support GPIO registers 0x08/0x09
- rename EM28XX_R08_GPIO to EM2820_R08_GPIO_CTRL

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  128 +++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |    6 +-
 drivers/media/usb/em28xx/em28xx-reg.h   |    5 +-
 3 Dateien geändert, 70 Zeilen hinzugefügt(+), 69 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a2230cc..7f1422b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -83,26 +83,26 @@ static void em28xx_pre_card_setup(struct em28xx *dev);
 
 /* Reset for the most [analog] boards */
 static struct em28xx_reg_seq default_analog[] = {
-	{EM28XX_R08_GPIO,	0x6d,   ~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6d,   ~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Reset for the most [digital] boards */
 static struct em28xx_reg_seq default_digital[] = {
-	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 analog */
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] = {
-	{EM28XX_R08_GPIO,	0x2d,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
 	{0x05,			0xff,	0x10,		10},
 	{  -1,			-1,	-1,		-1},
 };
 
 /* Board Hauppauge WinTV HVR 900 digital */
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
-	{EM28XX_R08_GPIO,	0x2e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x04,	0x0f,		10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
 	{ -1,			-1,	-1,		-1},
@@ -110,14 +110,14 @@ static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
 
 /* Board Hauppauge WinTV HVR 900 (R2) digital */
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900R2_digital[] = {
-	{EM28XX_R08_GPIO,	0x2e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x2e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x0c,	0x0f,		10},
 	{ -1,			-1,	-1,		-1},
 };
 
 /* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
 static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
-	{EM28XX_R08_GPIO,       0x69,   ~EM_GPIO_4,	 10},
+	{EM2820_R08_GPIO_CTRL,       0x69,   ~EM_GPIO_4,	 10},
 	{	-1,		-1,	-1,		 -1},
 };
 
@@ -128,11 +128,11 @@ static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
 
 /* Board - EM2882 Kworld 315U digital */
 static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
-	{EM28XX_R08_GPIO,	0xff,	0xff,		10},
-	{EM28XX_R08_GPIO,	0xfe,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		10},
-	{EM28XX_R08_GPIO,	0x7e,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0x7e,	0xff,		10},
 	{  -1,			-1,	-1,		-1},
 };
 
@@ -145,13 +145,13 @@ static struct em28xx_reg_seq em2882_kworld_315u_tuner_gpio[] = {
 };
 
 static struct em28xx_reg_seq kworld_330u_analog[] = {
-	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
 	{ -1,			-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq kworld_330u_digital[] = {
-	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{ -1,			-1,	-1,		-1},
 };
@@ -163,12 +163,12 @@ static struct em28xx_reg_seq kworld_330u_digital[] = {
    GOP3  - s5h1409 reset
  */
 static struct em28xx_reg_seq evga_indtube_analog[] = {
-	{EM28XX_R08_GPIO,	0x79,   0xff,		60},
+	{EM2820_R08_GPIO_CTRL,	0x79,   0xff,		60},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq evga_indtube_digital[] = {
-	{EM28XX_R08_GPIO,	0x7a,	0xff,		 1},
+	{EM2820_R08_GPIO_CTRL,	0x7a,	0xff,		 1},
 	{EM2880_R04_GPO,	0x04,	0xff,		10},
 	{EM2880_R04_GPO,	0x0c,	0xff,		 1},
 	{ -1,			-1,	-1,		-1},
@@ -186,31 +186,31 @@ static struct em28xx_reg_seq evga_indtube_digital[] = {
  * EM_GPIO_7 - currently unknown
  */
 static struct em28xx_reg_seq kworld_a340_digital[] = {
-	{EM28XX_R08_GPIO,	0x6d,		~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6d,		~EM_GPIO_4,	10},
 	{ -1,			-1,		-1,		-1},
 };
 
 /* Pinnacle Hybrid Pro eb1a:2881 */
 static struct em28xx_reg_seq pinnacle_hybrid_pro_analog[] = {
-	{EM28XX_R08_GPIO,	0xfd,   ~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0xfd,   ~EM_GPIO_4,	10},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq pinnacle_hybrid_pro_digital[] = {
-	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x04,	0xff,	       100},/* zl10353 reset */
 	{EM2880_R04_GPO,	0x0c,	0xff,		 1},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
-	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
 	{ -1,			-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
-	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{ -1,			-1,	-1,		-1},
 };
@@ -219,66 +219,66 @@ static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
    GPIO4 - CU1216L NIM
    Other GPIOs seems to be don't care. */
 static struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
-	{EM28XX_R08_GPIO,	0xfe,	0xff,		10},
-	{EM28XX_R08_GPIO,	0xde,	0xff,		10},
-	{EM28XX_R08_GPIO,	0xfe,	0xff,		10},
-	{EM28XX_R08_GPIO,	0xff,	0xff,		10},
-	{EM28XX_R08_GPIO,	0x7f,	0xff,		10},
-	{EM28XX_R08_GPIO,	0x6f,	0xff,		10},
-	{EM28XX_R08_GPIO,	0xff,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xde,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0x7f,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0x6f,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
 	{-1,			-1,	-1,		-1},
 };
 
 /* Callback for the most boards */
 static struct em28xx_reg_seq default_tuner_gpio[] = {
-	{EM28XX_R08_GPIO,	EM_GPIO_4,	EM_GPIO_4,	10},
-	{EM28XX_R08_GPIO,	0,		EM_GPIO_4,	10},
-	{EM28XX_R08_GPIO,	EM_GPIO_4,	EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0,		EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	10},
 	{  -1,			-1,		-1,		-1},
 };
 
 /* Mute/unmute */
 static struct em28xx_reg_seq compro_unmute_tv_gpio[] = {
-	{EM28XX_R08_GPIO,	5,		7,		10},
+	{EM2820_R08_GPIO_CTRL,	5,		7,		10},
 	{  -1,			-1,		-1,		-1},
 };
 
 static struct em28xx_reg_seq compro_unmute_svid_gpio[] = {
-	{EM28XX_R08_GPIO,	4,		7,		10},
+	{EM2820_R08_GPIO_CTRL,	4,		7,		10},
 	{  -1,			-1,		-1,		-1},
 };
 
 static struct em28xx_reg_seq compro_mute_gpio[] = {
-	{EM28XX_R08_GPIO,	6,		7,		10},
+	{EM2820_R08_GPIO_CTRL,	6,		7,		10},
 	{  -1,			-1,		-1,		-1},
 };
 
 /* Terratec AV350 */
 static struct em28xx_reg_seq terratec_av350_mute_gpio[] = {
-	{EM28XX_R08_GPIO,	0xff,	0x7f,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0x7f,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq terratec_av350_unmute_gpio[] = {
-	{EM28XX_R08_GPIO,	0xff,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq silvercrest_reg_seq[] = {
-	{EM28XX_R08_GPIO,	0xff,	0xff,		10},
-	{EM28XX_R08_GPIO,	0x01,	0xf7,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
+	{EM2820_R08_GPIO_CTRL,	0x01,	0xf7,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq vc211a_enable[] = {
-	{EM28XX_R08_GPIO,	0xff,	0x07,		10},
-	{EM28XX_R08_GPIO,	0xff,	0x0f,		10},
-	{EM28XX_R08_GPIO,	0xff,	0x0b,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0x07,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0x0f,		10},
+	{EM2820_R08_GPIO_CTRL,	0xff,	0x0b,		10},
 	{	-1,		-1,	-1,		-1},
 };
 
 static struct em28xx_reg_seq dikom_dk300_digital[] = {
-	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2820_R08_GPIO_CTRL,	0x6e,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x08,	0xff,		10},
 	{ -1,			-1,	-1,		-1},
 };
@@ -310,7 +310,7 @@ static struct em28xx_reg_seq pctv_290e[] = {
 
 #if 0
 static struct em28xx_reg_seq terratec_h5_gpio[] = {
-	{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+	{EM2820_R08_GPIO_CTRL,		0xff,	0xff,	10},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
 	{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	50},
@@ -2300,9 +2300,9 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		break;
 	case EM2861_BOARD_KWORLD_PVRTV_300U:
 	case EM2880_BOARD_KWORLD_DVB_305U:
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x6d);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0x6d);
 		msleep(10);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x7d);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0x7d);
 		msleep(10);
 		break;
 	case EM2870_BOARD_COMPRO_VIDEOMATE:
@@ -2312,45 +2312,45 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		msleep(10);
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x01);
 		msleep(10);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfc);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfc);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xdc);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xdc);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfc);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfc);
 		mdelay(70);
 		break;
 	case EM2870_BOARD_TERRATEC_XS_MT2060:
 		/* this device needs some gpio writes to get the DVB-T
 		   demod work */
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xde);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
 		break;
 	case EM2870_BOARD_PINNACLE_PCTV_DVB:
 		/* this device needs some gpio writes to get the
 		   DVB-T demod work */
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xde);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
 		mdelay(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
 		break;
 	case EM2820_BOARD_GADMEI_UTV310:
 	case EM2820_BOARD_MSI_VOX_USB_2:
 		/* enables audio for that devices */
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		break;
 
 	case EM2882_BOARD_KWORLD_ATSC_315U:
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		msleep(10);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		msleep(10);
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x00);
 		msleep(10);
@@ -2376,13 +2376,13 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		break;
 
 	case EM2820_BOARD_IODATA_GVMVP_SZ:
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		msleep(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		msleep(10);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfe);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		msleep(70);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		msleep(70);
 		break;
 	}
@@ -2678,12 +2678,12 @@ static void em28xx_card_setup(struct em28xx *dev)
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		em28xx_write_reg(dev, 0x0d, 0x42);
 		msleep(10);
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		msleep(10);
 		break;
 	case EM2820_BOARD_KWORLD_PVRTV2800RF:
 		/* GPIO enables sound on KWORLD PVR TV 2800RF */
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf9);
+		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf9);
 		break;
 	case EM2820_BOARD_UNKNOWN:
 	case EM2800_BOARD_UNKNOWN:
@@ -2899,7 +2899,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	/* Set the default GPO/GPIO for legacy devices */
 	dev->reg_gpo_num = EM2880_R04_GPO;
-	dev->reg_gpio_num = EM28XX_R08_GPIO;
+	dev->reg_gpio_num = EM2820_R08_GPIO_CTRL;
 
 	dev->wait_after_write = 5;
 
@@ -3087,7 +3087,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	if (dev->board.has_msp34xx) {
 		/* Send a reset to other chips via gpio */
-		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
+		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_write_reg - "
 				      "msp34xx(1) failed! error [%d]\n",
@@ -3096,7 +3096,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		}
 		msleep(3);
 
-		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
+		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_write_reg - "
 				      "msp34xx(2) failed! error [%d]\n",
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 69aed82..bb1e8dc 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -487,7 +487,7 @@ static void terratec_h5_init(struct em28xx *dev)
 {
 	int i;
 	struct em28xx_reg_seq terratec_h5_init[] = {
-		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2820_R08_GPIO_CTRL,		0xff,	0xff,	10},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf2,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
@@ -543,7 +543,7 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 	 * 0xb6: unknown (does not affect DVB-T).
 	 */
 	struct em28xx_reg_seq terratec_htc_stick_init[] = {
-		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2820_R08_GPIO_CTRL,		0xff,	0xff,	10},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xe6,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xf6,	0xff,	100},
@@ -590,7 +590,7 @@ static void terratec_htc_usb_xs_init(struct em28xx *dev)
 	int i;
 
 	struct em28xx_reg_seq terratec_htc_usb_xs_init[] = {
-		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2820_R08_GPIO_CTRL,		0xff,	0xff,	10},
 		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	100},
 		{EM2874_R80_GPIO_P0_CTRL,	0xb2,	0xff,	50},
 		{EM2874_R80_GPIO_P0_CTRL,	0xb6,	0xff,	100},
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 0233c5b..af39ddb 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -49,8 +49,9 @@
 
 
 /* GPIO/GPO registers */
-#define EM2880_R04_GPO	0x04    /* em2880-em2883 only */
-#define EM28XX_R08_GPIO	0x08	/* em2820 or upper */
+#define EM2880_R04_GPO		0x04    /* em2880-em2883 only */
+#define EM2820_R08_GPIO_CTRL	0x08	/* em2820-em2873/83 only */
+#define EM2820_R09_GPIO_STATE	0x09	/* em2820-em2873/83 only */
 
 #define EM28XX_R06_I2C_CLK	0x06
 
-- 
1.7.10.4

