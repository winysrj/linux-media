Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab3CSQuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 24/46] [media] siano: simplify message endianness logic
Date: Tue, 19 Mar 2013 13:49:13 -0300
Message-Id: <1363711775-2120-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, every time a message is sent or received, the endiannes
need to be fixed on big endian machines. This is currently done
on every call to the send API, and on every msg reception logic.

Instead of doing that, move it to the send/receive functions.

That simplifies the logic and avoids the risk of forgetting to
fix it somewhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 14 --------------
 drivers/media/common/siano/smsdvb.c     |  8 --------
 drivers/media/mmc/siano/smssdio.c       |  3 +++
 drivers/media/usb/siano/smsusb.c        |  9 ++++++---
 4 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 35486c5..029dd6a 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -37,7 +37,6 @@
 #include "smscoreapi.h"
 #include "sms-cards.h"
 #include "smsir.h"
-#include "smsendian.h"
 
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
@@ -807,8 +806,6 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 				msg->msgData[0] = coredev->ir.controller;
 				msg->msgData[1] = coredev->ir.timeout;
 
-				smsendian_handle_tx_message(
-					(struct SmsMsgHdr_ST2 *)msg);
 				rc = smscore_sendrequest_and_wait(coredev, msg,
 						msg->xMsgHeader. msgLength,
 						&coredev->ir_init_done);
@@ -853,7 +850,6 @@ int smscore_configure_board(struct smscore_device_t *coredev)
 		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
 		MtuMsg.msgData[0] = board->mtu;
 
-		smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&MtuMsg);
 		coredev->sendrequest_handler(coredev->context, &MtuMsg,
 					     sizeof(MtuMsg));
 	}
@@ -867,7 +863,6 @@ int smscore_configure_board(struct smscore_device_t *coredev)
 				sizeof(CrysMsg));
 		CrysMsg.msgData[0] = board->crystal;
 
-		smsendian_handle_tx_message((struct SmsMsgHdr_S *)&CrysMsg);
 		coredev->sendrequest_handler(coredev->context, &CrysMsg,
 					     sizeof(CrysMsg));
 	}
@@ -989,7 +984,6 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		/* Entry point */
 	msg->msgData[1] = firmware->Length;
 	msg->msgData[2] = 0; /* Regular checksum*/
-	smsendian_handle_tx_message(msg);
 	rc = smscore_sendrequest_and_wait(coredev, msg,
 					  msg->xMsgHeader.msgLength,
 					  &coredev->data_validity_done);
@@ -1013,14 +1007,12 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		TriggerMsg->msgData[3] = 0; /* Parameter */
 		TriggerMsg->msgData[4] = 4; /* Task ID */
 
-		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
 		rc = smscore_sendrequest_and_wait(coredev, TriggerMsg,
 					TriggerMsg->xMsgHeader.msgLength,
 					&coredev->trigger_done);
 	} else {
 		SMS_INIT_MSG(&msg->xMsgHeader, MSG_SW_RELOAD_EXEC_REQ,
 				sizeof(struct SmsMsgHdr_ST));
-		smsendian_handle_tx_message((struct SmsMsgHdr_S *)msg);
 		rc = coredev->sendrequest_handler(coredev->context, msg,
 				msg->xMsgHeader.msgLength);
 	}
@@ -1306,7 +1298,6 @@ int smscore_init_device(struct smscore_device_t *coredev, int mode)
 			sizeof(struct SmsMsgData_ST));
 	msg->msgData[0] = mode;
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
 	rc = smscore_sendrequest_and_wait(coredev, msg,
 			msg->xMsgHeader. msgLength,
 			&coredev->init_device_done);
@@ -1527,8 +1518,6 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		rc = client->onresponse_handler(client->context, cb);
 
 	if (rc < 0) {
-		smsendian_handle_rx_message((struct SmsMsgData_ST *)phdr);
-
 		switch (phdr->msgType) {
 		case MSG_SMS_ISDBT_TUNE_RES:
 			break;
@@ -2009,7 +1998,6 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 		pMsg->msgData[5] = 0;
 	}
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_configuration_done);
 
@@ -2059,7 +2047,6 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
 	pMsg->msgData[1] = NewLevel;
 
 	/* Send message to SMS */
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_set_level_done);
 
@@ -2108,7 +2095,6 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
 	pMsg->msgData[1] = 0;
 
 	/* Send message to SMS */
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_get_level_done);
 
diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index dbb807e..6335574 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -29,7 +29,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include "dvb_frontend.h"
 
 #include "smscoreapi.h"
-#include "smsendian.h"
 #include "sms-cards.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
@@ -324,8 +323,6 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
 	bool is_status_update = false;
 
-	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
-
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
 		dvb_dmx_swfilter(&client->demux, (u8 *)(phdr + 1),
@@ -545,7 +542,6 @@ static int smsdvb_start_feed(struct dvb_demux_feed *feed)
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient,
 				     &PidMsg, sizeof(PidMsg));
 }
@@ -566,7 +562,6 @@ static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient,
 				     &PidMsg, sizeof(PidMsg));
 }
@@ -577,7 +572,6 @@ static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
 {
 	int rc;
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer);
 	rc = smsclient_sendrequest(client->smsclient, buffer, size);
 	if (rc < 0)
 		return rc;
@@ -606,8 +600,6 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 	else
 		Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&Msg);
-
 	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					 &client->stats_done);
 
diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index c96da47..8834c43 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -43,6 +43,7 @@
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
+#include "smsendian.h"
 
 /* Registers */
 
@@ -97,6 +98,7 @@ static int smssdio_sendrequest(void *context, void *buffer, size_t size)
 
 	sdio_claim_host(smsdev->func);
 
+	smsendian_handle_tx_message((struct SmsMsgData_ST *) buffer);
 	while (size >= smsdev->func->cur_blksize) {
 		ret = sdio_memcpy_toio(smsdev->func, SMSSDIO_DATA,
 					buffer, smsdev->func->cur_blksize);
@@ -231,6 +233,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 	cb->size = hdr->msgLength;
 	cb->offset = 0;
 
+	smsendian_handle_rx_message((struct SmsMsgData_ST *) cb->p);
 	smscore_onresponse(smsdev->coredev, cb);
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 751c0d6..acd3d1e 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -129,6 +129,8 @@ static void smsusb_onresponse(struct urb *urb)
 				  smscore_translate_msg(phdr->msgType),
 				  phdr->msgType, phdr->msgLength);
 
+			smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
+
 			smscore_onresponse(dev->coredev, surb->cb);
 			surb->cb = NULL;
 		} else {
@@ -207,13 +209,14 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) buffer;
 	int dummy;
 
+	if (dev->state != SMSUSB_ACTIVE)
+		return -ENOENT;
+
 	sms_debug("sending %s(%d) size: %d",
 		  smscore_translate_msg(phdr->msgType), phdr->msgType,
 		  phdr->msgLength);
 
-	if (dev->state != SMSUSB_ACTIVE)
-		return -ENOENT;
-
+	smsendian_handle_tx_message((struct SmsMsgData_ST *) phdr);
 	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
-- 
1.8.1.4

