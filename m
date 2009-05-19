Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:40675 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753610AbZESOtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 10:49:18 -0400
Message-ID: <855967.12185.qm@web110807.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 07:49:19 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_43] Siano: Add new GPIO management interface
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242744570 -10800
# Node ID 749c11a362a9fad1992809007247d5c76c35bfc9
# Parent  08e292f80f37496d8d4b43a542f518196eaa4dc0
[09051_43] Siano: Add new GPIO management interface

From: Uri Shkolnik <uris@siano-ms.com>

Add new GPIO management interface to replace old (buggy) one.
Keeping old interface intact for now.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 08e292f80f37 -r 749c11a362a9 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 16:30:40 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 17:49:30 2009 +0300
@@ -109,7 +109,7 @@ static int sms_set_gpio(struct smscore_d
 {
 	int lvl, ret;
 	u32 gpio;
-	struct smscore_gpio_config gpioconfig = {
+	struct smscore_config_gpio gpioconfig = {
 		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
 		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
 		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
diff -r 08e292f80f37 -r 749c11a362a9 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 16:30:40 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 17:49:30 2009 +0300
@@ -1331,8 +1331,9 @@ static int smscore_map_common_buffer(str
 }
 #endif
 
+/* old GPIO managments implementation */
 int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
-			   struct smscore_gpio_config *pinconfig)
+			   struct smscore_config_gpio *pinconfig)
 {
 	struct {
 		struct SmsMsgHdr_ST hdr;
@@ -1399,6 +1400,238 @@ int smscore_set_gpio(struct smscore_devi
 
 	return coredev->sendrequest_handler(coredev->context,
 					    &msg, sizeof(msg));
+}
+
+/* new GPIO managment implementation */
+static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
+		u32 *pGroupNum, u32 *pGroupCfg) {
+
+	*pGroupCfg = 1;
+
+	if (PinNum >= 0 && PinNum <= 1)	{
+		*pTranslatedPinNum = 0;
+		*pGroupNum = 9;
+		*pGroupCfg = 2;
+	} else if (PinNum >= 2 && PinNum <= 6) {
+		*pTranslatedPinNum = 2;
+		*pGroupNum = 0;
+		*pGroupCfg = 2;
+	} else if (PinNum >= 7 && PinNum <= 11) {
+		*pTranslatedPinNum = 7;
+		*pGroupNum = 1;
+	} else if (PinNum >= 12 && PinNum <= 15) {
+		*pTranslatedPinNum = 12;
+		*pGroupNum = 2;
+		*pGroupCfg = 3;
+	} else if (PinNum == 16) {
+		*pTranslatedPinNum = 16;
+		*pGroupNum = 23;
+	} else if (PinNum >= 17 && PinNum <= 24) {
+		*pTranslatedPinNum = 17;
+		*pGroupNum = 3;
+	} else if (PinNum == 25) {
+		*pTranslatedPinNum = 25;
+		*pGroupNum = 6;
+	} else if (PinNum >= 26 && PinNum <= 28) {
+		*pTranslatedPinNum = 26;
+		*pGroupNum = 4;
+	} else if (PinNum == 29) {
+		*pTranslatedPinNum = 29;
+		*pGroupNum = 5;
+		*pGroupCfg = 2;
+	} else if (PinNum == 30) {
+		*pTranslatedPinNum = 30;
+		*pGroupNum = 8;
+	} else if (PinNum == 31) {
+		*pTranslatedPinNum = 31;
+		*pGroupNum = 17;
+	} else
+		return -1;
+
+	*pGroupCfg <<= 24;
+
+	return 0;
+}
+
+int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
+		struct smscore_gpio_config *pGpioConfig) {
+
+	u32 totalLen;
+	u32 TranslatedPinNum;
+	u32 GroupNum;
+	u32 ElectricChar;
+	u32 groupCfg;
+	void *buffer;
+	int rc;
+
+	struct SetGpioMsg {
+		struct SmsMsgHdr_ST xMsgHeader;
+		u32 msgData[6];
+	} *pMsg;
+
+
+	if (PinNum > MAX_GPIO_PIN_NUMBER)
+		return -EINVAL;
+
+	if (pGpioConfig == NULL)
+		return -EINVAL;
+
+	totalLen = sizeof(struct SmsMsgHdr_ST) + (sizeof(u32) * 6);
+
+	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+			GFP_KERNEL | GFP_DMA);
+	if (!buffer)
+		return -ENOMEM;
+
+	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+
+	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->xMsgHeader.msgDstId = HIF_TASK;
+	pMsg->xMsgHeader.msgFlags = 0;
+	pMsg->xMsgHeader.msgLength = (u16) totalLen;
+	pMsg->msgData[0] = PinNum;
+
+	if (!(coredev->device_flags & SMS_DEVICE_FAMILY2)) {
+		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_REQ;
+		if (GetGpioPinParams(PinNum, &TranslatedPinNum, &GroupNum,
+				&groupCfg) != 0)
+			return -EINVAL;
+
+		pMsg->msgData[1] = TranslatedPinNum;
+		pMsg->msgData[2] = GroupNum;
+		ElectricChar = (pGpioConfig->PullUpDown)
+				| (pGpioConfig->InputCharacteristics << 2)
+				| (pGpioConfig->OutputSlewRate << 3)
+				| (pGpioConfig->OutputDriving << 4);
+		pMsg->msgData[3] = ElectricChar;
+		pMsg->msgData[4] = pGpioConfig->Direction;
+		pMsg->msgData[5] = groupCfg;
+	} else {
+		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_EX_REQ;
+		pMsg->msgData[1] = pGpioConfig->PullUpDown;
+		pMsg->msgData[2] = pGpioConfig->OutputSlewRate;
+		pMsg->msgData[3] = pGpioConfig->OutputDriving;
+		pMsg->msgData[4] = pGpioConfig->Direction;
+		pMsg->msgData[5] = 0;
+	}
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
+	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+			&coredev->gpio_configuration_done);
+
+	if (rc != 0) {
+		if (rc == -ETIME)
+			sms_err("smscore_gpio_configure timeout");
+		else
+			sms_err("smscore_gpio_configure error");
+	}
+	kfree(buffer);
+
+	return rc;
+}
+
+int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
+		u8 NewLevel) {
+
+	u32 totalLen;
+	int rc;
+	void *buffer;
+
+	struct SetGpioMsg {
+		struct SmsMsgHdr_ST xMsgHeader;
+		u32 msgData[3]; /* keep it 3 ! */
+	} *pMsg;
+
+	if ((NewLevel > 1) || (PinNum > MAX_GPIO_PIN_NUMBER) ||
+			(PinNum > MAX_GPIO_PIN_NUMBER))
+		return -EINVAL;
+
+	totalLen = sizeof(struct SmsMsgHdr_ST) +
+			(3 * sizeof(u32)); /* keep it 3 ! */
+
+	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+			GFP_KERNEL | GFP_DMA);
+	if (!buffer)
+		return -ENOMEM;
+
+	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+
+	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->xMsgHeader.msgDstId = HIF_TASK;
+	pMsg->xMsgHeader.msgFlags = 0;
+	pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_SET_LEVEL_REQ;
+	pMsg->xMsgHeader.msgLength = (u16) totalLen;
+	pMsg->msgData[0] = PinNum;
+	pMsg->msgData[1] = NewLevel;
+
+	/* Send message to SMS */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
+	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+			&coredev->gpio_set_level_done);
+
+	if (rc != 0) {
+		if (rc == -ETIME)
+			sms_err("smscore_gpio_set_level timeout");
+		else
+			sms_err("smscore_gpio_set_level error");
+	}
+	kfree(buffer);
+
+	return rc;
+}
+
+int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
+		u8 *level) {
+
+	u32 totalLen;
+	int rc;
+	void *buffer;
+
+	struct SetGpioMsg {
+		struct SmsMsgHdr_ST xMsgHeader;
+		u32 msgData[2];
+	} *pMsg;
+
+
+	if (PinNum > MAX_GPIO_PIN_NUMBER)
+		return -EINVAL;
+
+	totalLen = sizeof(struct SmsMsgHdr_ST) + (2 * sizeof(u32));
+
+	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+			GFP_KERNEL | GFP_DMA);
+	if (!buffer)
+		return -ENOMEM;
+
+	pMsg = (struct SetGpioMsg *) SMS_ALIGN_ADDRESS(buffer);
+
+	pMsg->xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	pMsg->xMsgHeader.msgDstId = HIF_TASK;
+	pMsg->xMsgHeader.msgFlags = 0;
+	pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_GET_LEVEL_REQ;
+	pMsg->xMsgHeader.msgLength = (u16) totalLen;
+	pMsg->msgData[0] = PinNum;
+	pMsg->msgData[1] = 0;
+
+	/* Send message to SMS */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
+	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
+			&coredev->gpio_get_level_done);
+
+	if (rc != 0) {
+		if (rc == -ETIME)
+			sms_err("smscore_gpio_get_level timeout");
+		else
+			sms_err("smscore_gpio_get_level error");
+	}
+	kfree(buffer);
+
+	/* Its a race between other gpio_get_level() and the copy of the single
+	 * global 'coredev->gpio_get_res' to  the function's variable 'level'
+	 */
+	*level = coredev->gpio_get_res;
+
+	return rc;
 }
 
 static int __init smscore_module_init(void)
