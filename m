Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcE0MsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:48:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 5/6] v4l: Add 14-bit raw bayer pixel format definitions
Date: Fri, 27 May 2016 15:44:39 +0300
Message-Id: <1464353080-18300-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:

	V4L2_PIX_FMT_SBGGR14
	V4L2_PIX_FMT_SGBRG14
	V4L2_PIX_FMT_SGRBG14
	V4L2_PIX_FMT_SRGGB14

Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb14.xml | 90 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
 include/uapi/linux/videodev2.h                     |  4 +
 3 files changed, 95 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb14.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml
new file mode 100644
index 0000000..7e82d7e
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb14.xml
@@ -0,0 +1,90 @@
+    <refentry>
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_SRGGB14 ('RG14'),
+	 V4L2_PIX_FMT_SGRBG14 ('BA14'),
+	 V4L2_PIX_FMT_SGBRG14 ('GB14'),
+	 V4L2_PIX_FMT_SBGGR14 ('BG14'),
+	 </refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-SRGGB14"><constant>V4L2_PIX_FMT_SRGGB14</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGRBG14"><constant>V4L2_PIX_FMT_SGRBG14</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGBRG14"><constant>V4L2_PIX_FMT_SGBRG14</constant></refname>
+	<refname id="V4L2-PIX-FMT-SBGGR14"><constant>V4L2_PIX_FMT_SBGGR14</constant></refname>
+	<refpurpose>14-bit Bayer formats expanded to 16 bits</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>These four pixel formats are raw sRGB / Bayer formats with
+14 bits per colour. Each colour component is stored in a 16-bit word, with 2
+unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
+and n/2 blue or red samples, with alternating red and blue rows. Bytes are
+stored in memory in little endian order. They are conventionally described
+as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
+formats</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_SBGGR14</constant> 4 &times; 4
+pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte, high 2 bits in high bytes are 0.
+	  <informaltable frame="none">
+	    <tgroup cols="5" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start&nbsp;+&nbsp;0:</entry>
+		  <entry>B<subscript>00low</subscript></entry>
+		  <entry>B<subscript>00high</subscript></entry>
+		  <entry>G<subscript>01low</subscript></entry>
+		  <entry>G<subscript>01high</subscript></entry>
+		  <entry>B<subscript>02low</subscript></entry>
+		  <entry>B<subscript>02high</subscript></entry>
+		  <entry>G<subscript>03low</subscript></entry>
+		  <entry>G<subscript>03high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;8:</entry>
+		  <entry>G<subscript>10low</subscript></entry>
+		  <entry>G<subscript>10high</subscript></entry>
+		  <entry>R<subscript>11low</subscript></entry>
+		  <entry>R<subscript>11high</subscript></entry>
+		  <entry>G<subscript>12low</subscript></entry>
+		  <entry>G<subscript>12high</subscript></entry>
+		  <entry>R<subscript>13low</subscript></entry>
+		  <entry>R<subscript>13high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;16:</entry>
+		  <entry>B<subscript>20low</subscript></entry>
+		  <entry>B<subscript>20high</subscript></entry>
+		  <entry>G<subscript>21low</subscript></entry>
+		  <entry>G<subscript>21high</subscript></entry>
+		  <entry>B<subscript>22low</subscript></entry>
+		  <entry>B<subscript>22high</subscript></entry>
+		  <entry>G<subscript>23low</subscript></entry>
+		  <entry>G<subscript>23high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;24:</entry>
+		  <entry>G<subscript>30low</subscript></entry>
+		  <entry>G<subscript>30high</subscript></entry>
+		  <entry>R<subscript>31low</subscript></entry>
+		  <entry>R<subscript>31high</subscript></entry>
+		  <entry>G<subscript>32low</subscript></entry>
+		  <entry>G<subscript>32high</subscript></entry>
+		  <entry>R<subscript>33low</subscript></entry>
+		  <entry>R<subscript>33high</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 457337e..29e9d7c 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1594,6 +1594,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-srggb10dpcm8;
     &sub-srggb12;
     &sub-srggb12p;
+    &sub-srggb14;
   </section>
 
   <section id="yuv-formats">
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 7ace868..2c4b076 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -581,6 +581,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
 #define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
 #define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
+#define V4L2_PIX_FMT_SBGGR14 v4l2_fourcc('B', 'G', '1', '4') /* 14  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG14 v4l2_fourcc('G', 'B', '1', '4') /* 14  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG14 v4l2_fourcc('B', 'A', '1', '4') /* 14  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB14 v4l2_fourcc('R', 'G', '1', '4') /* 14  RGRG.. GBGB.. */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
1.9.1

