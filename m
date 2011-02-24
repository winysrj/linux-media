Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38863 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1BXOjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:39:32 -0500
Date: Thu, 24 Feb 2011 15:33:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/7] s5p-fimc: Allow defining number of sensors at runtime
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1298558034-10768-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add num_clients field to struct s5p_fimc_isp_info to define exactly
size of clients array which simplifies a bit the sensors management.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 ++++++-----
 drivers/media/video/s5p-fimc/fimc-core.c    |   22 ++++++++--------------
 include/media/s5p_fimc.h                    |    7 +++----
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 9aa767e..3d717f9 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -91,7 +91,7 @@ static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 	struct v4l2_subdev *sd;
 	int i;
 
-	for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i) {
+	for (i = 0; i < pdata->num_clients; ++i) {
 		isp_info = pdata->isp_info[i];
 
 		if (!isp_info || (index >= 0 && i != index))
@@ -116,12 +116,13 @@ static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 static int fimc_isp_subdev_init(struct fimc_dev *fimc, unsigned int index)
 {
 	struct s5p_fimc_isp_info *isp_info;
+	struct s5p_platform_fimc *pdata = fimc->pdata;
 	int ret;
 
-	if (index >= FIMC_MAX_CAMIF_CLIENTS)
+	if (index >= pdata->num_clients)
 		return -EINVAL;
 
-	isp_info = fimc->pdata->isp_info[index];
+	isp_info = pdata->isp_info[index];
 	if (!isp_info)
 		return -EINVAL;
 
@@ -564,7 +565,7 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 	struct s5p_platform_fimc *pldata = ctx->fimc_dev->pdata;
 	struct s5p_fimc_isp_info *isp_info;
 
-	if (i->index >= FIMC_MAX_CAMIF_CLIENTS)
+	if (i->index >= pldata->num_clients)
 		return -EINVAL;
 
 	isp_info = pldata->isp_info[i->index];
@@ -586,7 +587,7 @@ static int fimc_cap_s_input(struct file *file, void *priv,
 	if (fimc_capture_active(ctx->fimc_dev))
 		return -EBUSY;
 
-	if (i >= FIMC_MAX_CAMIF_CLIENTS || !pdata->isp_info[i])
+	if (i >= pdata->num_clients || !pdata->isp_info[i])
 		return -EINVAL;
 
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index f20e286..1ad9bc6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1578,6 +1578,7 @@ static int fimc_probe(struct platform_device *pdev)
 	struct fimc_dev *fimc;
 	struct resource *res;
 	struct samsung_fimc_driverdata *drv_data;
+	struct s5p_platform_fimc *pdata;
 	int ret = 0;
 	int cap_input_index = -1;
 
@@ -1599,7 +1600,8 @@ static int fimc_probe(struct platform_device *pdev)
 	fimc->id = pdev->id;
 	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
-	fimc->pdata = pdev->dev.platform_data;
+	pdata = pdev->dev.platform_data;
+	fimc->pdata = pdata;
 	fimc->state = ST_IDLE;
 
 	init_waitqueue_head(&fimc->irq_queue);
@@ -1630,19 +1632,11 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 
 	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
-	/*
-	 * Check if vide capture node needs to be registered for this device
-	 * instance.
-	 */
-	if (fimc->pdata) {
-		int i;
-		for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i)
-			if (fimc->pdata->isp_info[i])
-				break;
-		if (i < FIMC_MAX_CAMIF_CLIENTS) {
-			cap_input_index = i;
-			fimc->num_clocks++;
-		}
+
+	/* Check if a video capture node needs to be registered. */
+	if (pdata && pdata->num_clients >= 1 && pdata->isp_info[0]) {
+		cap_input_index = 0;
+		fimc->num_clocks++;
 	}
 
 	ret = fimc_clk_get(fimc);
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 0d457ca..96cd6fc 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -46,15 +46,14 @@ struct s5p_fimc_isp_info {
 	u16 flags;
 };
 
-
-#define FIMC_MAX_CAMIF_CLIENTS	2
-
 /**
  * struct s5p_platform_fimc - camera host interface platform data
  *
  * @isp_info: properties of camera sensor required for host interface setup
+ * @num_clients: the number of attached image sensors
  */
 struct s5p_platform_fimc {
-	struct s5p_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
+	struct s5p_fimc_isp_info **isp_info;
+	int num_clients;
 };
 #endif /* S5P_FIMC_H_ */
-- 
1.7.4.1
