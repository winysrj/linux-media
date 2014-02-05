Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaBEQlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 09/47] adv7842: Add pad-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:00 +0100
Message-Id: <1391618558-5580-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7842.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index e04fe3f..78d21fd 100644
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
@@ -2897,6 +2903,8 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
 	.get_edid = adv7842_get_edid,
 	.set_edid = adv7842_set_edid,
+	.enum_dv_timings = adv7842_enum_dv_timings,
+	.dv_timings_cap = adv7842_dv_timings_cap,
 };
 
 static const struct v4l2_subdev_ops adv7842_ops = {
-- 
1.8.3.2

