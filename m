Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43414 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199AbcAKEHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 23:07:46 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/3] v4l: Merge the YUV and YVU 4:2:0 tri-planar non-contiguous formats docs
Date: Mon, 11 Jan 2016 06:07:42 +0200
Message-Id: <1452485264-11328-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1452485264-11328-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1452485264-11328-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two formats are very similar, having two separate pages to describe
them is overkill.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |  26 ++--
 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml | 154 ---------------------
 Documentation/DocBook/media/v4l/pixfmt.xml         |   1 -
 3 files changed, 17 insertions(+), 164 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
index e781cc61786c..7d13fe96657d 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
@@ -1,35 +1,43 @@
-    <refentry id="V4L2-PIX-FMT-YUV420M">
+    <refentry>
       <refmeta>
-	<refentrytitle>V4L2_PIX_FMT_YUV420M ('YM12')</refentrytitle>
+	<refentrytitle>V4L2_PIX_FMT_YUV420M ('YM12'), V4L2_PIX_FMT_YVU420M ('YM21')</refentrytitle>
 	&manvol;
       </refmeta>
       <refnamediv>
-	<refname> <constant>V4L2_PIX_FMT_YUV420M</constant></refname>
-	<refpurpose>Variation of <constant>V4L2_PIX_FMT_YUV420</constant>
-	  with planes non contiguous in memory. </refpurpose>
+	<refname id="V4L2-PIX-FMT-YUV420M"><constant>V4L2_PIX_FMT_YUV420M</constant></refname>
+	<refname id="V4L2-PIX-FMT-YVU420M"><constant>V4L2_PIX_FMT_YVU420M</constant></refname>
+	<refpurpose>Variation of <constant>V4L2_PIX_FMT_YUV420</constant> and
+	  <constant>V4L2_PIX_FMT_YVU420</constant> with planes non contiguous
+	  in memory.</refpurpose>
       </refnamediv>
 
       <refsect1>
 	<title>Description</title>
 
 	<para>This is a multi-planar format, as opposed to a packed format.
-The three components are separated into three sub- images or planes.
+The three components are separated into three sub-images or planes.</para>
 
-The Y plane is first. The Y plane has one byte per pixel. The Cb data
+	<para>The Y plane is first. The Y plane has one byte per pixel.
+For <constant>V4L2_PIX_FMT_YUV420M</constant> the Cb data
 constitutes the second plane which is half the width and half
 the height of the Y plane (and of the image). Each Cb belongs to four
 pixels, a two-by-two square of the image. For example,
 Cb<subscript>0</subscript> belongs to Y'<subscript>00</subscript>,
 Y'<subscript>01</subscript>, Y'<subscript>10</subscript>, and
 Y'<subscript>11</subscript>. The Cr data, just like the Cb plane, is
-in the third plane. </para>
+in the third plane.</para>
+
+	<para><constant>V4L2_PIX_FMT_YVU420M</constant> is the same except
+the Cr data is stored in the second plane and the Cb data in the third plane.
+</para>
 
 	<para>If the Y plane has pad bytes after each row, then the Cb
 and Cr planes have half as many pad bytes after their rows. In other
 words, two Cx rows (including padding) is exactly as long as one Y row
 (including padding).</para>
 
