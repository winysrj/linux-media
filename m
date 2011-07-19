Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43210 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1GSNiK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:38:10 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.50.162])
	by mgw-sa01.nokia.com (Switch-3.4.4/Switch-3.4.3) with ESMTP id p6JDc8J9027233
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:08 +0300
Received: from kaali.localdomain (kaali.localdomain [192.168.239.7])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 9E27D37FCDA
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:08 +0300 (EEST)
Received: from sailus by kaali.localdomain with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1QjAUy-0004Dx-9o
	for linux-media@vger.kernel.org; Tue, 19 Jul 2011 16:38:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC 1/3] v4l: Move event documentation from SUBSCRIBE_EVENT to DQEVENT
Date: Tue, 19 Jul 2011 16:38:06 +0300
Message-Id: <1311082688-16185-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4E2588AD.4070106@maxwell.research.nokia.com>
References: <4E2588AD.4070106@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move documentation of structures used in DQEVENT from SUBSCRIBE_EVENT to
DQEVENT.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  107 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  107 --------------------
 2 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 7769642..5200b68 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -135,6 +135,113 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="v4l2-event-vsync">
+      <title>struct <structname>v4l2_event_vsync</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>field</structfield></entry>
+	    <entry>The upcoming field. See &v4l2-field;.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
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
   </refsect1>
   <refsect1>
     &return-value;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 69c0d8a..275be96 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -183,113 +183,6 @@
       </tgroup>
     </table>
 
-    <table frame="none" pgwide="1" id="v4l2-event-vsync">
-      <title>struct <structname>v4l2_event_vsync</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u8</entry>
-	    <entry><structfield>field</structfield></entry>
-	    <entry>The upcoming field. See &v4l2-field;.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <table frame="none" pgwide="1" id="v4l2-event-ctrl">
-      <title>struct <structname>v4l2_event_ctrl</structname></title>
-      <tgroup cols="4">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>changes</structfield></entry>
-	    <entry></entry>
-	    <entry>A bitmask that tells what has changed. See <xref linkend="changes-flags" />.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>type</structfield></entry>
-	    <entry></entry>
-	    <entry>The type of the control. See &v4l2-ctrl-type;.</entry>
-	  </row>
-	  <row>
-	    <entry>union (anonymous)</entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>__s32</entry>
-	    <entry><structfield>value</structfield></entry>
-	    <entry>The 32-bit value of the control for 32-bit control types.
-		This is 0 for string controls since the value of a string
-		cannot be passed using &VIDIOC-DQEVENT;.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>__s64</entry>
-	    <entry><structfield>value64</structfield></entry>
-	    <entry>The 64-bit value of the control for 64-bit control types.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>flags</structfield></entry>
-	    <entry></entry>
-	    <entry>The control flags. See <xref linkend="control-flags" />.</entry>
-	  </row>
-	  <row>
-	    <entry>__s32</entry>
-	    <entry><structfield>minimum</structfield></entry>
-	    <entry></entry>
-	    <entry>The minimum value of the control. See &v4l2-queryctrl;.</entry>
-	  </row>
-	  <row>
-	    <entry>__s32</entry>
-	    <entry><structfield>maximum</structfield></entry>
-	    <entry></entry>
-	    <entry>The maximum value of the control. See &v4l2-queryctrl;.</entry>
-	  </row>
-	  <row>
-	    <entry>__s32</entry>
-	    <entry><structfield>step</structfield></entry>
-	    <entry></entry>
-	    <entry>The step value of the control. See &v4l2-queryctrl;.</entry>
-	  </row>
-	  <row>
-	    <entry>__s32</entry>
-	    <entry><structfield>default_value</structfield></entry>
-	    <entry></entry>
-	    <entry>The default value value of the control. See &v4l2-queryctrl;.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <table pgwide="1" frame="none" id="changes-flags">
-      <title>Changes</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_EVENT_CTRL_CH_VALUE</constant></entry>
-	    <entry>0x0001</entry>
-	    <entry>This control event was triggered because the value of the control
-		changed. Special case: if a button control is pressed, then this
-		event is sent as well, even though there is not explicit value
-		associated with a button control.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_EVENT_CTRL_CH_FLAGS</constant></entry>
-	    <entry>0x0002</entry>
-	    <entry>This control event was triggered because the control flags
-		changed.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
   </refsect1>
   <refsect1>
     &return-value;
-- 
1.7.2.5

