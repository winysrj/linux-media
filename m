Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab3LQSdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:47 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/6] [media] dib8000: Fix UCB measure with DVBv5 stats
Date: Tue, 17 Dec 2013 13:30:44 -0200
Message-Id: <1387294246-10155-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
References: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On dib8000, the block error count is a monotonic 32 bits register.
With DVBv5 stats, we use a 64 bits counter, that it is reset
when a new channel is tuned.

Change the UCB counting start from 0 and to be returned with
64 bits, just like the API requests.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 7b10b73befbe..ef0d9ec0df23 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -119,6 +119,7 @@ struct dib8000_state {
 	u8 longest_intlv_layer;
 	u16 output_mode;
 
+	s64 init_ucb;
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1_max;
 	u16 agc1_min;
@@ -986,10 +987,13 @@ static u16 dib8000_identify(struct i2c_device *client)
 	return value;
 }
 
+static int dib8000_read_unc_blocks(struct dvb_frontend *fe, u32 *unc);
+
 static void dib8000_reset_stats(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
+	u32 ucb;
 
 	memset(&c->strength, 0, sizeof(c->strength));
 	memset(&c->cnr, 0, sizeof(c->cnr));
@@ -1010,6 +1014,9 @@ static void dib8000_reset_stats(struct dvb_frontend *fe)
 	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+	dib8000_read_unc_blocks(fe, &ucb);
+	state->init_ucb = -ucb;
 }
 
 static int dib8000_reset(struct dvb_frontend *fe)
@@ -3989,14 +3996,12 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].uvalue += 100000000;
 
-	/*
-	 * FIXME: this is refreshed on every second, but a time
-	 * drift between dib8000 and PC clock may cause troubles
-	 */
 	dib8000_read_unc_blocks(fe, &val);
+	if (val < state->init_ucb)
+		state->init_ucb += 1L << 32;
 
 	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-	c->block_error.stat[0].uvalue += val;
+	c->block_error.stat[0].uvalue = val + state->init_ucb;
 
 	if (state->revision < 0x8002)
 		return 0;
-- 
1.8.3.1

