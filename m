Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53996 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2AGILd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 03:11:33 -0500
Received: by iaeh11 with SMTP id h11so3856032iae.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jan 2012 00:11:32 -0800 (PST)
Date: Sat, 7 Jan 2012 02:11:27 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Luca Olivetti <luca@ventoso.org>,
	Antti Palosaari <crope@iki.fi>,
	Johannes Stezenbach <js@sig21.net>, linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] af9005, af9015: use symbolic names for USB id
 table indices
Message-ID: <20120107081127.GC10247@elie.hsd1.il.comcast.net>
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de>
 <20111222234446.GB10497@elie.Belkin>
 <201112231820.03693.pboettcher@kernellabs.com>
 <20111223230045.GE21769@elie.Belkin>
 <4F06F512.9090704@redhat.com>
 <20120107080136.GA10247@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107080136.GA10247@elie.hsd1.il.comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The af9005_properties and af9015_properties tables make use of USB ids
from the USB id tables with hardcoded indices, as in
"&af9015_usb_table[30]".  Adding new entries before the end breaks
such references, so everyone has had to carefully tiptoe to only add
entries at the end of the list.

In the spirit of "dw2102: use symbolic names for dw2102_table
indices", use C99-style initializers with symbolic names for each
index to avoid this.  In the new regime, properties tables referring
to the USB ids have names like "&af9015_usb_table[CINERGY_T_STICK_RC]"
that do not change meaning when items in the USB id table are
reordered.

Encouraged-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9005.c |   23 ++-
 drivers/media/dvb/dvb-usb/af9015.c |  316 +++++++++++++++++++++++++++---------
 2 files changed, 252 insertions(+), 87 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index bd51a764351b..5d5e32f4e99d 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -977,11 +977,20 @@ static int af9005_usb_probe(struct usb_interface *intf,
 				   THIS_MODULE, NULL, adapter_nr);
 }
 
+enum af9005_usb_table_entry {
+	AFATECH_AF9005,
+	TERRATEC_AF9005,
+	ANSONIC_AF9005,
+};
+
 static struct usb_device_id af9005_usb_table[] = {
-	{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9005)},
-	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_USB_XE)},
-	{USB_DEVICE(USB_VID_ANSONIC, USB_PID_ANSONIC_DVBT_USB)},
-	{0},
+	[AFATECH_AF9005] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9005)},
+	[TERRATEC_AF9005] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_CINERGY_T_USB_XE)},
+	[ANSONIC_AF9005] = {USB_DEVICE(USB_VID_ANSONIC,
+				USB_PID_ANSONIC_DVBT_USB)},
+	{ }
 };
 
 MODULE_DEVICE_TABLE(usb, af9005_usb_table);
