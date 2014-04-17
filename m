Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaDQONZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 08/49] adv7842: Add pad-level DV timings operations
Date: Thu, 17 Apr 2014 16:12:39 +0200
Message-Id: <1397744000-23967-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 06c25c3..5742f6f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1399,6 +1399,9 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 static int adv7842_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
+
 	return v4l2_enum_dv_timings_cap(timings,
 		adv7842_get_dv_timings_cap(sd), adv7842_check_dv_timings, NULL);
 }
@@ -1406,6 +1409,9 @@ static int adv7842_enum_dv_timings(struct v4l2_subdev *sd,
 static int adv7842_dv_timings_cap(struct v4l2_subdev *sd,
 				  struct v4l2_dv_timings_cap *cap)
 {
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	*cap = *adv7842_get_dv_timings_cap(sd);
 	return 0;
 }
@@ -2901,6 +2907,8 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
 	.get_edid = adv7842_get_edid,
 	.set_edid = adv7842_set_edid,
+	.enum_dv_timings = adv7842_enum_dv_timings,
+	.dv_timings_cap = adv7842_dv_timings_cap,
 };
 
 static const struct v4l2_subdev_ops adv7842_ops = {
-- 
1.8.3.2

