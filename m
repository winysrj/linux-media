Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21852 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdBTNjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:39:16 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v2 02/15] media: s5p-mfc: Use generic of_device_get_match_data
 helper
Date: Mon, 20 Feb 2017 14:38:51 +0100
Message-id: <1487597944-2000-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
References: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170220133911eucas1p17c0e5d66163593575edc5b8014aa9c30@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace custom code with generic helper to retrieve driver data.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 17 ++---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  4 ++--
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3e1f22eb4339..ad3d7377f40d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_reserved_mem.h>
 #include <media/videobuf2-v4l2.h>
 #include "s5p_mfc_common.h"
@@ -1157,8 +1158,6 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 	device_unregister(mfc_dev->mem_dev_r);
 }
 
-static void *mfc_get_drv_data(struct platform_device *pdev);
-
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1182,7 +1181,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->variant = mfc_get_drv_data(pdev);
+	dev->variant = of_device_get_match_data(&pdev->dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
@@ -1541,18 +1540,6 @@ static int s5p_mfc_resume(struct device *dev)
 };
 MODULE_DEVICE_TABLE(of, exynos_mfc_match);
 
-static void *mfc_get_drv_data(struct platform_device *pdev)
-{
-	struct s5p_mfc_variant *driver_data = NULL;
-	const struct of_device_id *match;
-
-	match = of_match_node(exynos_mfc_match, pdev->dev.of_node);
-	if (match)
-		driver_data = (struct s5p_mfc_variant *)match->data;
-
-	return driver_data;
-}
-
 static struct platform_driver s5p_mfc_driver = {
 	.probe		= s5p_mfc_probe,
 	.remove		= s5p_mfc_remove,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 3e0e8eaf8bfe..2f1387a4c386 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -192,7 +192,7 @@ struct s5p_mfc_buf {
  */
 struct s5p_mfc_pm {
 	struct clk	*clock_gate;
-	const char	**clk_names;
+	const char * const *clk_names;
 	struct clk	*clocks[MFC_MAX_CLOCKS];
 	int		num_clocks;
 	bool		use_clock_gating;
@@ -304,7 +304,7 @@ struct s5p_mfc_dev {
 	struct v4l2_ctrl_handler dec_ctrl_handler;
 	struct v4l2_ctrl_handler enc_ctrl_handler;
 	struct s5p_mfc_pm	pm;
-	struct s5p_mfc_variant	*variant;
+	const struct s5p_mfc_variant	*variant;
 	int num_inst;
 	spinlock_t irqlock;	/* lock when operating on context */
 	spinlock_t condlock;	/* lock when changing/checking if a context is
-- 
1.9.1
