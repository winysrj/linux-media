Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1389 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3HVKPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:15:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 05/10] v4l2: add a motion detection event.
Date: Thu, 22 Aug 2013 12:14:19 +0200
Message-Id: <e470878aa076008c21a179959498ea3927fa4b36.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
References: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index cf13339..52e5606 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1721,6 +1721,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_MOTION_DET			5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1752,12 +1753,28 @@ struct v4l2_event_frame_sync {
 	__u32 frame_sequence;
 };
 
+#define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ	(1 << 0)
+
+/**
+ * struct v4l2_event_motion_det - motion detection event
+ * @flags:             if V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ is set, then the
+ *                     frame_sequence field is valid.
+ * @frame_sequence:    the frame sequence number associated with this event.
+ * @region_mask:       which regions detected motion.
+ */
+struct v4l2_event_motion_det {
+	__u32 flags;
+	__u32 frame_sequence;
+	__u32 region_mask;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
 		struct v4l2_event_vsync		vsync;
 		struct v4l2_event_ctrl		ctrl;
 		struct v4l2_event_frame_sync	frame_sync;
+		struct v4l2_event_motion_det	motion_det;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
1.8.3.2

