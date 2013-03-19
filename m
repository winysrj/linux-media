Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839Ab3CSQub (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/46] [media] siano: make load firmware logic to work with newer firmwares
Date: Tue, 19 Mar 2013 13:49:00 -0300
Message-Id: <1363711775-2120-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are new firmwares for sms2xxx devices. Change the firmware
load logic to handle those newer firmwares and devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 348 ++++++++++++++++++++------------
 drivers/media/common/siano/smscoreapi.h |   8 +-
 2 files changed, 220 insertions(+), 136 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 0bfb429..74a2cb5 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -683,6 +683,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	/* init completion events */
 	init_completion(&dev->version_ex_done);
 	init_completion(&dev->data_download_done);
+	init_completion(&dev->data_validity_done);
 	init_completion(&dev->trigger_done);
 	init_completion(&dev->init_device_done);
 	init_completion(&dev->reload_start_done);
@@ -753,7 +754,13 @@ EXPORT_SYMBOL_GPL(smscore_register_device);
 
 static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
 		void *buffer, size_t size, struct completion *completion) {
-	int rc = coredev->sendrequest_handler(coredev->context, buffer, size);
+	int rc;
+
+	if (completion == NULL)
+		return -EINVAL;
+	init_completion(completion);
+
+	rc = coredev->sendrequest_handler(coredev->context, buffer, size);
 	if (rc < 0) {
 		sms_info("sendrequest returned error %d", rc);
 		return rc;
@@ -850,8 +857,9 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 					 void *buffer, size_t size)
 {
 	struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
-	struct SmsMsgHdr_ST *msg;
-	u32 mem_address;
+	struct SmsMsgData_ST4 *msg;
+	u32 mem_address,  calc_checksum = 0;
+	u32 i, *ptr;
 	u8 *payload = firmware->Payload;
 	int rc = 0;
 	firmware->StartAddress = le32_to_cpu(firmware->StartAddress);
@@ -874,34 +882,35 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 
 	if (coredev->mode != DEVICE_MODE_NONE) {
 		sms_debug("sending reload command.");
-		SMS_INIT_MSG(msg, MSG_SW_RELOAD_START_REQ,
+		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SW_RELOAD_START_REQ,
 			     sizeof(struct SmsMsgHdr_ST));
 		rc = smscore_sendrequest_and_wait(coredev, msg,
-						  msg->msgLength,
+						  msg->xMsgHeader.msgLength,
 						  &coredev->reload_start_done);
+		if (rc < 0) {
+			sms_err("device reload failed, rc %d", rc);
+			goto exit_fw_download;
+		}
 		mem_address = *(u32 *) &payload[20];
 	}
 
+	for (i = 0, ptr = (u32 *)firmware->Payload; i < firmware->Length/4 ;
+	     i++, ptr++)
+		calc_checksum += *ptr;
+
 	while (size && rc >= 0) {
 		struct SmsDataDownload_ST *DataMsg =
 			(struct SmsDataDownload_ST *) msg;
 		int payload_size = min((int) size, SMS_MAX_PAYLOAD_SIZE);
 
-		SMS_INIT_MSG(msg, MSG_SMS_DATA_DOWNLOAD_REQ,
+		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_DATA_DOWNLOAD_REQ,
 			     (u16)(sizeof(struct SmsMsgHdr_ST) +
 				      sizeof(u32) + payload_size));
 
 		DataMsg->MemAddr = mem_address;
 		memcpy(DataMsg->Payload, payload, payload_size);
 
-		if ((coredev->device_flags & SMS_ROM_NO_RESPONSE) &&
-		    (coredev->mode == DEVICE_MODE_NONE))
-			rc = coredev->sendrequest_handler(
-				coredev->context, DataMsg,
-				DataMsg->xMsgHeader.msgLength);
-		else
-			rc = smscore_sendrequest_and_wait(
-				coredev, DataMsg,
+		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
 				DataMsg->xMsgHeader.msgLength,
 				&coredev->data_download_done);
 
@@ -910,44 +919,65 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		mem_address += payload_size;
 	}
 
-	if (rc >= 0) {
-		if (coredev->mode == DEVICE_MODE_NONE) {
-			struct SmsMsgData_ST *TriggerMsg =
-				(struct SmsMsgData_ST *) msg;
-
-			SMS_INIT_MSG(msg, MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
-				     sizeof(struct SmsMsgHdr_ST) +
-				     sizeof(u32) * 5);
-
-			TriggerMsg->msgData[0] = firmware->StartAddress;
-						/* Entry point */
-			TriggerMsg->msgData[1] = 5; /* Priority */
-			TriggerMsg->msgData[2] = 0x200; /* Stack size */
-			TriggerMsg->msgData[3] = 0; /* Parameter */
-			TriggerMsg->msgData[4] = 4; /* Task ID */
-
-			if (coredev->device_flags & SMS_ROM_NO_RESPONSE) {
-				rc = coredev->sendrequest_handler(
-					coredev->context, TriggerMsg,
-					TriggerMsg->xMsgHeader.msgLength);
-				msleep(100);
-			} else
-				rc = smscore_sendrequest_and_wait(
-					coredev, TriggerMsg,
+	if (rc < 0)
+		goto exit_fw_download;
+
+	sms_err("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
+		calc_checksum);
+	SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_DATA_VALIDITY_REQ,
+			sizeof(msg->xMsgHeader) +
+			sizeof(u32) * 3);
+	msg->msgData[0] = firmware->StartAddress;
+		/* Entry point */
+	msg->msgData[1] = firmware->Length;
+	msg->msgData[2] = 0; /* Regular checksum*/
+	smsendian_handle_tx_message(msg);
+	rc = smscore_sendrequest_and_wait(coredev, msg,
+					  msg->xMsgHeader.msgLength,
+					  &coredev->data_validity_done);
+	if (rc < 0)
+		goto exit_fw_download;
+
+	if (coredev->mode == DEVICE_MODE_NONE) {
+		struct SmsMsgData_ST *TriggerMsg =
+			(struct SmsMsgData_ST *) msg;
+
+		sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
+		SMS_INIT_MSG(&msg->xMsgHeader,
+				MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
+				sizeof(struct SmsMsgHdr_ST) +
+				sizeof(u32) * 5);
+
+		TriggerMsg->msgData[0] = firmware->StartAddress;
+					/* Entry point */
+		TriggerMsg->msgData[1] = 6; /* Priority */
+		TriggerMsg->msgData[2] = 0x200; /* Stack size */
+		TriggerMsg->msgData[3] = 0; /* Parameter */
+		TriggerMsg->msgData[4] = 4; /* Task ID */
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = smscore_sendrequest_and_wait(coredev, TriggerMsg,
 					TriggerMsg->xMsgHeader.msgLength,
 					&coredev->trigger_done);
-		} else {
-			SMS_INIT_MSG(msg, MSG_SW_RELOAD_EXEC_REQ,
-				     sizeof(struct SmsMsgHdr_ST));
-
-			rc = coredev->sendrequest_handler(coredev->context,
-							  msg, msg->msgLength);
-		}
-		msleep(500);
+	} else {
+		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SW_RELOAD_EXEC_REQ,
+				sizeof(struct SmsMsgHdr_ST));
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = coredev->sendrequest_handler(coredev->context, msg,
+				msg->xMsgHeader.msgLength);
 	}
 
-	sms_debug("rc=%d, postload=%p ", rc,
-		  coredev->postload_handler);
+	if (rc < 0)
+		goto exit_fw_download;
+
+	/*
+	 * backward compatibility - wait to device_ready_done for
+	 * not more than 400 ms
+	 */
+	msleep(400);
+
+exit_fw_download:
+	sms_debug("rc=%d, postload=0x%p ", rc, coredev->postload_handler);
 
 	kfree(msg);
 
@@ -956,6 +986,10 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		rc;
 }
 
+
+static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
+			      int mode, int lookup);
+
 /**
  * loads specified firmware into a buffer and calls device loadfirmware_handler
  *
@@ -967,41 +1001,43 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
  * @return 0 on success, <0 on error.
  */
 static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
