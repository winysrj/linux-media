Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2IXO4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:56:08 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAV00HTS05535D0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:56:07 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAV0044E052DB30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:56:07 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 2/5] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
Date: Mon, 24 Sep 2012 16:55:43 +0200
Message-id: <1348498546-2652-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_PIX_FMT_S5C_UYVY_JPG is a two-plane image format used by
Samsung S5C73M3 camera. The first plane contains interleaved UYVY
and JPEG data, followed by meta-data in form of offsets to the UYVU
data blocks.

The second plane contains additional meta-data needed for extracting
JPEG and UYVY data stream from the first plane, in particular an
offset to the first entry of an array of data offsets in the first
plane. The offsets are expressed as 4-byte unsigned integers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 9 +++++++++
 include/linux/videodev2.h                  | 1 +
 2 files changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 1ddbfab..9caed9b 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -996,6 +996,15 @@ the other bits are set to 0.</entry>
 	    <entry>Old 6-bit greyscale format. Only the most significant 6 bits of each byte are used,
 the other bits are set to 0.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-JPG-YUYV-S5C">
+	    <entry><constant>V4L2_PIX_FMT_S5C_YUYV_JPG</constant></entry>
+	    <entry>'S5CJ'</entry>
+	    <entry>Two-planar format used by Samsung S5C73MX cameras.The first
+plane contains interleaved JPEG and YUYV data, followed by meta data describing
+layout of the YUYV and JPEG data blocks. The second plane contains additional
+information about data layout in the first plane, like an offset to the array
+of offsets to YUVY data chunks.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4862165..aa6fb4d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -435,6 +435,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
 #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
+#define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'J') /* S5C73M3 interleaved YUYV/JPEG */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.7.11.3