diff -r 08e292f80f37 -r 749c11a362a9 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 16:30:40 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 17:49:30 2009 +0300
@@ -550,7 +550,7 @@ struct SMSHOSTLIB_I2C_RES_ST {
 };
 
 
-struct smscore_gpio_config {
+struct smscore_config_gpio {
 #define SMS_GPIO_DIRECTION_INPUT  0
 #define SMS_GPIO_DIRECTION_OUTPUT 1
 	u8 direction;
@@ -574,6 +574,48 @@ struct smscore_gpio_config {
 #define SMS_GPIO_OUTPUTDRIVING_12mA 2
 #define SMS_GPIO_OUTPUTDRIVING_16mA 3
 	u8 outputdriving;
+};
+
+struct smscore_gpio_config {
+#define SMS_GPIO_DIRECTION_INPUT  0
+#define SMS_GPIO_DIRECTION_OUTPUT 1
+	u8 Direction;
+
+#define SMS_GPIO_PULLUPDOWN_NONE     0
+#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
+#define SMS_GPIO_PULLUPDOWN_PULLUP   2
+#define SMS_GPIO_PULLUPDOWN_KEEPER   3
+	u8 PullUpDown;
+
+#define SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL  0
+#define SMS_GPIO_INPUT_CHARACTERISTICS_SCHMITT 1
+	u8 InputCharacteristics;
+
+#define SMS_GPIO_OUTPUT_SLEW_RATE_SLOW		1 /* 10xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_FAST		0 /* 10xx */
+
+
+#define SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS	0 /* 11xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_0_9_V_NS	1 /* 11xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_1_7_V_NS	2 /* 11xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_3_3_V_NS	3 /* 11xx */
+	u8 OutputSlewRate;
+
+#define SMS_GPIO_OUTPUT_DRIVING_S_4mA		0 /* 10xx */
+#define SMS_GPIO_OUTPUT_DRIVING_S_8mA		1 /* 10xx */
+#define SMS_GPIO_OUTPUT_DRIVING_S_12mA		2 /* 10xx */
+#define SMS_GPIO_OUTPUT_DRIVING_S_16mA		3 /* 10xx */
+
+#define SMS_GPIO_OUTPUT_DRIVING_1_5mA		0 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_2_8mA		1 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_4mA			2 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_7mA			3 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_10mA			4 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_11mA			5 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_14mA			6 /* 11xx */
+#undef SMS_GPIO_OUTPUT_DRIVING_16mA
+#define SMS_GPIO_OUTPUT_DRIVING_16mA			7 /* 11xx */
+	u8 OutputDriving;
 };
 
 extern void smscore_registry_setmode(char *devpath, int mode);
@@ -619,9 +661,18 @@ extern void smscore_putbuffer(struct sms
 extern void smscore_putbuffer(struct smscore_device_t *coredev,
 			      struct smscore_buffer_t *cb);
 
+/* old GPIO managment */
 int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
-			   struct smscore_gpio_config *pinconfig);
+			   struct smscore_config_gpio *pinconfig);
 int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
+
+/* new GPIO managment */
+extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
+		struct smscore_gpio_config *pGpioConfig);
+extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
+		u8 NewLevel);
+extern int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
+		u8 *level);
 
 void smscore_set_board_id(struct smscore_device_t *core, int id);
 int smscore_get_board_id(struct smscore_device_t *core);



      
