Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49998 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934024AbbEOKb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 06:31:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE
Date: Fri, 15 May 2015 12:31:37 +0200
Message-Id: <1431685897-11153-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431685897-11153-1-git-send-email-hverkuil@xs4all.nl>
References: <1431685897-11153-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This format was added but not documented. Do this now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml | 81 +++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml        |  1 +
 2 files changed, 82 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-y16-be.xml b/Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
new file mode 100644
index 0000000..2212703
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
@@ -0,0 +1,81 @@
+<refentry id="V4L2-PIX-FMT-Y16-BE">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y16_BE ('Y16 ' | (1 &lt;&lt; 31))</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y16_BE</constant></refname>
+    <refpurpose>Grey-scale image</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a grey-scale image with a depth of 16 bits per
+pixel. The most significant byte is stored at lower memory addresses
+(big-endian). Note the actual sampling precision may be lower than
+16 bits, for example 10 bits per pixel with values in range 0 to
+1023.</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y16_BE</constant> 4 &times; 4
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
+		  <entry>Y'<subscript>30low</subscript></entry>
+		  <entry>Y'<subscript>30high</subscript></entry>
+		  <entry>Y'<subscript>31low</subscript></entry>
+		  <entry>Y'<subscript>31high</subscript></entry>
+		  <entry>Y'<subscript>32low</subscript></entry>
+		  <entry>Y'<subscript>32high</subscript></entry>
+		  <entry>Y'<subscript>33low</subscript></entry>
+		  <entry>Y'<subscript>33high</subscript></entry>
+		</row>
+		<row>
+		  <entry>start&nbsp;+&nbsp;8:</entry>
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
+		  <entry>start&nbsp;+&nbsp;16:</entry>
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
+		  <entry>start&nbsp;+&nbsp;24:</entry>
+		  <entry>Y'<subscript>00low</subscript></entry>
+		  <entry>Y'<subscript>00high</subscript></entry>
+		  <entry>Y'<subscript>01low</subscript></entry>
+		  <entry>Y'<subscript>01high</subscript></entry>
+		  <entry>Y'<subscript>02low</subscript></entry>
+		  <entry>Y'<subscript>02high</subscript></entry>
+		  <entry>Y'<subscript>03low</subscript></entry>
+		  <entry>Y'<subscript>03high</subscript></entry>
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
index fcde4e2..ddff8d9 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1429,6 +1429,7 @@ information.</para>
     &sub-y12;
     &sub-y10b;
     &sub-y16;
+    &sub-y16-be;
     &sub-uv8;
     &sub-yuyv;
     &sub-uyvy;
-- 
2.1.4

