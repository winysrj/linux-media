Return-path: <mchehab@pedra>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:63822 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370Ab0IXS20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 14:28:26 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH 3/4] ov7670: implement VIDIOC_ENUM_FRAMESIZES
Message-Id: <20100924171737.9C15F9D401B@zog.reactivated.net>
Date: Fri, 24 Sep 2010 18:17:37 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

GStreamer uses this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index f551f63..214cebf 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -916,6 +916,22 @@ static int ov7670_enum_frameintervals(struct v4l2_subdev *sd,
 }
 
 /*
+ * Frame size enumeration
+ */
+static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
+		struct v4l2_frmsizeenum *fsize)
+{
+	__u32 index = fsize->index;
+	if (index >= N_WIN_SIZES)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = ov7670_win_sizes[index].width;
+	fsize->discrete.height = ov7670_win_sizes[index].height;
+	return 0;
+}
+
+/*
  * Code for dealing with controls.
  */
 
@@ -1462,6 +1478,7 @@ static const struct v4l2_subdev_video_ops ov7670_video_ops = {
 	.s_parm = ov7670_s_parm,
 	.g_parm = ov7670_g_parm,
 	.enum_frameintervals = ov7670_enum_frameintervals,
+	.enum_framesizes = ov7670_enum_framesizes,
 };
 
 static const struct v4l2_subdev_ops ov7670_ops = {
-- 
1.7.2.2

