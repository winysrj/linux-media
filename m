Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58590 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752862AbdJUIhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 04:37:52 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thierry Reding <treding@nvidia.com>,
        linux-tegra@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tegra-cec: fix messy probe() cleanup
Message-ID: <001c8577-b77c-6a98-1efa-dc4902940873@xs4all.nl>
Date: Sat, 21 Oct 2017 10:37:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The probe() cleanup code ('goto foo_error') was very messy. It appears
that this code wasn't updated when I switched to the devm_ functions
in an earlier version.

Update the code to use 'return error' where it can and do proper cleanup
where it needs to.

Note that the original code wasn't buggy, it was just messy.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Since I already posted the pull request for this driver and since this is
just a cleanup I decided to do this as a separate patch on top of the pull
request code rather than merging this in the pull request.
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index b53743f555e8..807c94c70049 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -356,40 +356,34 @@ static int tegra_cec_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev,
 			"Unable to allocate resources for device\n");
-		ret = -EBUSY;
-		goto cec_error;
+		return -EBUSY;
 	}

 	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
 		pdev->name)) {
 		dev_err(&pdev->dev,
 			"Unable to request mem region for device\n");
-		ret = -EBUSY;
-		goto cec_error;
+		return -EBUSY;
 	}

 	cec->tegra_cec_irq = platform_get_irq(pdev, 0);

-	if (cec->tegra_cec_irq <= 0) {
-		ret = -EBUSY;
-		goto cec_error;
-	}
+	if (cec->tegra_cec_irq <= 0)
+		return -EBUSY;

 	cec->cec_base = devm_ioremap_nocache(&pdev->dev, res->start,
-		resource_size(res));
+					     resource_size(res));

 	if (!cec->cec_base) {
 		dev_err(&pdev->dev, "Unable to grab IOs for device\n");
-		ret = -EBUSY;
-		goto cec_error;
+		return -EBUSY;
 	}

 	cec->clk = devm_clk_get(&pdev->dev, "cec");

 	if (IS_ERR_OR_NULL(cec->clk)) {
 		dev_err(&pdev->dev, "Can't get clock for CEC\n");
-		ret = -ENOENT;
-		goto clk_error;
+		return -ENOENT;
 	}

 	clk_prepare_enable(cec->clk);
@@ -406,13 +400,13 @@ static int tegra_cec_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device\n");
-		goto cec_error;
+		goto clk_error;
 	}

 	cec->notifier = cec_notifier_get(&hdmi_dev->dev);
 	if (!cec->notifier) {
 		ret = -ENOMEM;
-		goto cec_error;
+		goto clk_error;
 	}

 	cec->adap = cec_allocate_adapter(&tegra_cec_ops, cec, TEGRA_CEC_NAME,
@@ -437,8 +431,8 @@ static int tegra_cec_probe(struct platform_device *pdev)
 	if (cec->notifier)
 		cec_notifier_put(cec->notifier);
 	cec_delete_adapter(cec->adap);
-	clk_disable_unprepare(cec->clk);
 clk_error:
+	clk_disable_unprepare(cec->clk);
 	return ret;
 }

-- 
2.14.1
