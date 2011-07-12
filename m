Return-path: <mchehab@localhost>
Received: from nm17-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.93]:29061 "HELO
	nm17-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753653Ab1GLUdM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 16:33:12 -0400
Received: by iyb12 with SMTP id 12so4983243iyb.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jul 2011 13:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E17CF84.108@iki.fi>
References: <BANLkTi=SM+syVFQOs3_22tGZN1v+AcKGpQ@mail.gmail.com>
	<BANLkTimSqC3bAyJQneXkmM8Mae5Ono1JLA@mail.gmail.com>
	<4E17CF84.108@iki.fi>
Date: Tue, 12 Jul 2011 22:33:08 +0200
Message-ID: <CA+x4LmirEv-+PDUDV=eSXv7fiMJbnz-k7Q7jT3oZOgVvGPF_rw@mail.gmail.com>
Subject: Re: Fwd: [PATCH] STV22 Dual USB DVB-T Tuner HDTV linux kernel support
From: David <reality_es@yahoo.es>
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hello Again:

The new patches are done, please tell me if i have to make any
changes. Thanks for your time.

Signed-off-by: Emilio David Diaus Lopez <reality_es@yahoo.es>
----------------------------------------------
--- ./drivers/media/dvb/dvb-usb/af9015.c.orig    2011-03-22
05:45:24.000000000 +0100
+++ ./drivers/media/dvb/dvb-usb/af9015.c    2011-07-12 22:04:15.612645277 +0200
@@ -759,6 +759,8 @@ static const struct af9015_rc_setup af90
         RC_MAP_DIGITALNOW_TINYTWIN },
     { (USB_VID_GTEK << 16) + USB_PID_TINYTWIN_3,
         RC_MAP_DIGITALNOW_TINYTWIN },
+    { (USB_VID_KWORLD_2 << 16) + USB_PID_SVEON_STV22,
+        RC_MAP_MSI_DIGIVOX_III },
     { }
 };

@@ -1309,6 +1311,7 @@ static struct usb_device_id af9015_usb_t
         USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
 /* 35 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
     {USB_DEVICE(USB_VID_GTEK,      USB_PID_TINYTWIN_3)},
+    {USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
     {0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1502,7 +1505,7 @@ static struct dvb_usb_device_properties

         .i2c_algo = &af9015_i2c_algo,

-        .num_device_descs = 9, /* check max from dvb-usb.h */
+        .num_device_descs = 10, /* check max from dvb-usb.h */
         .devices = {
             {
                 .name = "Xtensions XD-380",
@@ -1554,6 +1557,11 @@ static struct dvb_usb_device_properties
                 .cold_ids = {&af9015_usb_table[20], NULL},
                 .warm_ids = {NULL},
             },
+                        {
+                .name = "Sveon STV22 Dual USB DVB-T Tuner HDTV ",
+                .cold_ids = {&af9015_usb_table[37], NULL},
+                .warm_ids = {NULL},
+            },
         }
     }, {
         .caps = DVB_USB_IS_AN_I2C_ADAPTER,
------------------------
--- ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h.orig    2011-06-08
03:51:23.000000000 +0200
+++ ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h    2011-07-12
22:06:22.432044202 +0200
@@ -315,6 +315,7 @@
 #define USB_PID_FRIIO_WHITE                0x0001
 #define USB_PID_TVWAY_PLUS                0x0002
 #define USB_PID_SVEON_STV20                0xe39d
+#define USB_PID_SVEON_STV22                0xe401
 #define USB_PID_AZUREWAVE_AZ6027            0x3275
 #define USB_PID_TERRATEC_DVBS2CI_V1            0x10a4
 #define USB_PID_TERRATEC_DVBS2CI_V2            0x10ac
----------------------
1.3
-------------------------

regards

Emilio David Diaus López
