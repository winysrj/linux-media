Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:15868 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935902AbZAPOZt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 09:25:49 -0500
Received: by ey-out-2122.google.com with SMTP id 22so306920eye.37
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 06:25:47 -0800 (PST)
Message-ID: <b24e53350901160625j6d20c8cetfb0bba7f82d6c622@mail.gmail.com>
Date: Fri, 16 Jan 2009 09:25:47 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] em28xx: Fix for KWorld 330U Board
In-Reply-To: <b24e53350901141133i29738777y58de51188fa6364@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901141121v90e533ds13c62f4536a03dfe@mail.gmail.com>
	 <b24e53350901141126s1861444aj928810f7bc428e5f@mail.gmail.com>
	 <b24e53350901141133i29738777y58de51188fa6364@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
12:46:43 2009 -0500
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
diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c     Wed Jan 14
10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c     Wed Jan 14
12:47:00 2009 -0500
@@ -29,6 +29,7 @@

 #include "lgdt330x.h"
 #include "zl10353.h"
+#include "s5h1409.h"
 #ifdef EM28XX_DRX397XD_SUPPORT
 #include "drx397xD.h"
 #endif
@@ -231,6 +232,15 @@
      .no_tuner = 1,
      .parallel_ts = 1,
      .if2 = 45600,
+};
+
+static struct s5h1409_config em28xx_s5h1409_with_xc3028 = {
+       .demod_address = 0x32 >> 1,
+       .output_mode   = S5H1409_PARALLEL_OUTPUT,
+       .gpio          = S5H1409_GPIO_OFF,
+       .inversion     = S5H1409_INVERSION_OFF,
+       .status_mode   = S5H1409_DEMODLOCKING,
+       .mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK
 };

 #ifdef EM28XX_DRX397XD_SUPPORT
@@ -413,7 +423,6 @@
      case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
      case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
      case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
-       case EM2883_BOARD_KWORLD_HYBRID_A316:
      case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
              dvb->frontend = dvb_attach(lgdt330x_attach,
                                         &em2880_lgdt3303_dev,
@@ -434,6 +443,15 @@
                      goto out_free;
              }
              break;
+       case EM2883_BOARD_KWORLD_HYBRID_330U:
+               dvb->frontend = dvb_attach(s5h1409_attach,
+                                          &em28xx_s5h1409_with_xc3028,
+                                          &dev->i2c_adap);
+               if (attach_xc3028(0x61, dev) < 0) {
+                       result = -EINVAL;
+                       goto out_free;
+               }
+               break;
      case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
 #ifdef EM28XX_DRX397XD_SUPPORT
              /* We don't have the config structure properly populated, so
diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-video.c
--- a/linux/drivers/media/video/em28xx/em28xx-video.c   Wed Jan 14
10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-video.c   Wed Jan 14
12:47:00 2009 -0500
@@ -2023,6 +2023,7 @@

 int em28xx_register_analog_devices(struct em28xx *dev)
 {
+    u8 val;
      int ret;

      printk(KERN_INFO "%s: v4l2 driver version %d.%d.%d\n",
@@ -2051,7 +2052,8 @@
      /* enable vbi capturing */

 /*     em28xx_write_reg(dev, EM28XX_R0E_AUDIOSRC, 0xc0); audio register */
-/*     em28xx_write_reg(dev, EM28XX_R0F_XCLK, 0x80); clk register */
+       val = (u8)em28xx_read_reg(dev, EM28XX_R0F_XCLK);
+       em28xx_write_reg(dev, EM28XX_R0F_XCLK,
(EM28XX_XCLK_AUDIO_UNMUTE | val));
      em28xx_write_reg(dev, EM28XX_R11_VINCTRL, 0x51);
 #endif

diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h Wed Jan 14 10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx.h Wed Jan 14 12:47:00 2009 -0500
@@ -95,7 +95,7 @@
 #define EM2882_BOARD_KWORLD_VS_DVBT              54
 #define EM2882_BOARD_TERRATEC_HYBRID_XS                  55
 #define EM2882_BOARD_PINNACLE_HYBRID_PRO         56
-#define EM2883_BOARD_KWORLD_HYBRID_A316                  57
+#define EM2883_BOARD_KWORLD_HYBRID_330U                  57
 #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU     58
 #define EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850     60
 #define EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2
