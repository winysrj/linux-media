Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbcGUPQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 11:16:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 2/3] Update header files for requests
Date: Thu, 21 Jul 2016 18:15:45 +0300
Message-Id: <1469114146-11109-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix libv4l2 and compliance tests as well for reserved field access.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/media.h                       | 32 +++++++++++++++++++++++++++++
 include/linux/v4l2-subdev.h                 | 11 ++++++++--
 include/linux/videodev2.h                   |  7 +++++--
 lib/libv4l2/libv4l2.c                       |  4 ++--
 utils/v4l2-compliance/v4l2-test-buffers.cpp |  2 +-
 5 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/linux/media.h b/include/linux/media.h
index fdabb28..5e12826 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -384,10 +384,42 @@ struct media_v2_topology {
 
 /* ioctls */
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_DELETE		1
+#define MEDIA_REQ_CMD_APPLY		2
+#define MEDIA_REQ_CMD_QUEUE		3
+
+#define MEDIA_REQ_FL_COMPLETE_EVENT	(1 << 0)
+
+
+struct __attribute__ ((packed)) media_request_cmd {
+	__u32 cmd;
+	__u32 request;
+	__u32 flags;
+};
+
+struct __attribute__ ((packed)) media_event_request_complete {
+	__u32 id;
+};
+
+#define MEDIA_EVENT_TYPE_REQUEST_COMPLETE	1
+
+struct __attribute__ ((packed)) media_event {
+	__u32 type;
+	__u32 sequence;
+	__u32 reserved[4];
+
+	union {
+		struct media_event_request_complete req_complete;
+	};
+};
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x05, struct media_request_cmd)
+#define MEDIA_IOC_DQEVENT		_IOWR('|', 0x06, struct media_event)
 
 #endif /* __LINUX_MEDIA_H */
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index dbce2b5..dbb7c1d 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -32,10 +32,12 @@
  * enum v4l2_subdev_format_whence - Media bus format type
  * @V4L2_SUBDEV_FORMAT_TRY: try format, for negotiation only
  * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
+ * @V4L2_SUBDEV_FORMAT_REQUEST: format stored in request
  */
 enum v4l2_subdev_format_whence {
 	V4L2_SUBDEV_FORMAT_TRY = 0,
 	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
+	V4L2_SUBDEV_FORMAT_REQUEST = 2,
 };
 
 /**
@@ -43,12 +45,15 @@ enum v4l2_subdev_format_whence {
  * @which: format type (from enum v4l2_subdev_format_whence)
  * @pad: pad number, as reported by the media API
  * @format: media bus format (format code and frame size)
+ * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
+ * @reserved: for future use, set to zero for now
  */
 struct v4l2_subdev_format {
 	__u32 which;
 	__u32 pad;
 	struct v4l2_mbus_framefmt format;
-	__u32 reserved[8];
+	__u32 request;
+	__u32 reserved[7];
 };
 
 /**
@@ -139,6 +144,7 @@ struct v4l2_subdev_frame_interval_enum {
  *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r: coordinates of the selection window
+ * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
  * @reserved: for future use, set to zero for now
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -151,7 +157,8 @@ struct v4l2_subdev_selection {
 	__u32 target;
 	__u32 flags;
 	struct v4l2_rect r;
-	__u32 reserved[8];
+	__u32 request;
+	__u32 reserved[7];
 };
 
 /* Backwards compatibility define --- to be removed */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5b03ed4..4c13742 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -846,6 +846,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request: this buffer should use this request
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -869,7 +870,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u32			request;
 	__u32			reserved;
 };
 
@@ -1967,6 +1968,7 @@ struct v4l2_plane_pix_format {
  * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
  * @quantization:	enum v4l2_quantization, colorspace quantization
  * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
+ * @request:		request ID
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1981,7 +1983,8 @@ struct v4l2_pix_format_mplane {
 	__u8				ycbcr_enc;
 	__u8				quantization;
 	__u8				xfer_func;
-	__u8				reserved[7];
+	__u8				reserved[3];
+	__u32				request;
 } __attribute__ ((packed));
 
 /**
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 0ba0a88..e1dec98 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -190,7 +190,7 @@ static int v4l2_map_buffers(int index)
 		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		buf.memory = V4L2_MEMORY_MMAP;
 		buf.index = i;
-		buf.reserved = buf.reserved2 = 0;
+		buf.reserved = buf.request = 0;
 		result = devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
 				devices[index].fd, VIDIOC_QUERYBUF, &buf);
@@ -579,7 +579,7 @@ static int v4l2_buffers_mapped(int index)
 			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 			buf.memory = V4L2_MEMORY_MMAP;
 			buf.index = i;
-			buf.reserved = buf.reserved2 = 0;
+			buf.reserved = buf.request = 0;
 			if (devices[index].dev_ops->ioctl(
 					devices[index].dev_ops_priv,
 					devices[index].fd, VIDIOC_QUERYBUF,
diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 7c38abc..1a3c6f8 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -245,7 +245,7 @@ int buffer::check(unsigned type, unsigned memory, unsigned index,
 	fail_on_test(g_memory() != memory);
 	fail_on_test(g_index() >= VIDEO_MAX_FRAME);
 	fail_on_test(g_index() != index);
-	fail_on_test(buf.reserved2 || buf.reserved);
+	fail_on_test(buf.request || buf.reserved);
 	fail_on_test(timestamp != V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC &&
 		     timestamp != V4L2_BUF_FLAG_TIMESTAMP_COPY);
 	fail_on_test(timestamp_src != V4L2_BUF_FLAG_TSTAMP_SRC_SOE &&
-- 
2.7.4

