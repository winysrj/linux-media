Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab3CSQuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 17/46] [media] siano: use a separate completion for stats
Date: Tue, 19 Mar 2013 13:49:06 -0300
Message-Id: <1363711775-2120-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of re-use tune_done also for stats, the better is to use
a different completion.

Also, it was noticed that sometimes, the driver answers with
MSG_SMS_SIGNAL_DETECTED_IND for status request. Fix the code to
also handle those other signal indicators.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 57f3560..f4fd670 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -48,6 +48,7 @@ struct smsdvb_client_t {
 	fe_status_t             fe_status;
 
 	struct completion       tune_done;
+	struct completion       stats_done;
 
 	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
 	int event_fe_state;
@@ -349,7 +350,6 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 			pReceptionData->ErrorTSPackets = 0;
 		}
 
-		complete(&client->tune_done);
 		break;
 	}
 	default:
@@ -376,6 +376,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 				client->fe_status = 0;
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_UNLOCK);
 		}
+		complete(&client->stats_done);
 	}
 
 	return 0;
@@ -471,7 +472,7 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 				    sizeof(struct SmsMsgHdr_ST), 0 };
 
 	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
-					  &client->tune_done);
+					 &client->stats_done);
 
 	return rc;
 }
@@ -1002,6 +1003,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	client->coredev = coredev;
 
 	init_completion(&client->tune_done);
+	init_completion(&client->stats_done);
 
 	kmutex_lock(&g_smsdvb_clientslock);
 
-- 
1.8.1.4

