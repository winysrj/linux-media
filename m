Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:5768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZKJFfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 00:35:04 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1515508fga.1
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 21:35:08 -0800 (PST)
Date: Tue, 10 Nov 2009 13:37:43 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Add new TV cards of Beholder
Message-ID: <20091110133743.21cb7dc5@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/4EnK_Or6Av.+P+4JDr_57Ua"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/4EnK_Or6Av.+P+4JDr_57Ua
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Add new TV cards of Beholder for autodetect.

diff -r 3919b17dc88e linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Wed Oct 14 12:52:55 2009 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue Nov 10 08:05:15 2009 +0900
@@ -33,6 +33,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
+#include "tuner-xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN			0
 #define TM5600_BOARD_GENERIC			1
@@ -193,6 +194,36 @@
 		},
 		.gpio_addr_tun_reset = TM6000_GPIO_2,
 	},
+	[TM6010_BOARD_BEHOLD_WANDER] = {
+		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6000_GPIO_2,
+	},
+	[TM6010_BOARD_BEHOLD_VOYAGER] = {
+		.name         = "Beholder Voyager TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 0,
+			.has_zl10353  = 0,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6000_GPIO_2,
+	},
+
 };
 
 /* table of devices that work with this driver */
@@ -203,6 +234,8 @@
 	{ USB_DEVICE(0x14aa, 0x0620), .driver_info = TM6000_BOARD_FREECOM_AND_SIMILAR },
 	{ USB_DEVICE(0x06e1, 0xb339), .driver_info = TM6000_BOARD_ADSTECH_MINI_DUAL_TV },
 	{ USB_DEVICE(0x2040, 0x6600), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
+	{ USB_DEVICE(0x6000, 0xdec0), .driver_info = TM6010_BOARD_BEHOLD_WANDER },
+	{ USB_DEVICE(0x6000, 0xdec1), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER },
 	{ },
 };
 
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/4EnK_Or6Av.+P+4JDr_57Ua
Content-Type: text/x-patch; name=behold_usb.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_usb.patch

diff -r 3919b17dc88e linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Wed Oct 14 12:52:55 2009 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue Nov 10 08:05:15 2009 +0900
@@ -33,6 +33,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
+#include "tuner-xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN			0
 #define TM5600_BOARD_GENERIC			1
@@ -193,6 +194,36 @@
 		},
 		.gpio_addr_tun_reset = TM6000_GPIO_2,
 	},
+	[TM6010_BOARD_BEHOLD_WANDER] = {
+		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6000_GPIO_2,
+	},
+	[TM6010_BOARD_BEHOLD_VOYAGER] = {
+		.name         = "Beholder Voyager TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 0,
+			.has_zl10353  = 0,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6000_GPIO_2,
+	},
+
 };
 
 /* table of devices that work with this driver */
@@ -203,6 +234,8 @@
 	{ USB_DEVICE(0x14aa, 0x0620), .driver_info = TM6000_BOARD_FREECOM_AND_SIMILAR },
 	{ USB_DEVICE(0x06e1, 0xb339), .driver_info = TM6000_BOARD_ADSTECH_MINI_DUAL_TV },
 	{ USB_DEVICE(0x2040, 0x6600), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
+	{ USB_DEVICE(0x6000, 0xdec0), .driver_info = TM6010_BOARD_BEHOLD_WANDER },
+	{ USB_DEVICE(0x6000, 0xdec1), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER },
 	{ },
 };
 
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/4EnK_Or6Av.+P+4JDr_57Ua--
