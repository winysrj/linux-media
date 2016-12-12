Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36462 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbcLLSEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 13:04:43 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, mchehab@kernel.org, kgene@kernel.org,
        krzk@kernel.org, javier@osg.samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: platform: exynos4-is: constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 23:33:57 +0530
Message-Id: <1481565837-20467-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_{core/pad/video}_ops structures are stored in the
fields of the v4l2_subdev_ops structure which are of type const.
Also, v4l2_subdev_ops structure is passed to a function
having its argument of type const. As these structures are never
modified, so declare them as const.
Done using Coccinelle:(one of the scripts used)

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
expression e1;
@@
v4l2_subdev_init(e1,&i@p)

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

File size before:
   text	   data	    bss	    dec	    hex	filename
  16830	   1064	      0	  17894	   45e6 platform/exynos4-is/fimc-capture.o
   7787	    704	     20	   8511	   213f platform/exynos4-is/mipi-csis.o

File size after:
   text	   data	    bss	    dec	    hex	filename
  17022	    880	      0	  17902	   45ee platform/exynos4-is/fimc-capture.o
   8299	    192	     20	   8511	   213f platform/exynos4-is/mipi-csis.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c | 4 ++--
 drivers/media/platform/exynos4-is/mipi-csis.c    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 964f4a6..a5e729c 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1695,7 +1695,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops fimc_subdev_pad_ops = {
+static const struct v4l2_subdev_pad_ops fimc_subdev_pad_ops = {
 	.enum_mbus_code = fimc_subdev_enum_mbus_code,
 	.get_selection = fimc_subdev_get_selection,
 	.set_selection = fimc_subdev_set_selection,
@@ -1703,7 +1703,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	.set_fmt = fimc_subdev_set_fmt,
 };
 
-static struct v4l2_subdev_ops fimc_subdev_ops = {
+static const struct v4l2_subdev_ops fimc_subdev_ops = {
 	.pad = &fimc_subdev_pad_ops,
 };
 
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index befd9fc..f819b29 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -649,23 +649,23 @@ static int s5pcsis_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static struct v4l2_subdev_core_ops s5pcsis_core_ops = {
+static const struct v4l2_subdev_core_ops s5pcsis_core_ops = {
 	.s_power = s5pcsis_s_power,
 	.log_status = s5pcsis_log_status,
 };
 
-static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
+static const struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
 	.enum_mbus_code = s5pcsis_enum_mbus_code,
 	.get_fmt = s5pcsis_get_fmt,
 	.set_fmt = s5pcsis_set_fmt,
 };
 
-static struct v4l2_subdev_video_ops s5pcsis_video_ops = {
+static const struct v4l2_subdev_video_ops s5pcsis_video_ops = {
 	.s_rx_buffer = s5pcsis_s_rx_buffer,
 	.s_stream = s5pcsis_s_stream,
 };
 
-static struct v4l2_subdev_ops s5pcsis_subdev_ops = {
+static const struct v4l2_subdev_ops s5pcsis_subdev_ops = {
 	.core = &s5pcsis_core_ops,
 	.pad = &s5pcsis_pad_ops,
 	.video = &s5pcsis_video_ops,
-- 
1.9.1

