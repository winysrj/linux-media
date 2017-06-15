Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57513 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751869AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/15] af9033: use kernel 64-bit division
Date: Thu, 15 Jun 2017 06:30:54 +0300
Message-Id: <20170615033105.13517-4-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace own binary division with 64-bit multiply and division.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c      | 34 +++----------------------------
 drivers/media/dvb-frontends/af9013_priv.h |  1 +
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index f644182..dd7ac0a 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -277,33 +277,6 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	return ret;
 }
 
-static u32 af9013_div(struct af9013_state *state, u32 a, u32 b, u32 x)
-{
-	u32 r = 0, c = 0, i;
-
-	dev_dbg(&state->client->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
-
-	if (a > b) {
-		c = a / b;
-		a = a - c * b;
-	}
-
-	for (i = 0; i < x; i++) {
-		if (a >= b) {
-			r += 1;
-			a -= b;
-		}
-		a <<= 1;
-		r <<= 1;
-	}
-	r = (c << (u32)x) + r;
-
-	dev_dbg(&state->client->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
-			__func__, a, b, x, r, r);
-
-	return r;
-}
-
 static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 {
 	int ret, i;
@@ -638,8 +611,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 			spec_inv = !state->spec_inv;
 		}
 
-		freq_cw = af9013_div(state, sampling_freq, state->clk,
-				23);
+		freq_cw = DIV_ROUND_CLOSEST_ULL((u64)sampling_freq * 0x800000,
+						state->clk);
 
 		if (spec_inv)
 			freq_cw = 0x800000 - freq_cw;
@@ -1108,11 +1081,10 @@ static int af9013_init(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	adc_cw = af9013_div(state, state->clk, 1000000ul, 19);
+	adc_cw = div_u64((u64)state->clk * 0x80000, 1000000);
 	buf[0] = (adc_cw >>  0) & 0xff;
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
-
 	ret = af9013_wr_regs(state, 0xd180, buf, 3);
 	if (ret)
 		goto err;
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index 31d6538..97b5b0c 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -24,6 +24,7 @@
 #include "dvb_frontend.h"
 #include "af9013.h"
 #include <linux/firmware.h>
+#include <linux/math64.h>
 
 #define AF9013_FIRMWARE "dvb-fe-af9013.fw"
 
-- 
http://palosaari.fi/
