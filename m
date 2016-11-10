Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35062 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932267AbcKJKbl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:31:41 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 4/4] s5p-mfc: Use clock gating only on MFC v5 hardware
Date: Thu, 10 Nov 2016 11:31:23 +0100
Message-id: <1478773883-12083-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
References: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161110103136eucas1p2c55d1177fcc97c5dbf1bc650e88d72ce@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer MFC hardware have internal clock gating feature, so additional
software-triggered clock gating sometimes causes misbehavior of the MFC
firmware and results in freeze or crash. This patch changes the driver
to use software-triggered clock gating only when working with v5 MFC
hardware, where it has been proven to work properly.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 17 +++++++++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 994a27b..7d39359 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1441,6 +1441,7 @@ static int s5p_mfc_runtime_resume(struct device *dev)
 	.buf_size	= &buf_size_v5,
 	.buf_align	= &mfc_buf_align_v5,
 	.fw_name[0]	= "s5p-mfc.fw",
+	.use_clock_gating = true,
 };
 
 static struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 46b99f2..c068ee3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -199,6 +199,7 @@ struct s5p_mfc_buf {
 struct s5p_mfc_pm {
 	struct clk	*clock;
 	struct clk	*clock_gate;
+	bool		use_clock_gating;
 	atomic_t	power;
 	struct device	*device;
 };
@@ -235,6 +236,7 @@ struct s5p_mfc_variant {
 	struct s5p_mfc_buf_size *buf_size;
 	struct s5p_mfc_buf_align *buf_align;
 	char	*fw_name[MFC_FW_MAX_VERSIONS];
+	bool		use_clock_gating;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 930dc2d..b5806ab 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -37,6 +37,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 
 	pm = &dev->pm;
 	p_dev = dev;
+	pm->use_clock_gating = dev->variant->use_clock_gating;
 	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
 	if (IS_ERR(pm->clock_gate)) {
 		mfc_err("Failed to get clock-gating control\n");
@@ -108,6 +109,8 @@ int s5p_mfc_clock_on(void)
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
 #endif
+	if (!pm->use_clock_gating)
+		return 0;
 	if (!IS_ERR_OR_NULL(pm->clock_gate))
 		ret = clk_enable(pm->clock_gate);
 	return ret;
@@ -119,22 +122,32 @@ void s5p_mfc_clock_off(void)
 	atomic_dec(&clk_ref);
 	mfc_debug(3, "- %d\n", atomic_read(&clk_ref));
 #endif
+	if (!pm->use_clock_gating)
+		return;
 	if (!IS_ERR_OR_NULL(pm->clock_gate))
 		clk_disable(pm->clock_gate);
 }
 
 int s5p_mfc_power_on(void)
 {
+	int ret = 0;
+
 #ifdef CONFIG_PM
-	return pm_runtime_get_sync(pm->device);
+	ret = pm_runtime_get_sync(pm->device);
+	if (ret)
+		return ret;
 #else
 	atomic_set(&pm->power, 1);
-	return 0;
 #endif
+	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
+		ret = clk_enable(pm->clock_gate);
+	return ret;
 }
 
 int s5p_mfc_power_off(void)
 {
+	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
+		clk_disable(pm->clock_gate);
 #ifdef CONFIG_PM
 	return pm_runtime_put_sync(pm->device);
 #else
-- 
1.9.1

