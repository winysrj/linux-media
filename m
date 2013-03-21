Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab3CUNC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:02:56 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD2uFb009627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:02:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] siano: remove the remaining CamelCase compliants
Date: Thu, 21 Mar 2013 10:02:41 -0300
Message-Id: <1363870963-28552-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the remaining CamelCase checkpatch.pl compliants.
There are still a few left, but those are due to USB and
DVB APIs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c      |   4 +-
 drivers/media/common/siano/smscoreapi.c     | 256 ++++++++++++++--------------
 drivers/media/common/siano/smscoreapi.h     |  30 ++--
 drivers/media/common/siano/smsdvb-debugfs.c |  68 ++++----
 drivers/media/common/siano/smsdvb-main.c    | 124 +++++++-------
 drivers/media/common/siano/smsdvb.h         |   2 +-
 drivers/media/common/siano/smsendian.c      |  18 +-
 drivers/media/usb/siano/smsusb.c            |   4 +-
 8 files changed, 253 insertions(+), 253 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 9bd7aa1..8276999 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -179,9 +179,9 @@ static inline void sms_gpio_assign_11xx_default_led_config(
 int sms_board_event(struct smscore_device_t *coredev,
 		    enum SMS_BOARD_EVENTS gevent)
 {
-	struct smscore_config_gpio MyGpioConfig;
+	struct smscore_config_gpio my_gpio_config;
 
-	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
+	sms_gpio_assign_11xx_default_led_config(&my_gpio_config);
 
 	switch (gevent) {
 	case BOARD_EVENT_POWER_INIT: /* including hotplug */
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e5fa405..19e7a5f 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -803,8 +803,8 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 				SMS_INIT_MSG(&msg->x_msg_header,
 						MSG_SMS_START_IR_REQ,
 						sizeof(struct sms_msg_data2));
-				msg->msgData[0] = coredev->ir.controller;
-				msg->msgData[1] = coredev->ir.timeout;
+				msg->msg_data[0] = coredev->ir.controller;
+				msg->msg_data[1] = coredev->ir.timeout;
 
 				rc = smscore_sendrequest_and_wait(coredev, msg,
 						msg->x_msg_header. msg_length,
@@ -840,31 +840,31 @@ int smscore_configure_board(struct smscore_device_t *coredev)
 	}
 
 	if (board->mtu) {
-		struct sms_msg_data MtuMsg;
+		struct sms_msg_data mtu_msg;
 		sms_debug("set max transmit unit %d", board->mtu);
 
-		MtuMsg.x_msg_header.msg_src_id = 0;
-		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
-		MtuMsg.x_msg_header.msg_flags = 0;
-		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
-		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
-		MtuMsg.msgData[0] = board->mtu;
+		mtu_msg.x_msg_header.msg_src_id = 0;
+		mtu_msg.x_msg_header.msg_dst_id = HIF_TASK;
+		mtu_msg.x_msg_header.msg_flags = 0;
+		mtu_msg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
+		mtu_msg.x_msg_header.msg_length = sizeof(mtu_msg);
+		mtu_msg.msg_data[0] = board->mtu;
 
-		coredev->sendrequest_handler(coredev->context, &MtuMsg,
-					     sizeof(MtuMsg));
+		coredev->sendrequest_handler(coredev->context, &mtu_msg,
+					     sizeof(mtu_msg));
 	}
 
 	if (board->crystal) {
-		struct sms_msg_data CrysMsg;
+		struct sms_msg_data crys_msg;
 		sms_debug("set crystal value %d", board->crystal);
 
-		SMS_INIT_MSG(&CrysMsg.x_msg_header,
+		SMS_INIT_MSG(&crys_msg.x_msg_header,
 				MSG_SMS_NEW_CRYSTAL_REQ,
-				sizeof(CrysMsg));
-		CrysMsg.msgData[0] = board->crystal;
+				sizeof(crys_msg));
+		crys_msg.msg_data[0] = board->crystal;
 
-		coredev->sendrequest_handler(coredev->context, &CrysMsg,
-					     sizeof(CrysMsg));
+		coredev->sendrequest_handler(coredev->context, &crys_msg,
+					     sizeof(crys_msg));
 	}
 
 	return 0;
@@ -959,7 +959,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		calc_checksum += *ptr;
 
 	while (size && rc >= 0) {
-		struct sms_data_download *DataMsg =
+		struct sms_data_download *data_msg =
 			(struct sms_data_download *) msg;
 		int payload_size = min((int) size, SMS_MAX_PAYLOAD_SIZE);
 
@@ -967,11 +967,11 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 			     (u16)(sizeof(struct sms_msg_hdr) +
 				      sizeof(u32) + payload_size));
 
-		DataMsg->mem_addr = mem_address;
-		memcpy(DataMsg->payload, payload, payload_size);
+		data_msg->mem_addr = mem_address;
+		memcpy(data_msg->payload, payload, payload_size);
 
-		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
-				DataMsg->x_msg_header.msg_length,
+		rc = smscore_sendrequest_and_wait(coredev, data_msg,
+				data_msg->x_msg_header.msg_length,
 				&coredev->data_download_done);
 
 		payload += payload_size;
@@ -987,10 +987,10 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_VALIDITY_REQ,
 			sizeof(msg->x_msg_header) +
 			sizeof(u32) * 3);
-	msg->msgData[0] = firmware->start_address;
+	msg->msg_data[0] = firmware->start_address;
 		/* Entry point */
-	msg->msgData[1] = firmware->length;
-	msg->msgData[2] = 0; /* Regular checksum*/
+	msg->msg_data[1] = firmware->length;
+	msg->msg_data[2] = 0; /* Regular checksum*/
 	rc = smscore_sendrequest_and_wait(coredev, msg,
 					  msg->x_msg_header.msg_length,
 					  &coredev->data_validity_done);
@@ -998,7 +998,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		goto exit_fw_download;
 
 	if (coredev->mode == DEVICE_MODE_NONE) {
-		struct sms_msg_data *TriggerMsg =
+		struct sms_msg_data *trigger_msg =
 			(struct sms_msg_data *) msg;
 
 		sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
@@ -1007,15 +1007,15 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 				sizeof(struct sms_msg_hdr) +
 				sizeof(u32) * 5);
 
-		TriggerMsg->msgData[0] = firmware->start_address;
+		trigger_msg->msg_data[0] = firmware->start_address;
 					/* Entry point */
-		TriggerMsg->msgData[1] = 6; /* Priority */
-		TriggerMsg->msgData[2] = 0x200; /* Stack size */
-		TriggerMsg->msgData[3] = 0; /* Parameter */
-		TriggerMsg->msgData[4] = 4; /* Task ID */
+		trigger_msg->msg_data[1] = 6; /* Priority */
+		trigger_msg->msg_data[2] = 0x200; /* Stack size */
+		trigger_msg->msg_data[3] = 0; /* Parameter */
+		trigger_msg->msg_data[4] = 4; /* Task ID */
 
-		rc = smscore_sendrequest_and_wait(coredev, TriggerMsg,
-					TriggerMsg->x_msg_header.msg_length,
+		rc = smscore_sendrequest_and_wait(coredev, trigger_msg,
+					trigger_msg->x_msg_header.msg_length,
 					&coredev->trigger_done);
 	} else {
 		SMS_INIT_MSG(&msg->x_msg_header, MSG_SW_RELOAD_EXEC_REQ,
@@ -1315,7 +1315,7 @@ int smscore_init_device(struct smscore_device_t *coredev, int mode)
 	msg = (struct sms_msg_data *)SMS_ALIGN_ADDRESS(buffer);
 	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_INIT_DEVICE_REQ,
 			sizeof(struct sms_msg_data));
-	msg->msgData[0] = mode;
+	msg->msg_data[0] = mode;
 
 	rc = smscore_sendrequest_and_wait(coredev, msg,
 			msg->x_msg_header. msg_length,
@@ -1403,7 +1403,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 
 			SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_INIT_DEVICE_REQ,
 				     sizeof(struct sms_msg_data));
-			msg->msgData[0] = mode;
+			msg->msg_data[0] = mode;
 
 			rc = smscore_sendrequest_and_wait(
 				coredev, msg, msg->x_msg_header.msg_length,
@@ -1563,7 +1563,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			struct sms_msg_data *validity = (struct sms_msg_data *) phdr;
 
 			sms_err("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
-				validity->msgData[0]);
+				validity->msg_data[0]);
 			complete(&coredev->data_validity_done);
 			break;
 		}
@@ -1897,52 +1897,52 @@ int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level)
 }
 
 /* new GPIO management implementation */
