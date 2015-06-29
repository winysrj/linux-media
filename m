Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34300 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbF2AqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2015 20:46:06 -0400
Received: by ykfy125 with SMTP id y125so102178217ykf.1
        for <linux-media@vger.kernel.org>; Sun, 28 Jun 2015 17:46:06 -0700 (PDT)
From: Helen Fornazier <helen.fornazier@gmail.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	s.nawrocki@samsung.com, sakari.ailus@linux.intel.com
Cc: Helen Fornazier <helen.fornazier@gmail.com>
Subject: [PATCH] [media] v4l2-subdev: return -EPIPE instead of -EINVAL in link validate default
Date: Sun, 28 Jun 2015 21:45:42 -0300
Message-Id: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the V4L2 API, the VIDIOC_STREAMON ioctl should return EPIPE
when the pipeline configuration is invalid.

As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the error
caused by the v4l2_subdev_link_validate_default (if it is in use), it
should return -EPIPE if it detects a format mismatch in the pipeline
configuration

Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 6359606..5e64342 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -508,7 +508,7 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	if (source_fmt->format.width != sink_fmt->format.width
 	    || source_fmt->format.height != sink_fmt->format.height
 	    || source_fmt->format.code != sink_fmt->format.code)
-		return -EINVAL;
+		return -EPIPE;
 
 	/* The field order must match, or the sink field order must be NONE
 	 * to support interlaced hardware connected to bridges that support
@@ -516,7 +516,7 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	 */
 	if (source_fmt->format.field != sink_fmt->format.field &&
 	    sink_fmt->format.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+		return -EPIPE;
 
 	return 0;
 }
-- 
1.9.1

