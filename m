Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbcF2Wnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jiri Kosina <jkosina@suse.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 05/10] au8522: remove au8522_read_ber() ops
Date: Wed, 29 Jun 2016 19:43:21 -0300
Message-Id: <1b9a13b1a6be99eb656ff8bbbcd4465bd0e1d2eb.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no code on au8522 to get the bit error rate.
Remove the fake function that were returning the number of
uncorrected error blocks as if they were ber.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index aebee53903cc..22d837494cc7 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -787,15 +787,6 @@ static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status)
 	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 	c->block_error.stat[0].uvalue = state->ucblocks;
 }
-static int au8522_read_signal_strength(struct dvb_frontend *fe,
-				       u16 *signal_strength)
-{
-	struct au8522_state *state = fe->demodulator_priv;
-
-	*signal_strength = state->strength;
-
-	return 0;
-}
 
 static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
@@ -857,6 +848,16 @@ static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	return 0;
 }
 
+static int au8522_read_signal_strength(struct dvb_frontend *fe,
+				       u16 *signal_strength)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+
+	*signal_strength = state->strength;
+
+	return 0;
+}
+
 static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct au8522_state *state = fe->demodulator_priv;
@@ -866,16 +867,6 @@ static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int au8522_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct au8522_state *state = fe->demodulator_priv;
-
-	/* FIXME: This is so wrong! */
-	*ber = state->ucblocks;
-
-	return 0;
-}
-
 static int au8522_get_frontend(struct dvb_frontend *fe,
 			       struct dtv_frontend_properties *c)
 {
@@ -987,7 +978,6 @@ static struct dvb_frontend_ops au8522_ops = {
 	.get_frontend         = au8522_get_frontend,
 	.get_tune_settings    = au8522_get_tune_settings,
 	.read_status          = au8522_read_status,
-	.read_ber             = au8522_read_ber,
 	.read_signal_strength = au8522_read_signal_strength,
 	.read_snr             = au8522_read_snr,
 	.read_ucblocks        = au8522_read_ucblocks,
-- 
2.7.4

