Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6294 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1ITKTI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:19:08 -0400
Subject: [PATCH  12/17]DVB:Siano drivers - Improve firmware load and reload
 mechanism.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:50 +0300
Message-ID: <1316514710.5199.90.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch step Improve firmware load and reload mechanism in order to
support new siano devices and match all existing devices.

Thanks,
Doron Cohen

-----------------------

>From 59062b9fbc2f3c28cbb1ec014c6ed5a3e065a7de Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 08:22:29 +0300
Subject: [PATCH 16/21] Improve firmware load and reload mechanism in
order to support new siano devices and match all existing devices.

---
 drivers/media/dvb/siano/smscoreapi.c |  530
+++++++++++++++++++++++++++-------
 1 files changed, 423 insertions(+), 107 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index db24391..e50e356 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -312,6 +312,7 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer,
void *common_buffer,
 	cb->p = buffer;
 	cb->offset_in_common = buffer - (u8 *) common_buffer;
 	cb->phys = common_buffer_phys + cb->offset_in_common;
+	cb->offset=0;
 
 	return cb;
 }
@@ -352,6 +353,7 @@ int smscore_register_device(struct
smsdevice_params_t *params,
 	/* init completion events */
 	init_completion(&dev->version_ex_done);
 	init_completion(&dev->data_download_done);
+	init_completion(&dev->data_validity_done);
 	init_completion(&dev->trigger_done);
 	init_completion(&dev->init_device_done);
 	init_completion(&dev->reload_start_done);
@@ -360,6 +362,7 @@ int smscore_register_device(struct
smsdevice_params_t *params,
 	init_completion(&dev->gpio_set_level_done);
 	init_completion(&dev->gpio_get_level_done);
 	init_completion(&dev->ir_init_done);
+	init_completion(&dev->device_ready_done);
 
 	/* Buffer management */
 	init_waitqueue_head(&dev->buffer_mng_waitq);
@@ -426,7 +429,13 @@ EXPORT_SYMBOL_GPL(smscore_register_device);
 
 static int smscore_sendrequest_and_wait(struct smscore_device_t
*coredev,
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
@@ -535,7 +544,8 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 {
 	struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
 	struct SmsMsgHdr_S *msg;
-	u32 mem_address;
+	u32 mem_address,  calc_checksum = 0;
+	u32 i, *ptr;
 	u8 *payload = firmware->Payload;
 	int rc = 0;
 	firmware->StartAddress = le32_to_cpu(firmware->StartAddress);
@@ -563,9 +573,17 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 		rc = smscore_sendrequest_and_wait(coredev, msg,
 						  msg->msgLength,
 						  &coredev->reload_start_done);
+
+		if (rc < 0) {				
+			sms_err("device reload failed, rc %d", rc);
+			goto exit_fw_download;
+		}
+
 		mem_address = *(u32 *) &payload[20];
 	}
 
+	for (i = 0, ptr = (u32*)firmware->Payload; i < firmware->Length/4 ; i
++, ptr++)
+		calc_checksum += *ptr;
 	while (size && rc >= 0) {
 		struct SmsDataDownload_S *DataMsg =
 			(struct SmsDataDownload_S *) msg;
@@ -578,14 +596,9 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 		DataMsg->MemAddr = mem_address;
 		memcpy(DataMsg->Payload, payload, payload_size);
 
-		if ((coredev->device_flags & SMS_ROM_NO_RESPONSE) &&
-		    (coredev->mode == SMSHOSTLIB_DEVMD_NONE))
-			rc = coredev->sendrequest_handler(
-				coredev->context, DataMsg,
-				DataMsg->xMsgHeader.msgLength);
-		else
-			rc = smscore_sendrequest_and_wait(
-				coredev, DataMsg,
+
+	
+		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
 				DataMsg->xMsgHeader.msgLength,
 				&coredev->data_download_done);
 
@@ -594,44 +607,63 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 		mem_address += payload_size;
 	}
 
-	if (rc >= 0) {
+	if (rc < 0) 		
+		goto exit_fw_download;
+
+	sms_err("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
calc_checksum);
+	SMS_INIT_MSG(msg, MSG_SMS_DATA_VALIDITY_REQ,
+			sizeof(struct SmsMsgHdr_S) +
+			sizeof(u32) * 3);
+	((struct SmsMsgData_S *)msg)->msgData[0] = firmware->StartAddress;
+		/* Entry point */
+	((struct SmsMsgData_S *)msg)->msgData[1] = firmware->Length;
+	((struct SmsMsgData_S *)msg)->msgData[2] = 0; /* Regular checksum*/
+	smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+	rc = smscore_sendrequest_and_wait(coredev, msg,	((struct SmsMsgData_S
*)msg)->xMsgHeader.msgLength, &coredev->data_validity_done);
+	if (rc < 0) 		
+		goto exit_fw_download;
+
+
 		if (coredev->mode == SMSHOSTLIB_DEVMD_NONE) {
 			struct SmsMsgData_S *TriggerMsg =
 				(struct SmsMsgData_S *) msg;
 
+		        sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
 			SMS_INIT_MSG(msg, MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
 				     sizeof(struct SmsMsgHdr_S) +
 				     sizeof(u32) * 5);
 
 			TriggerMsg->msgData[0] = firmware->StartAddress;
 						/* Entry point */
-			TriggerMsg->msgData[1] = 5; /* Priority */
+		TriggerMsg->msgData[1] = 6; /* Priority */
 			TriggerMsg->msgData[2] = 0x200; /* Stack size */
 			TriggerMsg->msgData[3] = 0; /* Parameter */
 			TriggerMsg->msgData[4] = 4; /* Task ID */
 
-			if (coredev->device_flags & SMS_ROM_NO_RESPONSE) {
-				rc = coredev->sendrequest_handler(
-					coredev->context, TriggerMsg,
-					TriggerMsg->xMsgHeader.msgLength);
-				msleep(100);
-			} else
-				rc = smscore_sendrequest_and_wait(
-					coredev, TriggerMsg,
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = smscore_sendrequest_and_wait(coredev,
+			TriggerMsg,
 					TriggerMsg->xMsgHeader.msgLength,
 					&coredev->trigger_done);
 		} else {
 			SMS_INIT_MSG(msg, MSG_SW_RELOAD_EXEC_REQ,
 				     sizeof(struct SmsMsgHdr_S));
-
-			rc = coredev->sendrequest_handler(coredev->context,
-							  msg, msg->msgLength);
-		}
-		msleep(500);
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = coredev->sendrequest_handler(coredev->context, msg,
+				msg->msgLength);
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
 
@@ -653,42 +685,211 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
  * @return 0 on success, <0 on error.
  */
 static int smscore_load_firmware_from_file(struct smscore_device_t
*coredev,
-					   char *filename,
-					   loadfirmware_t loadfirmware_handler)
-{
+		int mode, int lookup, loadfirmware_t loadfirmware_handler) {
 	int rc = -ENOENT;
+	u8 *fw_buf;
+	u32 fw_buf_size;
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
 	const struct firmware *fw;
-	u8 *fw_buffer;
 
-	if (loadfirmware_handler == NULL && !(coredev->device_flags &
-					      SMS_DEVICE_FAMILY2))
+	char* fw_filename = smscore_get_fw_filename(coredev, mode, lookup);
+	if (!strcmp(fw_filename,"none"))
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
+	sms_info("read fw %s, buffer size=0x%x", fw_filename, fw->size);
+	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
 			    GFP_KERNEL | GFP_DMA);
-	if (fw_buffer) {
-		memcpy(fw_buffer, fw->data, fw->size);
+	if (!fw_buf) {
+		sms_info("failed to allocate firmware buffer");
+		return -ENOMEM;
+	}
+	memcpy(fw_buf, fw->data, fw->size);
+	fw_buf_size = fw->size;
+#else
+	if (!coredev->fw_buf) {
+		sms_info("missing fw file buffer");
+		return -EINVAL;
+	}
+	fw_buf = coredev->fw_buf;
+	fw_buf_size = coredev->fw_buf_size;
+#endif
 
 		rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
-		      smscore_load_firmware_family2(coredev,
-						    fw_buffer,
-						    fw->size) :
-		      loadfirmware_handler(coredev->context,
-					   fw_buffer, fw->size);
+		smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
+		: loadfirmware_handler(coredev->context, fw_buf,
+		fw_buf_size);
+
+	kfree(fw_buf);
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
+	release_firmware(fw);
+#else
+	coredev->fw_buf = NULL;
+	coredev->fw_buf_size = 0;
+#endif
+	return rc;
+}
+
+/**
+ * Send chunk of firmware data using SMS MSGs
+ * The motivation is to eliminate the need of big memory allocation in
kernel for firmware
+ * download.
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param buffer  pointer to a buffer
+ * @param size    size of buffer
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_send_fw_chunk(struct smscore_device_t *coredev,
+		void *buffer, size_t size) 
+{
+
+	struct SmsMsgHdr_S *msg;
+	int rc = 0;
+	int offset = 0;
+	
+	if (buffer == NULL)
+	{
+		sms_debug("Error: NULL buffer");
+		return -1;
+	}
+	
+	/* First chunk */
+	if (coredev->start_address == 0)
+	{
+		struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
+		coredev->start_address = le32_to_cpu(firmware->StartAddress);
+		coredev->current_address = coredev->start_address;
+		offset = 12;
+		size -= 12;
+		
+		if (coredev->preload_handler) 
+		{
+			rc = coredev->preload_handler(coredev->context);
+			if (rc < 0)
+				return rc;
+		}
+	}
+		
+	/* PAGE_SIZE buffer shall be enough and dma aligned */
+	msg = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
+	if (!msg)
+		return -ENOMEM;
+		
+	while (size && rc >= 0) {
+		int payload_size;
+		struct SmsDataDownload_S *DataMsg;
+		sms_debug("sending MSG_SMS_DATA_DOWNLOAD_REQ");
+		DataMsg = (struct SmsDataDownload_S *) msg;
+		payload_size = min((int)size, SMS_MAX_PAYLOAD_SIZE);
 
-		kfree(fw_buffer);
+		SMS_INIT_MSG(msg, MSG_SMS_DATA_DOWNLOAD_REQ,
+				(u16) (sizeof(struct SmsMsgHdr_S) +
+						sizeof(u32) + payload_size));
+
+		DataMsg->MemAddr = coredev->current_address;
+		copy_from_user(DataMsg->Payload, (u8*)(buffer + offset),
payload_size);
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
+			DataMsg->xMsgHeader.msgLength,
+			&coredev->data_download_done);
+
+		size -= payload_size;
+		offset += payload_size;
+		coredev->current_address += payload_size;
+	}
+
+	kfree(msg);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(smscore_send_fw_chunk);
+
+
+/**
+ * Send last chunk of firmware data using SMS MSGs
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param buffer  pointer to a buffer
+ * @param size    size of buffer
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_send_last_fw_chunk(struct smscore_device_t *coredev,
+		void *buffer, size_t size) 
+{
+	int rc = 0;
+	struct SmsMsgHdr_S *msg;
+	
+	rc = smscore_send_fw_chunk(coredev, buffer, size);
+	if (rc < 0)
+		return rc;
+	
+	/* PAGE_SIZE buffer shall be enough and dma aligned */
+	msg = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
+	if (!msg)
+		return -ENOMEM;
+	
+	if (coredev->mode == SMSHOSTLIB_DEVMD_NONE) {
+		struct SmsMsgData_S *TriggerMsg =
+				(struct SmsMsgData_S *) msg;
+
+		sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
+		SMS_INIT_MSG(msg, MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
+				sizeof(struct SmsMsgHdr_S) +
+				sizeof(u32) * 5);
+
+		TriggerMsg->msgData[0] = coredev->start_address;
+		/* Entry point */
+		TriggerMsg->msgData[1] = 6; /* Priority */
+		TriggerMsg->msgData[2] = 0x200; /* Stack size */
+		TriggerMsg->msgData[3] = 0; /* Parameter */
+		TriggerMsg->msgData[4] = 4; /* Task ID */
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = smscore_sendrequest_and_wait(coredev,
+			TriggerMsg,
+			TriggerMsg->xMsgHeader.msgLength,
+			&coredev->trigger_done);
 	} else {
-		sms_info("failed to allocate firmware buffer");
-		rc = -ENOMEM;
+		SMS_INIT_MSG(msg, MSG_SW_RELOAD_EXEC_REQ,
+				sizeof(struct SmsMsgHdr_S));
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = coredev->sendrequest_handler(coredev->context, msg,
+				msg->msgLength);
 	}
 
-	release_firmware(fw);
+	/* clear start_address */
+	coredev->start_address = 0;
+
+	if (rc < 0)
+		goto exit_fw_download;
+			
+	/*
+	 * backward compatibility - wait to device_ready_done for
+	 * not more than 400 ms
+	 */
+	wait_for_completion_timeout(&coredev->device_ready_done,
+			msecs_to_jiffies(400));		
+
+exit_fw_download:
+	sms_debug("rc=%d, postload=0x%p ", rc, coredev->postload_handler);
+
+	kfree(msg);
 
 	return rc;
 }
@@ -712,6 +913,7 @@ void smscore_unregister_device(struct
smscore_device_t *coredev)
 
 	/* Release input device (IR) resources */
 #ifdef SMS_RC_SUPPORT_SUBSYS
+	/* Release input device (IR) resources */
 	sms_ir_exit(coredev);
 #endif /*SMS_RC_SUPPORT_SUBSYS*/
 	smscore_notify_clients(coredev);
@@ -737,7 +939,9 @@ void smscore_unregister_device(struct
smscore_device_t *coredev)
 
 		sms_info("waiting for %d buffer(s)",
 			 coredev->num_buffers - num_buffers);
+		kmutex_unlock(&g_smscore_deviceslock);
 		msleep(100);
+		kmutex_lock(&g_smscore_deviceslock);
 	}
 
 	sms_info("freed %d buffers", num_buffers);
@@ -800,30 +1004,106 @@ static int smscore_detect_mode(struct
smscore_device_t *coredev)
 }
 
 static char *smscore_fw_lkup[][SMS_NUM_OF_DEVICE_TYPES] = {
-	/*Stellar		NOVA A0		Nova B0		VEGA*/
+/*Stellar, NOVA A0, Nova B0, VEGA, VENICE, MING, PELE, RIO,
DENVER_1530, DENVER_2160*/
 	/*DVBT*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
+{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none",
"none", "none", "none", "dvb_rio.inp", "none", "none" },
 	/*DVBH*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
+{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none",
"none", "none", "none", "dvbh_rio.inp", "none", "none" },
 	/*TDMB*/
-	{"none", "tdmb_nova_12mhz.inp", "tdmb_nova_12mhz_b0.inp", "none"},
+{ "none", "tdmb_nova_12mhz.inp", "tdmb_nova_12mhz_b0.inp", "none",
"none", "none", "none", "none", "none", "tdmb_denver.inp" },
 	/*DABIP*/
-	{"none", "none", "none", "none"},
-	/*BDA*/
-	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
+{ "none", "none", "none", "none", "none", "none", "none", "none",
"none", "none" },
+/*DVBT_BDA*/
+{ "none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none",
"none", "none", "none", "dvb_rio.inp", "none", "none" },
 	/*ISDBT*/
-	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
-	/*ISDBTBDA*/
-	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
+{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none",
"none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
+/*ISDBT_BDA*/
+{ "none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none",
"none", "none", "isdbt_pele.inp", "isdbt_rio.inp", "none", "none" },
 	/*CMMB*/
-	{"none", "none", "none", "cmmb_vega_12mhz.inp"}
+{ "none", "none", "none", "cmmb_vega_12mhz.inp",
"cmmb_venice_12mhz.inp", "cmmb_ming_app.inp", "none", "none", "none",
"none" },
+/*RAW - not supported*/
+{ "none", "none", "none", "none", "none", "none", "none", "none",
"none", "none" },
+/*FM*/
+{ "none", "none", "fm_radio.inp", "none", "none", "none", "none",
"fm_radio_rio.inp", "none", "none" },
+/*FM_BDA*/
+{ "none", "none", "fm_radio.inp", "none", "none", "none", "none",
"fm_radio_rio.inp", "none", "none" },
+/*ATSC*/
+{ "none", "none", "none", "none", "none", "none", "none", "none",
"atsc_denver.inp", "none" }
 };
 
-static inline char *sms_get_fw_name(struct smscore_device_t *coredev,
-				    int mode, enum sms_device_type_st type)
+/**
+ * get firmware file name from one of the two mechanisms : sms_boards
or 
+ * smscore_fw_lkup.
+
+ * @param coredev pointer to a coredev object returned by
+ * 		  smscore_register_device
+ * @param mode requested mode of operation
+ * @param lookup if 1, always get the fw filename from smscore_fw_lkup 
+ * 	 table. if 0, try first to get from sms_boards
+ *
+ * @return 0 on success, <0 on error.
+ */
+char *smscore_get_fw_filename(struct smscore_device_t *coredev, int
mode, int lookup) {
+	char **fw;
+	int board_id = smscore_get_board_id(coredev);
+	enum sms_device_type_st type =
smscore_registry_gettype(coredev->devpath); 
+
+	if ( (board_id == SMS_BOARD_UNKNOWN) || 
+	     (lookup == 1) ) {
+		sms_debug("trying to get fw name from lookup table mode %d type %d",
mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+	
+	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
board_id, mode);
+	fw = sms_get_board(board_id)->fw;
+	if (fw == NULL) {
+		sms_debug("cannot find fw name in sms_boards, getting from lookup
table mode %d type %d", mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+
+	if (fw[mode] == NULL) {
+		sms_debug("cannot find fw name in sms_boards, getting from lookup
table mode %d type %d", mode, type);
+		return smscore_fw_lkup[mode][type];
+	}
+
+	return fw[mode];
+}
+
+/**
+ * send init device request and wait for response
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param mode requested mode of operation
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_init_device(struct smscore_device_t *coredev, int mode)
 {
-	char **fw = sms_get_board(smscore_get_board_id(coredev))->fw;
-	return (fw && fw[mode]) ? fw[mode] : smscore_fw_lkup[mode][type];
+	void* buffer;
+	struct SmsMsgData_S *msg;
+	int rc = 0;
+
+	buffer = kmalloc(sizeof(struct SmsMsgData_S) +
+			SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
+		sms_err("Could not allocate buffer for "
+				"init device message.");
+		return -ENOMEM;
+	}
+
+	msg = (struct SmsMsgData_S *)SMS_ALIGN_ADDRESS(buffer);
+	SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
+			sizeof(struct SmsMsgData_S));
+	msg->msgData[0] = mode;
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+	rc = smscore_sendrequest_and_wait(coredev, msg,
+			msg->xMsgHeader. msgLength,
+			&coredev->init_device_done);
+
+	kfree(buffer);
+	return rc;
 }
 
 /**
@@ -838,13 +1118,11 @@ static inline char *sms_get_fw_name(struct
smscore_device_t *coredev,
  */
 int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 {
-	void *buffer;
 	int rc = 0;
-	enum sms_device_type_st type;
 
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode >=
SMSHOSTLIB_DEVMD_RAW_TUNER) {
+		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode >= SMSHOSTLIB_DEVMD_MAX) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
@@ -865,56 +1143,35 @@ int smscore_set_device_mode(struct
smscore_device_t *coredev, int mode)
 		}
 
 		if (!(coredev->modes_supported & (1 << mode))) {
-			char *fw_filename;
+			rc = smscore_load_firmware_from_file(coredev, mode, 0, NULL);
 
-			type = smscore_registry_gettype(coredev->devpath);
-			fw_filename = sms_get_fw_name(coredev, mode, type);
-
-			rc = smscore_load_firmware_from_file(coredev,
-							     fw_filename, NULL);
+			/* 
+			* try again with the default firmware -
+			* get the fw filename from look-up table
+			*/
 			if (rc < 0) {
-				sms_debug("error %d loading firmware: %s, "
-					 "trying again with default firmware",
-					 rc, fw_filename);
-
-				/* try again with the default firmware */
-				fw_filename = smscore_fw_lkup[mode][type];
-				rc = smscore_load_firmware_from_file(coredev,
-							     fw_filename, NULL);
+				sms_debug("error %d loading firmware, "
+					"trying again with default firmware", rc);
+				rc = smscore_load_firmware_from_file(coredev, mode, 1, NULL);
+			}
 
 				if (rc < 0) {
-				        sms_debug("error %d loading firmware", rc);
+				sms_debug("error %d loading firmware", rc);
 					return rc;
 				}
-			}
-			sms_log("firmware download success: %s", fw_filename);
-		} else
-			sms_info("mode %d supported by running "
-				 "firmware", mode);
 
-		buffer = kmalloc(sizeof(struct SmsMsgData_S) +
-				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
-		if (buffer) {
-			struct SmsMsgData_S *msg =
-				(struct SmsMsgData_S *)
-					SMS_ALIGN_ADDRESS(buffer);
-
-			SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
-				     sizeof(struct SmsMsgData_S));
-			msg->msgData[0] = mode;
-
-			rc = smscore_sendrequest_and_wait(
-				coredev, msg, msg->xMsgHeader.msgLength,
-				&coredev->init_device_done);
-
-			kfree(buffer);
+			sms_info("firmware download success");
 		} else {
-			sms_err("Could not allocate buffer for "
-				"init device message.");
-			rc = -ENOMEM;
+			sms_info("mode %d is already supported by running "
+					"firmware", mode);
+			}
+
+		rc = smscore_init_device(coredev, mode);
+		if (rc < 0) {
+			sms_err("device init failed, rc %d.", rc);
 		}
 	} else {
-		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode > SMSHOSTLIB_DEVMD_DVBT_BDA)
{
+		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode >= SMSHOSTLIB_DEVMD_MAX) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
@@ -943,6 +1200,58 @@ int smscore_set_device_mode(struct
smscore_device_t *coredev, int mode)
 		sms_err("return error code %d.", rc);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(smscore_set_device_mode);
+
+/**
+ * configures device features according to voard configuration
structure.
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_configure_board(struct smscore_device_t *coredev) {
+	struct sms_board* board;
+
+	board = sms_get_board(coredev->board_id);
+	if (!board)
+	{
+		sms_err("no board configuration exist.");
+		return -1;
+	}
+	
+	if (board->mtu)
+	{
+		struct SmsMsgData_S MtuMsg;
+		sms_debug("set max transmit unit %d", board->mtu);
+
+		MtuMsg.xMsgHeader.msgSrcId = 0;
+		MtuMsg.xMsgHeader.msgDstId = HIF_TASK;
+		MtuMsg.xMsgHeader.msgFlags = 0;
+		MtuMsg.xMsgHeader.msgType = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
+		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
+		MtuMsg.msgData[0] = board->mtu;
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)&MtuMsg);
+		coredev->sendrequest_handler(coredev->context, &MtuMsg,
sizeof(MtuMsg));
+	}
+
+	if (board->crystal)
+	{
+		struct SmsMsgData_S CrysMsg;
+		sms_debug("set crystal value %d", board->crystal);
+
+		SMS_INIT_MSG(&CrysMsg.xMsgHeader, 
+				MSG_SMS_NEW_CRYSTAL_REQ,
+				sizeof(CrysMsg));
+		CrysMsg.msgData[0] = board->crystal;
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)&CrysMsg);
+		coredev->sendrequest_handler(coredev->context, &CrysMsg,
sizeof(CrysMsg));
+	}
+
+	return 0;
+}
 
 /**
  * calls device handler to get current mode of operation
@@ -1099,6 +1408,13 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 		case MSG_SW_RELOAD_EXEC_RES:
 			sms_debug("MSG_SW_RELOAD_EXEC_RES");
 			break;
+		case MSG_SMS_DATA_VALIDITY_RES:
+		{
+			struct SmsMsgData_S *validity = (struct SmsMsgData_S *) phdr;			
+			sms_err("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
validity->msgData[0]);
+			complete(&coredev->data_validity_done);
+			break;
+		}
 		case MSG_SMS_SWDOWNLOAD_TRIGGER_RES:
 			sms_debug("MSG_SMS_SWDOWNLOAD_TRIGGER_RES");
 			complete(&coredev->trigger_done);
@@ -1188,8 +1504,8 @@ EXPORT_SYMBOL_GPL(smscore_getbuffer);
  */
 void smscore_putbuffer(struct smscore_device_t *coredev,
 		struct smscore_buffer_t *cb) {
-	wake_up_interruptible(&coredev->buffer_mng_waitq);
 	list_add_locked(&cb->entry, &coredev->buffers, &coredev->bufferslock);
+	wake_up_interruptible(&coredev->buffer_mng_waitq);
 }
 EXPORT_SYMBOL_GPL(smscore_putbuffer);
 
-- 
1.7.4.1

