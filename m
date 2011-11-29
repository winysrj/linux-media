Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57670 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1K2K05 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 05:26:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 2/3] v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
Date: Tue, 29 Nov 2011 11:26:58 +0100
Message-Id: <1322562419-9934-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NV24 and NV42 are planar YCbCr 4:4:4 and YCrCb 4:4:4 formats with a
luma plane followed by an interleaved chroma plane.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  129 +++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
 include/linux/videodev2.h                       |    2 +
 3 files changed, 132 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv24.xml b/Documentation/DocBook/media/v4l/pixfmt-nv24.xml
new file mode 100644
index 0000000..939c803
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv24.xml
@@ -0,0 +1,129 @@
+    <refentry>
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_NV24 ('NV24'), V4L2_PIX_FMT_NV42 ('NV42')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-NV24"><constant>V4L2_PIX_FMT_NV24</constant></refname>
+	<refname id="V4L2-PIX-FMT-NV42"><constant>V4L2_PIX_FMT_NV42</constant></refname>
+	<refpurpose>Formats with full horizontal and vertical
+chroma resolutions, also known as YUV 4:4:4. One luminance and one
+chrominance plane with alternating chroma samples as opposed to
+<constant>V4L2_PIX_FMT_YVU420</constant></refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>These are two-plane versions of the YUV 4:4:4 format. The three
+	components are separated into two sub-images or planes. The Y plane is
+	first, with each Y sample stored in one byte per pixel. For
+	<constant>V4L2_PIX_FMT_NV24</constant>, a combined CbCr plane
+	immediately follows the Y plane in memory. The CbCr plane has the same
+	width and height, in pixels, as the Y plane (and the image). Each line
+	contains one CbCr pair per pixel, with each Cb and Cr sample stored in
+	one byte. <constant>V4L2_PIX_FMT_NV42</constant> is the same except that
+	the Cb and Cr samples are swapped, the CrCb plane starts with a Cr
+	sample.</para>
+
+	<para>If the Y plane has pad bytes after each row, then the CbCr plane
+	has twice as many pad bytes after its rows.</para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_NV24</constant> 4 &times; 4
+pixel image</title>
+
+	  <formalpara>
+	    <title>Byte Order.</title>
+	    <para>Each cell is one byte.
+		<informaltable frame="none">
+		<tgroup cols="9" align="center">
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
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;16:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		      <entry>Cb<subscript>02</subscript></entry>
+		      <entry>Cr<subscript>02</subscript></entry>
+		      <entry>Cb<subscript>03</subscript></entry>
+		      <entry>Cr<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;24:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		      <entry>Cb<subscript>12</subscript></entry>
+		      <entry>Cr<subscript>12</subscript></entry>
+		      <entry>Cb<subscript>13</subscript></entry>
+		      <entry>Cr<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;32:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		      <entry>Cb<subscript>22</subscript></entry>
+		      <entry>Cr<subscript>22</subscript></entry>
+		      <entry>Cb<subscript>23</subscript></entry>
+		      <entry>Cr<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;40:</entry>
+		      <entry>Cb<subscript>30</subscript></entry>
+		      <entry>Cr<subscript>30</subscript></entry>
+		      <entry>Cb<subscript>31</subscript></entry>
+		      <entry>Cr<subscript>31</subscript></entry>
+		      <entry>Cb<subscript>32</subscript></entry>
+		      <entry>Cr<subscript>32</subscript></entry>
+		      <entry>Cb<subscript>33</subscript></entry>
+		      <entry>Cr<subscript>33</subscript></entry>
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
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 2ff6b77..aef4615 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -714,6 +714,7 @@ information.</para>
     &sub-nv12m;
     &sub-nv12mt;
     &sub-nv16;
+    &sub-nv24;
     &sub-m420;
   </section>
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..d2f74f8 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -343,6 +343,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
 #define V4L2_PIX_FMT_NV16    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
+#define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
+#define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
-- 
1.7.3.4

