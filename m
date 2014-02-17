Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2436 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaBQKIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 05:08:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 30/35] DocBook: document new v4l motion detection event.
Date: Mon, 17 Feb 2014 10:57:45 +0100
Message-Id: <1392631070-41868-31-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new motion detection event.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 44 ++++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  8 ++++
 2 files changed, 52 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 89891ad..ffa1fac 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -94,6 +94,12 @@
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>&v4l2-event-motion-det;</entry>
+            <entry><structfield>motion_det</structfield></entry>
+	    <entry>Event data for event V4L2_EVENT_MOTION_DET.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
             <entry><structfield>data</structfield>[64]</entry>
 	    <entry>Event data. Defined by the event type. The union
@@ -242,6 +248,44 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="v4l2-event-motion-det">
+      <title>struct <structname>v4l2_event_motion_det</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>
+	      Currently only one flag is available: if <constant>V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ</constant>
+	      is set, then the <structfield>frame_sequence</structfield> field is valid,
+	      otherwise that field should be ignored.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>frame_sequence</structfield></entry>
+	    <entry>
+	      The sequence number of the frame being received. Only valid if the
+	      <constant>V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ</constant> flag was set.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>region_mask</structfield></entry>
+	    <entry>
+	      The bitmask of the regions that reported motion. There is at least one
+	      region. If this field is 0, then no motion was detected at all.
+	      If there is no <constant>V4L2_CID_DETECT_MD_REGION_GRID</constant> control
+	      (see <xref linkend="detect-controls" />) to assign a different region
+	      to each cell in the motion detection grid, then that all cells
+	      are automatically assigned to the default region 0.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table pgwide="1" frame="none" id="changes-flags">
       <title>Changes</title>
       <tgroup cols="3">
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 5c70b61..9e68976 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -155,6 +155,14 @@
 	    </entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
+	    <entry>5</entry>
+	    <entry>
+	      <para>Triggered whenever the motion detection state for one or more of the regions
+	      changes. This event has a &v4l2-event-motion-det; associated with it.</para>
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
 	    <entry>0x08000000</entry>
 	    <entry>Base event number for driver-private events.</entry>
-- 
1.8.4.rc3

