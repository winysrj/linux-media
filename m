Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44757 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731399AbeKMTkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:40:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/9] videodev2.h: add tag support
Date: Tue, 13 Nov 2018 10:42:30 +0100
Message-Id: <20181113094238.48253-2-hverkuil@xs4all.nl>
In-Reply-To: <20181113094238.48253-1-hverkuil@xs4all.nl>
References: <20181113094238.48253-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for 'tags' to struct v4l2_buffer. These can be used
by m2m devices so userspace can set a tag for an output buffer and
this value will then be copied to the capture buffer(s).

This tag can be used to refer to capture buffers, something that
is needed by stateless HW codecs.

The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
or not tags are supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 38 +++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..ec1fef2a9445 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -879,6 +879,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_TAGS	(1 << 4)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
@@ -912,6 +913,11 @@ struct v4l2_plane {
 	__u32			reserved[11];
 };
 
+struct v4l2_buffer_tag {
+	__u32 low;
+	__u32 high;
+};
+
 /**
  * struct v4l2_buffer - video buffer info
  * @index:	id number of the buffer
@@ -950,7 +956,10 @@ struct v4l2_buffer {
 	__u32			flags;
 	__u32			field;
 	struct timeval		timestamp;
-	struct v4l2_timecode	timecode;
+	union {
+		struct v4l2_timecode	timecode;
+		struct v4l2_buffer_tag	tag;
+	};
 	__u32			sequence;
 
 	/* memory location */
@@ -988,6 +997,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* tag field is valid */
+#define V4L2_BUF_FLAG_TAG			0x00000200
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
@@ -1007,6 +1018,31 @@ struct v4l2_buffer {
 /* request_fd is valid */
 #define V4L2_BUF_FLAG_REQUEST_FD		0x00800000
 
+static inline void v4l2_buffer_set_tag(struct v4l2_buffer *buf, __u64 tag)
+{
+	buf->tag.high = tag >> 32;
+	buf->tag.low = tag & 0xffffffffULL;
+	buf->flags |= V4L2_BUF_FLAG_TAG;
+}
+
+static inline void v4l2_buffer_set_tag_ptr(struct v4l2_buffer *buf,
+					   const void *tag)
+{
+	v4l2_buffer_set_tag(buf, (uintptr_t)tag);
+}
+
+static inline __u64 v4l2_buffer_get_tag(const struct v4l2_buffer *buf)
+{
+	if (!(buf->flags & V4L2_BUF_FLAG_TAG))
+		return 0;
+	return (((__u64)buf->tag.high) << 32) | (__u64)buf->tag.low;
+}
+
+static inline void *v4l2_buffer_get_tag_ptr(const struct v4l2_buffer *buf)
+{
+	return (void *)(uintptr_t)v4l2_buffer_get_tag(buf);
+}
+
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
  *
-- 
2.19.1
