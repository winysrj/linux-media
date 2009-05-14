Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:36622 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752779AbZENTfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:35:53 -0400
Message-ID: <840143.54949.qm@web110803.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:35:54 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_22] Siano: smscore - fix bug in gpio implementation
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242329318 -10800
# Node ID 8b645aa2ab13f22b8d4dcd8e6353fce2c976cd34
# Parent  71c60eec8001438fee7e9f2e220a101576d6a219
[0905_22] Siano: smscore - fix bug in gpio implementation

From: Uri Shkolnik <uris@siano-ms.com>

Old implementation code was wrong. The correct code has been submmited.
(old code bug may cause chip-set failure and bad reception
experiance)

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 71c60eec8001 -r 8b645aa2ab13 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:13:13 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:28:38 2009 +0300
@@ -160,11 +160,11 @@ static int sms_set_gpio(struct smscore_d
 	int lvl, ret;
 	u32 gpio;
 	struct smscore_gpio_config gpioconfig = {
-		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
-		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
-		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
-		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
-		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
+		.Direction            = SMS_GPIO_DIRECTION_OUTPUT,
+		.PullUpDown           = SMS_GPIO_PULLUPDOWN_NONE,
+		.InputCharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
+		.OutputSlewRate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
+		.OutputDriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
 	};
 
 	if (pin == 0)
diff -r 71c60eec8001 -r 8b645aa2ab13 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 22:13:13 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 22:28:38 2009 +0300
@@ -35,6 +35,8 @@
 #include "smsendian.h"
 #include "sms-cards.h"
 #include "smsir.h"
+
+#define MAX_GPIO_PIN_NUMBER	31
 
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
@@ -350,6 +352,9 @@ int smscore_register_device(struct smsde
 	init_completion(&dev->init_device_done);
 	init_completion(&dev->reload_start_done);
 	init_completion(&dev->resume_done);
+	init_completion(&dev->gpio_configuration_done);
+	init_completion(&dev->gpio_set_level_done);
+	init_completion(&dev->gpio_get_level_done);
 	init_completion(&dev->ir_init_done);
 
 	/* alloc common buffer */
@@ -1045,6 +1050,23 @@ void smscore_onresponse(struct smscore_d
 		case MSG_SMS_SLEEP_RESUME_COMP_IND:
 			complete(&coredev->resume_done);
 			break;
+		case MSG_SMS_GPIO_CONFIG_EX_RES:
+			sms_debug("MSG_SMS_GPIO_CONFIG_EX_RES");
+			complete(&coredev->gpio_configuration_done);
+			break;
+		case MSG_SMS_GPIO_SET_LEVEL_RES:
+			sms_debug("MSG_SMS_GPIO_SET_LEVEL_RES");
+			complete(&coredev->gpio_set_level_done);
+			break;
+		case MSG_SMS_GPIO_GET_LEVEL_RES:
+		{
+			u32 *msgdata = (u32 *) phdr;
+			coredev->gpio_get_res = msgdata[1];
+			sms_debug("MSG_SMS_GPIO_GET_LEVEL_RES gpio level %d",
+					coredev->gpio_get_res);
+			complete(&coredev->gpio_get_level_done);
+			break;
+		}
 		case MSG_SMS_START_IR_RES:
 			complete(&coredev->ir_init_done);
 			break;
@@ -1313,74 +1335,235 @@ static int smscore_map_common_buffer(str
 }
 #endif
 
-int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
-			   struct smscore_gpio_config *pinconfig)
-{
-	struct {
-		struct SmsMsgHdr_ST hdr;
-		u32 data[6];
-	} msg;
+static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
+		u32 *pGroupNum, u32 *pGroupCfg) {
 
-	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-		msg.hdr.msgDstId = HIF_TASK;
-		msg.hdr.msgFlags = 0;
-		msg.hdr.msgType  = MSG_SMS_GPIO_CONFIG_EX_REQ;
-		msg.hdr.msgLength = sizeof(msg);
+	*pGroupCfg = 1;
 
-		msg.data[0] = pin;
-		msg.data[1] = pinconfig->pullupdown;
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
 
-		/* Convert slew rate for Nova: Fast(0) = 3 / Slow(1) = 0; */
-		msg.data[2] = pinconfig->outputslewrate == 0 ? 3 : 0;
+	*pGroupCfg <<= 24;
 
-		switch (pinconfig->outputdriving) {
-		case SMS_GPIO_OUTPUTDRIVING_16mA:
-			msg.data[3] = 7; /* Nova - 16mA */
-			break;
-		case SMS_GPIO_OUTPUTDRIVING_12mA:
-			msg.data[3] = 5; /* Nova - 11mA */
-			break;
-		case SMS_GPIO_OUTPUTDRIVING_8mA:
-			msg.data[3] = 3; /* Nova - 7mA */
-			break;
-		case SMS_GPIO_OUTPUTDRIVING_4mA:
-		default:
-			msg.data[3] = 2; /* Nova - 4mA */
-			break;
-		}
+	return 0;
+}
 
-		msg.data[4] = pinconfig->direction;
-		msg.data[5] = 0;
-	} else /* TODO: SMS_DEVICE_FAMILY1 */
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
 		return -EINVAL;
 
-	return coredev->sendrequest_handler(coredev->context,
-					    &msg, sizeof(msg));
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
 }
 
