Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52381 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbbCRKFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:05:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3637C2A0084
	for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 11:05:31 +0100 (CET)
Message-ID: <55094DEB.2050908@xs4all.nl>
Date: Wed, 18 Mar 2015 11:05:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: improve event documentation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It always annoyed me that the event type documentation was separate from the struct
v4l2_event documentation. This patch moves it all to one place, VIDIOC_DQEVENT.

This makes much more sense.

Also changed the 'changes-flags' ref to 'ctrl-changes-flags' since this referred to
control changes. There is a src-changes-flags as well, so 'changes-flags' was a bit
vague.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 350dfb3..a0aef85 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2491,7 +2491,7 @@ that used it. It was originally scheduled for removal in 2.6.35.
         </listitem>
         <listitem>
 	  <para>Added <constant>V4L2_EVENT_CTRL_CH_RANGE</constant> control event
-	  changes flag. See <xref linkend="changes-flags"/>.</para>
+	  changes flag. See <xref linkend="ctrl-changes-flags"/>.</para>
         </listitem>
       </orderedlist>
     </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index b036f89..a31eea0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -64,7 +64,7 @@
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
             <entry></entry>
-	    <entry>Type of the event.</entry>
+	    <entry>Type of the event, see <xref linkend="event-type" />.</entry>
 	  </row>
 	  <row>
 	    <entry>union</entry>
@@ -154,6 +154,113 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="event-type">
+      <title>Event Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_EVENT_ALL</constant></entry>
+	    <entry>0</entry>
+	    <entry>All events. V4L2_EVENT_ALL is valid only for
+	    VIDIOC_UNSUBSCRIBE_EVENT for unsubscribing all events at once.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_VSYNC</constant></entry>
+	    <entry>1</entry>
+	    <entry>This event is triggered on the vertical sync.
+	    This event has a &v4l2-event-vsync; associated with it.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_EOS</constant></entry>
+	    <entry>2</entry>
+	    <entry>This event is triggered when the end of a stream is reached.
+	    This is typically used with MPEG decoders to report to the application
+	    when the last of the MPEG stream has been decoded.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_CTRL</constant></entry>
+	    <entry>3</entry>
+	    <entry><para>This event requires that the <structfield>id</structfield>
+		matches the control ID from which you want to receive events.
+		This event is triggered if the control's value changes, if a
+		button control is pressed or if the control's flags change.
+	    	This event has a &v4l2-event-ctrl; associated with it. This struct
+		contains much of the same information as &v4l2-queryctrl; and
+		&v4l2-control;.</para>
+
+		<para>If the event is generated due to a call to &VIDIOC-S-CTRL; or
+		&VIDIOC-S-EXT-CTRLS;, then the event will <emphasis>not</emphasis> be sent to
+		the file handle that called the ioctl function. This prevents
+		nasty feedback loops. If you <emphasis>do</emphasis> want to get the
+		event, then set the <constant>V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK</constant>
+		flag.
+		</para>
+
+		<para>This event type will ensure that no information is lost when
+		more events are raised than there is room internally. In that
+		case the &v4l2-event-ctrl; of the second-oldest event is kept,
+		but the <structfield>changes</structfield> field of the
+		second-oldest event is ORed with the <structfield>changes</structfield>
+		field of the oldest event.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_FRAME_SYNC</constant></entry>
+	    <entry>4</entry>
+	    <entry>
+	      <para>Triggered immediately when the reception of a
+	      frame has begun. This event has a
+	      &v4l2-event-frame-sync; associated with it.</para>
+
+	      <para>If the hardware needs to be stopped in the case of a
+	      buffer underrun it might not be able to generate this event.
+	      In such cases the <structfield>frame_sequence</structfield>
+	      field in &v4l2-event-frame-sync; will not be incremented. This
+	      causes two consecutive frame sequence numbers to have n times
+	      frame interval in between them.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
+	    <entry>5</entry>
+	    <entry>
+	      <para>This event is triggered when a source parameter change is
+	       detected during runtime by the video device. It can be a
+	       runtime resolution change triggered by a video decoder or the
+	       format change happening on an input connector.
+	       This event requires that the <structfield>id</structfield>
+	       matches the input index (when used with a video device node)
+	       or the pad index (when used with a subdevice node) from which
+	       you want to receive events.</para>
+
+              <para>This event has a &v4l2-event-src-change; associated
+	      with it. The <structfield>changes</structfield> bitfield denotes
+	      what has changed for the subscribed pad. If multiple events
+	      occurred before application could dequeue them, then the changes
+	      will have the ORed value of all the events generated.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
+	    <entry>6</entry>
+	    <entry>
+	      <para>Triggered whenever the motion detection state for one or more of the regions
+	      changes. This event has a &v4l2-event-motion-det; associated with it.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
+	    <entry>0x08000000</entry>
+	    <entry>Base event number for driver-private events.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table frame="none" pgwide="1" id="v4l2-event-vsync">
       <title>struct <structname>v4l2_event_vsync</structname></title>
       <tgroup cols="3">
