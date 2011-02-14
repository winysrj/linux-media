Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab1BNMVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v2 2/6] v4l: Add subdev sensor g_skip_frames operation
Date: Mon, 14 Feb 2011 13:21:26 +0100
Message-Id: <1297686090-9762-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some buggy sensors generate corrupt frames when the stream is started.
This new operation return the number of corrupt frames to skip when
starting the stream.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b0ce124..79217ba 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -339,9 +339,13 @@ struct v4l2_subdev_vbi_ops {
  *		      This is needed for some sensors, which always corrupt
  *		      several top lines of the output image, or which send their
  *		      metadata in them.
+ * @g_skip_frames: number of frames to skip at stream start. This is needed for
+ *		   buggy sensors that generate faulty frames when they are
+ *		   turned on.
  */
 struct v4l2_subdev_sensor_ops {
 	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
+	int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);
 };
 
 /*
-- 
1.7.3.4

