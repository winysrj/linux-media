Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57096 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbdJaQp4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:45:56 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] media: exynos4-is: drop obsolete capabilities
Date: Tue, 31 Oct 2017 17:45:44 +0100
Message-id: <20171031164544.2401-2-m.szyprowski@samsung.com>
In-reply-to: <20171031164544.2401-1-m.szyprowski@samsung.com>
References: <20171031164544.2401-1-m.szyprowski@samsung.com>
        <CGME20171031164552eucas1p2c8074f30e1d31d4706381fbd47a3cfb6@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting both V4L2_CAP_VIDEO_CAPTURE_MPLANE and V4L2_CAP_VIDEO_OUTPUT_MPLANE
for mem2mem video nodes is obsolete since commit f0476a83d61a ("[media]
V4L: Add capability flags for memory-to-memory devices"). It was enough
time to adapt all users to the new flags, so drop the legacy caps for now
to match other mem2mem drivers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-m2m.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 9027d0b0d2bd..a19f8b164a47 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -236,15 +236,7 @@ static int fimc_m2m_querycap(struct file *file, void *fh,
 				     struct v4l2_capability *cap)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	unsigned int caps;
-
-	/*
-	 * This is only a mem-to-mem video device. The capture and output
-	 * device capability flags are left only for backward compatibility
-	 * and are scheduled for removal.
-	 */
-	caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
-		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	unsigned int caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
 
 	__fimc_vidioc_querycap(&fimc->pdev->dev, cap, caps);
 	return 0;
-- 
2.14.2
