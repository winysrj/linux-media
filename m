Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55742 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaBKCFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 21:05:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 03/16] e4000: fix PLL calc to allow higher frequencies
Date: Tue, 11 Feb 2014 04:04:46 +0200
Message-Id: <1392084299-16549-4-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-1-git-send-email-crope@iki.fi>
References: <1392084299-16549-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was 32-bit overflow on VCO frequency calculation which blocks
tuning to 1073 - 1104 MHz. Use 64 bit number in order to avoid VCO
frequency overflow.

After that fix device in question tunes to following range:
60 - 1104 MHz
1250 - 2207 MHz

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index ac44dd2..019dc62 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -221,11 +221,11 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	struct e4000_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, sigma_delta;
-	unsigned int f_vco;
+	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
 	dev_dbg(&priv->client->dev,
-			"%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
+			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
 			__func__, c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
@@ -248,20 +248,16 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	/*
-	 * Note: Currently f_vco overflows when c->frequency is 1 073 741 824 Hz
-	 * or more.
-	 */
-	f_vco = c->frequency * e4000_pll_lut[i].mul;
+	f_vco = 1ull * c->frequency * e4000_pll_lut[i].mul;
 	sigma_delta = div_u64(0x10000ULL * (f_vco % priv->clock), priv->clock);
-	buf[0] = f_vco / priv->clock;
+	buf[0] = div_u64(f_vco, priv->clock);
 	buf[1] = (sigma_delta >> 0) & 0xff;
 	buf[2] = (sigma_delta >> 8) & 0xff;
 	buf[3] = 0x00;
 	buf[4] = e4000_pll_lut[i].div;
 
 	dev_dbg(&priv->client->dev,
-			"%s: f_vco=%u pll div=%d sigma_delta=%04x\n",
+			"%s: f_vco=%llu pll div=%d sigma_delta=%04x\n",
 			__func__, f_vco, buf[0], sigma_delta);
 
 	ret = e4000_wr_regs(priv, 0x09, buf, 5);
-- 
1.8.5.3

