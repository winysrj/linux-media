Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:45342 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753088AbeDSOHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:07:01 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 26/61] media: platform: exynos4-is: simplify getting .drvdata
Date: Thu, 19 Apr 2018 16:05:56 +0200
Message-Id: <20180419140641.27926-27-wsa+renesas@sang-engineering.com>
In-Reply-To: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
References: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should get drvdata from struct device directly. Going via
platform_device is an unneeded step back and forth.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Build tested only. buildbot is happy. Please apply individually.

 drivers/media/platform/exynos4-is/media-dev.c | 6 ++----
 drivers/media/platform/exynos4-is/mipi-csis.c | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 78b48a1fa26c..deb499f76412 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1201,8 +1201,7 @@ static const struct media_device_ops fimc_md_ops = {
 static ssize_t fimc_md_sysfs_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct fimc_md *fmd = platform_get_drvdata(pdev);
+	struct fimc_md *fmd = dev_get_drvdata(dev);
 
 	if (fmd->user_subdev_api)
 		return strlcpy(buf, "Sub-device API (sub-dev)\n", PAGE_SIZE);
@@ -1214,8 +1213,7 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct fimc_md *fmd = platform_get_drvdata(pdev);
+	struct fimc_md *fmd = dev_get_drvdata(dev);
 	bool subdev_api;
 	int i;
 
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index cba46a656338..b4e28a299e26 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -891,8 +891,7 @@ static int s5pcsis_probe(struct platform_device *pdev)
 
 static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct csis_state *state = sd_to_csis_state(sd);
 	int ret = 0;
 
@@ -921,8 +920,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 
 static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct csis_state *state = sd_to_csis_state(sd);
 	int ret = 0;
 
-- 
2.11.0
