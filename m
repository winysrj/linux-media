Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8222 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3EaMlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:41:07 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN002DAXWIY8Q0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:41:06 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] exynos4-is: Fix reported colorspace at FIMC-IS-ISP subdev
Date: Fri, 31 May 2013 14:40:37 +0200
Message-id: <1370004037-18314-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
References: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIMC-IS-ISP handles only Bayer formats thus V4L2_COLORSPACE_SRGB
should be used. This change applies to the code first added in v3.10.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index d63947f..7ede30b 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -138,7 +138,7 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	mutex_lock(&isp->subdev_lock);
 	__is_get_frame_size(is, &cur_fmt);
@@ -194,7 +194,7 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "%s: pad%d: code: 0x%x, %dx%d\n",
 		 __func__, fmt->pad, mf->code, mf->width, mf->height);
 
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	mutex_lock(&isp->subdev_lock);
 	__isp_subdev_try_format(isp, fmt);
-- 
1.7.9.5

