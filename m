Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56335 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbeLCNwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:55 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 1/9] videodev2.h: add tag support
Date: Mon,  3 Dec 2018 14:51:35 +0100
Message-Id: <20181203135143.45487-2-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add support for 'tags' to struct v4l2_buffer. These can be used
by m2m devices so userspace can set a tag for an output buffer and
this value will then be copied to the capture buffer(s).

This tag can be used to refer to capture buffers, something that
is needed by stateless HW codecs.

The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
or not tags are supported.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 include/uapi/linux/videodev2.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2a223835214c..99b2b13a5757 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -880,6 +880,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
 #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
+#define V4L2_BUF_CAP_SUPPORTS_TAGS	(1 << 5)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
@@ -924,6 +925,7 @@ struct v4l2_plane {
  * @field:	enum v4l2_field; field order of the image in the buffer
  * @timestamp:	frame timestamp
  * @timecode:	frame timecode
+ * @tag:	buffer tag
  * @sequence:	sequence count of this frame
  * @memory:	enum v4l2_memory; the method, in which the actual video data is
  *		passed
@@ -951,7 +953,10 @@ struct v4l2_buffer {
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
@@ -989,6 +994,8 @@ struct v4l2_buffer {
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
