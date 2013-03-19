Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab3CSQuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 31/46] [media] siano: add two missing fields to ISDB-T stats debugfs
Date: Tue, 19 Mar 2013 13:49:20 -0300
Message-Id: <1363711775-2120-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those fields help to identify the version of the ISDB stats.
Useful while debuging the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-debugfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 4d5dd47..59c7323 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -166,6 +166,11 @@ void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 	buf = debug_data->stats_data;
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "StatisticsType = %d\t", p->StatisticsType);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "FullSize = %d\n", p->FullSize);
+
+	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "IsRfLocked = %d\t\t", p->IsRfLocked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "IsDemodLocked = %d\t", p->IsDemodLocked);
@@ -251,6 +256,11 @@ void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
 	buf = debug_data->stats_data;
 
 	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "StatisticsType = %d\t", p->StatisticsType);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "FullSize = %d\n", p->FullSize);
+
+	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "IsRfLocked = %d\t\t", p->IsRfLocked);
 	n += snprintf(&buf[n], PAGE_SIZE - n,
 		      "IsDemodLocked = %d\t", p->IsDemodLocked);
-- 
1.8.1.4

