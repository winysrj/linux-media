Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934297AbaDITY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:24:56 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id CFFB820E92
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/17] smiapp: Make PLL flags separate from regular quirk flags
Date: Wed,  9 Apr 2014 22:24:54 +0300
Message-Id: <1397071509-2071-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't make sense to just copy the information to the PLL flags. Add a
new fields for the quirks to contain the PLL flags.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  | 5 ++---
 drivers/media/i2c/smiapp/smiapp-quirk.c | 2 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h | 5 ++---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 69c11ec..23f2c4d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2617,12 +2617,11 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
 	pll->csi2.lanes = sensor->platform_data->lanes;
 	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
+	if (sensor->minfo.quirk)
+		pll->flags = sensor->minfo.quirk->pll_flags;
 	/* Profile 0 sensors have no separate OP clock branch. */
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
-	if (smiapp_needs_quirk(sensor,
-			       SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE))
-		pll->flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 
 	rval = smiapp_update_mode(sensor);
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index bb8c506..c7f5194 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -271,7 +271,7 @@ const struct smiapp_quirk smiapp_jt8ev1_quirk = {
 	.post_poweron = jt8ev1_post_poweron,
 	.pre_streamon = jt8ev1_pre_streamon,
 	.post_streamoff = jt8ev1_post_streamoff,
-	.flags = SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE,
+	.pll_flags = SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE,
 };
 
 static int tcm8500md_limits(struct smiapp_sensor *sensor)
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 504a6d8..bc9d28c 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -43,11 +43,10 @@ struct smiapp_quirk {
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
 	const struct smia_reg *regs;
 	unsigned long flags;
+	unsigned long pll_flags;
 };
 
-/* op pix clock is for all lanes in total normally */
-#define SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
-#define SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY			(1 << 1)
+#define SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY			(1 << 0)
 
 struct smiapp_reg_8 {
 	u16 reg;
-- 
1.8.3.2

