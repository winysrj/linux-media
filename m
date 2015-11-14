Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52552 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbKNN0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2015 08:26:31 -0500
Received: from avalon.bb.dnainternet.fi (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id B1855203A8
	for <linux-media@vger.kernel.org>; Sat, 14 Nov 2015 14:25:49 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: Add YUV 4:2:2 and YUV 4:4:4 tri-planar non-contiguous formats
Date: Sat, 14 Nov 2015 15:26:33 +0200
Message-Id: <1447507593-15016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The formats use three planes through the multiplanar API, allowing for
non-contiguous planes in memory.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml | 159 +++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml | 171 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml | 159 +++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml | 171 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +
 include/uapi/linux/videodev2.h                     |   4 +
 7 files changed, 672 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml

Hello,

The driver using those formats should follow in the not too distant future,
but I'd appreciate getting feedback on the definitions already.

diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
new file mode 100644
index 000000000000..f4d8d74e7f74
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
@@ -0,0 +1,159 @@
+    <refentry id="V4L2-PIX-FMT-YUV422M">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YUV422M ('YM16')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname> <constant>V4L2_PIX_FMT_YUV422M</constant></refname>
+	<refpurpose>Planar formats with &frac12; horizontal resolution, also
+	known as YUV 4:2:2</refpurpose>
+      </refnamediv>
+
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is a multi-planar format, as opposed to a packed format.
+The three components are separated into three sub- images or planes.
+
+The Y plane is first. The Y plane has one byte per pixel. The Cb data
+constitutes the second plane which is half the width of the Y plane (and of the
+image). Each Cb belongs to two pixels. For example,
+Cb<subscript>0</subscript> belongs to Y'<subscript>00</subscript>,
+Y'<subscript>01</subscript>. The Cr data, just like the Cb plane, is
+in the third plane. </para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cb
+and Cr planes have half as many pad bytes after their rows. In other
+words, two Cx rows (including padding) is exactly as long as one Y row
+(including padding).</para>
+
+	<para><constant>V4L2_PIX_FMT_YUV422M</constant> is intended to be
+used only in drivers and applications that support the multi-planar API,
+described in <xref linkend="planar-apis"/>. </para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YUV422M</constant> 4 &times; 4
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
+		      <entry>start0&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;8:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;0:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;2:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;4:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;6:</entry>
+		      <entry>Cb<subscript>30</subscript></entry>
+		      <entry>Cb<subscript>31</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;0:</entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;2:</entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;4:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;6:</entry>
+		      <entry>Cr<subscript>30</subscript></entry>
+		      <entry>Cr<subscript>31</subscript></entry>
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
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
new file mode 100644
index 000000000000..346739e48c79
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
@@ -0,0 +1,171 @@
+    <refentry id="V4L2-PIX-FMT-YUV444M">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YUV444M ('YM24')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname> <constant>V4L2_PIX_FMT_YUV444M</constant></refname>
+	<refpurpose>Planar formats with full horizontal resolution, also
+	known as YUV 4:4:4</refpurpose>
+      </refnamediv>
+
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is a multi-planar format, as opposed to a packed format.
+The three components are separated into three sub- images or planes.
+
+The Y plane is first. The Y plane has one byte per pixel. The Cb data
+constitutes the second plane which is the same width and height as the Y plane
+(and as the image). The Cr data, just like the Cb plane, is in the third plane.
+</para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cb
+and Cr planes have the same number of pad bytes after their rows.</para>
+
+	<para><constant>V4L2_PIX_FMT_YUV444M</constant> is intended to be
+used only in drivers and applications that support the multi-planar API,
+described in <xref linkend="planar-apis"/>. </para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YUV444M</constant> 4 &times; 4
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
+		      <entry>start0&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;8:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;0:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		      <entry>Cb<subscript>02</subscript></entry>
+		      <entry>Cb<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;4:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		      <entry>Cb<subscript>12</subscript></entry>
+		      <entry>Cb<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;8:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		      <entry>Cb<subscript>22</subscript></entry>
+		      <entry>Cb<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;12:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		      <entry>Cb<subscript>32</subscript></entry>
+		      <entry>Cb<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;0:</entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		      <entry>Cr<subscript>02</subscript></entry>
+		      <entry>Cr<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;4:</entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		      <entry>Cr<subscript>12</subscript></entry>
+		      <entry>Cr<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;8:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		      <entry>Cr<subscript>22</subscript></entry>
+		      <entry>Cr<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;12:</entry>
+		      <entry>Cr<subscript>30</subscript></entry>
+		      <entry>Cr<subscript>31</subscript></entry>
+		      <entry>Cr<subscript>32</subscript></entry>
+		      <entry>Cr<subscript>33</subscript></entry>
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
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml b/Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml
new file mode 100644
index 000000000000..3c8ea6cbedf8
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml
@@ -0,0 +1,159 @@
+    <refentry id="V4L2-PIX-FMT-YVU422M">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YVU422M ('YM61')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname> <constant>V4L2_PIX_FMT_YVU422M</constant></refname>
+	<refpurpose>Planar formats with &frac12; horizontal resolution, also
+	known as YVU 4:2:2</refpurpose>
+      </refnamediv>
+
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is a multi-planar format, as opposed to a packed format.
+The three components are separated into three sub- images or planes.
+
+The Y plane is first. The Y plane has one byte per pixel. The Cr data
+constitutes the second plane which is half the width of the Y plane (and of the
+image). Each Cr belongs to two pixels. For example,
+Cb<subscript>0</subscript> belongs to Y'<subscript>00</subscript>,
+Y'<subscript>01</subscript>. The Cb data, just like the Cr plane, is
+in the third plane. </para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cr
+and Cb planes have half as many pad bytes after their rows. In other
+words, two Cx rows (including padding) is exactly as long as one Y row
+(including padding).</para>
+
+	<para><constant>V4L2_PIX_FMT_YVU422M</constant> is intended to be
+used only in drivers and applications that support the multi-planar API,
+described in <xref linkend="planar-apis"/>. </para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YVU422M</constant> 4 &times; 4
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
+		      <entry>start0&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;8:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;0:</entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;2:</entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;4:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;6:</entry>
+		      <entry>Cr<subscript>30</subscript></entry>
+		      <entry>Cr<subscript>31</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;0:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;2:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;4:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;6:</entry>
+		      <entry>Cb<subscript>30</subscript></entry>
+		      <entry>Cb<subscript>31</subscript></entry>
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
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry><entry></entry>
+		      <entry>Y</entry><entry>C</entry><entry>Y</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml b/Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml
new file mode 100644
index 000000000000..25147ac63334
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml
@@ -0,0 +1,171 @@
+    <refentry id="V4L2-PIX-FMT-YVU444M">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YVU444M ('YM42')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname> <constant>V4L2_PIX_FMT_YVU444M</constant></refname>
+	<refpurpose>Planar formats with full horizontal resolution, also
+	known as YVU 4:4:4</refpurpose>
+      </refnamediv>
+
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is a multi-planar format, as opposed to a packed format.
+The three components are separated into three sub- images or planes.
+
+The Y plane is first. The Y plane has one byte per pixel. The Cr data
+constitutes the second plane which is the same width and height as the Y plane
+(and as the image). The Cb data, just like the Cr plane, is in the third plane.
+</para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cr
+and Cb planes have the same number of pad bytes after their rows.</para>
+
+	<para><constant>V4L2_PIX_FMT_YVU444M</constant> is intended to be
+used only in drivers and applications that support the multi-planar API,
+described in <xref linkend="planar-apis"/>. </para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YVU444M</constant> 4 &times; 4
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
+		      <entry>start0&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;8:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start0&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;0:</entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		      <entry>Cr<subscript>02</subscript></entry>
+		      <entry>Cr<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;4:</entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		      <entry>Cr<subscript>12</subscript></entry>
+		      <entry>Cr<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;8:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		      <entry>Cr<subscript>22</subscript></entry>
+		      <entry>Cr<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start1&nbsp;+&nbsp;12:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		      <entry>Cr<subscript>32</subscript></entry>
+		      <entry>Cr<subscript>33</subscript></entry>
+		    </row>
+		    <row><entry></entry></row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;0:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		      <entry>Cb<subscript>02</subscript></entry>
+		      <entry>Cb<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;4:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		      <entry>Cb<subscript>12</subscript></entry>
+		      <entry>Cb<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;8:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		      <entry>Cb<subscript>22</subscript></entry>
+		      <entry>Cb<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start2&nbsp;+&nbsp;12:</entry>
+		      <entry>Cb<subscript>30</subscript></entry>
+		      <entry>Cb<subscript>31</subscript></entry>
+		      <entry>Cb<subscript>32</subscript></entry>
+		      <entry>Cb<subscript>33</subscript></entry>
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
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry><entry></entry>
+		      <entry>YC</entry><entry></entry><entry>YC</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index d871245d2973..fa26cb37a331 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1629,6 +1629,10 @@ information.</para>
     &sub-yuv420;
     &sub-yuv420m;
     &sub-yvu420m;
+    &sub-yuv422m;
+    &sub-yvu422m;
+    &sub-yuv444m;
+    &sub-yvu444m;
     &sub-yuv410;
     &sub-yuv422p;
     &sub-yuv411p;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7486af2c8ae4..571b6ed43e07 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1191,6 +1191,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/CbCr 4:2:0 (16x16 MB, N-C)"; break;
 	case V4L2_PIX_FMT_YUV420M:	descr = "Planar YUV 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_YVU420M:	descr = "Planar YVU 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_YUV422M:	descr = "Planar YUV 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_YVU422M:	descr = "Planar YVU 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_YUV444M:	descr = "Planar YUV 4:4:4 (N-C)"; break;
+	case V4L2_PIX_FMT_YVU444M:	descr = "Planar YVU 4:4:4 (N-C)"; break;
 	case V4L2_PIX_FMT_SBGGR8:	descr = "8-bit Bayer BGBG/GRGR"; break;
 	case V4L2_PIX_FMT_SGBRG8:	descr = "8-bit Bayer GBGB/RGRG"; break;
 	case V4L2_PIX_FMT_SGRBG8:	descr = "8-bit Bayer GRGR/BGBG"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 05830dc9260c..b37f75c75976 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -546,6 +546,10 @@ struct v4l2_pix_format {
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
 #define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'M', '2', '1') /* 12  YVU420 planar */
+#define V4L2_PIX_FMT_YUV422M v4l2_fourcc('Y', 'M', '1', '6') /* 16  YUV422 planar */
+#define V4L2_PIX_FMT_YVU422M v4l2_fourcc('Y', 'M', '6', '1') /* 16  YVU422 planar */
+#define V4L2_PIX_FMT_YUV444M v4l2_fourcc('Y', 'M', '2', '4') /* 24  YUV444 planar */
+#define V4L2_PIX_FMT_YVU444M v4l2_fourcc('Y', 'M', '4', '2') /* 24  YVU444 planar */
 
 /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
-- 
Regards,

Laurent Pinchart

