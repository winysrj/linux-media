Return-path: <linux-media-owner@vger.kernel.org>
Received: from mrbusi1.netcologne.de ([195.14.230.6]:37356 "EHLO
	mrbusi1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682AbZDHPJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 11:09:08 -0400
Received: from merkur.jueling.ath.cx (xdsl-87-78-142-137.netcologne.de [87.78.142.137])
	by mrbusi1.netcologne.de (Postfix) with ESMTPS id EC6FE1A0033
	for <linux-media@vger.kernel.org>; Wed,  8 Apr 2009 17:03:18 +0200 (CEST)
From: Marcel Jueling <Marcel.Jueling@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0
Date: Wed, 8 Apr 2009 17:03:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081703.07540.Marcel.Jueling@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Marcel Jueling <Marcel@Jueling.de>
# Date 1239055416 -7200
# Node ID 7975c4afd177f5171be54c35b51a7c674b25e666
# Parent 8e6c672abd5690eb89263673a4d312fcc76d26ed
New device: Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0

From: Marcel Jueling <Marcel@Jueling.de>

Signed-off-by: Marcel Jueling <Marcel@Jueling.de>

--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Mon Apr 06 18:01:26 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Tue Apr 07 00:03:36 2009 +0200
@@ -1254,16 +1254,17 @@
 	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_PC160_2T)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X)},
-/* 10 */{USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
+/* 10 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
+	{USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
 	{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGIVOX_DUO)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
 	{USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
-/* 15 */{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGI_VOX_MINI_III)},
+/* 15 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
+	{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGI_VOX_MINI_III)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_2)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_3)},
-	{USB_DEVICE(USB_VID_AFATECH,   USB_PID_TREKSTOR_DVBT)},
+/* 20 */{USB_DEVICE(USB_VID_AFATECH,   USB_PID_TREKSTOR_DVBT)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
 	{0},
 };
@@ -1324,7 +1325,7 @@
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 9,
+		.num_device_descs = 10,
 		.devices = {
 			{
 				.name = "Afatech AF9015 DVB-T USB2.0 stick",
@@ -1372,6 +1373,11 @@
 			{
 				.name = "AVerMedia AVerTV DVB-T Volar X",
 				.cold_ids = {&af9015_usb_table[9], NULL},
+				.warm_ids = {NULL},
+			},
+			{
+				.name = "Conceptronic DVB-T CTVDIGRCU V3.0",
+				.cold_ids = {&af9015_usb_table[10], NULL},
 				.warm_ids = {NULL},
 			},
 		}
@@ -1433,51 +1439,51 @@
 		.devices = {
 			{
 				.name = "Xtensions XD-380",
-				.cold_ids = {&af9015_usb_table[10], NULL},
+				.cold_ids = {&af9015_usb_table[11], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "MSI DIGIVOX Duo",
-				.cold_ids = {&af9015_usb_table[11], NULL},
+				.cold_ids = {&af9015_usb_table[12], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Fujitsu-Siemens Slim Mobile USB DVB-T",
-				.cold_ids = {&af9015_usb_table[12], NULL},
+				.cold_ids = {&af9015_usb_table[13], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Telestar Starstick 2",
-				.cold_ids = {&af9015_usb_table[13], NULL},
+				.cold_ids = {&af9015_usb_table[14], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AVerMedia A309",
-				.cold_ids = {&af9015_usb_table[14], NULL},
+				.cold_ids = {&af9015_usb_table[15], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "MSI Digi VOX mini III",
-				.cold_ids = {&af9015_usb_table[15], NULL},
+				.cold_ids = {&af9015_usb_table[16], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld USB DVB-T TV Stick II " \
 					"(VS-DVB-T 395U)",
-				.cold_ids = {&af9015_usb_table[16],
-					     &af9015_usb_table[17],
-					     &af9015_usb_table[18], NULL},
+				.cold_ids = {&af9015_usb_table[17],
+					     &af9015_usb_table[18],
+					     &af9015_usb_table[19], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TrekStor DVB-T USB Stick",
-				.cold_ids = {&af9015_usb_table[19], NULL},
+				.cold_ids = {&af9015_usb_table[20], NULL},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AverMedia AVerTV Volar Black HD " \
 					"(A850)",
-				.cold_ids = {&af9015_usb_table[20], NULL},
+				.cold_ids = {&af9015_usb_table[21], NULL},
 				.warm_ids = {NULL},
 			},
 		}
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon Apr 06 18:01:26 
2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Apr 07 00:03:36 2009 
+0200
@@ -80,6 +80,7 @@
 #define USB_PID_COMPRO_DVBU2000_UNK_WARM		0x010d
 #define USB_PID_COMPRO_VIDEOMATE_U500			0x1e78
 #define USB_PID_COMPRO_VIDEOMATE_U500_PC		0x1e80
+#define USB_PID_CONCEPTRONIC_CTVDIGRCU			0xe397
 #define USB_PID_CONEXANT_D680_DMB			0x86d6
 #define USB_PID_DIBCOM_HOOK_DEFAULT			0x0064
 #define USB_PID_DIBCOM_HOOK_DEFAULT_REENUM		0x0065
