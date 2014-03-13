Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44194 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbaCMRRv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 13:17:51 -0400
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v11][ 01/12] [media] v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
Date: Thu, 13 Mar 2014 18:17:22 +0100
Message-Id: <1394731053-6118-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That new macro is needed by the imx_drm staging driver
  for supporting the QVGA display of the eukrea-cpuimx51 board.

Signed-off-by: Denis Carikli <denis@eukrea.com>
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
ChangeLog v9->v10:
- Rebased on top of:
  "211e7f2 [media] DocBook media: drop the old incorrect packed RGB table"
- Added Philipp Zabel's Ack.

ChangeLog v8->v9:
- Removed the Cc. They are now set in git-send-email directly.

ChangeLog v7->v8:
- Added Mauro Carvalho Chehab back to the list of Cc

ChangeLog v6->v7:
- Shrinked even more the Cc list.
ChangeLog v5->v6:
- Remove people not concerned by this patch from the Cc list.

ChangeLog v3->v4:
- Added Laurent Pinchart's Ack.

ChangeLog v2->v3:
- Added some interested people in the Cc list.
- Added Mauro Carvalho Chehab's Ack.
- Added documentation.
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   39 ++++++++++++++++++++
 include/uapi/linux/videodev2.h                     |    1 +
 2 files changed, 40 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index e1c4f8b..88a7fe1 100644
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
index 4dc7052..efcbc15 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -299,6 +299,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
 #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */
+#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
 #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-- 
1.7.9.5

