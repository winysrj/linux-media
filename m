Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4956 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaBQJ7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 29/35] v4l2: add a motion detection event.
Date: Mon, 17 Feb 2014 10:57:44 +0100
Message-Id: <1392631070-41868-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
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
1.8.4.rc3

