Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab3CUNDA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:03:00 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD306o001948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:03:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/6] siano: get rid of CammelCase from smscoreapi.h
Date: Thu, 21 Mar 2013 10:02:38 -0300
Message-Id: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is almost impossible to see a compliant with checkpatch.pl
on those Siano drivers, as there are simply too much violations
on it. So, now that a big change was done, the better is to
cleanup the checkpatch compliants.

Let's first replace all CammelCase symbols found at smscoreapi.h
using camel_case namespace. That removed 144 checkpatch.pl
compliants on this file. Of course, the other files need to be
fixed accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c      |  12 +-
 drivers/media/common/siano/smscoreapi.c     | 336 +++++++++++-----------
 drivers/media/common/siano/smscoreapi.h     | 420 ++++++++++++++--------------
 drivers/media/common/siano/smsdvb-debugfs.c | 230 +++++++--------
 drivers/media/common/siano/smsdvb-main.c    | 250 ++++++++---------
 drivers/media/common/siano/smsdvb.h         |  32 +--
 drivers/media/common/siano/smsendian.c      |  30 +-
 drivers/media/mmc/siano/smssdio.c           |  18 +-
 drivers/media/usb/siano/smsusb.c            |  40 +--
 9 files changed, 684 insertions(+), 684 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 6680134..9bd7aa1 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -167,13 +167,13 @@ struct sms_board *sms_get_board(unsigned id)
 }
 EXPORT_SYMBOL_GPL(sms_get_board);
 static inline void sms_gpio_assign_11xx_default_led_config(
-		struct smscore_config_gpio *pGpioConfig) {
-	pGpioConfig->direction = SMS_GPIO_DIRECTION_OUTPUT;
-	pGpioConfig->inputcharacteristics =
+		struct smscore_config_gpio *p_gpio_config) {
+	p_gpio_config->direction = SMS_GPIO_DIRECTION_OUTPUT;
+	p_gpio_config->inputcharacteristics =
 		SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
-	pGpioConfig->outputdriving = SMS_GPIO_OUTPUTDRIVING_4mA;
-	pGpioConfig->outputslewrate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
-	pGpioConfig->pullupdown = SMS_GPIO_PULLUPDOWN_NONE;
+	p_gpio_config->outputdriving = SMS_GPIO_OUTPUTDRIVING_4mA;
+	p_gpio_config->outputslewrate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
+	p_gpio_config->pullupdown = SMS_GPIO_PULLUPDOWN_NONE;
 }
 
 int sms_board_event(struct smscore_device_t *coredev,
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 5006d1c..e5fa405 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -792,22 +792,22 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 		if	(rc != 0)
 			sms_err("Error initialization DTV IR sub-module");
 		else {
-			buffer = kmalloc(sizeof(struct SmsMsgData_ST2) +
+			buffer = kmalloc(sizeof(struct sms_msg_data2) +
 						SMS_DMA_ALIGNMENT,
 						GFP_KERNEL | GFP_DMA);
 			if (buffer) {
-				struct SmsMsgData_ST2 *msg =
-				(struct SmsMsgData_ST2 *)
+				struct sms_msg_data2 *msg =
+				(struct sms_msg_data2 *)
 				SMS_ALIGN_ADDRESS(buffer);
 
-				SMS_INIT_MSG(&msg->xMsgHeader,
+				SMS_INIT_MSG(&msg->x_msg_header,
 						MSG_SMS_START_IR_REQ,
-						sizeof(struct SmsMsgData_ST2));
+						sizeof(struct sms_msg_data2));
 				msg->msgData[0] = coredev->ir.controller;
 				msg->msgData[1] = coredev->ir.timeout;
 
 				rc = smscore_sendrequest_and_wait(coredev, msg,
-						msg->xMsgHeader. msgLength,
+						msg->x_msg_header. msg_length,
 						&coredev->ir_init_done);
 
 				kfree(buffer);
@@ -840,14 +840,14 @@ int smscore_configure_board(struct smscore_device_t *coredev)
 	}
 
 	if (board->mtu) {
-		struct SmsMsgData_ST MtuMsg;
+		struct sms_msg_data MtuMsg;
 		sms_debug("set max transmit unit %d", board->mtu);
 
-		MtuMsg.xMsgHeader.msgSrcId = 0;
-		MtuMsg.xMsgHeader.msgDstId = HIF_TASK;
-		MtuMsg.xMsgHeader.msgFlags = 0;
-		MtuMsg.xMsgHeader.msgType = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
-		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
+		MtuMsg.x_msg_header.msg_src_id = 0;
+		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
+		MtuMsg.x_msg_header.msg_flags = 0;
+		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
+		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
 		MtuMsg.msgData[0] = board->mtu;
 
 		coredev->sendrequest_handler(coredev->context, &MtuMsg,
@@ -855,10 +855,10 @@ int smscore_configure_board(struct smscore_device_t *coredev)
 	}
 
 	if (board->crystal) {
-		struct SmsMsgData_ST CrysMsg;
+		struct sms_msg_data CrysMsg;
 		sms_debug("set crystal value %d", board->crystal);
 
-		SMS_INIT_MSG(&CrysMsg.xMsgHeader,
+		SMS_INIT_MSG(&CrysMsg.x_msg_header,
 				MSG_SMS_NEW_CRYSTAL_REQ,
 				sizeof(CrysMsg));
 		CrysMsg.msgData[0] = board->crystal;
@@ -916,19 +916,19 @@ EXPORT_SYMBOL_GPL(smscore_start_device);
 static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 					 void *buffer, size_t size)
 {
-	struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
-	struct SmsMsgData_ST4 *msg;
+	struct sms_firmware *firmware = (struct sms_firmware *) buffer;
+	struct sms_msg_data4 *msg;
 	u32 mem_address,  calc_checksum = 0;
 	u32 i, *ptr;
-	u8 *payload = firmware->Payload;
+	u8 *payload = firmware->payload;
 	int rc = 0;
-	firmware->StartAddress = le32_to_cpu(firmware->StartAddress);
-	firmware->Length = le32_to_cpu(firmware->Length);
+	firmware->start_address = le32_to_cpu(firmware->start_address);
+	firmware->length = le32_to_cpu(firmware->length);
 
-	mem_address = firmware->StartAddress;
+	mem_address = firmware->start_address;
 
 	sms_info("loading FW to addr 0x%x size %d",
-		 mem_address, firmware->Length);
+		 mem_address, firmware->length);
 	if (coredev->preload_handler) {
 		rc = coredev->preload_handler(coredev->context);
 		if (rc < 0)
@@ -942,10 +942,10 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 
 	if (coredev->mode != DEVICE_MODE_NONE) {
 		sms_debug("sending reload command.");
-		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SW_RELOAD_START_REQ,
-			     sizeof(struct SmsMsgHdr_ST));
+		SMS_INIT_MSG(&msg->x_msg_header, MSG_SW_RELOAD_START_REQ,
+			     sizeof(struct sms_msg_hdr));
 		rc = smscore_sendrequest_and_wait(coredev, msg,
-						  msg->xMsgHeader.msgLength,
+						  msg->x_msg_header.msg_length,
 						  &coredev->reload_start_done);
 		if (rc < 0) {
 			sms_err("device reload failed, rc %d", rc);
@@ -954,24 +954,24 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		mem_address = *(u32 *) &payload[20];
 	}
 
-	for (i = 0, ptr = (u32 *)firmware->Payload; i < firmware->Length/4 ;
+	for (i = 0, ptr = (u32 *)firmware->payload; i < firmware->length/4 ;
 	     i++, ptr++)
 		calc_checksum += *ptr;
 
 	while (size && rc >= 0) {
-		struct SmsDataDownload_ST *DataMsg =
-			(struct SmsDataDownload_ST *) msg;
+		struct sms_data_download *DataMsg =
+			(struct sms_data_download *) msg;
 		int payload_size = min((int) size, SMS_MAX_PAYLOAD_SIZE);
 
-		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_DATA_DOWNLOAD_REQ,
-			     (u16)(sizeof(struct SmsMsgHdr_ST) +
+		SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_DOWNLOAD_REQ,
+			     (u16)(sizeof(struct sms_msg_hdr) +
 				      sizeof(u32) + payload_size));
 
-		DataMsg->MemAddr = mem_address;
-		memcpy(DataMsg->Payload, payload, payload_size);
+		DataMsg->mem_addr = mem_address;
+		memcpy(DataMsg->payload, payload, payload_size);
 
 		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
-				DataMsg->xMsgHeader.msgLength,
+				DataMsg->x_msg_header.msg_length,
 				&coredev->data_download_done);
 
 		payload += payload_size;
@@ -984,30 +984,30 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 
 	sms_err("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
 		calc_checksum);
-	SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_DATA_VALIDITY_REQ,
-			sizeof(msg->xMsgHeader) +
+	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_VALIDITY_REQ,
+			sizeof(msg->x_msg_header) +
 			sizeof(u32) * 3);
-	msg->msgData[0] = firmware->StartAddress;
+	msg->msgData[0] = firmware->start_address;
 		/* Entry point */
-	msg->msgData[1] = firmware->Length;
+	msg->msgData[1] = firmware->length;
 	msg->msgData[2] = 0; /* Regular checksum*/
 	rc = smscore_sendrequest_and_wait(coredev, msg,
-					  msg->xMsgHeader.msgLength,
+					  msg->x_msg_header.msg_length,
 					  &coredev->data_validity_done);
 	if (rc < 0)
 		goto exit_fw_download;
 
 	if (coredev->mode == DEVICE_MODE_NONE) {
-		struct SmsMsgData_ST *TriggerMsg =
-			(struct SmsMsgData_ST *) msg;
+		struct sms_msg_data *TriggerMsg =
+			(struct sms_msg_data *) msg;
 
 		sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
-		SMS_INIT_MSG(&msg->xMsgHeader,
+		SMS_INIT_MSG(&msg->x_msg_header,
 				MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
-				sizeof(struct SmsMsgHdr_ST) +
+				sizeof(struct sms_msg_hdr) +
 				sizeof(u32) * 5);
 
-		TriggerMsg->msgData[0] = firmware->StartAddress;
+		TriggerMsg->msgData[0] = firmware->start_address;
 					/* Entry point */
 		TriggerMsg->msgData[1] = 6; /* Priority */
 		TriggerMsg->msgData[2] = 0x200; /* Stack size */
@@ -1015,13 +1015,13 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		TriggerMsg->msgData[4] = 4; /* Task ID */
 
 		rc = smscore_sendrequest_and_wait(coredev, TriggerMsg,
-					TriggerMsg->xMsgHeader.msgLength,
+					TriggerMsg->x_msg_header.msg_length,
 					&coredev->trigger_done);
 	} else {
-		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SW_RELOAD_EXEC_REQ,
-				sizeof(struct SmsMsgHdr_ST));
+		SMS_INIT_MSG(&msg->x_msg_header, MSG_SW_RELOAD_EXEC_REQ,
+				sizeof(struct sms_msg_hdr));
 		rc = coredev->sendrequest_handler(coredev->context, msg,
-				msg->xMsgHeader.msgLength);
+				msg->x_msg_header.msg_length);
 	}
 
 	if (rc < 0)
@@ -1256,19 +1256,19 @@ EXPORT_SYMBOL_GPL(smscore_unregister_device);
 
 static int smscore_detect_mode(struct smscore_device_t *coredev)
 {
-	void *buffer = kmalloc(sizeof(struct SmsMsgHdr_ST) + SMS_DMA_ALIGNMENT,
+	void *buffer = kmalloc(sizeof(struct sms_msg_hdr) + SMS_DMA_ALIGNMENT,
 			       GFP_KERNEL | GFP_DMA);
-	struct SmsMsgHdr_ST *msg =
-		(struct SmsMsgHdr_ST *) SMS_ALIGN_ADDRESS(buffer);
+	struct sms_msg_hdr *msg =
+		(struct sms_msg_hdr *) SMS_ALIGN_ADDRESS(buffer);
 	int rc;
 
 	if (!buffer)
 		return -ENOMEM;
 
 	SMS_INIT_MSG(msg, MSG_SMS_GET_VERSION_EX_REQ,
-		     sizeof(struct SmsMsgHdr_ST));
+		     sizeof(struct sms_msg_hdr));
 
-	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
+	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msg_length,
 					  &coredev->version_ex_done);
 	if (rc == -ETIME) {
 		sms_err("MSG_SMS_GET_VERSION_EX_REQ failed first try");
@@ -1276,7 +1276,7 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 		if (wait_for_completion_timeout(&coredev->resume_done,
 						msecs_to_jiffies(5000))) {
 			rc = smscore_sendrequest_and_wait(
-				coredev, msg, msg->msgLength,
+				coredev, msg, msg->msg_length,
 				&coredev->version_ex_done);
 			if (rc < 0)
 				sms_err("MSG_SMS_GET_VERSION_EX_REQ failed "
@@ -1302,23 +1302,23 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 int smscore_init_device(struct smscore_device_t *coredev, int mode)
 {
 	void *buffer;
-	struct SmsMsgData_ST *msg;
+	struct sms_msg_data *msg;
 	int rc = 0;
 
-	buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
+	buffer = kmalloc(sizeof(struct sms_msg_data) +
 			SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
 		sms_err("Could not allocate buffer for init device message.");
 		return -ENOMEM;
 	}
 
-	msg = (struct SmsMsgData_ST *)SMS_ALIGN_ADDRESS(buffer);
-	SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
-			sizeof(struct SmsMsgData_ST));
+	msg = (struct sms_msg_data *)SMS_ALIGN_ADDRESS(buffer);
+	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_INIT_DEVICE_REQ,
+			sizeof(struct sms_msg_data));
 	msg->msgData[0] = mode;
 
 	rc = smscore_sendrequest_and_wait(coredev, msg,
-			msg->xMsgHeader. msgLength,
+			msg->x_msg_header. msg_length,
 			&coredev->init_device_done);
 
 	kfree(buffer);
@@ -1396,17 +1396,17 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		coredev->mode = mode;
 		coredev->device_flags &= ~SMS_DEVICE_NOT_READY;
 
-		buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
+		buffer = kmalloc(sizeof(struct sms_msg_data) +
 				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
 		if (buffer) {
-			struct SmsMsgData_ST *msg = (struct SmsMsgData_ST *) SMS_ALIGN_ADDRESS(buffer);
+			struct sms_msg_data *msg = (struct sms_msg_data *) SMS_ALIGN_ADDRESS(buffer);
 
-			SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
-				     sizeof(struct SmsMsgData_ST));
+			SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_INIT_DEVICE_REQ,
+				     sizeof(struct sms_msg_data));
 			msg->msgData[0] = mode;
 
 			rc = smscore_sendrequest_and_wait(
-				coredev, msg, msg->xMsgHeader.msgLength,
+				coredev, msg, msg->x_msg_header.msg_length,
 				&coredev->init_device_done);
 
 			kfree(buffer);
@@ -1483,7 +1483,7 @@ found:
  */
 void smscore_onresponse(struct smscore_device_t *coredev,
 		struct smscore_buffer_t *cb) {
-	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) ((u8 *) cb->p
+	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) ((u8 *) cb->p
 			+ cb->offset);
 	struct smscore_client_t *client;
 	int rc = -EBUSY;
@@ -1505,14 +1505,14 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 
 	data_total += cb->size;
 	/* Do we need to re-route? */
-	if ((phdr->msgType == MSG_SMS_HO_PER_SLICES_IND) ||
-			(phdr->msgType == MSG_SMS_TRANSMISSION_IND)) {
+	if ((phdr->msg_type == MSG_SMS_HO_PER_SLICES_IND) ||
+			(phdr->msg_type == MSG_SMS_TRANSMISSION_IND)) {
 		if (coredev->mode == DEVICE_MODE_DVBT_BDA)
-			phdr->msgDstId = DVBT_BDA_CONTROL_MSG_ID;
+			phdr->msg_dst_id = DVBT_BDA_CONTROL_MSG_ID;
 	}
 
 
-	client = smscore_find_client(coredev, phdr->msgType, phdr->msgDstId);
+	client = smscore_find_client(coredev, phdr->msg_type, phdr->msg_dst_id);
 
 	/* If no client registered for type & id,
 	 * check for control client where type is not registered */
@@ -1520,7 +1520,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		rc = client->onresponse_handler(client->context, cb);
 
 	if (rc < 0) {
-		switch (phdr->msgType) {
+		switch (phdr->msg_type) {
 		case MSG_SMS_ISDBT_TUNE_RES:
 			break;
 		case MSG_SMS_RF_TUNE_RES:
@@ -1537,17 +1537,17 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 		case MSG_SMS_GET_VERSION_EX_RES:
 		{
-			struct SmsVersionRes_ST *ver =
-				(struct SmsVersionRes_ST *) phdr;
+			struct sms_version_res *ver =
+				(struct sms_version_res *) phdr;
 			sms_debug("Firmware id %d prots 0x%x ver %d.%d",
-				  ver->FirmwareId, ver->SupportedProtocols,
-				  ver->RomVersionMajor, ver->RomVersionMinor);
+				  ver->firmware_id, ver->supported_protocols,
+				  ver->rom_ver_major, ver->rom_ver_minor);
 
-			coredev->mode = ver->FirmwareId == 255 ?
-				DEVICE_MODE_NONE : ver->FirmwareId;
-			coredev->modes_supported = ver->SupportedProtocols;
-			coredev->fw_version = ver->RomVersionMajor << 8 |
-					      ver->RomVersionMinor;
+			coredev->mode = ver->firmware_id == 255 ?
+				DEVICE_MODE_NONE : ver->firmware_id;
+			coredev->modes_supported = ver->supported_protocols;
+			coredev->fw_version = ver->rom_ver_major << 8 |
+					      ver->rom_ver_minor;
 
 			complete(&coredev->version_ex_done);
 			break;
@@ -1560,7 +1560,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 		case MSG_SMS_DATA_VALIDITY_RES:
 		{
-			struct SmsMsgData_ST *validity = (struct SmsMsgData_ST *) phdr;
+			struct sms_msg_data *validity = (struct sms_msg_data *) phdr;
 
 			sms_err("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
 				validity->msgData[0]);
@@ -1600,9 +1600,9 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			sms_ir_event(coredev,
 				(const char *)
 				((char *)phdr
-				+ sizeof(struct SmsMsgHdr_ST)),
-				(int)phdr->msgLength
-				- sizeof(struct SmsMsgHdr_ST));
+				+ sizeof(struct sms_msg_hdr)),
+				(int)phdr->msg_length
+				- sizeof(struct sms_msg_hdr));
 			break;
 
 		case MSG_SMS_DVBT_BDA_DATA:
@@ -1616,8 +1616,8 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 
 		default:
 			sms_debug("message %s(%d) not handled.",
-				  smscore_translate_msg(phdr->msgType),
-				  phdr->msgType);
+				  smscore_translate_msg(phdr->msg_type),
+				  phdr->msg_type);
 			break;
 		}
 		smscore_putbuffer(coredev, cb);
@@ -1799,7 +1799,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 			  void *buffer, size_t size)
 {
 	struct smscore_device_t *coredev;
-	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) buffer;
+	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) buffer;
 	int rc;
 
 	if (client == NULL) {
@@ -1816,7 +1816,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 	}
 
 	rc = smscore_validate_client(client->coredev, client, 0,
-				     phdr->msgSrcId);
+				     phdr->msg_src_id);
 	if (rc < 0)
 		return rc;
 
@@ -1830,16 +1830,16 @@ int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
 			   struct smscore_config_gpio *pinconfig)
 {
 	struct {
-		struct SmsMsgHdr_ST hdr;
+		struct sms_msg_hdr hdr;
 		u32 data[6];
 	} msg;
 
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-		msg.hdr.msgDstId = HIF_TASK;
-		msg.hdr.msgFlags = 0;
-		msg.hdr.msgType  = MSG_SMS_GPIO_CONFIG_EX_REQ;
-		msg.hdr.msgLength = sizeof(msg);
+		msg.hdr.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+		msg.hdr.msg_dst_id = HIF_TASK;
+		msg.hdr.msg_flags = 0;
+		msg.hdr.msg_type  = MSG_SMS_GPIO_CONFIG_EX_REQ;
+		msg.hdr.msg_length = sizeof(msg);
 
 		msg.data[0] = pin;
 		msg.data[1] = pinconfig->pullupdown;
@@ -1875,18 +1875,18 @@ int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
 int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level)
 {
 	struct {
-		struct SmsMsgHdr_ST hdr;
+		struct sms_msg_hdr hdr;
 		u32 data[3];
 	} msg;
 
 	if (pin > MAX_GPIO_PIN_NUMBER)
 		return -EINVAL;
 
-	msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	msg.hdr.msgDstId = HIF_TASK;
-	msg.hdr.msgFlags = 0;
-	msg.hdr.msgType  = MSG_SMS_GPIO_SET_LEVEL_REQ;
-	msg.hdr.msgLength = sizeof(msg);
+	msg.hdr.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	msg.hdr.msg_dst_id = HIF_TASK;
+	msg.hdr.msg_flags = 0;
+	msg.hdr.msg_type  = MSG_SMS_GPIO_SET_LEVEL_REQ;
+	msg.hdr.msg_length = sizeof(msg);
 
 	msg.data[0] = pin;
 	msg.data[1] = level ? 1 : 0;
@@ -1897,47 +1897,47 @@ int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level)
 }
 
 /* new GPIO management implementation */
-static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
+static int GetGpioPinParams(u32 pin_num, u32 *pTranslatedpin_num,
 		u32 *pGroupNum, u32 *pGroupCfg) {
 
 	*pGroupCfg = 1;
 
-	if (PinNum <= 1)	{
-		*pTranslatedPinNum = 0;
+	if (pin_num <= 1)	{
+		*pTranslatedpin_num = 0;
 		*pGroupNum = 9;
 		*pGroupCfg = 2;
-	} else if (PinNum >= 2 && PinNum <= 6) {
-		*pTranslatedPinNum = 2;
+	} else if (pin_num >= 2 && pin_num <= 6) {
+		*pTranslatedpin_num = 2;
 		*pGroupNum = 0;
 		*pGroupCfg = 2;
-	} else if (PinNum >= 7 && PinNum <= 11) {
-		*pTranslatedPinNum = 7;
+	} else if (pin_num >= 7 && pin_num <= 11) {
+		*pTranslatedpin_num = 7;
 		*pGroupNum = 1;
-	} else if (PinNum >= 12 && PinNum <= 15) {
-		*pTranslatedPinNum = 12;
+	} else if (pin_num >= 12 && pin_num <= 15) {
+		*pTranslatedpin_num = 12;
 		*pGroupNum = 2;
 		*pGroupCfg = 3;
-	} else if (PinNum == 16) {
-		*pTranslatedPinNum = 16;
+	} else if (pin_num == 16) {
+		*pTranslatedpin_num = 16;
 		*pGroupNum = 23;
-	} else if (PinNum >= 17 && PinNum <= 24) {
-		*pTranslatedPinNum = 17;
+	} else if (pin_num >= 17 && pin_num <= 24) {
+		*pTranslatedpin_num = 17;
 		*pGroupNum = 3;
-	} else if (PinNum == 25) {
-		*pTranslatedPinNum = 25;
+	} else if (pin_num == 25) {
+		*pTranslatedpin_num = 25;
 		*pGroupNum = 6;
-	} else if (PinNum >= 26 && PinNum <= 28) {
-		*pTranslatedPinNum = 26;
+	} else if (pin_num >= 26 && pin_num <= 28) {
+		*pTranslatedpin_num = 26;
 		*pGroupNum = 4;
-	} else if (PinNum == 29) {
-		*pTranslatedPinNum = 29;
+	} else if (pin_num == 29) {
+		*pTranslatedpin_num = 29;
 		*pGroupNum = 5;
 		*pGroupCfg = 2;
-	} else if (PinNum == 30) {
-		*pTranslatedPinNum = 30;
+	} else if (pin_num == 30) {
+		*pTranslatedpin_num = 30;
 		*pGroupNum = 8;
-	} else if (PinNum == 31) {
-		*pTranslatedPinNum = 31;
+	} else if (pin_num == 31) {
+		*pTranslatedpin_num = 31;
 		*pGroupNum = 17;
 	} else
 		return -1;
@@ -1947,11 +1947,11 @@ static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
 	return 0;
 }
 
-int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
-		struct smscore_config_gpio *pGpioConfig) {
+int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
+		struct smscore_config_gpio *p_gpio_config) {
 
 	u32 totalLen;
-	u32 TranslatedPinNum = 0;
+	u32 Translatedpin_num = 0;
 	u32 GroupNum = 0;
 	u32 ElectricChar;
 	u32 groupCfg;
@@ -1959,18 +1959,18 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 	int rc;
 
 	struct SetGpioMsg {
-		struct SmsMsgHdr_ST xMsgHeader;
+		struct sms_msg_hdr x_msg_header;
 		u32 msgData[6];
 	} *pMsg;
 
 
-	if (PinNum > MAX_GPIO_PIN_NUMBER)
+	if (pin_num > MAX_GPIO_PIN_NUMBER)
 		return -EINVAL;
 
-	if (pGpioConfig == NULL)
+	if (p_gpio_config == NULL)
 		return -EINVAL;
 
-	totalLen = sizeof(struct SmsMsgHdr_ST) + (sizeof(u32) * 6);
+	totalLen = sizeof(struct sms_msg_hdr) + (sizeof(u32) * 6);
 
 	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
 			GFP_KERNEL | GFP_DMA);
@@ -1979,35 +1979,35 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 
 	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->xMsgHeader.msgDstId = HIF_TASK;
-	pMsg->xMsgHeader.msgFlags = 0;
-	pMsg->xMsgHeader.msgLength = (u16) totalLen;
-	pMsg->msgData[0] = PinNum;
+	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
+	pMsg->x_msg_header.msg_flags = 0;
+	pMsg->x_msg_header.msg_length = (u16) totalLen;
+	pMsg->msgData[0] = pin_num;
 
 	if (!(coredev->device_flags & SMS_DEVICE_FAMILY2)) {
-		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_REQ;
-		if (GetGpioPinParams(PinNum, &TranslatedPinNum, &GroupNum,
+		pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_REQ;
+		if (GetGpioPinParams(pin_num, &Translatedpin_num, &GroupNum,
 				&groupCfg) != 0) {
 			rc = -EINVAL;
 			goto free;
 		}
 
-		pMsg->msgData[1] = TranslatedPinNum;
+		pMsg->msgData[1] = Translatedpin_num;
 		pMsg->msgData[2] = GroupNum;
-		ElectricChar = (pGpioConfig->pullupdown)
-				| (pGpioConfig->inputcharacteristics << 2)
-				| (pGpioConfig->outputslewrate << 3)
-				| (pGpioConfig->outputdriving << 4);
+		ElectricChar = (p_gpio_config->pullupdown)
+				| (p_gpio_config->inputcharacteristics << 2)
+				| (p_gpio_config->outputslewrate << 3)
+				| (p_gpio_config->outputdriving << 4);
 		pMsg->msgData[3] = ElectricChar;
-		pMsg->msgData[4] = pGpioConfig->direction;
+		pMsg->msgData[4] = p_gpio_config->direction;
 		pMsg->msgData[5] = groupCfg;
 	} else {
-		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_EX_REQ;
-		pMsg->msgData[1] = pGpioConfig->pullupdown;
-		pMsg->msgData[2] = pGpioConfig->outputslewrate;
-		pMsg->msgData[3] = pGpioConfig->outputdriving;
-		pMsg->msgData[4] = pGpioConfig->direction;
+		pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_EX_REQ;
+		pMsg->msgData[1] = p_gpio_config->pullupdown;
+		pMsg->msgData[2] = p_gpio_config->outputslewrate;
+		pMsg->msgData[3] = p_gpio_config->outputdriving;
+		pMsg->msgData[4] = p_gpio_config->direction;
 		pMsg->msgData[5] = 0;
 	}
 
@@ -2026,22 +2026,22 @@ free:
 	return rc;
 }
 
-int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
-		u8 NewLevel) {
+int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
+		u8 new_level) {
 
 	u32 totalLen;
 	int rc;
 	void *buffer;
 
 	struct SetGpioMsg {
-		struct SmsMsgHdr_ST xMsgHeader;
+		struct sms_msg_hdr x_msg_header;
 		u32 msgData[3]; /* keep it 3 ! */
 	} *pMsg;
 
-	if ((NewLevel > 1) || (PinNum > MAX_GPIO_PIN_NUMBER))
+	if ((new_level > 1) || (pin_num > MAX_GPIO_PIN_NUMBER))
 		return -EINVAL;
 
-	totalLen = sizeof(struct SmsMsgHdr_ST) +
+	totalLen = sizeof(struct sms_msg_hdr) +
 			(3 * sizeof(u32)); /* keep it 3 ! */
 
 	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
@@ -2051,13 +2051,13 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
 
 	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->xMsgHeader.msgDstId = HIF_TASK;
-	pMsg->xMsgHeader.msgFlags = 0;
-	pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_SET_LEVEL_REQ;
-	pMsg->xMsgHeader.msgLength = (u16) totalLen;
-	pMsg->msgData[0] = PinNum;
-	pMsg->msgData[1] = NewLevel;
+	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
+	pMsg->x_msg_header.msg_flags = 0;
+	pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_SET_LEVEL_REQ;
+	pMsg->x_msg_header.msg_length = (u16) totalLen;
+	pMsg->msgData[0] = pin_num;
+	pMsg->msgData[1] = new_level;
 
 	/* Send message to SMS */
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
@@ -2074,7 +2074,7 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
 	return rc;
 }
 
-int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
+int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 		u8 *level) {
 
 	u32 totalLen;
@@ -2082,15 +2082,15 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
 	void *buffer;
 
 	struct SetGpioMsg {
-		struct SmsMsgHdr_ST xMsgHeader;
+		struct sms_msg_hdr x_msg_header;
 		u32 msgData[2];
 	} *pMsg;
 
 
-	if (PinNum > MAX_GPIO_PIN_NUMBER)
+	if (pin_num > MAX_GPIO_PIN_NUMBER)
 		return -EINVAL;
 
-	totalLen = sizeof(struct SmsMsgHdr_ST) + (2 * sizeof(u32));
+	totalLen = sizeof(struct sms_msg_hdr) + (2 * sizeof(u32));
 
 	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
 			GFP_KERNEL | GFP_DMA);
@@ -2099,12 +2099,12 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
 
 	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->xMsgHeader.msgDstId = HIF_TASK;
-	pMsg->xMsgHeader.msgFlags = 0;
-	pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_GET_LEVEL_REQ;
-	pMsg->xMsgHeader.msgLength = (u16) totalLen;
-	pMsg->msgData[0] = PinNum;
+	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
+	pMsg->x_msg_header.msg_flags = 0;
+	pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_GET_LEVEL_REQ;
+	pMsg->x_msg_header.msg_length = (u16) totalLen;
+	pMsg->msgData[0] = pin_num;
 	pMsg->msgData[1] = 0;
 
 	/* Send message to SMS */
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index bb74246..4b0cd7d 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -577,8 +577,8 @@ enum msg_types {
 };
 
 #define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
-	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
-	(ptr)->msgLength = len; (ptr)->msgFlags = 0; \
+	(ptr)->msg_type = type; (ptr)->msg_src_id = src; (ptr)->msg_dst_id = dst; \
+	(ptr)->msg_length = len; (ptr)->msg_flags = 0; \
 } while (0)
 
 #define SMS_INIT_MSG(ptr, type, len) \
@@ -611,78 +611,78 @@ enum SMS_DEVICE_MODE {
 	DEVICE_MODE_MAX,
 };
 
-struct SmsMsgHdr_ST {
-	u16	msgType;
-	u8	msgSrcId;
-	u8	msgDstId;
-	u16	msgLength; /* Length of entire message, including header */
-	u16	msgFlags;
+struct sms_msg_hdr {
+	u16	msg_type;
+	u8	msg_src_id;
+	u8	msg_dst_id;
+	u16	msg_length; /* length of entire message, including header */
+	u16	msg_flags;
 };
 
-struct SmsMsgData_ST {
-	struct SmsMsgHdr_ST xMsgHeader;
+struct sms_msg_data {
+	struct sms_msg_hdr x_msg_header;
 	u32 msgData[1];
 };
 
-struct SmsMsgData_ST2 {
-	struct SmsMsgHdr_ST xMsgHeader;
+struct sms_msg_data2 {
+	struct sms_msg_hdr x_msg_header;
 	u32 msgData[2];
 };
 
-struct SmsMsgData_ST4 {
-	struct SmsMsgHdr_ST xMsgHeader;
+struct sms_msg_data4 {
+	struct sms_msg_hdr x_msg_header;
 	u32 msgData[4];
 };
 
-struct SmsDataDownload_ST {
-	struct SmsMsgHdr_ST	xMsgHeader;
-	u32			MemAddr;
-	u8			Payload[SMS_MAX_PAYLOAD_SIZE];
+struct sms_data_download {
+	struct sms_msg_hdr	x_msg_header;
+	u32			mem_addr;
+	u8			payload[SMS_MAX_PAYLOAD_SIZE];
 };
 
-struct SmsVersionRes_ST {
-	struct SmsMsgHdr_ST	xMsgHeader;
+struct sms_version_res {
+	struct sms_msg_hdr	x_msg_header;
 
-	u16		ChipModel; /* e.g. 0x1102 for SMS-1102 "Nova" */
-	u8		Step; /* 0 - Step A */
-	u8		MetalFix; /* 0 - Metal 0 */
+	u16		chip_model; /* e.g. 0x1102 for SMS-1102 "Nova" */
+	u8		step; /* 0 - step A */
+	u8		metal_fix; /* 0 - Metal 0 */
 
-	/* FirmwareId 0xFF if ROM, otherwise the
+	/* firmware_id 0xFF if ROM, otherwise the
 	 * value indicated by SMSHOSTLIB_DEVICE_MODES_E */
-	u8 FirmwareId;
-	/* SupportedProtocols Bitwise OR combination of
+	u8 firmware_id;
+	/* supported_protocols Bitwise OR combination of
 					     * supported protocols */
-	u8 SupportedProtocols;
+	u8 supported_protocols;
 
-	u8		VersionMajor;
-	u8		VersionMinor;
-	u8		VersionPatch;
-	u8		VersionFieldPatch;
+	u8		version_major;
+	u8		version_minor;
+	u8		version_patch;
+	u8		version_field_patch;
 
-	u8		RomVersionMajor;
-	u8		RomVersionMinor;
-	u8		RomVersionPatch;
-	u8		RomVersionFieldPatch;
+	u8		rom_ver_major;
+	u8		rom_ver_minor;
+	u8		rom_ver_patch;
+	u8		rom_ver_field_patch;
 
 	u8		TextLabel[34];
 };
 
-struct SmsFirmware_ST {
-	u32			CheckSum;
-	u32			Length;
-	u32			StartAddress;
-	u8			Payload[1];
+struct sms_firmware {
+	u32			check_sum;
+	u32			length;
+	u32			start_address;
+	u8			payload[1];
 };
 
-/* Statistics information returned as response for
- * SmsHostApiGetStatistics_Req */
+/* statistics information returned as response for
+ * SmsHostApiGetstatistics_Req */
 struct SMSHOSTLIB_STATISTICS_ST {
-	u32 Reserved;		/* Reserved */
+	u32 reserved;		/* reserved */
 
 	/* Common parameters */
-	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
+	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
+	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
+	u32 is_external_lna_on;	/* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
 	s32 SNR;		/* dB */
@@ -693,137 +693,137 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
 	s32 RSSI;		/* dBm */
-	s32 InBandPwr;		/* In band power in dBM */
-	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
+	s32 in_band_pwr;		/* In band power in dBM */
+	s32 carrier_offset;	/* Carrier Offset in bin/1024 */
 
 	/* Transmission parameters */
-	u32 Frequency;		/* Frequency in Hz */
-	u32 Bandwidth;		/* Bandwidth in MHz, valid only for DVB-T/H */
-	u32 TransmissionMode;	/* Transmission Mode, for DAB modes 1-4,
+	u32 frequency;		/* frequency in Hz */
+	u32 bandwidth;		/* bandwidth in MHz, valid only for DVB-T/H */
+	u32 transmission_mode;	/* Transmission Mode, for DAB modes 1-4,
 	for DVB-T/H FFT mode carriers in Kilos */
-	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET,
+	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET,
 	valid only for DVB-T/H */
-	u32 GuardInterval;	/* Guard Interval from
+	u32 guard_interval;	/* Guard Interval from
 	SMSHOSTLIB_GUARD_INTERVALS_ET, 	valid only for DVB-T/H */
-	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
+	u32 code_rate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
 	valid only for DVB-T/H */
-	u32 LPCodeRate;		/* Low Priority Code Rate from
+	u32 lp_code_rate;		/* Low Priority Code Rate from
 	SMSHOSTLIB_CODE_RATE_ET, valid only for DVB-T/H */
-	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET,
+	u32 hierarchy;		/* hierarchy from SMSHOSTLIB_HIERARCHY_ET,
 	valid only for DVB-T/H */
-	u32 Constellation;	/* Constellation from
+	u32 constellation;	/* constellation from
 	SMSHOSTLIB_CONSTELLATION_ET, valid only for DVB-T/H */
 
 	/* Burst parameters, valid only for DVB-H */
-	u32 BurstSize;		/* Current burst size in bytes,
+	u32 burst_size;		/* Current burst size in bytes,
 	valid only for DVB-H */
-	u32 BurstDuration;	/* Current burst duration in mSec,
+	u32 burst_duration;	/* Current burst duration in mSec,
 	valid only for DVB-H */
-	u32 BurstCycleTime;	/* Current burst cycle time in mSec,
+	u32 burst_cycle_time;	/* Current burst cycle time in mSec,
 	valid only for DVB-H */
-	u32 CalculatedBurstCycleTime;/* Current burst cycle time in mSec,
+	u32 calc_burst_cycle_time;/* Current burst cycle time in mSec,
 	as calculated by demodulator, valid only for DVB-H */
-	u32 NumOfRows;		/* Number of rows in MPE table,
+	u32 num_of_rows;		/* Number of rows in MPE table,
 	valid only for DVB-H */
-	u32 NumOfPaddCols;	/* Number of padding columns in MPE table,
+	u32 num_of_padd_cols;	/* Number of padding columns in MPE table,
 	valid only for DVB-H */
-	u32 NumOfPunctCols;	/* Number of puncturing columns in MPE table,
+	u32 num_of_punct_cols;	/* Number of puncturing columns in MPE table,
 	valid only for DVB-H */
-	u32 ErrorTSPackets;	/* Number of erroneous
+	u32 error_ts_packets;	/* Number of erroneous
 	transport-stream packets */
-	u32 TotalTSPackets;	/* Total number of transport-stream packets */
-	u32 NumOfValidMpeTlbs;	/* Number of MPE tables which do not include
+	u32 total_ts_packets;	/* Total number of transport-stream packets */
+	u32 num_of_valid_mpe_tlbs;	/* Number of MPE tables which do not include
 	errors after MPE RS decoding */
-	u32 NumOfInvalidMpeTlbs;/* Number of MPE tables which include errors
+	u32 num_of_invalid_mpe_tlbs;/* Number of MPE tables which include errors
 	after MPE RS decoding */
-	u32 NumOfCorrectedMpeTlbs;/* Number of MPE tables which were
+	u32 num_of_corrected_mpe_tlbs;/* Number of MPE tables which were
 	corrected by MPE RS decoding */
 	/* Common params */
-	u32 BERErrorCount;	/* Number of errornous SYNC bits. */
-	u32 BERBitCount;	/* Total number of SYNC bits. */
+	u32 ber_error_count;	/* Number of errornous SYNC bits. */
+	u32 ber_bit_count;	/* Total number of SYNC bits. */
 
 	/* Interface information */
-	u32 SmsToHostTxErrors;	/* Total number of transmission errors. */
+	u32 sms_to_host_tx_errors;	/* Total number of transmission errors. */
 
 	/* DAB/T-DMB */
-	u32 PreBER; 		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
+	u32 pre_ber; 		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
 
 	/* DVB-H TPS parameters */
-	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
+	u32 cell_id;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
 	 if set to 0xFFFFFFFF cell_id not yet recovered */
-	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
+	u32 dvbh_srv_ind_hp;	/* DVB-H service indication info, bit 1 -
 	Time Slicing indicator, bit 0 - MPE-FEC indicator */
-	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
+	u32 dvbh_srv_ind_lp;	/* DVB-H service indication info, bit 1 -
 	Time Slicing indicator, bit 0 - MPE-FEC indicator */
 
-	u32 NumMPEReceived;	/* DVB-H, Num MPE section received */
+	u32 num_mpe_received;	/* DVB-H, Num MPE section received */
 
-	u32 ReservedFields[10];	/* Reserved */
+	u32 reservedFields[10];	/* reserved */
 };
 
-struct SmsMsgStatisticsInfo_ST {
-	u32 RequestResult;
+struct sms_msg_statistics_info {
+	u32 request_result;
 
-	struct SMSHOSTLIB_STATISTICS_ST Stat;
+	struct SMSHOSTLIB_STATISTICS_ST stat;
 
 	/* Split the calc of the SNR in DAB */
-	u32 Signal; /* dB */
-	u32 Noise; /* dB */
+	u32 signal; /* dB */
+	u32 noise; /* dB */
 
 };
 
 struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
 	/* Per-layer information */
-	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
+	u32 code_rate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
 		       * 255 means layer does not exist */
-	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET,
+	u32 constellation; /* constellation from SMSHOSTLIB_CONSTELLATION_ET,
 			    * 255 means layer does not exist */
 	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 BERErrorCount; /* Post Viterbi Error Bits Count */
-	u32 BERBitCount; /* Post Viterbi Total Bits Count */
-	u32 PreBER; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
+	u32 ber_error_count; /* Post Viterbi Error Bits Count */
+	u32 ber_bit_count; /* Post Viterbi Total Bits Count */
+	u32 pre_ber; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
 	u32 TS_PER; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-	u32 TILdepthI; /* Time interleaver depth I parameter,
+	u32 error_ts_packets; /* Number of erroneous transport-stream packets */
+	u32 total_ts_packets; /* Total number of transport-stream packets */
+	u32 ti_ldepth_i; /* Time interleaver depth I parameter,
 			* 255 means layer does not exist */
-	u32 NumberOfSegments; /* Number of segments in layer A,
+	u32 number_of_segments; /* Number of segments in layer A,
 			       * 255 means layer does not exist */
-	u32 TMCCErrors; /* TMCC errors */
+	u32 tmcc_errors; /* TMCC errors */
 };
 
 struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
-	u32 StatisticsType; /* Enumerator identifying the type of the
+	u32 statistics_type; /* Enumerator identifying the type of the
 				* structure.  Values are the same as
 				* SMSHOSTLIB_DEVICE_MODES_E
 				*
 				* This field MUST always be first in any
 				* statistics structure */
 
-	u32 FullSize; /* Total size of the structure returned by the modem.
+	u32 full_size; /* Total size of the structure returned by the modem.
 		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
+		       * full_size, the struct will be truncated */
 
 	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
+	u32 is_rf_locked; /* 0 - not locked, 1 - locked */
+	u32 is_demod_locked; /* 0 - not locked, 1 - locked */
+	u32 is_external_lna_on; /* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
 	s32  SNR; /* dB */
 	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in Hz */
+	s32  in_band_pwr; /* In band power in dBM */
+	s32  carrier_offset; /* Carrier Offset in Hz */
 
 	/* Transmission parameters */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 TransmissionMode; /* ISDB-T transmission mode */
-	u32 ModemState; /* 0 - Acquisition, 1 - Locked */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 SystemType; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
-	u32 PartialReception; /* TRUE - partial reception, FALSE otherwise */
-	u32 NumOfLayers; /* Number of ISDB-T layers in the network */
+	u32 frequency; /* frequency in Hz */
+	u32 bandwidth; /* bandwidth in MHz */
+	u32 transmission_mode; /* ISDB-T transmission mode */
+	u32 modem_state; /* 0 - Acquisition, 1 - Locked */
+	u32 guard_interval; /* Guard Interval, 1 divided by value */
+	u32 system_type; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
+	u32 partial_reception; /* TRUE - partial reception, FALSE otherwise */
+	u32 num_of_layers; /* Number of ISDB-T layers in the network */
 
 	/* Per-layer information */
 	/* Layers A, B and C */
@@ -831,44 +831,44 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
 
 	/* Interface information */
-	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
+	u32 sms_to_host_tx_errors; /* Total number of transmission errors. */
 };
 
 struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
-	u32 StatisticsType; /* Enumerator identifying the type of the
+	u32 statistics_type; /* Enumerator identifying the type of the
 				* structure.  Values are the same as
 				* SMSHOSTLIB_DEVICE_MODES_E
 				*
 				* This field MUST always be first in any
 				* statistics structure */
 
-	u32 FullSize; /* Total size of the structure returned by the modem.
+	u32 full_size; /* Total size of the structure returned by the modem.
 		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
+		       * full_size, the struct will be truncated */
 
 	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
+	u32 is_rf_locked; /* 0 - not locked, 1 - locked */
+	u32 is_demod_locked; /* 0 - not locked, 1 - locked */
+	u32 is_external_lna_on; /* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
 	s32  SNR; /* dB */
 	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in Hz */
+	s32  in_band_pwr; /* In band power in dBM */
+	s32  carrier_offset; /* Carrier Offset in Hz */
 
 	/* Transmission parameters */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 TransmissionMode; /* ISDB-T transmission mode */
-	u32 ModemState; /* 0 - Acquisition, 1 - Locked */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 SystemType; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
-	u32 PartialReception; /* TRUE - partial reception, FALSE otherwise */
-	u32 NumOfLayers; /* Number of ISDB-T layers in the network */
-
-	u32 SegmentNumber; /* Segment number for ISDB-Tsb */
-	u32 TuneBW;	   /* Tuned bandwidth - BW_ISDBT_1SEG / BW_ISDBT_3SEG */
+	u32 frequency; /* frequency in Hz */
+	u32 bandwidth; /* bandwidth in MHz */
+	u32 transmission_mode; /* ISDB-T transmission mode */
+	u32 modem_state; /* 0 - Acquisition, 1 - Locked */
+	u32 guard_interval; /* Guard Interval, 1 divided by value */
+	u32 system_type; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
+	u32 partial_reception; /* TRUE - partial reception, FALSE otherwise */
+	u32 num_of_layers; /* Number of ISDB-T layers in the network */
+
+	u32 segment_number; /* Segment number for ISDB-Tsb */
+	u32 tune_bw;	   /* Tuned bandwidth - BW_ISDBT_1SEG / BW_ISDBT_3SEG */
 
 	/* Per-layer information */
 	/* Layers A, B and C */
@@ -876,21 +876,21 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
 	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
 
 	/* Interface information */
-	u32 Reserved1;    /* Was SmsToHostTxErrors - obsolete . */
+	u32 reserved1;    /* Was sms_to_host_tx_errors - obsolete . */
  /* Proprietary information */
-	u32 ExtAntenna;    /* Obsolete field. */
-	u32 ReceptionQuality;
-	u32 EwsAlertActive;   /* Signals if EWS alert is currently on */
-	u32 LNAOnOff;	/* Internal LNA state: 0: OFF, 1: ON */
-
-	u32 RfAgcLevel;	 /* RF AGC Level [linear units], full gain = 65535 (20dB) */
-	u32 BbAgcLevel;    /* Baseband AGC level [linear units], full gain = 65535 (71.5dB) */
-	u32 FwErrorsCounter;   /* Application errors - should be always zero */
+	u32 ext_antenna;    /* Obsolete field. */
+	u32 reception_quality;
+	u32 ews_alert_active;   /* signals if EWS alert is currently on */
+	u32 lna_on_off;	/* Internal LNA state: 0: OFF, 1: ON */
+
+	u32 rf_agc_level;	 /* RF AGC Level [linear units], full gain = 65535 (20dB) */
+	u32 bb_agc_level;    /* Baseband AGC level [linear units], full gain = 65535 (71.5dB) */
+	u32 fw_errors_counter;   /* Application errors - should be always zero */
 	u8 FwErrorsHistoryArr[8]; /* Last FW errors IDs - first is most recent, last is oldest */
 
 	s32  MRC_SNR;     /* dB */
-	u32 SNRFullRes;    /* dB x 65536 */
-	u32 Reserved4[4];
+	u32 snr_full_res;    /* dB x 65536 */
+	u32 reserved4[4];
 };
 
 
@@ -916,148 +916,148 @@ struct PID_DATA_S {
 };
 
 #define CORRECT_STAT_RSSI(_stat) ((_stat).RSSI *= -1)
-#define CORRECT_STAT_BANDWIDTH(_stat) (_stat.Bandwidth = 8 - _stat.Bandwidth)
+#define CORRECT_STAT_BANDWIDTH(_stat) (_stat.bandwidth = 8 - _stat.bandwidth)
 #define CORRECT_STAT_TRANSMISSON_MODE(_stat) \
-	if (_stat.TransmissionMode == 0) \
-		_stat.TransmissionMode = 2; \
-	else if (_stat.TransmissionMode == 1) \
-		_stat.TransmissionMode = 8; \
+	if (_stat.transmission_mode == 0) \
+		_stat.transmission_mode = 2; \
+	else if (_stat.transmission_mode == 1) \
+		_stat.transmission_mode = 8; \
 		else \
-			_stat.TransmissionMode = 4;
+			_stat.transmission_mode = 4;
 
 struct TRANSMISSION_STATISTICS_S {
-	u32 Frequency;		/* Frequency in Hz */
-	u32 Bandwidth;		/* Bandwidth in MHz */
-	u32 TransmissionMode;	/* FFT mode carriers in Kilos */
-	u32 GuardInterval;	/* Guard Interval from
+	u32 frequency;		/* frequency in Hz */
+	u32 bandwidth;		/* bandwidth in MHz */
+	u32 transmission_mode;	/* FFT mode carriers in Kilos */
+	u32 guard_interval;	/* Guard Interval from
 	SMSHOSTLIB_GUARD_INTERVALS_ET */
-	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
-	u32 LPCodeRate;		/* Low Priority Code Rate from
+	u32 code_rate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
+	u32 lp_code_rate;		/* Low Priority Code Rate from
 	SMSHOSTLIB_CODE_RATE_ET */
-	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
-	u32 Constellation;	/* Constellation from
+	u32 hierarchy;		/* hierarchy from SMSHOSTLIB_HIERARCHY_ET */
+	u32 constellation;	/* constellation from
 	SMSHOSTLIB_CONSTELLATION_ET */
 
 	/* DVB-H TPS parameters */
-	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
+	u32 cell_id;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
 	 if set to 0xFFFFFFFF cell_id not yet recovered */
-	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
+	u32 dvbh_srv_ind_hp;	/* DVB-H service indication info, bit 1 -
 	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
-	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
+	u32 dvbh_srv_ind_lp;	/* DVB-H service indication info, bit 1 -
 	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
-	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 };
 
 struct RECEPTION_STATISTICS_S {
-	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
+	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
+	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
+	u32 is_external_lna_on;	/* 0 - external LNA off, 1 - external LNA on */
 
-	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
+	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
 	u32 BER;		/* Post Viterbi BER [1E-5] */
-	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
-	u32 BERBitCount;	/* Total number of SYNC bits. */
+	u32 ber_error_count;	/* Number of erronous SYNC bits. */
+	u32 ber_bit_count;	/* Total number of SYNC bits. */
 	u32 TS_PER;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
 	s32 RSSI;		/* dBm */
-	s32 InBandPwr;		/* In band power in dBM */
-	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
-	u32 ErrorTSPackets;	/* Number of erroneous
+	s32 in_band_pwr;		/* In band power in dBM */
+	s32 carrier_offset;	/* Carrier Offset in bin/1024 */
+	u32 error_ts_packets;	/* Number of erroneous
 	transport-stream packets */
-	u32 TotalTSPackets;	/* Total number of transport-stream packets */
+	u32 total_ts_packets;	/* Total number of transport-stream packets */
 
 	s32 MRC_SNR;		/* dB */
 	s32 MRC_RSSI;		/* dBm */
-	s32 MRC_InBandPwr;	/* In band power in dBM */
+	s32 mrc_in_band_pwr;	/* In band power in dBM */
 };
 
 struct RECEPTION_STATISTICS_EX_S {
-	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
+	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
+	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
+	u32 is_external_lna_on;	/* 0 - external LNA off, 1 - external LNA on */
 
-	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
+	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
 	u32 BER;		/* Post Viterbi BER [1E-5] */
-	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
-	u32 BERBitCount;	/* Total number of SYNC bits. */
+	u32 ber_error_count;	/* Number of erronous SYNC bits. */
+	u32 ber_bit_count;	/* Total number of SYNC bits. */
 	u32 TS_PER;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
 	s32 RSSI;		/* dBm */
-	s32 InBandPwr;		/* In band power in dBM */
-	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
-	u32 ErrorTSPackets;	/* Number of erroneous
+	s32 in_band_pwr;		/* In band power in dBM */
+	s32 carrier_offset;	/* Carrier Offset in bin/1024 */
+	u32 error_ts_packets;	/* Number of erroneous
 	transport-stream packets */
-	u32 TotalTSPackets;	/* Total number of transport-stream packets */
+	u32 total_ts_packets;	/* Total number of transport-stream packets */
 
-	s32  RefDevPPM;
-	s32  FreqDevHz;
+	s32  ref_dev_ppm;
+	s32  freq_dev_hz;
 
 	s32 MRC_SNR;		/* dB */
 	s32 MRC_RSSI;		/* dBm */
-	s32 MRC_InBandPwr;	/* In band power in dBM */
+	s32 mrc_in_band_pwr;	/* In band power in dBM */
 };
 
 
-/* Statistics information returned as response for
- * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up */
+/* statistics information returned as response for
+ * SmsHostApiGetstatisticsEx_Req for DVB applications, SMS1100 and up */
 struct SMSHOSTLIB_STATISTICS_DVB_S {
 	/* Reception */
-	struct RECEPTION_STATISTICS_S ReceptionData;
+	struct RECEPTION_STATISTICS_S reception_data;
 
 	/* Transmission parameters */
-	struct TRANSMISSION_STATISTICS_S TransmissionData;
+	struct TRANSMISSION_STATISTICS_S transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
 #define	SRVM_MAX_PID_FILTERS 8
-	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
+	struct PID_DATA_S pid_data[SRVM_MAX_PID_FILTERS];
 };
 
-/* Statistics information returned as response for
- * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up */
+/* statistics information returned as response for
+ * SmsHostApiGetstatisticsEx_Req for DVB applications, SMS1100 and up */
 struct SMSHOSTLIB_STATISTICS_DVB_EX_S {
 	/* Reception */
-	struct RECEPTION_STATISTICS_EX_S ReceptionData;
+	struct RECEPTION_STATISTICS_EX_S reception_data;
 
 	/* Transmission parameters */
-	struct TRANSMISSION_STATISTICS_S TransmissionData;
+	struct TRANSMISSION_STATISTICS_S transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
 #define	SRVM_MAX_PID_FILTERS 8
-	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
+	struct PID_DATA_S pid_data[SRVM_MAX_PID_FILTERS];
 };
 
 struct SRVM_SIGNAL_STATUS_S {
 	u32 result;
 	u32 snr;
-	u32 tsPackets;
-	u32 etsPackets;
+	u32 ts_packets;
+	u32 ets_packets;
 	u32 constellation;
-	u32 hpCode;
-	u32 tpsSrvIndLP;
-	u32 tpsSrvIndHP;
-	u32 cellId;
+	u32 hp_code;
+	u32 tps_srv_ind_lp;
+	u32 tps_srv_ind_hp;
+	u32 cell_id;
 	u32 reason;
 
-	s32 inBandPower;
-	u32 requestId;
+	s32 in_band_power;
+	u32 request_id;
 };
 
 struct SMSHOSTLIB_I2C_REQ_ST {
-	u32	DeviceAddress; /* I2c device address */
-	u32	WriteCount; /* number of bytes to write */
-	u32	ReadCount; /* number of bytes to read */
+	u32	device_address; /* I2c device address */
+	u32	write_count; /* number of bytes to write */
+	u32	read_count; /* number of bytes to read */
 	u8	Data[1];
 };
 
 struct SMSHOSTLIB_I2C_RES_ST {
-	u32	Status; /* non-zero value in case of failure */
-	u32	ReadCount; /* number of bytes read */
+	u32	status; /* non-zero value in case of failure */
+	u32	read_count; /* number of bytes read */
 	u8	Data[1];
 };
 
@@ -1154,11 +1154,11 @@ int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
 int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
 
 /* new GPIO management */
-extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
-		struct smscore_config_gpio *pGpioConfig);
-extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
-		u8 NewLevel);
-extern int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
+extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
+		struct smscore_config_gpio *p_gpio_config);
+extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
+		u8 new_level);
+extern int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 		u8 *level);
 
 void smscore_set_board_id(struct smscore_device_t *core, int id);
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 0219be3..5a28506 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -63,11 +63,11 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 	buf = debug_data->stats_data;
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsRfLocked = %d\n", p->IsRfLocked);
+		      "is_rf_locked = %d\n", p->is_rf_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsDemodLocked = %d\n", p->IsDemodLocked);
+		      "is_demod_locked = %d\n", p->is_demod_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+		      "is_external_lna_on = %d\n", p->is_external_lna_on);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "SNR = %d\n", p->SNR);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
@@ -81,70 +81,70 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "RSSI = %d\n", p->RSSI);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "InBandPwr = %d\n", p->InBandPwr);
+		      "in_band_pwr = %d\n", p->in_band_pwr);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CarrierOffset = %d\n", p->CarrierOffset);
+		      "carrier_offset = %d\n", p->carrier_offset);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "ModemState = %d\n", p->ModemState);
+		      "modem_state = %d\n", p->modem_state);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Frequency = %d\n", p->Frequency);
+		      "frequency = %d\n", p->frequency);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Bandwidth = %d\n", p->Bandwidth);
+		      "bandwidth = %d\n", p->bandwidth);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "TransmissionMode = %d\n", p->TransmissionMode);
+		      "transmission_mode = %d\n", p->transmission_mode);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "ModemState = %d\n", p->ModemState);
+		      "modem_state = %d\n", p->modem_state);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "GuardInterval = %d\n", p->GuardInterval);
+		      "guard_interval = %d\n", p->guard_interval);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CodeRate = %d\n", p->CodeRate);
+		      "code_rate = %d\n", p->code_rate);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "LPCodeRate = %d\n", p->LPCodeRate);
+		      "lp_code_rate = %d\n", p->lp_code_rate);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Hierarchy = %d\n", p->Hierarchy);
+		      "hierarchy = %d\n", p->hierarchy);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Constellation = %d\n", p->Constellation);
+		      "constellation = %d\n", p->constellation);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BurstSize = %d\n", p->BurstSize);
+		      "burst_size = %d\n", p->burst_size);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BurstDuration = %d\n", p->BurstDuration);
+		      "burst_duration = %d\n", p->burst_duration);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BurstCycleTime = %d\n", p->BurstCycleTime);
+		      "burst_cycle_time = %d\n", p->burst_cycle_time);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CalculatedBurstCycleTime = %d\n",
-	              p->CalculatedBurstCycleTime);
+		      "calc_burst_cycle_time = %d\n",
+	              p->calc_burst_cycle_time);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfRows = %d\n", p->NumOfRows);
+		      "num_of_rows = %d\n", p->num_of_rows);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfPaddCols = %d\n", p->NumOfPaddCols);
+		      "num_of_padd_cols = %d\n", p->num_of_padd_cols);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfPunctCols = %d\n", p->NumOfPunctCols);
+		      "num_of_punct_cols = %d\n", p->num_of_punct_cols);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "ErrorTSPackets = %d\n", p->ErrorTSPackets);
+		      "error_ts_packets = %d\n", p->error_ts_packets);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "TotalTSPackets = %d\n", p->TotalTSPackets);
+		      "total_ts_packets = %d\n", p->total_ts_packets);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfValidMpeTlbs = %d\n", p->NumOfValidMpeTlbs);
+		      "num_of_valid_mpe_tlbs = %d\n", p->num_of_valid_mpe_tlbs);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfInvalidMpeTlbs = %d\n", p->NumOfInvalidMpeTlbs);
+		      "num_of_invalid_mpe_tlbs = %d\n", p->num_of_invalid_mpe_tlbs);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfCorrectedMpeTlbs = %d\n", p->NumOfCorrectedMpeTlbs);
+		      "num_of_corrected_mpe_tlbs = %d\n", p->num_of_corrected_mpe_tlbs);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BERErrorCount = %d\n", p->BERErrorCount);
+		      "ber_error_count = %d\n", p->ber_error_count);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BERBitCount = %d\n", p->BERBitCount);
+		      "ber_bit_count = %d\n", p->ber_bit_count);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "SmsToHostTxErrors = %d\n", p->SmsToHostTxErrors);
+		      "sms_to_host_tx_errors = %d\n", p->sms_to_host_tx_errors);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "PreBER = %d\n", p->PreBER);
+		      "pre_ber = %d\n", p->pre_ber);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CellId = %d\n", p->CellId);
+		      "cell_id = %d\n", p->cell_id);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "DvbhSrvIndHP = %d\n", p->DvbhSrvIndHP);
+		      "dvbh_srv_ind_hp = %d\n", p->dvbh_srv_ind_hp);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "DvbhSrvIndLP = %d\n", p->DvbhSrvIndLP);
+		      "dvbh_srv_ind_lp = %d\n", p->dvbh_srv_ind_lp);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumMPEReceived = %d\n", p->NumMPEReceived);
+		      "num_mpe_received = %d\n", p->num_mpe_received);
 
 	debug_data->stats_count = n;
 	spin_unlock(&debug_data->lock);
