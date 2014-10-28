Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 08/13] [media] lbdt3306a: simplify the lock status check
Date: Tue, 28 Oct 2014 13:00:43 -0200
Message-Id: <2cf3f13aa583cf9f7454b88ea9953cc3a5f297fe.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic there is too complex and it looks like an inifite
loop.

So, simplify the logic and implement it as a for loop.

This gets rid of the following checkpatch.pl warnings:

WARNING: else is not generally useful after a break or return
+			return LG3306_UNLOCK;
+		} else {

WARNING: else is not generally useful after a break or return
+			return LG3306_UNLOCK;
+		} else {

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 85fc9c63e3ca..0356810da444 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1461,64 +1461,52 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 	u8 packet_error;
 	u32 snr;
 
-	while (1) {
+	for (cnt = 0; cnt < 10; cnt++) {
 		if (lgdt3306a_sync_lock_poll(state) == LG3306_UNLOCK) {
 			dbg_info("no sync lock!\n");
 			return LG3306_UNLOCK;
-		} else {
-			msleep(20);
-			ret = lgdt3306a_pre_monitoring(state);
-			if (ret)
-				return LG3306_UNLOCK;
-
-			packet_error = lgdt3306a_get_packet_error(state);
-			snr = lgdt3306a_calculate_snr_x100(state);
-			dbg_info("cnt=%d errors=%d snr=%d\n",
-			       cnt, packet_error, snr);
-
-			if ((snr < 1500) || (packet_error >= 0xff))
-				cnt++;
-			else
-				return LG3306_LOCK;
-
-			if (cnt >= 10) {
-				dbg_info("not locked!\n");
-				return LG3306_UNLOCK;
-			}
 		}
+
+		msleep(20);
+		ret = lgdt3306a_pre_monitoring(state);
+		if (ret)
+			break;
+
+		packet_error = lgdt3306a_get_packet_error(state);
+		snr = lgdt3306a_calculate_snr_x100(state);
+		dbg_info("cnt=%d errors=%d snr=%d\n", cnt, packet_error, snr);
+
+		if ((snr >= 1500) && (packet_error < 0xff))
+			return LG3306_LOCK;
 	}
+
+	dbg_info("not locked!\n");
 	return LG3306_UNLOCK;
 }
 
 static enum lgdt3306a_lock_status lgdt3306a_qam_lock_poll(struct lgdt3306a_state *state)
 {
-	u8 cnt = 0;
+	u8 cnt;
 	u8 packet_error;
 	u32	snr;
 
-	while (1) {
+	for (cnt = 0; cnt < 10; cnt++) {
 		if (lgdt3306a_fec_lock_poll(state) == LG3306_UNLOCK) {
 			dbg_info("no fec lock!\n");
 			return LG3306_UNLOCK;
-		} else {
-			msleep(20);
-
-			packet_error = lgdt3306a_get_packet_error(state);
-			snr = lgdt3306a_calculate_snr_x100(state);
-			dbg_info("cnt=%d errors=%d snr=%d\n",
-			       cnt, packet_error, snr);
-
-			if ((snr < 1500) || (packet_error >= 0xff))
-				cnt++;
-			else
-				return LG3306_LOCK;
-
-			if (cnt >= 10) {
-				dbg_info("not locked!\n");
-				return LG3306_UNLOCK;
-			}
 		}
+
+		msleep(20);
+
+		packet_error = lgdt3306a_get_packet_error(state);
+		snr = lgdt3306a_calculate_snr_x100(state);
+		dbg_info("cnt=%d errors=%d snr=%d\n", cnt, packet_error, snr);
+
+		if ((snr >= 1500) && (packet_error < 0xff))
+			return LG3306_LOCK;
 	}
+
+	dbg_info("not locked!\n");
 	return LG3306_UNLOCK;
 }
 
-- 
1.9.3

