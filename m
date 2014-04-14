Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbaDNJA5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:57 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id DC113209E8
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:53 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 08/21] smiapp: Make PLL (quirk) flags a function
Date: Mon, 14 Apr 2014 11:58:33 +0300
Message-Id: <1397465926-29724-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is more flexible. Quirk flags may be affected by configuration.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  | 4 ++--
 drivers/media/i2c/smiapp/smiapp-quirk.c | 7 ++++++-
 drivers/media/i2c/smiapp/smiapp-quirk.h | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 23f2c4d..02041cc 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2617,8 +2617,8 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
 	pll->csi2.lanes = sensor->platform_data->lanes;
 	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
-	if (sensor->minfo.quirk)
-		pll->flags = sensor->minfo.quirk->pll_flags;
+	pll->flags = smiapp_call_quirk(sensor, pll_flags);
+
 	/* Profile 0 sensors have no separate OP clock branch. */
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index bd2f8a7..e0bee87 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -220,12 +220,17 @@ static int jt8ev1_post_streamoff(struct smiapp_sensor *sensor)
 	return smiapp_write_8(sensor, 0x3328, 0x80);
 }
 
+static unsigned long jt8ev1_pll_flags(struct smiapp_sensor *sensor)
+{
+	return SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
+}
+
 const struct smiapp_quirk smiapp_jt8ev1_quirk = {
 	.limits = jt8ev1_limits,
 	.post_poweron = jt8ev1_post_poweron,
 	.pre_streamon = jt8ev1_pre_streamon,
 	.post_streamoff = jt8ev1_post_streamoff,
-	.pll_flags = SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE,
+	.pll_flags = jt8ev1_pll_flags,
 };
 
 static int tcm8500md_limits(struct smiapp_sensor *sensor)
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index ea8231c6..dddb62b 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -41,8 +41,8 @@ struct smiapp_quirk {
 	int (*post_poweron)(struct smiapp_sensor *sensor);
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
+	unsigned long (*pll_flags)(struct smiapp_sensor *sensor);
 	unsigned long flags;
-	unsigned long pll_flags;
 };
 
 #define SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY			(1 << 0)
-- 
1.8.3.2

