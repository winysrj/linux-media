Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2453 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268AbaFLLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 18/34] DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
Date: Thu, 12 Jun 2014 13:52:50 +0200
Message-Id: <f8654a8eec1e71f2df38d27d6cefb0e9bd600c8f.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the support for the new compound type controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 37 +++++++++++++++++-----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index e9f6735..2a157b3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -72,23 +72,30 @@ initialize the <structfield>id</structfield>,
 <structfield>size</structfield> and <structfield>reserved2</structfield> fields
 of each &v4l2-ext-control; and call the
 <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
-must also set the <structfield>string</structfield> field.</para>
+must also set the <structfield>string</structfield> field. Controls
+of compound types (<constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is set)
+must set the <structfield>ptr</structfield> field.</para>
 
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
 
+    <para>N-dimensional arrays are set and retrieved row-by-row. You cannot set a partial
+array, all elements have to be set or retrieved. The total size is calculated
+as <structfield>elems</structfield> * <structfield>elem_size</structfield>.
+These values can be obtained by calling &VIDIOC-QUERY-EXT-CTRL;.</para>
+
     <para>To change the value of a set of controls applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
 <structfield>reserved2</structfield> and
-<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
+<structfield>value/value64/string/ptr</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_S_EXT_CTRLS</constant> ioctl. The controls
 will only be set if <emphasis>all</emphasis> control values are
 valid.</para>
@@ -96,7 +103,7 @@ valid.</para>
     <para>To check if a set of controls have correct values applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
 <structfield>reserved2</structfield> and
-<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
+<structfield>value/value64/string/ptr</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctl. It is up to
 the driver whether wrong values are automatically adjusted to a valid
 value or if an error is returned.</para>
@@ -158,19 +165,33 @@ applications must set the array to zero.</entry>
 	    <entry></entry>
 	    <entry>__s32</entry>
 	    <entry><structfield>value</structfield></entry>
-	    <entry>New value or current value.</entry>
+	    <entry>New value or current value. Valid if this control is not of
+type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
+<constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is not set.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>__s64</entry>
 	    <entry><structfield>value64</structfield></entry>
-	    <entry>New value or current value.</entry>
+	    <entry>New value or current value. Valid if this control is of
+type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
+<constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is not set.</entry>
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
+	    <entry><structfield>ptr</structfield></entry>
+	    <entry>A pointer to a compound type which can be an N-dimensional array and/or a
+compound type (the control's type is >= <constant>V4L2_CTRL_COMPOUND_TYPES</constant>).
+Valid if <constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is set for this control.
+</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
2.0.0.rc0

