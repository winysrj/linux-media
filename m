Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49882
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751172AbdIOJLI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:11:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 2/5] media: stv6110: get rid of a srate dead code
Date: Fri, 15 Sep 2017 06:10:58 -0300
Message-Id: <be4198870b124684d5ce566cb8176e7298eae371.1505466580.git.mchehab@s-opensource.com>
In-Reply-To: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
In-Reply-To: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stv6110 has a weird code that checks if get_property
and set_property ioctls are defined. If they're, it initializes
a "srate" var from properties cache. Otherwise, it sets to
15MBaud, with won't make any sense.

Thankfully, it seems that someone already noticed, as the
"srate" is not used anywhere!

So, get rid of that really weird dead code logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv6110.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index e4fd9c1b0560..2821f6da6764 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -262,7 +262,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	u8 ret = 0x04;
 	u32 divider, ref, p, presc, i, result_freq, vco_freq;
 	s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
-	s32 srate;
 
 	dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
 						frequency, priv->mclk);
@@ -273,13 +272,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
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
