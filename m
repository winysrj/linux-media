Return-path: <mchehab@pedra>
Received: from nm6-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.234]:37704 "HELO
	nm6-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752987Ab1FWVh6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 17:37:58 -0400
Received: by iwn6 with SMTP id 6so1914633iwn.19
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 14:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=SM+syVFQOs3_22tGZN1v+AcKGpQ@mail.gmail.com>
References: <BANLkTi=SM+syVFQOs3_22tGZN1v+AcKGpQ@mail.gmail.com>
Date: Thu, 23 Jun 2011 23:37:55 +0200
Message-ID: <BANLkTimSqC3bAyJQneXkmM8Mae5Ono1JLA@mail.gmail.com>
Subject: Fwd: [PATCH] STV22 Dual USB DVB-T Tuner HDTV linux kernel support
From: David <reality_es@yahoo.es>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello:

I expect the patches finally are ok.

This patches add

Signed-off-by: Emilio David Diaus Lopez <reality_es@yahoo.es>
-----------------------------------------

-- ./drivers/media/dvb/dvb-usb/af9015.c.orig    2011-06-21
12:39:44.000000000 +0200
+++ ./drivers/media/dvb/dvb-usb/af9015.c        2011-06-22
12:05:28.000000000 +0200
@@ -749,6 +749,8 @@ static const struct af9015_rc_setup af90
               RC_MAP_AZUREWAVE_AD_TU700 },
       { (USB_VID_MSI_2 << 16) + USB_PID_MSI_DIGI_VOX_MINI_III,
               RC_MAP_MSI_DIGIVOX_III },
+       { (USB_VID_KWORLD_2 << 16) + USB_PID_SVEON_STV22,
+               RC_MAP_MSI_DIGIVOX_III },
       { (USB_VID_LEADTEK << 16) + USB_PID_WINFAST_DTV_DONGLE_GOLD,
               RC_MAP_LEADTEK_Y04G0051 },
       { (USB_VID_AVERMEDIA << 16) + USB_PID_AVERMEDIA_VOLAR_X,
@@ -1309,6 +1311,7 @@ static struct usb_device_id af9015_usb_t
               USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
 /* 35 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
       {USB_DEVICE(USB_VID_GTEK,      USB_PID_TINYTWIN_3)},
+       {USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
       {0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1649,6 +1652,11 @@ static struct dvb_usb_device_properties
                               .warm_ids = {NULL},
                       },
                       {
+                               .name = "Sveon STV22 Dual USB DVB-T
Tuner HDTV ",
+                               .cold_ids = {&af9015_usb_table[37], NULL},
+                               .warm_ids = {NULL},
+                       },
+                       {
                               .name = "Leadtek WinFast DTV2000DS",
                               .cold_ids = {&af9015_usb_table[29], NULL},
                               .warm_ids = {NULL},

------------------------------
--- ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h.orig      2011-06-21
12:39:45.000000000 +0200
+++ ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2011-06-18
11:48:22.000000000 +0200
@@ -128,6 +128,7 @@
 #define USB_PID_INTEL_CE9500                           0x9500
 #define USB_PID_KWORLD_399U                            0xe399
 #define USB_PID_KWORLD_399U_2                          0xe400
+#define USB_PID_SVEON_STV22                            0xe401
 #define USB_PID_KWORLD_395U                            0xe396
 #define USB_PID_KWORLD_395U_2                          0xe39b
 #define USB_PID_KWORLD_395U_3                          0xe395
------------------------
1.1
-----------------------
Thanks for your time

goodbye
Emilio David Diaus López