@@ -166,74 +166,74 @@ void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 	buf = debug_data->stats_data;
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "StatisticsType = %d\t", p->StatisticsType);
+		      "statistics_type = %d\t", p->statistics_type);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "FullSize = %d\n", p->FullSize);
+		      "full_size = %d\n", p->full_size);
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsRfLocked = %d\t\t", p->IsRfLocked);
+		      "is_rf_locked = %d\t\t", p->is_rf_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsDemodLocked = %d\t", p->IsDemodLocked);
+		      "is_demod_locked = %d\t", p->is_demod_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+		      "is_external_lna_on = %d\n", p->is_external_lna_on);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "SNR = %d dB\t\t", p->SNR);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "RSSI = %d dBm\t\t", p->RSSI);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "InBandPwr = %d dBm\n", p->InBandPwr);
+		      "in_band_pwr = %d dBm\n", p->in_band_pwr);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CarrierOffset = %d\t", p->CarrierOffset);
+		      "carrier_offset = %d\t", p->carrier_offset);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Bandwidth = %d\t\t", p->Bandwidth);
+		      "bandwidth = %d\t\t", p->bandwidth);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Frequency = %d Hz\n", p->Frequency);
+		      "frequency = %d Hz\n", p->frequency);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "TransmissionMode = %d\t", p->TransmissionMode);
+		      "transmission_mode = %d\t", p->transmission_mode);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "ModemState = %d\t\t", p->ModemState);
+		      "modem_state = %d\t\t", p->modem_state);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "GuardInterval = %d\n", p->GuardInterval);
+		      "guard_interval = %d\n", p->guard_interval);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "SystemType = %d\t\t", p->SystemType);
+		      "system_type = %d\t\t", p->system_type);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "PartialReception = %d\t", p->PartialReception);
+		      "partial_reception = %d\t", p->partial_reception);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfLayers = %d\n", p->NumOfLayers);
+		      "num_of_layers = %d\n", p->num_of_layers);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "SmsToHostTxErrors = %d\n", p->SmsToHostTxErrors);
+		      "sms_to_host_tx_errors = %d\n", p->sms_to_host_tx_errors);
 
 	for (i = 0; i < 3; i++) {
-		if (p->LayerInfo[i].NumberOfSegments < 1 ||
-		    p->LayerInfo[i].NumberOfSegments > 13)
+		if (p->LayerInfo[i].number_of_segments < 1 ||
+		    p->LayerInfo[i].number_of_segments > 13)
 			continue;
 
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tCodeRate = %d\t",
-			      p->LayerInfo[i].CodeRate);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "Constellation = %d\n",
-			      p->LayerInfo[i].Constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tcode_rate = %d\t",
+			      p->LayerInfo[i].code_rate);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "constellation = %d\n",
+			      p->LayerInfo[i].constellation);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
 			      p->LayerInfo[i].BER);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBERErrorCount = %-5d\t",
