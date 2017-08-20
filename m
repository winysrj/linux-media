Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37202 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbdHTK3V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:29:21 -0400
Received: by mail-wr0-f196.google.com with SMTP id z91so13117695wrc.4
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:29:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 2/2] [media] dvb-frontends/stv0910: fix mask for scramblingcode setup
Date: Sun, 20 Aug 2017 12:29:15 +0200
Message-Id: <20170820102915.6196-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170820102915.6196-1-d.scheller.oss@gmail.com>
References: <20170820102915.6196-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index fe25b1778555..d1ae9553f74c 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1021,7 +1021,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 		write_reg(state, RSTV0910_P2_PLROOT1 + state->regoff,
 			  (scrambling_code >> 8) & 0xff);
 		write_reg(state, RSTV0910_P2_PLROOT2 + state->regoff,
-			  (scrambling_code >> 16) & 0x07);
+			  (scrambling_code >> 16) & 0x0f);
 		state->cur_scrambling_code = scrambling_code;
 	}
 
-- 
2.13.0
