Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43093 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbaJaNX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:23:27 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so7731677pab.28
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:23:27 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2] dvb:tc90522: fix stats report
Date: Fri, 31 Oct 2014 22:23:18 +0900
Message-Id: <1414761798-1496-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

* report the fixed per-transponder symbolrate instead of per-TS ones
* add output TS-ID report

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index bca81ef..b35d65c 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -216,32 +216,30 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	c->delivery_system = SYS_ISDBS;
 
 	layers = 0;
-	ret = reg_read(state, 0xe8, val, 3);
+	ret = reg_read(state, 0xe6, val, 5);
 	if (ret == 0) {
-		int slots;
 		u8 v;
 
+		c->stream_id = val[0] << 8 | val[1];
+
 		/* high/single layer */
-		v = (val[0] & 0x70) >> 4;
+		v = (val[2] & 0x70) >> 4;
 		c->modulation = (v == 7) ? PSK_8 : QPSK;
 		c->fec_inner = fec_conv_sat[v];
 		c->layer[0].fec = c->fec_inner;
 		c->layer[0].modulation = c->modulation;
-		c->layer[0].segment_count = val[1] & 0x3f; /* slots */
+		c->layer[0].segment_count = val[3] & 0x3f; /* slots */
 
 		/* low layer */
-		v = (val[0] & 0x07);
+		v = (val[2] & 0x07);
 		c->layer[1].fec = fec_conv_sat[v];
 		if (v == 0)  /* no low layer */
 			c->layer[1].segment_count = 0;
 		else
-			c->layer[1].segment_count = val[2] & 0x3f; /* slots */
+			c->layer[1].segment_count = val[4] & 0x3f; /* slots */
 		/* actually, BPSK if v==1, but not defined in fe_modulation_t */
 		c->layer[1].modulation = QPSK;
 		layers = (v > 0) ? 2 : 1;
-
-		slots =  c->layer[0].segment_count +  c->layer[1].segment_count;
-		c->symbol_rate = 28860000 * slots / 48;
 	}
 
 	/* statistics */
-- 
2.1.3

