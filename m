Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36480 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760872AbbCDJtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:49:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/8] DocBook media: document the new 'which' field.
Date: Wed,  4 Mar 2015 10:47:59 +0100
Message-Id: <1425462481-8200-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The subdev enum ioctls now have a new 'which' field. Document this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml | 13 +++++++++----
 .../DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml     | 13 +++++++++----
 .../DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml      | 11 ++++++++---
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
index 2f8f4f0..cff59f5 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
@@ -67,9 +67,9 @@
 
     <para>To enumerate frame intervals applications initialize the
     <structfield>index</structfield>, <structfield>pad</structfield>,
-    <structfield>code</structfield>, <structfield>width</structfield> and
-    <structfield>height</structfield> fields of
-    &v4l2-subdev-frame-interval-enum; and call the
+    <structfield>which</structfield>, <structfield>code</structfield>,
+    <structfield>width</structfield> and <structfield>height</structfield>
+    fields of &v4l2-subdev-frame-interval-enum; and call the
     <constant>VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL</constant> ioctl with a pointer
     to this structure. Drivers fill the rest of the structure or return
     an &EINVAL; if one of the input fields is invalid. All frame intervals are
@@ -123,7 +123,12 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry>Frame intervals to be enumerated, from &v4l2-subdev-format-whence;.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
index 79ce42b..abd545e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
@@ -61,9 +61,9 @@
     ioctl.</para>
 
     <para>To enumerate frame sizes applications initialize the
-    <structfield>pad</structfield>, <structfield>code</structfield> and
-    <structfield>index</structfield> fields of the
-    &v4l2-subdev-mbus-code-enum; and call the
+    <structfield>pad</structfield>, <structfield>which</structfield> ,
+    <structfield>code</structfield> and <structfield>index</structfield>
+    fields of the &v4l2-subdev-mbus-code-enum; and call the
     <constant>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</constant> ioctl with a pointer to
     the structure. Drivers fill the minimum and maximum frame sizes or return
     an &EINVAL; if one of the input parameters is invalid.</para>
@@ -127,7 +127,12 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry>Frame sizes to be enumerated, from &v4l2-subdev-format-whence;.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
index a6b3432..0bcb278 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
@@ -56,8 +56,8 @@
     </note>
 
     <para>To enumerate media bus formats available at a given sub-device pad
-    applications initialize the <structfield>pad</structfield> and
-    <structfield>index</structfield> fields of &v4l2-subdev-mbus-code-enum; and
+    applications initialize the <structfield>pad</structfield>, <structfield>which</structfield>
+    and <structfield>index</structfield> fields of &v4l2-subdev-mbus-code-enum; and
     call the <constant>VIDIOC_SUBDEV_ENUM_MBUS_CODE</constant> ioctl with a
     pointer to this structure. Drivers fill the rest of the structure or return
     an &EINVAL; if either the <structfield>pad</structfield> or
@@ -93,7 +93,12 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry>Media bus format codes to be enumerated, from &v4l2-subdev-format-whence;.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
-- 
2.1.4

