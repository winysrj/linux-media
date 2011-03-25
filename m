Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39486 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1CYP3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:29:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LIM008BVDPCDH20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Mar 2011 15:29:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LIM00GL7DPBY5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Mar 2011 15:29:35 +0000 (GMT)
Date: Fri, 25 Mar 2011 16:29:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH v2] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
In-reply-to: <201103241731.33518.laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1301066967-26690-1-git-send-email-s.nawrocki@samsung.com>
References: <201103241731.33518.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add V4L2_MBUS_FMT_JPEG_1X8 format and the corresponding Docbook
documentation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hello,

it's a second patch version adding V4L2_MBUS_FMT_JPEG_1X8
format to the list of media bus formats. The requirement of
this format had already been discussed in the past (1*, 2*).
This patch adds relevant entry in v4l2-mediabus.h header and
the documentation.

Changes since v1:
 - rewritten description of JPEG formats code structure

Comments and suggestions are welcome.

--
Regards,
Sylwester Nawrocki,
Samsung Poland R&D Center


1* http://www.spinics.net/lists/linux-media/msg27980.html
2* http://www.spinics.net/lists/linux-media/msg28651.html
---
 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++++++++++++++++++++++++++
 include/linux/v4l2-mediabus.h                |    3 ++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
index b5376e2..a65e97e 100644
--- a/Documentation/DocBook/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -2463,5 +2463,51 @@
 	</tgroup>
       </table>
     </section>
+
+    <section>
+      <title>JPEG Compressed Formats</title>
+
+      <para>Those data formats consist of an ordered sequence of 8-bit bytes
+	obtained from JPEG compression process. Additionally to the
+	<constant>_JPEG</constant> prefix the format code is made of
+	the following information.
+	<itemizedlist>
+	  <listitem>The number of bus samples per entropy encoded byte.</listitem>
+	  <listitem>The bus width.</listitem>
+	</itemizedlist>
+
+	<para>For instance, for a JPEG baseline process and an 8-bit bus width
+	  the format will be named <constant>V4L2_MBUS_FMT_JPEG_1X8</constant>.
+	</para>
+      </para>
+
+      <para>The following table lists existing JPEG compressed formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-jpeg">
+	<title>JPEG Formats</title>
+	<tgroup cols="3">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="left"/>
+	  <colspec colname="remarks" align="left"/>
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry>Remarks</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-JPEG-1X8">
+	      <entry>V4L2_MBUS_FMT_JPEG_1X8</entry>
+	      <entry>0x4001</entry>
+	      <entry>Besides of its usage for the parallel bus this format is
+		recommended for transmission of JPEG data over MIPI CSI bus
+		using the User Defined 8-bit Data types.
+	      </entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
   </section>
 </section>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 7054a7a..15d6cda 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -86,6 +86,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
 	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
 	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
+
+	/* JPEG compressed formats - next is 0x4002 */
+	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
 };
 
 /**
-- 
1.7.4.1
