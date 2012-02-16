Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2BPSYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:08 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZI00GKN0G4O3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI000JF0G33H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 2/6] V4L: Add V4L2_PIX_FMT_JPG_YUV_S5C fourcc definition
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_JPG_YUV_S5C is a two-plane image format generated
by S5C73M3 camera. The first plane contains interleaved JPEG and
YUYV data and the second one the meta data containing offsets
(pointers) to the YUYV data blocks. First 4 bytes of the meta
data plane indicate total size of the image data plane, subsequent
4 bytes indicate actual size of the meta data and the remainder
is a list of offsets to YUYV blocks within the first plane.
All numbers are 4 byte unsigned integers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml |    8 ++++++++
 include/linux/videodev2.h                  |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 31eaae2..0512f2b 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -999,6 +999,14 @@ the other bits are set to 0.</entry>
 	    <entry>Old 6-bit greyscale format. Only the least significant 6 bits of each byte are used,
 the other bits are set to 0.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-JPG-YUYV-S5C">
+	    <entry><constant>V4L2_PIX_FMT_JPG_YUYV_S5C</constant></entry>
+	    <entry>'S5CJ'</entry>
+	    <entry>Two-planar format used by Samsung S5C73MX cameras.The first plane contains
+interleaved JPEG and YUYV data and the second one the meta data containing a list of offsets
+to the YUYV data blocks within first plane. All numbers in the second plane are 4-byte unsigned
+integers.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 740b35b..4fdba17 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -415,6 +415,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
 #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
+#define V4L2_PIX_FMT_JPG_YUYV_S5C v4l2_fourcc('S', '5', 'C', 'J') /* S5C73M3 interleaved JPEG/YUYV */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.7.9