-			      p->LayerInfo[i].BERErrorCount);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "BERBitCount = %-5d\n",
-			      p->LayerInfo[i].BERBitCount);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tPreBER = %-5d\t",
-			      p->LayerInfo[i].PreBER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber_error_count = %-5d\t",
+			      p->LayerInfo[i].ber_error_count);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "ber_bit_count = %-5d\n",
+			      p->LayerInfo[i].ber_bit_count);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tpre_ber = %-5d\t",
+			      p->LayerInfo[i].pre_ber);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
 			      p->LayerInfo[i].TS_PER);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tErrorTSPackets = %-5d\t",
-			      p->LayerInfo[i].ErrorTSPackets);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TotalTSPackets = %-5d\t",
-			      p->LayerInfo[i].TotalTSPackets);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TILdepthI = %d\n",
-			      p->LayerInfo[i].TILdepthI);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\terror_ts_packets = %-5d\t",
+			      p->LayerInfo[i].error_ts_packets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "total_ts_packets = %-5d\t",
+			      p->LayerInfo[i].total_ts_packets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "ti_ldepth_i = %d\n",
+			      p->LayerInfo[i].ti_ldepth_i);
 		n += snprintf(&buf[n], PAGE_SIZE - n,
-			      "\tNumberOfSegments = %d\t",
-			      p->LayerInfo[i].NumberOfSegments);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TMCCErrors = %d\n",
-			      p->LayerInfo[i].TMCCErrors);
+			      "\tnumber_of_segments = %d\t",
+			      p->LayerInfo[i].number_of_segments);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "tmcc_errors = %d\n",
+			      p->LayerInfo[i].tmcc_errors);
 	}
 
 	debug_data->stats_count = n;
