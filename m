Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4226 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaFLLyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 28/34] v4l2: add a motion detection event.
Date: Thu, 12 Jun 2014 13:53:00 +0200
Message-Id: <731c193e2e978982bd697ec545190deb00476350.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new MOTION_DET event to signal when motion is detected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 93ae827..f7defeb 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1799,6 +1799,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
 #define V4L2_EVENT_SOURCE_CHANGE		5
+#define V4L2_EVENT_MOTION_DET			6
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1836,6 +1837,21 @@ struct v4l2_event_src_change {
 	__u32 changes;
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
@@ -1843,6 +1859,7 @@ struct v4l2_event {
 		struct v4l2_event_ctrl		ctrl;
 		struct v4l2_event_frame_sync	frame_sync;
 		struct v4l2_event_src_change	src_change;
+		struct v4l2_event_motion_det	motion_det;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
2.0.0.rc0

