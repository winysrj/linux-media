Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pslib.cesnet.cz ([195.178.64.118] helo=neptun.pslib.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <petr.cvek@pslib.cz>) id 1KTJnh-0007Sb-M6
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 19:06:22 +0200
Received: from opteron.pslib.cz (opteron.pslib.cz [10.200.0.18])
	by neptun.pslib.cz (8.13.1/8.13.1) with ESMTP id m7DH6HMA011043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 19:06:17 +0200
Received: from pslib.cz (localhost.localdomain [127.0.0.1])
	by opteron.pslib.cz (8.13.8/8.13.8) with ESMTP id m7DH6HaI027370
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 19:06:17 +0200
From: "Petr Cvek" <petr.cvek@pslib.cz>
To: linux-dvb@linuxtv.org
Date: Wed, 13 Aug 2008 19:06:17 +0200
Message-Id: <20080813170508.M39801@pslib.cz>
MIME-Version: 1.0
Subject: [linux-dvb] Leadtek Winfast Dongle H (hybrid)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello everyone, I was asked by my friend to help him with his DVB USB card 
(based on STK7700PH): 

Bus 008 Device 005: ID 0413:60f6 Leadtek Research, Inc.

...and I found, that card isn't yet supported, but there is all code for it 
now. 
So I add new device into list:

diff -Naur old/dib0700_devices.c new/dib0700_devices.c
--- old/dib0700_devices.c	2008-08-13 18:55:35.000000000 +0200
+++ new/dib0700_devices.c	2008-08-13 18:26:27.000000000 +0200
@@ -1117,7 +1117,8 @@
 	{ USB_DEVICE(USB_VID_TERRATEC,	
USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS) },
 	{ USB_DEVICE(USB_VID_LEADTEK,   
USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
-	{ USB_DEVICE(USB_VID_HAUPPAUGE, 
USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
+/* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, 
USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
+	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_HYBRID) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1403,7 +1404,7 @@
 			},
 		},
 
-		.num_device_descs = 3,
+		.num_device_descs = 4,
 		.devices = {
 			{   "Terratec Cinergy HT USB XE",
 				{ &dib0700_usb_id_table[27], NULL },
@@ -1417,6 +1418,10 @@
 				{ &dib0700_usb_id_table[32], NULL },
 				{ NULL },
 			},
+			{   "Leadtek Winfast Dongle Hybrid",
+				{ &dib0700_usb_id_table[36], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff -Naur old/dvb-usb-ids.h new/dvb-usb-ids.h
--- old/dvb-usb-ids.h	2008-08-13 18:55:39.000000000 +0200
+++ new/dvb-usb-ids.h	2008-08-13 18:24:55.000000000 +0200
@@ -189,6 +189,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_WARM			0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P		0x6f00
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
+#define USB_PID_WINFAST_DTV_DONGLE_HYBRID		0x60f6
 #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202

After patching, card works as DVB-T reciever (confirmed by someone other with 
this card and with DVB-T signal). This card can receive analog TV too, it has 
cx25843 (cx25840 compatible) chip for it, but there is not any connection 
between this subsystems.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
