Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52662 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbeCOJak (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:30:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id t3so9059550wmc.2
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:30:39 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: mchehab@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 1/2] cec: stm32: simplify clock management
Date: Thu, 15 Mar 2018 10:29:48 +0100
Message-Id: <20180315092949.9895-2-benjamin.gaignard@st.com>
In-Reply-To: <20180315092949.9895-1-benjamin.gaignard@st.com>
References: <20180315092949.9895-1-benjamin.gaignard@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Since CEC framework enable and disable the adapter when it is needed
just follow it orders to enable/disable the clocks.
Call stm32_cec_hw_init() when the adapter is enabled and do not let
regmap manage registers clock help to simplify clocking scheme.

While reworking cec clock start using pm_runtime.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/media/platform/stm32/stm32-cec.c | 70 ++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
index 7c496bc1cf38..35cc2ffd6b96 100644
--- a/drivers/media/platform/stm32/stm32-cec.c
+++ b/drivers/media/platform/stm32/stm32-cec.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 
 #include <media/cec.h>
@@ -70,7 +71,7 @@ struct stm32_cec {
 	int			tx_cnt;
 };
 
-static void cec_hw_init(struct stm32_cec *cec)
+static void stm32_cec_hw_init(struct stm32_cec *cec)
 {
 	regmap_update_bits(cec->regmap, CEC_CR, TXEOM | TXSOM | CECEN, 0);
 
@@ -166,22 +167,17 @@ static irqreturn_t stm32_cec_irq_handler(int irq, void *arg)
 static int stm32_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
 	struct stm32_cec *cec = adap->priv;
-	int ret = 0;
 
 	if (enable) {
-		ret = clk_enable(cec->clk_cec);
-		if (ret)
-			dev_err(cec->dev, "fail to enable cec clock\n");
-
-		clk_enable(cec->clk_hdmi_cec);
+		pm_runtime_get_sync(cec->dev);
+		stm32_cec_hw_init(cec);
 		regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
 	} else {
-		clk_disable(cec->clk_cec);
-		clk_disable(cec->clk_hdmi_cec);
 		regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
+		pm_runtime_disable(cec->dev);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
@@ -260,8 +256,8 @@ static int stm32_cec_probe(struct platform_device *pdev)
 	if (IS_ERR(mmio))
 		return PTR_ERR(mmio);
 
-	cec->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "cec", mmio,
-						&stm32_cec_regmap_cfg);
+	cec->regmap = devm_regmap_init_mmio(&pdev->dev, mmio,
+					    &stm32_cec_regmap_cfg);
 
 	if (IS_ERR(cec->regmap))
 		return PTR_ERR(cec->regmap);
@@ -284,19 +280,10 @@ static int stm32_cec_probe(struct platform_device *pdev)
 		return PTR_ERR(cec->clk_cec);
 	}
 
-	ret = clk_prepare(cec->clk_cec);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to prepare cec clock\n");
-		return ret;
-	}
-
 	cec->clk_hdmi_cec = devm_clk_get(&pdev->dev, "hdmi-cec");
-	if (!IS_ERR(cec->clk_hdmi_cec)) {
-		ret = clk_prepare(cec->clk_hdmi_cec);
-		if (ret) {
-			dev_err(&pdev->dev, "Unable to prepare hdmi-cec clock\n");
-			return ret;
-		}
+	if (IS_ERR(cec->clk_hdmi_cec)) {
+		dev_err(&pdev->dev, "Cannot get cec clock\n");
+		return PTR_ERR(cec->clk_hdmi_cec);
 	}
 
 	/*
@@ -315,24 +302,46 @@ static int stm32_cec_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	cec_hw_init(cec);
-
 	platform_set_drvdata(pdev, cec);
+	pm_runtime_enable(&pdev->dev);
 
-	return 0;
+	return ret;
 }
 
 static int stm32_cec_remove(struct platform_device *pdev)
 {
 	struct stm32_cec *cec = platform_get_drvdata(pdev);
 
-	clk_unprepare(cec->clk_cec);
-	clk_unprepare(cec->clk_hdmi_cec);
-
 	cec_unregister_adapter(cec->adap);
 
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
+static int __maybe_unused stm32_cec_runtime_suspend(struct device *dev)
+{
+	struct stm32_cec *cec = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(cec->clk_cec);
+	clk_disable_unprepare(cec->clk_hdmi_cec);
+
+	return 0;
+}
+
+static int __maybe_unused stm32_cec_runtime_resume(struct device *dev)
+{
+	struct stm32_cec *cec = dev_get_drvdata(dev);
+
+	clk_prepare_enable(cec->clk_cec);
+	clk_prepare_enable(cec->clk_hdmi_cec);
+
+	return 0;
+}
+
+static const struct dev_pm_ops stm32_cec_pm_ops = {
+	SET_RUNTIME_PM_OPS(stm32_cec_runtime_suspend, stm32_cec_runtime_resume,
+			   NULL)
+};
 
 static const struct of_device_id stm32_cec_of_match[] = {
 	{ .compatible = "st,stm32-cec" },
@@ -346,6 +355,7 @@ static struct platform_driver stm32_cec_driver = {
 	.driver = {
 		.name		= CEC_NAME,
 		.of_match_table = stm32_cec_of_match,
+		.pm = &stm32_cec_pm_ops,
 	},
 };
 
-- 
2.15.0
