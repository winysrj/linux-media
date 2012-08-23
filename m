Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19599 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab2HWJwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 05:52:23 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700EG3CQH07Z0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:22 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9700GHMCQHII60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:18 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 3/4] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
Date: Thu, 23 Aug 2012 11:51:28 +0200
Message-id: <1345715489-30158-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_S5C_UYVY_JPG is a single-planar image format generated
by S5C73M3 camera. The image data consist of interleaved JPEG compressed
data and raw UYVY data and the meta data appended at the end.

The meta-data is a list of offsets to UYVY data blocks of fixed size, which
may be followed by a JPEG data chunk. Whether the JPEG chunk is present
between two subsequent VYUY blocks can be figured out from the difference
between two offset values.
All numbers are 4 byte unsigned integers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 10 ++++++++++
 include/linux/videodev2.h                  |  1 +
 2 files changed, 11 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index e58934c..8492ffb 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -995,6 +995,16 @@ the other bits are set to 0.</entry>
 	    <entry>Old 6-bit greyscale format. Only the most significant 6 bits of each byte are used,
 the other bits are set to 0.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-S5C-UYVY-JPG">
+	    <entry><constant>V4L2_PIX_FMT_S5C_UYVY_JPG</constant></entry>
+	    <entry>'S5CJ'</entry>
+	    <entry>A single planar image format generated by S5C73M3 camera.
+An interleaved JPEG compressed and raw UYVY data which is immediatey followed
+by a meta data containing a list of offsets to the UYVY data blocks. The
+meta-data is a list of offsets to UYVY chunks of fixed size, which may be
+followed by an JPEG data chunk. All numbers in the meta-data part are 4-byte
+unsigned integers.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index d3fd19f..fc7ee90 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -434,6 +434,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
 #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
+#define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.7.11.3