-static int GetGpioPinParams(u32 pin_num, u32 *pTranslatedpin_num,
-		u32 *pGroupNum, u32 *pGroupCfg) {
+static int get_gpio_pin_params(u32 pin_num, u32 *p_translatedpin_num,
+		u32 *p_group_num, u32 *p_group_cfg) {
 
-	*pGroupCfg = 1;
+	*p_group_cfg = 1;
 
 	if (pin_num <= 1)	{
-		*pTranslatedpin_num = 0;
-		*pGroupNum = 9;
-		*pGroupCfg = 2;
+		*p_translatedpin_num = 0;
+		*p_group_num = 9;
+		*p_group_cfg = 2;
 	} else if (pin_num >= 2 && pin_num <= 6) {
-		*pTranslatedpin_num = 2;
-		*pGroupNum = 0;
-		*pGroupCfg = 2;
+		*p_translatedpin_num = 2;
+		*p_group_num = 0;
+		*p_group_cfg = 2;
 	} else if (pin_num >= 7 && pin_num <= 11) {
-		*pTranslatedpin_num = 7;
-		*pGroupNum = 1;
+		*p_translatedpin_num = 7;
+		*p_group_num = 1;
 	} else if (pin_num >= 12 && pin_num <= 15) {
-		*pTranslatedpin_num = 12;
-		*pGroupNum = 2;
-		*pGroupCfg = 3;
+		*p_translatedpin_num = 12;
+		*p_group_num = 2;
+		*p_group_cfg = 3;
 	} else if (pin_num == 16) {
-		*pTranslatedpin_num = 16;
-		*pGroupNum = 23;
+		*p_translatedpin_num = 16;
+		*p_group_num = 23;
 	} else if (pin_num >= 17 && pin_num <= 24) {
-		*pTranslatedpin_num = 17;
-		*pGroupNum = 3;
+		*p_translatedpin_num = 17;
+		*p_group_num = 3;
 	} else if (pin_num == 25) {
-		*pTranslatedpin_num = 25;
-		*pGroupNum = 6;
+		*p_translatedpin_num = 25;
+		*p_group_num = 6;
 	} else if (pin_num >= 26 && pin_num <= 28) {
-		*pTranslatedpin_num = 26;
-		*pGroupNum = 4;
+		*p_translatedpin_num = 26;
+		*p_group_num = 4;
 	} else if (pin_num == 29) {
-		*pTranslatedpin_num = 29;
-		*pGroupNum = 5;
-		*pGroupCfg = 2;
+		*p_translatedpin_num = 29;
+		*p_group_num = 5;
+		*p_group_cfg = 2;
 	} else if (pin_num == 30) {
-		*pTranslatedpin_num = 30;
-		*pGroupNum = 8;
+		*p_translatedpin_num = 30;
+		*p_group_num = 8;
 	} else if (pin_num == 31) {
-		*pTranslatedpin_num = 31;
-		*pGroupNum = 17;
+		*p_translatedpin_num = 31;
+		*p_group_num = 17;
 	} else
 		return -1;
 
-	*pGroupCfg <<= 24;
+	*p_group_cfg <<= 24;
 
 	return 0;
 }
@@ -1950,18 +1950,18 @@ static int GetGpioPinParams(u32 pin_num, u32 *pTranslatedpin_num,
 int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
 		struct smscore_config_gpio *p_gpio_config) {
 
-	u32 totalLen;
-	u32 Translatedpin_num = 0;
-	u32 GroupNum = 0;
-	u32 ElectricChar;
-	u32 groupCfg;
+	u32 total_len;
+	u32 translatedpin_num = 0;
+	u32 group_num = 0;
+	u32 electric_char;
+	u32 group_cfg;
 	void *buffer;
 	int rc;
 
-	struct SetGpioMsg {
+	struct set_gpio_msg {
 		struct sms_msg_hdr x_msg_header;
-		u32 msgData[6];
-	} *pMsg;
+		u32 msg_data[6];
+	} *p_msg;
 
 
 	if (pin_num > MAX_GPIO_PIN_NUMBER)
@@ -1970,48 +1970,48 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
 	if (p_gpio_config == NULL)
 		return -EINVAL;
 
-	totalLen = sizeof(struct sms_msg_hdr) + (sizeof(u32) * 6);
+	total_len = sizeof(struct sms_msg_hdr) + (sizeof(u32) * 6);
 
-	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
 			GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
 
-	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+	p_msg = (struct set_gpio_msg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
-	pMsg->x_msg_header.msg_flags = 0;
-	pMsg->x_msg_header.msg_length = (u16) totalLen;
-	pMsg->msgData[0] = pin_num;
+	p_msg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	p_msg->x_msg_header.msg_dst_id = HIF_TASK;
+	p_msg->x_msg_header.msg_flags = 0;
+	p_msg->x_msg_header.msg_length = (u16) total_len;
+	p_msg->msg_data[0] = pin_num;
 
 	if (!(coredev->device_flags & SMS_DEVICE_FAMILY2)) {
-		pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_REQ;
-		if (GetGpioPinParams(pin_num, &Translatedpin_num, &GroupNum,
-				&groupCfg) != 0) {
+		p_msg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_REQ;
+		if (get_gpio_pin_params(pin_num, &translatedpin_num, &group_num,
+				&group_cfg) != 0) {
 			rc = -EINVAL;
 			goto free;
 		}
 
-		pMsg->msgData[1] = Translatedpin_num;
-		pMsg->msgData[2] = GroupNum;
-		ElectricChar = (p_gpio_config->pullupdown)
+		p_msg->msg_data[1] = translatedpin_num;
+		p_msg->msg_data[2] = group_num;
+		electric_char = (p_gpio_config->pullupdown)
 				| (p_gpio_config->inputcharacteristics << 2)
 				| (p_gpio_config->outputslewrate << 3)
 				| (p_gpio_config->outputdriving << 4);
-		pMsg->msgData[3] = ElectricChar;
-		pMsg->msgData[4] = p_gpio_config->direction;
-		pMsg->msgData[5] = groupCfg;
+		p_msg->msg_data[3] = electric_char;
+		p_msg->msg_data[4] = p_gpio_config->direction;
+		p_msg->msg_data[5] = group_cfg;
 	} else {
-		pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_EX_REQ;
-		pMsg->msgData[1] = p_gpio_config->pullupdown;
-		pMsg->msgData[2] = p_gpio_config->outputslewrate;
-		pMsg->msgData[3] = p_gpio_config->outputdriving;
-		pMsg->msgData[4] = p_gpio_config->direction;
-		pMsg->msgData[5] = 0;
+		p_msg->x_msg_header.msg_type = MSG_SMS_GPIO_CONFIG_EX_REQ;
+		p_msg->msg_data[1] = p_gpio_config->pullupdown;
+		p_msg->msg_data[2] = p_gpio_config->outputslewrate;
+		p_msg->msg_data[3] = p_gpio_config->outputdriving;
+		p_msg->msg_data[4] = p_gpio_config->direction;
+		p_msg->msg_data[5] = 0;
 	}
 
-	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+	rc = smscore_sendrequest_and_wait(coredev, p_msg, total_len,
 			&coredev->gpio_configuration_done);
 
 	if (rc != 0) {
@@ -2029,38 +2029,38 @@ free:
 int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
 		u8 new_level) {
 
-	u32 totalLen;
+	u32 total_len;
 	int rc;
 	void *buffer;
 
-	struct SetGpioMsg {
+	struct set_gpio_msg {
 		struct sms_msg_hdr x_msg_header;
-		u32 msgData[3]; /* keep it 3 ! */
-	} *pMsg;
+		u32 msg_data[3]; /* keep it 3 ! */
+	} *p_msg;
 
 	if ((new_level > 1) || (pin_num > MAX_GPIO_PIN_NUMBER))
 		return -EINVAL;
 
-	totalLen = sizeof(struct sms_msg_hdr) +
+	total_len = sizeof(struct sms_msg_hdr) +
 			(3 * sizeof(u32)); /* keep it 3 ! */
 
-	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
 			GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
 
-	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+	p_msg = (struct set_gpio_msg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
-	pMsg->x_msg_header.msg_flags = 0;
-	pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_SET_LEVEL_REQ;
-	pMsg->x_msg_header.msg_length = (u16) totalLen;
-	pMsg->msgData[0] = pin_num;
-	pMsg->msgData[1] = new_level;
+	p_msg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	p_msg->x_msg_header.msg_dst_id = HIF_TASK;
+	p_msg->x_msg_header.msg_flags = 0;
+	p_msg->x_msg_header.msg_type = MSG_SMS_GPIO_SET_LEVEL_REQ;
+	p_msg->x_msg_header.msg_length = (u16) total_len;
+	p_msg->msg_data[0] = pin_num;
+	p_msg->msg_data[1] = new_level;
 
 	/* Send message to SMS */
-	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+	rc = smscore_sendrequest_and_wait(coredev, p_msg, total_len,
 			&coredev->gpio_set_level_done);
 
 	if (rc != 0) {
@@ -2077,38 +2077,38 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
 int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 		u8 *level) {
 
-	u32 totalLen;
+	u32 total_len;
 	int rc;
 	void *buffer;
 
-	struct SetGpioMsg {
+	struct set_gpio_msg {
 		struct sms_msg_hdr x_msg_header;
-		u32 msgData[2];
-	} *pMsg;
+		u32 msg_data[2];
+	} *p_msg;
 
 
 	if (pin_num > MAX_GPIO_PIN_NUMBER)
 		return -EINVAL;
 
-	totalLen = sizeof(struct sms_msg_hdr) + (2 * sizeof(u32));
+	total_len = sizeof(struct sms_msg_hdr) + (2 * sizeof(u32));
 
-	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
 			GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
 
-	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+	p_msg = (struct set_gpio_msg *) SMS_ALIGN_ADDRESS(buffer);
 
-	pMsg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	pMsg->x_msg_header.msg_dst_id = HIF_TASK;
-	pMsg->x_msg_header.msg_flags = 0;
-	pMsg->x_msg_header.msg_type = MSG_SMS_GPIO_GET_LEVEL_REQ;
-	pMsg->x_msg_header.msg_length = (u16) totalLen;
-	pMsg->msgData[0] = pin_num;
-	pMsg->msgData[1] = 0;
+	p_msg->x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	p_msg->x_msg_header.msg_dst_id = HIF_TASK;
+	p_msg->x_msg_header.msg_flags = 0;
+	p_msg->x_msg_header.msg_type = MSG_SMS_GPIO_GET_LEVEL_REQ;
+	p_msg->x_msg_header.msg_length = (u16) total_len;
+	p_msg->msg_data[0] = pin_num;
+	p_msg->msg_data[1] = 0;
 
 	/* Send message to SMS */
-	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+	rc = smscore_sendrequest_and_wait(coredev, p_msg, total_len,
 			&coredev->gpio_get_level_done);
 
 	if (rc != 0) {
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index b0253d2..d3e781f 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -624,17 +624,17 @@ struct sms_msg_hdr {
 
 struct sms_msg_data {
 	struct sms_msg_hdr x_msg_header;
-	u32 msgData[1];
+	u32 msg_data[1];
 };
 
 struct sms_msg_data2 {
 	struct sms_msg_hdr x_msg_header;
-	u32 msgData[2];
+	u32 msg_data[2];
 };
 
 struct sms_msg_data4 {
 	struct sms_msg_hdr x_msg_header;
-	u32 msgData[4];
+	u32 msg_data[4];
 };
 
 struct sms_data_download {
@@ -689,9 +689,9 @@ struct sms_stats {
 
 	/* Reception quality */
 	s32 SNR;		/* dB */
-	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 ber;		/* Post Viterbi ber [1E-5] */
 	u32 FIB_CRC;		/* CRC errors percentage, valid only for DAB */
-	u32 TS_PER;		/* Transport stream PER,
+	u32 ts_per;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A, valid only for DVB-T/H */
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
@@ -749,7 +749,7 @@ struct sms_stats {
 	u32 sms_to_host_tx_errors;	/* Total number of transmission errors. */
 
 	/* DAB/T-DMB */
-	u32 pre_ber;		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
+	u32 pre_ber;		/* DAB/T-DMB only: Pre Viterbi ber [1E-5] */
 
 	/* DVB-H TPS parameters */
 	u32 cell_id;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
@@ -781,11 +781,11 @@ struct sms_isdbt_layer_stats {
 		       * 255 means layer does not exist */
 	u32 constellation; /* constellation from SMSHOSTLIB_CONSTELLATION_ET,
 			    * 255 means layer does not exist */
-	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
+	u32 ber; /* Post Viterbi ber [1E-5], 0xFFFFFFFF indicate N/A */
 	u32 ber_error_count; /* Post Viterbi Error Bits Count */
 	u32 ber_bit_count; /* Post Viterbi Total Bits Count */
-	u32 pre_ber; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 TS_PER; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
+	u32 pre_ber; /* Pre Viterbi ber [1E-5], 0xFFFFFFFF indicate N/A */
+	u32 ts_per; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
 	u32 error_ts_packets; /* Number of erroneous transport-stream packets */
 	u32 total_ts_packets; /* Total number of transport-stream packets */
 	u32 ti_ldepth_i; /* Time interleaver depth I parameter,
@@ -830,7 +830,7 @@ struct sms_isdbt_stats {
 
 	/* Per-layer information */
 	/* Layers A, B and C */
-	struct sms_isdbt_layer_stats	LayerInfo[3];
+	struct sms_isdbt_layer_stats	layer_info[3];
 	/* Per-layer statistics, see sms_isdbt_layer_stats */
 
 	/* Interface information */
@@ -875,7 +875,7 @@ struct sms_isdbt_stats_ex {
 
 	/* Per-layer information */
 	/* Layers A, B and C */
-	struct sms_isdbt_layer_stats	LayerInfo[3];
+	struct sms_isdbt_layer_stats	layer_info[3];
 	/* Per-layer statistics, see sms_isdbt_layer_stats */
 
 	/* Interface information */
@@ -958,10 +958,10 @@ struct sms_rx_stats {
 
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
-	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 ber;		/* Post Viterbi ber [1E-5] */
 	u32 ber_error_count;	/* Number of erronous SYNC bits. */
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
-	u32 TS_PER;		/* Transport stream PER,
+	u32 ts_per;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
@@ -984,10 +984,10 @@ struct sms_rx_stats_ex {
 
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
-	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 ber;		/* Post Viterbi ber [1E-5] */
 	u32 ber_error_count;	/* Number of erronous SYNC bits. */
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
-	u32 TS_PER;		/* Transport stream PER,
+	u32 ts_per;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
 	u32 MFER;		/* DVB-H frame error rate in percentage,
 	0xFFFFFFFF indicate N/A, valid only for DVB-H */
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index f63121c..a881da5 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -71,11 +71,11 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "SNR = %d\n", p->SNR);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "BER = %d\n", p->BER);
+		      "ber = %d\n", p->ber);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "FIB_CRC = %d\n", p->FIB_CRC);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
-		      "TS_PER = %d\n", p->TS_PER);
+		      "ts_per = %d\n", p->ts_per);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "MFER = %d\n", p->MFER);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
@@ -204,36 +204,36 @@ void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 		      "sms_to_host_tx_errors = %d\n", p->sms_to_host_tx_errors);
 
 	for (i = 0; i < 3; i++) {
-		if (p->LayerInfo[i].number_of_segments < 1 ||
-		    p->LayerInfo[i].number_of_segments > 13)
+		if (p->layer_info[i].number_of_segments < 1 ||
+		    p->layer_info[i].number_of_segments > 13)
 			continue;
 
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tcode_rate = %d\t",
-			      p->LayerInfo[i].code_rate);
+			      p->layer_info[i].code_rate);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "constellation = %d\n",
-			      p->LayerInfo[i].constellation);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
-			      p->LayerInfo[i].BER);
+			      p->layer_info[i].constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber = %-5d\t",
+			      p->layer_info[i].ber);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber_error_count = %-5d\t",
-			      p->LayerInfo[i].ber_error_count);
+			      p->layer_info[i].ber_error_count);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "ber_bit_count = %-5d\n",
-			      p->LayerInfo[i].ber_bit_count);
+			      p->layer_info[i].ber_bit_count);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tpre_ber = %-5d\t",
-			      p->LayerInfo[i].pre_ber);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
-			      p->LayerInfo[i].TS_PER);
+			      p->layer_info[i].pre_ber);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tts_per = %-5d\n",
+			      p->layer_info[i].ts_per);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\terror_ts_packets = %-5d\t",
-			      p->LayerInfo[i].error_ts_packets);
+			      p->layer_info[i].error_ts_packets);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "total_ts_packets = %-5d\t",
-			      p->LayerInfo[i].total_ts_packets);
+			      p->layer_info[i].total_ts_packets);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "ti_ldepth_i = %d\n",
-			      p->LayerInfo[i].ti_ldepth_i);
+			      p->layer_info[i].ti_ldepth_i);
 		n += snprintf(&buf[n], PAGE_SIZE - n,
 			      "\tnumber_of_segments = %d\t",
-			      p->LayerInfo[i].number_of_segments);
+			      p->layer_info[i].number_of_segments);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "tmcc_errors = %d\n",
-			      p->LayerInfo[i].tmcc_errors);
+			      p->layer_info[i].tmcc_errors);
 	}
 
 	debug_data->stats_count = n;
