Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33683 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755921AbdIGSm6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:42:58 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 07/15] [media] v4l: add V4L2_EVENT_BUF_QUEUED event
Date: Thu,  7 Sep 2017 15:42:18 -0300
Message-Id: <20170907184226.27482-8-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add a new event the userspace can subscribe to receive notifications
when a buffer is queued onto the driver. The event provides the index of
the queued buffer.

v2: - Add missing Documentation (Mauro)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-dqevent.rst | 23 +++++++++++++++++++++++
 Documentation/media/videodev2.h.rst.exceptions  |  1 +
 include/uapi/linux/videodev2.h                  | 11 +++++++++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index fcd9c933870d..55f9dbdca6ec 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -78,6 +78,10 @@ call.
       - ``src_change``
       - Event data for event V4L2_EVENT_SOURCE_CHANGE.
     * -
+      - struct :c:type:`v4l2_event_buf_queued`
+      - ``buf_queued``
+      - Event data for event V4L2_EVENT_BUF_QUEUED.
+    * -
       - __u8
       - ``data``\ [64]
       - Event data. Defined by the event type. The union should be used to
@@ -337,6 +341,25 @@ call.
 	each cell in the motion detection grid, then that all cells are
 	automatically assigned to the default region 0.
 
+.. c:type:: v4l2_event_buf_queued
+
+.. flat-table:: struct v4l2_event_buf_queued
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
index a5cb0a8686ac..4e014b1d0317 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -462,6 +462,7 @@ replace define V4L2_EVENT_CTRL event-type
 replace define V4L2_EVENT_FRAME_SYNC event-type
 replace define V4L2_EVENT_SOURCE_CHANGE event-type
 replace define V4L2_EVENT_MOTION_DET event-type
+replace define V4L2_EVENT_BUF_QUEUED event-type
 replace define V4L2_EVENT_PRIVATE_START event-type
 
 replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e5abab9a908c..e2ec0b66f490 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2158,6 +2158,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_FRAME_SYNC			4
 #define V4L2_EVENT_SOURCE_CHANGE		5
 #define V4L2_EVENT_MOTION_DET			6
+#define V4L2_EVENT_BUF_QUEUED			7
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -2210,6 +2211,15 @@ struct v4l2_event_motion_det {
 	__u32 region_mask;
 };
 
+/**
+ * struct v4l2_event_buf_queued - buffer queued in the driver event
+ * @index:		index of the buffer queued in the driver
+ */
+struct v4l2_event_buf_queued {
+	__u32 index;
+	__s32 out_fence_fd;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
@@ -2218,6 +2228,7 @@ struct v4l2_event {
 		struct v4l2_event_frame_sync	frame_sync;
 		struct v4l2_event_src_change	src_change;
 		struct v4l2_event_motion_det	motion_det;
+		struct v4l2_event_buf_queued	buf_queued;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
2.13.5