@@ -256,76 +256,76 @@ void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
 	buf = debug_data->stats_data;
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "StatisticsType = %d\t", p->StatisticsType);
+		      "statistics_type = %d\t", p->statistics_type);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "FullSize = %d\n", p->FullSize);
+		      "full_size = %d\n", p->full_size);
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsRfLocked = %d\t\t", p->IsRfLocked);
+		      "is_rf_locked = %d\t\t", p->is_rf_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsDemodLocked = %d\t", p->IsDemodLocked);
+		      "is_demod_locked = %d\t", p->is_demod_locked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+		      "is_external_lna_on = %d\n", p->is_external_lna_on);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "SNR = %d dB\t\t", p->SNR);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "RSSI = %d dBm\t\t", p->RSSI);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "InBandPwr = %d dBm\n", p->InBandPwr);
+		      "in_band_pwr = %d dBm\n", p->in_band_pwr);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "CarrierOffset = %d\t", p->CarrierOffset);
+		      "carrier_offset = %d\t", p->carrier_offset);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Bandwidth = %d\t\t", p->Bandwidth);
+		      "bandwidth = %d\t\t", p->bandwidth);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "Frequency = %d Hz\n", p->Frequency);
+		      "frequency = %d Hz\n", p->frequency);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "TransmissionMode = %d\t", p->TransmissionMode);
+		      "transmission_mode = %d\t", p->transmission_mode);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "ModemState = %d\t\t", p->ModemState);
+		      "modem_state = %d\t\t", p->modem_state);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "GuardInterval = %d\n", p->GuardInterval);
+		      "guard_interval = %d\n", p->guard_interval);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "SystemType = %d\t\t", p->SystemType);
+		      "system_type = %d\t\t", p->system_type);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "PartialReception = %d\t", p->PartialReception);
+		      "partial_reception = %d\t", p->partial_reception);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "NumOfLayers = %d\n", p->NumOfLayers);
-	n += snprintf(&buf[n], PAGE_SIZE - n, "SegmentNumber = %d\t",
-		      p->SegmentNumber);
-	n += snprintf(&buf[n], PAGE_SIZE - n, "TuneBW = %d\n",
-		      p->TuneBW);
+		      "num_of_layers = %d\n", p->num_of_layers);
+	n += snprintf(&buf[n], PAGE_SIZE - n, "segment_number = %d\t",
+		      p->segment_number);
+	n += snprintf(&buf[n], PAGE_SIZE - n, "tune_bw = %d\n",
+		      p->tune_bw);
 
 	for (i = 0; i < 3; i++) {
-		if (p->LayerInfo[i].NumberOfSegments < 1 ||
-		    p->LayerInfo[i].NumberOfSegments > 13)
+		if (p->LayerInfo[i].number_of_segments < 1 ||
+		    p->LayerInfo[i].number_of_segments > 13)
 			continue;
 
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tCodeRate = %d\t",
-			      p->LayerInfo[i].CodeRate);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "Constellation = %d\n",
-			      p->LayerInfo[i].Constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tcode_rate = %d\t",
+			      p->LayerInfo[i].code_rate);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "constellation = %d\n",
+			      p->LayerInfo[i].constellation);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
 			      p->LayerInfo[i].BER);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBERErrorCount = %-5d\t",
