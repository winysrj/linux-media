Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3936 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3KLNpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 08:45:41 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, vinod.govindapillai@intel.com
Subject: [PATCH v2 1/1] v4l: Add frame end event
Date: Tue, 12 Nov 2013 15:47:06 +0200
Message-Id: <1384264026-9648-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1383311443-7863-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1383311443-7863-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an event to signal frame end. This is not necessarily the same timestamp
as the video buffer done timestamp, and can be also subscribed by other
processes than the one controlling streaming and buffer (de)queueing.

Also make all event type constants appear as constants in documentation and
move frame sync event struct documentation after all control event
documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi,

I decided it'd be better not to use the id field to tell it's frame end ---
that field would be better used for stream id (and we're not exactly running
out of possible values for type).

As discussed previously, I don't know when this would be needed in mainline.

Regards,
Sakari

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 39 +++++++++++-----------
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   | 18 +++++++++-
 include/uapi/linux/videodev2.h                     |  2 ++
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 89891ad..0fdaa2e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -76,21 +76,22 @@
 	    <entry></entry>
 	    <entry>&v4l2-event-vsync;</entry>
             <entry><structfield>vsync</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_VSYNC.
+	    <entry>Event data for event <constant>V4L2_EVENT_VSYNC</constant>.
             </entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-ctrl;</entry>
             <entry><structfield>ctrl</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_CTRL.
+	    <entry>Event data for event <constant>V4L2_EVENT_CTRL</constant>.
             </entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-frame-sync;</entry>
             <entry><structfield>frame_sync</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_FRAME_SYNC.</entry>
+	    <entry>Event data for event <constant>V4L2_EVENT_FRAME_SYNC
+	    </constant> and <constant>V4L2_EVENT_FRAME_END</constant>.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
@@ -226,22 +227,6 @@
       </tgroup>
     </table>
 
-    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
-      <title>struct <structname>v4l2_event_frame_sync</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>frame_sequence</structfield></entry>
-	    <entry>
-	      The sequence number of the frame being received.
-	    </entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
     <table pgwide="1" frame="none" id="changes-flags">
       <title>Changes</title>
       <tgroup cols="3">
@@ -270,6 +255,22 @@
 	</tbody>
       </tgroup>
     </table>
+
+    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
+      <title>struct <structname>v4l2_event_frame_sync</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>frame_sequence</structfield></entry>
+	    <entry>
+	      The sequence number of the frame being received.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </refsect1>
   <refsect1>
     &return-value;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 5c70b61..406e5e0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -150,7 +150,23 @@
 	      buffer underrun it might not be able to generate this event.
 	      In such cases the <structfield>frame_sequence</structfield>
 	      field in &v4l2-event-frame-sync; will not be incremented. This
-	      causes two consecutive frame sequence numbers to have n times
+	      causes two consecutive frame sync events to have n times
+	      frame interval in between them.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_FRAME_END</constant></entry>
+	    <entry>5</entry>
+	    <entry>
+	      <para>Triggered immediately when the reception of a
+	      frame has ended. This event has a
+	      &v4l2-event-frame-sync; associated with it.</para>
+
+	      <para>If the hardware needs to be stopped in the case of a
+	      buffer underrun it might not be able to generate this event.
+	      In such cases the <structfield>frame_sequence</structfield>
+	      field in &v4l2-event-frame-sync; will not be incremented. This
+	      causes two consecutive frame end events to have n times
 	      frame interval in between them.</para>
 	    </entry>
 	  </row>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..2307e1a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_FRAME_END			5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1760,6 +1761,7 @@ struct v4l2_event_ctrl {
 	__s32 default_value;
 };
 
+/* V4L2_EVENT_FRAME_SYNC or V4L2_EVENT_FRAME_END */
 struct v4l2_event_frame_sync {
 	__u32 frame_sequence;
 };
-- 
1.8.3.2