-					   char *filename,
+					   int mode, int lookup,
 					   loadfirmware_t loadfirmware_handler)
 {
 	int rc = -ENOENT;
+	u8 *fw_buf;
+	u32 fw_buf_size;
 	const struct firmware *fw;
-	u8 *fw_buffer;
 
-	if (loadfirmware_handler == NULL && !(coredev->device_flags &
-					      SMS_DEVICE_FAMILY2))
+	char *fw_filename = smscore_get_fw_filename(coredev, mode, lookup);
+	if (!strcmp(fw_filename, "none"))
+		return -ENOENT;
+
+	if (loadfirmware_handler == NULL && !(coredev->device_flags
+			& SMS_DEVICE_FAMILY2))
 		return -EINVAL;
 
-	rc = request_firmware(&fw, filename, coredev->device);
+	rc = request_firmware(&fw, fw_filename, coredev->device);
 	if (rc < 0) {
-		sms_info("failed to open \"%s\"", filename);
+		sms_info("failed to open \"%s\"", fw_filename);
 		return rc;
 	}
-	sms_info("read FW %s, size=%zd", filename, fw->size);
-	fw_buffer = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
-			    GFP_KERNEL | GFP_DMA);
-	if (fw_buffer) {
-		memcpy(fw_buffer, fw->data, fw->size);
-
-		rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
-		      smscore_load_firmware_family2(coredev,
-						    fw_buffer,
-						    fw->size) :
-		      loadfirmware_handler(coredev->context,
-					   fw_buffer, fw->size);
-
-		kfree(fw_buffer);
-	} else {
+	sms_info("read fw %s, buffer size=0x%zx", fw_filename, fw->size);
+	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
+			 GFP_KERNEL | GFP_DMA);
+	if (!fw_buf) {
 		sms_info("failed to allocate firmware buffer");
-		rc = -ENOMEM;
+		return -ENOMEM;
 	}
