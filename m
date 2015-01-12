Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc3s15.hotmail.com ([65.55.116.90]:50826 "EHLO
	BLU004-OMC3S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbbALAit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 19:38:49 -0500
Message-ID: <BLU436-SMTP195E555A687F62E2F6F3462BA430@phx.gbl>
From: Michael Krufky <mkrufky@hotmail.com>
To: linux-media@vger.kernel.org
CC: m.chehab@samsung.com, Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] lgdt3305: we only need to pass state into lgdt3305_mpeg_mode_polarity()
Date: Sun, 11 Jan 2015 19:33:08 -0500
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Ira Krufky <mkrufky@linuxtv.org>

Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-frontends/lgdt3305.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 92c891a..b42d649 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -236,12 +236,12 @@ static inline int lgdt3305_mpeg_mode(struct lgdt3305_state *state,
 	return lgdt3305_set_reg_bit(state, LGDT3305_TP_CTRL_1, 5, mode);
 }
 
-static int lgdt3305_mpeg_mode_polarity(struct lgdt3305_state *state,
-				       enum lgdt3305_tp_clock_edge edge,
-				       enum lgdt3305_tp_valid_polarity valid)
+static int lgdt3305_mpeg_mode_polarity(struct lgdt3305_state *state)
 {
 	u8 val;
 	int ret;
+	enum lgdt3305_tp_clock_edge edge = state->cfg->tpclk_edge;
+	enum lgdt3305_tp_valid_polarity valid = state->cfg->tpvalid_polarity;
 
 	lg_dbg("edge = %d, valid = %d\n", edge, valid);
 
@@ -740,9 +740,7 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe)
 		goto fail;
 
 	/* lgdt3305_mpeg_mode_polarity calls lgdt3305_soft_reset */
-	ret = lgdt3305_mpeg_mode_polarity(state,
-					  state->cfg->tpclk_edge,
-					  state->cfg->tpvalid_polarity);
+	ret = lgdt3305_mpeg_mode_polarity(state);
 fail:
 	return ret;
 }
@@ -806,9 +804,7 @@ static int lgdt3305_set_parameters(struct dvb_frontend *fe)
 		goto fail;
 
 	/* lgdt3305_mpeg_mode_polarity calls lgdt3305_soft_reset */
-	ret = lgdt3305_mpeg_mode_polarity(state,
-					  state->cfg->tpclk_edge,
-					  state->cfg->tpvalid_polarity);
+	ret = lgdt3305_mpeg_mode_polarity(state);
 fail:
 	return ret;
 }
-- 
2.1.0

