Return-path: <mchehab@pedra>
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:56453 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab0JDTcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 15:32:51 -0400
Received: from [192.168.2.1] (abo-159-1-69.bdx.modulonet.fr [85.69.1.159])
	by smtp5.tech.numericable.fr (Postfix) with ESMTP id 4C12C124027
	for <linux-media@vger.kernel.org>; Mon,  4 Oct 2010 21:32:48 +0200 (CEST)
Message-ID: <4CAA2BE6.1050302@libertysurf.fr>
Date: Mon, 04 Oct 2010 21:32:54 +0200
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Terratec Cinergy Hybrid T USB XS FR
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  New gpio definitions.
XC3028_FE_ZARLINK456 was not loaded.

Signed-off-by: Michel Garnier<catimimi@libertysurf.fr>

---

diff -Nru v4l-dvb-1da5fed5c8b2-orig/linux/drivers/media/video/em28xx/em28xx-cards.c 
v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c
--- v4l-dvb-1da5fed5c8b2-orig/linux/drivers/media/video/em28xx/em28xx-cards.c    2010-09-19 07:23:09.000000000 +0200
+++ v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c    2010-10-04 19:05:11.000000000 +0200
@@ -200,6 +200,18 @@
      {    -1,        -1,    -1,        -1},
  };

+static struct em28xx_reg_seq terratec_cinergy_USB_XS_analog[] = {
+    {EM28XX_R08_GPIO,    0x6d,    ~EM_GPIO_4,    10},
+    {EM2880_R04_GPO,    0x00,    0xff,        10},
+    { -1,            -1,    -1,        -1},
+};
+
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_digital[] = {
+    {EM28XX_R08_GPIO,    0x6e,    ~EM_GPIO_4,    10},
+    {EM2880_R04_GPO,    0x08,    0xff,        10},
+    { -1,            -1,    -1,        -1},
+};
+
  /* eb1a:2868 Reddo DVB-C USB TV Box
     GPIO4 - CU1216L NIM
     Other GPIOs seems to be don't care. */
@@ -824,22 +836,22 @@
          .tuner_gpio   = default_tuner_gpio,
          .decoder      = EM28XX_TVP5150,
          .has_dvb      = 1,
-        .dvb_gpio     = default_digital,
+        .dvb_gpio     = terratec_cinergy_USB_XS_digital,
          .input        = { {
              .type     = EM28XX_VMUX_TELEVISION,
              .vmux     = TVP5150_COMPOSITE0,
              .amux     = EM28XX_AMUX_VIDEO,
-            .gpio     = default_analog,
+            .gpio     = terratec_cinergy_USB_XS_analog,
          }, {
              .type     = EM28XX_VMUX_COMPOSITE1,
              .vmux     = TVP5150_COMPOSITE1,
              .amux     = EM28XX_AMUX_LINE_IN,
-            .gpio     = default_analog,
+            .gpio     = terratec_cinergy_USB_XS_analog,
          }, {
              .type     = EM28XX_VMUX_SVIDEO,
              .vmux     = TVP5150_SVIDEO,
              .amux     = EM28XX_AMUX_LINE_IN,
-            .gpio     = default_analog,
+            .gpio     = terratec_cinergy_USB_XS_analog,
          } },
      },
      [EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
@@ -2259,6 +2271,7 @@
          ctl->demod = XC3028_FE_ZARLINK456;
          break;
      case EM2880_BOARD_TERRATEC_HYBRID_XS:
+    case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
      case EM2881_BOARD_PINNACLE_HYBRID_PRO:
          ctl->demod = XC3028_FE_ZARLINK456;
          break;

