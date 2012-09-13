Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward3.mail.yandex.net ([77.88.46.8]:44191 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2IMOZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 10:25:23 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: linux-media@vger.kernel.org
Cc: Akihiro TSUKADA <tskd2@yahoo.co.jp>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] va1j5jf8007s: Multistream support 
MIME-Version: 1.0
Message-Id: <1057731347546320@web15d.yandex.ru>
Date: Thu, 13 Sep 2012 17:25:20 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update multistream support.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
index d980dfb..1b637b7 100644
--- a/drivers/media/pci/pt1/va1j5jf8007s.c
+++ b/drivers/media/pci/pt1/va1j5jf8007s.c
@@ -329,8 +329,8 @@ va1j5jf8007s_set_ts_id(struct va1j5jf8007s_state *state)
 	u8 buf[3];
 	struct i2c_msg msg;
 
-	ts_id = state->fe.dtv_property_cache.isdbs_ts_id;
-	if (!ts_id)
+	ts_id = state->fe.dtv_property_cache.stream_id;
+	if (!ts_id || ts_id == NO_STREAM_ID_FILTER)
 		return 0;
 
 	buf[0] = 0x8f;
@@ -356,8 +356,8 @@ va1j5jf8007s_check_ts_id(struct va1j5jf8007s_state *state, int *lock)
 	struct i2c_msg msgs[2];
 	u32 ts_id;
 
-	ts_id = state->fe.dtv_property_cache.isdbs_ts_id;
-	if (!ts_id) {
+	ts_id = state->fe.dtv_property_cache.stream_id;
+	if (!ts_id || ts_id == NO_STREAM_ID_FILTER) {
 		*lock = 1;
 		return 0;
 	}
@@ -587,7 +587,8 @@ static struct dvb_frontend_ops va1j5jf8007s_ops = {
 		.frequency_stepsize = 1000,
 		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO |
+			FE_CAN_MULTISTREAM,
 	},
 
 	.read_snr = va1j5jf8007s_read_snr,