-			      p->LayerInfo[i].BERErrorCount);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "BERBitCount = %-5d\n",
-			      p->LayerInfo[i].BERBitCount);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tPreBER = %-5d\t",
-			      p->LayerInfo[i].PreBER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber_error_count = %-5d\t",
+			      p->LayerInfo[i].ber_error_count);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "ber_bit_count = %-5d\n",
+			      p->LayerInfo[i].ber_bit_count);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tpre_ber = %-5d\t",
+			      p->LayerInfo[i].pre_ber);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
 			      p->LayerInfo[i].TS_PER);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tErrorTSPackets = %-5d\t",
-			      p->LayerInfo[i].ErrorTSPackets);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TotalTSPackets = %-5d\t",
-			      p->LayerInfo[i].TotalTSPackets);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TILdepthI = %d\n",
-			      p->LayerInfo[i].TILdepthI);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\terror_ts_packets = %-5d\t",
+			      p->LayerInfo[i].error_ts_packets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "total_ts_packets = %-5d\t",
+			      p->LayerInfo[i].total_ts_packets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "ti_ldepth_i = %d\n",
+			      p->LayerInfo[i].ti_ldepth_i);
 		n += snprintf(&buf[n], PAGE_SIZE - n,
-			      "\tNumberOfSegments = %d\t",
-			      p->LayerInfo[i].NumberOfSegments);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "TMCCErrors = %d\n",
-			      p->LayerInfo[i].TMCCErrors);
+			      "\tnumber_of_segments = %d\t",
+			      p->LayerInfo[i].number_of_segments);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "tmcc_errors = %d\n",
+			      p->LayerInfo[i].tmcc_errors);
 	}
 
 
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index a2882f5..cec85fe 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -228,15 +228,15 @@ static void smsdvb_update_tx_params(struct smsdvb_client_t *client,
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	c->frequency = p->Frequency;
-	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
-	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
-	c->transmission_mode = sms_to_mode(p->TransmissionMode);
-	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
-	c->code_rate_HP = sms_to_code_rate(p->CodeRate);
-	c->code_rate_LP = sms_to_code_rate(p->LPCodeRate);
-	c->hierarchy = sms_to_hierarchy(p->Hierarchy);
-	c->modulation = sms_to_modulation(p->Constellation);
+	c->frequency = p->frequency;
+	client->fe_status = sms_to_status(p->is_demod_locked, 0);
+	c->bandwidth_hz = sms_to_bw(p->bandwidth);
+	c->transmission_mode = sms_to_mode(p->transmission_mode);
+	c->guard_interval = sms_to_guard_interval(p->guard_interval);
+	c->code_rate_HP = sms_to_code_rate(p->code_rate);
+	c->code_rate_LP = sms_to_code_rate(p->lp_code_rate);
+	c->hierarchy = sms_to_hierarchy(p->hierarchy);
+	c->modulation = sms_to_modulation(p->constellation);
 }
 
 static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
