Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EJRXvO032442
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:27:33 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0EJQgig008362
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:26:43 -0500
Received: by nf-out-0910.google.com with SMTP id d3so111089nfc.21
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 11:26:42 -0800 (PST)
Message-ID: <b24e53350901141126s1861444aj928810f7bc428e5f@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:26:42 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
In-Reply-To: <b24e53350901141121v90e533ds13c62f4536a03dfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901141121v90e533ds13c62f4536a03dfe@mail.gmail.com>
Subject: Fwd: [PATCH 3/4] em28xx: Fix for KWorld 330U Board
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
