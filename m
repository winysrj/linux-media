Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6238 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755070Ab1ITKSo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:44 -0400
Subject: [PATCH 8/17]DVB:Siano drivers -  Hide smscore structure from all
 modules which are not the core device.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:24 +0300
Message-ID: <1316514684.5199.86.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch makes smscore structure hidden from all other module by
making it's pointer NULL.

Thanks,
Doron Cohen

--------------


>From b003e8ec2893b7d6e68720abeb490fba38904e59 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Mon, 19 Sep 2011 14:16:02 +0300
Subject: [PATCH 11/21] Hide smscore data by making pointer NULL with
unkniown fields.

---
 drivers/media/dvb/siano/smsdvb.c |   65
+++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index 62dd37c..2695d3a 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -37,7 +37,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 struct smsdvb_client_t {
 	struct list_head entry;
 
-	struct smscore_device_t *coredev;
+	void *coredev;
 	struct smscore_client_t *smsclient;
 
 	struct dvb_adapter      adapter;
@@ -73,15 +73,15 @@ enum SMS_DVB3_EVENTS {
 static struct list_head g_smsdvb_clients;
 static struct mutex g_smsdvb_clientslock;
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
+int sms_debug;
+module_param_named(debug, sms_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 /* Events that may come from DVB v3 adapter */
 static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 		enum SMS_DVB3_EVENTS event) {
 
-	struct smscore_device_t *coredev = client->coredev;
+	void *coredev = client->coredev;
 	switch (event) {
 	case DVB3_EVENT_INIT:
 		sms_debug("DVB3_EVENT_INIT");
@@ -656,45 +656,43 @@ static int smsdvb_isdbt_set_frontend(struct
dvb_frontend *fe,
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
-
-	struct {
-		struct SmsMsgHdr_S	Msg;
-		u32		Data[4];
-	} Msg;
+	struct SmsMsgData4Args_S Msg;
 
 	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
 
-	Msg.Msg.msgSrcId  = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msgDstId  = HIF_TASK;
-	Msg.Msg.msgFlags  = 0;
-	Msg.Msg.msgType   = MSG_SMS_ISDBT_TUNE_REQ;
-	Msg.Msg.msgLength = sizeof(Msg);
-
+	Msg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.xMsgHeader.msgDstId = HIF_TASK;
+	Msg.xMsgHeader.msgFlags = 0;
+	Msg.xMsgHeader.msgType   = MSG_SMS_ISDBT_TUNE_REQ;
+	Msg.xMsgHeader.msgLength = sizeof(Msg);
+	Msg.msgData[0] = p->frequency;
 	if (c->isdbt_sb_segment_idx == -1)
 		c->isdbt_sb_segment_idx = 0;
+	sms_info("freq %d band %d",
+		  p->frequency, p->u.ofdm.bandwidth);
 
 	switch (c->isdbt_sb_segment_count) {
 	case 3:
-		Msg.Data[1] = BW_ISDBT_3SEG;
+		Msg.msgData[1] = BW_ISDBT_3SEG;
 		break;
 	case 1:
-		Msg.Data[1] = BW_ISDBT_1SEG;
+		Msg.msgData[1] = BW_ISDBT_1SEG;
 		break;
 	case 0:	/* AUTO */
 		switch (c->bandwidth_hz / 1000000) {
 		case 8:
 		case 7:
 			c->isdbt_sb_segment_count = 3;
-			Msg.Data[1] = BW_ISDBT_3SEG;
+			Msg.msgData[1] = BW_ISDBT_3SEG;
 			break;
 		case 6:
 			c->isdbt_sb_segment_count = 1;
-			Msg.Data[1] = BW_ISDBT_1SEG;
+			Msg.msgData[1] = BW_ISDBT_1SEG;
 			break;
 		default: /* Assumes 6 MHZ bw */
 			c->isdbt_sb_segment_count = 1;
 			c->bandwidth_hz = 6000;
-			Msg.Data[1] = BW_ISDBT_1SEG;
+			Msg.msgData[1] = BW_ISDBT_1SEG;
 			break;
 		}
 		break;
@@ -702,10 +700,9 @@ static int smsdvb_isdbt_set_frontend(struct
dvb_frontend *fe,
 		sms_info("Segment count %d not supported",
c->isdbt_sb_segment_count);
 		return -EINVAL;
 	}
-
-	Msg.Data[0] = c->frequency;
-	Msg.Data[2] = 12000000;
-	Msg.Data[3] = c->isdbt_sb_segment_idx;
+        Msg.msgData[0] = c->frequency;
+	Msg.msgData[2] = 12000000;
+	Msg.msgData[3] = c->isdbt_sb_segment_idx;
 
 	sms_info("%s: freq %d segwidth %d segindex %d\n", __func__,
 		 c->frequency, c->isdbt_sb_segment_count,
@@ -782,7 +779,7 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.info = {
 		.name			= "Siano Mobile Digital MDTV Receiver",
 		.type			= FE_OFDM,
-		.frequency_min		= 44250000,
+	        .frequency_min = 164000000,
 		.frequency_max		= 867250000,
 		.frequency_stepsize	= 250000,
 		.caps = FE_CAN_INVERSION_AUTO |
@@ -811,16 +808,24 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.sleep = smsdvb_sleep,
 };
 
-static int smsdvb_hotplug(void *coredev,
-			  struct device *device, int arrival)
+static int smsdvb_hotplug(void *coredev, struct device *device, int
arrival)
 {
 	struct smsclient_params_t params;
 	struct smsdvb_client_t *client;
 	int rc;
+	int mode = smscore_get_device_mode(coredev);
 
 	/* device removal handled by onremove callback */
 	if (!arrival)
 		return 0;
+
+	if ( (mode != SMSHOSTLIB_DEVMD_DVBT_BDA) &&
+	     (mode != SMSHOSTLIB_DEVMD_ISDBT_BDA) ) {
+		sms_err("SMS Device mode is not set for "
+			"DVB operation.");
+		return 0;
+	}
+
 	client = kzalloc(sizeof(struct smsdvb_client_t), GFP_KERNEL);
 	if (!client) {
 		sms_err("kmalloc() failed");
@@ -949,6 +954,8 @@ static void __exit smsdvb_module_exit(void)
 module_init(smsdvb_module_init);
 module_exit(smsdvb_module_exit);
 
-MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
-MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
+#define MODULE_VERSION_STRING "Siano DVB module for LinuxTV interface
"VERSION_STRING
+
+MODULE_DESCRIPTION(MODULE_VERSION_STRING);
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

