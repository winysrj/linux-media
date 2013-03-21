Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab3CUNCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:02:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD2nwn020856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:02:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] [siano] fix checkpatch.pl compliants on smscoreapi.h
Date: Thu, 21 Mar 2013 10:02:40 -0300
Message-Id: <1363870963-28552-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the remaining checkpatch.pl compliants at smscoreapi.h,
except by the "line over 80 characters" on comments. Fixing those
would require more time, as the better is to convert them into the
struct descriptions used inside the kernel, as described at:
	Documentation/kernel-doc-nano-HOWTO.txt

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index b65232a..b0253d2 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -577,8 +577,11 @@ enum msg_types {
 };
 
 #define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
-	(ptr)->msg_type = type; (ptr)->msg_src_id = src; (ptr)->msg_dst_id = dst; \
-	(ptr)->msg_length = len; (ptr)->msg_flags = 0; \
+	(ptr)->msg_type = type; \
+	(ptr)->msg_src_id = src; \
+	(ptr)->msg_dst_id = dst; \
+	(ptr)->msg_length = len; \
+	(ptr)->msg_flags = 0; \
 } while (0)
 
 #define SMS_INIT_MSG(ptr, type, len) \
@@ -704,7 +707,7 @@ struct sms_stats {
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET,
 	valid only for DVB-T/H */
 	u32 guard_interval;	/* Guard Interval from
-	SMSHOSTLIB_GUARD_INTERVALS_ET, 	valid only for DVB-T/H */
+	SMSHOSTLIB_GUARD_INTERVALS_ET,	valid only for DVB-T/H */
 	u32 code_rate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
 	valid only for DVB-T/H */
 	u32 lp_code_rate;		/* Low Priority Code Rate from
@@ -746,7 +749,7 @@ struct sms_stats {
 	u32 sms_to_host_tx_errors;	/* Total number of transmission errors. */
 
 	/* DAB/T-DMB */
-	u32 pre_ber; 		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
+	u32 pre_ber;		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
 
 	/* DVB-H TPS parameters */
 	u32 cell_id;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
@@ -1177,7 +1180,8 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 
 #define dprintk(kern, lvl, fmt, arg...) do {\
 	if (sms_dbg & lvl) \
-		sms_printk(kern, fmt, ##arg); } while (0)
+		sms_printk(kern, fmt, ##arg); \
+} while (0)
 
 #define sms_log(fmt, arg...) sms_printk(KERN_INFO, fmt, ##arg)
 #define sms_err(fmt, arg...) \
-- 
1.8.1.4

