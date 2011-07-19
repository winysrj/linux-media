Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:34098 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1GSNiL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:38:11 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.50.162])
	by mgw-da01.nokia.com (Switch-3.4.4/Switch-3.4.3) with ESMTP id p6JDc8Af032138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:10 +0300
Received: from kaali.localdomain (kaali.localdomain [192.168.239.7])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id A988738638F
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:08 +0300 (EEST)
Received: from sailus by kaali.localdomain with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1QjAUy-0004Dz-EP
	for linux-media@vger.kernel.org; Tue, 19 Jul 2011 16:38:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC 2/3] v4l: events: Define frame start event
Date: Tue, 19 Jul 2011 16:38:07 +0300
Message-Id: <1311082688-16185-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4E2588AD.4070106@maxwell.research.nokia.com>
References: <4E2588AD.4070106@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define a frame start event to tell user space when the reception of a frame
starts.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   26 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   18 +++++++++++++
 include/linux/videodev2.h                          |   12 +++++++--
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 5200b68..d2cb8db 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -88,6 +88,12 @@
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>&v4l2-event-frame-sync;</entry>
+            <entry><structfield>frame</structfield></entry>
+	    <entry>Event data for event V4L2_EVENT_FRAME_START.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
             <entry><structfield>data</structfield>[64]</entry>
 	    <entry>Event data. Defined by the event type. The union
@@ -220,6 +226,26 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
+      <title>struct <structname>v4l2_event_frame_sync</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>buffer_sequence</structfield></entry>
+	    <entry>
+	      The sequence number of the buffer to be handled next or
+	      currently handled by the driver.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <para>&v4l2-event-frame-sync; is associated with
+    <constant>V4L2_EVENT_FRAME_START</constant> event.</para>
+
     <table pgwide="1" frame="none" id="changes-flags">
       <title>Changes</title>
       <tgroup cols="3">
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 275be96..7ec42bb 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -139,6 +139,24 @@
 	    </entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_EVENT_FRAME_START</constant></entry>
+	    <entry>4</entry>
+	    <entry>
+	      <para>Triggered immediately when the reception of a
+	      frame has begun. This event has a
+	      &v4l2-event-frame-sync; associated with it.</para>
+
+	      <para>A driver will only generate this event when the
+	      hardware can generate it. This might not be the case
+	      e.g. when the hardware has no DMA buffer to write the
+	      image data to. In such cases the
+	      <structfield>buffer_sequence</structfield> field in
+	      &v4l2-event-frame-sync; will not be incremented either.
+	      This causes two consecutive buffer sequence numbers to
+	      have n times frame interval in between them.</para>
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
 	    <entry>0x08000000</entry>
 	    <entry>Base event number for driver-private events.</entry>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fca24cc..4265102 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2006,6 +2006,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_VSYNC			1
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
+#define V4L2_EVENT_FRAME_START			4
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -2032,12 +2033,17 @@ struct v4l2_event_ctrl {
 	__s32 default_value;
 };
 
+struct v4l2_event_frame_sync {
+	__u32 buffer_sequence;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
-		struct v4l2_event_vsync vsync;
-		struct v4l2_event_ctrl	ctrl;
-		__u8			data[64];
+		struct v4l2_event_vsync		vsync;
+		struct v4l2_event_ctrl		ctrl;
+		struct v4l2_event_frame_sync	frame_sync;
+		__u8				data[64];
 	} u;
 	__u32				pending;
 	__u32				sequence;
-- 
1.7.2.5

