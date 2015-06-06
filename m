Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53648 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] ts2020: improve filter limit calc
Date: Sat,  6 Jun 2015 14:58:42 +0300
Message-Id: <1433591928-30915-2-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* We don't need calculate channel bandwidth from symbol rate as it
is calculated by DVB core.

* Use clamp() to force upper/lower limit of filter 3dB frequency.
Upper limit should never exceeded 40MHz (80MHz BW) in any case,
though...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index bc48388..590f7e1 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -233,7 +233,6 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
-	u32 symbol_rate = (c->symbol_rate / 1000);
 	u32 f3db, gdiv28;
 	u16 u16tmp, value, lpf_coeff;
 	u8 buf[3], reg10, lpf_mxdiv, mlpf_max, mlpf_min, nlpf;
@@ -312,12 +311,9 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 
 	value = ts2020_readreg(fe, 0x26);
 
-	f3db = (symbol_rate * 135) / 200 + 2000;
-	f3db += FREQ_OFFSET_LOW_SYM_RATE;
-	if (f3db < 7000)
-		f3db = 7000;
-	if (f3db > 40000)
-		f3db = 40000;
+	f3db = (c->bandwidth_hz / 1000 / 2) + 2000;
+	f3db += FREQ_OFFSET_LOW_SYM_RATE; /* FIXME: ~always too wide filter */
+	f3db = clamp(f3db, 7000U, 40000U);
 
 	gdiv28 = gdiv28 * 207 / (value * 2 + 151);
 	mlpf_max = gdiv28 * 135 / 100;
-- 
http://palosaari.fi/