@@ -245,35 +245,35 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+	client->fe_status = sms_to_status(p->is_demod_locked, p->is_rf_locked);
 	c->modulation = sms_to_modulation(p->constellation);
 
-	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->inBandPower * 1000;
+	/* signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->in_band_power * 1000;
 
-	/* Carrier to Noise ratio, in DB */
+	/* Carrier to noise ratio, in DB */
 	c->cnr.stat[0].svalue = p->snr * 1000;
 
 	/* PER/BER requires demod lock */
-	if (!p->IsDemodLocked)
+	if (!p->is_demod_locked)
 		return;
 
 	/* TS PER */
 	client->last_per = c->block_error.stat[0].uvalue;
 	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
-	c->block_error.stat[0].uvalue += p->etsPackets;
-	c->block_count.stat[0].uvalue += p->etsPackets + p->tsPackets;
+	c->block_error.stat[0].uvalue += p->ets_packets;
+	c->block_count.stat[0].uvalue += p->ets_packets + p->ts_packets;
 
 	/* BER */
 	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-	c->post_bit_error.stat[0].uvalue += p->BERErrorCount;
-	c->post_bit_count.stat[0].uvalue += p->BERBitCount;
+	c->post_bit_error.stat[0].uvalue += p->ber_error_count;
+	c->post_bit_count.stat[0].uvalue += p->ber_bit_count;
 
 	/* Legacy PER/BER */
-	client->legacy_per = (p->etsPackets * 65535) /
-			     (p->tsPackets + p->etsPackets);
+	client->legacy_per = (p->ets_packets * 65535) /
+			     (p->ts_packets + p->ets_packets);
 }
 
 static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
@@ -285,44 +285,44 @@ static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 	if (client->prt_dvb_stats)
 		client->prt_dvb_stats(client->debug_data, p);
 
-	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+	client->fe_status = sms_to_status(p->is_demod_locked, p->is_rf_locked);
 
 	/* Update DVB modulation parameters */
-	c->frequency = p->Frequency;
-	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
-	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
-	c->transmission_mode = sms_to_mode(p->TransmissionMode);
-	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
-	c->code_rate_HP = sms_to_code_rate(p->CodeRate);
-	c->code_rate_LP = sms_to_code_rate(p->LPCodeRate);
-	c->hierarchy = sms_to_hierarchy(p->Hierarchy);
-	c->modulation = sms_to_modulation(p->Constellation);
+	c->frequency = p->frequency;
+	client->fe_status = sms_to_status(p->is_demod_locked, 0);
+	c->bandwidth_hz = sms_to_bw(p->bandwidth);
+	c->transmission_mode = sms_to_mode(p->transmission_mode);
+	c->guard_interval = sms_to_guard_interval(p->guard_interval);
+	c->code_rate_HP = sms_to_code_rate(p->code_rate);
+	c->code_rate_LP = sms_to_code_rate(p->lp_code_rate);
+	c->hierarchy = sms_to_hierarchy(p->hierarchy);
+	c->modulation = sms_to_modulation(p->constellation);
 
 	/* update reception data */
-	c->lna = p->IsExternalLNAOn ? 1 : 0;
+	c->lna = p->is_external_lna_on ? 1 : 0;
 
-	/* Carrier to Noise ratio, in DB */
+	/* Carrier to noise ratio, in DB */
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
-	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+	/* signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->in_band_pwr * 1000;
 
 	/* PER/BER requires demod lock */
-	if (!p->IsDemodLocked)
+	if (!p->is_demod_locked)
 		return;
 
 	/* TS PER */
 	client->last_per = c->block_error.stat[0].uvalue;
 	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
-	c->block_error.stat[0].uvalue += p->ErrorTSPackets;
-	c->block_count.stat[0].uvalue += p->TotalTSPackets;
+	c->block_error.stat[0].uvalue += p->error_ts_packets;
+	c->block_count.stat[0].uvalue += p->total_ts_packets;
 
 	/* BER */
 	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-	c->post_bit_error.stat[0].uvalue += p->BERErrorCount;
