Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EJMpPg029597
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:22:51 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0EJLumv005964
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:21:56 -0500
Received: by ewy14 with SMTP id 14so798375ewy.3
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 11:21:55 -0800 (PST)
Message-ID: <b24e53350901141121v90e533ds13c62f4536a03dfe@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:21:55 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH 3/4] em28xx: Fix for KWorld 330U Board
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

em28xx: Fix for KWorld 330U Board

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Fix for KWorld 330U Board

Many thanks to Devin and Mauro!!!

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Wed Jan 14
10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Wed Jan 14
12:47:00 2009 -0500
@@ -114,6 +114,18 @@
        {  -1,                  -1,     -1,             -1},
 };
 #endif
+
+static struct em28xx_reg_seq kworld_330u_analog[] = {
+       {EM28XX_R08_GPIO,       0x6d,   ~EM_GPIO_4,     10},
+          {EM2880_R04_GPO,        0x00,   0xff,           10},
+       {       -1,             -1,     -1,             -1},
+};
+
+static struct em28xx_reg_seq kworld_330u_digital[] = {
+       {EM28XX_R08_GPIO,       0x6e,   ~EM_GPIO_4,     10},
+       {EM2880_R04_GPO,        0x08,   0xff,           10},
+       {       -1,             -1,     -1,             -1},
+};

 /* Callback for the most boards */
 static struct em28xx_reg_seq default_tuner_gpio[] = {
@@ -1242,29 +1254,33 @@
                        .gpio     = hauppauge_wintv_hvr_900_analog,
                } },
        },
-       [EM2883_BOARD_KWORLD_HYBRID_A316] = {
+       [EM2883_BOARD_KWORLD_HYBRID_330U] = {
                .name         = "Kworld PlusTV HD Hybrid 330",
                .tuner_type   = TUNER_XC2028,
                .tuner_gpio   = default_tuner_gpio,
                .decoder      = EM28XX_TVP5150,
                .mts_firmware = 1,
                .has_dvb      = 1,
-               .dvb_gpio     = default_digital,
+               .dvb_gpio     = kworld_330u_digital,
+               .xclk             = EM28XX_XCLK_FREQUENCY_12MHZ,
+               .i2c_speed        = EM28XX_I2C_CLK_WAIT_ENABLE |
EM28XX_I2C_EEPROM_ON_BOARD | EM28XX_I2C_EEPROM_KEY_VALID,
                .input        = { {
                        .type     = EM28XX_VMUX_TELEVISION,
                        .vmux     = TVP5150_COMPOSITE0,
                        .amux     = EM28XX_AMUX_VIDEO,
-                       .gpio     = default_analog,
+                       .gpio     = kworld_330u_analog,
+                       .aout     = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
                }, {
                        .type     = EM28XX_VMUX_COMPOSITE1,
                        .vmux     = TVP5150_COMPOSITE1,
                        .amux     = EM28XX_AMUX_LINE_IN,
-                       .gpio     = hauppauge_wintv_hvr_900_analog,
+                       .gpio     = kworld_330u_analog,
+                       .aout     = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
                }, {
                        .type     = EM28XX_VMUX_SVIDEO,
                        .vmux     = TVP5150_SVIDEO,
                        .amux     = EM28XX_AMUX_LINE_IN,
-                       .gpio     = hauppauge_wintv_hvr_900_analog,
+                       .gpio     = kworld_330u_analog,
                } },
        },
        [EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU] = {
@@ -1318,7 +1334,7 @@
                        .driver_info = EM2880_BOARD_KWORLD_DVB_310U },
 #endif
        { USB_DEVICE(0xeb1a, 0xa316),
-                       .driver_info = EM2883_BOARD_KWORLD_HYBRID_A316 },
+                       .driver_info = EM2883_BOARD_KWORLD_HYBRID_330U },
        { USB_DEVICE(0xeb1a, 0xe320),
                        .driver_info = EM2880_BOARD_MSI_DIGIVOX_AD_II },
        { USB_DEVICE(0xeb1a, 0xe323),
@@ -1594,6 +1610,10 @@
        case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
                /* FIXME: Better to specify the needed IF */
                ctl->demod = XC3028_FE_DEFAULT;
+               break;
+       case EM2883_BOARD_KWORLD_HYBRID_330U:
+               ctl->demod = XC3028_FE_CHINA;
+               ctl->fname = XC2028_DEFAULT_FIRMWARE;
                break;
        default:
                ctl->demod = XC3028_FE_OREN538;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
