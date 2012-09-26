Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29914 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab2IZPyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 11:54:39 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00F2NS6UKE21@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:38 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAY000JLS6LTOA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:38 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 1/5] V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus
 format
Date: Wed, 26 Sep 2012 17:54:09 +0200
Message-id: <1348674853-24596-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds media bus pixel code for the interleaved JPEG/UYVY
image format used by S5C73MX Samsung cameras. This interleaved image
data is transferred on MIPI-CSI2 bus as User Defined Byte-based Data.

It also defines an experimental vendor and device specific media bus
formats section and adds related DocBook documentation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |  4 ++
 Documentation/DocBook/media/v4l/subdev-formats.xml | 44 ++++++++++++++++++++++
 include/linux/v4l2-mediabus.h                      |  5 +++
 3 files changed, 53 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 802c1ab..b12cddb 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2612,6 +2612,10 @@ ioctls.</para>
         <listitem>
 	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
         </listitem>
+        <listitem>
+	  <para>Vendor and device specific media bus pixel formats.
+	    <xref linkend="v4l2-mbus-vendor-spec-fmts" />.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..a0a9364 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2565,5 +2565,49 @@
 	</tgroup>
       </table>
     </section>
+
+    <section id="v4l2-mbus-vendor-spec-fmts">
+      <title>Vendor and Device Specific Formats</title>
+
+      <note>
+	<title>Experimental</title>
+	<para>This is an <link linkend="experimental">experimental</link>
+interface and may change in the future.</para>
+      </note>
+
+      <para>This section lists complex data formats that are either vendor or
+	device specific.
+      </para>
+
+      <para>The following table lists the existing vendor and device specific
+	formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-vendor-specific">
+	<title>Vendor and device specific formats</title>
+	<tgroup cols="3">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="left"/>
+	  <colspec colname="remarks" align="left"/>
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry>Comments</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-S5C-UYVY-JPEG-1X8">
+	      <entry>V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8</entry>
+	      <entry>0x5001</entry>
+	      <entry>
+		Interleaved raw UYVY and JPEG image format with embedded
+		meta-data used by Samsung S3C73MX camera sensors.
+	      </entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+
   </section>
 </section>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..7d64e0e 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -92,6 +92,11 @@ enum v4l2_mbus_pixelcode {
 
 	/* JPEG compressed formats - next is 0x4002 */
 	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
+
+	/* Vendor specific formats - next is 0x5002 */
+
+	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
+	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
 };
 
 /**
-- 
1.7.11.3

