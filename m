Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63196 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3ACUhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 15:37:33 -0500
Received: by mail-ee0-f43.google.com with SMTP id e49so7856314eek.16
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 12:37:32 -0800 (PST)
Message-ID: <1357245445.12232.3.camel@canaries64>
Subject: [PATCH] ts2020.c: ts2020_set_params [BUG] point to fe->tuner_priv.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 03 Jan 2013 20:37:25 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes corruption of fe->demodulator_priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/ts2020.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 94e3fe2..f50e237 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -182,7 +182,7 @@ static int ts2020_set_tuner_rf(struct dvb_frontend *fe)
 static int ts2020_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct ts2020_priv *priv = fe->demodulator_priv;
+	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
 	u32 frequency = c->frequency;
 	s32 offset_khz;
-- 
1.8.0


