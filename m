Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:33092 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754183Ab0HHPEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Aug 2010 11:04:53 -0400
Message-ID: <4C5EC776.1040001@gmx.de>
Date: Sun, 08 Aug 2010 17:04:22 +0200
From: Alf Fahland <alf-f@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH]  USB DVB-T Stick CTX1921 Chipset DIB7770
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following small patch adds support for USB DVB-T device Creatix 
CTX1921(DIB7770):

diff -r c9cb8918dcb2 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Tue Jun 01 
12:47:42 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Sun Aug 08 
16:49:40 2010 +0200
@@ -2091,6 +2091,7 @@
         { USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV282E) },
         { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
         { USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY) },
+       { USB_DEVICE(USB_VID_MEDION,    USB_PID_CREATIX_CTX1921) },
         { 0 }           /* Terminating entry */
  };
  MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2606,7 +2607,7 @@
                         },
                 },

-               .num_device_descs = 2,
+               .num_device_descs = 3,
                 .devices = {
                         {   "DiBcom STK7770P reference design",
                                 { &dib0700_usb_id_table[59], NULL },
@@ -2618,6 +2619,10 @@
&dib0700_usb_id_table[60], NULL},
                                 { NULL },
                         },
+                       {   "Medion CTX1921 DVB-T USB",
+                               { &dib0700_usb_id_table[69], NULL },
+                               { NULL },
+                       },
                 },
                 .rc_interval      = DEFAULT_RC_INTERVAL,
                 .rc_key_map       = ir_codes_dib0700_table,
diff -r c9cb8918dcb2 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Tue Jun 01 
12:47:42 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Sun Aug 08 
16:49:40 2010 +0200
@@ -107,6 +107,7 @@
  #define USB_PID_DIBCOM_STK8096GP                        0x1fa0
  #define USB_PID_DIBCOM_ANCHOR_2135_COLD                        0x2131
  #define USB_PID_DIBCOM_STK7770P                                0x1e80
+#define USB_PID_CREATIX_CTX1921                                0x1921
  #define USB_PID_DPOSH_M9206_COLD                       0x9206
  #define USB_PID_DPOSH_M9206_WARM                       0xa090
  #define USB_PID_E3C_EC168                              0x1689

