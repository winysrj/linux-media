Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51088 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdIOTzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 15:55:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos4-is: properly initialize frame format
Date: Fri, 15 Sep 2017 21:54:34 +0200
Message-Id: <20170915195441.1505586-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We copy the subdev frame format from a partially initialized
structure, which is not entirely well-defined. Older compilers
like gcc-4.4 can copy uninitialized stack data here and warn
about it:

drivers/media/platform/exynos4-is/fimc-isp.c: In function 'fimc_isp_subdev_open':
drivers/media/platform/exynos4-is/fimc-isp.c:379: error: 'fmt.reserved[10u]' may be used uninitialized in this function
drivers/media/platform/exynos4-is/fimc-isp.c:379: error: 'fmt.reserved[9u]' may be used uninitialized in this function
...
drivers/media/platform/exynos4-is/fimc-isp.c:379: error: 'fmt.reserved[0u]' may be used uninitialized in this function
drivers/media/platform/exynos4-is/fimc-isp.c:379: error: 'fmt.xfer_func' may be used uninitialized in this function

On newer compilers, only the initialized fields get copied, but
we should not rely on that, so this changes the code to zero-out
the remaining fields first.

Fixes: 9a761e436843 ("[media] exynos4-is: Add Exynos4x12 FIMC-IS driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/exynos4-is/fimc-isp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index fd793d3ac072..9a48c0f69320 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -366,16 +366,16 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
 static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 				struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt fmt;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_mbus_framefmt fmt = {
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.code = fimc_isp_formats[0].mbus_code,
+		.width = DEFAULT_PREVIEW_STILL_WIDTH + FIMC_ISP_CAC_MARGIN_WIDTH,
+		.height = DEFAULT_PREVIEW_STILL_HEIGHT + FIMC_ISP_CAC_MARGIN_HEIGHT,
+		.field = V4L2_FIELD_NONE,
+	};
 
 	format = v4l2_subdev_get_try_format(sd, fh->pad, FIMC_ISP_SD_PAD_SINK);
-
-	fmt.colorspace = V4L2_COLORSPACE_SRGB;
-	fmt.code = fimc_isp_formats[0].mbus_code;
-	fmt.width = DEFAULT_PREVIEW_STILL_WIDTH + FIMC_ISP_CAC_MARGIN_WIDTH;
-	fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT + FIMC_ISP_CAC_MARGIN_HEIGHT;
-	fmt.field = V4L2_FIELD_NONE;
 	*format = fmt;
 
 	format = v4l2_subdev_get_try_format(sd, fh->pad, FIMC_ISP_SD_PAD_SRC_FIFO);
-- 
2.9.0
