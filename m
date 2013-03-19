Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3CSRX6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:23:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 42/46] [media] siano: reorder smscore_get_fw_filename() function
Date: Tue, 19 Mar 2013 13:49:31 -0300
Message-Id: <1363711775-2120-43-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put this function earlier in the code, to avoid the need of
defining a function stub.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 172 ++++++++++++++++----------------
 1 file changed, 84 insertions(+), 88 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index f6619e0..5bfeeee 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1046,9 +1046,92 @@ exit_fw_download:
 	return rc;
 }
 
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
+};
 
+/**
+ * get firmware file name from one of the two mechanisms : sms_boards or
+ * smscore_fw_lkup.
+ * @param coredev pointer to a coredev object returned by
+ *		  smscore_register_device
+ * @param mode requested mode of operation
+ * @param lookup if 1, always get the fw filename from smscore_fw_lkup
+ *	 table. if 0, try first to get from sms_boards
+ *
+ * @return 0 on success, <0 on error.
+ */
 static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
-				     int mode);
+			      int mode)
+{
+	char **fw;
+	int board_id = smscore_get_board_id(coredev);
+	enum sms_device_type_st type;
+
+	type = smscore_registry_gettype(coredev->devpath);
+
+	/* Prevent looking outside the smscore_fw_lkup table */
+	if (type <= SMS_UNKNOWN_TYPE || type >= SMS_NUM_OF_DEVICE_TYPES)
+		return NULL;
+	if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX)
+		return NULL;
+
+	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
+		  board_id, mode);
+	fw = sms_get_board(board_id)->fw;
+	if (!fw || !fw[mode]) {
+		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
+			  mode, type);
+		return smscore_fw_lkup[type][mode];
+	}
+
+	return fw[mode];
+}
 
 /**
  * loads specified firmware into a buffer and calls device loadfirmware_handler
@@ -1208,93 +1291,6 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 	return rc;
 }
 
-static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
-	[SMS_NOVA_A0] = {
-		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz.inp",
-	},
-	[SMS_NOVA_B0] = {
-		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz_b0.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz_b0.inp",
-		[DEVICE_MODE_FM_RADIO]		= "fm_radio.inp",
-		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio.inp",
-	},
-	[SMS_VEGA] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_vega_12mhz.inp",
-	},
-	[SMS_VENICE] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_venice_12mhz.inp",
-	},
-	[SMS_MING] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_ming_app.inp",
-	},
-	[SMS_PELE] = {
-		[DEVICE_MODE_ISDBT]		= "isdbt_pele.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_pele.inp",
-	},
-	[SMS_RIO] = {
-		[DEVICE_MODE_DVBT]		= "dvb_rio.inp",
-		[DEVICE_MODE_DVBH]		= "dvbh_rio.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_rio.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_rio.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_rio.inp",
-		[DEVICE_MODE_FM_RADIO]		= "fm_radio_rio.inp",
-		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio_rio.inp",
-	},
-	[SMS_DENVER_1530] = {
-		[DEVICE_MODE_ATSC]		= "atsc_denver.inp",
-	},
-	[SMS_DENVER_2160] = {
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_denver.inp",
-	},
-};
-
-/**
- * get firmware file name from one of the two mechanisms : sms_boards or
- * smscore_fw_lkup.
- * @param coredev pointer to a coredev object returned by
- *		  smscore_register_device
- * @param mode requested mode of operation
- * @param lookup if 1, always get the fw filename from smscore_fw_lkup
- *	 table. if 0, try first to get from sms_boards
- *
- * @return 0 on success, <0 on error.
- */
-static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
-			      int mode)
-{
-	char **fw;
-	int board_id = smscore_get_board_id(coredev);
-	enum sms_device_type_st type;
-
-	type = smscore_registry_gettype(coredev->devpath);
-
-	/* Prevent looking outside the smscore_fw_lkup table */
-	if (type <= SMS_UNKNOWN_TYPE || type >= SMS_NUM_OF_DEVICE_TYPES)
-		return NULL;
-	if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX)
-		return NULL;
-
-	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
-		  board_id, mode);
-	fw = sms_get_board(board_id)->fw;
-	if (!fw || !fw[mode]) {
-		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
-			  mode, type);
-		return smscore_fw_lkup[type][mode];
-	}
-
-	return fw[mode];
-}
-
 /**
  * send init device request and wait for response
  *
-- 
1.8.1.4

