Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36333 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbCAPFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 10:05:19 -0500
Received: by wghk14 with SMTP id k14so28904317wgh.3
        for <linux-media@vger.kernel.org>; Sun, 01 Mar 2015 07:05:17 -0800 (PST)
Received: from ?IPv6:2001:7e8:c6b2:601:f489:d91f:93de:d8b6? ([2001:7e8:c6b2:601:f489:d91f:93de:d8b6])
        by mx.google.com with ESMTPSA id j5sm11882030wie.3.2015.03.01.07.05.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2015 07:05:16 -0800 (PST)
Message-ID: <54F32A6D.5090909@gmail.com>
Date: Sun, 01 Mar 2015 16:04:13 +0100
From: Gilles Risch <gilles.risch@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] Basic support for the Elgato EyeTV Hybrid INT 2008 USB Stick
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will add basic support for the Elgato EyeTV Hybrid INT
2008 USB Stick.

Signed-off-by: Gilles Risch <gilles.risch@gmail.com>

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c 
b/drivers/media/usb/em28xx/em28xx-cards.c
index d9704e6..3a72188 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1157,6 +1157,15 @@ struct em28xx_board em28xx_boards[] = {
          .i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
                  EM28XX_I2C_FREQ_400_KHZ,
      },
+    [EM2884_BOARD_ELGATO_EYETV_HYBRID_2008] = {
+        .name         = "Elgato EyeTV Hybrid 2008 INT",
+        .has_dvb      = 1,
+        .ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+        .tuner_type   = TUNER_ABSENT,
+        .def_i2c_bus  = 1,
+        .i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
+                EM28XX_I2C_FREQ_400_KHZ,
+    },
      [EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
          .name         = "Hauppauge WinTV HVR 900",
          .tda9887_conf = TDA9887_PRESENT,
@@ -2378,6 +2387,8 @@ struct usb_device_id em28xx_id_table[] = {
              .driver_info = EM2860_BOARD_TERRATEC_GRABBY },
      { USB_DEVICE(0x0ccd, 0x00b2),
              .driver_info = EM2884_BOARD_CINERGY_HTC_STICK },
+    { USB_DEVICE(0x0fd9, 0x0018),
+            .driver_info = EM2884_BOARD_ELGATO_EYETV_HYBRID_2008},
      { USB_DEVICE(0x0fd9, 0x0033),
              .driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
      { USB_DEVICE(0x185b, 0x2870),
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c 
b/drivers/media/usb/em28xx/em28xx-dvb.c
index aee70d4..876c8d4 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -41,7 +41,7 @@
  #include "mt352.h"
  #include "mt352_priv.h" /* FIXME */
  #include "tda1002x.h"
-#include "drx39xyj/drx39xxj.h"
+#include "drx39xxj.h"
  #include "tda18271.h"
  #include "s921.h"
  #include "drxd.h"
@@ -1380,6 +1380,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
              }
          }
          break;
+    case EM2884_BOARD_ELGATO_EYETV_HYBRID_2008:
      case EM2884_BOARD_CINERGY_HTC_STICK:
          terratec_htc_stick_init(dev);

diff --git a/drivers/media/usb/em28xx/em28xx.h 
b/drivers/media/usb/em28xx/em28xx.h
index 9c70753..0ccb32c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -143,6 +143,7 @@
  #define EM28178_BOARD_PCTV_292E                   94
  #define EM2861_BOARD_LEADTEK_VC100                95
  #define EM28178_BOARD_TERRATEC_T2_STICK_HD        96
+#define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008      97

  /* Limits minimum and default number of buffers */
  #define EM28XX_MIN_BUF 4
