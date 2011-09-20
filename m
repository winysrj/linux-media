Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6238 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1ITKSp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:45 -0400
Subject: [PATCH 9/17]DVB:Siano drivers - Improve debug capabilities by
 separating debug and info messages.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:28 +0300
Message-ID: <1316514688.5199.87.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch Improves debug capabilities by changing debug messages.
Thanks,
Doron Cohen

--------------


>From 1adbdde1dc186b23eb772f0c647d7175dc3f7418 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Mon, 19 Sep 2011 14:24:29 +0300
Subject: [PATCH 12/21] Improve debug capabilities by separating debug
and info messages

---
 drivers/media/dvb/siano/smsdvb.c |   39
++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index 2695d3a..b80868c 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -84,42 +84,42 @@ static void sms_board_dvb3_event(struct
smsdvb_client_t *client,
 	void *coredev = client->coredev;
 	switch (event) {
 	case DVB3_EVENT_INIT:
-		sms_debug("DVB3_EVENT_INIT");
+		sms_info("DVB3_EVENT_INIT");
 		sms_board_event(coredev, BOARD_EVENT_BIND);
 		break;
 	case DVB3_EVENT_SLEEP:
-		sms_debug("DVB3_EVENT_SLEEP");
+		sms_info("DVB3_EVENT_SLEEP");
 		sms_board_event(coredev, BOARD_EVENT_POWER_SUSPEND);
 		break;
 	case DVB3_EVENT_HOTPLUG:
-		sms_debug("DVB3_EVENT_HOTPLUG");
+		sms_info("DVB3_EVENT_HOTPLUG");
 		sms_board_event(coredev, BOARD_EVENT_POWER_INIT);
 		break;
 	case DVB3_EVENT_FE_LOCK:
 		if (client->event_fe_state != DVB3_EVENT_FE_LOCK) {
 			client->event_fe_state = DVB3_EVENT_FE_LOCK;
-			sms_debug("DVB3_EVENT_FE_LOCK");
+			sms_info("DVB3_EVENT_FE_LOCK");
 			sms_board_event(coredev, BOARD_EVENT_FE_LOCK);
 		}
 		break;
 	case DVB3_EVENT_FE_UNLOCK:
 		if (client->event_fe_state != DVB3_EVENT_FE_UNLOCK) {
 			client->event_fe_state = DVB3_EVENT_FE_UNLOCK;
-			sms_debug("DVB3_EVENT_FE_UNLOCK");
+			sms_info("DVB3_EVENT_FE_UNLOCK");
 			sms_board_event(coredev, BOARD_EVENT_FE_UNLOCK);
 		}
 		break;
 	case DVB3_EVENT_UNC_OK:
 		if (client->event_unc_state != DVB3_EVENT_UNC_OK) {
 			client->event_unc_state = DVB3_EVENT_UNC_OK;
-			sms_debug("DVB3_EVENT_UNC_OK");
+			sms_info("DVB3_EVENT_UNC_OK");
 			sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_OK);
 		}
 		break;
 	case DVB3_EVENT_UNC_ERR:
 		if (client->event_unc_state != DVB3_EVENT_UNC_ERR) {
 			client->event_unc_state = DVB3_EVENT_UNC_ERR;
-			sms_debug("DVB3_EVENT_UNC_ERR");
+			sms_info("DVB3_EVENT_UNC_ERR");
 			sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_ERRORS);
 		}
 		break;
@@ -249,20 +249,24 @@ static int smsdvb_onresponse(void *context, struct
smscore_buffer_t *cb)
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
 	struct SmsMsgHdr_S *phdr = (struct SmsMsgHdr_S *) (((u8 *) cb->p)
 			+ cb->offset);
-	u32 *pMsgData = (u32 *) phdr + 1;
-	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_S);*/
+	u32 *pMsgData = (u32 *) (phdr + 1);
 	bool is_status_update = false;
+	static int data_packets = 0;
 
 	smsendian_handle_rx_message((struct SmsMsgData_S *) phdr);
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
+		if (!(data_packets & 0xf));
+			sms_info("Got %d data packets so far.", data_packets);
+		data_packets++;
 		dvb_dmx_swfilter(&client->demux, (u8 *)(phdr + 1),
 				 cb->size - sizeof(struct SmsMsgHdr_S));
 		break;
 
 	case MSG_SMS_RF_TUNE_RES:
 	case MSG_SMS_ISDBT_TUNE_RES:
+		sms_info("MSG_SMS_RF_TUNE_RES");
 		complete(&client->tune_done);
 		break;
 
@@ -416,8 +420,7 @@ static int smsdvb_start_feed(struct dvb_demux_feed
*feed)
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct SmsMsgData_S PidMsg;
 
-	sms_debug("add pid %d(%x)",
-		  feed->pid, feed->pid);
+	sms_info("add pid %d(%x)", feed->pid, feed->pid);
 
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
@@ -437,8 +440,7 @@ static int smsdvb_stop_feed(struct dvb_demux_feed
*feed)
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct SmsMsgData_S PidMsg;
 
-	sms_debug("remove pid %d(%x)",
-		  feed->pid, feed->pid);
+	sms_info("remove pid %d(%x)", feed->pid, feed->pid);
 
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
@@ -578,7 +580,7 @@ static int smsdvb_read_ucblocks(struct dvb_frontend
*fe, u32 *ucblocks)
 static int smsdvb_get_tune_settings(struct dvb_frontend *fe,
 				    struct dvb_frontend_tune_settings *tune)
 {
-	sms_debug("");
+	sms_info("");
 
 	tune->min_delay_ms = 400;
 	tune->step_size = 250000;
@@ -629,6 +631,8 @@ static int smsdvb_dvbt_set_frontend(struct
dvb_frontend *fe,
 		return -EINVAL;
 	}
 	/* Disable LNA, if any. An error is returned if no LNA is present */
+	sms_info("setting LNA");
+
 	ret = sms_board_lna_control(client->coredev, 0);
 	if (ret == 0) {
 		fe_status_t status;
@@ -645,9 +649,11 @@ static int smsdvb_dvbt_set_frontend(struct
dvb_frontend *fe,
 		/* previous tune didn't lock - enable LNA and tune again */
 		sms_board_lna_control(client->coredev, 1);
 	}
+	sms_info("Sending message");
 
 	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					   &client->tune_done);
+	sms_info("Tune Done.");
 }
 
 static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe,
@@ -727,6 +733,7 @@ static int smsdvb_set_frontend(struct dvb_frontend
*fe,
 	case SMSHOSTLIB_DEVMD_ISDBT_BDA:
 		return smsdvb_isdbt_set_frontend(fe, fep);
 	default:
+		sms_err("SMS Device mode is not set for DVB operation.");
 		return -EINVAL;
 	}
 }
@@ -737,9 +744,9 @@ static int smsdvb_get_frontend(struct dvb_frontend
*fe,
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
-	sms_debug("");
+	sms_info("");
+
 
-	/* todo: */
 	memcpy(fep, &client->fe_params,
 	       sizeof(struct dvb_frontend_parameters));
 
-- 
1.7.4.1