@@ -177,7 +284,7 @@
 	    <entry>__u32</entry>
 	    <entry><structfield>changes</structfield></entry>
 	    <entry></entry>
-	    <entry>A bitmask that tells what has changed. See <xref linkend="changes-flags" />.</entry>
+	    <entry>A bitmask that tells what has changed. See <xref linkend="ctrl-changes-flags" />.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -309,8 +416,8 @@
       </tgroup>
     </table>
 
-    <table pgwide="1" frame="none" id="changes-flags">
-      <title>Changes</title>
+    <table pgwide="1" frame="none" id="ctrl-changes-flags">
+      <title>Control Changes</title>
       <tgroup cols="3">
 	&cs-def;
 	<tbody valign="top">
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index d7c9365..d0332f6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -60,7 +60,9 @@
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
-	    <entry>Type of the event.</entry>
+	    <entry>Type of the event, see <xref linkend="event-type" />. Note that
+<constant>V4L2_EVENT_ALL</constant> can be used with VIDIOC_UNSUBSCRIBE_EVENT
+for unsubscribing all events at once.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -84,113 +86,6 @@
       </tgroup>
     </table>
 
-    <table frame="none" pgwide="1" id="event-type">
-      <title>Event Types</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_EVENT_ALL</constant></entry>
-	    <entry>0</entry>
-	    <entry>All events. V4L2_EVENT_ALL is valid only for
-	    VIDIOC_UNSUBSCRIBE_EVENT for unsubscribing all events at once.
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_VSYNC</constant></entry>
-	    <entry>1</entry>
-	    <entry>This event is triggered on the vertical sync.
-	    This event has a &v4l2-event-vsync; associated with it.
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_EOS</constant></entry>
-	    <entry>2</entry>
-	    <entry>This event is triggered when the end of a stream is reached.
-	    This is typically used with MPEG decoders to report to the application
-	    when the last of the MPEG stream has been decoded.
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_CTRL</constant></entry>
-	    <entry>3</entry>
-	    <entry><para>This event requires that the <structfield>id</structfield>
-		matches the control ID from which you want to receive events.
-		This event is triggered if the control's value changes, if a
-		button control is pressed or if the control's flags change.
-	    	This event has a &v4l2-event-ctrl; associated with it. This struct
-		contains much of the same information as &v4l2-queryctrl; and
-		&v4l2-control;.</para>
-
-		<para>If the event is generated due to a call to &VIDIOC-S-CTRL; or
-		&VIDIOC-S-EXT-CTRLS;, then the event will <emphasis>not</emphasis> be sent to
-		the file handle that called the ioctl function. This prevents
-		nasty feedback loops. If you <emphasis>do</emphasis> want to get the
-		event, then set the <constant>V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK</constant>
-		flag.
-		</para>
-
-		<para>This event type will ensure that no information is lost when
-		more events are raised than there is room internally. In that
-		case the &v4l2-event-ctrl; of the second-oldest event is kept,
-		but the <structfield>changes</structfield> field of the
-		second-oldest event is ORed with the <structfield>changes</structfield>
-		field of the oldest event.</para>
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_FRAME_SYNC</constant></entry>
-	    <entry>4</entry>
-	    <entry>
-	      <para>Triggered immediately when the reception of a
-	      frame has begun. This event has a
-	      &v4l2-event-frame-sync; associated with it.</para>
-
-	      <para>If the hardware needs to be stopped in the case of a
-	      buffer underrun it might not be able to generate this event.
-	      In such cases the <structfield>frame_sequence</structfield>
-	      field in &v4l2-event-frame-sync; will not be incremented. This
-	      causes two consecutive frame sequence numbers to have n times
-	      frame interval in between them.</para>
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
-	    <entry>5</entry>
-	    <entry>
-	      <para>This event is triggered when a source parameter change is
-	       detected during runtime by the video device. It can be a
-	       runtime resolution change triggered by a video decoder or the
-	       format change happening on an input connector.
-	       This event requires that the <structfield>id</structfield>
-	       matches the input index (when used with a video device node)
-	       or the pad index (when used with a subdevice node) from which
-	       you want to receive events.</para>
-
-              <para>This event has a &v4l2-event-src-change; associated
-	      with it. The <structfield>changes</structfield> bitfield denotes
-	      what has changed for the subscribed pad. If multiple events
-	      occurred before application could dequeue them, then the changes
-	      will have the ORed value of all the events generated.</para>
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
-	    <entry>6</entry>
-	    <entry>
-	      <para>Triggered whenever the motion detection state for one or more of the regions
-	      changes. This event has a &v4l2-event-motion-det; associated with it.</para>
-	    </entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
-	    <entry>0x08000000</entry>
-	    <entry>Base event number for driver-private events.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
     <table pgwide="1" frame="none" id="event-flags">
       <title>Event Flags</title>
       <tgroup cols="3">
