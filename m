Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaLWOVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 09:21:34 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dib8000: upd_demod_gain_period should be u32
Date: Tue, 23 Dec 2014 12:21:12 -0200
Message-Id: <1419344472-29927-1-git-send-email-mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As shown at the code, upd_demod_gain_period is used to write
to two 16-bit registers:
    dib8000_write_word(state, 1946, upd_demod_gain_period & 0xFFFF);
    dib8000_write_word(state, 1947, reg | (1<<14) | ((upd_demod_gain_period >> 16) & 0xFF));

So, it should be declared as u32.

This fixes the following smatch warning:
	drivers/media/dvb-frontends/dib8000.c:1282 dib8000_agc_startup() warn: right shifting more than type allows

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 61e31f2d2f71..8c6663b6399d 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1263,7 +1263,8 @@ static int dib8000_agc_startup(struct dvb_frontend *fe)
 	struct dib8000_state *state = fe->demodulator_priv;
 	enum frontend_tune_state *tune_state = &state->tune_state;
 	int ret = 0;
-	u16 reg, upd_demod_gain_period = 0x8000;
+	u16 reg;
+	u32 upd_demod_gain_period = 0x8000;
 
 	switch (*tune_state) {
 	case CT_AGC_START:
-- 
2.1.0