@@ -296,36 +296,36 @@ void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
 		      p->tune_bw);
 
 	for (i = 0; i < 3; i++) {
-		if (p->LayerInfo[i].number_of_segments < 1 ||
-		    p->LayerInfo[i].number_of_segments > 13)
+		if (p->layer_info[i].number_of_segments < 1 ||
+		    p->layer_info[i].number_of_segments > 13)
 			continue;
 
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tcode_rate = %d\t",
-			      p->LayerInfo[i].code_rate);
+			      p->layer_info[i].code_rate);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "constellation = %d\n",
-			      p->LayerInfo[i].constellation);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
-			      p->LayerInfo[i].BER);
+			      p->layer_info[i].constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber = %-5d\t",
+			      p->layer_info[i].ber);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tber_error_count = %-5d\t",
-			      p->LayerInfo[i].ber_error_count);
+			      p->layer_info[i].ber_error_count);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "ber_bit_count = %-5d\n",
-			      p->LayerInfo[i].ber_bit_count);
+			      p->layer_info[i].ber_bit_count);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\tpre_ber = %-5d\t",
-			      p->LayerInfo[i].pre_ber);
-		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
-			      p->LayerInfo[i].TS_PER);
+			      p->layer_info[i].pre_ber);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tts_per = %-5d\n",
+			      p->layer_info[i].ts_per);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "\terror_ts_packets = %-5d\t",
-			      p->LayerInfo[i].error_ts_packets);
+			      p->layer_info[i].error_ts_packets);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "total_ts_packets = %-5d\t",
-			      p->LayerInfo[i].total_ts_packets);
+			      p->layer_info[i].total_ts_packets);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "ti_ldepth_i = %d\n",
-			      p->LayerInfo[i].ti_ldepth_i);
+			      p->layer_info[i].ti_ldepth_i);
 		n += snprintf(&buf[n], PAGE_SIZE - n,
 			      "\tnumber_of_segments = %d\t",
-			      p->LayerInfo[i].number_of_segments);
+			      p->layer_info[i].number_of_segments);
 		n += snprintf(&buf[n], PAGE_SIZE - n, "tmcc_errors = %d\n",
-			      p->LayerInfo[i].tmcc_errors);
+			      p->layer_info[i].tmcc_errors);
 	}
 
 
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 29d1c41..d965a7a 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -265,7 +265,7 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 	c->block_error.stat[0].uvalue += p->ets_packets;
 	c->block_count.stat[0].uvalue += p->ets_packets + p->ts_packets;
 
