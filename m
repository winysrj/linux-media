Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39805 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1FFTWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 15:22:45 -0400
Received: by qyk7 with SMTP id 7so962107qyk.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 12:22:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimFT+D3_vZVj5KMiB7jMvq=088Y7A@mail.gmail.com>
References: <BANLkTimFT+D3_vZVj5KMiB7jMvq=088Y7A@mail.gmail.com>
Date: Mon, 6 Jun 2011 21:22:44 +0200
Message-ID: <BANLkTim9d3yi3OQn4AxfwV6pfv+KY-KseA@mail.gmail.com>
Subject: [PATCH] cx231xx: Add support for Hauppauge WinTV USB2-FM
From: Peter Moon <pomoon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for the " Hauppauge WinTV USB2-FM" Analog Stick.

Signed-off-by: Peter Moon <pomoon@gmail.com>

diff -ru linux.orig/drivers/media/video/cx231xx/cx231xx-avcore.c
linux/drivers/media/video/cx231xx/cx231xx-avcore.c
--- linux.orig/drivers/media/video/cx231xx/cx231xx-avcore.c     2011-06-03
21:53:42.000000000 +0200
+++ linux/drivers/media/video/cx231xx/cx231xx-avcore.c  2011-06-03
21:54:13.000000000 +0200
@@ -355,6 +355,7 @@
       case CX231XX_BOARD_HAUPPAUGE_EXETER:
       case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:
       case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+       case CX231XX_BOARD_HAUPPAUGE_USB2_FM:
               if (avmode == POLARIS_AVMODE_ANALOGT_TV) {
                       while (afe_power_status != (FLD_PWRDN_TUNING_BIAS |
                                               FLD_PWRDN_ENABLE_PLL)) {
@@ -1729,6 +1730,7 @@
       case CX231XX_BOARD_CNXT_RDU_250:
       case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
       case CX231XX_BOARD_HAUPPAUGE_EXETER:
+       case CX231XX_BOARD_HAUPPAUGE_USB2_FM:
               func_mode = 0x03;
               break;
       case CX231XX_BOARD_CNXT_RDE_253S:
diff -ru linux.orig/drivers/media/video/cx231xx/cx231xx-cards.c
linux/drivers/media/video/cx231xx/cx231xx-cards.c
--- linux.orig/drivers/media/video/cx231xx/cx231xx-cards.c      2011-06-03
21:53:42.000000000 +0200
+++ linux/drivers/media/video/cx231xx/cx231xx-cards.c   2011-06-03
21:54:13.000000000 +0200
@@ -532,6 +532,41 @@
                       .gpio = NULL,
               } },
       },
+       [CX231XX_BOARD_HAUPPAUGE_USB2_FM] = {
+               .name = "Hauppauge WinTV USB2 FM",
+               .tuner_type = TUNER_NXP_TDA18271,
+               .tuner_addr = 0x60,
+               .tuner_gpio = RDE250_XCV_TUNER,
+               .tuner_sif_gpio = 0x05,
+               .tuner_scl_gpio = 0x1a,
+               .tuner_sda_gpio = 0x1b,
+               .decoder = CX231XX_AVDECODER,
+               .output_mode = OUT_MODE_VIP11,
+               .ctl_pin_status_mask = 0xFFFFFFC4,
+               .agc_analog_digital_select_gpio = 0x0c,
+               .gpio_pin_status_mask = 0x4001000,
+               .tuner_i2c_master = 1,
+               .norm = V4L2_STD_PAL,
+
+               .input = {{
+                       .type = CX231XX_VMUX_TELEVISION,
+                       .vmux = CX231XX_VIN_3_1,
+                       .amux = CX231XX_AMUX_VIDEO,
+                       .gpio = NULL,
+               }, {
+                       .type = CX231XX_VMUX_COMPOSITE1,
+                       .vmux = CX231XX_VIN_2_1,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               }, {
+                       .type = CX231XX_VMUX_SVIDEO,
+                       .vmux = CX231XX_VIN_1_1 |
+                               (CX231XX_VIN_1_2 << 8) |
+                               CX25840_SVIDEO_ON,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               } },
+       },
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);

@@ -553,6 +588,8 @@
        .driver_info = CX231XX_BOARD_CNXT_RDE_250},
       {USB_DEVICE(0x0572, 0x58A0),
        .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+       {USB_DEVICE(0x2040, 0xb110),
+        .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM},
       {USB_DEVICE(0x2040, 0xb120),
        .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
       {USB_DEVICE(0x2040, 0xb140),
diff -ru linux.orig/drivers/media/video/cx231xx/cx231xx-core.c
linux/drivers/media/video/cx231xx/cx231xx-core.c
--- linux.orig/drivers/media/video/cx231xx/cx231xx-core.c       2011-06-03
21:53:42.000000000 +0200
+++ linux/drivers/media/video/cx231xx/cx231xx-core.c    2011-06-03
21:54:13.000000000 +0200
@@ -742,6 +742,7 @@
               case CX231XX_BOARD_CNXT_RDU_253S:
               case CX231XX_BOARD_HAUPPAUGE_EXETER:
               case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+               case CX231XX_BOARD_HAUPPAUGE_USB2_FM:
               errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
                       break;
               default:
@@ -1381,6 +1382,7 @@
       case CX231XX_BOARD_CNXT_RDU_253S:
       case CX231XX_BOARD_HAUPPAUGE_EXETER:
       case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+       case CX231XX_BOARD_HAUPPAUGE_USB2_FM:
       errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
               break;
       default:
diff -ru linux.orig/drivers/media/video/cx231xx/cx231xx.h
linux/drivers/media/video/cx231xx/cx231xx.h
--- linux.orig/drivers/media/video/cx231xx/cx231xx.h    2011-06-03
21:53:42.000000000 +0200
+++ linux/drivers/media/video/cx231xx/cx231xx.h 2011-06-03
21:55:49.000000000 +0200
@@ -67,6 +67,7 @@
 #define CX231XX_BOARD_PV_XCAPTURE_USB 11
 #define CX231XX_BOARD_KWORLD_UB430_USB_HYBRID 12
 #define CX231XX_BOARD_ICONBIT_U100 13
+#define CX231XX_BOARD_HAUPPAUGE_USB2_FM 14

 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
