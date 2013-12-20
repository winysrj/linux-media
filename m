Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3LTNRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 08:17:21 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] dib8000: fix compilation error
Date: Fri, 20 Dec 2013 08:14:06 -0200
Message-Id: <1387534446-25329-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by  kbuild test robot <fengguang.wu@intel.com>:

with a random config:

   drivers/built-in.o: In function `dib8000_get_time_us.isra.16':
>> dib8000.c:(.text+0x3075aa): undefined reference to `__udivdi3'

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 7539d7af2cf7..481ee49e6a37 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3951,7 +3951,7 @@ static u32 dib8000_get_time_us(struct dvb_frontend *fe, int layer)
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	int ini_layer, end_layer, i;
-	u64 time_us;
+	u64 time_us, tmp64;
 	u32 tmp, denom;
 	int guard, rate_num, rate_denum, bits_per_symbol, nsegs;
 	int interleaving, fft_div;
@@ -4048,7 +4048,9 @@ static u32 dib8000_get_time_us(struct dvb_frontend *fe, int layer)
 
 	/* Estimate the period for the total bit rate */
 	time_us = rate_denum * (1008 * 1562500L);
-	time_us = time_us + time_us / guard;
+	tmp64 = time_us;
+	do_div(tmp64, guard);
+	time_us = time_us + tmp64;
 	time_us += denom / 2;
 	do_div(time_us, denom);
 
-- 
1.8.3.1