-	<para><constant>V4L2_PIX_FMT_YUV420M</constant> is intended to be
+	<para><constant>V4L2_PIX_FMT_YUV420M</constant> and
+<constant>V4L2_PIX_FMT_YVU420M</constant> are intended to be
 used only in drivers and applications that support the multi-planar API,
 described in <xref linkend="planar-apis"/>. </para>
 
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
deleted file mode 100644
index 2330667907c7..000000000000
--- a/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
+++ /dev/null
@@ -1,154 +0,0 @@
-    <refentry id="V4L2-PIX-FMT-YVU420M">
-      <refmeta>
-	<refentrytitle>V4L2_PIX_FMT_YVU420M ('YM21')</refentrytitle>
-	&manvol;
-      </refmeta>
-      <refnamediv>
-	<refname> <constant>V4L2_PIX_FMT_YVU420M</constant></refname>
-	<refpurpose>Variation of <constant>V4L2_PIX_FMT_YVU420</constant>
-	  with planes non contiguous in memory. </refpurpose>
-      </refnamediv>
-
-      <refsect1>
-	<title>Description</title>
-
-	<para>This is a multi-planar format, as opposed to a packed format.
-The three components are separated into three sub-images or planes.
-
-The Y plane is first. The Y plane has one byte per pixel. The Cr data
-constitutes the second plane which is half the width and half
-the height of the Y plane (and of the image). Each Cr belongs to four
-pixels, a two-by-two square of the image. For example,
-Cr<subscript>0</subscript> belongs to Y'<subscript>00</subscript>,
-Y'<subscript>01</subscript>, Y'<subscript>10</subscript>, and
-Y'<subscript>11</subscript>. The Cb data, just like the Cr plane, constitutes
-the third plane. </para>
-
-	<para>If the Y plane has pad bytes after each row, then the Cr
-and Cb planes have half as many pad bytes after their rows. In other
-words, two Cx rows (including padding) is exactly as long as one Y row
-(including padding).</para>
-
-	<para><constant>V4L2_PIX_FMT_YVU420M</constant> is intended to be
-used only in drivers and applications that support the multi-planar API,
-described in <xref linkend="planar-apis"/>. </para>
-
-	<example>
-	  <title><constant>V4L2_PIX_FMT_YVU420M</constant> 4 &times; 4
-pixel image</title>
-
-	  <formalpara>
-	    <title>Byte Order.</title>
-	    <para>Each cell is one byte.
-		<informaltable frame="none">
-		<tgroup cols="5" align="center">
-		  <colspec align="left" colwidth="2*" />
-		  <tbody valign="top">
-		    <row>
-		      <entry>start0&nbsp;+&nbsp;0:</entry>
-		      <entry>Y'<subscript>00</subscript></entry>
-		      <entry>Y'<subscript>01</subscript></entry>
-		      <entry>Y'<subscript>02</subscript></entry>
-		      <entry>Y'<subscript>03</subscript></entry>
-		    </row>
-		    <row>
-		      <entry>start0&nbsp;+&nbsp;4:</entry>
-		      <entry>Y'<subscript>10</subscript></entry>
-		      <entry>Y'<subscript>11</subscript></entry>
-		      <entry>Y'<subscript>12</subscript></entry>
-		      <entry>Y'<subscript>13</subscript></entry>
-		    </row>
-		    <row>
-		      <entry>start0&nbsp;+&nbsp;8:</entry>
-		      <entry>Y'<subscript>20</subscript></entry>
-		      <entry>Y'<subscript>21</subscript></entry>
-		      <entry>Y'<subscript>22</subscript></entry>
-		      <entry>Y'<subscript>23</subscript></entry>
-		    </row>
-		    <row>
-		      <entry>start0&nbsp;+&nbsp;12:</entry>
-		      <entry>Y'<subscript>30</subscript></entry>
-		      <entry>Y'<subscript>31</subscript></entry>
-		      <entry>Y'<subscript>32</subscript></entry>
-		      <entry>Y'<subscript>33</subscript></entry>
-		    </row>
-		    <row><entry></entry></row>
-		    <row>
-		      <entry>start1&nbsp;+&nbsp;0:</entry>
-		      <entry>Cr<subscript>00</subscript></entry>
-		      <entry>Cr<subscript>01</subscript></entry>
-		    </row>
-		    <row>
-		      <entry>start1&nbsp;+&nbsp;2:</entry>
-		      <entry>Cr<subscript>10</subscript></entry>
-		      <entry>Cr<subscript>11</subscript></entry>
-		    </row>
-		    <row><entry></entry></row>
-		    <row>
-		      <entry>start2&nbsp;+&nbsp;0:</entry>
-		      <entry>Cb<subscript>00</subscript></entry>
-		      <entry>Cb<subscript>01</subscript></entry>
-		    </row>
-		    <row>
-		      <entry>start2&nbsp;+&nbsp;2:</entry>
-		      <entry>Cb<subscript>10</subscript></entry>
-		      <entry>Cb<subscript>11</subscript></entry>
-		    </row>
-		  </tbody>
-		</tgroup>
-		</informaltable>
-	      </para>
-	  </formalpara>
-
-	  <formalpara>
-	    <title>Color Sample Location.</title>
-	    <para>
-		<informaltable frame="none">
-		<tgroup cols="7" align="center">
-		  <tbody valign="top">
-		    <row>
-		      <entry></entry>
-		      <entry>0</entry><entry></entry><entry>1</entry><entry></entry>
-		      <entry>2</entry><entry></entry><entry>3</entry>
-		    </row>
-		    <row>
-		      <entry>0</entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry>
-		    </row>
-		    <row>
-		      <entry></entry>
-		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
-		      <entry></entry><entry>C</entry><entry></entry>
-		    </row>
-		    <row>
-		      <entry>1</entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry>
-		    </row>
-		    <row>
-		      <entry></entry>
-		    </row>
-		    <row>
-		      <entry>2</entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry>
-		    </row>
-		    <row>
-		      <entry></entry>
-		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
-		      <entry></entry><entry>C</entry><entry></entry>
-		    </row>
-		    <row>
-		      <entry>3</entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
-		      <entry>Y</entry><entry></entry><entry>Y</entry>
-		    </row>
-		  </tbody>
-		</tgroup>
-		</informaltable>
-	      </para>
-	  </formalpara>
-	</example>
-      </refsect1>
-    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index d871245d2973..9e77ff353feb 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1628,7 +1628,6 @@ information.</para>
     &sub-y41p;
     &sub-yuv420;
     &sub-yuv420m;
-    &sub-yvu420m;
     &sub-yuv410;
     &sub-yuv422p;
     &sub-yuv411p;
-- 
2.4.10