-	/* BER */
+	/* ber */
 	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_error.stat[0].uvalue += p->ber_error_count;
@@ -318,14 +318,14 @@ static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 	c->block_error.stat[0].uvalue += p->error_ts_packets;
 	c->block_count.stat[0].uvalue += p->total_ts_packets;
 
-	/* BER */
+	/* ber */
 	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_error.stat[0].uvalue += p->ber_error_count;
 	c->post_bit_count.stat[0].uvalue += p->ber_bit_count;
 
 	/* Legacy PER/BER */
-	client->legacy_ber = p->BER;
+	client->legacy_ber = p->ber;
 };
 
 static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
@@ -391,7 +391,7 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 
 	for (i = 0; i < n_layers; i++) {
-		lr = &p->LayerInfo[i];
+		lr = &p->layer_info[i];
 
 		/* Update per-layer transmission parameters */
 		if (lr->number_of_segments > 0 && lr->number_of_segments < 13) {
@@ -479,7 +479,7 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 	c->block_error.len = n_layers + 1;
 	c->block_count.len = n_layers + 1;
 	for (i = 0; i < n_layers; i++) {
-		lr = &p->LayerInfo[i];
+		lr = &p->layer_info[i];
 
 		/* Update per-layer transmission parameters */
 		if (lr->number_of_segments > 0 && lr->number_of_segments < 13) {
@@ -500,13 +500,13 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 		c->block_error.stat[0].uvalue += lr->error_ts_packets;
 		c->block_count.stat[0].uvalue += lr->total_ts_packets;
 
-		/* BER */
+		/* ber */
 		c->post_bit_error.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->post_bit_count.stat[i + 1].scale = FE_SCALE_COUNTER;
 		c->post_bit_error.stat[i + 1].uvalue += lr->ber_error_count;
 		c->post_bit_count.stat[i + 1].uvalue += lr->ber_bit_count;
 
-		/* Update global BER counter */
+		/* Update global ber counter */
 		c->post_bit_error.stat[0].uvalue += lr->ber_error_count;
 		c->post_bit_count.stat[0].uvalue += lr->ber_bit_count;
 	}
@@ -636,44 +636,44 @@ static int smsdvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct smsdvb_client_t *client =
 		container_of(feed->demux, struct smsdvb_client_t, demux);
-	struct sms_msg_data PidMsg;
+	struct sms_msg_data pid_msg;
 
 	sms_debug("add pid %d(%x)",
 		  feed->pid, feed->pid);
 
 	client->feed_users++;
 
-	PidMsg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	PidMsg.x_msg_header.msg_dst_id = HIF_TASK;
-	PidMsg.x_msg_header.msg_flags = 0;
-	PidMsg.x_msg_header.msg_type  = MSG_SMS_ADD_PID_FILTER_REQ;
-	PidMsg.x_msg_header.msg_length = sizeof(PidMsg);
-	PidMsg.msgData[0] = feed->pid;
+	pid_msg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	pid_msg.x_msg_header.msg_dst_id = HIF_TASK;
+	pid_msg.x_msg_header.msg_flags = 0;
+	pid_msg.x_msg_header.msg_type  = MSG_SMS_ADD_PID_FILTER_REQ;
+	pid_msg.x_msg_header.msg_length = sizeof(pid_msg);
+	pid_msg.msg_data[0] = feed->pid;
 
 	return smsclient_sendrequest(client->smsclient,
-				     &PidMsg, sizeof(PidMsg));
+				     &pid_msg, sizeof(pid_msg));
 }
 
 static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct smsdvb_client_t *client =
 		container_of(feed->demux, struct smsdvb_client_t, demux);
-	struct sms_msg_data PidMsg;
+	struct sms_msg_data pid_msg;
 
 	sms_debug("remove pid %d(%x)",
 		  feed->pid, feed->pid);
 
 	client->feed_users--;
 
-	PidMsg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	PidMsg.x_msg_header.msg_dst_id = HIF_TASK;
-	PidMsg.x_msg_header.msg_flags = 0;
-	PidMsg.x_msg_header.msg_type  = MSG_SMS_REMOVE_PID_FILTER_REQ;
-	PidMsg.x_msg_header.msg_length = sizeof(PidMsg);
-	PidMsg.msgData[0] = feed->pid;
+	pid_msg.x_msg_header.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	pid_msg.x_msg_header.msg_dst_id = HIF_TASK;
+	pid_msg.x_msg_header.msg_flags = 0;
+	pid_msg.x_msg_header.msg_type  = MSG_SMS_REMOVE_PID_FILTER_REQ;
+	pid_msg.x_msg_header.msg_length = sizeof(pid_msg);
+	pid_msg.msg_data[0] = feed->pid;
 
 	return smsclient_sendrequest(client->smsclient,
-				     &PidMsg, sizeof(PidMsg));
+				     &pid_msg, sizeof(pid_msg));
 }
 
 static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
