Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42435 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753682AbeBKSvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 13:51:18 -0500
Received: by mail-pf0-f193.google.com with SMTP id b25so3267072pfd.9
        for <linux-media@vger.kernel.org>; Sun, 11 Feb 2018 10:51:17 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: imx: mipi csi-2: Fix set_fmt try
Date: Sun, 11 Feb 2018 10:51:09 -0800
Message-Id: <1518375069-5497-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

csi2_set_fmt() was setting the try_fmt only on the first pad, and pad
index was ignored. Fix by introducing __csi2_get_fmt().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx6-mipi-csi2.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 477d191..4b7135a 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -447,6 +447,16 @@ static int csi2_link_setup(struct media_entity *entity,
 	return ret;
 }
 
+static struct v4l2_mbus_framefmt *
+__csi2_get_fmt(struct csi2_dev *csi2, struct v4l2_subdev_pad_config *cfg,
+	       unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&csi2->sd, cfg, pad);
+	else
+		return &csi2->format_mbus;
+}
+
 static int csi2_get_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat)
@@ -456,11 +466,7 @@ static int csi2_get_fmt(struct v4l2_subdev *sd,
 
 	mutex_lock(&csi2->lock);
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
-		fmt = v4l2_subdev_get_try_format(&csi2->sd, cfg,
-						 sdformat->pad);
-	else
-		fmt = &csi2->format_mbus;
+	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
 
 	sdformat->format = *fmt;
 
@@ -474,6 +480,7 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_format *sdformat)
 {
 	struct csi2_dev *csi2 = sd_to_dev(sd);
+	struct v4l2_mbus_framefmt *fmt;
 	int ret = 0;
 
 	if (sdformat->pad >= CSI2_NUM_PADS)
@@ -490,10 +497,9 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->pad != CSI2_SINK_PAD)
 		sdformat->format = csi2->format_mbus;
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
-		cfg->try_fmt = sdformat->format;
-	else
-		csi2->format_mbus = sdformat->format;
+	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
+
+	*fmt = sdformat->format;
 out:
 	mutex_unlock(&csi2->lock);
 	return ret;
-- 
2.7.4
