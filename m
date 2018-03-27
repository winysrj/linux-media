Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34001 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeC0Q5L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 12:57:11 -0400
Received: by mail-pf0-f195.google.com with SMTP id q9so2363204pff.1
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 09:57:11 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb-core/dvb_frontend: set better default for ISDB-T
Date: Wed, 28 Mar 2018 01:56:58 +0900
Message-Id: <20180327165658.19998-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

DTV_ISDBT_LAYER_ENABLED parameter should be set to "All" by default,
instead of "None", as described in the API document.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a7ed16e0841..fb10ac9cdd9 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -973,7 +973,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->isdbt_sb_subchannel = 0;
 	c->isdbt_sb_segment_idx = 0;
 	c->isdbt_sb_segment_count = 0;
-	c->isdbt_layer_enabled = 0;
+	c->isdbt_layer_enabled = 7;	/* All layers (A,B,C) */
 	for (i = 0; i < 3; i++) {
 		c->layer[i].fec = FEC_AUTO;
 		c->layer[i].modulation = QAM_AUTO;
-- 
2.16.3
