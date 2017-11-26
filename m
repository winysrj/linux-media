Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33503 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdKZNAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:18 -0500
Received: by mail-wm0-f67.google.com with SMTP id g130so25175951wme.0
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:18 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 5/7] [media] dvb-frontends/stv0910: read symbolrate in get_frontend()
Date: Sun, 26 Nov 2017 14:00:07 +0100
Message-Id: <20171126130009.6798-6-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Utilise get_cur_symbol_rate() in get_frontend() to update the
dtv_frontend_properties with the current symbol rate as reported by the
demodulator.

Reported-by: Richard Scobie <rascobie@slingshot.co.nz>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 074374fe00be..e9517e11b399 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1526,6 +1526,7 @@ static int get_frontend(struct dvb_frontend *fe,
 {
 	struct stv *state = fe->demodulator_priv;
 	u8 tmp;
+	u32 symbolrate;
 
 	if (state->receive_mode == RCVMODE_DVBS2) {
 		u32 mc;
@@ -1579,6 +1580,10 @@ static int get_frontend(struct dvb_frontend *fe,
 		p->rolloff = ROLLOFF_35;
 	}
 
+	if (state->receive_mode != RCVMODE_NONE) {
+		get_cur_symbol_rate(state, &symbolrate);
+		p->symbol_rate = symbolrate;
+	}
 	return 0;
 }
 
-- 
2.13.6
