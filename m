Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10934 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1EPMFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 08:05:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 16 May 2011 14:05:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
In-reply-to: <1305547539-13194-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1305547539-13194-2-git-send-email-s.nawrocki@samsung.com>
References: <1305547539-13194-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add V4L2_MBUS_FMT_JPEG_1X8 format and the corresponding Docbook
documentation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++++++++++++++++++++++++++
 include/linux/v4l2-mediabus.h                |    3 ++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
index d7ccd25..a26b10c 100644
--- a/Documentation/DocBook/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -2522,5 +2522,51 @@
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
index de5c159..5ea7f75 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -89,6 +89,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
 	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
 	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
+
+	/* JPEG compressed formats - next is 0x4002 */
+	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
 };
 
 /**
-- 
1.7.5
