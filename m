Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754203AbZLKRZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 12:25:14 -0500
Date: Fri, 11 Dec 2009 18:25:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] document new pixel formats
Message-ID: <Pine.LNX.4.64.0912111820270.5084@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document all four 10-bit Bayer formats, 10-bit monochrome and a missing 
8-bit Bayer formats.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Notice, this is a linux git patch, so, it includes manual additions to 
media-entities.tmpl, which will hopefully not be needed for hg. I'm also 
adding all four 10-bit Bayer formats here, including the 
V4L2_PIX_FMT_SGRBG10, which is already documented in pixfmt.xml. We can 
remove that bit then.

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index bb5ab74..5524e32 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -222,8 +222,11 @@
 <!ENTITY sub-sbggr8 SYSTEM "v4l/pixfmt-sbggr8.xml">
 <!ENTITY sub-sgbrg8 SYSTEM "v4l/pixfmt-sgbrg8.xml">
 <!ENTITY sub-sgrbg8 SYSTEM "v4l/pixfmt-sgrbg8.xml">
+<!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
+<!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY sub-uyvy SYSTEM "v4l/pixfmt-uyvy.xml">
 <!ENTITY sub-vyuy SYSTEM "v4l/pixfmt-vyuy.xml">
+<!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
 <!ENTITY sub-y16 SYSTEM "v4l/pixfmt-y16.xml">
 <!ENTITY sub-y41p SYSTEM "v4l/pixfmt-y41p.xml">
 <!ENTITY sub-yuv410 SYSTEM "v4l/pixfmt-yuv410.xml">
@@ -313,8 +316,11 @@
 <!ENTITY sbggr8 SYSTEM "v4l/pixfmt-sbggr8.xml">
 <!ENTITY sgbrg8 SYSTEM "v4l/pixfmt-sgbrg8.xml">
 <!ENTITY sgrbg8 SYSTEM "v4l/pixfmt-sgrbg8.xml">
+<!ENTITY srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
+<!ENTITY srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY uyvy SYSTEM "v4l/pixfmt-uyvy.xml">
 <!ENTITY vyuy SYSTEM "v4l/pixfmt-vyuy.xml">
+<!ENTITY y10 SYSTEM "v4l/pixfmt-y10.xml">
 <!ENTITY y16 SYSTEM "v4l/pixfmt-y16.xml">
 <!ENTITY y41p SYSTEM "v4l/pixfmt-y41p.xml">
 <!ENTITY yuv410 SYSTEM "v4l/pixfmt-yuv410.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/v4l/pixfmt-srggb10.xml
