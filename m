Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3CUNCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:02:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD2oxR028308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:02:50 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] siano: make some functions static
Date: Thu, 21 Mar 2013 10:02:43 -0300
Message-Id: <1363870963-28552-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/common/siano/smsdvb-debugfs.c:51:6: warning: no previous prototype for 'smsdvb_print_dvb_stats' [-Wmissing-prototypes]
drivers/media/common/siano/smsdvb-debugfs.c:154:6: warning: no previous prototype for 'smsdvb_print_isdb_stats' [-Wmissing-prototypes]
drivers/media/common/siano/smsdvb-debugfs.c:244:6: warning: no previous prototype for 'smsdvb_print_isdb_stats_ex' [-Wmissing-prototypes]
drivers/media/common/siano/smscoreapi.c:832:5: warning: no previous prototype for 'smscore_configure_board' [-Wmissing-prototypes]
drivers/media/common/siano/smscoreapi.c:1301:5: warning: no previous prototype for 'smscore_init_device' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c     | 4 ++--
 drivers/media/common/siano/smsdvb-debugfs.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e7fc4de..ebb9ece 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -829,7 +829,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
  *
  * @return 0 on success, <0 on error.
  */
-int smscore_configure_board(struct smscore_device_t *coredev)
+static int smscore_configure_board(struct smscore_device_t *coredev)
 {
 	struct sms_board *board;
 
@@ -1298,7 +1298,7 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
  *
  * @return 0 on success, <0 on error.
  */
-int smscore_init_device(struct smscore_device_t *coredev, int mode)
+static int smscore_init_device(struct smscore_device_t *coredev, int mode)
 {
 	void *buffer;
 	struct sms_msg_data *msg;
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 4c5691e..0bb4430 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -48,7 +48,7 @@ struct smsdvb_debugfs {
 	wait_queue_head_t	stats_queue;
 };
 
-void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
+static void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 			    struct sms_stats *p)
 {
 	int n = 0;
@@ -151,7 +151,7 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 	wake_up(&debug_data->stats_queue);
 }
 
-void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
+static void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 			     struct sms_isdbt_stats *p)
 {
 	int i, n = 0;
@@ -241,7 +241,7 @@ void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 	wake_up(&debug_data->stats_queue);
 }
 
-void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
+static void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
 				struct sms_isdbt_stats_ex *p)
 {
 	int i, n = 0;
-- 
1.8.1.4

