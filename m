Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab0BYRd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 12:33:56 -0500
Date: Thu, 25 Feb 2010 14:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 4/4] V4L/DVB: v4l: document new Bayer and monochrome pixel
 formats
Message-ID: <20100225143327.527f5888@pedra>
In-Reply-To: <c541522de5dec33a56dbe94a26fadf400fd7e536.1267119175.git.mchehab@redhat.com>
References: <c541522de5dec33a56dbe94a26fadf400fd7e536.1267119175.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document all four 10-bit Bayer formats, 10-bit monochrome and a missing
8-bit Bayer formats.

[mchehab@redhat.com: remove duplicated symbol for V4L2-PIX-FMT-SGRBG10]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb10.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb8.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10.xml

diff --git a/Documentation/DocBook/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/v4l/pixfmt-srggb10.xml
new file mode 100644
index 0000000..7b27409
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-srggb10.xml
@@ -0,0 +1,90 @@
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
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb8.xml b/Documentation/DocBook/v4l/pixfmt-srggb8.xml
new file mode 100644
index 0000000..2570e3b
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-srggb8.xml
@@ -0,0 +1,67 @@
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
diff --git a/Documentation/DocBook/v4l/pixfmt-y10.xml b/Documentation/DocBook/v4l/pixfmt-y10.xml
new file mode 100644
index 0000000..d065043
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y10.xml
@@ -0,0 +1,79 @@
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
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index 6e38f50..7e2c38e 100644
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
@@ -710,11 +713,6 @@ kernel sources in the file <filename>Documentation/video4linux/cx2341x/README.hm
 	    <entry>'S561'</entry>
 	    <entry>Compressed GBRG Bayer format used by the gspca driver.</entry>
 	  </row>
-	  <row id="V4L2-PIX-FMT-SGRBG10">
-	    <entry><constant>V4L2_PIX_FMT_SGRBG10</constant></entry>
-	    <entry>'DA10'</entry>
-	    <entry>10 bit raw Bayer, expanded to 16 bits.</entry>
-	  </row>
 	  <row id="V4L2-PIX-FMT-SGRBG10DPCM8">
 	    <entry><constant>V4L2_PIX_FMT_SGRBG10DPCM8</constant></entry>
 	    <entry>'DB10'</entry>
-- 
1.6.6.1

