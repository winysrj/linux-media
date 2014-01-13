Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/7] [media] dib8000: Properly represent long long integers
Date: Mon, 13 Jan 2014 16:32:34 -0200
Message-Id: <1389637958-3884-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiling with avr32, it gets those errors:

	drivers/media/dvb-frontends/dib8000.c: In function 'dib8000_get_stats':
	drivers/media/dvb-frontends/dib8000.c:4121: warning: integer constant is too large for 'long' type

Fix integer representation to avoid overflow.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 481ee49e6a37..dd4a99cff3e7 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4118,7 +4118,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 		/* Get UCB measures */
 		dib8000_read_unc_blocks(fe, &val);
 		if (val < state->init_ucb)
-			state->init_ucb += 0x100000000L;
+			state->init_ucb += 0x100000000LL;
 
 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 		c->block_error.stat[0].uvalue = val + state->init_ucb;
@@ -4128,7 +4128,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 			time_us = dib8000_get_time_us(fe, -1);
 
 		if (time_us) {
-			blocks = 1250000UL * 1000000UL;
+			blocks = 1250000ULL * 1000000ULL;
 			do_div(blocks, time_us * 8 * 204);
 			c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 			c->block_count.stat[0].uvalue += blocks;
@@ -4191,7 +4191,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 			if (!time_us)
 				time_us = dib8000_get_time_us(fe, i);
 			if (time_us) {
-				blocks = 1250000UL * 1000000UL;
+				blocks = 1250000ULL * 1000000ULL;
 				do_div(blocks, time_us * 8 * 204);
 				c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 				c->block_count.stat[0].uvalue += blocks;
-- 
1.8.3.1

