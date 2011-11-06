Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60558 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1KFWad (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 17:30:33 -0500
Received: by wyh15 with SMTP id 15so3948653wyh.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 14:30:32 -0800 (PST)
Message-ID: <4eb70a87.c6cae30a.09a9.22d4@mx.google.com>
Subject: [PATCH ]Re: Support for Sveon STV22 (IT9137)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Leandro =?ISO-8859-1?Q?Terr=E9s?= <imlordlt@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 06 Nov 2011 22:30:26 +0000
In-Reply-To: <CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
References: <CABb1zhvkLYTZ4zUy7jPh1AH+1XGQRdhsHM7CxK5ADMuuzKHAzg@mail.gmail.com>
	 <CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This indeed a clone of Kworld UB499 2T

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 31b4aa4..07ede26 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -319,6 +319,7 @@
 #define USB_PID_TVWAY_PLUS				0x0002
 #define USB_PID_SVEON_STV20				0xe39d
 #define USB_PID_SVEON_STV22				0xe401
+#define USB_PID_SVEON_STV22_IT9137			0xe411
 #define USB_PID_AZUREWAVE_AZ6027			0x3275
 #define USB_PID_TERRATEC_DVBS2CI_V1			0x10a4
 #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index d4739d1..66b2dcb 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -577,6 +577,7 @@ static int it913x_probe(struct usb_interface *intf,
 static struct usb_device_id it913x_table[] = {
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09) },
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135) },
+	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137) },
 	{}		/* Terminating entry */
 };
 
@@ -652,7 +653,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_codes	= RC_MAP_KWORLD_315U,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
-	.num_device_descs = 2,
+	.num_device_descs = 3,
 	.devices = {
 		{   "Kworld UB499-2T T09(IT9137)",
 			{ &it913x_table[0], NULL },
@@ -660,6 +661,9 @@ static struct dvb_usb_device_properties it913x_properties = {
 		{   "ITE 9135 Generic",
 			{ &it913x_table[1], NULL },
 			},
+		{   "Sveon STV22 Dual DVB-T HDTV(IT9137)",
+			{ &it913x_table[2], NULL },
+			},
 	}
 };
 
-- 
1.7.5.4


