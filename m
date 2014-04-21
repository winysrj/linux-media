Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64702 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDUJ0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 05:26:21 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 1/2] v4l: Add resolution change event.
Date: Mon, 21 Apr 2014 14:56:01 +0530
Message-Id: <1398072362-24962-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

This event indicates that the decoder has reached a point in the stream,
at which the resolution changes. The userspace is expected to provide a new
set of CAPTURE buffers for the new format before decoding can continue.
The event can also be used for more generic events involving resolution
or format changes at runtime for all kinds of video devices.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16 ++++++++++++++++
 include/uapi/linux/videodev2.h                     |    6 ++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 5c70b61..0aec831 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -155,6 +155,22 @@
 	    </entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
+	    <entry>5</entry>
+	    <entry>
+	      <para>This event is triggered when a resolution or format change
+	       is detected during runtime by the video device. It can be a
+	       runtime resolution change triggered by a video decoder or the
+	       format change happening on an HDMI connector. Application may
+	       need to reinitialize buffers before proceeding further.</para>
+
+              <para>This event has a &v4l2-event-source-change; associated
+	      with it. This has significance only for v4l2 subdevs where the
+	      <structfield>pad_num</structfield> field will be updated with
+	      the pad number on which the event is triggered.</para>
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
 	    <entry>0x08000000</entry>
 	    <entry>Base event number for driver-private events.</entry>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..12e0614 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_SOURCE_CHANGE		5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1764,12 +1765,17 @@ struct v4l2_event_frame_sync {
 	__u32 frame_sequence;
 };
 
+struct v4l2_event_source_change {
+	__u32 pad_num;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
 		struct v4l2_event_vsync		vsync;
 		struct v4l2_event_ctrl		ctrl;
 		struct v4l2_event_frame_sync	frame_sync;
+		struct v4l2_event_source_change source_change;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
1.7.9.5

