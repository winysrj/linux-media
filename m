Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33416 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab2EHKEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 May 2012 06:04:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9015: various small changes and clean-ups
Date: Tue,  8 May 2012 13:04:24 +0300
Message-Id: <1336471464-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean-up dvb_usb_device_properties and fix errors
reported by checkpatch.pl.

Some other very minor changes. Functionality remains
untouched.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9015.c |  495 +++++++++++++++--------------------
 1 files changed, 212 insertions(+), 283 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 7e70ea5..677fed7 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -244,8 +244,7 @@ static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	u8 uninitialized_var(mbox), addr_len;
 	struct req_t req;
 
-/* TODO: implement bus lock
-
+/*
 The bus lock is needed because there is two tuners both using same I2C-address.
 Due to that the only way to select correct tuner is use demodulator I2C-gate.
 
@@ -789,7 +788,7 @@ static void af9015_set_remote_config(struct usb_device *udev,
 	/* try to load remote based USB ID */
 	if (!props->rc.core.rc_codes)
 		props->rc.core.rc_codes = af9015_rc_setup_match(
-			(vid << 16) + pid, af9015_rc_setup_usbids);
+			(vid << 16) | pid, af9015_rc_setup_usbids);
 
 	/* try to load remote based USB iManufacturer string */
 	if (!props->rc.core.rc_codes && vid == USB_VID_AFATECH) {
@@ -1220,8 +1219,8 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach demodulator */
-	adap->fe_adap[0].fe = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
-		&adap->dev->i2c_adap);
+	adap->fe_adap[0].fe = dvb_attach(af9013_attach,
+		&af9015_af9013_config[adap->id], &adap->dev->i2c_adap);
 
 	/*
 	 * AF9015 firmware does not like if it gets interrupted by I2C adapter
@@ -1324,14 +1323,15 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	switch (af9015_af9013_config[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
 	case AF9013_TUNER_MT2060_2:
-		ret = dvb_attach(mt2060_attach, adap->fe_adap[0].fe, &adap->dev->i2c_adap,
-			&af9015_mt2060_config,
+		ret = dvb_attach(mt2060_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, &af9015_mt2060_config,
 			af9015_config.mt2060_if1[adap->id])
 			== NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_QT1010:
 	case AF9013_TUNER_QT1010A:
-		ret = dvb_attach(qt1010_attach, adap->fe_adap[0].fe, &adap->dev->i2c_adap,
+		ret = dvb_attach(qt1010_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap,
 			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18271:
@@ -1434,69 +1434,85 @@ enum af9015_usb_table_entry {
 };
 
 static struct usb_device_id af9015_usb_table[] = {
-	[AFATECH_9015] =
-		{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9015)},
-	[AFATECH_9016] =
-		{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9016)},
-	[WINFAST_DTV_GOLD] =
-		{USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_GOLD)},
-	[PINNACLE_PCTV_71E] =
-		{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PINNACLE_PCTV71E)},
-	[KWORLD_PLUSTV_399U] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U)},
-	[TINYTWIN] = {USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TINYTWIN)},
-	[AZUREWAVE_TU700] =
-		{USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_AZUREWAVE_AD_TU700)},
-	[TERRATEC_AF9015] = {USB_DEVICE(USB_VID_TERRATEC,
+	[AFATECH_9015] = {
+		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9015)},
+	[AFATECH_9016] = {
+		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9016)},
+	[WINFAST_DTV_GOLD] = {
+		USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_GOLD)},
+	[PINNACLE_PCTV_71E] = {
+		USB_DEVICE(USB_VID_PINNACLE, USB_PID_PINNACLE_PCTV71E)},
+	[KWORLD_PLUSTV_399U] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U)},
+	[TINYTWIN] = {
+		USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TINYTWIN)},
+	[AZUREWAVE_TU700] = {
+		USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_AZUREWAVE_AD_TU700)},
+	[TERRATEC_AF9015] = {
+		USB_DEVICE(USB_VID_TERRATEC,
 				USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2)},
-	[KWORLD_PLUSTV_PC160] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_2T)},
-	[AVERTV_VOLAR_X] =
-		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X)},
-	[XTENSIONS_380U] =
-		{USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
-	[MSI_DIGIVOX_DUO] =
-		{USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGIVOX_DUO)},
-	[AVERTV_VOLAR_X_REV2] =
-		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
-	[TELESTAR_STARSTICK_2] =
-		{USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
-	[AVERMEDIA_A309_USB] =
-		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
-	[MSI_DIGIVOX_MINI_III] =
-		{USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGI_VOX_MINI_III)},
-	[KWORLD_E396] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U)},
-	[KWORLD_E39B] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_2)},
-	[KWORLD_E395] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_3)},
-	[TREKSTOR_DVBT] = {USB_DEVICE(USB_VID_AFATECH, USB_PID_TREKSTOR_DVBT)},
-	[AVERTV_A850] = {USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
-	[AVERTV_A805] = {USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A805)},
-	[CONCEPTRONIC_CTVDIGRCU] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CONCEPTRONIC_CTVDIGRCU)},
-	[KWORLD_MC810] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_MC810)},
-	[GENIUS_TVGO_DVB_T03] =
-		{USB_DEVICE(USB_VID_KYE, USB_PID_GENIUS_TVGO_DVB_T03)},
-	[KWORLD_399U_2] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U_2)},
-	[KWORLD_PC160_T] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_T)},
-	[SVEON_STV20] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20)},
-	[TINYTWIN_2] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_TINYTWIN_2)},
-	[WINFAST_DTV2000DS] =
-		{USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV2000DS)},
-	[KWORLD_UB383_T] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB383_T)},
-	[KWORLD_E39A] =
-		{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_4)},
-	[AVERMEDIA_A815M] =
-		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A815M)},
-	[CINERGY_T_STICK_RC] = {USB_DEVICE(USB_VID_TERRATEC,
+	[KWORLD_PLUSTV_PC160] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_2T)},
+	[AVERTV_VOLAR_X] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X)},
+	[XTENSIONS_380U] = {
+		USB_DEVICE(USB_VID_XTENSIONS, USB_PID_XTENSIONS_XD_380)},
+	[MSI_DIGIVOX_DUO] = {
+		USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGIVOX_DUO)},
+	[AVERTV_VOLAR_X_REV2] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_X_2)},
+	[TELESTAR_STARSTICK_2] = {
+		USB_DEVICE(USB_VID_TELESTAR,  USB_PID_TELESTAR_STARSTICK_2)},
+	[AVERMEDIA_A309_USB] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A309)},
+	[MSI_DIGIVOX_MINI_III] = {
+		USB_DEVICE(USB_VID_MSI_2, USB_PID_MSI_DIGI_VOX_MINI_III)},
+	[KWORLD_E396] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U)},
+	[KWORLD_E39B] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_2)},
+	[KWORLD_E395] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_3)},
+	[TREKSTOR_DVBT] = {
+		USB_DEVICE(USB_VID_AFATECH, USB_PID_TREKSTOR_DVBT)},
+	[AVERTV_A850] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
+	[AVERTV_A805] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A805)},
+	[CONCEPTRONIC_CTVDIGRCU] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CONCEPTRONIC_CTVDIGRCU)},
+	[KWORLD_MC810] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_MC810)},
+	[GENIUS_TVGO_DVB_T03] = {
+		USB_DEVICE(USB_VID_KYE, USB_PID_GENIUS_TVGO_DVB_T03)},
+	[KWORLD_399U_2] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_399U_2)},
+	[KWORLD_PC160_T] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_PC160_T)},
+	[SVEON_STV20] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20)},
+	[TINYTWIN_2] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_TINYTWIN_2)},
+	[WINFAST_DTV2000DS] = {
+		USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV2000DS)},
+	[KWORLD_UB383_T] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB383_T)},
+	[KWORLD_E39A] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_395U_4)},
+	[AVERMEDIA_A815M] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A815M)},
+	[CINERGY_T_STICK_RC] = {
+		USB_DEVICE(USB_VID_TERRATEC,
 				USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
-	[CINERGY_T_DUAL_RC] = {USB_DEVICE(USB_VID_TERRATEC,
+	[CINERGY_T_DUAL_RC] = {
+		USB_DEVICE(USB_VID_TERRATEC,
 				USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
-	[AVERTV_A850T] =
-		{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
-	[TINYTWIN_3] = {USB_DEVICE(USB_VID_GTEK, USB_PID_TINYTWIN_3)},
-	[SVEON_STV22] = {USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22)},
+	[AVERTV_A850T] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
+	[TINYTWIN_3] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_TINYTWIN_3)},
+	[SVEON_STV22] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22)},
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1516,43 +1532,44 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-
-				.pid_filter_count = 32,
-				.pid_filter       = af9015_pid_filter,
-				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
-
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x84,
+				.num_frontends = 1,
+				.fe = {
+					{
+						.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+							DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+						.pid_filter_count = 32,
+						.pid_filter       = af9015_pid_filter,
+						.pid_filter_ctrl  = af9015_pid_filter_ctrl,
+
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x84,
+						},
+					}
 				},
-			}},
 			},
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x85,
-					.u = {
-						.bulk = {
-							.buffersize =
-						TS_USB20_FRAME_SIZE,
-						}
+				.num_frontends = 1,
+				.fe = {
+					{
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x85,
+							.u = {
+								.bulk = {
+									.buffersize = TS_USB20_FRAME_SIZE,
+								}
+							}
+						},
 					}
 				},
-			}},
 			}
 		},
 
@@ -1575,102 +1592,67 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 				.cold_ids = {
 					&af9015_usb_table[AFATECH_9015],
 					&af9015_usb_table[AFATECH_9016],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Leadtek WinFast DTV Dongle Gold",
 				.cold_ids = {
 					&af9015_usb_table[WINFAST_DTV_GOLD],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Pinnacle PCTV 71e",
 				.cold_ids = {
 					&af9015_usb_table[PINNACLE_PCTV_71E],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld PlusTV Dual DVB-T Stick " \
 					"(DVB-T 399U)",
 				.cold_ids = {
 					&af9015_usb_table[KWORLD_PLUSTV_399U],
 					&af9015_usb_table[KWORLD_399U_2],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "DigitalNow TinyTwin DVB-T Receiver",
 				.cold_ids = {
 					&af9015_usb_table[TINYTWIN],
 					&af9015_usb_table[TINYTWIN_2],
 					&af9015_usb_table[TINYTWIN_3],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "TwinHan AzureWave AD-TU700(704J)",
 				.cold_ids = {
 					&af9015_usb_table[AZUREWAVE_TU700],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "TerraTec Cinergy T USB XE",
 				.cold_ids = {
 					&af9015_usb_table[TERRATEC_AF9015],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld PlusTV Dual DVB-T PCI " \
 					"(DVB-T PC160-2T)",
 				.cold_ids = {
 					&af9015_usb_table[KWORLD_PLUSTV_PC160],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "AVerMedia AVerTV DVB-T Volar X",
 				.cold_ids = {
 					&af9015_usb_table[AVERTV_VOLAR_X],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "TerraTec Cinergy T Stick RC",
 				.cold_ids = {
 					&af9015_usb_table[CINERGY_T_STICK_RC],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "TerraTec Cinergy T Stick Dual RC",
 				.cold_ids = {
 					&af9015_usb_table[CINERGY_T_DUAL_RC],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "AverMedia AVerTV Red HD+ (A850T)",
 				.cold_ids = {
 					&af9015_usb_table[AVERTV_A850T],
-					NULL
 				},
-				.warm_ids = {NULL},
 			},
 		}
 	}, {
@@ -1686,43 +1668,44 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-
-				.pid_filter_count = 32,
-				.pid_filter       = af9015_pid_filter,
-				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
-
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x84,
+				.num_frontends = 1,
+				.fe = {
+					{
+						.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+							DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+						.pid_filter_count = 32,
+						.pid_filter       = af9015_pid_filter,
+						.pid_filter_ctrl  = af9015_pid_filter_ctrl,
+
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x84,
+						},
+					}
 				},
-			}},
 			},
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x85,
-					.u = {
-						.bulk = {
-							.buffersize =
-						TS_USB20_FRAME_SIZE,
-						}
+				.num_frontends = 1,
+				.fe = {
+					{
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x85,
+							.u = {
+								.bulk = {
+									.buffersize = TS_USB20_FRAME_SIZE,
+								}
+							}
+						},
 					}
 				},
-			}},
 			}
 		},
 
@@ -1744,51 +1727,33 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 				.name = "Xtensions XD-380",
 				.cold_ids = {
 					&af9015_usb_table[XTENSIONS_380U],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "MSI DIGIVOX Duo",
 				.cold_ids = {
 					&af9015_usb_table[MSI_DIGIVOX_DUO],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Fujitsu-Siemens Slim Mobile USB DVB-T",
 				.cold_ids = {
 					&af9015_usb_table[AVERTV_VOLAR_X_REV2],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Telestar Starstick 2",
 				.cold_ids = {
 					&af9015_usb_table[TELESTAR_STARSTICK_2],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "AVerMedia A309",
 				.cold_ids = {
 					&af9015_usb_table[AVERMEDIA_A309_USB],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "MSI Digi VOX mini III",
 				.cold_ids = {
 					&af9015_usb_table[MSI_DIGIVOX_MINI_III],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld USB DVB-T TV Stick II " \
 					"(VS-DVB-T 395U)",
 				.cold_ids = {
@@ -1796,34 +1761,23 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 					&af9015_usb_table[KWORLD_E39B],
 					&af9015_usb_table[KWORLD_E395],
 					&af9015_usb_table[KWORLD_E39A],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "TrekStor DVB-T USB Stick",
 				.cold_ids = {
 					&af9015_usb_table[TREKSTOR_DVBT],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "AverMedia AVerTV Volar Black HD " \
 					"(A850)",
 				.cold_ids = {
 					&af9015_usb_table[AVERTV_A850],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Sveon STV22 Dual USB DVB-T Tuner HDTV",
 				.cold_ids = {
 					&af9015_usb_table[SVEON_STV22],
-					NULL
 				},
-				.warm_ids = {NULL},
 			},
 		}
 	}, {
@@ -1839,43 +1793,44 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-
-				.pid_filter_count = 32,
-				.pid_filter       = af9015_pid_filter,
-				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
-
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x84,
+				.num_frontends = 1,
+				.fe = {
+					{
+						.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+							DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+						.pid_filter_count = 32,
+						.pid_filter       = af9015_pid_filter,
+						.pid_filter_ctrl  = af9015_pid_filter_ctrl,
+
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x84,
+						},
+					}
 				},
-			}},
 			},
 			{
-			.num_frontends = 1,
-			.fe = {{
-				.frontend_attach =
-					af9015_af9013_frontend_attach,
-				.tuner_attach    = af9015_tuner_attach,
-				.stream = {
-					.type = USB_BULK,
-					.count = 6,
-					.endpoint = 0x85,
-					.u = {
-						.bulk = {
-							.buffersize =
-						TS_USB20_FRAME_SIZE,
-						}
+				.num_frontends = 1,
+				.fe = {
+					{
+						.frontend_attach = af9015_af9013_frontend_attach,
+						.tuner_attach    = af9015_tuner_attach,
+						.stream = {
+							.type = USB_BULK,
+							.count = 6,
+							.endpoint = 0x85,
+							.u = {
+								.bulk = {
+									.buffersize = TS_USB20_FRAME_SIZE,
+								}
+							}
+						},
 					}
 				},
-			}},
 			}
 		},
 
@@ -1897,76 +1852,50 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 				.name = "AverMedia AVerTV Volar GPS 805 (A805)",
 				.cold_ids = {
 					&af9015_usb_table[AVERTV_A805],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Conceptronic USB2.0 DVB-T CTVDIGRCU " \
 					"V3.0",
 				.cold_ids = {
 					&af9015_usb_table[CONCEPTRONIC_CTVDIGRCU],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld Digial MC-810",
 				.cold_ids = {
 					&af9015_usb_table[KWORLD_MC810],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Genius TVGo DVB-T03",
 				.cold_ids = {
 					&af9015_usb_table[GENIUS_TVGO_DVB_T03],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld PlusTV DVB-T PCI Pro Card " \
 					"(DVB-T PC160-T)",
 				.cold_ids = {
 					&af9015_usb_table[KWORLD_PC160_T],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Sveon STV20 Tuner USB DVB-T HDTV",
 				.cold_ids = {
 					&af9015_usb_table[SVEON_STV20],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "Leadtek WinFast DTV2000DS",
 				.cold_ids = {
 					&af9015_usb_table[WINFAST_DTV2000DS],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "KWorld USB DVB-T Stick Mobile " \
 					"(UB383-T)",
 				.cold_ids = {
 					&af9015_usb_table[KWORLD_UB383_T],
-					NULL
 				},
-				.warm_ids = {NULL},
-			},
-			{
+			}, {
 				.name = "AverMedia AVerTV Volar M (A815Mac)",
 				.cold_ids = {
 					&af9015_usb_table[AVERMEDIA_A815M],
-					NULL
 				},
-				.warm_ids = {NULL},
 			},
 		}
 	},
@@ -2019,5 +1948,5 @@ static struct usb_driver af9015_usb_driver = {
 module_usb_driver(af9015_usb_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
-MODULE_DESCRIPTION("Driver for Afatech AF9015 DVB-T");
+MODULE_DESCRIPTION("Afatech AF9015 driver");
 MODULE_LICENSE("GPL");
-- 
1.7.7.6

