Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:38366
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbcGYDf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2016 23:35:26 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [dvbv5-scan] wait no more than timeout when scanning
Date: Sun, 24 Jul 2016 23:35:17 -0400
Message-Id: <1469417717-18017-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

some frontends (mentioned on lgdt3306a) wait timeout inside code like:
for (i = 20; i > 0; i--) {
  msleep(50);

If there is no-LOCK then dvbv5-scan spent a lot of time (doing 40x calls).
This patch introduce timeout which 4 sec * multiply. So we do not wait more
than 4 sec (or so) if no-LOCK.
CLOCK_MONOTONIC is used so we don't care about timestamps "rollup"

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 utils/dvb/dvbv5-scan.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 689bc0b..f6bb3fc 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -182,12 +182,23 @@ static int print_frontend_stats(struct arguments *args,
 	return 0;
 }
 
+/* return timestamp in msec */
+uint64_t get_timestamp()
+{
+	struct timespec now;
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return now.tv_sec * 1000 + now.tv_nsec/1000000;
+}
+
 static int check_frontend(void *__args,
 			  struct dvb_v5_fe_parms *parms)
 {
 	struct arguments *args = __args;
 	int rc, i;
 	fe_status_t status;
+	uint64_t start = get_timestamp();
+	/* msec timeout by default 4 sec * multiply */ 
+	uint64_t timeout = args->timeout_multiply * 4 * 1000;
 
 	args->n_status_lines = 0;
 	for (i = 0; i < args->timeout_multiply * 40; i++) {
@@ -203,6 +214,10 @@ static int check_frontend(void *__args,
 		print_frontend_stats(args, parms);
 		if (status & FE_HAS_LOCK)
 			break;
+
+		if ((get_timestamp() - start) > timeout)
+			break;
+
 		usleep(100000);
 	};
 
-- 
2.7.4

