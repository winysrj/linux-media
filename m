Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2228 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab1F1L0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/13] DocBook: update V4L Event Interface section.
Date: Tue, 28 Jun 2011 13:26:03 +0200
Message-Id: <747e03f1172c52f7507731c9ddb0434ed332e5c9.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Starting with v3.1 the V4L2 API provides certain guarantees with respect to
events. Document these.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/dev-event.xml      |   30 ++++++++++++++++---
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   15 +++++++--
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-event.xml b/Documentation/DocBook/media/v4l/dev-event.xml
index be5a98f..f14ae3f 100644
--- a/Documentation/DocBook/media/v4l/dev-event.xml
+++ b/Documentation/DocBook/media/v4l/dev-event.xml
@@ -1,9 +1,10 @@
   <title>Event Interface</title>
 
-  <para>The V4L2 event interface provides means for user to get
+  <para>The V4L2 event interface provides a means for a user to get
   immediately notified on certain conditions taking place on a device.
   This might include start of frame or loss of signal events, for
-  example.
+  example. Changes in the value or state of a V4L2 control can also be
+  reported through events.
   </para>
 
   <para>To receive events, the events the user is interested in first must
@@ -15,12 +16,31 @@
 
   <para>The event subscriptions and event queues are specific to file
   handles. Subscribing an event on one file handle does not affect
-  other file handles.
-  </para>
+  other file handles.</para>
 
   <para>The information on dequeueable events is obtained by using select or
   poll system calls on video devices. The V4L2 events use POLLPRI events on
-  poll system call and exceptions on select system call.  </para>
+  poll system call and exceptions on select system call.</para>
+
+  <para>Starting with kernel 3.1 certain guarantees can be given with
+  regards to events:<orderedlist>
+	<listitem>
+	  <para>Each subscribed event has its own internal dedicated event queue.
+This means that flooding of one event type will not interfere with other
+event types.</para>
+	</listitem>
+	<listitem>
+	  <para>If the internal event queue for a particular subscribed event
+becomes full, then the oldest event in that queue will be dropped.</para>
+	</listitem>
+	<listitem>
+	  <para>Where applicable, certain event types can ensure that the payload
+of the oldest event that is about to be dropped will be merged with the payload
+of the next oldest event. Thus ensuring that no information is lost, but only an
+intermediate step leading up to that information. See the documentation for the
+event you want to subscribe to whether this is applicable for that event or not.</para>
+	</listitem>
+      </orderedlist></para>
 
   <!--
 Local Variables:
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 975f603..039a969 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -100,7 +100,7 @@
 	    <entry><constant>V4L2_EVENT_VSYNC</constant></entry>
 	    <entry>1</entry>
 	    <entry>This event is triggered on the vertical sync.
-	    This event has &v4l2-event-vsync; associated with it.
+	    This event has a &v4l2-event-vsync; associated with it.
 	    </entry>
 	  </row>
 	  <row>
@@ -118,7 +118,7 @@
 		matches the control ID from which you want to receive events.
 		This event is triggered if the control's value changes, if a
 		button control is pressed or if the control's flags change.
-	    	This event has &v4l2-event-ctrl; associated with it. This struct
+	    	This event has a &v4l2-event-ctrl; associated with it. This struct
 		contains much of the same information as &v4l2-queryctrl; and
 		&v4l2-control;.
 
@@ -126,6 +126,13 @@
 		&VIDIOC-S-EXT-CTRLS;, then the event will not be sent to
 		the file handle that called the ioctl function. This prevents
 		nasty feedback loops.
+
+		This event type will ensure that no information is lost when
+		more events are raised than there is room internally. In that
+		case the &v4l2-event-ctrl; of the second-oldest event is kept,
+		but the <structfield>changes</structfield> field of the
+		second-oldest event is ORed with the <structfield>changes</structfield>
+		field of the oldest event.
 	    </entry>
 	  </row>
 	  <row>
@@ -147,8 +154,8 @@
 	    <entry>0x0001</entry>
 	    <entry>When this event is subscribed an initial event will be sent
 		containing the current status. This only makes sense for events
-		that are triggered by a status change. Other events will ignore
-		this flag.</entry>
+		that are triggered by a status change such as <constant>V4L2_EVENT_CTRL</constant>.
+		Other events will ignore this flag.</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
1.7.1

