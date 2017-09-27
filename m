Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33160
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752174AbdI0Vkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 03/37] media: stv6110: get rid of a srate dead code
Date: Wed, 27 Sep 2017 18:40:04 -0300
Message-Id: <a6526cb5bd2e97ba0f5e5cb5038db2ab26c37b30.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stv6110 has a weird code that checks if get_property
and set_property ioctls are defined. If they're, it initializes
a "srate" var from properties cache. Otherwise, it sets to
15MBaud, with won't make any sense.

Thankfully, it seems that someone else discovered the issue in
the past, as "srate" is currently not used anywhere!

So, get rid of that really weird dead code logic.

Reported-by: Honza Petrous <jpetrous@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv6110.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index e4fd9c1b0560..6aad0efa3174 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -258,11 +258,9 @@ static int stv6110_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
 	struct stv6110_priv *priv = fe->tuner_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 ret = 0x04;
 	u32 divider, ref, p, presc, i, result_freq, vco_freq;
 	s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
-	s32 srate;
 
 	dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
 						frequency, priv->mclk);
@@ -273,13 +271,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 				((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
 
 	/* BB_GAIN = db/2 */
-	if (fe->ops.set_property && fe->ops.get_property) {
-		srate = c->symbol_rate;
-		dprintk("%s: Get Frontend parameters: srate=%d\n",
-							__func__, srate);
-	} else
-		srate = 15000000;
-
 	priv->regs[RSTV6110_CTRL2] &= ~0x0f;
 	priv->regs[RSTV6110_CTRL2] |= (priv->gain & 0x0f);
 
-- 
2.13.5
