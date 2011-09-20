Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6297 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932138Ab1ITKTM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:19:12 -0400
Subject: [PATCH  13/17]DVB:Siano drivers - Support big endian platform
 which uses SPI/I2C
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:54 +0300
Message-ID: <1316514714.5199.91.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch step adds support big endian platform which uses SPI/I2C

Thanks,
Doron Cohen

>From 2b77c0b5f69924206b9e09cda42aad56772e9380 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 08:31:52 +0300
Subject: [PATCH 17/21] Support big endian platform which uses SPI/I2C
(need to switch header byte order)

---
 drivers/media/dvb/siano/smscoreapi.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index e50e356..459c6e9 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -570,8 +570,8 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 		sms_debug("sending reload command.");
 		SMS_INIT_MSG(msg, MSG_SW_RELOAD_START_REQ,
 			     sizeof(struct SmsMsgHdr_S));
-		rc = smscore_sendrequest_and_wait(coredev, msg,
-						  msg->msgLength,
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
+		rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
 						  &coredev->reload_start_done);
 
 		if (rc < 0) {				
@@ -597,7 +597,7 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 		memcpy(DataMsg->Payload, payload, payload_size);
 
 
-	
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
 		rc = smscore_sendrequest_and_wait(coredev, DataMsg,
 				DataMsg->xMsgHeader.msgLength,
 				&coredev->data_download_done);
@@ -976,6 +976,7 @@ static int smscore_detect_mode(struct
smscore_device_t *coredev)
 	SMS_INIT_MSG(msg, MSG_SMS_GET_VERSION_EX_REQ,
 		     sizeof(struct SmsMsgHdr_S));
 
+	smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
 	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
 					  &coredev->version_ex_done);
 
@@ -1356,6 +1357,8 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 		rc = client->onresponse_handler(client->context, cb);
 
 	if (rc < 0) {
+		smsendian_handle_rx_message((struct SmsMsgData_S *)phdr);
+
 		switch (phdr->msgType) {
 		case MSG_SMS_ISDBT_TUNE_RES:
 			sms_debug("MSG_SMS_ISDBT_TUNE_RES");
-- 
1.7.4.1

