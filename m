Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:56823 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJTVul (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:41 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 05/17] [media] v4l: add V4L2_EVENT_OUT_FENCE event
Date: Fri, 20 Oct 2017 19:50:00 -0200
Message-Id: <20171020215012.20646-6-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add a new event the userspace can subscribe to receive notifications
of the out_fence_fd when a buffer is queued onto the driver.
The event provides the index of the queued buffer and the out_fence_fd.

v3: - Rename event to V4L2_EVENT_OUT_FENCE

v2: - Add missing Documentation (Mauro)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-dqevent.rst | 23 +++++++++++++++++++++++
 Documentation/media/videodev2.h.rst.exceptions  |  1 +
 include/uapi/linux/videodev2.h                  | 12 ++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index cb3565f36793..2143df63aeb1 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -79,6 +79,10 @@ call.
       - ``src_change``
       - Event data for event V4L2_EVENT_SOURCE_CHANGE.
     * -
+      - struct :c:type:`v4l2_event_buf_queued`
+      - ``buf_queued``
+      - Event data for event V4L2_EVENT_OUT_FENCE.
+    * -
       - __u8
       - ``data``\ [64]
       - Event data. Defined by the event type. The union should be used to
@@ -338,6 +342,25 @@ call.
 	each cell in the motion detection grid, then that all cells are
 	automatically assigned to the default region 0.
 
+.. c:type:: v4l2_event_out_fence
+
+.. flat-table:: struct v4l2_event_out_fence
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``index``
+      - The index of the buffer that was queued to the driver.
+    * - __s32
+      - ``out_fence_fd``
+      - The out-fence file descriptor of the buffer that was queued to
+	the driver. It will signal when the buffer is ready, or if an
+	error happens.
+
+
+
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index a5cb0a8686ac..32f3d5b37e3a 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -462,6 +462,7 @@ replace define V4L2_EVENT_CTRL event-type
 replace define V4L2_EVENT_FRAME_SYNC event-type
 replace define V4L2_EVENT_SOURCE_CHANGE event-type
 replace define V4L2_EVENT_MOTION_DET event-type
+replace define V4L2_EVENT_OUT_FENCE event-type
 replace define V4L2_EVENT_PRIVATE_START event-type
 
 replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0acc06..2a432e8c18e3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2156,6 +2156,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_FRAME_SYNC			4
 #define V4L2_EVENT_SOURCE_CHANGE		5
 #define V4L2_EVENT_MOTION_DET			6
+#define V4L2_EVENT_OUT_FENCE			7
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -2208,6 +2209,16 @@ struct v4l2_event_motion_det {
 	__u32 region_mask;
 };
 
+/**
+ * struct v4l2_event_out_fence - out fence fd event
+ * @index:		index of the buffer queued in the driver
+ * @out_fence_fd:	out-fence fd of the buffer queued
+ */
+struct v4l2_event_out_fence {
+	__u32 index;
+	__s32 out_fence_fd;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
@@ -2216,6 +2227,7 @@ struct v4l2_event {
 		struct v4l2_event_frame_sync	frame_sync;
 		struct v4l2_event_src_change	src_change;
 		struct v4l2_event_motion_det	motion_det;
+		struct v4l2_event_out_fence	out_fence;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
2.13.6
