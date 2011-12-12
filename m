Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LLRpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:09 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW3000C7QN3JX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3007V2QN2EF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:58 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 14/14] s5p-csis: Enable v4l subdev device node
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-15-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set v4l2_subdev flags for a host driver to create a sub-device
node for the driver so the subdev can be directly configured
by applications. Add the subdev open() handler.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c |   22 ++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 59d79bc..130335c 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -427,6 +427,23 @@ static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
+static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	format->colorspace = V4L2_COLORSPACE_JPEG;
+	format->code = s5pcsis_formats[0].code;
+	format->width = S5PCSIS_DEF_PIX_WIDTH;
+	format->height = S5PCSIS_DEF_PIX_HEIGHT;
+	format->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops s5pcsis_sd_internal_ops = {
+	.open = s5pcsis_open,
+};
+
 static struct v4l2_subdev_core_ops s5pcsis_core_ops = {
 	.s_power = s5pcsis_s_power,
 };
@@ -544,8 +561,13 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
 	state->sd.owner = THIS_MODULE;
 	strlcpy(state->sd.name, dev_name(&pdev->dev), sizeof(state->sd.name));
+	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	state->csis_fmt = &s5pcsis_formats[0];
 
+	state->format.code = s5pcsis_formats[0].code;
+	state->format.width = S5PCSIS_DEF_PIX_WIDTH;
+	state->format.height = S5PCSIS_DEF_PIX_HEIGHT;
+
 	state->pads[CSIS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	state->pads[CSIS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&state->sd.entity,
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.h b/drivers/media/video/s5p-fimc/mipi-csis.h
index f569133..2709286 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.h
+++ b/drivers/media/video/s5p-fimc/mipi-csis.h
@@ -19,4 +19,7 @@
 #define CSIS_PAD_SOURCE		1
 #define CSIS_PADS_NUM		2
 
+#define S5PCSIS_DEF_PIX_WIDTH	640
+#define S5PCSIS_DEF_PIX_HEIGHT	480
+
 #endif
-- 
1.7.8

