Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60772 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbbCNLrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:47:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 20/22] videodev2.h: add V4L2_PIX_FMT_XBGR444
Date: Sat, 14 Mar 2015 12:46:59 +0100
Message-Id: <1426333621-21474-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
References: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is similar to XRGB444 but with the red and blue components swapped. It
turns out that the RGB444 format in marvell-ccic driver really was this
variant, so we need a proper definition of that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 22 ++++++++++++++++++++++
 include/uapi/linux/videodev2.h                     |  7 ++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 6ab4f0f..cd6cc81 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -171,6 +171,28 @@ for a pixel lie next to each other in memory.</para>
 	    <entry>r<subscript>1</subscript></entry>
 	    <entry>r<subscript>0</subscript></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-XBGR444">
+	    <entry><constant>V4L2_PIX_FMT_XBGR444</constant></entry>
+	    <entry>'XB12'</entry>
+	    <entry></entry>
+	    <entry>g</entry>
+	    <entry>g</entry>
+	    <entry>g</entry>
+	    <entry>g</entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
+	    <entry></entry>
+	    <entry>-<subscript>3</subscript></entry>
+	    <entry>-<subscript>2</subscript></entry>
+	    <entry>-<subscript>1</subscript></entry>
+	    <entry>-<subscript>0</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-ARGB555">
 	    <entry><constant>V4L2_PIX_FMT_ARGB555</constant></entry>
 	    <entry>'AR15'</entry>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..0b015c1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -375,9 +375,10 @@ struct v4l2_pix_format {
 
 /* RGB formats */
 #define V4L2_PIX_FMT_RGB332  v4l2_fourcc('R', 'G', 'B', '1') /*  8  RGB-3-3-2     */
-#define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4', '4') /* 16  xxxxrrrr ggggbbbb */
-#define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16  aaaarrrr ggggbbbb */
-#define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R', '1', '2') /* 16  xxxxrrrr ggggbbbb */
+#define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4', '4') /* 16  RGB-4-4-4 */
+#define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16  RGB-4-4-4-4 */
+#define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R', '1', '2') /* 16  RGB-4-4-4-4 */
+#define V4L2_PIX_FMT_XBGR444 v4l2_fourcc('X', 'B', '1', '2') /* 16  BGR-4-4-4-4 */
 #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16  RGB-5-5-5     */
 #define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */
 #define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1', '5') /* 16  XRGB-1-5-5-5  */
-- 
2.1.4

