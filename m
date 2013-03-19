Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778Ab3CSQt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:49:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/46] [media] siano: add some new messages to the smscoreapi
Date: Tue, 19 Mar 2013 13:49:05 -0300
Message-Id: <1363711775-2120-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on Doron Cohen's patch:
	http://patchwork.linuxtv.org/patch/7887/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index d928c22..6e60c99 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1430,7 +1430,23 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		rc = client->onresponse_handler(client->context, cb);
 
 	if (rc < 0) {
+		smsendian_handle_rx_message((struct SmsMsgData_ST *)phdr);
+
 		switch (phdr->msgType) {
+		case MSG_SMS_ISDBT_TUNE_RES:
+			break;
+		case MSG_SMS_RF_TUNE_RES:
+			break;
+		case MSG_SMS_SIGNAL_DETECTED_IND:
+			break;
+		case MSG_SMS_NO_SIGNAL_IND:
+			break;
+		case MSG_SMS_SPI_INT_LINE_SET_RES:
+			break;
+		case MSG_SMS_INTERFACE_LOCK_IND:
+			break;
+		case MSG_SMS_INTERFACE_UNLOCK_IND:
+			break;
 		case MSG_SMS_GET_VERSION_EX_RES:
 		{
 			struct SmsVersionRes_ST *ver =
-- 
1.8.1.4