@@ -694,7 +694,7 @@ static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
 static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 {
 	int rc;
-	struct sms_msg_hdr Msg;
+	struct sms_msg_hdr msg;
 
 	/* Don't request stats too fast */
 	if (client->get_stats_jiffies &&
@@ -702,10 +702,10 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 		return 0;
 	client->get_stats_jiffies = jiffies + msecs_to_jiffies(100);
 
-	Msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.msg_dst_id = HIF_TASK;
-	Msg.msg_flags = 0;
-	Msg.msg_length = sizeof(Msg);
+	msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	msg.msg_dst_id = HIF_TASK;
+	msg.msg_flags = 0;
+	msg.msg_length = sizeof(msg);
 
 	switch (smscore_get_device_mode(client->coredev)) {
 	case DEVICE_MODE_ISDBT:
@@ -714,15 +714,15 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 		* Check for firmware version, to avoid breaking for old cards
 		*/
 		if (client->coredev->fw_version >= 0x800)
-			Msg.msg_type = MSG_SMS_GET_STATISTICS_EX_REQ;
+			msg.msg_type = MSG_SMS_GET_STATISTICS_EX_REQ;
 		else
-			Msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
+			msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
 		break;
 	default:
-		Msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
+		msg.msg_type = MSG_SMS_GET_STATISTICS_REQ;
 	}
 
-	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+	rc = smsdvb_sendrequest_and_wait(client, &msg, sizeof(msg),
 					 &client->stats_done);
 
 	return rc;
@@ -845,9 +845,9 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 		container_of(fe, struct smsdvb_client_t, frontend);
 
 	struct {
-		struct sms_msg_hdr	Msg;
+		struct sms_msg_hdr	msg;
 		u32		Data[3];
-	} Msg;
+	} msg;
 
 	int ret;
 
@@ -856,26 +856,26 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 	client->event_unc_state = -1;
 	fe->dtv_property_cache.delivery_system = SYS_DVBT;
 
-	Msg.Msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msg_dst_id = HIF_TASK;
-	Msg.Msg.msg_flags = 0;
-	Msg.Msg.msg_type = MSG_SMS_RF_TUNE_REQ;
-	Msg.Msg.msg_length = sizeof(Msg);
-	Msg.Data[0] = c->frequency;
-	Msg.Data[2] = 12000000;
+	msg.msg.msg_src_id = DVBT_BDA_CONTROL_MSG_ID;
+	msg.msg.msg_dst_id = HIF_TASK;
+	msg.msg.msg_flags = 0;
+	msg.msg.msg_type = MSG_SMS_RF_TUNE_REQ;
+	msg.msg.msg_length = sizeof(msg);
+	msg.Data[0] = c->frequency;
+	msg.Data[2] = 12000000;
 
 	sms_info("%s: freq %d band %d", __func__, c->frequency,
 		 c->bandwidth_hz);
 
 	switch (c->bandwidth_hz / 1000000) {
 	case 8:
-		Msg.Data[1] = BW_8_MHZ;
+		msg.Data[1] = BW_8_MHZ;
 		break;
 	case 7:
-		Msg.Data[1] = BW_7_MHZ;
+		msg.Data[1] = BW_7_MHZ;
 		break;
 	case 6:
-		Msg.Data[1] = BW_6_MHZ;
+		msg.Data[1] = BW_6_MHZ;
 		break;
 	case 0:
 		return -EOPNOTSUPP;
@@ -888,7 +888,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 		fe_status_t status;
 
 		/* tune with LNA off at first */
-		ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+		ret = smsdvb_sendrequest_and_wait(client, &msg, sizeof(msg),
 						  &client->tune_done);
 
 		smsdvb_read_status(fe, &status);
@@ -900,7 +900,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 		sms_board_lna_control(client->coredev, 1);
 	}
 
-	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+	return smsdvb_sendrequest_and_wait(client, &msg, sizeof(msg),
 					   &client->tune_done);
 }
 
