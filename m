Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaJHIrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 04:47:16 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400KKPB2JQU80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 17:47:07 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Cc: s.nawrocki@samsung.com
Subject: [PATCH 2/3] exynos4-is: Add support for asynchronous sub-devices power
 on
Date: Wed, 08 Oct 2014 10:46:52 +0200
Message-id: <1412758013-23608-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1412758013-23608-1-git-send-email-j.anaszewski@samsung.com>
References: <1412758013-23608-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Schedule sub-devices power up in separate thread to speed up video device
open and to allow some ioctls, like VIDIOC_REQBUFS to be run in parallel.

We synchronize with completion of the power up sequence before starting
streaming on subdevices, as they require to be powered up before being
starting streaming.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   19 +++++++++++++++----
 include/media/exynos-fimc.h                   |    2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 344718d..c867c46 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -10,6 +10,7 @@
  * or (at your option) any later version.
  */
 
+#include <linux/async.h>
 #include <linux/bug.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
@@ -186,6 +187,13 @@ error:
 	return ret;
 }
 
+static void __fimc_pipeline_power_async(void *data, async_cookie_t cookie)
+{
+	struct fimc_pipeline *p = data;
+
+	WARN_ON(fimc_pipeline_s_power(p, true) < 0);
+}
+
 /**
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
@@ -219,14 +227,13 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 			return ret;
 	}
 
-	ret = fimc_pipeline_s_power(p, 1);
-	if (!ret)
-		return 0;
+	async_schedule_domain(__fimc_pipeline_power_async, p,
+					&ep->async_domain);
 
 	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
 		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -275,6 +282,9 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENODEV;
 
+	/* Wait until all devices in the chain are powered up */
+	async_synchronize_full_domain(&ep->async_domain);
+
 	for (i = 0; i < IDX_MAX; i++) {
 		unsigned int idx = seq[on][i];
 
@@ -309,6 +319,7 @@ static struct exynos_media_pipeline *fimc_md_pipeline_create(
 		return NULL;
 
 	list_add_tail(&p->list, &fmd->pipelines);
+	async_domain_init_exclusive(&p->ep.async_domain);
 
 	p->ep.ops = &fimc_pipeline_ops;
 	return &p->ep;
diff --git a/include/media/exynos-fimc.h b/include/media/exynos-fimc.h
index aa44660..ed779de 100644
--- a/include/media/exynos-fimc.h
+++ b/include/media/exynos-fimc.h
@@ -12,6 +12,7 @@
 #ifndef S5P_FIMC_H_
 #define S5P_FIMC_H_
 
+#include <linux/async.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
@@ -146,6 +147,7 @@ struct exynos_video_entity {
 struct exynos_media_pipeline {
 	struct media_pipeline mp;
 	const struct exynos_media_pipeline_ops *ops;
+	struct async_domain async_domain;
 };
 
 static inline struct exynos_video_entity *vdev_to_exynos_video_entity(
-- 
1.7.9.5

