Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933242Ab3CSQuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 36/46] [media] siano: Only feed DVB data when there's a feed
Date: Tue, 19 Mar 2013 13:49:25 -0300
Message-Id: <1363711775-2120-37-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, the driver sends DVB data even before tunning.

It was noticed that this may lead into some mistakes at DVB
decode, as the PIDs from wrong channels may be associated with
another frequency, as they may already be inside the PID buffers.

So, prevent it by not feeding DVB demux with data while there's no
feed or while the device is not tuned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 18 +++++++++++++++---
 drivers/media/common/siano/smsdvb.h      |  3 +++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index b146064..114fe57 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -511,8 +511,13 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
-		dvb_dmx_swfilter(&client->demux, p,
-				 cb->size - sizeof(struct SmsMsgHdr_ST));
+		/*
+		 * Only feed data to dvb demux if are there any feed listening
+		 * to it and if the device has tuned
+		 */
+		if (client->feed_users && client->has_tuned)
+			dvb_dmx_swfilter(&client->demux, p,
+					 cb->size - sizeof(struct SmsMsgHdr_ST));
 		break;
 
 	case MSG_SMS_RF_TUNE_RES:
@@ -578,9 +583,10 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
 			else
 				sms_board_dvb3_event(client, DVB3_EVENT_UNC_ERR);
+			client->has_tuned = true;
 		} else {
 			smsdvb_stats_not_ready(fe);
-
+			client->has_tuned = false;
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_UNLOCK);
 		}
 		complete(&client->stats_done);
@@ -622,6 +628,8 @@ static int smsdvb_start_feed(struct dvb_demux_feed *feed)
 	sms_debug("add pid %d(%x)",
 		  feed->pid, feed->pid);
 
+	client->feed_users++;
+
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
 	PidMsg.xMsgHeader.msgFlags = 0;
@@ -642,6 +650,8 @@ static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
 	sms_debug("remove pid %d(%x)",
 		  feed->pid, feed->pid);
 
+	client->feed_users--;
+
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
 	PidMsg.xMsgHeader.msgFlags = 0;
@@ -962,6 +972,8 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe)
 	c->strength.stat[0].uvalue = 0;
 	c->cnr.stat[0].uvalue = 0;
 
+	client->has_tuned = false;
+
 	switch (smscore_get_device_mode(coredev)) {
 	case DEVICE_MODE_DVBT:
 	case DEVICE_MODE_DVBT_BDA:
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index 3422069..63cdd75 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -54,6 +54,9 @@ struct smsdvb_client_t {
 
 	unsigned long		get_stats_jiffies;
 
+	int			feed_users;
+	bool			has_tuned;
+
 	/* Stats debugfs data */
 	struct dentry		*debugfs;
 
-- 
1.8.1.4

