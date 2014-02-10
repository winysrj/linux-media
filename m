Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1250 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaBJIsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:48:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 20/34] DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
Date: Mon, 10 Feb 2014 09:46:45 +0100
Message-Id: <1392022019-5519-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the support for the new complex type controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 43 ++++++++++++++++++----
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index b3bb957..d946d6b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -72,23 +72,30 @@ initialize the <structfield>id</structfield>,
 <structfield>size</structfield> and <structfield>reserved2</structfield> fields
 of each &v4l2-ext-control; and call the
 <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
-must also set the <structfield>string</structfield> field.</para>
+must also set the <structfield>string</structfield> field. Controls
+of complex types (<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is set)
+must set the <structfield>p</structfield> field.</para>
 
     <para>If the <structfield>size</structfield> is too small to
 receive the control result (only relevant for pointer-type controls
 like strings), then the driver will set <structfield>size</structfield>
 to a valid value and return an &ENOSPC;. You should re-allocate the
-string memory to this new size and try again. It is possible that the
-same issue occurs again if the string has grown in the meantime. It is
+memory to this new size and try again. For the string type it is possible that
+the same issue occurs again if the string has grown in the meantime. It is
 recommended to call &VIDIOC-QUERYCTRL; first and use
 <structfield>maximum</structfield>+1 as the new <structfield>size</structfield>
 value. It is guaranteed that that is sufficient memory.
 </para>
 
+    <para>Matrices are set and retrieved row-by-row. You cannot set a partial
+matrix, all elements have to be set or retrieved. The total size is calculated
+as <structfield>rows</structfield> * <structfield>cols</structfield> * <structfield>elem_size</structfield>.
+These values can be obtained by calling &VIDIOC-QUERY-EXT-CTRL;.</para>
+
     <para>To change the value of a set of controls applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
 <structfield>reserved2</structfield> and
-<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
+<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_S_EXT_CTRLS</constant> ioctl. The controls
 will only be set if <emphasis>all</emphasis> control values are
 valid.</para>
@@ -96,11 +103,17 @@ valid.</para>
     <para>To check if a set of controls have correct values applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
 <structfield>reserved2</structfield> and
-<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
+<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctl. It is up to
 the driver whether wrong values are automatically adjusted to a valid
 value or if an error is returned.</para>
 
+    <para>For matrices it is possible to only set or check only the first
+<constant>X</constant> elements by setting size to <constant>X * elem_size</constant>,
+where <structfield>elem_size</structfield> is obtained by calling &VIDIOC-QUERY-EXT-CTRL;.
+Matrix elements are set row-by-row. Matrix elements that are not explicitly
+set will be initialized to their default value.</para>
+
     <para>When the <structfield>id</structfield> or
 <structfield>ctrl_class</structfield> is invalid drivers return an
 &EINVAL;. When the value is out of bounds drivers can choose to take
@@ -158,19 +171,33 @@ applications must set the array to zero.</entry>
 	    <entry></entry>
 	    <entry>__s32</entry>
 	    <entry><structfield>value</structfield></entry>
-	    <entry>New value or current value.</entry>
+	    <entry>New value or current value. Valid if this control is not of
+type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
+<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is not set.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>__s64</entry>
 	    <entry><structfield>value64</structfield></entry>
-	    <entry>New value or current value.</entry>
+	    <entry>New value or current value. Valid if this control is of
+type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
+<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is not set.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>char *</entry>
 	    <entry><structfield>string</structfield></entry>
-	    <entry>A pointer to a string.</entry>
+	    <entry>A pointer to a string. Valid if this control is of
+type <constant>V4L2_CTRL_TYPE_STRING</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>void *</entry>
+	    <entry><structfield>p</structfield></entry>
+	    <entry>A pointer to a complex type which can be a matrix and/or a
+complex type (the control's type is >= <constant>V4L2_CTRL_COMPLEX_TYPES</constant>).
+Valid if <constant>V4L2_CTRL_FLAG_IS_PTR</constant> is set for this control.
+</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
1.8.5.2

