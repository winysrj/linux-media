Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24KmZQr026533
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 15:48:35 -0500
Received: from gandalf.light-speed.de (gandalf.light-speed.de [87.106.176.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24Km3lm032299
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 15:48:03 -0500
Received: from [192.168.1.123] (pool-198-21-196-89.dbd-ipconnect.net
	[89.196.21.198]) (authenticated bits=0)
	by gandalf.light-speed.de (8.14.2/8.14.2) with ESMTP id m24KlmNx002461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 21:47:50 +0100
Message-ID: <47CDB575.1080706@2moove.de>
Date: Tue, 04 Mar 2008 21:47:49 +0100
From: Daniel Wolf <daniel.wolf@2moove.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [PATCH] Support for DVB-T USB Device Emtec S810
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

Description:

This Patch is for supporting the DVB-T USB Device "Emtec S810". Probably 
it also support the "Intuix S810" device because it appears to be the 
same. But i can´t guarantee it because i don´t have this device physically.

lsusb gives:
Bus 005 Device 002: ID 1164:2edc YUAN High-Tech Development Co., Ltd
------------------------------------------------------

Patch 1:

--- linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h    2008-03-04 
21:24:05.000000000 +0100
+++ linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h_patched    2008-03-04 
21:23:31.000000000 +0100
@@ -46,6 +46,7 @@
 #define USB_VID_ULTIMA_ELECTRONIC        0x05d8
 #define USB_VID_UNIWILL                0x1584
 #define USB_VID_WIDEVIEW            0x14aa
+#define USB_VID_YUANRD           0x1164
 /* dom : pour gigabyte u7000 */
 #define USB_VID_GIGABYTE            0x1044
 
@@ -187,5 +188,6 @@
 #define USB_PID_GIGABYTE_U7000                0x7001
 #define USB_PID_ASUS_U3000                0x171f
 #define USB_PID_ASUS_U3100                0x173f
+#define USB_PID_YUANRD_STK7700D     0x2edc
 
 #endif
--------------------------------------------------------

Patch 2:

--- linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    2008-03-04 
21:24:05.000000000 +0100
+++ linux/drivers/media/dvb/dvb-usb/dib0700_devices.c_patched    
2008-03-04 21:23:05.000000000 +0100
@@ -905,6 +905,7 @@ struct usb_device_id dib0700_usb_id_tabl
         { USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
 /* 25 */    { USB_DEVICE(USB_VID_HAUPPAUGE, 
USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
         { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
+         { USB_DEVICE(USB_VID_YUANRD, USB_PID_YUANRD_STK7700D) },
         { 0 }        /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1123,6 +1124,28 @@ struct dvb_usb_device_properties dib0700
         .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
         .rc_query         = dib0700_rc_query
 
+    },  { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
+        .num_adapters = 1,
+        .adapter = {
+            {
+                .frontend_attach  = stk7070p_frontend_attach,
+                .tuner_attach     = dib7070p_tuner_attach,
+
+                DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+
+                .size_of_priv     = sizeof(struct dib0700_adapter_state),
+            },
+        },
+
+        .num_device_descs = 1,
+        .devices = {
+            {   "Emtec S810",
+                { &dib0700_usb_id_table[27], NULL },
+                { NULL },
+            },
+        },
+
     }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
         .num_adapters = 2,
--------------------------------------------------------------

Signed-off-by: Daniel Wolf <daniel.wolf@2moove.de>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
