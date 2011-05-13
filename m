Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50488 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab1EMJK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 05:10:59 -0400
Received: from localhost.localdomain (150.165-65-87.adsl-dyn.isp.belgacom.be [87.65.165.150])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 07356359A1
	for <linux-media@vger.kernel.org>; Fri, 13 May 2011 09:10:57 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2] v4l: Add M420 format definition
Date: Fri, 13 May 2011 11:11:55 +0200
Message-Id: <1305277915-8383-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Hans de Goede <hdegoede@redhat.com>

M420 is an hybrid YUV 4:2:2 packet/planar format. Two Y lines are
followed by an interleaved U/V line.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[laurent.pinchart@ideasonboard.com: split into v4l/uvcvideo patches]
[laurent.pinchart@ideasonboard.com: add documentation]
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-m420.xml |  147 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    1 +
 include/linux/videodev2.h                 |    1 +
 5 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-m420.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 7a95708..c8abb23 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -270,6 +270,7 @@
 <!ENTITY sub-write SYSTEM "v4l/func-write.xml">
 <!ENTITY sub-io SYSTEM "v4l/io.xml">
 <!ENTITY sub-grey SYSTEM "v4l/pixfmt-grey.xml">
+<!ENTITY sub-m420 SYSTEM "v4l/pixfmt-m420.xml">
 <!ENTITY sub-nv12 SYSTEM "v4l/pixfmt-nv12.xml">
 <!ENTITY sub-nv12m SYSTEM "v4l/pixfmt-nv12m.xml">
 <!ENTITY sub-nv12mt SYSTEM "v4l/pixfmt-nv12mt.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt-m420.xml b/Documentation/DocBook/v4l/pixfmt-m420.xml
new file mode 100644
index 0000000..ce4bc01
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-m420.xml
@@ -0,0 +1,147 @@
+    <refentry id="V4L2-PIX-FMT-M420">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_M420 ('M420')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname><constant>V4L2_PIX_FMT_M420</constant></refname>
+	<refpurpose>Format with &frac12; horizontal and vertical chroma
+	resolution, also known as YUV 4:2:0. Hybrid plane line-interleaved
+	layout.</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>M420 is a YUV format with &frac12; horizontal and vertical chroma
+	subsampling (YUV 4:2:0). Pixels are organized as interleaved luma and
+	chroma planes. Two lines of luma data are followed by one line of chroma
+	data.</para>
+	<para>The luma plane has one byte per pixel. The chroma plane contains
+	interleaved CbCr pixels subsampled by &frac12; in the horizontal and
+	vertical directions. Each CbCr pair belongs to four pixels. For example,
+Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
+Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
+Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.</para>
+
+	<para>All line lengths are identical: if the Y lines include pad bytes
+	so do the CbCr lines.</para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_M420</constant> 4 &times; 4
+pixel image</title>
+
+	  <formalpara>
+	    <title>Byte Order.</title>
+	    <para>Each cell is one byte.
+		<informaltable frame="none">
+		<tgroup cols="5" align="center">
+		  <colspec align="left" colwidth="2*" />
+		  <tbody valign="top">
+		    <row>
+		      <entry>start&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;8:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;16:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;20:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;24:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+
+	  <formalpara>
+	    <title>Color Sample Location.</title>
+	    <para>
+		<informaltable frame="none">
+		<tgroup cols="7" align="center">
+		  <tbody valign="top">
+		    <row>
+		      <entry></entry>
+		      <entry>0</entry><entry></entry><entry>1</entry><entry></entry>
+		      <entry>2</entry><entry></entry><entry>3</entry>
+		    </row>
+		    <row>
+		      <entry>0</entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry></entry>
+		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
+		      <entry></entry><entry>C</entry><entry></entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry></entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry></entry>
+		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
+		      <entry></entry><entry>C</entry><entry></entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry></entry><entry>Y</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
+
+  <!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "pixfmt.sgml"
+indent-tabs-mode: nil
+End:
+  -->
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index 3486a06..dbfe3b0 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -713,6 +713,7 @@ information.</para>
     &sub-nv12m;
     &sub-nv12mt;
     &sub-nv16;
+    &sub-m420;
   </section>
 
   <section>
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 937acf5..c50536a 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -336,6 +336,7 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
 #define <link linkend="V4L2-PIX-FMT-YUV420">V4L2_PIX_FMT_YUV420</link>  v4l2_fourcc('Y', 'U', '1', '2') /* 12  YUV 4:2:0     */
 #define <link linkend="V4L2-PIX-FMT-HI240">V4L2_PIX_FMT_HI240</link>   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit color   */
 #define <link linkend="V4L2-PIX-FMT-HM12">V4L2_PIX_FMT_HM12</link>    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
+#define <link linkend="V4L2-PIX-FMT-M420">V4L2_PIX_FMT_M420</link>    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
 
 /* two planes -- one Y, one Cr + Cb interleaved  */
 #define <link linkend="V4L2-PIX-FMT-NV12">V4L2_PIX_FMT_NV12</link>    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a417270..8a4c309 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -336,6 +336,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_YUV420  v4l2_fourcc('Y', 'U', '1', '2') /* 12  YUV 4:2:0     */
 #define V4L2_PIX_FMT_HI240   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit color   */
 #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
+#define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
 
 /* two planes -- one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
-- 
1.7.3.4

