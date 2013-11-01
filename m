Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27884 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3KANJU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Nov 2013 09:09:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: vinod.govindapillai@intel.com
Subject: [PATCH 1/1] v4l: Add frame end event
Date: Fri,  1 Nov 2013 15:10:43 +0200
Message-Id: <1383311443-7863-1-git-send-email-sakari.ailus@linux.intel.com>
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
Hi folks,

As we have a frame sync event that's being used to tell about the frame
start, I thought of having a frame end event as well. This isn't exactly the
same as a buffer ready event which could take place already earlier for
instance if cropping is being done.

I propose to use the id field for the purpose (V4L2_EVENT_FRAME_SYNC_START /
V4L2_EVENT_FRAME_SYNC_END). The frame start event will retain its old id
zero.

Originally I think we thought of using the id field for the line, but
now I think it's worth adding a distinct event for that purpose: line based
events are typically triggered from other sources than line based events.
Frame sync, in my opinion, matches better with frame start and frame end
than to anything related to lines.

So should line based events be supported, they should have their own event
type and use the id field as the line number.

Kind regards,
Sakari

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 58 +++++++++++++++-------
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   | 11 +++-
 include/uapi/linux/videodev2.h                     |  3 ++
 3 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 89891ad..e258c6e 100644
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
+	    </constant>.</entry>
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
@@ -270,6 +255,41 @@
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
+
+    <table pgwide="1" frame="none" id="v4l2-event-frame-sync-ids">
+      <title>Frame sync event IDs</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_EVENT_FRAME_SYNC_START</constant></entry>
+	    <entry>0x0000</entry>
+	    <entry>Frame sync event delivered at frame start.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_FRAME_SYNC_END</constant></entry>
+	    <entry>0x0001</entry>
+	    <entry>Frame sync event delivered at frame end.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </refsect1>
   <refsect1>
     &return-value;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 5c70b61..aaa6fe1 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -143,15 +143,22 @@
 	    <entry>4</entry>
 	    <entry>
 	      <para>Triggered immediately when the reception of a
-	      frame has begun. This event has a
+	      frame has begun or ended. This event has a
 	      &v4l2-event-frame-sync; associated with it.</para>
 
 	      <para>If the hardware needs to be stopped in the case of a
 	      buffer underrun it might not be able to generate this event.
 	      In such cases the <structfield>frame_sequence</structfield>
 	      field in &v4l2-event-frame-sync; will not be incremented. This
-	      causes two consecutive frame sequence numbers to have n times
+	      causes two consecutive frame sync events to have n times
 	      frame interval in between them.</para>
+
+	      <para>The <structfield>id</structfield> field must be set to
+	      either <constant>V4L2_EVENT_FRAME_SYNC_START</constant> or
+	      <constant>V4L2_EVENT_FRAME_SYNC_END</constant> which signify
+	      the start of frame and end of frame, respectively. See
+	      <xref linkend="v4l2-event-frame-sync-ids" /> for more
+	      information.</para>
 	    </entry>
 	  </row>
 	  <row>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..133957a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1760,6 +1760,9 @@ struct v4l2_event_ctrl {
 	__s32 default_value;
 };
 
+#define V4L2_EVENT_FRAME_SYNC_START		0
+#define V4L2_EVENT_FRAME_SYNC_END		1
+
 struct v4l2_event_frame_sync {
 	__u32 frame_sequence;
 };
-- 
1.8.3.2

