Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34005 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbeKITgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 14:36:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/5] videodev2.h: add cookie support
Date: Fri,  9 Nov 2018 10:56:09 +0100
Message-Id: <20181109095613.28272-2-hverkuil@xs4all.nl>
In-Reply-To: <20181109095613.28272-1-hverkuil@xs4all.nl>
References: <20181109095613.28272-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for 'cookies' to struct v4l2_buffer. These can be used to
by m2m devices so userspace can set a cookie in an output buffer and
this value will then be copied to the capture buffer(s).

This cookie can be used to refer to capture buffers, something that
is needed by stateless HW codecs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 36 +++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..180df3451057 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -912,6 +912,11 @@ struct v4l2_plane {
 	__u32			reserved[11];
 };
 
+struct v4l2_cookie {
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
+		struct v4l2_cookie	cookie;
+	};
 	__u32			sequence;
 
 	/* memory location */
@@ -988,6 +996,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* cookie field is valid */
+#define V4L2_BUF_FLAG_COOKIE			0x00000200
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
@@ -1007,6 +1017,30 @@ struct v4l2_buffer {
 /* request_fd is valid */
 #define V4L2_BUF_FLAG_REQUEST_FD		0x00800000
 
+static inline void v4l2_buffer_set_cookie(struct v4l2_buffer *buf, __u64 cookie)
+{
+	buf->cookie.high = cookie >> 32;
+	buf->cookie.low = cookie & 0xffffffffULL;
+	buf->flags |= V4L2_BUF_FLAG_COOKIE;
+}
+
+static inline void v4l2_buffer_set_cookie_ptr(struct v4l2_buffer *buf, const void *cookie)
+{
+	v4l2_buffer_set_cookie(buf, (__u64)cookie);
+}
+
+static inline __u64 v4l2_buffer_get_cookie(const struct v4l2_buffer *buf)
+{
+	if (!(buf->flags & V4L2_BUF_FLAG_COOKIE))
+		return 0;
+	return (((__u64)buf->cookie.high) << 32) | (__u64)buf->cookie.low;
+}
+
+static inline void *v4l2_buffer_get_cookie_ptr(const struct v4l2_buffer *buf)
+{
+	return (void *)v4l2_buffer_get_cookie(buf);
+}
+
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
  *
-- 
2.19.1
