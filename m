Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43193 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbeEZO24 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 10:28:56 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: staging: tegra-vde: Reset memory client
Date: Sat, 26 May 2018 17:27:55 +0300
Message-Id: <20180526142755.22966-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DMA requests must be blocked before resetting VDE HW, otherwise it is
possible to get a memory corruption or a machine hang. Use the reset
control provided by the Memory Controller to block DMA before resetting
the VDE HW.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---

Changelog:

v2:
	- Reset HW even if Memory Client resetting fails.

 drivers/staging/media/tegra-vde/tegra-vde.c | 35 +++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 90177a59b97c..6f06061a40d9 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -73,6 +73,7 @@ struct tegra_vde {
 	struct mutex lock;
 	struct miscdevice miscdev;
 	struct reset_control *rst;
+	struct reset_control *rst_mc;
 	struct gen_pool *iram_pool;
 	struct completion decode_completion;
 	struct clk *clk;
@@ -850,9 +851,23 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	 * We rely on the VDE registers reset value, otherwise VDE
 	 * causes bus lockup.
 	 */
+	ret = reset_control_assert(vde->rst_mc);
+	if (ret) {
+		dev_err(dev, "DEC start: Failed to assert MC reset: %d\n",
+			ret);
+		goto put_runtime_pm;
+	}
+
 	ret = reset_control_reset(vde->rst);
 	if (ret) {
-		dev_err(dev, "Failed to reset HW: %d\n", ret);
+		dev_err(dev, "DEC start: Failed to reset HW: %d\n", ret);
+		goto put_runtime_pm;
+	}
+
+	ret = reset_control_deassert(vde->rst_mc);
+	if (ret) {
+		dev_err(dev, "DEC start: Failed to deassert MC reset: %d\n",
+			ret);
 		goto put_runtime_pm;
 	}
 
@@ -880,9 +895,18 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 		ret = timeout;
 	}
 
+	/*
+	 * At first reset memory client to avoid resetting VDE HW in the
+	 * middle of DMA which could result into memory corruption or hang
+	 * the whole system.
+	 */
+	err = reset_control_assert(vde->rst_mc);
+	if (err)
+		dev_err(dev, "DEC end: Failed to assert MC reset: %d\n", err);
+
 	err = reset_control_assert(vde->rst);
 	if (err)
-		dev_err(dev, "Failed to assert HW reset: %d\n", err);
+		dev_err(dev, "DEC end: Failed to assert HW reset: %d\n", err);
 
 put_runtime_pm:
 	pm_runtime_mark_last_busy(dev);
@@ -1074,6 +1098,13 @@ static int tegra_vde_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	vde->rst_mc = devm_reset_control_get_optional(dev, "mc");
+	if (IS_ERR(vde->rst_mc)) {
+		err = PTR_ERR(vde->rst_mc);
+		dev_err(dev, "Could not get MC reset %d\n", err);
+		return err;
+	}
+
 	irq = platform_get_irq_byname(pdev, "sync-token");
 	if (irq < 0)
 		return irq;
-- 
2.17.0
