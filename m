Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60950 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 04/12] [media] tc358743: fix set_pll to enable PLL with default frequency
Date: Mon, 30 Mar 2015 13:10:48 +0200
Message-Id: <1427713856-10240-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

set_pll not only skips PLL changes but also doesn't enable it in the
first place if the rate is the same as the default values.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 85a0f7a..dd2ea16 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -606,6 +606,7 @@ static void tc358743_set_pll(struct v4l2_subdev *sd)
 	struct tc358743_state *state = to_state(sd);
 	struct tc358743_platform_data *pdata = &state->pdata;
 	u16 pllctl0 = i2c_rd16(sd, PLLCTL0);
+	u16 pllctl1 = i2c_rd16(sd, PLLCTL1);
 	u16 pllctl0_new = SET_PLL_PRD(pdata->pll_prd) |
 		SET_PLL_FBD(pdata->pll_fbd);
 
@@ -613,8 +614,8 @@ static void tc358743_set_pll(struct v4l2_subdev *sd)
 
 	/* Only rewrite when needed, since rewriting triggers another format
 	 * change event. */
-	if (pllctl0 != pllctl0_new) {
-		u32 hsck = (pdata->refclk_hz * pdata->pll_prd) / pdata->pll_fbd;
+	if ((pllctl0 != pllctl0_new) || ((pllctl1 & MASK_PLL_EN) == 0)) {
+		u32 hsck = (pdata->refclk_hz * pdata->pll_fbd) / pdata->pll_prd;
 		u16 pll_frs;
 
 		if (hsck > 500000000)
-- 
2.1.4

