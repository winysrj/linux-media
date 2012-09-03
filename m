Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2657 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2ICNsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/10] DocBook: deprecate V4L2_BUF_TYPE_PRIVATE.
Date: Mon,  3 Sep 2012 15:48:41 +0200
Message-Id: <09164b905bb3020751b6a3f101c4f52257570ff7.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
References: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As per decision taken during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml          |    2 +-
 Documentation/DocBook/media/v4l/io.xml              |   14 ++------------
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml  |    6 ++----
 Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml |    6 ++----
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml   |    6 ++----
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml    |    4 +---
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml   |    4 +---
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml  |    5 ++---
 8 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 578135e..c6ae4c9 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -1476,7 +1476,7 @@ follows.<informaltable>
 		  </row>
 		  <row>
 		    <entry><constant>V4L2_BUF_TYPE_PRIVATE_BASE</constant></entry>
-		    <entry><constant>V4L2_BUF_TYPE_PRIVATE</constant></entry>
+		    <entry><constant>V4L2_BUF_TYPE_PRIVATE</constant> (but this is deprecated)</entry>
 		  </row>
 		</tbody>
 	      </tgroup>
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2512649..2dc39d8 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -685,18 +685,14 @@ memory, set by the application. See <xref linkend="userp" /> for details.
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved2</structfield></entry>
 	    <entry></entry>
-	    <entry>A place holder for future extensions and custom
-(driver defined) buffer types
-<constant>V4L2_BUF_TYPE_PRIVATE</constant> and higher. Applications
+	    <entry>A place holder for future extensions. Applications
 should set this to 0.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield></entry>
 	    <entry></entry>
-	    <entry>A place holder for future extensions and custom
-(driver defined) buffer types
-<constant>V4L2_BUF_TYPE_PRIVATE</constant> and higher. Applications
+	    <entry>A place holder for future extensions. Applications
 should set this to 0.</entry>
 	  </row>
 	</tbody>
@@ -829,12 +825,6 @@ should set this to 0.</entry>
 	    <entry>Buffer for video output overlay (OSD), see <xref
 		linkend="osd" />.</entry>
 	  </row>
-	  <row>
-	    <entry><constant>V4L2_BUF_TYPE_PRIVATE</constant></entry>
-	    <entry>0x80</entry>
-	  <entry>This and higher values are reserved for custom
-(driver defined) buffer types.</entry>
-	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index f1bac2c..4559c45 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -70,10 +70,8 @@ output.</para>
 	    <entry>Type of the data stream, set by the application.
 Only these types are valid here:
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
-defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
-and higher. See <xref linkend="v4l2-buf-type" />.</entry>
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
 	    <entry>struct <link linkend="v4l2-rect-crop">v4l2_rect</link></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
index 0bd3324..f8dfeed 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
@@ -81,10 +81,8 @@ Only these types are valid here:
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>,
 <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
-defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
-and higher. See <xref linkend="v4l2-buf-type" />.</entry>
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
index c4ff3b1..75c6a93 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
@@ -104,10 +104,8 @@ changed and <constant>VIDIOC_S_CROP</constant> returns the
 	    <entry><structfield>type</structfield></entry>
 	    <entry>Type of the data stream, set by the application.
 Only these types are valid here: <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
-defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
-and higher. See <xref linkend="v4l2-buf-type" />.</entry>
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
 	    <entry>&v4l2-rect;</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index 9ef279a..6b16af95 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -174,9 +174,7 @@ capture and output devices.</entry>
 	    <entry></entry>
 	    <entry>__u8</entry>
 	    <entry><structfield>raw_data</structfield>[200]</entry>
-	    <entry>Place holder for future extensions and custom
-(driver defined) formats with <structfield>type</structfield>
-<constant>V4L2_BUF_TYPE_PRIVATE</constant> and higher.</entry>
+	    <entry>Place holder for future extensions.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index f83d2cd..9058224 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
@@ -108,9 +108,7 @@ devices.</para>
 	    <entry></entry>
 	    <entry>__u8</entry>
 	    <entry><structfield>raw_data</structfield>[200]</entry>
-	    <entry>A place holder for future extensions and custom
-(driver defined) buffer types <constant>V4L2_BUF_TYPE_PRIVATE</constant> and
-higher.</entry>
+	    <entry>A place holder for future extensions.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index d7c9505..2b50ef2 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -109,9 +109,8 @@ as the &v4l2-format; <structfield>type</structfield> field. See <xref
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[2]</entry>
-	    <entry>A place holder for future extensions and custom
-(driver defined) buffer types <constant>V4L2_BUF_TYPE_PRIVATE</constant> and
-higher. This array should be zeroed by applications.</entry>
+	    <entry>A place holder for future extensions. This array should
+be zeroed by applications.</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
1.7.10.4

