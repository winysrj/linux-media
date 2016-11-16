Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64098 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934742AbcKPJFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:31 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6/9] s5p-mfc: Kill all IS_ERR_OR_NULL in clocks management code
Date: Wed, 16 Nov 2016 10:04:55 +0100
Message-id: <1479287098-30493-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090520eucas1p1014c941bfe4fbe11392f8d9028e6f4f1@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After commit "s5p-mfc: Fix clock management in s5p_mfc_release function"
all clocks related functions are called only when MFC device is really
available, so there is no additional check needed for NULL
gate clocks. This patch simplifies the code and kills IS_ERR_OR_NULL
macro usage.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 11a918eb7564..b514584cf00d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -91,16 +91,12 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 
 int s5p_mfc_clock_on(void)
 {
-	int ret = 0;
-
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
 
 	if (!pm->use_clock_gating)
 		return 0;
-	if (!IS_ERR_OR_NULL(pm->clock_gate))
-		ret = clk_enable(pm->clock_gate);
-	return ret;
+	return clk_enable(pm->clock_gate);
 }
 
 void s5p_mfc_clock_off(void)
@@ -110,8 +106,7 @@ void s5p_mfc_clock_off(void)
 
 	if (!pm->use_clock_gating)
 		return;
-	if (!IS_ERR_OR_NULL(pm->clock_gate))
-		clk_disable(pm->clock_gate);
+	clk_disable(pm->clock_gate);
 }
 
 int s5p_mfc_power_on(void)
@@ -122,14 +117,14 @@ int s5p_mfc_power_on(void)
 	if (ret)
 		return ret;
 
-	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
+	if (!pm->use_clock_gating)
 		ret = clk_enable(pm->clock_gate);
 	return ret;
 }
 
 int s5p_mfc_power_off(void)
 {
-	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
+	if (!pm->use_clock_gating)
 		clk_disable(pm->clock_gate);
 	return pm_runtime_put_sync(pm->device);
 }
-- 
1.9.1

