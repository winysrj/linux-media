Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:38194 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0FAS7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 14:59:00 -0400
Received: from [192.168.0.101] (mil13-1-88-163-137-134.fbx.proxad.net [88.163.137.134])
	by smtp5-g21.free.fr (Postfix) with ESMTP id C74B7D480E9
	for <linux-media@vger.kernel.org>; Tue,  1 Jun 2010 20:58:52 +0200 (CEST)
Subject: Re: [PATCH] support for medion dvb stick 1660:1921
From: =?ISO-8859-1?Q?St=E9phane?= Elmaleh <stephane.elmaleh@laposte.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Jun 2010 20:58:51 +0200
Message-Id: <1275418731.28407.2.camel@stef-netbook>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick

thank you for your help, I understand my mistake.
Here is the new patch, I hope this one is right.

regards
Stéphane

diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed May 19
19:34:33 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Tue Jun 01
20:28:13 2010 +0200
@@ -2091,6 +2091,7 @@
        { USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV282E) },
        { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
        { USB_DEVICE(USB_VID_ELGATO,
USB_PID_ELGATO_EYETV_DIVERSITY) },
+       { USB_DEVICE(USB_VID_MEDION,    USB_PID_MEDION_STICK_CTX_1921) },
        { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2606,10 +2607,14 @@
                        },
                },
 
-               .num_device_descs = 2,
+               .num_device_descs = 3,
                .devices = {
                        {   "DiBcom STK7770P reference design",
                                { &dib0700_usb_id_table[59], NULL },
+                               { NULL },
+                       },
+                       {   "Medion Stick ctx 1921",
+                               { &dib0700_usb_id_table[69], NULL },
                                { NULL },
                        },
                        {   "Terratec Cinergy T USB XXS (HD)/ T3",
diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Wed May 19
19:34:33
2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Tue Jun 01
20:28:13
2010 +0200
@@ -303,4 +303,5 @@
 #define USB_PID_TERRATEC_DVBS2CI_V2                    0x10ac
 #define USB_PID_TECHNISAT_USB2_HDCI_V1                 0x0001
 #define USB_PID_TECHNISAT_USB2_HDCI_V2                 0x0002
+#define USB_PID_MEDION_STICK_CTX_1921                  0x1921
 #endif


