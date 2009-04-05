Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:31169 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757054AbZDEKSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 06:18:05 -0400
Message-ID: <827426.7180.qm@web110807.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 03:18:01 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_10] Siano: smsdvb - add events mechanism
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238742622 -10800
# Node ID ec7ee486fb86d51bdb48e6a637a6ddd52e9e08c2
# Parent  020ba7b31c963bd36d607848198e9e4258a6f80e
[PATCH] [0904_10] Siano: smsdvb - add events mechanism

From: Uri Shkolnik <uris@siano-ms.com>

Add events mechanism that will notify the "cards" component
(which represent the specific hardware target) for DVB related
events.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 020ba7b31c96 -r ec7ee486fb86 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 21:33:14 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 10:10:22 2009 +0300
@@ -66,6 +66,45 @@ static int sms_dbg;
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
+
+/* Events that may come from DVB v3 adapter */
+static void sms_board_dvb3_event(struct smscore_device_t *coredev,
+		enum SMS_DVB3_EVENTS event) {
+	switch (event) {
+	case DVB3_EVENT_INIT:
+		sms_debug("DVB3_EVENT_INIT");
+		/* sms_board_event(coredev, BOARD_EVENT_BIND); */
+		break;
+	case DVB3_EVENT_SLEEP:
+		sms_debug("DVB3_EVENT_SLEEP");
+		/* sms_board_event(coredev, BOARD_EVENT_POWER_SUSPEND); */
+		break;
+	case DVB3_EVENT_HOTPLUG:
+		sms_debug("DVB3_EVENT_HOTPLUG");
+		/* sms_board_event(coredev, BOARD_EVENT_POWER_INIT); */
+		break;
+	case DVB3_EVENT_FE_LOCK:
+		sms_debug("DVB3_EVENT_FE_LOCK");
+		/* sms_board_event(coredev, BOARD_EVENT_FE_LOCK); */
+		break;
+	case DVB3_EVENT_FE_UNLOCK:
+		sms_debug("DVB3_EVENT_FE_UNLOCK");
+		/* sms_board_event(coredev, BOARD_EVENT_FE_UNLOCK); */
+		break;
+	case DVB3_EVENT_UNC_OK:
+		sms_debug("DVB3_EVENT_UNC_OK");
+		/* sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_OK); */
+		break;
+	case DVB3_EVENT_UNC_ERR:
+		sms_debug("DVB3_EVENT_UNC_ERR");
+		/* sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_ERRORS); */
+		break;
+
+	default:
+		sms_err("Unknown dvb3 api event");
+		break;
+	}
+}
 
 static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 {
@@ -174,17 +213,15 @@ static int smsdvb_onresponse(void *conte
 		client->fe_status = 0;
 	}
 
-	/*
-	 if (client->fe_status & FE_HAS_LOCK)
-	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
-	 else
-	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
+	if (client->fe_status & FE_HAS_LOCK)
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
+	else
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
 
-	 if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
-	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
-	 else
-	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
-	 */
+	if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
+	else
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
 
 	if (client->fe_status & FE_HAS_LOCK)
 		sms_board_led_feedback(client->coredev,
@@ -346,13 +383,12 @@ static int smsdvb_set_frontend(struct dv
 			       struct dvb_frontend_parameters *fep)
 {
 	struct smsdvb_client_t *client =
-	container_of(fe, struct smsdvb_client_t, frontend);
+	    container_of(fe, struct smsdvb_client_t, frontend);
 
 	struct {
 		struct SmsMsgHdr_ST Msg;
 		u32 Data[3];
 	} Msg;
-	int ret;
 
 	Msg.Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	Msg.Msg.msgDstId = HIF_TASK;
@@ -387,7 +423,8 @@ static int smsdvb_set_frontend(struct dv
 	}
 
 	/* Disable LNA, if any. An error is returned if no LNA is present */
-	ret = sms_board_lna_control(client->coredev, 0);
+	{
+	int ret = sms_board_lna_control(client->coredev, 0);
 	if (ret == 0) {
 		fe_status_t status;
 
@@ -403,7 +440,7 @@ static int smsdvb_set_frontend(struct dv
 		/* previous tune didnt lock - enable LNA and tune again */
 		sms_board_lna_control(client->coredev, 1);
 	}
-
+	}
 	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					   &client->tune_done);
 }
@@ -428,6 +465,7 @@ static int smsdvb_init(struct dvb_fronte
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
+	sms_board_dvb3_event(client->coredev, DVB3_EVENT_INIT);
 	sms_board_power(client->coredev, 1);
 
 	return 0;
@@ -438,6 +476,7 @@ static int smsdvb_sleep(struct dvb_front
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
+	sms_board_dvb3_event(client->coredev, DVB3_EVENT_SLEEP);
 	sms_board_led_feedback(client->coredev, SMS_LED_OFF);
 	sms_board_power(client->coredev, 0);
 
@@ -572,6 +611,7 @@ static int smsdvb_hotplug(struct smscore
 
 	sms_info("success");
 
+	sms_board_dvb3_event(coredev, DVB3_EVENT_HOTPLUG);
 	sms_board_setup(coredev);
 
 	return 0;
@@ -614,8 +654,8 @@ void smsdvb_module_exit(void)
 	kmutex_lock(&g_smsdvb_clientslock);
 
 	while (!list_empty(&g_smsdvb_clients))
-	       smsdvb_unregister_client(
-			(struct smsdvb_client_t *) g_smsdvb_clients.next);
+		smsdvb_unregister_client((struct smsdvb_client_t *)
+					 g_smsdvb_clients.next);
 
 	kmutex_unlock(&g_smsdvb_clientslock);
 }



      