+	memcpy(fw_buf, fw->data, fw->size);
+	fw_buf_size = fw->size;
+
+	rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
+		smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
+		: loadfirmware_handler(coredev->context, fw_buf,
+		fw_buf_size);
 
+	kfree(fw_buf);
 	release_firmware(fw);
 
 	return rc;
@@ -1050,7 +1086,9 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 
 		sms_info("waiting for %d buffer(s)",
 			 coredev->num_buffers - num_buffers);
+		kmutex_unlock(&g_smscore_deviceslock);
 		msleep(100);
+		kmutex_lock(&g_smscore_deviceslock);
 	}
 
 	sms_info("freed %d buffers", num_buffers);
@@ -1108,30 +1146,73 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 }
 
 static char *smscore_fw_lkup[][SMS_NUM_OF_DEVICE_TYPES] = {
-	/*Stellar		NOVA A0		Nova B0		VEGA*/
-	/*DVBT*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
-	/*DVBH*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
-	/*TDMB*/
-	{"none", "tdmb_nova_12mhz.inp", "tdmb_nova_12mhz_b0.inp", "none"},
-	/*DABIP*/
-	{"none", "none", "none", "none"},
-	/*BDA*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
-	/*ISDBT*/
-	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
-	/*ISDBTBDA*/
-	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
-	/*CMMB*/
-	{"none", "none", "none", "cmmb_vega_12mhz.inp"}
+	/*Stellar, NOVA A0, Nova B0, VEGA, VENICE, MING, PELE, RIO, DENVER_1530, DENVER_2160 */
+		/*DVBT*/
+	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvb_rio.inp", "none", "none" },
+		/*DVBH*/
+	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvbh_rio.inp", "none", "none" },
+		/*TDMB*/
+	{ "none", "tdmb_nova_12mhz.inp", "tdmb_nova_12mhz_b0.inp", "none", "none", "none", "none", "none", "none", "tdmb_denver.inp" },
+		/*DABIP*/
+	{ "none", "none", "none", "none", "none", "none", "none", "none", "none", "none" },
+		/*DVBT_BDA*/
+	{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none", "none", "none", "none", "dvb_rio.inp", "none", "none" },
+		/*ISDBT*/
+	{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none", "none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
+		/*ISDBT_BDA*/
+	{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none", "none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
+		/*CMMB*/
+	{ "none", "none", "none", "cmmb_vega_12mhz.inp", "cmmb_venice_12mhz.inp", "cmmb_ming_app.inp", "none", "none", "none", 	"none" },
+		/*RAW - not supported*/
+	{ "none", "none", "none", "none", "none", "none", "none", "none", "none", "none" },
+		/*FM*/
+	{ "none", "none", "fm_radio.inp", "none", "none", "none", "none", "fm_radio_rio.inp", "none", "none" },
+		/*FM_BDA*/
+	{ "none", "none", "fm_radio.inp", "none", "none", "none", "none", "fm_radio_rio.inp", "none", "none" },
+		/*ATSC*/
+	{ "none", "none", "none", "none", "none", "none", "none", "none", "atsc_denver.inp", "none" }
 };
 
-static inline char *sms_get_fw_name(struct smscore_device_t *coredev,
-				    int mode, enum sms_device_type_st type)
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
+static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
+			      int mode, int lookup)
 {
-	char **fw = sms_get_board(smscore_get_board_id(coredev))->fw;
-	return (fw && fw[mode]) ? fw[mode] : smscore_fw_lkup[mode][type];
+	char **fw;
+	int board_id = smscore_get_board_id(coredev);
+	enum sms_device_type_st type = smscore_registry_gettype(coredev->devpath);
+
+	if ((board_id == SMS_BOARD_UNKNOWN) || (lookup == 1)) {
+		sms_debug("trying to get fw name from lookup table mode %d type %d",
+			  mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+
+	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
+		  board_id, mode);
+	fw = sms_get_board(board_id)->fw;
+	if (fw == NULL) {
+		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
+			  mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+
+	if (fw[mode] == NULL) {
+		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
+			  mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+
+	return fw[mode];
 }
 
 /**
@@ -1146,9 +1227,7 @@ static inline char *sms_get_fw_name(struct smscore_device_t *coredev,
  */
 int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 {
-	void *buffer;
 	int rc = 0;
-	enum sms_device_type_st type;
 
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
@@ -1173,55 +1252,30 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		}
 
 		if (!(coredev->modes_supported & (1 << mode))) {
-			char *fw_filename;
-
-			type = smscore_registry_gettype(coredev->devpath);
-			fw_filename = sms_get_fw_name(coredev, mode, type);
-
 			rc = smscore_load_firmware_from_file(coredev,
-							     fw_filename, NULL);
-			if (rc < 0) {
-				sms_warn("error %d loading firmware: %s, "
-					 "trying again with default firmware",
-					 rc, fw_filename);
+							     mode, 0, NULL);
 
-				/* try again with the default firmware */
-				fw_filename = smscore_fw_lkup[mode][type];
+			/*
+			* try again with the default firmware -
+			* get the fw filename from look-up table
+			*/
+			if (rc < 0) {
+				sms_debug("error %d loading firmware, trying again with default firmware",
+					  rc);
 				rc = smscore_load_firmware_from_file(coredev,
-							     fw_filename, NULL);
-
+								     mode, 1,
+								     NULL);
 				if (rc < 0) {
-					sms_warn("error %d loading "
-						 "firmware: %s", rc,
-						 fw_filename);
+					sms_debug("error %d loading firmware",
+						  rc);
 					return rc;
 				}
 			}
-			sms_log("firmware download success: %s", fw_filename);
-		} else
-			sms_info("mode %d supported by running "
-				 "firmware", mode);
-
-		buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
-				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
-		if (buffer) {
-			struct SmsMsgData_ST *msg =
-				(struct SmsMsgData_ST *)
-					SMS_ALIGN_ADDRESS(buffer);
-
-			SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
-				     sizeof(struct SmsMsgData_ST));
-			msg->msgData[0] = mode;
-
-			rc = smscore_sendrequest_and_wait(
-				coredev, msg, msg->xMsgHeader.msgLength,
-				&coredev->init_device_done);
-
-			kfree(buffer);
+			if (rc >= 0)
+				sms_info("firmware download success");
 		} else {
-			sms_err("Could not allocate buffer for "
-				"init device message.");
-			rc = -ENOMEM;
+			sms_info("mode %d is already supported by running firmware",
+				 mode);
 		}
 	} else {
 		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
@@ -1240,8 +1294,25 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 	}
 
 	if (rc >= 0) {
+		char *buffer;
 		coredev->mode = mode;
 		coredev->device_flags &= ~SMS_DEVICE_NOT_READY;
+
+		buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
+				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
+		if (buffer) {
+			struct SmsMsgData_ST *msg =(struct SmsMsgData_ST *) SMS_ALIGN_ADDRESS(buffer);
+
+			SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
+				     sizeof(struct SmsMsgData_ST));
+			msg->msgData[0] = mode;
+
+			rc = smscore_sendrequest_and_wait(
+				coredev, msg, msg->xMsgHeader.msgLength,
+				&coredev->init_device_done);
+
+			kfree(buffer);
+		}
 	}
 
 	if (rc < 0)
@@ -1372,6 +1443,15 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		case MSG_SW_RELOAD_START_RES:
 			complete(&coredev->reload_start_done);
 			break;
+		case MSG_SMS_DATA_VALIDITY_RES:
+		{
+			struct SmsMsgData_ST *validity = (struct SmsMsgData_ST *) phdr;
+
+			sms_err("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
+				validity->msgData[0]);
+			complete(&coredev->data_validity_done);
+			break;
+		}
 		case MSG_SMS_DATA_DOWNLOAD_RES:
 			complete(&coredev->data_download_done);
 			break;
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index f1440a5..91db853 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -162,6 +162,7 @@ struct smscore_device_t {
 
 	/* host <--> device messages */
 	struct completion version_ex_done, data_download_done, trigger_done;
+	struct completion data_validity_done, device_ready_done;
 	struct completion init_device_done, reload_start_done, resume_done;
 	struct completion gpio_configuration_done, gpio_set_level_done;
 	struct completion gpio_get_level_done, ir_init_done;
@@ -594,6 +595,11 @@ struct SmsMsgData_ST2 {
 	u32 msgData[2];
 };
 
+struct SmsMsgData_ST4 {
+	struct SmsMsgHdr_ST xMsgHeader;
+	u32 msgData[4];
+};
+
 struct SmsDataDownload_ST {
 	struct SmsMsgHdr_ST	xMsgHeader;
 	u32			MemAddr;
@@ -998,8 +1004,6 @@ extern void smscore_onresponse(struct smscore_device_t *coredev,
 extern int smscore_get_common_buffer_size(struct smscore_device_t *coredev);
 extern int smscore_map_common_buffer(struct smscore_device_t *coredev,
 				      struct vm_area_struct *vma);
-extern int smscore_get_fw_filename(struct smscore_device_t *coredev,
-				   int mode, char *filename);
 extern int smscore_send_fw_file(struct smscore_device_t *coredev,
 				u8 *ufwbuf, int size);
 
-- 
1.8.1.4

