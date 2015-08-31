Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34019 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbbHaSEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 14:04:55 -0400
MIME-Version: 1.0
Date: Mon, 31 Aug 2015 20:04:53 +0200
Message-ID: <CAB0z4NpRKDQ=yoSxzo5-9mV-5zTcYTan0JvGvugZVKHkH2xkdA@mail.gmail.com>
Subject: [PATCH TRY 2] Support for EVOLVEO XtraTV stick
From: CIJOML CIJOMLovic <cijoml@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

please find out down this email patch to support EVOLVEO XtraTV stick.
This tuner is for android phones with microusb connecter, however with
reduction it works perfectly with linux kernel:
The device identify itself at USB bus as Bus 002 Device 004: ID
1f4d:a115 G-Tek Electronics Group
so I have created new vendor group but device named as its commercial name.

Thank you for merging this patch to upstream

Best regards

Michal


diff -urN media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
media_build.new/linux/drivers/media/dvb-core/dvb-usb-ids.h
--- media_build/linux/drivers/media/dvb-core/dvb-usb-ids.h
2015-05-11 13:20:08.000000000 +0200
+++ media_build.new/linux/drivers/media/dvb-core/dvb-usb-ids.h
2015-06-16 22:26:01.917990493 +0200
@@ -70,6 +70,8 @@
 #define USB_VID_EVOLUTEPC            0x1e59
 #define USB_VID_AZUREWAVE            0x13d3
 #define USB_VID_TECHNISAT            0x14f7
+#define USB_VID_GTEK                0x1f4d
+

 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD            0xa333
@@ -388,4 +390,5 @@
 #define USB_PID_PCTV_2002E_SE                           0x025d
 #define USB_PID_SVEON_STV27                             0xd3af
 #define USB_PID_TURBOX_DTT_2000                         0xd3a4
+#define USB_PID_EVOLVEO_XTRATV_STICK            0xa115
 #endif
diff -urN media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
media_build.new/linux/drivers/media/usb/dvb-usb-v2/af9035.c
--- media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
2015-05-30 17:32:46.000000000 +0200
+++ media_build.new/linux/drivers/media/usb/dvb-usb-v2/af9035.c
2015-06-16 22:26:14.561990868 +0200
@@ -2075,6 +2075,8 @@
         &af9035_props, "PCTV AndroiDTV (78e)", RC_MAP_IT913X_V1) },
     { DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
         &af9035_props, "PCTV microStick (79e)", RC_MAP_IT913X_V2) },
+    { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_EVOLVEO_XTRATV_STICK,
+        &af9035_props, "EVOLVEO XtraTV stick", RC_MAP_IT913X_V2) },

     /* IT930x devices */
     { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
r
