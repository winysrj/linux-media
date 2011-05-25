Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4080 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab1EYNeU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/11] V4L2 spec: document control events.
Date: Wed, 25 May 2011 15:33:54 +0200
Message-Id: <1bb696b87c19d6ad695b1d984fcabfe414005ae0.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media-entities.tmpl          |    1 +
 Documentation/DocBook/v4l/vidioc-dqevent.xml       |   17 +++-
 .../DocBook/v4l/vidioc-subscribe-event.xml         |  142 +++++++++++++++++++-
 3 files changed, 158 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index c8abb23..e0754a6 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -167,6 +167,7 @@
 <!ENTITY v4l2-event "struct&nbsp;<link linkend='v4l2-event'>v4l2_event</link>">
 <!ENTITY v4l2-event-subscription "struct&nbsp;<link linkend='v4l2-event-subscription'>v4l2_event_subscription</link>">
 <!ENTITY v4l2-event-vsync "struct&nbsp;<link linkend='v4l2-event-vsync'>v4l2_event_vsync</link>">
+<!ENTITY v4l2-event-ctrl "struct&nbsp;<link linkend='v4l2-event-ctrl'>v4l2_event_ctrl</link>">
 <!ENTITY v4l2-ext-control "struct&nbsp;<link linkend='v4l2-ext-control'>v4l2_ext_control</link>">
 <!ENTITY v4l2-ext-controls "struct&nbsp;<link linkend='v4l2-ext-controls'>v4l2_ext_controls</link>">
 <!ENTITY v4l2-fmtdesc "struct&nbsp;<link linkend='v4l2-fmtdesc'>v4l2_fmtdesc</link>">
diff --git a/Documentation/DocBook/v4l/vidioc-dqevent.xml b/Documentation/DocBook/v4l/vidioc-dqevent.xml
index 4e0a7cc..b8c4f76 100644
--- a/Documentation/DocBook/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/v4l/vidioc-dqevent.xml
@@ -81,6 +81,13 @@
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>&v4l2-event-ctrl;</entry>
+            <entry><structfield>ctrl</structfield></entry>
+	    <entry>Event data for event V4L2_EVENT_CTRL.
+            </entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
             <entry><structfield>data</structfield>[64]</entry>
 	    <entry>Event data. Defined by the event type. The union
@@ -110,8 +117,16 @@
 	    <entry>Event timestamp.</entry>
 	  </row>
 	  <row>
+	    <entry>u32</entry>
+	    <entry><structfield>id</structfield></entry>
+            <entry></entry>
+	    <entry>The ID associated with the event source. If the event does not
+		have an associated ID (this depends on the event type), then this
+		is 0.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
             <entry></entry>
 	    <entry>Reserved for future extensions. Drivers must set
 	    the array to zero.</entry>
diff --git a/Documentation/DocBook/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/v4l/vidioc-subscribe-event.xml
index 8b50179..975f603 100644
--- a/Documentation/DocBook/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/v4l/vidioc-subscribe-event.xml
@@ -64,7 +64,19 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[7]</entry>
+	    <entry><structfield>id</structfield></entry>
+	    <entry>ID of the event source. If there is no ID associated with
+		the event source, then set this to 0. Whether or not an event
+		needs an ID depends on the event type.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Event flags, see <xref linkend="event-flags" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[5]</entry>
 	    <entry>Reserved for future extensions. Drivers and applications
 	    must set the array to zero.</entry>
 	  </row>
@@ -100,6 +112,23 @@
 	    </entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_EVENT_CTRL</constant></entry>
+	    <entry>3</entry>
+	    <entry>This event requires that the <structfield>id</structfield>
+		matches the control ID from which you want to receive events.
+		This event is triggered if the control's value changes, if a
+		button control is pressed or if the control's flags change.
+	    	This event has &v4l2-event-ctrl; associated with it. This struct
+		contains much of the same information as &v4l2-queryctrl; and
+		&v4l2-control;.
+
+		If the event is generated due to a call to &VIDIOC-S-CTRL; or
+		&VIDIOC-S-EXT-CTRLS;, then the event will not be sent to
+		the file handle that called the ioctl function. This prevents
+		nasty feedback loops.
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
 	    <entry>0x08000000</entry>
 	    <entry>Base event number for driver-private events.</entry>
@@ -108,6 +137,23 @@
       </tgroup>
     </table>
 
+    <table pgwide="1" frame="none" id="event-flags">
+      <title>Event Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_EVENT_SUB_FL_SEND_INITIAL</constant></entry>
+	    <entry>0x0001</entry>
+	    <entry>When this event is subscribed an initial event will be sent
+		containing the current status. This only makes sense for events
+		that are triggered by a status change. Other events will ignore
+		this flag.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table frame="none" pgwide="1" id="v4l2-event-vsync">
       <title>struct <structname>v4l2_event_vsync</structname></title>
       <tgroup cols="3">
@@ -122,6 +168,100 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="v4l2-event-ctrl">
+      <title>struct <structname>v4l2_event_ctrl</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>changes</structfield></entry>
+	    <entry></entry>
+	    <entry>A bitmask that tells what has changed. See <xref linkend="changes-flags" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry></entry>
+	    <entry>The type of the control. See &v4l2-ctrl-type;.</entry>
+	  </row>
+	  <row>
+	    <entry>union (anonymous)</entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__s32</entry>
+	    <entry><structfield>value</structfield></entry>
+	    <entry>The 32-bit value of the control for 32-bit control types.
+		This is 0 for string controls since the value of a string
+		cannot be passed using &VIDIOC-DQEVENT;.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__s64</entry>
+	    <entry><structfield>value64</structfield></entry>
+	    <entry>The 64-bit value of the control for 64-bit control types.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry></entry>
+	    <entry>The control flags. See <xref linkend="control-flags" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>minimum</structfield></entry>
+	    <entry></entry>
+	    <entry>The minimum value of the control. See &v4l2-queryctrl;.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>maximum</structfield></entry>
+	    <entry></entry>
+	    <entry>The maximum value of the control. See &v4l2-queryctrl;.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>step</structfield></entry>
+	    <entry></entry>
+	    <entry>The step value of the control. See &v4l2-queryctrl;.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>default_value</structfield></entry>
+	    <entry></entry>
+	    <entry>The default value value of the control. See &v4l2-queryctrl;.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="changes-flags">
+      <title>Changes</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_EVENT_CTRL_CH_VALUE</constant></entry>
+	    <entry>0x0001</entry>
+	    <entry>This control event was triggered because the value of the control
+		changed. Special case: if a button control is pressed, then this
+		event is sent as well, even though there is not explicit value
+		associated with a button control.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_CTRL_CH_FLAGS</constant></entry>
+	    <entry>0x0002</entry>
+	    <entry>This control event was triggered because the control flags
+		changed.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
   </refsect1>
 </refentry>
 <!--
-- 
1.7.1

