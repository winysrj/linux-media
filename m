Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:30845 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2GaN3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 09:29:13 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8100AGL1FG2Q80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 22:28:44 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8100ALP1FF8G60@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 22:28:44 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, hverkuil@xs4all.nl, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com,
	shaik.samsung@gmail.com, shaik.ameer@samsung.com
Subject: [PATCH v5 1/5] v4l: Add new YVU420 multi planar fourcc definition
Date: Tue, 31 Jul 2012 19:14:02 +0530
Message-id: <1343742246-27579-2-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1343742246-27579-1-git-send-email-shaik.ameer@samsung.com>
References: <1343742246-27579-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the following new fourcc definition.
For multiplanar YCrCb
        - V4L2_PIX_FMT_YVU420M - 'YM21'

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml |  154 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 include/linux/videodev2.h                          |    1 +
 3 files changed, 156 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
new file mode 100644
index 0000000..2330667
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
@@ -0,0 +1,154 @@
+    <refentry id="V4L2-PIX-FMT-YVU420M">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YVU420M ('YM21')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname> <constant>V4L2_PIX_FMT_YVU420M</constant></refname>
+	<refpurpose>Variation of <constant>V4L2_PIX_FMT_YVU420</constant>
+	  with planes non contiguous in memory. </refpurpose>
+      </refnamediv>
+
+      <refsect1>
+	<title>Description</title>
+
+	<para>This is a multi-planar format, as opposed to a packed format.
+The three components are separated into three sub-images or planes.
+
+The Y plane is first. The Y plane has one byte per pixel. The Cr data
+constitutes the second plane which is half the width and half
+the height of the Y plane (and of the image). Each Cr belongs to four
+pixels, a two-by-two square of the image. For example,
+Cr<subscript>0</subscript> belongs to Y'<subscript>00</subscript>,
+Y'<subscript>01</subscript>, Y'<subscript>10</subscript>, and
+Y'<subscript>11</subscript>. The Cb data, just like the Cr plane, constitutes
+the third plane. </para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cr
+and Cb planes have half as many pad bytes after their rows. In other
+words, two Cx rows (including padding) is exactly as long as one Y row
+(including padding).</para>
+
+	<para><constant>V4L2_PIX_FMT_YVU420M</constant> is intended to be
+used only in drivers and applications that support the multi-planar API,
+described in <xref linkend="planar-apis"/>. </para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YVU420M</constant> 4 &times; 4
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
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index e58934c..1ddbfab 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -708,6 +708,7 @@ information.</para>
     &sub-y41p;
     &sub-yuv420;
     &sub-yuv420m;
+    &sub-yvu420m;
     &sub-yuv410;
     &sub-yuv422p;
     &sub-yuv411p;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7a147c8..3f17e82 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -368,6 +368,7 @@ struct v4l2_pix_format {
 
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
+#define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'M', '2', '1') /* 12  YVU420 planar */
 
 /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
-- 
1.7.0.4