@@ -915,17 +915,17 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	int ret;
 
 	struct {
-		struct sms_msg_hdr	Msg;
+		struct sms_msg_hdr	msg;
 		u32		Data[4];
-	} Msg;
+	} msg;
 
 	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
 
-	Msg.Msg.msg_src_id  = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msg_dst_id  = HIF_TASK;
-	Msg.Msg.msg_flags  = 0;
-	Msg.Msg.msg_type   = MSG_SMS_ISDBT_TUNE_REQ;
-	Msg.Msg.msg_length = sizeof(Msg);
+	msg.msg.msg_src_id  = DVBT_BDA_CONTROL_MSG_ID;
+	msg.msg.msg_dst_id  = HIF_TASK;
+	msg.msg.msg_flags  = 0;
+	msg.msg.msg_type   = MSG_SMS_ISDBT_TUNE_REQ;
+	msg.msg.msg_length = sizeof(msg);
 
 	if (c->isdbt_sb_segment_idx == -1)
 		c->isdbt_sb_segment_idx = 0;
@@ -933,19 +933,19 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	if (!c->isdbt_layer_enabled)
 		c->isdbt_layer_enabled = 7;
 
-	Msg.Data[0] = c->frequency;
-	Msg.Data[1] = BW_ISDBT_1SEG;
-	Msg.Data[2] = 12000000;
-	Msg.Data[3] = c->isdbt_sb_segment_idx;
+	msg.Data[0] = c->frequency;
+	msg.Data[1] = BW_ISDBT_1SEG;
+	msg.Data[2] = 12000000;
+	msg.Data[3] = c->isdbt_sb_segment_idx;
 
 	if (c->isdbt_partial_reception) {
 		if ((type == SMS_PELE || type == SMS_RIO) &&
 		    c->isdbt_sb_segment_count > 3)
-			Msg.Data[1] = BW_ISDBT_13SEG;
+			msg.Data[1] = BW_ISDBT_13SEG;
 		else if (c->isdbt_sb_segment_count > 1)
-			Msg.Data[1] = BW_ISDBT_3SEG;
+			msg.Data[1] = BW_ISDBT_3SEG;
 	} else if (type == SMS_PELE || type == SMS_RIO)
