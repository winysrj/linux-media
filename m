Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1GAOHn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 10:07:43 -0400
Message-ID: <4E0DD4A9.8010308@redhat.com>
Date: Fri, 01 Jul 2011 11:07:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: oravecz@nytud.hu
Subject: [PATCH] Enable audio at MSI Digivox AD II card
References: <201107011102.p61B2pX09363@ny01.nytud.hu>
In-Reply-To: <201107011102.p61B2pX09363@ny01.nytud.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This device also uses audio on a separate USB interface. The new audio
handling works fine, but the GPIO settings, and I2C/XCLK speed need
some fixes.

Thanks to Oravecz to diagnose and get the right configs for the registers.

Reported-by: Oravecz Csaba <oravecz@nytud.hu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

I'm waiting for Oravecz confirmation that this patch works like the changes he
originally made, but I'm forwarding the patch to the ML, in order to keep it
tracked via patchwork, and to allow others to test it.


diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index c892a1e..e9bb267 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -107,16 +107,20 @@ static struct em28xx_reg_seq hauppauge_wintv_hvr_900R2_digital[] = {
 	{ -1,			-1,	-1,		-1},
 };
 
-/* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
+/* Board EM2880 MSI DIGIVOX AD */
 static struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
 	{EM28XX_R08_GPIO,       0x69,   ~EM_GPIO_4,	 10},
 	{	-1,		-1,	-1,		 -1},
 };
 
-/* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
-
-/* Board  - EM2870 Kworld 355u
-   Analog - No input analog */
+/* Board EM2880_BOARD_MSI_DIGIVOX_AD_II */
+static struct em28xx_reg_seq em2880_msi_digivox_ad_ii_analog[] = {
+	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM28XX_R08_GPIO,	0x7d,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x00,	0xff,		10},
+	{EM2880_R04_GPO,	0x08,	0xff,		10},
+	{	-1,		-1,	-1,		 -1},
+};
 
 /* Board - EM2882 Kworld 315U digital */
 static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
@@ -1299,22 +1303,26 @@ struct em28xx_board em28xx_boards[] = {
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
+		.i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE |
+				  EM28XX_I2C_EEPROM_ON_BOARD |
+				  EM28XX_I2C_EEPROM_KEY_VALID,
+		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.gpio     = em2880_msi_digivox_ad_analog,
+			.gpio     = em2880_msi_digivox_ad_ii_analog,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = em2880_msi_digivox_ad_analog,
+			.gpio     = em2880_msi_digivox_ad_ii_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = em2880_msi_digivox_ad_analog,
+			.gpio     = em2880_msi_digivox_ad_ii_analog,
 		} },
 	},
 	[EM2880_BOARD_KWORLD_DVB_305U] = {

