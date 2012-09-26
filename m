Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29920 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2IZPyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 11:54:43 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00F2NS6UKE21@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:42 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAY000JLS6LTOA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:42 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 2/5] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
Date: Wed, 26 Sep 2012 17:54:10 +0200
Message-id: <1348674853-24596-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of the Samsung S5C73M3 camera specific
image format. V4L2_PIX_FMT_S5C_UYVY_JPG is a two-planar format,
the  first plane contains interleaved UYVY and JPEG data followed
by meta-data. The second plane contains additional meta-data needed
for extracting JPEG and UYVY data stream from the first plane.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 28 ++++++++++++++++++++++++++++
 include/linux/videodev2.h                  |  1 +
 2 files changed, 29 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 1ddbfab..21284ba 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -996,6 +996,34 @@ the other bits are set to 0.</entry>
 	    <entry>Old 6-bit greyscale format. Only the most significant 6 bits of each byte are used,
 the other bits are set to 0.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-S5C-UYVY-JPG">
+	    <entry><constant>V4L2_PIX_FMT_S5C_UYVY_JPG</constant></entry>
+	    <entry>'S5CI'</entry>
+	    <entry>Two-planar format used by Samsung S5C73MX cameras. The
+first plane contains interleaved JPEG and UYVY image data, followed by meta data
+in form of an array of offsets to the UYVY data blocks. The actual pointer array
+follows immediately the interleaved JPEG/UYVY data, the number of entries in
+this array equals the height of the UYVY image. Each entry is a 4-byte unsigned
+integer in big endian order and it's an offset to a single pixel line of the
+UYVY image. The first plane can start either with JPEG or UYVY data chunk. The
+size of a single UYVY block equals the UYVY image's width multiplied by 2. The
+size of a JPEG chunk depends on the image and can vary with each line.
+<para>The second plane, at an offset of 4084 bytes, contains a 4-byte offset to
+the pointer array in the first plane. This offset is followed by a 4-byte value
+indicating size of the pointer array. All numbers in the second plane are also
+in big endian order. Remaining data in the first plane is undefined. The
+information in the second plane allows to easily find location of the pointer
+array, which can be different for each frame. The size of the pointer array is
+constant for given UYVY image height.</para>
+<para>In order to extract UYVY and JPEG frames an application can initially set
+a data pointer to the start of first plane and then add an offset from the first
+entry of the pointers table. Such a pointer indicates start of an UYVY image
+pixel line. Whole UYVY line can be copied to a separate buffer. These steps
+should be repeated for each line, i.e. the number of entries in the pointer
+array. Anything what's in between the UYVY lines is JPEG data and should be
+concatenated to form the JPEG stream. </para>
+</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 8d29bb2..6c82ff5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -436,6 +436,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
 #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
+#define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'J') /* S5C73M3 interleaved UYVY/JPEG */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.7.11.3

