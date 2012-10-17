Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2JQLQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6997024pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:37 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/8] [media] s5p-mfc: Use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 17 Oct 2012 16:41:46 +0530
Message-Id: <1350472311-9748-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
as required by the common clock framework.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 367db75..f7c5c5a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -100,7 +100,7 @@ int s5p_mfc_clock_on(void)
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d", atomic_read(&clk_ref));
 #endif
-	ret = clk_enable(pm->clock_gate);
+	ret = clk_prepare_enable(pm->clock_gate);
 	return ret;
 }
 
@@ -110,7 +110,7 @@ void s5p_mfc_clock_off(void)
 	atomic_dec(&clk_ref);
 	mfc_debug(3, "- %d", atomic_read(&clk_ref));
 #endif
-	clk_disable(pm->clock_gate);
+	clk_disable_unprepare(pm->clock_gate);
 }
 
 int s5p_mfc_power_on(void)
-- 
1.7.4.1

