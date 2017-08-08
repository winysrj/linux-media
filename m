Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44181 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752125AbdHHLYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:04 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] [media] exynos4-is: constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:31 +0200
Message-Id: <1502189912-28794-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev_ops structures are only passed as the second
argument of v4l2_subdev_init, which is const, so the
v4l2_subdev_ops structures can be const as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/exynos4-is/fimc-isp.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 8efe916..fd793d3 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -433,7 +433,7 @@ static void fimc_isp_subdev_unregistered(struct v4l2_subdev *sd)
 	.s_power = fimc_isp_subdev_s_power,
 };
 
-static struct v4l2_subdev_ops fimc_is_subdev_ops = {
+static const struct v4l2_subdev_ops fimc_is_subdev_ops = {
 	.core = &fimc_is_core_ops,
 	.video = &fimc_is_subdev_video_ops,
 	.pad = &fimc_is_subdev_pad_ops,
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 7d3ec5c..30282c5 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1361,7 +1361,7 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	.log_status = fimc_lite_log_status,
 };
 
-static struct v4l2_subdev_ops fimc_lite_subdev_ops = {
+static const struct v4l2_subdev_ops fimc_lite_subdev_ops = {
 	.core = &fimc_lite_core_ops,
 	.video = &fimc_lite_subdev_video_ops,
 	.pad = &fimc_lite_subdev_pad_ops,
