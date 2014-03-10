Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaCJXOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 12/48] ths8200: Add pad-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:23 +0100
Message-Id: <1394493359-14115-13-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ths8200.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index f72561e..c4ec8b2 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -410,6 +410,9 @@ static int ths8200_g_dv_timings(struct v4l2_subdev *sd,
 static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
+
 	return v4l2_enum_dv_timings_cap(timings, &ths8200_timings_cap,
 			NULL, NULL);
 }
@@ -417,6 +420,9 @@ static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
 static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
 				  struct v4l2_dv_timings_cap *cap)
 {
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	*cap = ths8200_timings_cap;
 	return 0;
 }
@@ -430,10 +436,16 @@ static const struct v4l2_subdev_video_ops ths8200_video_ops = {
 	.dv_timings_cap = ths8200_dv_timings_cap,
 };
 
+static const struct v4l2_subdev_pad_ops ths8200_pad_ops = {
+	.enum_dv_timings = ths8200_enum_dv_timings,
+	.dv_timings_cap = ths8200_dv_timings_cap,
+};
+
 /* V4L2 top level operation handlers */
 static const struct v4l2_subdev_ops ths8200_ops = {
 	.core  = &ths8200_core_ops,
 	.video = &ths8200_video_ops,
+	.pad = &ths8200_pad_ops,
 };
 
 static int ths8200_probe(struct i2c_client *client,
-- 
1.8.3.2

