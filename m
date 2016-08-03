Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35318 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbcHCSEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:04:12 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v4 7/8] v4l: Add signal lock status to source change events
Date: Wed,  3 Aug 2016 11:03:49 -0700
Message-Id: <1470247430-11168-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a signal lock status change to the source changes bitmask.
This indicates there was a signal lock or unlock event detected
at the input of a video decoder.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---

v4:
- converted to rst from DocBook

v3: no changes
v2: no changes
---
 Documentation/media/uapi/v4l/vidioc-dqevent.rst | 9 +++++++++
 Documentation/media/videodev2.h.rst.exceptions  | 1 +
 include/uapi/linux/videodev2.h                  | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 73c0d5b..7d8a053 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -564,6 +564,15 @@ call.
 	  an input. This can come from an input connector or from a video
 	  decoder.
 
+    -  .. row 2
+
+       -  ``V4L2_EVENT_SRC_CH_LOCK_STATUS``
+
+       -  0x0002
+
+       -  This event gets triggered when there is a signal lock or
+	  unlock detected at the input of a video decoder.
+
 
 Return Value
 ============
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 9bb9a6c..f412cc8 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -453,6 +453,7 @@ replace define V4L2_EVENT_CTRL_CH_FLAGS ctrl-changes-flags
 replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
 
 replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
+replace define V4L2_EVENT_SRC_CH_LOCK_STATUS src-changes-flags
 
 replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 724f43e..08a153f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2078,6 +2078,7 @@ struct v4l2_event_frame_sync {
 };
 
 #define V4L2_EVENT_SRC_CH_RESOLUTION		(1 << 0)
+#define V4L2_EVENT_SRC_CH_LOCK_STATUS		(1 << 1)
 
 struct v4l2_event_src_change {
 	__u32 changes;
-- 
1.9.1