-int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level)
-{
-	struct {
-		struct SmsMsgHdr_ST hdr;
-		u32 data[3];
-	} msg;
+int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
+		u8 NewLevel) {
 
-	if (pin > MAX_GPIO_PIN_NUMBER)
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
 		return -EINVAL;
 
-	msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
-	msg.hdr.msgDstId = HIF_TASK;
-	msg.hdr.msgFlags = 0;
-	msg.hdr.msgType  = MSG_SMS_GPIO_SET_LEVEL_REQ;
-	msg.hdr.msgLength = sizeof(msg);
+	totalLen = sizeof(struct SmsMsgHdr_ST) +
+			(3 * sizeof(u32)); /* keep it 3 ! */
 
-	msg.data[0] = pin;
-	msg.data[1] = level ? 1 : 0;
-	msg.data[2] = 0;
+	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
+			GFP_KERNEL | GFP_DMA);
+	if (!buffer)
+		return -ENOMEM;
 
-	return coredev->sendrequest_handler(coredev->context,
-					    &msg, sizeof(msg));
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
diff -r 71c60eec8001 -r 8b645aa2ab13 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 22:13:13 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 22:28:38 2009 +0300
@@ -553,27 +553,41 @@ struct smscore_gpio_config {
 struct smscore_gpio_config {
 #define SMS_GPIO_DIRECTION_INPUT  0
 #define SMS_GPIO_DIRECTION_OUTPUT 1
-	u8 direction;
+	u8 Direction;
 
 #define SMS_GPIO_PULLUPDOWN_NONE     0
 #define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
 #define SMS_GPIO_PULLUPDOWN_PULLUP   2
 #define SMS_GPIO_PULLUPDOWN_KEEPER   3
-	u8 pullupdown;
+	u8 PullUpDown;
 
 #define SMS_GPIO_INPUTCHARACTERISTICS_NORMAL  0
 #define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
-	u8 inputcharacteristics;
+	u8 InputCharacteristics;
 
-#define SMS_GPIO_OUTPUTSLEWRATE_FAST 0
-#define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
-	u8 outputslewrate;
+#define SMS_GPIO_OUTPUTSLEWRATE_SLOW		0 /* 10xx */
+#define SMS_GPIO_OUTPUTSLEWRATE_FAST		1 /* 10xx */
 
-#define SMS_GPIO_OUTPUTDRIVING_4mA  0
-#define SMS_GPIO_OUTPUTDRIVING_8mA  1
-#define SMS_GPIO_OUTPUTDRIVING_12mA 2
-#define SMS_GPIO_OUTPUTDRIVING_16mA 3
-	u8 outputdriving;
+#define SMS_GPIO_OUTPUTSLEWRATE_0_45_V_NS	0 /* 11xx */
+#define SMS_GPIO_OUTPUTSLEWRATE_0_9_V_NS	1 /* 11xx */
+#define SMS_GPIO_OUTPUTSLEWRATE_1_7_V_NS	2 /* 11xx */
+#define SMS_GPIO_OUTPUTSLEWRATE_3_3_V_NS	3 /* 11xx */
+	u8 OutputSlewRate;
+
+#define SMS_GPIO_OUTPUTDRIVING_S_4mA		0 /* 10xx */
+#define SMS_GPIO_OUTPUTDRIVING_S_8mA		1 /* 10xx */
+#define SMS_GPIO_OUTPUTDRIVING_S_12mA		2 /* 10xx */
+#define SMS_GPIO_OUTPUTDRIVING_S_16mA		3 /* 10xx */
+
+#define SMS_GPIO_OUTPUTDRIVING_1_5mA		0 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_2_8mA		1 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_4mA			2 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_7mA			3 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_10mA			4 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_11mA			5 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_14mA			6 /* 11xx */
+#define SMS_GPIO_OUTPUTDRIVING_16mA			7 /* 11xx */
+	u8 OutputDriving;
 };
 
 extern void smscore_registry_setmode(char *devpath, int mode);



      
