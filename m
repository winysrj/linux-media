Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3480 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaAaKCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 05:02:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 28/32] v4l2: add a motion detection event.
Date: Fri, 31 Jan 2014 10:56:26 +0100
Message-Id: <1391162190-8620-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new MOTION_DET event to signal when motion is detected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8b70f51..4cbfb16 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1773,6 +1773,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_MOTION_DET			5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1804,12 +1805,28 @@ struct v4l2_event_frame_sync {
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
1.8.5.2

