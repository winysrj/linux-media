Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:57232 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0AJVWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 16:22:04 -0500
Received: from host73-182.tvk.torun.pl (HELO [192.168.1.100]) (dz-tor@[217.173.182.73])
          (envelope-sender <dz-tor@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 10 Jan 2010 22:15:18 +0100
Message-ID: <4B4A4365.3050900@wp.pl>
Date: Sun, 10 Jan 2010 22:15:17 +0100
From: dz-tor <dz-tor@wp.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dz-tor@wp.pl
Subject: [PATCH] drivers/media/video/saa7134: Add support for Leadtek Winfast
 TV2100 FM card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for Leadtek Winfast TV2100 FM card. Support for remote 
control is missing.

Signed-off-by: Darek Zielski <dz-tor@wp.pl>
---
diff -r dd3338c55018 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c    Sun Jan 10 
10:20:28 2010 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    Sun Jan 10 
21:42:27 2010 +0100
@@ -5359,6 +5359,43 @@
              .vmux = 8,
          } },
      },
+    [SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM] = {
+        .name           = "Leadtek Winfast 2100 FM",
+        .audio_clock    = 0x00187de7,
+        .tuner_type     = TUNER_TNF_5335MF,
+        .radio_type     = UNSET,
+        .tuner_addr    = ADDR_UNSET,
+        .radio_addr    = ADDR_UNSET,
+
+        .gpiomask       = 0x0d,
+        .inputs         = {{
+            .name = name_tv,
+            .vmux = 1,
+            .amux = LINE1,
+            .gpio = 0x00,
+            .tv   = 1,
+        }, {
+            .name = name_comp1,
+            .vmux = 3,
+            .amux = LINE2,
+            .gpio = 0x08,
+        }, {
+            .name = name_svideo,
+            .vmux = 8,
+            .amux = LINE2,
+            .gpio = 0x08,
+        } },
+        .radio = {
+            .name = name_radio,
+            .amux = LINE1,
+            .gpio = 0x04,
+        },
+        .mute = {
+            .name = name_mute,
+            .amux = LINE1,
+            .gpio = 0x08,
+        },
+    },

  };

@@ -6510,6 +6547,12 @@
          .subdevice    = 0x6655,
          .driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
      }, {
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+        .subvendor    = 0x107d,
+        .subdevice    = 0x6f3a,
+        .driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM,
+    }, {
          /* --- boards without eeprom + subsystem ID --- */
          .vendor       = PCI_VENDOR_ID_PHILIPS,
          .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff -r dd3338c55018 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h    Sun Jan 10 10:20:28 
2010 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h    Sun Jan 10 21:42:27 
2010 +0100
@@ -300,6 +300,7 @@
  #define SAA7134_BOARD_ZOLID_HYBRID_PCI        173
  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID    174
  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
+#define SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM 176

  #define SAA7134_MAXBOARDS 32
  #define SAA7134_INPUT_MAX 8


