Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54521 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1KVJzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 04:55:52 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV200F1F3L2ON50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 09:55:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV200K2A3L1FU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 09:55:50 +0000 (GMT)
Date: Tue, 22 Nov 2011 10:55:38 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH v1 1/3] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
In-reply-to: <1321955740-24452-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1321955740-24452-2-git-send-email-s.nawrocki@samsung.com>
References: <1321955740-24452-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the new field is to allow the video pipeline elements to
negotiate memory buffer size for compressed data frames, where the buffer
size cannot be derived from pixel width and height and the pixel code.

For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the framesamples
parameter should be calculated by the driver from pixel width, height,
color format and other parameters if required and returned to the caller.
This applies to compressed data formats only.

The application should propagate the framesamples value, whatever returned
at the first sub-device within a data pipeline, i.e. at the pipeline's data
source.

For compressed data formats the host drivers should internally validate
the framesamples parameter values before streaming is enabled, to make sure
the memory buffer size requirements are satisfied along the pipeline.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml |    7 ++++++-
 include/linux/v4l2-mediabus.h                      |    4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..d0827b4 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -35,7 +35,12 @@
 	</row>
 	<row>
 	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[7]</entry>
+	  <entry><structfield>framesamples</structfield></entry>
+	  <entry>Number of data samples on media bus per frame.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>reserved</structfield>[6]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..ce776e8 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ * @framesamples: number of data samples per frame
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
1.7.7.2

