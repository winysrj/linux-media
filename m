Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55401 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932748AbaDIMz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 08:55:28 -0400
In-Reply-To: <20140409125354.GP16119@n2100.arm.linux.org.uk>
References: <20140409125354.GP16119@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 7/8] v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
Message-Id: <E1WXs2H-0002bC-0k@rmk-PC.arm.linux.org.uk>
Date: Wed, 09 Apr 2014 13:55:25 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Denis Carikli <denis@eukrea.com>
To: linux-arm-kernel@lists.infradead.org

That new macro is needed by the imx_drm staging driver
  for supporting the QVGA display of the eukrea-cpuimx51 board.

Signed-off-by: Denis Carikli <denis@eukrea.com>
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 39 ++++++++++++++++++++++
 include/uapi/linux/videodev2.h                     |  1 +
 2 files changed, 40 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 166c8d65e4f7..3207295c15fa 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -279,6 +279,45 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry></entry>
 	    <entry></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-RGB666">
+	    <entry><constant>V4L2_PIX_FMT_RGB666</constant></entry>
+	    <entry>'RGBH'</entry>
+	    <entry></entry>
+	    <entry>r<subscript>5</subscript></entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
+	    <entry>g<subscript>5</subscript></entry>
+	    <entry>g<subscript>4</subscript></entry>
+	    <entry></entry>
+	    <entry>g<subscript>3</subscript></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
+	    <entry>b<subscript>5</subscript></entry>
+	    <entry>b<subscript>4</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-BGR24">
 	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
 	    <entry>'BGR3'</entry>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe988cc..3051d67fcf5a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -294,6 +294,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
 #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */
+#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
 #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-- 
1.8.3.1