-	c->post_bit_count.stat[0].uvalue += p->BERBitCount;
+	c->post_bit_error.stat[0].uvalue += p->ber_error_count;
+	c->post_bit_count.stat[0].uvalue += p->ber_bit_count;
 
 	/* Legacy PER/BER */
 	client->legacy_ber = p->BER;
@@ -339,26 +339,26 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	if (client->prt_isdb_stats)
 		client->prt_isdb_stats(client->debug_data, p);
 
-	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+	client->fe_status = sms_to_status(p->is_demod_locked, p->is_rf_locked);
 
 	/*
 	 * Firmware 2.1 seems to report only lock status and
-	 * Signal strength. The signal strength indicator is at the
+	 * signal strength. The signal strength indicator is at the
 	 * wrong field.
 	 */
-	if (p->StatisticsType == 0) {
-		c->strength.stat[0].uvalue = ((s32)p->TransmissionMode) * 1000;
+	if (p->statistics_type == 0) {
+		c->strength.stat[0].uvalue = ((s32)p->transmission_mode) * 1000;
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return;
 	}
 
 	/* Update ISDB-T transmission parameters */
-	c->frequency = p->Frequency;
-	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
-	c->transmission_mode = sms_to_mode(p->TransmissionMode);
-	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
-	c->isdbt_partial_reception = p->PartialReception ? 1 : 0;
-	n_layers = p->NumOfLayers;
+	c->frequency = p->frequency;
+	c->bandwidth_hz = sms_to_bw(p->bandwidth);
+	c->transmission_mode = sms_to_mode(p->transmission_mode);
+	c->guard_interval = sms_to_guard_interval(p->guard_interval);
+	c->isdbt_partial_reception = p->partial_reception ? 1 : 0;
+	n_layers = p->num_of_layers;
 	if (n_layers < 1)
 		n_layers = 1;
 	if (n_layers > 3)
@@ -366,16 +366,16 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	c->isdbt_layer_enabled = 0;
 
 	/* update reception data */
-	c->lna = p->IsExternalLNAOn ? 1 : 0;
+	c->lna = p->is_external_lna_on ? 1 : 0;
 
-	/* Carrier to Noise ratio, in DB */
+	/* Carrier to noise ratio, in DB */
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
-	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+	/* signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->in_band_pwr * 1000;
 
 	/* PER/BER and per-layer stats require demod lock */
-	if (!p->IsDemodLocked)
+	if (!p->is_demod_locked)
 		return;
 
 	client->last_per = c->block_error.stat[0].uvalue;
@@ -394,33 +394,33 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 		lr = &p->LayerInfo[i];
 
 		/* Update per-layer transmission parameters */
-		if (lr->NumberOfSegments > 0 && lr->NumberOfSegments < 13) {
+		if (lr->number_of_segments > 0 && lr->number_of_segments < 13) {
 			c->isdbt_layer_enabled |= 1 << i;
-			c->layer[i].segment_count = lr->NumberOfSegments;
+			c->layer[i].segment_count = lr->number_of_segments;
 		} else {
 			continue;
 		}
-		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
+		c->layer[i].modulation = sms_to_modulation(lr->constellation);
 
 		/* TS PER */
 		c->block_error.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->block_count.stat[i + 1].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[i + 1].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[i + 1].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[i + 1].uvalue += lr->error_ts_packets;
+		c->block_count.stat[i + 1].uvalue += lr->total_ts_packets;
 
 		/* Update global PER counter */
-		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[0].uvalue += lr->error_ts_packets;
+		c->block_count.stat[0].uvalue += lr->total_ts_packets;
 
 		/* BER */
 		c->post_bit_error.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->post_bit_count.stat[i + 1].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[i + 1].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[i + 1].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[i + 1].uvalue += lr->ber_error_count;
+		c->post_bit_count.stat[i + 1].uvalue += lr->ber_bit_count;
 
 		/* Update global BER counter */
-		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[0].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[0].uvalue += lr->ber_error_count;
+		c->post_bit_count.stat[0].uvalue += lr->ber_bit_count;
 	}
 }
 
@@ -436,13 +436,13 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 		client->prt_isdb_stats_ex(client->debug_data, p);
 
 	/* Update ISDB-T transmission parameters */
-	c->frequency = p->Frequency;
-	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
-	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
-	c->transmission_mode = sms_to_mode(p->TransmissionMode);
-	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
-	c->isdbt_partial_reception = p->PartialReception ? 1 : 0;
-	n_layers = p->NumOfLayers;
+	c->frequency = p->frequency;
+	client->fe_status = sms_to_status(p->is_demod_locked, 0);
+	c->bandwidth_hz = sms_to_bw(p->bandwidth);
+	c->transmission_mode = sms_to_mode(p->transmission_mode);
+	c->guard_interval = sms_to_guard_interval(p->guard_interval);
+	c->isdbt_partial_reception = p->partial_reception ? 1 : 0;
+	n_layers = p->num_of_layers;
 	if (n_layers < 1)
 		n_layers = 1;
 	if (n_layers > 3)
@@ -450,16 +450,16 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 	c->isdbt_layer_enabled = 0;
 
 	/* update reception data */
-	c->lna = p->IsExternalLNAOn ? 1 : 0;
+	c->lna = p->is_external_lna_on ? 1 : 0;
 
-	/* Carrier to Noise ratio, in DB */
+	/* Carrier to noise ratio, in DB */
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
-	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+	/* signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->in_band_pwr * 1000;
 
 	/* PER/BER and per-layer stats require demod lock */
-	if (!p->IsDemodLocked)
+	if (!p->is_demod_locked)
 		return;
 
 	client->last_per = c->block_error.stat[0].uvalue;
@@ -482,47 +482,47 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 		lr = &p->LayerInfo[i];
 
 		/* Update per-layer transmission parameters */
-		if (lr->NumberOfSegments > 0 && lr->NumberOfSegments < 13) {
+		if (lr->number_of_segments > 0 && lr->number_of_segments < 13) {
 			c->isdbt_layer_enabled |= 1 << i;
-			c->layer[i].segment_count = lr->NumberOfSegments;
+			c->layer[i].segment_count = lr->number_of_segments;
 		} else {
 			continue;
 		}
-		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
+		c->layer[i].modulation = sms_to_modulation(lr->constellation);
 
 		/* TS PER */
 		c->block_error.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->block_count.stat[i + 1].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[i + 1].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[i + 1].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[i + 1].uvalue += lr->error_ts_packets;
+		c->block_count.stat[i + 1].uvalue += lr->total_ts_packets;
 
 		/* Update global PER counter */
-		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[0].uvalue += lr->error_ts_packets;
+		c->block_count.stat[0].uvalue += lr->total_ts_packets;
 
 		/* BER */
 		c->post_bit_error.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->post_bit_count.stat[i + 1].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[i + 1].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[i + 1].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[i + 1].uvalue += lr->ber_error_count;
+		c->post_bit_count.stat[i + 1].uvalue += lr->ber_bit_count;
 
 		/* Update global BER counter */
-		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[0].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[0].uvalue += lr->ber_error_count;
+		c->post_bit_count.stat[0].uvalue += lr->ber_bit_count;
 	}
 }
 
 static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 {
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
-	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
+	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) (((u8 *) cb->p)
 			+ cb->offset);
 	void *p = phdr + 1;
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	bool is_status_update = false;
 
-	switch (phdr->msgType) {
+	switch (phdr->msg_type) {
 	case MSG_SMS_DVBT_BDA_DATA:
 		/*
 		 * Only feed data to dvb demux if are there any feed listening
@@ -530,7 +530,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		 */
 		if (client->feed_users && client->has_tuned)
 			dvb_dmx_swfilter(&client->demux, p,
-					 cb->size - sizeof(struct SmsMsgHdr_ST));
+					 cb->size - sizeof(struct sms_msg_hdr));
 		break;
 
 	case MSG_SMS_RF_TUNE_RES:
@@ -571,7 +571,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 			smsdvb_update_isdbt_stats(client, p);
 			break;
 		default:
-			/* Skip SmsMsgStatisticsInfo_ST:RequestResult field */
+			/* Skip sms_msg_statistics_info:request_result field */
 			smsdvb_update_dvb_stats(client, p + sizeof(u32));
 		}
 
@@ -580,7 +580,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 
 	/* Only for ISDB-T */
 	case MSG_SMS_GET_STATISTICS_EX_RES:
-		/* Skip SmsMsgStatisticsInfo_ST:RequestResult field? */
+		/* Skip sms_msg_statistics_info:request_result field? */
 		smsdvb_update_isdbt_stats_ex(client, p + sizeof(u32));
 		is_status_update = true;
 		break;
@@ -636,18 +636,18 @@ static int smsdvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct smsdvb_client_t *client =
 		container_of(feed->demux, struct smsdvb_client_t, demux);
-	struct SmsMsgData_ST PidMsg;
+	struct sms_msg_data PidMsg;
 
 	sms_debug("add pid %d(%x)",
 		  feed->pid, feed->pid);
 
 	client->feed_users++;
 
