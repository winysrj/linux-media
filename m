Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261Ab3CSRYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:24:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 35/46] [media] siano: Fix bandwidth report
Date: Tue, 19 Mar 2013 13:49:24 -0300
Message-Id: <1363711775-2120-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was expected that the bandwidth would be following the defines
at smscoreapi.h. However, this doesn't work. Instead, this field
brings just the bandwidth in MHz. Convert it to Hertz.

It should be noticed that, on ISDB, using the _EX request, the
field TuneBW seems to show the value that matches the bandwidth
code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 632a250..b146064 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -43,18 +43,6 @@ module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 
-u32 sms_to_bw_table[] = {
-	[BW_8_MHZ]		= 8000000,
-	[BW_7_MHZ]		= 7000000,
-	[BW_6_MHZ]		= 6000000,
-	[BW_5_MHZ]		= 5000000,
-	[BW_2_MHZ]		= 2000000,
-	[BW_1_5_MHZ]		= 1500000,
-	[BW_ISDBT_1SEG]		= 6000000,
-	[BW_ISDBT_3SEG]		= 6000000,
-	[BW_ISDBT_13SEG]	= 6000000,
-};
-
 u32 sms_to_guard_interval_table[] = {
 	[0] = GUARD_INTERVAL_1_32,
 	[1] = GUARD_INTERVAL_1_16,
@@ -204,6 +192,9 @@ static inline int sms_to_status(u32 is_demod_locked, u32 is_rf_locked)
 	return 0;
 }
 
+static inline u32 sms_to_bw(u32 value) {
+	return value * 1000000;
+}
 
 #define convert_from_table(value, table, defval) ({			\
 	u32 __ret;							\
@@ -214,9 +205,6 @@ static inline int sms_to_status(u32 is_demod_locked, u32 is_rf_locked)
 	__ret;								\
 })
 
-#define sms_to_bw(value)						\
-	convert_from_table(value, sms_to_bw_table, 0);
-
 #define sms_to_guard_interval(value)					\
 	convert_from_table(value, sms_to_guard_interval_table,		\
 			   GUARD_INTERVAL_AUTO);
-- 
1.8.1.4

