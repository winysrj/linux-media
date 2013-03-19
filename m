Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933242Ab3CSQum (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:42 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 28/46] [media] siano: fix start of statistics
Date: Tue, 19 Mar 2013 13:49:17 -0300
Message-Id: <1363711775-2120-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that the first u32 after the header for some stats are used by
something not documented.

The stats struct starts after it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index a5f5272..70ea3e9 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -724,7 +724,8 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 			smsdvb_update_isdbt_stats(client, p);
 			break;
 		default:
-			smsdvb_update_dvb_stats(client, p);
+			/* Skip SmsMsgStatisticsInfo_ST:RequestResult field */
+			smsdvb_update_dvb_stats(client, p + sizeof(u32));
 		}
 
 		is_status_update = true;
@@ -732,7 +733,8 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 
 	/* Only for ISDB-T */
 	case MSG_SMS_GET_STATISTICS_EX_RES:
-		smsdvb_update_isdbt_stats_ex(client, p);
+		/* Skip SmsMsgStatisticsInfo_ST:RequestResult field? */
+		smsdvb_update_isdbt_stats_ex(client, p + sizeof(u32));
 		is_status_update = true;
 		break;
 	default:
-- 
1.8.1.4

