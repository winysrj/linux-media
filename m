Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1047 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HZMA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 1/8] videodev2.h: add V4L2_CTRL_FLAG_VOLATILE.
Date: Fri, 26 Aug 2011 14:00:06 +0200
Message-Id: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new VOLATILE control flag that is set for volatile controls.
That way applications know whether the value of the control is volatile
(i.e. can change continuously) or not.

Until now this was an internal property, but it is useful to know in
userspace as well.

A typical use case is the gain value when autogain is on. In that case the
hardware will continuously adjust the gain based various environmental
factors.

This patch just adds and documents the flag, it's not yet used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    8 ++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 ++++++++-
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |    9 +++++++++
 include/linux/videodev2.h                          |    1 +
 4 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index ce1004a..91410b6 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2370,6 +2370,14 @@ that used it. It was originally scheduled for removal in 2.6.35.
         </listitem>
       </orderedlist>
     </section>
+    <section>
+      <title>V4L2 in Linux 3.2</title>
+      <orderedlist>
+        <listitem>
+	  <para>V4L2_CTRL_FLAG_VOLATILE was added to signal volatile controls to userspace.</para>
+        </listitem>
+      </orderedlist>
+    </section>
 
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 0d05e87..40132c2 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.2</revnumber>
+	<date>2011-08-26</date>
+	<authorinitials>hv</authorinitials>
+	<revremark>Added V4L2_CTRL_FLAG_VOLATILE.</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.1</revnumber>
 	<date>2011-06-27</date>
 	<authorinitials>mcc, po, hv</authorinitials>
@@ -410,7 +417,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.1</subtitle>
+ <subtitle>Revision 3.2</subtitle>
 
   <chapter id="common">
     &sub-common;
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 677ea64..0ac0057 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -406,6 +406,15 @@ flag is typically present for relative controls or action controls where
 writing a value will cause the device to carry out a given action
 (&eg; motor control) but no meaningful value can be returned.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_FLAG_VOLATILE</constant></entry>
+	    <entry>0x0080</entry>
+	    <entry>This control is volatile, which means that the value of the control
+changes continuously. A typical example would be the current gain value if the device
+is in auto-gain mode. In such a case the hardware calculates the gain value based on
+the lighting conditions which can change over time. Note that setting a new value for
+a volatile control will have no effect. The new value will just be ignored.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fca24cc..c027766 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1082,6 +1082,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_INACTIVE 	0x0010
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
+#define V4L2_CTRL_FLAG_VOLATILE		0x0080
 
 /*  Query flag, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
-- 
1.7.5.4

