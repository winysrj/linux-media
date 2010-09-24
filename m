Return-path: <mchehab@pedra>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:63822 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297Ab0IXS2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 14:28:24 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH 2/4] ov7670: implement VIDIOC_ENUM_FRAMEINTERVALS
Message-Id: <20100924171729.351469D401C@zog.reactivated.net>
Date: Fri, 24 Sep 2010 18:17:29 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jonathan Corbet <corbet@lwn.net>

Inquiring minds (and gstreamer) want to know.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 91c886a..f551f63 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -896,14 +896,28 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 }
 
 
-
 /*
- * Code for dealing with controls.
+ * Frame intervals.  Since frame rates are controlled with the clock
+ * divider, we can only do 30/n for integer n values.  So no continuous
+ * or stepwise options.  Here we just pick a handful of logical values.
  */
 
+static int ov7670_frame_rates[] = { 30, 15, 10, 5, 1 };
 
+static int ov7670_enum_frameintervals(struct v4l2_subdev *sd,
+		struct v4l2_frmivalenum *interval)
+{
+	if (interval->index >= ARRAY_SIZE(ov7670_frame_rates))
+		return -EINVAL;
+	interval->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	interval->discrete.numerator = 1;
+	interval->discrete.denominator = ov7670_frame_rates[interval->index];
+	return 0;
+}
 
-
+/*
+ * Code for dealing with controls.
+ */
 
 static int ov7670_store_cmatrix(struct v4l2_subdev *sd,
 		int matrix[CMATRIX_LEN])
@@ -1447,6 +1461,7 @@ static const struct v4l2_subdev_video_ops ov7670_video_ops = {
 	.s_fmt = ov7670_s_fmt,
 	.s_parm = ov7670_s_parm,
 	.g_parm = ov7670_g_parm,
+	.enum_frameintervals = ov7670_enum_frameintervals,
 };
 
 static const struct v4l2_subdev_ops ov7670_ops = {
-- 
1.7.2.2