-		Msg.Data[1] = BW_ISDBT_13SEG;
+		msg.Data[1] = BW_ISDBT_13SEG;
 
 	c->bandwidth_hz = 6000000;
 
@@ -959,7 +959,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 		fe_status_t status;
 
 		/* tune with LNA off at first */
-		ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+		ret = smsdvb_sendrequest_and_wait(client, &msg, sizeof(msg),
 						  &client->tune_done);
 
 		smsdvb_read_status(fe, &status);
@@ -970,7 +970,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 		/* previous tune didn't lock - enable LNA and tune again */
 		sms_board_lna_control(client->coredev, 1);
 	}
-	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+	return smsdvb_sendrequest_and_wait(client, &msg, sizeof(msg),
 					   &client->tune_done);
 }
 
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index 513f853..92c413b 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -87,7 +87,7 @@ struct RECEPTION_STATISTICS_PER_SLICES_S {
 	u32 request_id;
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 
-	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 ber;		/* Post Viterbi BER [1E-5] */
 	s32 RSSI;		/* dBm */
 	s32 carrier_offset;	/* Carrier Offset in bin/1024 */
 
diff --git a/drivers/media/common/siano/smsendian.c b/drivers/media/common/siano/smsendian.c
index 32a7b28..bfe831c 100644
--- a/drivers/media/common/siano/smsendian.c
+++ b/drivers/media/common/siano/smsendian.c
@@ -30,21 +30,21 @@ void smsendian_handle_tx_message(void *buffer)
 #ifdef __BIG_ENDIAN
 	struct sms_msg_data *msg = (struct sms_msg_data *)buffer;
 	int i;
-	int msgWords;
+	int msg_words;
 
 	switch (msg->x_msg_header.msg_type) {
 	case MSG_SMS_DATA_DOWNLOAD_REQ:
 	{
-		msg->msgData[0] = le32_to_cpu(msg->msgData[0]);
+		msg->msg_data[0] = le32_to_cpu(msg->msg_data[0]);
 		break;
 	}
 
 	default:
-		msgWords = (msg->x_msg_header.msg_length -
+		msg_words = (msg->x_msg_header.msg_length -
 				sizeof(struct sms_msg_hdr))/4;
 
-		for (i = 0; i < msgWords; i++)
-			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
+		for (i = 0; i < msg_words; i++)
+			msg->msg_data[i] = le32_to_cpu(msg->msg_data[i]);
 
 		break;
 	}
@@ -57,7 +57,7 @@ void smsendian_handle_rx_message(void *buffer)
 #ifdef __BIG_ENDIAN
 	struct sms_msg_data *msg = (struct sms_msg_data *)buffer;
 	int i;
-	int msgWords;
+	int msg_words;
 
 	switch (msg->x_msg_header.msg_type) {
 	case MSG_SMS_GET_VERSION_EX_RES:
@@ -77,11 +77,11 @@ void smsendian_handle_rx_message(void *buffer)
 
 	default:
 	{
-		msgWords = (msg->x_msg_header.msg_length -
+		msg_words = (msg->x_msg_header.msg_length -
 				sizeof(struct sms_msg_hdr))/4;
 
-		for (i = 0; i < msgWords; i++)
-			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
+		for (i = 0; i < msg_words; i++)
+			msg->msg_data[i] = le32_to_cpu(msg->msg_data[i]);
 
 		break;
 	}
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 3a290f1..03761c6 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -310,7 +310,7 @@ static void smsusb1_detectmode(void *context, int *mode)
 
 static int smsusb1_setmode(void *context, int mode)
 {
-	struct sms_msg_hdr Msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
+	struct sms_msg_hdr msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
 			     sizeof(struct sms_msg_hdr), 0 };
 
 	if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
@@ -318,7 +318,7 @@ static int smsusb1_setmode(void *context, int mode)
 		return -EINVAL;
 	}
 
-	return smsusb_sendrequest(context, &Msg, sizeof(Msg));
+	return smsusb_sendrequest(context, &msg, sizeof(msg));
 }
 
 static void smsusb_term_device(struct usb_interface *intf)
-- 
1.8.1.4

