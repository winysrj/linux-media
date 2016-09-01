Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:44181 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755066AbcIALjh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:39:37 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, wsa@the-dreams.de,
        b.zolnierkie@samsung.com, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] exynos4-is: Clear isp-i2c adapter power.ignore_children
 flag
Date: Thu, 01 Sep 2016 13:39:16 +0200
Message-id: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 04f59143b571161d25315dd52d7a2ecc022cb71a
("i2c: let I2C masters ignore their children for PM")
the power.ignore_children flag is set when registering an I2C
adapter. Since I2C transfers are not managed by the fimc-isp-i2c
driver its clients use pm_runtime_* calls directly to communicate
required power state of the bus controller.
However when the power.ignore_children flag is set that doesn't
work, so clear that flag back after registering the adapter.
While at it drop pm_runtime_enable() call on the i2c_adapter
as it is already done by the I2C subsystem when registering
I2C adapter.

Cc: <stable@vger.kernel.org> # 4.7+
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 7521aa5..03b4246 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -55,26 +55,37 @@ static int fimc_is_i2c_probe(struct platform_device *pdev)
 	i2c_adap->algo = &fimc_is_i2c_algorithm;
 	i2c_adap->class = I2C_CLASS_SPD;
 
+	platform_set_drvdata(pdev, isp_i2c);
+	pm_runtime_enable(&pdev->dev);
+
 	ret = i2c_add_adapter(i2c_adap);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add I2C bus %s\n",
 						node->full_name);
-		return ret;
+		goto err_pm_dis;
 	}
 
-	platform_set_drvdata(pdev, isp_i2c);
-
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_enable(&i2c_adap->dev);
-
+	/*
+	 * Client drivers of this adapter don't do any I2C transfers as that
+	 * is handled by the ISP firmware.  But we rely on the runtime PM
+	 * state propagation from the clients up to the adapter driver so
+	 * clear the ignore_children flags here.  PM rutnime calls are not
+	 * used in probe() handler of clients of this adapter so there is
+	 * no issues with clearing the flag right after registering the I2C
+	 * adapter.
+	 */
+	pm_suspend_ignore_children(&i2c_adap->dev, false);
 	return 0;
+
+err_pm_dis:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static int fimc_is_i2c_remove(struct platform_device *pdev)
 {
 	struct fimc_is_i2c *isp_i2c = platform_get_drvdata(pdev);
 
-	pm_runtime_disable(&isp_i2c->adapter.dev);
 	pm_runtime_disable(&pdev->dev);
 	i2c_del_adapter(&isp_i2c->adapter);
 
-- 
1.9.1

