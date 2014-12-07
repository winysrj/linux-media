Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43948 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752674AbaLGXXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 18:23:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: aviv.d.greenberg@intel.com
Subject: [REVIEW PATCH v2 3/3] v4l: Add packed Bayer raw10 pixel formats
Date: Mon,  8 Dec 2014 01:22:22 +0200
Message-Id: <1417994542-25826-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1417994542-25826-1-git-send-email-sakari.ailus@iki.fi>
References: <1417994542-25826-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aviv Greenberg <aviv.d.greenberg@intel.com>

These formats are just like 10-bit raw bayer formats that exist already, but
the pixels are not padded to byte boundaries. Instead, the eight high order
bits of four consecutive pixels are stored in four bytes, followed by a byte
of two low order bits of each of the four pixels.

Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          |   99 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 include/uapi/linux/videodev2.h                     |    5 +
 3 files changed, 105 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
new file mode 100644
index 0000000..30aa635
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
@@ -0,0 +1,99 @@
+    <refentry id="pixfmt-srggb10p">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_SRGGB10P ('pRAA'),
+	 V4L2_PIX_FMT_SGRBG10P ('pgAA'),
+	 V4L2_PIX_FMT_SGBRG10P ('pGAA'),
+	 V4L2_PIX_FMT_SBGGR10P ('pBAA'),
+	 </refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-SRGGB10P"><constant>V4L2_PIX_FMT_SRGGB10P</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGRBG10P"><constant>V4L2_PIX_FMT_SGRBG10P</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGBRG10P"><constant>V4L2_PIX_FMT_SGBRG10P</constant></refname>
+	<refname id="V4L2-PIX-FMT-SBGGR10P"><constant>V4L2_PIX_FMT_SBGGR10P</constant></refname>
+	<refpurpose>10-bit packed Bayer formats</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>These four pixel formats are packed raw sRGB /
+	Bayer formats with 10 bits per colour. Every four consecutive
+	colour components are packed into 5 bytes. Each of the first 4
+	bytes contain the 8 high order bits of the pixels, and the
+	fifth byte contains the two least significants bits of each
+	pixel, in the same order.</para>
+
+	<para>Each n-pixel row contains n/2 green samples and n/2 blue
+	or red samples, with alternating green-red and green-blue
+	rows. They are conventionally described as GRGR... BGBG...,
+	RGRG... GBGB..., etc. Below is an example of one of these
+	formats:</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_SBGGR10P</constant> 4 &times; 4
+      pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte.
+	  <informaltable frame="topbot" colsep="1" rowsep="1">
+	    <tgroup cols="5" align="center" border="1">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start&nbsp;+&nbsp;0:</entry>
+		  <entry>B<subscript>00high</subscript></entry>
+		  <entry>G<subscript>01high</subscript></entry>
+		  <entry>B<subscript>02high</subscript></entry>
+		  <entry>G<subscript>03high</subscript></entry>
+		  <entry>B<subscript>00low</subscript>(bits 7--6)
+			 G<subscript>01low</subscript>(bits 5--4)
+			 B<subscript>02low</subscript>(bits 3--2)
+			 G<subscript>03low</subscript>(bits 1--0)
+		  </entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;5:</entry>
+		  <entry>G<subscript>10high</subscript></entry>
+		  <entry>R<subscript>11high</subscript></entry>
+		  <entry>G<subscript>12high</subscript></entry>
+		  <entry>R<subscript>13high</subscript></entry>
+		  <entry>G<subscript>10low</subscript>(bits 7--6)
+			 R<subscript>11low</subscript>(bits 5--4)
+			 G<subscript>12low</subscript>(bits 3--2)
+			 R<subscript>13low</subscript>(bits 1--0)
+		  </entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;10:</entry>
+		  <entry>B<subscript>20high</subscript></entry>
+		  <entry>G<subscript>21high</subscript></entry>
+		  <entry>B<subscript>22high</subscript></entry>
+		  <entry>G<subscript>23high</subscript></entry>
+		  <entry>B<subscript>20low</subscript>(bits 7--6)
+			 G<subscript>21low</subscript>(bits 5--4)
+			 B<subscript>22low</subscript>(bits 3--2)
+			 G<subscript>23low</subscript>(bits 1--0)
+		  </entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;15:</entry>
+		  <entry>G<subscript>30high</subscript></entry>
+		  <entry>R<subscript>31high</subscript></entry>
+		  <entry>G<subscript>32high</subscript></entry>
+		  <entry>R<subscript>33high</subscript></entry>
+		  <entry>G<subscript>30low</subscript>(bits 7--6)
+			 R<subscript>31low</subscript>(bits 5--4)
+			 G<subscript>32low</subscript>(bits 3--2)
+			 R<subscript>33low</subscript>(bits 1--0)
+		  </entry>
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
index ccf6053..2c83ef9 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1373,6 +1373,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-srggb8;
     &sub-sbggr16;
     &sub-srggb10;
+    &sub-srggb10p;
     &sub-srggb10alaw8;
     &sub-srggb10dpcm8;
     &sub-srggb12;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index f0b94b8..fbdc360 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -463,6 +463,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
+	/* 10bit raw bayer packed, 5 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR10P v4l2_fourcc('p', 'B', 'A', 'A')
+#define V4L2_PIX_FMT_SGBRG10P v4l2_fourcc('p', 'G', 'A', 'A')
+#define V4L2_PIX_FMT_SGRBG10P v4l2_fourcc('p', 'g', 'A', 'A')
+#define V4L2_PIX_FMT_SRGGB10P v4l2_fourcc('p', 'R', 'A', 'A')
 	/* 10bit raw bayer a-law compressed to 8 bits */
 #define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
 #define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
-- 
1.7.10.4