-	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
-	PidMsg.xMsgHeader.msgFlags = 0;
-	PidMsg.xMsgHeader.msgType  = MSG_SMS_ADD_PID_FILTER_REQ;
-	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
+	PidMsg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	PidMsg.x_msg_header.msg_dst_id = HIF_TASK;
+	PidMsg.x_msg_header.msg_flags = 0;
+	PidMsg.x_msg_header.msg_type  = MSG_SMS_ADD_PID_FILTER_REQ;
+	PidMsg.x_msg_header.msg_length = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
 	return smsclient_sendrequest(client->smsclient,
@@ -658,18 +658,18 @@ static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct smsdvb_client_t *client =
 		container_of(feed->demux, struct smsdvb_client_t, demux);
-	struct SmsMsgData_ST PidMsg;
+	struct sms_msg_data PidMsg;
 
 	sms_debug("remove pid %d(%x)",
 		  feed->pid, feed->pid);
 
 	client->feed_users--;
 
-	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
-	PidMsg.xMsgHeader.msgFlags = 0;
-	PidMsg.xMsgHeader.msgType  = MSG_SMS_REMOVE_PID_FILTER_REQ;
-	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
+	PidMsg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	PidMsg.x_msg_header.msg_dst_id = HIF_TASK;
+	PidMsg.x_msg_header.msg_flags = 0;
+	PidMsg.x_msg_header.msg_type  = MSG_SMS_REMOVE_PID_FILTER_REQ;
+	PidMsg.x_msg_header.msg_length = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
 	return smsclient_sendrequest(client->smsclient,
@@ -694,7 +694,7 @@ static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
 static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 {
 	int rc;
-	struct SmsMsgHdr_ST Msg;
+	struct sms_msg_hdr Msg;
 
 	/* Don't request stats too fast */
 	if (client->get_stats_jiffies &&
@@ -702,10 +702,10 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 		return 0;
 	client->get_stats_jiffies = jiffies + msecs_to_jiffies(100);
 
-	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.msgDstId = HIF_TASK;
-	Msg.msgFlags = 0;
-	Msg.msgLength = sizeof(Msg);
+	Msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.msg_dst_id = HIF_TASK;
+	Msg.msg_flags = 0;
+	Msg.msg_length = sizeof(Msg);
 
 	switch (smscore_get_device_mode(client->coredev)) {
 	case DEVICE_MODE_ISDBT:
@@ -714,12 +714,12 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 		* Check for firmware version, to avoid breaking for old cards
 		*/
 		if (client->coredev->fw_version >= 0x800)
-			Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
+			Msg.msg_type = MSG_SMS_GET_STATISTICS_EX_REQ;
 		else
-			Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+			Msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
 		break;
 	default:
-		Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+		Msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
 	}
 
 	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
@@ -845,7 +845,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 		container_of(fe, struct smsdvb_client_t, frontend);
 
 	struct {
-		struct SmsMsgHdr_ST	Msg;
+		struct sms_msg_hdr	Msg;
 		u32		Data[3];
 	} Msg;
 
@@ -856,11 +856,11 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 	client->event_unc_state = -1;
 	fe->dtv_property_cache.delivery_system = SYS_DVBT;
 
-	Msg.Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msgDstId = HIF_TASK;
-	Msg.Msg.msgFlags = 0;
-	Msg.Msg.msgType = MSG_SMS_RF_TUNE_REQ;
-	Msg.Msg.msgLength = sizeof(Msg);
+	Msg.Msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.Msg.msg_dst_id = HIF_TASK;
+	Msg.Msg.msg_flags = 0;
+	Msg.Msg.msg_type = MSG_SMS_RF_TUNE_REQ;
+	Msg.Msg.msg_length = sizeof(Msg);
 	Msg.Data[0] = c->frequency;
 	Msg.Data[2] = 12000000;
 
@@ -915,17 +915,17 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	int ret;
 
 	struct {
-		struct SmsMsgHdr_ST	Msg;
+		struct sms_msg_hdr	Msg;
 		u32		Data[4];
 	} Msg;
 
 	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
 
-	Msg.Msg.msgSrcId  = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msgDstId  = HIF_TASK;
-	Msg.Msg.msgFlags  = 0;
-	Msg.Msg.msgType   = MSG_SMS_ISDBT_TUNE_REQ;
-	Msg.Msg.msgLength = sizeof(Msg);
+	Msg.Msg.msg_src_id  = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.Msg.msg_dst_id  = HIF_TASK;
+	Msg.Msg.msg_flags  = 0;
+	Msg.Msg.msg_type   = MSG_SMS_ISDBT_TUNE_REQ;
+	Msg.Msg.msg_length = sizeof(Msg);
 
 	if (c->isdbt_sb_segment_idx == -1)
 		c->isdbt_sb_segment_idx = 0;
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index 63cdd75..e1ff07c 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -57,7 +57,7 @@ struct smsdvb_client_t {
 	int			feed_users;
 	bool			has_tuned;
 
-	/* Stats debugfs data */
+	/* stats debugfs data */
 	struct dentry		*debugfs;
 
 	struct smsdvb_debugfs	*debug_data;
@@ -74,30 +74,30 @@ struct smsdvb_client_t {
 struct RECEPTION_STATISTICS_PER_SLICES_S {
 	u32 result;
 	u32 snr;
-	s32 inBandPower;
-	u32 tsPackets;
-	u32 etsPackets;
+	s32 in_band_power;
+	u32 ts_packets;
+	u32 ets_packets;
 	u32 constellation;
-	u32 hpCode;
-	u32 tpsSrvIndLP;
-	u32 tpsSrvIndHP;
-	u32 cellId;
+	u32 hp_code;
+	u32 tps_srv_ind_lp;
+	u32 tps_srv_ind_hp;
+	u32 cell_id;
 	u32 reason;
-	u32 requestId;
-	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
+	u32 request_id;
+	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 
 	u32 BER;		/* Post Viterbi BER [1E-5] */
 	s32 RSSI;		/* dBm */
-	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
+	s32 carrier_offset;	/* Carrier Offset in bin/1024 */
 
-	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
+	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 
-	u32 BERBitCount;	/* Total number of SYNC bits. */
-	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
+	u32 ber_bit_count;	/* Total number of SYNC bits. */
+	u32 ber_error_count;	/* Number of erronous SYNC bits. */
 
 	s32 MRC_SNR;		/* dB */
-	s32 MRC_InBandPwr;	/* In band power in dBM */
+	s32 mrc_in_band_pwr;	/* In band power in dBM */
 	s32 MRC_RSSI;		/* dBm */
 };
 
diff --git a/drivers/media/common/siano/smsendian.c b/drivers/media/common/siano/smsendian.c
index e2657c2..32a7b28 100644
--- a/drivers/media/common/siano/smsendian.c
+++ b/drivers/media/common/siano/smsendian.c
@@ -28,11 +28,11 @@
 void smsendian_handle_tx_message(void *buffer)
 {
 #ifdef __BIG_ENDIAN
-	struct SmsMsgData_ST *msg = (struct SmsMsgData_ST *)buffer;
+	struct sms_msg_data *msg = (struct sms_msg_data *)buffer;
 	int i;
 	int msgWords;
 
-	switch (msg->xMsgHeader.msgType) {
+	switch (msg->x_msg_header.msg_type) {
 	case MSG_SMS_DATA_DOWNLOAD_REQ:
 	{
 		msg->msgData[0] = le32_to_cpu(msg->msgData[0]);
@@ -40,8 +40,8 @@ void smsendian_handle_tx_message(void *buffer)
 	}
 
 	default:
-		msgWords = (msg->xMsgHeader.msgLength -
-				sizeof(struct SmsMsgHdr_ST))/4;
+		msgWords = (msg->x_msg_header.msg_length -
+				sizeof(struct sms_msg_hdr))/4;
 
 		for (i = 0; i < msgWords; i++)
 			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
@@ -55,16 +55,16 @@ EXPORT_SYMBOL_GPL(smsendian_handle_tx_message);
 void smsendian_handle_rx_message(void *buffer)
 {
 #ifdef __BIG_ENDIAN
-	struct SmsMsgData_ST *msg = (struct SmsMsgData_ST *)buffer;
+	struct sms_msg_data *msg = (struct sms_msg_data *)buffer;
 	int i;
 	int msgWords;
 
-	switch (msg->xMsgHeader.msgType) {
+	switch (msg->x_msg_header.msg_type) {
 	case MSG_SMS_GET_VERSION_EX_RES:
 	{
-		struct SmsVersionRes_ST *ver =
-			(struct SmsVersionRes_ST *) msg;
-		ver->ChipModel = le16_to_cpu(ver->ChipModel);
+		struct sms_version_res *ver =
+			(struct sms_version_res *) msg;
+		ver->chip_model = le16_to_cpu(ver->chip_model);
 		break;
 	}
 
@@ -77,8 +77,8 @@ void smsendian_handle_rx_message(void *buffer)
 
 	default:
 	{
-		msgWords = (msg->xMsgHeader.msgLength -
-				sizeof(struct SmsMsgHdr_ST))/4;
+		msgWords = (msg->x_msg_header.msg_length -
+				sizeof(struct sms_msg_hdr))/4;
 
 		for (i = 0; i < msgWords; i++)
 			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
@@ -93,11 +93,11 @@ EXPORT_SYMBOL_GPL(smsendian_handle_rx_message);
 void smsendian_handle_message_header(void *msg)
 {
 #ifdef __BIG_ENDIAN
-	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)msg;
+	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *)msg;
 
-	phdr->msgType = le16_to_cpu(phdr->msgType);
-	phdr->msgLength = le16_to_cpu(phdr->msgLength);
-	phdr->msgFlags = le16_to_cpu(phdr->msgFlags);
+	phdr->msg_type = le16_to_cpu(phdr->msg_type);
+	phdr->msg_length = le16_to_cpu(phdr->msg_length);
+	phdr->msg_flags = le16_to_cpu(phdr->msg_flags);
 #endif /* __BIG_ENDIAN */
 }
 EXPORT_SYMBOL_GPL(smsendian_handle_message_header);
diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index 8834c43..912c281 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -98,7 +98,7 @@ static int smssdio_sendrequest(void *context, void *buffer, size_t size)
 
 	sdio_claim_host(smsdev->func);
 
-	smsendian_handle_tx_message((struct SmsMsgData_ST *) buffer);
+	smsendian_handle_tx_message((struct sms_msg_data *) buffer);
 	while (size >= smsdev->func->cur_blksize) {
 		ret = sdio_memcpy_toio(smsdev->func, SMSSDIO_DATA,
 					buffer, smsdev->func->cur_blksize);
@@ -130,7 +130,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 
 	struct smssdio_device *smsdev;
 	struct smscore_buffer_t *cb;
-	struct SmsMsgHdr_ST *hdr;
+	struct sms_msg_hdr *hdr;
 	size_t size;
 
 	smsdev = sdio_get_drvdata(func);
@@ -163,20 +163,20 @@ static void smssdio_interrupt(struct sdio_func *func)
 
 		hdr = cb->p;
 
-		if (hdr->msgFlags & MSG_HDR_FLAG_SPLIT_MSG) {
+		if (hdr->msg_flags & MSG_HDR_FLAG_SPLIT_MSG) {
 			smsdev->split_cb = cb;
 			return;
 		}
 
-		if (hdr->msgLength > smsdev->func->cur_blksize)
-			size = hdr->msgLength - smsdev->func->cur_blksize;
+		if (hdr->msg_length > smsdev->func->cur_blksize)
+			size = hdr->msg_length - smsdev->func->cur_blksize;
 		else
 			size = 0;
 	} else {
 		cb = smsdev->split_cb;
 		hdr = cb->p;
 
-		size = hdr->msgLength - sizeof(struct SmsMsgHdr_ST);
+		size = hdr->msg_length - sizeof(struct sms_msg_hdr);
 
 		smsdev->split_cb = NULL;
 	}
@@ -184,7 +184,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 	if (size) {
 		void *buffer;
 
-		buffer = cb->p + (hdr->msgLength - size);
+		buffer = cb->p + (hdr->msg_length - size);
 		size = ALIGN(size, SMSSDIO_BLOCK_SIZE);
 
 		BUG_ON(smsdev->func->cur_blksize != SMSSDIO_BLOCK_SIZE);
@@ -230,10 +230,10 @@ static void smssdio_interrupt(struct sdio_func *func)
 		}
 	}
 
-	cb->size = hdr->msgLength;
+	cb->size = hdr->msg_length;
 	cb->offset = 0;
 
-	smsendian_handle_rx_message((struct SmsMsgData_ST *) cb->p);
+	smsendian_handle_rx_message((struct sms_msg_data *) cb->p);
 	smscore_onresponse(smsdev->coredev, cb);
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 01a0f39..3a290f1 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -93,26 +93,26 @@ static void smsusb_onresponse(struct urb *urb)
 	}
 
 	if ((urb->actual_length > 0) && (urb->status == 0)) {
-		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
+		struct sms_msg_hdr *phdr = (struct sms_msg_hdr *)surb->cb->p;
 
 		smsendian_handle_message_header(phdr);
-		if (urb->actual_length >= phdr->msgLength) {
-			surb->cb->size = phdr->msgLength;
+		if (urb->actual_length >= phdr->msg_length) {
+			surb->cb->size = phdr->msg_length;
 
 			if (dev->response_alignment &&
-			    (phdr->msgFlags & MSG_HDR_FLAG_SPLIT_MSG)) {
+			    (phdr->msg_flags & MSG_HDR_FLAG_SPLIT_MSG)) {
 
 				surb->cb->offset =
 					dev->response_alignment +
-					((phdr->msgFlags >> 8) & 3);
+					((phdr->msg_flags >> 8) & 3);
 
 				/* sanity check */
-				if (((int) phdr->msgLength +
+				if (((int) phdr->msg_length +
 				     surb->cb->offset) > urb->actual_length) {
 					sms_err("invalid response "
 						"msglen %d offset %d "
 						"size %d",
-						phdr->msgLength,
+						phdr->msg_length,
 						surb->cb->offset,
 						urb->actual_length);
 					goto exit_and_resubmit;
@@ -121,22 +121,22 @@ static void smsusb_onresponse(struct urb *urb)
 				/* move buffer pointer and
 				 * copy header to its new location */
 				memcpy((char *) phdr + surb->cb->offset,
-				       phdr, sizeof(struct SmsMsgHdr_ST));
+				       phdr, sizeof(struct sms_msg_hdr));
 			} else
 				surb->cb->offset = 0;
 
 			sms_debug("received %s(%d) size: %d",
-				  smscore_translate_msg(phdr->msgType),
-				  phdr->msgType, phdr->msgLength);
+				  smscore_translate_msg(phdr->msg_type),
+				  phdr->msg_type, phdr->msg_length);
 
-			smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
+			smsendian_handle_rx_message((struct sms_msg_data *) phdr);
 
 			smscore_onresponse(dev->coredev, surb->cb);
 			surb->cb = NULL;
 		} else {
 			sms_err("invalid response "
 				"msglen %d actual %d",
-				phdr->msgLength, urb->actual_length);
+				phdr->msg_length, urb->actual_length);
 		}
 	} else
 		sms_err("error, urb status %d, %d bytes",
@@ -206,18 +206,18 @@ static int smsusb_start_streaming(struct smsusb_device_t *dev)
 static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 {
 	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
-	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) buffer;
+	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) buffer;
 	int dummy;
 
 	if (dev->state != SMSUSB_ACTIVE)
 		return -ENOENT;
 
 	sms_debug("sending %s(%d) size: %d",
-		  smscore_translate_msg(phdr->msgType), phdr->msgType,
-		  phdr->msgLength);
+		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
+		  phdr->msg_length);
 
-	smsendian_handle_tx_message((struct SmsMsgData_ST *) phdr);
-	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
+	smsendian_handle_tx_message((struct sms_msg_data *) phdr);
+	smsendian_handle_message_header((struct sms_msg_hdr *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
 }
@@ -310,8 +310,8 @@ static void smsusb1_detectmode(void *context, int *mode)
 
 static int smsusb1_setmode(void *context, int mode)
 {
-	struct SmsMsgHdr_ST Msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
-			     sizeof(struct SmsMsgHdr_ST), 0 };
+	struct sms_msg_hdr Msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
+			     sizeof(struct sms_msg_hdr), 0 };
 
 	if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
 		sms_err("invalid firmware id specified %d", mode);
@@ -375,7 +375,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		dev->buffer_size = USB2_BUFFER_SIZE;
 		dev->response_alignment =
 		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
-		    sizeof(struct SmsMsgHdr_ST);
+		    sizeof(struct sms_msg_hdr);
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;
-- 
1.8.1.4

