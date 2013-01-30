Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28717 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3A3RXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:23:38 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00L4K8B3ACU0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:37 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00A7W8B4SV70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:37 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/5] s5p-fimc: Avoid null pointer dereference in
 fimc_capture_ctrls_create()
Date: Wed, 30 Jan 2013 18:23:21 +0100
Message-id: <1359566606-31394-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With presence of some faults, e.g. caused by wrong platform data or
the device tree structure the IDX_SENSOR entry in the array may be NULL,
so make sure it is not dereferenced then.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index df6fc6c..35998a3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -486,6 +486,7 @@ static struct vb2_ops fimc_capture_qops = {
 int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
 	int ret;
 
 	if (WARN_ON(vid_cap->ctx == NULL))
@@ -494,11 +495,13 @@ int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 		return 0;
 
 	ret = fimc_ctrls_create(vid_cap->ctx);
-	if (ret || vid_cap->user_subdev_api || !vid_cap->ctx->ctrls.ready)
+
+	if (ret || vid_cap->user_subdev_api || !sensor  ||
+	    !vid_cap->ctx->ctrls.ready)
 		return ret;
 
 	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrls.handler,
-		    fimc->pipeline.subdevs[IDX_SENSOR]->ctrl_handler, NULL);
+				     sensor->ctrl_handler, NULL);
 }
 
 static int fimc_capture_set_default_format(struct fimc_dev *fimc);
-- 
1.7.9.5

