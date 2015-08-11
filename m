Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965155AbbHKPUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:20:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/4] ov2659: get rid of unused values
Date: Tue, 11 Aug 2015 12:18:32 -0300
Message-Id: <64e82329e4957b77788544b2584e4993ee389b31.1439306295.git.mchehab@osg.samsung.com>
In-Reply-To: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
References: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
In-Reply-To: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
References: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Why to store the chosed values for prediv, postdiv and mult if
those won't be used?

drivers/media/i2c/ov2659.c: In function 'ov2659_pll_calc_params':
drivers/media/i2c/ov2659.c:912:35: warning: variable 's_mult' set but not used [-Wunused-but-set-variable]
  u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
                                   ^
drivers/media/i2c/ov2659.c:912:20: warning: variable 's_postdiv' set but not used [-Wunused-but-set-variable]
  u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
                    ^
drivers/media/i2c/ov2659.c:912:6: warning: variable 's_prediv' set but not used [-Wunused-but-set-variable]
  u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
      ^

This is likely some leftover from some past change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 6edffc7b74e3..49109f4f5bb4 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -909,7 +909,6 @@ static void ov2659_pll_calc_params(struct ov2659 *ov2659)
 	u8 ctrl1_reg = 0, ctrl2_reg = 0, ctrl3_reg = 0;
 	struct i2c_client *client = ov2659->client;
 	unsigned int desired = pdata->link_frequency;
-	u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
 	u32 prediv, postdiv, mult;
 	u32 bestdelta = -1;
 	u32 delta, actual;
@@ -929,9 +928,6 @@ static void ov2659_pll_calc_params(struct ov2659 *ov2659)
 
 				if ((delta < bestdelta) || (bestdelta == -1)) {
 					bestdelta = delta;
-					s_mult    = mult;
-					s_prediv  = prediv;
-					s_postdiv = postdiv;
 					ctrl1_reg = ctrl1[i].reg;
 					ctrl2_reg = mult;
 					ctrl3_reg = ctrl3[j].reg;
-- 
2.4.3

