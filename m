Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:43282 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752063AbZESPsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:48:46 -0400
Message-ID: <495724.2537.qm@web110816.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:48:47 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_50] Siano: smscore - Add big endian support
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242748399 -10800
# Node ID a93ebe0069b3d7d8d791ccb620a7797508cf724c
# Parent  4d75f9d1c4f96d65a8ad312c21e488a212ee58a3
[09051_50] Siano: smscore - Add big endian support

From: Uri Shkolnik <uris@siano-ms.com>

Add support for big endian target, to the smscore module.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 4d75f9d1c4f9 -r a93ebe0069b3 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:48:35 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:53:19 2009 +0300
@@ -34,8 +34,10 @@
 #include <asm/byteorder.h>
 
 #include "smscoreapi.h"
+#include "smsendian.h"
 #include "sms-cards.h"
 #include "smsir.h"
+
 #define MAX_GPIO_PIN_NUMBER	31
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 10)
@@ -465,6 +467,8 @@ static int smscore_init_ir(struct smscor
 				msg->msgData[0] = coredev->ir.controller;
 				msg->msgData[1] = coredev->ir.timeout;
 
+				smsendian_handle_tx_message(
+					(struct SmsMsgHdr_ST2 *)msg);
 				rc = smscore_sendrequest_and_wait(coredev, msg,
 						msg->xMsgHeader. msgLength,
 						&coredev->ir_init_done);
@@ -545,6 +549,7 @@ static int smscore_load_firmware_family2
 		sms_debug("sending reload command.");
 		SMS_INIT_MSG(msg, MSG_SW_RELOAD_START_REQ,
 			     sizeof(struct SmsMsgHdr_ST));
+		smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 		rc = smscore_sendrequest_and_wait(coredev, msg,
 						  msg->msgLength,
 						  &coredev->reload_start_done);
@@ -563,6 +568,7 @@ static int smscore_load_firmware_family2
 		DataMsg->MemAddr = mem_address;
 		memcpy(DataMsg->Payload, payload, payload_size);
 
+		smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 		if ((coredev->device_flags & SMS_ROM_NO_RESPONSE) &&
 		    (coredev->mode == DEVICE_MODE_NONE))
 			rc = coredev->sendrequest_handler(
@@ -595,6 +601,7 @@ static int smscore_load_firmware_family2
 			TriggerMsg->msgData[3] = 0; /* Parameter */
 			TriggerMsg->msgData[4] = 4; /* Task ID */
 
+			smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 			if (coredev->device_flags & SMS_ROM_NO_RESPONSE) {
 				rc = coredev->sendrequest_handler(
 					coredev->context, TriggerMsg,
@@ -608,7 +615,7 @@ static int smscore_load_firmware_family2
 		} else {
 			SMS_INIT_MSG(msg, MSG_SW_RELOAD_EXEC_REQ,
 				     sizeof(struct SmsMsgHdr_ST));
-
+			smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 			rc = coredev->sendrequest_handler(coredev->context,
 							  msg, msg->msgLength);
 		}
@@ -767,6 +774,7 @@ static int smscore_detect_mode(struct sm
 	SMS_INIT_MSG(msg, MSG_SMS_GET_VERSION_EX_REQ,
 		     sizeof(struct SmsMsgHdr_ST));
 
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
 					  &coredev->version_ex_done);
 	if (rc == -ETIME) {
@@ -895,6 +903,7 @@ int smscore_set_device_mode(struct smsco
 				     sizeof(struct SmsMsgData_ST));
 			msg->msgData[0] = mode;
 
+			smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 			rc = smscore_sendrequest_and_wait(
 				coredev, msg, msg->xMsgHeader.msgLength,
 				&coredev->init_device_done);
@@ -1102,6 +1111,8 @@ void smscore_onresponse(struct smscore_d
 		rc = client->onresponse_handler(client->context, cb);
 
 	if (rc < 0) {
+		smsendian_handle_rx_message((struct SmsMsgData_ST *)phdr);
+
 		switch (phdr->msgType) {
 		case MSG_SMS_GET_VERSION_EX_RES:
 		{
@@ -1604,6 +1615,7 @@ int smscore_gpio_configure(struct smscor
 		pMsg->msgData[5] = 0;
 	}
 
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_configuration_done);
 
@@ -1653,6 +1665,7 @@ int smscore_gpio_set_level(struct smscor
 	pMsg->msgData[1] = NewLevel;
 
 	/* Send message to SMS */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_set_level_done);
 
@@ -1701,6 +1714,7 @@ int smscore_gpio_get_level(struct smscor
 	pMsg->msgData[1] = 0;
 
 	/* Send message to SMS */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_get_level_done);
 



      