new file mode 100644
index 0000000..1be1815
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-srggb10.xml
@@ -0,0 +1,98 @@
+    <refentry>
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_SRGGB10 ('RG10'),
+	 V4L2_PIX_FMT_SGRBG10 ('BA10'),
+	 V4L2_PIX_FMT_SGBRG10 ('GB10'),
+	 V4L2_PIX_FMT_SBGGR10 ('BG10'),
+	 </refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname id="V4L2-PIX-FMT-SRGGB10"><constant>V4L2_PIX_FMT_SRGGB10</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGRBG10"><constant>V4L2_PIX_FMT_SGRBG10</constant></refname>
+	<refname id="V4L2-PIX-FMT-SGBRG10"><constant>V4L2_PIX_FMT_SGBRG10</constant></refname>
+	<refname id="V4L2-PIX-FMT-SBGGR10"><constant>V4L2_PIX_FMT_SBGGR10</constant></refname>
+	<refpurpose>10-bit Bayer formats expanded to 16 bits</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>The following four pixel formats are raw sRGB / Bayer formats with
+10 bits per colour. Each colour component is stored in a 16-bit word, with 6
+unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
+and n/2 blue or red samples, with alternating red and blue rows. Bytes are
+stored in memory in little endian order. They are conventionally described
+as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
+formats</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_SBGGR10</constant> 4 &times; 4
+pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte, high 6 bits in high bytes are 0.
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
+
+  <!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "pixfmt.sgml"
+indent-tabs-mode: nil
+End:
+  -->
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb8.xml b/Documentation/DocBook/v4l/pixfmt-srggb8.xml
new file mode 100644
index 0000000..cfae228
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-srggb8.xml
@@ -0,0 +1,75 @@
+    <refentry id="V4L2-PIX-FMT-SRGGB8">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_SRGGB8 ('RGGB')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname><constant>V4L2_PIX_FMT_SRGGB8</constant></refname>
+	<refpurpose>Bayer RGB format</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is commonly the native format of digital cameras,
+reflecting the arrangement of sensors on the CCD device. Only one red,
+green or blue value is given for each pixel. Missing components must
+be interpolated from neighbouring pixels. From left to right the first
+row consists of a red and green value, the second row of a green and
+blue value. This scheme repeats to the right and down for every two
+columns and rows.</para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_SRGGB8</constant> 4 &times; 4
+pixel image</title>
+
+	  <formalpara>
+	    <title>Byte Order.</title>
+	    <para>Each cell is one byte.
+	      <informaltable frame="none">
+		<tgroup cols="5" align="center">
+		  <colspec align="left" colwidth="2*" />
+		  <tbody valign="top">
+		    <row>
+		      <entry>start&nbsp;+&nbsp;0:</entry>
+		      <entry>R<subscript>00</subscript></entry>
+		      <entry>G<subscript>01</subscript></entry>
+		      <entry>R<subscript>02</subscript></entry>
+		      <entry>G<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;4:</entry>
+		      <entry>G<subscript>10</subscript></entry>
+		      <entry>B<subscript>11</subscript></entry>
+		      <entry>G<subscript>12</subscript></entry>
+		      <entry>B<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;8:</entry>
+		      <entry>R<subscript>20</subscript></entry>
+		      <entry>G<subscript>21</subscript></entry>
+		      <entry>R<subscript>22</subscript></entry>
+		      <entry>G<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;12:</entry>
+		      <entry>G<subscript>30</subscript></entry>
+		      <entry>B<subscript>31</subscript></entry>
+		      <entry>G<subscript>32</subscript></entry>
+		      <entry>B<subscript>33</subscript></entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+	      </informaltable>
+	    </para>
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
diff --git a/Documentation/DocBook/v4l/pixfmt-y10.xml b/Documentation/DocBook/v4l/pixfmt-y10.xml
new file mode 100644
index 0000000..d22c9b9
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y10.xml
@@ -0,0 +1,87 @@
+<refentry id="V4L2-PIX-FMT-Y10">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y10 ('Y10 ')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y10</constant></refname>
+    <refpurpose>Grey-scale image</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a grey-scale image with a depth of 10 bits per pixel. Pixels
+are stored in 16-bit words with unused high bits padded with 0. The least
+significant byte is stored at lower memory addresses (little-endian).</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y10</constant> 4 &times; 4
+pixel image</title>
+
+      <formalpara>
+	<title>Byte Order.</title>
+	<para>Each cell is one byte.
+	  <informaltable frame="none">
+	    <tgroup cols="9" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>start&nbsp;+&nbsp;0:</entry>
+		  <entry>Y'<subscript>00low</subscript></entry>
+		  <entry>Y'<subscript>00high</subscript></entry>
+		  <entry>Y'<subscript>01low</subscript></entry>
+		  <entry>Y'<subscript>01high</subscript></entry>
+		  <entry>Y'<subscript>02low</subscript></entry>
+		  <entry>Y'<subscript>02high</subscript></entry>
+		  <entry>Y'<subscript>03low</subscript></entry>
+		  <entry>Y'<subscript>03high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;8:</entry>
+		  <entry>Y'<subscript>10low</subscript></entry>
+		  <entry>Y'<subscript>10high</subscript></entry>
+		  <entry>Y'<subscript>11low</subscript></entry>
+		  <entry>Y'<subscript>11high</subscript></entry>
+		  <entry>Y'<subscript>12low</subscript></entry>
+		  <entry>Y'<subscript>12high</subscript></entry>
+		  <entry>Y'<subscript>13low</subscript></entry>
+		  <entry>Y'<subscript>13high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;16:</entry>
+		  <entry>Y'<subscript>20low</subscript></entry>
+		  <entry>Y'<subscript>20high</subscript></entry>
+		  <entry>Y'<subscript>21low</subscript></entry>
+		  <entry>Y'<subscript>21high</subscript></entry>
+		  <entry>Y'<subscript>22low</subscript></entry>
+		  <entry>Y'<subscript>22high</subscript></entry>
+		  <entry>Y'<subscript>23low</subscript></entry>
+		  <entry>Y'<subscript>23high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;24:</entry>
+		  <entry>Y'<subscript>30low</subscript></entry>
+		  <entry>Y'<subscript>30high</subscript></entry>
+		  <entry>Y'<subscript>31low</subscript></entry>
+		  <entry>Y'<subscript>31high</subscript></entry>
+		  <entry>Y'<subscript>32low</subscript></entry>
+		  <entry>Y'<subscript>32high</subscript></entry>
+		  <entry>Y'<subscript>33low</subscript></entry>
+		  <entry>Y'<subscript>33high</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
+
+  <!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "pixfmt.sgml"
+indent-tabs-mode: nil
+End:
+  -->
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index 885968d..71fc5c5 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -566,7 +566,9 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-sbggr8;
     &sub-sgbrg8;
     &sub-sgrbg8;
+    &sub-srggb8;
     &sub-sbggr16;
+    &sub-srggb10;
   </section>
 
   <section id="yuv-formats">
@@ -589,6 +591,7 @@ information.</para>
 
     &sub-packed-yuv;
     &sub-grey;
+    &sub-y10;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
