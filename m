Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21698 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1LNMXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 07:23:14 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW70032S12OOD@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW700JMQ12N6H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Date: Wed, 14 Dec 2011 13:23:07 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv4 1/2] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
In-reply-to: <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323865388-26994-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
 <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the new field is to allow the video pipeline elements
to negotiate memory buffer size for compressed data frames, where
the buffer size cannot be derived from pixel width and height and
the pixel code.

For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the
framesamples parameter should be calculated by the driver from pixel
width, height, color format and other parameters if required and
returned to the caller. This applies to compressed data formats only.

The application should propagate the framesamples value, whatever
returned at the first sub-device within a data pipeline, i.e. at the
pipeline's data source.

For compressed data formats the host drivers should internally
validate the framesamples parameter values before streaming is
enabled, to make sure the memory buffer size requirements are
satisfied along the pipeline.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
--
There is no changes in this patch comparing to v3.
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   10 ++++++++--
 Documentation/DocBook/media/v4l/subdev-formats.xml |    9 ++++++++-
 include/linux/v4l2-mediabus.h                      |    4 +++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 0916a73..b9d24eb 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -113,7 +113,7 @@
     <para>Drivers that implement the <link linkend="media-controller-intro">media
     API</link> can expose pad-level image format configuration to applications.
     When they do, applications can use the &VIDIOC-SUBDEV-G-FMT; and
-    &VIDIOC-SUBDEV-S-FMT; ioctls. to negotiate formats on a per-pad basis.</para>
+    &VIDIOC-SUBDEV-S-FMT; ioctls to negotiate formats on a per-pad basis.</para>
 
     <para>Applications are responsible for configuring coherent parameters on
     the whole pipeline and making sure that connected pads have compatible
@@ -160,7 +160,13 @@
       guaranteed to be supported by the device. In particular, drivers guarantee
       that a returned format will not be further changed if passed to an
       &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such as
-      formats on other pads or links' configuration are not changed).</para>
+      formats on other pads or links' configuration are not changed). When a
+      device contains a data encoder, the <structfield>
+      <link linkend="v4l2-mbus-framefmt-framesamples">framesamples</link>
+      </structfield> field value may be further changed, if parameters of the
+      encoding process are changed after the format has been negotiated. In
+      such situation applications should use &VIDIOC-SUBDEV-G-FMT; ioctl to
+      query an updated format.</para>
 
       <para>Drivers automatically propagate formats inside sub-devices. When a
       try or active format is set on a pad, corresponding formats on other pads
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..7c202a1 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -33,9 +33,16 @@
 	  <entry>Image colorspace, from &v4l2-colorspace;. See
 	  <xref linkend="colorspaces" /> for details.</entry>
 	</row>
+	<row id="v4l2-mbus-framefmt-framesamples">
+	  <entry>__u32</entry>
+	  <entry><structfield>framesamples</structfield></entry>
+	  <entry>Maximum number of bus samples per frame for compressed data
+	    formats. For uncompressed formats drivers and applications must
+	    set this parameter to zero. </entry>
+	</row>
 	<row>
 	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[7]</entry>
+	  <entry><structfield>reserved</structfield>[6]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..f18d6cd 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ * @framesamples: maximum number of bus samples per frame
  */
 struct v4l2_mbus_framefmt {
 	__u32			width;
@@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u32			reserved[7];
+	__u32			framesamples;
+	__u32			reserved[6];
 };
 
 #endif
-- 
1.7.8

