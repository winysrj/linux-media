Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46819 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728629AbeKLSZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCHv2 1/5] videodev2.h: add tag support
Date: Mon, 12 Nov 2018 09:33:01 +0100
Message-Id: <20181112083305.22618-2-hverkuil@xs4all.nl>
In-Reply-To: <20181112083305.22618-1-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
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

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 37 +++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..a6f81f368e01 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -912,6 +912,11 @@ struct v4l2_plane {
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
@@ -950,7 +955,10 @@ struct v4l2_buffer {
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
@@ -988,6 +996,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* tag field is valid */
+#define V4L2_BUF_FLAG_TAG			0x00000200
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
@@ -1007,6 +1017,31 @@ struct v4l2_buffer {
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
+	v4l2_buffer_set_tag(buf, (__u64)tag);
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
+	return (void *)v4l2_buffer_get_tag(buf);
+}
+
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
  *
-- 
2.19.1
