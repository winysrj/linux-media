Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38495 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbeEOJWG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:22:06 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: dan.carpenter@oracle.com, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Prevent NULL pointer dereference in
 __isp_video_try_fmt()
Date: Tue, 15 May 2018 11:21:45 +0200
Message-id: <20180515092145.6161-1-s.nawrocki@samsung.com>
References: <CGME20180515092203epcas2p4a97c179cbba250cf45c1527a5e00735c@epcas2p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes potential NULL pointer dereference as indicated
by the following static checker warning:

drivers/media/platform/exynos4-is/fimc-isp-video.c:408 isp_video_try_fmt_mplane()
error: NULL dereference inside function '__isp_video_try_fmt(isp, &f->fmt.pix_mp, (0))()'.

Fixes: 34947b8aebe3: ("[media] exynos4-is: Add the FIMC-IS ISP capture DMA driver")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 55ba696b8cf4..a920164f53f1 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -384,12 +384,17 @@ static void __isp_video_try_fmt(struct fimc_isp *isp,
 				struct v4l2_pix_format_mplane *pixm,
 				const struct fimc_fmt **fmt)
 {
-	*fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
+	const struct fimc_fmt *__fmt;
+
+	__fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
+
+	if (fmt)
+		*fmt = __fmt;
 
 	pixm->colorspace = V4L2_COLORSPACE_SRGB;
 	pixm->field = V4L2_FIELD_NONE;
-	pixm->num_planes = (*fmt)->memplanes;
-	pixm->pixelformat = (*fmt)->fourcc;
+	pixm->num_planes = __fmt->memplanes;
+	pixm->pixelformat = __fmt->fourcc;
 	/*
 	 * TODO: double check with the docmentation these width/height
 	 * constraints are correct.
-- 
2.14.2
