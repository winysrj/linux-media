Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1948232AbcBSTYu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 14:24:50 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch] media: ti-vpe: cal: Fix unreachable code in enum_frame_interval
Date: Fri, 19 Feb 2016 13:24:45 -0600
Message-ID: <1455909885-22830-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported, the current cal_enum_frameintervals() is confusing
and does not have the intended behavior.
Fix this by re-implementing to properly propagate the enum_frame_interval
request to the subdevice.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/cal.c | 40 +++++++++++--------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 35fa1071c5b2..76d81b61ecb3 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1201,42 +1201,26 @@ static int cal_enum_frameintervals(struct file *file, void *priv,
 {
 	struct cal_ctx *ctx = video_drvdata(file);
 	const struct cal_fmt *fmt;
-	struct v4l2_subdev_frame_size_enum fse;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = fival->index,
+		.width = fival->width,
+		.height = fival->height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
-	if (fival->index)
-		return -EINVAL;
-
 	fmt = find_format_by_pix(ctx, fival->pixel_format);
 	if (!fmt)
 		return -EINVAL;
 
-	/* check for valid width/height */
 	ret = 0;
-	fse.pad = 0;
-	fse.code = fmt->code;
-	fse.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	for (fse.index = 0; ; fse.index++) {
-		ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size,
-				       NULL, &fse);
-		if (ret)
-			return -EINVAL;
-
-		if ((fival->width == fse.max_width) &&
-		    (fival->height == fse.max_height))
-			break;
-		else if ((fival->width >= fse.min_width) &&
-			 (fival->width <= fse.max_width) &&
-			 (fival->height >= fse.min_height) &&
-			 (fival->height <= fse.max_height))
-			break;
-
-		return -EINVAL;
-	}
-
+	fie.code = fmt->code;
+	ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_interval,
+			       NULL, &fie);
+	if (ret)
+		return ret;
 	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	fival->discrete.numerator = 1;
-	fival->discrete.denominator = 30;
+	fival->discrete = fie.interval;
 
 	return 0;
 }
-- 
2.7.1.287.g4943984

