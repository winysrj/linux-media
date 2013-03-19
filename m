Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab3CSQuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 32/46] [media] siano: don't request statistics too fast
Date: Tue, 19 Mar 2013 13:49:21 -0300
Message-Id: <1363711775-2120-33-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As each DVBv3 call may generate an stats overhead, prevent doing
it too fast. This is specially useful if a burst of get stats
DVBv3 call is sent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 5 +++++
 drivers/media/common/siano/smsdvb.h      | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index c14f10d..4242005 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -663,6 +663,11 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 	int rc;
 	struct SmsMsgHdr_ST Msg;
 
+	/* Don't request stats too fast */
+	if (client->get_stats_jiffies &&
+	   (!time_after(jiffies, client->get_stats_jiffies)))
+		return 0;
+	client->get_stats_jiffies = jiffies + msecs_to_jiffies(100);
 
 	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	Msg.msgDstId = HIF_TASK;
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index 09982bc..3422069 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -52,6 +52,8 @@ struct smsdvb_client_t {
 	int event_fe_state;
 	int event_unc_state;
 
+	unsigned long		get_stats_jiffies;
+
 	/* Stats debugfs data */
 	struct dentry		*debugfs;
 
-- 
1.8.1.4

