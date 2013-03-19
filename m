Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3CSRYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:24:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 39/46] [media] siano: simplify firmware lookup logic
Date: Tue, 19 Mar 2013 13:49:28 -0300
Message-Id: <1363711775-2120-40-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two ways to specify firmware for siano devices: a
per-device ID and a per-device type.

The per-device type logic is currently made by a 11x9 string
table, sparsely filled. It is very hard to read the table at
the source code, as there are too much "none" filling there
("none" there is a way to tell NULL).

Instead of using such problematic table, convert it into an
easy to read table, where the unused values will be defaulted
to NULL.

While here, also simplifies a little bit the logic and print
a message if an user-selected mode doesn't exist.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 91 +++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 37 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 029dd6a..6db7fe5 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1063,9 +1063,11 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	const struct firmware *fw;
 
 	char *fw_filename = smscore_get_fw_filename(coredev, mode, lookup);
-	sms_debug("Firmware name: %s\n", fw_filename);
-	if (!strcmp(fw_filename, "none"))
+	if (!fw_filename) {
+		sms_info("mode %d not supported on this device", mode);
 		return -ENOENT;
+	}
+	sms_debug("Firmware name: %s", fw_filename);
 
 	if (loadfirmware_handler == NULL && !(coredev->device_flags
 			& SMS_DEVICE_FAMILY2))
@@ -1199,32 +1201,53 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 	return rc;
 }
 
-static char *smscore_fw_lkup[][SMS_NUM_OF_DEVICE_TYPES] = {
-	/*Stellar, NOVA A0, Nova B0, VEGA, VENICE, MING, PELE, RIO, DENVER_1530, DENVER_2160 */
-		/*DVBT*/
-	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvb_rio.inp", "none", "none" },
-		/*DVBH*/
-	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvbh_rio.inp", "none", "none" },
-		/*TDMB*/
-	{ "none", "tdmb_nova_12mhz.inp", "tdmb_nova_12mhz_b0.inp", "none", "none", "none", "none", "none", "none", "tdmb_denver.inp" },
-		/*DABIP*/
-	{ "none", "none", "none", "none", "none", "none", "none", "none", "none", "none" },
-		/*DVBT_BDA*/
-	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvb_rio.inp", "none", "none" },
-		/*ISDBT*/
-	{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none", "none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
-		/*ISDBT_BDA*/
-	{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none", "none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
-		/*CMMB*/
-	{ "none", "none", "none", "cmmb_vega_12mhz.inp", "cmmb_venice_12mhz.inp", "cmmb_ming_app.inp", "none", "none", "none", 	"none" },
-		/*RAW - not supported*/
-	{ "none", "none", "none", "none", "none", "none", "none", "none", "none", "none" },
-		/*FM*/
-	{ "none", "none", "fm_radio.inp", "none", "none", "none", "none", "fm_radio_rio.inp", "none", "none" },
-		/*FM_BDA*/
-	{ "none", "none", "fm_radio.inp", "none", "none", "none", "none", "fm_radio_rio.inp", "none", "none" },
-		/*ATSC*/
-	{ "none", "none", "none", "none", "none", "none", "none", "none", "atsc_denver.inp", "none" }
+static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
+	[SMS_NOVA_A0] = {
+		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz.inp",
+		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz.inp",
+		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz.inp",
+		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz.inp",
+		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz.inp",
+		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz.inp",
+	},
+	[SMS_NOVA_B0] = {
+		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz_b0.inp",
+		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz_b0.inp",
+		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz_b0.inp",
+		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz_b0.inp",
+		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz_b0.inp",
+		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz_b0.inp",
+		[DEVICE_MODE_FM_RADIO]		= "fm_radio.inp",
+		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio.inp",
+	},
+	[SMS_VEGA] = {
+		[DEVICE_MODE_CMMB]		= "cmmb_vega_12mhz.inp",
+	},
+	[SMS_VENICE] = {
+		[DEVICE_MODE_CMMB]		= "cmmb_venice_12mhz.inp",
+	},
+	[SMS_MING] = {
+		[DEVICE_MODE_CMMB]		= "cmmb_ming_app.inp",
+	},
+	[SMS_PELE] = {
+		[DEVICE_MODE_ISDBT]		= "isdbt_pele.inp",
+		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_pele.inp",
+	},
+	[SMS_RIO] = {
+		[DEVICE_MODE_DVBT]		= "dvb_rio.inp",
+		[DEVICE_MODE_DVBH]		= "dvbh_rio.inp",
+		[DEVICE_MODE_DVBT_BDA]		= "dvb_rio.inp",
+		[DEVICE_MODE_ISDBT]		= "isdbt_rio.inp",
+		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_rio.inp",
+		[DEVICE_MODE_FM_RADIO]		= "fm_radio_rio.inp",
+		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio_rio.inp",
+	},
+	[SMS_DENVER_1530] = {
+		[DEVICE_MODE_ATSC]		= "atsc_denver.inp",
+	},
+	[SMS_DENVER_2160] = {
+		[DEVICE_MODE_DAB_TDMB]		= "tdmb_denver.inp",
+	},
 };
 
 /**
@@ -1250,22 +1273,16 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 	if ((board_id == SMS_BOARD_UNKNOWN) || (lookup == 1)) {
 		sms_debug("trying to get fw name from lookup table mode %d type %d",
 			  mode, type);
-		return smscore_fw_lkup[mode][type];
+		return smscore_fw_lkup[type][mode];
 	}
 
 	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
 		  board_id, mode);
 	fw = sms_get_board(board_id)->fw;
-	if (fw == NULL) {
-		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
-			  mode, type);
-		return smscore_fw_lkup[mode][type];
-	}
-
-	if (fw[mode] == NULL) {
+	if (!fw || !fw[mode]) {
 		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
 			  mode, type);
-		return smscore_fw_lkup[mode][type];
+		return smscore_fw_lkup[type][mode];
 	}
 
 	return fw[mode];
-- 
1.8.1.4

