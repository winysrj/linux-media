Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17783 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1BIOKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 09:10:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LGC00M9ISPJPA70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 14:10:32 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LGC0017SSPIKL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 14:10:31 +0000 (GMT)
Date: Wed, 09 Feb 2011 15:10:25 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] v4l: Documentation for the NV12T multiplane format
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, k.debski@samsung.com
Message-id: <1297260625-17093-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Kamil Debski <k.debski@samsung.com>

Added documentation for V4L2_PIX_FMT_NV12MT format. This is a YUV 4:2:0
format with macro block size of 64x32 and specific order of macro blocks
in the memory.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

---
 Documentation/DocBook/media-entities.tmpl    |    1 +
 Documentation/DocBook/v4l/nv12mt.gif         |  Bin 0 -> 2108 bytes
 Documentation/DocBook/v4l/nv12mt_example.gif |  Bin 0 -> 6858 bytes
 Documentation/DocBook/v4l/pixfmt-nv12mt.xml  |   74 ++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml         |    1 +
 5 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/nv12mt.gif
 create mode 100644 Documentation/DocBook/v4l/nv12mt_example.gif
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12mt.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index be34dcb..9fc92d3 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -233,6 +233,7 @@
 <!ENTITY sub-io SYSTEM "v4l/io.xml">
 <!ENTITY sub-grey SYSTEM "v4l/pixfmt-grey.xml">
 <!ENTITY sub-nv12 SYSTEM "v4l/pixfmt-nv12.xml">
+<!ENTITY sub-nv12mt SYSTEM "v4l/pixfmt-nv12mt.xml">
 <!ENTITY sub-nv16 SYSTEM "v4l/pixfmt-nv16.xml">
 <!ENTITY sub-packed-rgb SYSTEM "v4l/pixfmt-packed-rgb.xml">
 <!ENTITY sub-packed-yuv SYSTEM "v4l/pixfmt-packed-yuv.xml">
diff --git a/Documentation/DocBook/v4l/nv12mt.gif b/Documentation/DocBook/v4l/nv12mt.gif
new file mode 100644
index 0000000000000000000000000000000000000000..ef2d4cf8367b97293eb9139de0f33d0a2ac236be
GIT binary patch
literal 2108
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
JfkA-P{{T*w8|nZ6

literal 0
HcmV?d00001

diff --git a/Documentation/DocBook/v4l/nv12mt_example.gif b/Documentation/DocBook/v4l/nv12mt_example.gif
new file mode 100644
index 0000000000000000000000000000000000000000..df81d68108eeb66569417b475984aa634385eebb
GIT binary patch
literal 6858
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
V-^XO_BChtj?V@hK$vy-q{tq)sSegI;

literal 0
HcmV?d00001

diff --git a/Documentation/DocBook/v4l/pixfmt-nv12mt.xml b/Documentation/DocBook/v4l/pixfmt-nv12mt.xml
new file mode 100644
index 0000000..b25ded8
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-nv12mt.xml
@@ -0,0 +1,74 @@
+    <refentry>
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_NV12MT ('TM12')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-NV12MT"><constant>V4L2_PIX_FMT_NV12MT
+</constant></refname>
+	<refpurpose>Formats with &frac12; horizontal and vertical
+chroma resolution. This format has two planes - one for luminance and one for
+chrominance. Chroma samples are interleaved. The difference to
+<constant>V4L2_PIX_FMT_NV12</constant> is the memory layout. Pixels are
+grouped in macroblocks of 64x32 size. The order of macroblocks in memory is
+also not standard.
+	</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is the two-plane versions of the YUV 4:2:0 format where data
+is grouped into 64x32 macroblocks. The three components are separated into two
+sub-images or planes. The Y plane has one byte per pixel and pixels are grouped
+into 64x32 macroblocks. The CbCr plane has the same width, in bytes, as the Y
+plane (and the image), but is half as tall in pixels. The chroma plane is also
+grouped into 64x32 macroblocks.</para>
+	<para>Width of the buffer has to be aligned to the multiple of 128, and
+height alignment is 32. Every four adjactent buffers - two horizontally and two
+vertically are grouped together and are located in memory in Z or flipped Z
+order. </para>
+	<para>Layout of macroblocks in memory is presented in the following
+figure.</para>
+	<para><figure id="nv12mt">
+	    <title><constant>V4L2_PIX_FMT_NV12MT</constant> macroblock Z shape
+memory layout</title>
+	    <mediaobject>
+	      <imageobject>
+		<imagedata fileref="nv12mt.gif" format="GIF" />
+	      </imageobject>
+	    </mediaobject>
+	</figure>
+	The requirement that width is multiple 128 is implemnted because, the Z
+shape cannot be cut in half horizontally. In case the vertical resolution is
+macroblocks is odd then the last row of macroblocks is arranged in a linear
+order.  </para>
+	<para>In case of chroma the layout is identical. Cb and Cr samples are
+interleaved. Height of the buffer is aligned to 32.
+	</para>
+	<example>
+	  <title>Memory layout of macroblocks in <constant>V4L2_PIX_FMT_NV12
+</constant> format pixel image - extreme case</title>
+	<para>
+	<figure id="nv12mt">
+	    <title>Example <constant>V4L2_PIX_FMT_NV12MT</constant> memory
+layout of macroblocks</title>
+	    <mediaobject>
+	      <imageobject>
+		<imagedata fileref="nv12mt_example.gif" format="GIF" />
+	      </imageobject>
+	    </mediaobject>
+	</figure>
+	Memory layout of macroblocks of <constant>V4L2_PIX_FMT_NV12MT
+</constant> format in most extreme case.
+	</para>
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
index d7c4671..3a9d068 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -603,6 +603,7 @@ information.</para>
     &sub-yuv422p;
     &sub-yuv411p;
     &sub-nv12;
+    &sub-nv12mt;
     &sub-nv16;
   </section>
 
-- 
1.6.3.3

