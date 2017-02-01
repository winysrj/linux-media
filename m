Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33620 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdBAU1D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 15:27:03 -0500
MIME-Version: 1.0
From: Piotr Oleszczyk <piotr.oleszczyk@gmail.com>
Date: Wed, 1 Feb 2017 21:26:42 +0100
Message-ID: <CAJQUACEM0eye3AqyyoSAZXNUimV7J5jrw1hDHKi1NrRqGooauw@mail.gmail.com>
Subject: [PATCH] add Hama Hybrid DVB-T Stick support
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding Hama Hybrid DVB-T Stick support. Technically it's the same
device what Terratec Cinergy HT USB XE is.

Signed-off-by: Piotr Oleszczyk <piotr.oleszczyk@gmail.com>

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h
b/drivers/media/dvb-core/dvb-usb-ids.h
index 779f422..c90c344 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -78,6 +78,7 @@
 #define USB_VID_EVOLUTEPC                      0x1e59
 #define USB_VID_AZUREWAVE                      0x13d3
 #define USB_VID_TECHNISAT                      0x14f7
+#define USB_VID_HAMA                           0x147f

 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD                      0xa333
@@ -413,4 +414,5 @@
 #define USB_PID_TURBOX_DTT_2000                         0xd3a4
 #define USB_PID_WINTV_SOLOHD                            0x0264
 #define USB_PID_EVOLVEO_XTRATV_STICK                   0xa115
+#define USB_PID_HAMA_DVBT_HYBRID_STICK                 0x2758
 #endif
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c
b/drivers/media/usb/dvb-usb/dib0700_devices.c
index b29d489..81d7fd4 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3815,6 +3815,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
        { USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
        { USB_DEVICE(USB_VID_PCTV,      USB_PID_DIBCOM_STK8096PVR) },
        { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096PVR) },
+       { USB_DEVICE(USB_VID_HAMA,      USB_PID_HAMA_DVBT_HYBRID) },
        { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -4379,7 +4380,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
                        },
                },

-               .num_device_descs = 9,
+               .num_device_descs = 10,
                .devices = {
                        {   "Terratec Cinergy HT USB XE",
                                { &dib0700_usb_id_table[27], NULL },
@@ -4417,6 +4418,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
                                { &dib0700_usb_id_table[54], NULL },
                                { NULL },
                        },
+                       {   "Hama DVB=T Hybrid USB Stick",
+                               { &dib0700_usb_id_table[85], NULL },
+                               { NULL },
+                       },
                },

                .rc.core = {
