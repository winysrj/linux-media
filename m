Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40426 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbeC0Pvk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:51:40 -0400
Received: by mail-pl0-f68.google.com with SMTP id x4-v6so14333221pln.7
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 08:51:40 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb-frontends/tc90522: fix bit shift mistakes
Date: Wed, 28 Mar 2018 00:51:21 +0900
Message-Id: <20180327155121.13110-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

they were obviously wrong.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 5572b39614d..04fb4922332 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -352,7 +352,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe,
 	mode = 1;
 	ret = reg_read(state, 0xb0, val, 1);
 	if (ret == 0) {
-		mode = (val[0] & 0xc0) >> 2;
+		mode = (val[0] & 0xc0) >> 6;
 		c->transmission_mode = tm_conv[mode];
 		c->guard_interval = (val[0] & 0x30) >> 4;
 	}
@@ -379,7 +379,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe,
 		}
 
 		/* layer B */
-		v = (val[3] & 0x03) << 1 | (val[4] & 0xc0) >> 6;
+		v = (val[3] & 0x03) << 2 | (val[4] & 0xc0) >> 6;
 		if (v == 0x0f)
 			c->layer[1].segment_count = 0;
 		else {
-- 
2.16.3
