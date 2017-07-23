Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33862 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdGWKNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id 79so1683931wmg.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:19 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 1/7] [media] dvb-frontends/stv0910: fix STR assignment, remove unneeded var
Date: Sun, 23 Jul 2017 12:13:09 +0200
Message-Id: <20170723101315.12523-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

According to the documentation, FE_SCALE_DECIBEL values should be assigned
to .svalue and not .uvalue, so let's do this. While at it, remove the
unneeded strength var from read_signal_strength().

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index bae1da3fdb2d..4084c142f1e4 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1321,7 +1321,6 @@ static void read_signal_strength(struct dvb_frontend *fe)
 {
 	struct stv *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &state->fe.dtv_property_cache;
-	s64 strength;
 	u8 reg[2];
 	u16 agc;
 	s32 padc, power = 0;
@@ -1341,10 +1340,8 @@ static void read_signal_strength(struct dvb_frontend *fe)
 
 	padc = table_lookup(padc_lookup, ARRAY_SIZE(padc_lookup), power) + 352;
 
-	strength = (padc - agc);
-
 	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
-	p->strength.stat[0].uvalue = strength;
+	p->strength.stat[0].svalue = (padc - agc);
 }
 
 static int read_status(struct dvb_frontend *fe, enum fe_status *status)
-- 
2.13.0
