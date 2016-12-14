Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33067 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbcLNEK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 23:10:57 -0500
Received: by mail-pg0-f66.google.com with SMTP id 3so948995pgd.0
        for <linux-media@vger.kernel.org>; Tue, 13 Dec 2016 20:10:57 -0800 (PST)
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, mchehab@kernel.org, kgene@kernel.org,
        krzk@kernel.org, javier@osg.samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: platform: exynos4-is: constify v4l2_subdev_ops strcutures
Date: Wed, 14 Dec 2016 09:25:47 +0530
Message-Id: <1481687747-28785-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for v4l2_subdev_ops structures that are only passed as an
argument to the function v4l2_subdev_init. This argument is of type
const, so v4l2_subdev_ops structures having this property can also  be
declared const.
Done using Coccinelle:

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
@@
v4l2_subdev_init(...,&i@p)

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_ops i;

Before and after size details:

   text	   data	    bss	    dec	    hex	filename
   6743	    152	     20	   6915	   1b03	platform/exynos4-is/fimc-isp.o
   6807	     88	     20	   6915	   1b03	platform/exynos4-is/fimc-isp.o

  15653	    392	     36	  16081	   3ed1	platform/exynos4-is/fimc-lite.o
  15717	    308	     36	  16061	   3ebd	platform/exynos4-is/fimc-lite.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c  | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c | 2 +-
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
index b91abf1..18b6aaa 100644
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
-- 
1.9.1

