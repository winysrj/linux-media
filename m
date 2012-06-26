Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2FZTek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:34:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 2/4] em28xx: defer probe() if userspace mode is disabled
Date: Tue, 26 Jun 2012 16:34:20 -0300
Message-Id: <1340739262-13747-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1340739262-13747-1-git-send-email-mchehab@redhat.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some em28xx devices with tuner-xc2028, drx-k and drx-d need firmware, in
order to be probed. Defer device probe on those devices, if userspace mode is
disabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |   42 +++++++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx.h       |    1 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 12bc54a..9229cd2 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -776,6 +776,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Terratec Cinergy A Hybrid XS",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 
@@ -800,6 +801,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name	      = "KWorld PVRTV 300U",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -880,6 +882,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Terratec Cinergy T XS",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 	},
 	[EM2870_BOARD_TERRATEC_XS_MT2060] = {
@@ -891,6 +894,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Kworld 350 U DVB-T",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 	},
 	[EM2870_BOARD_KWORLD_355U] = {
@@ -919,6 +923,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Terratec Hybrid XS Secam",
 		.has_msp34xx  = 1,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
@@ -970,6 +975,7 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
+		.needs_firmware = true,
 	},
 	[EM2884_BOARD_CINERGY_HTC_STICK] = {
 		.name         = "Terratec Cinergy HTC Stick",
@@ -979,11 +985,13 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
+		.needs_firmware = true,
 	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
 		.name         = "Hauppauge WinTV HVR 900",
 		.tda9887_conf = TDA9887_PRESENT,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
 		.has_dvb      = 1,
@@ -1011,6 +1019,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Hauppauge WinTV HVR 900 (R2)",
 		.tda9887_conf = TDA9887_PRESENT,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
 		.has_dvb      = 1,
@@ -1037,6 +1046,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850] = {
 		.name           = "Hauppauge WinTV HVR 850",
 		.tuner_type     = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio     = default_tuner_gpio,
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
@@ -1063,6 +1073,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950] = {
 		.name           = "Hauppauge WinTV HVR 950",
 		.tuner_type     = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio     = default_tuner_gpio,
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
@@ -1089,6 +1100,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_PINNACLE_PCTV_HD_PRO] = {
 		.name           = "Pinnacle PCTV HD Pro Stick",
 		.tuner_type     = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
@@ -1115,6 +1127,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600] = {
 		.name           = "AMD ATI TV Wonder HD 600",
 		.tuner_type     = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio     = default_tuner_gpio,
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
@@ -1141,6 +1154,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_TERRATEC_HYBRID_XS] = {
 		.name           = "Terratec Hybrid XS",
 		.tuner_type     = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio     = default_tuner_gpio,
 		.decoder        = EM28XX_TVP5150,
 		.has_dvb        = 1,
@@ -1170,6 +1184,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_TERRATEC_PRODIGY_XS] = {
 		.name         = "Terratec Prodigy XS",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -1412,6 +1427,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "MSI DigiVox A/D",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -1435,6 +1451,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "MSI DigiVox A/D II",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -1457,6 +1474,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_KWORLD_DVB_305U] = {
 		.name	      = "KWorld DVB-T 305U",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -1476,6 +1494,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_KWORLD_DVB_310U] = {
 		.name	      = "KWorld DVB-T 310U",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.has_dvb      = 1,
 		.dvb_gpio     = default_digital,
@@ -1534,6 +1553,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2880_BOARD_EMPIRE_DUAL_TV] = {
 		.name = "Empire dual TV",
 		.tuner_type = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio = default_tuner_gpio,
 		.has_dvb = 1,
 		.dvb_gpio = default_digital,
@@ -1560,6 +1580,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "DNT DA2 Hybrid",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
@@ -1582,6 +1603,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2881_BOARD_PINNACLE_HYBRID_PRO] = {
 		.name         = "Pinnacle Hybrid Pro",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
@@ -1606,6 +1628,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2882_BOARD_PINNACLE_HYBRID_PRO_330E] = {
 		.name         = "Pinnacle Hybrid Pro (330e)",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
 		.has_dvb      = 1,
@@ -1632,6 +1655,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2882_BOARD_KWORLD_VS_DVBT] = {
 		.name         = "Kworld VS-DVB-T 323UR",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.mts_firmware = 1,
@@ -1656,6 +1680,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2882_BOARD_TERRATEC_HYBRID_XS] = {
 		.name         = "Terratec Cinnergy Hybrid T USB XS (em2882)",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
 		.decoder      = EM28XX_TVP5150,
@@ -1683,6 +1708,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2882_BOARD_DIKOM_DK300] = {
 		.name         = "Dikom DK300",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.mts_firmware = 1,
@@ -1698,6 +1724,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2883_BOARD_KWORLD_HYBRID_330U] = {
 		.name         = "Kworld PlusTV HD Hybrid 330",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.mts_firmware = 1,
@@ -1750,6 +1777,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name	      = "Kaiomy TVnPC U2",
 		.vchannels    = 3,
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_addr   = 0x61,
 		.mts_firmware = 1,
 		.decoder      = EM28XX_TVP5150,
@@ -1864,6 +1892,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2882_BOARD_EVGA_INDTUBE] = {
 		.name         = "Evga inDtube",
 		.tuner_type   = TUNER_XC2028,
+		.needs_firmware = true,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
@@ -3133,6 +3162,19 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
 
+	/*
+	 * If the device requires firmware, probe() may need to be
+	 * postponed, as udev may not be ready yet to honour firmware
+	 * load requests.
+	 */
+	if (em28xx_boards[id->driver_info].needs_firmware &&
+	    is_usermodehelp_disabled()) {
+		printk_once(KERN_DEBUG DRIVER_NAME
+		            ": probe deferred for board %d.\n",
+		            (unsigned)id->driver_info);
+		return -EPROBE_DEFER;
+	}
+
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
 	/* Check to see next free device and mark as used */
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 8757523..ed8dc65 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -402,6 +402,7 @@ struct em28xx_board {
 	unsigned int is_webcam:1;
 	unsigned int valid:1;
 	unsigned int has_ir_i2c:1;
+	unsigned int needs_firmware:1;
 
 	unsigned char xclk, i2c_speed;
 	unsigned char radio_addr;
-- 
1.7.10.2

