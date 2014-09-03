Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 35/46] [media] stv0367: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:07 -0300
Message-Id: <945ce02df8d516ebdd4522600a17f701a81ed2c0.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 764577218974..59f622ae80e8 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1935,8 +1935,6 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
-
-	int error = 0;
 	enum stv0367_ter_mode mode;
 	int constell = 0,/* snr = 0,*/ Data = 0;
 
@@ -2020,7 +2018,7 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe)
 
 	p->guard_interval = stv0367_readbits(state, F367TER_SYR_GUARD);
 
-	return error;
+	return 0;
 }
 
 static int stv0367ter_read_snr(struct dvb_frontend *fe, u16 *snr)
-- 
1.9.3

