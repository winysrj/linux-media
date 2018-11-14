Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50840 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733090AbeKNXvI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:51:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/9] videodev2.h: add tag support
Date: Wed, 14 Nov 2018 14:47:35 +0100
Message-Id: <20181114134743.18993-2-hverkuil@xs4all.nl>
In-Reply-To: <20181114134743.18993-1-hverkuil@xs4all.nl>
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
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
 include/uapi/linux/videodev2.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..173a94d2cbef 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -879,6 +879,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_TAGS	(1 << 4)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
@@ -923,6 +924,7 @@ struct v4l2_plane {
  * @field:	enum v4l2_field; field order of the image in the buffer
  * @timestamp:	frame timestamp
  * @timecode:	frame timecode
+ * @tag:	buffer tag
  * @sequence:	sequence count of this frame
  * @memory:	enum v4l2_memory; the method, in which the actual video data is
  *		passed
@@ -950,7 +952,10 @@ struct v4l2_buffer {
 	__u32			flags;
 	__u32			field;
 	struct timeval		timestamp;
-	struct v4l2_timecode	timecode;
+	union {
+		struct v4l2_timecode	timecode;
+		__u32			tag;
+	};
 	__u32			sequence;
 
 	/* memory location */
@@ -988,6 +993,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* tag field is valid */
+#define V4L2_BUF_FLAG_TAG			0x00000200
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
-- 
2.19.1
