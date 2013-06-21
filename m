Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38698 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726Ab3FUNBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 09:01:33 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ00MJZUUKFKP0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 22:01:32 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/6] exynos4-is: Set valid initial format on FIMC-IS-ISP subdev
 pads
Date: Fri, 21 Jun 2013 15:00:33 +0200
Message-id: <1371819636-13499-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371819636-13499-1-git-send-email-s.nawrocki@samsung.com>
References: <1371819636-13499-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure there is a valid initial resolution and pixel format set
at the FIMC-IS-ISP subdev pads.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 9a37272..bc515f0 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -670,6 +670,22 @@ static const struct v4l2_ctrl_ops fimc_isp_ctrl_ops = {
 	.s_ctrl	= fimc_is_s_ctrl,
 };
 
+static void __isp_subdev_set_default_format(struct fimc_isp *isp)
+{
+	struct fimc_is *is = fimc_isp_to_is(isp);
+
+	isp->sink_fmt.width = DEFAULT_PREVIEW_STILL_WIDTH +
+				FIMC_ISP_CAC_MARGIN_WIDTH;
+	isp->sink_fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT +
+				FIMC_ISP_CAC_MARGIN_HEIGHT;
+	isp->sink_fmt.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+	isp->src_fmt.width = DEFAULT_PREVIEW_STILL_WIDTH;
+	isp->src_fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+	isp->src_fmt.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	__is_set_frame_size(is, &isp->src_fmt);
+}
+
 int fimc_isp_subdev_create(struct fimc_isp *isp)
 {
 	const struct v4l2_ctrl_ops *ops = &fimc_isp_ctrl_ops;
@@ -750,6 +766,8 @@ int fimc_isp_subdev_create(struct fimc_isp *isp)
 	sd->entity.ops = &fimc_is_subdev_media_ops;
 	v4l2_set_subdevdata(sd, isp);
 
+	__isp_subdev_set_default_format(isp);
+
 	return 0;
 }
 
-- 
1.7.9.5

