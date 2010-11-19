Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47581 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0KSN0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:26:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
Date: Fri, 19 Nov 2010 14:26:42 +0100
Message-Id: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Some buggy sensors generate corrupt frames when the stream is started.
This new operation returns the number of corrupt frames to skip when
starting the stream.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 04878e1..b196966 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -291,9 +291,13 @@ struct v4l2_subdev_pad_ops {
  *		      This is needed for some sensors, which always corrupt
  *		      several top lines of the output image, or which send their
  *		      metadata in them.
+ * @g_skip_frames: number of frames to skip at stream start. This is needed for
+ * 		   buggy sensors that generate faulty frames when they are
+ * 		   turned on.
  */
 struct v4l2_subdev_sensor_ops {
 	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
+	int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);
 };
 
 struct v4l2_subdev_ops {
-- 
1.7.2.2

