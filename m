Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49098 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbbCKMBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 08:01:17 -0400
Message-ID: <55002E6D.9060306@xs4all.nl>
Date: Wed, 11 Mar 2015 13:00:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] DocBook v4l: update bytesperline handling
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation says that the bytesperline field in v4l2_pix_format refers
to the largest plane in the case of planar formats (i.e. multiple planes
stores in a single buffer).

For almost all planar formats the first plane is also the largest (or equal)
plane, except for two formats: V4L2_PIX_FMT_NV24/NV42. For this YUV 4:4:4
format the second chroma plane is twice the size of the first luma plane.

Looking at the very few drivers that support this format the bytesperline
value that they report is actually that of the first plane and not that
of the largest plane.

Rather than fixing the drivers it makes more sense to update the documentation
since it is very difficult to use the largest plane for this. You would have
to check what the format is in order to know to which plane bytesperline
belongs, which makes calculations much more difficult.

This patch updates the documentation accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..447daf0 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -80,9 +80,9 @@ padding bytes after the last line of an image cross a system page
 boundary. Input devices may write padding bytes, the value is
 undefined. Output devices ignore the contents of padding
 bytes.</para><para>When the image format is planar the
-<structfield>bytesperline</structfield> value applies to the largest
+<structfield>bytesperline</structfield> value applies to the first
 plane and is divided by the same factor as the
-<structfield>width</structfield> field for any smaller planes. For
+<structfield>width</structfield> field for the other planes. For
 example the Cb and Cr planes of a YUV 4:2:0 image have half as many
 padding bytes following each line as the Y plane. To avoid ambiguities
 drivers must return a <structfield>bytesperline</structfield> value
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
index 2046073..77607cc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
@@ -240,9 +240,9 @@ where padding bytes after the last line of an image cross a system
 page boundary. Capture devices may write padding bytes, the value is
 undefined. Output devices ignore the contents of padding
 bytes.</para><para>When the image format is planar the
-<structfield>bytesperline</structfield> value applies to the largest
+<structfield>bytesperline</structfield> value applies to the first
 plane and is divided by the same factor as the
-<structfield>width</structfield> field for any smaller planes. For
+<structfield>width</structfield> field for the other planes. For
 example the Cb and Cr planes of a YUV 4:2:0 image have half as many
 padding bytes following each line as the Y plane. To avoid ambiguities
 drivers must return a <structfield>bytesperline</structfield> value
