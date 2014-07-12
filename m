Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaGLAh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 20:37:57 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] mb86a20s: Fix the code that estimates the measurement interval
Date: Fri, 11 Jul 2014 21:37:48 -0300
Message-Id: <1405125468-4748-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
References: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of looking at the guard interval field, it was using
the interval length, with is wrong. Fix it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 2de0e59bd243..227a420f7069 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -556,7 +556,7 @@ static u32 isdbt_rate[3][5][4] = {
 
 static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 				   u32 modulation, u32 forward_error_correction,
-				   u32 interleaving,
+				   u32 guard_interval,
 				   u32 segment)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -564,7 +564,7 @@ static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 	int mod, fec, guard;
 
 	/*
-	 * If modulation/fec/interleaving is not detected, the default is
+	 * If modulation/fec/guard is not detected, the default is
 	 * to consider the lowest bit rate, to avoid taking too long time
 	 * to get BER.
 	 */
@@ -602,7 +602,7 @@ static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 		break;
 	}
 
-	switch (interleaving) {
+	switch (guard_interval) {
 	default:
 	case GUARD_INTERVAL_1_4:
 		guard = 0;
@@ -693,7 +693,7 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		c->layer[layer].interleaving = rc;
 		mb86a20s_layer_bitrate(fe, layer, c->layer[layer].modulation,
 				       c->layer[layer].fec,
-				       c->layer[layer].interleaving,
+				       c->guard_interval,
 				       c->layer[layer].segment_count);
 	}
 
-- 
1.9.3