@@ -1041,15 +1050,15 @@ static struct dvb_usb_device_properties af9005_properties = {
 	.num_device_descs = 3,
 	.devices = {
 		    {.name = "Afatech DVB-T USB1.1 stick",
-		     .cold_ids = {&af9005_usb_table[0], NULL},
+		     .cold_ids = {&af9005_usb_table[AFATECH_AF9005], NULL},
 		     .warm_ids = {NULL},
 		     },
 		    {.name = "TerraTec Cinergy T USB XE",
-		     .cold_ids = {&af9005_usb_table[1], NULL},
+		     .cold_ids = {&af9005_usb_table[TERRATEC_AF9005], NULL},
 		     .warm_ids = {NULL},
 		     },
 		    {.name = "Ansonic DVB-T USB1.1 stick",
-		     .cold_ids = {&af9005_usb_table[2], NULL},
+		     .cold_ids = {&af9005_usb_table[ANSONIC_AF9005], NULL},
 		     .warm_ids = {NULL},
 		     },
 		    {NULL},
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 7959053d54ed..e755d7637c22 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1343,49 +1343,112 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	return ret;
 }
 
+enum af9015_usb_table_entry {
+	AFATECH_9015,
+	AFATECH_9016,
+	WINFAST_DTV_GOLD,
+	PINNACLE_PCTV_71E,
+	KWORLD_PLUSTV_399U,
+	TINYTWIN,
+	AZUREWAVE_TU700,
+	TERRATEC_AF9015,
+	KWORLD_PLUSTV_PC160,
+	AVERTV_VOLAR_X,
+	XTENSIONS_380U,
+	MSI_DIGIVOX_DUO,
+	AVERTV_VOLAR_X_REV2,
+	TELESTAR_STARSTICK_2,
+	AVERMEDIA_A309_USB,
+	MSI_DIGIVOX_MINI_III,
+	KWORLD_E396,
+	KWORLD_E39B,
+	KWORLD_E395,
+	TREKSTOR_DVBT,
+	AVERTV_A850,
+	AVERTV_A805,
+	CONCEPTRONIC_CTVDIGRCU,
+	KWORLD_MC810,
+	GENIUS_TVGO_DVB_T03,
+	KWORLD_399U_2,
+	KWORLD_PC160_T,
+	SVEON_STV20,
+	TINYTWIN_2,
+	WINFAST_DTV2000DS,
+	KWORLD_UB383_T,
+	KWORLD_E39A,
+	AVERMEDIA_A815M,
+	CINERGY_T_STICK_RC,
+	CINERGY_T_DUAL_RC,
+	AVERTV_A850T,
+	TINYTWIN_3,
+	SVEON_STV22,
+};
+
 static struct usb_device_id af9015_usb_table[] = {
-/*  0 */{USB_DEVICE(USB_VID_AFATECH,   USB_PID_AFATECH_AF9015_9015)},
-	{USB_DEVICE(USB_VID_AFATECH,   USB_PID_AFATECH_AF9015_9016)},
-	{USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_GOLD)},
-	{USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV71E)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_399U)},
-/*  5 */{USB_DEVICE(USB_VID_VISIONPLUS,
-		USB_PID_TINYTWIN)},
-	{USB_DEVICE(USB_VID_VISIONPLUS,
-		USB_PID_AZUREWAVE_AD_TU700)},
-	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_PC160_2T)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X)},
-/* 10 */{USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
-	{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGIVOX_DUO)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
-	{USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
-/* 15 */{USB_DEVICE(USB_VID_MSI_2,     USB_PID_MSI_DIGI_VOX_MINI_III)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_2)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_3)},
-	{USB_DEVICE(USB_VID_AFATECH,   USB_PID_TREKSTOR_DVBT)},
-/* 20 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A805)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_MC810)},
-	{USB_DEVICE(USB_VID_KYE,       USB_PID_GENIUS_TVGO_DVB_T03)},
-/* 25 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_399U_2)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_PC160_T)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV20)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_TINYTWIN_2)},
-	{USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV2000DS)},
-/* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_4)},
-	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A815M)},
-	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
-	{USB_DEVICE(USB_VID_TERRATEC,
-		USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
-/* 35 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
-	{USB_DEVICE(USB_VID_GTEK,      USB_PID_TINYTWIN_3)},
-	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
-	{0},
+	[AFATECH_9015] =
+		{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9015)},
+	[AFATECH_9016] =
+		{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9016)},
+	[WINFAST_DTV_GOLD] =
+		{USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_GOLD)},
+	[PINNACLE_PCTV_71E] =
+		{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PINNACLE_PCTV71E)},
+	[KWORLD_PLUSTV_399U] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U)},
+	[TINYTWIN] = {USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TINYTWIN)},
+	[AZUREWAVE_TU700] =
+		{USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_AZUREWAVE_AD_TU700)},
+	[TERRATEC_AF9015] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2)},
+	[KWORLD_PLUSTV_PC160] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_2T)},
+	[AVERTV_VOLAR_X] =
+		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X)},
+	[XTENSIONS_380U] =
+		{USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
+	[MSI_DIGIVOX_DUO] =
+		{USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGIVOX_DUO)},
+	[AVERTV_VOLAR_X_REV2] =
+		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
+	[TELESTAR_STARSTICK_2] =
+		{USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
+	[AVERMEDIA_A309_USB] =
+		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
+	[MSI_DIGIVOX_MINI_III] =
+		{USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGI_VOX_MINI_III)},
+	[KWORLD_E396] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U)},
+	[KWORLD_E39B] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_2)},
+	[KWORLD_E395] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_3)},
+	[TREKSTOR_DVBT] = {USB_DEVICE(USB_VID_AFATECH, USB_PID_TREKSTOR_DVBT)},
+	[AVERTV_A850] = {USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
+	[AVERTV_A805] = {USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A805)},
+	[CONCEPTRONIC_CTVDIGRCU] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CONCEPTRONIC_CTVDIGRCU)},
+	[KWORLD_MC810] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_MC810)},
+	[GENIUS_TVGO_DVB_T03] =
+		{USB_DEVICE(USB_VID_KYE, USB_PID_GENIUS_TVGO_DVB_T03)},
+	[KWORLD_399U_2] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U_2)},
+	[KWORLD_PC160_T] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_T)},
+	[SVEON_STV20] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20)},
+	[TINYTWIN_2] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_TINYTWIN_2)},
+	[WINFAST_DTV2000DS] =
+		{USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV2000DS)},
+	[KWORLD_UB383_T] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB383_T)},
+	[KWORLD_E39A] =
+		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_4)},
+	[AVERMEDIA_A815M] =
+		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A815M)},
+	[CINERGY_T_STICK_RC] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
+	[CINERGY_T_DUAL_RC] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
+	[AVERTV_A850T] =
+		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
+	[TINYTWIN_3] = {USB_DEVICE(USB_VID_GTEK, USB_PID_TINYTWIN_3)},
+	[SVEON_STV22] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22)},
+	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
 
@@ -1460,68 +1523,104 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.devices = {
 			{
 				.name = "Afatech AF9015 DVB-T USB2.0 stick",
-				.cold_ids = {&af9015_usb_table[0],
-					     &af9015_usb_table[1], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AFATECH_9015],
+					&af9015_usb_table[AFATECH_9016],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Leadtek WinFast DTV Dongle Gold",
-				.cold_ids = {&af9015_usb_table[2], NULL},
+				.cold_ids = {
+					&af9015_usb_table[WINFAST_DTV_GOLD],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Pinnacle PCTV 71e",
-				.cold_ids = {&af9015_usb_table[3], NULL},
+				.cold_ids = {
+					&af9015_usb_table[PINNACLE_PCTV_71E],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld PlusTV Dual DVB-T Stick " \
 					"(DVB-T 399U)",
-				.cold_ids = {&af9015_usb_table[4],
-					     &af9015_usb_table[25], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_PLUSTV_399U],
+					&af9015_usb_table[KWORLD_399U_2],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "DigitalNow TinyTwin DVB-T Receiver",
-				.cold_ids = {&af9015_usb_table[5],
-					     &af9015_usb_table[28],
-					     &af9015_usb_table[36], NULL},
+				.cold_ids = {
+					&af9015_usb_table[TINYTWIN],
+					&af9015_usb_table[TINYTWIN_2],
+					&af9015_usb_table[TINYTWIN_3],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TwinHan AzureWave AD-TU700(704J)",
-				.cold_ids = {&af9015_usb_table[6], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AZUREWAVE_TU700],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TerraTec Cinergy T USB XE",
-				.cold_ids = {&af9015_usb_table[7], NULL},
+				.cold_ids = {
+					&af9015_usb_table[TERRATEC_AF9015],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld PlusTV Dual DVB-T PCI " \
 					"(DVB-T PC160-2T)",
-				.cold_ids = {&af9015_usb_table[8], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_PLUSTV_PC160],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AVerMedia AVerTV DVB-T Volar X",
-				.cold_ids = {&af9015_usb_table[9], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERTV_VOLAR_X],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TerraTec Cinergy T Stick RC",
-				.cold_ids = {&af9015_usb_table[33], NULL},
+				.cold_ids = {
+					&af9015_usb_table[CINERGY_T_STICK_RC],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TerraTec Cinergy T Stick Dual RC",
-				.cold_ids = {&af9015_usb_table[34], NULL},
+				.cold_ids = {
+					&af9015_usb_table[CINERGY_T_DUAL_RC],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AverMedia AVerTV Red HD+ (A850T)",
-				.cold_ids = {&af9015_usb_table[35], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERTV_A850T],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 		}
@@ -1594,57 +1693,87 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.devices = {
 			{
 				.name = "Xtensions XD-380",
-				.cold_ids = {&af9015_usb_table[10], NULL},
+				.cold_ids = {
+					&af9015_usb_table[XTENSIONS_380U],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "MSI DIGIVOX Duo",
-				.cold_ids = {&af9015_usb_table[11], NULL},
+				.cold_ids = {
+					&af9015_usb_table[MSI_DIGIVOX_DUO],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Fujitsu-Siemens Slim Mobile USB DVB-T",
-				.cold_ids = {&af9015_usb_table[12], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERTV_VOLAR_X_REV2],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Telestar Starstick 2",
-				.cold_ids = {&af9015_usb_table[13], NULL},
+				.cold_ids = {
+					&af9015_usb_table[TELESTAR_STARSTICK_2],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AVerMedia A309",
-				.cold_ids = {&af9015_usb_table[14], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERMEDIA_A309_USB],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "MSI Digi VOX mini III",
-				.cold_ids = {&af9015_usb_table[15], NULL},
+				.cold_ids = {
+					&af9015_usb_table[MSI_DIGIVOX_MINI_III],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld USB DVB-T TV Stick II " \
 					"(VS-DVB-T 395U)",
-				.cold_ids = {&af9015_usb_table[16],
-					     &af9015_usb_table[17],
-					     &af9015_usb_table[18],
-					     &af9015_usb_table[31], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_E396],
+					&af9015_usb_table[KWORLD_E39B],
+					&af9015_usb_table[KWORLD_E395],
+					&af9015_usb_table[KWORLD_E39A],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "TrekStor DVB-T USB Stick",
-				.cold_ids = {&af9015_usb_table[19], NULL},
+				.cold_ids = {
+					&af9015_usb_table[TREKSTOR_DVBT],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AverMedia AVerTV Volar Black HD " \
 					"(A850)",
-				.cold_ids = {&af9015_usb_table[20], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERTV_A850],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Sveon STV22 Dual USB DVB-T Tuner HDTV",
-				.cold_ids = {&af9015_usb_table[37], NULL},
+				.cold_ids = {
+					&af9015_usb_table[SVEON_STV22],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 		}
@@ -1717,50 +1846,77 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.devices = {
 			{
 				.name = "AverMedia AVerTV Volar GPS 805 (A805)",
-				.cold_ids = {&af9015_usb_table[21], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERTV_A805],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Conceptronic USB2.0 DVB-T CTVDIGRCU " \
 					"V3.0",
-				.cold_ids = {&af9015_usb_table[22], NULL},
+				.cold_ids = {
+					&af9015_usb_table[CONCEPTRONIC_CTVDIGRCU],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld Digial MC-810",
-				.cold_ids = {&af9015_usb_table[23], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_MC810],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Genius TVGo DVB-T03",
-				.cold_ids = {&af9015_usb_table[24], NULL},
+				.cold_ids = {
+					&af9015_usb_table[GENIUS_TVGO_DVB_T03],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld PlusTV DVB-T PCI Pro Card " \
 					"(DVB-T PC160-T)",
-				.cold_ids = {&af9015_usb_table[26], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_PC160_T],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Sveon STV20 Tuner USB DVB-T HDTV",
-				.cold_ids = {&af9015_usb_table[27], NULL},
+				.cold_ids = {
+					&af9015_usb_table[SVEON_STV20],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "Leadtek WinFast DTV2000DS",
-				.cold_ids = {&af9015_usb_table[29], NULL},
+				.cold_ids = {
+					&af9015_usb_table[WINFAST_DTV2000DS],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "KWorld USB DVB-T Stick Mobile " \
 					"(UB383-T)",
-				.cold_ids = {&af9015_usb_table[30], NULL},
+				.cold_ids = {
+					&af9015_usb_table[KWORLD_UB383_T],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 			{
 				.name = "AverMedia AVerTV Volar M (A815Mac)",
-				.cold_ids = {&af9015_usb_table[32], NULL},
+				.cold_ids = {
+					&af9015_usb_table[AVERMEDIA_A815M],
+					NULL
+				},
 				.warm_ids = {NULL},
 			},
 		}
-- 
1.7.8.3

