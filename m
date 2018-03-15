Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34205 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbeCOJam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:30:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id a20so22215151wmd.1
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:30:41 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: mchehab@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 2/2] cec: stm32: add suspend/resume functions
Date: Thu, 15 Mar 2018 10:29:49 +0100
Message-Id: <20180315092949.9895-3-benjamin.gaignard@st.com>
In-Reply-To: <20180315092949.9895-1-benjamin.gaignard@st.com>
References: <20180315092949.9895-1-benjamin.gaignard@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

If wake up irq is defined in device-tree cec adapter
could be used has wake up source.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/media/platform/stm32/stm32-cec.c | 44 +++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
index 35cc2ffd6b96..68e18ee6655b 100644
--- a/drivers/media/platform/stm32/stm32-cec.c
+++ b/drivers/media/platform/stm32/stm32-cec.c
@@ -11,8 +11,11 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 
 #include <media/cec.h>
@@ -243,7 +246,7 @@ static int stm32_cec_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct stm32_cec *cec;
 	void __iomem *mmio;
-	int ret;
+	int ret, wakeirq;
 
 	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
 	if (!cec)
@@ -274,6 +277,12 @@ static int stm32_cec_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	wakeirq = of_irq_get_byname(pdev->dev.of_node, "wakeup");
+	if (wakeirq > 0) {
+		device_init_wakeup(&pdev->dev, true);
+		dev_pm_set_dedicated_wake_irq(&pdev->dev, wakeirq);
+	}
+
 	cec->clk_cec = devm_clk_get(&pdev->dev, "cec");
 	if (IS_ERR(cec->clk_cec)) {
 		dev_err(&pdev->dev, "Cannot get cec clock\n");
@@ -312,12 +321,44 @@ static int stm32_cec_remove(struct platform_device *pdev)
 {
 	struct stm32_cec *cec = platform_get_drvdata(pdev);
 
+	dev_pm_clear_wake_irq(&pdev->dev);
+	device_init_wakeup(&pdev->dev, false);
+
 	cec_unregister_adapter(cec->adap);
 
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
+
+static int __maybe_unused stm32_cec_suspend(struct device *dev)
+{
+	struct stm32_cec *cec = dev_get_drvdata(dev);
+
+	pm_runtime_force_suspend(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(cec->irq);
+
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+
+static int __maybe_unused stm32_cec_resume(struct device *dev)
+{
+	struct stm32_cec *cec = dev_get_drvdata(dev);
+
+	pinctrl_pm_select_default_state(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(cec->irq);
+
+	pm_runtime_force_resume(dev);
+
+	return 0;
+}
+
 static int __maybe_unused stm32_cec_runtime_suspend(struct device *dev)
 {
 	struct stm32_cec *cec = dev_get_drvdata(dev);
@@ -341,6 +382,7 @@ static int __maybe_unused stm32_cec_runtime_resume(struct device *dev)
 static const struct dev_pm_ops stm32_cec_pm_ops = {
 	SET_RUNTIME_PM_OPS(stm32_cec_runtime_suspend, stm32_cec_runtime_resume,
 			   NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(stm32_cec_suspend, stm32_cec_resume)
 };
 
 static const struct of_device_id stm32_cec_of_match[] = {
-- 
2.15.0
