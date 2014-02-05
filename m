Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaBEQlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 13/47] tvp7002: Add pad-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:04 +0100
Message-Id: <1391618558-5580-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings operation is deprecated. Implement the
pad-level version of the operation to prepare for the removal of the
video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp7002.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 912e1cc..9f56fd5 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -832,6 +832,9 @@ static int tvp7002_log_status(struct v4l2_subdev *sd)
 static int tvp7002_enum_dv_timings(struct v4l2_subdev *sd,
 		struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
+
 	/* Check requested format index is within range */
 	if (timings->index >= NUM_TIMINGS)
 		return -EINVAL;
@@ -937,6 +940,7 @@ static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
 	.enum_mbus_code = tvp7002_enum_mbus_code,
 	.get_fmt = tvp7002_get_pad_format,
 	.set_fmt = tvp7002_set_pad_format,
+	.enum_dv_timings = tvp7002_enum_dv_timings,
 };
 
 /* V4L2 top level operation handlers */
-- 
1.8.3.2

