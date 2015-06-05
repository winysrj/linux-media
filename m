Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56432 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbbFEILh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 04:11:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] DocBook media: correct description of reserved fields
Date: Fri,  5 Jun 2015 10:11:15 +0200
Message-Id: <1433491875-42608-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433491875-42608-1-git-send-email-hverkuil@xs4all.nl>
References: <1433491875-42608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make sure that the documentation clearly states who is zeroing reserved
fields: drivers and/or applications.

This patch syncs the documentation with the checks that v4l2-compliance
and valgrind do.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml                       | 12 ++++++------
 Documentation/DocBook/media/v4l/pixfmt.xml                   |  8 ++++----
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml       |  3 ++-
 .../DocBook/media/v4l/vidioc-enum-frameintervals.xml         |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml   |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml            |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml       |  2 +-
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml          |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml           |  4 ++--
 9 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index bfe6662..7bbc2a4 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -841,15 +841,15 @@ is the file descriptor associated with a DMABUF buffer.</entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved2</structfield></entry>
 	    <entry></entry>
-	    <entry>A place holder for future extensions. Applications
-should set this to 0.</entry>
+	    <entry>A place holder for future extensions. Drivers and applications
+must set this to 0.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield></entry>
 	    <entry></entry>
-	    <entry>A place holder for future extensions. Applications
-should set this to 0.</entry>
+	    <entry>A place holder for future extensions. Drivers and applications
+must set this to 0.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -930,8 +930,8 @@ should set this to 0.</entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[11]</structfield></entry>
 	    <entry></entry>
-	    <entry>Reserved for future use. Should be zeroed by an
-	    application.</entry>
+	    <entry>Reserved for future use. Should be zeroed by drivers and
+	    applications.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 6c3d653..8d95172 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -190,8 +190,8 @@ see <xref linkend="colorspaces" />.</entry>
         <row>
           <entry>__u16</entry>
           <entry><structfield>reserved[6]</structfield></entry>
-          <entry>Reserved for future extensions. Should be zeroed by the
-           application.</entry>
+          <entry>Reserved for future extensions. Should be zeroed by drivers and
+           applications.</entry>
         </row>
       </tbody>
     </tgroup>
@@ -267,8 +267,8 @@ see <xref linkend="colorspaces" />.</entry>
         <row>
           <entry>__u8</entry>
           <entry><structfield>reserved[8]</structfield></entry>
-          <entry>Reserved for future extensions. Should be zeroed by the
-           application.</entry>
+          <entry>Reserved for future extensions. Should be zeroed by drivers
+           and applications.</entry>
         </row>
       </tbody>
     </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 9b700a5..8ffe74f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -134,7 +134,8 @@ information.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[8]</entry>
-	    <entry>A place holder for future extensions.</entry>
+	    <entry>A place holder for future extensions. Drivers and applications
+must set the array to zero.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
index 5fd72c4..7c839ab 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
@@ -217,7 +217,8 @@ enumerated.</entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[2]</structfield></entry>
 	    <entry></entry>
-	    <entry>Reserved space for future use.</entry>
+	    <entry>Reserved space for future use. Must be zeroed by drivers and
+	    applications.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
index a78454b..9ed68ac 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
@@ -223,7 +223,8 @@ application should zero out all members except for the
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[2]</structfield></entry>
 	    <entry></entry>
-	    <entry>Reserved space for future use.</entry>
+	    <entry>Reserved space for future use. Must be zeroed by drivers and
+	    applications.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
index 4165e7b..a78c920 100644
--- a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -184,7 +184,8 @@ of open() for more details.</entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[11]</structfield></entry>
-	    <entry>Reserved field for future use. Must be set to zero.</entry>
+	    <entry>Reserved field for future use. Drivers and applications must
+set the array to zero.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index 0bb5c06..7865351 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -199,7 +199,7 @@ exist no rectangle</emphasis> that satisfies the constraints.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved[9]</structfield></entry>
-	    <entry>Reserved fields for future use.</entry>
+	    <entry>Reserved fields for future use. Drivers and applications must zero this array.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
index a597155..50bfcb5 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
@@ -60,7 +60,8 @@ buffer at any time after buffers have been allocated with the
     field. Valid index numbers range from zero
 to the number of buffers allocated with &VIDIOC-REQBUFS;
     (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.
-The <structfield>reserved</structfield> field should to set to 0.
+The <structfield>reserved</structfield> and <structfield>reserved2 </structfield>
+fields must be set to 0.
 When using the <link linkend="planar-apis">multi-planar API</link>, the
 <structfield>m.planes</structfield> field must contain a userspace pointer to an
 array of &v4l2-plane; and the <structfield>length</structfield> field has
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index 78a06a9..0f193fd 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -112,8 +112,8 @@ as the &v4l2-format; <structfield>type</structfield> field. See <xref
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[2]</entry>
-	    <entry>A place holder for future extensions. This array should
-be zeroed by applications.</entry>
+	    <entry>A place holder for future extensions. Drivers and applications
+must set the array to zero.</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
2.1.4

