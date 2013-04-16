Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:49437 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3DPGOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:14:42 -0400
Received: by mail-da0-f50.google.com with SMTP id t1so93341dae.9
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:14:41 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/5] [media] exynos4-is: Convert index variable to signed
Date: Tue, 16 Apr 2013 11:32:20 +0530
Message-Id: <1366092143-5482-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
References: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

index variable is used to check the validity of the data by
testing for negative values. Hence make it signed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-core.h |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index d2fe162..953b074 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -425,7 +425,7 @@ struct fimc_dev {
 	struct regmap			*sysreg;
 	const struct fimc_variant	*variant;
 	const struct fimc_drvdata	*drv_data;
-	u16				id;
+	int				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 71fed51..47da5e0 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -140,7 +140,7 @@ struct fimc_lite {
 	struct v4l2_subdev	*sensor;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl	*test_pattern;
-	u32			index;
+	int			index;
 	struct fimc_pipeline	pipeline;
 	const struct fimc_pipeline_ops *pipeline_ops;
 
-- 
1.7.9.5

