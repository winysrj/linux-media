Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0050.outbound.protection.outlook.com ([104.47.37.50]:11808
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750736AbeBGW36 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 17:29:58 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Jeffrey Mouroux <jmouroux@xilinx.com>,
        Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH 3/8] uapi: media: New fourcc codes needed by Xilinx Video IP
Date: Wed, 7 Feb 2018 14:29:33 -0800
Message-ID: <1518042578-22771-4-git-send-email-satishna@xilinx.com>
In-Reply-To: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
References: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeffrey Mouroux <jmouroux@xilinx.com>

The Xilinx Video Framebuffer DMA IP supports video memory formats
that are not represented in the current V4L2 fourcc library. This
patch adds those missing fourcc codes. This includes both new
8-bit and 10-bit pixel formats.

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 include/uapi/linux/videodev2.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.=
h
index 9827189..9fa4313c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -509,7 +509,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2', '4') /* 32  BGRX-8=
-8-8-8  */
 #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-8-=
8-8-8   */
 #define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32  ARGB-8=
-8-8-8  */
+#define V4L2_PIX_FMT_BGRA32  v4l2_fourcc('A', 'B', 'G', 'R') /* 32  ABGR-8=
-8-8-8  */
 #define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2', '4') /* 32  XRGB-8=
-8-8-8  */
+#define V4L2_PIX_FMT_BGRX32  v4l2_fourcc('X', 'B', 'G', 'R') /* 32  XBGR-8=
-8-8-8 */
+#define V4L2_PIX_FMT_XBGR30  v4l2_fourcc('R', 'X', '3', '0') /* 32  XBGR-2=
-10-10-10 */

 /* Grey formats */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greysc=
ale     */
@@ -537,12 +540,16 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:=
2:2     */
 #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:=
1:1     */
 #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxxyy=
yy uuuuvvvv */
+#define V4L2_PIX_FMT_XVUY32  v4l2_fourcc('X', 'V', '3', '2') /* 32  XVUY 8=
:8:8:8 */
+#define V4L2_PIX_FMT_AVUY32  v4l2_fourcc('A', 'V', '3', '2') /* 32  AVUY 8=
:8:8:8 */
+#define V4L2_PIX_FMT_VUY24   v4l2_fourcc('V', 'U', '2', '4') /* 24  VUY 8:=
8:8 */
 #define V4L2_PIX_FMT_YUV555  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16  YUV-5-=
5-5     */
 #define V4L2_PIX_FMT_YUV565  v4l2_fourcc('Y', 'U', 'V', 'P') /* 16  YUV-5-=
6-5     */
 #define V4L2_PIX_FMT_YUV32   v4l2_fourcc('Y', 'U', 'V', '4') /* 32  YUV-8-=
8-8-8   */
 #define V4L2_PIX_FMT_HI240   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit =
color   */
 #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:=
2:0 16x16 macroblocks */
 #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:=
2:0 2 lines y, 1 line uv interleaved */
+#define V4L2_PIX_FMT_XVUY10  v4l2_fourcc('X', 'Y', '1', '0') /* 32  XVUY 2=
-10-10-10 */

 /* two planes -- one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr=
 4:2:0  */
@@ -551,6 +558,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb=
 4:2:2  */
 #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr=
 4:4:4  */
 #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb=
 4:4:4  */
+#define V4L2_PIX_FMT_XV20    v4l2_fourcc('X', 'V', '2', '0') /* 32  XY/UV =
4:2:2 10-bit */
+#define V4L2_PIX_FMT_XV15    v4l2_fourcc('X', 'V', '1', '5') /* 32  XY/UV =
4:2:0 10-bit */

 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr=
 4:2:0  */
@@ -558,6 +567,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr=
 4:2:2  */
 #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb=
 4:2:2  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr=
 4:2:0 64x32 macroblocks */
+#define V4L2_PIX_FMT_XV20M   v4l2_fourcc('X', 'M', '2', '0') /* 32  XY/UV =
4:2:2 10-bit */
+#define V4L2_PIX_FMT_XV15M   v4l2_fourcc('X', 'M', '1', '5') /* 32  XY/UV =
4:2:0 10-bit */
 #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y=
/CbCr 4:2:0 16x16 macroblocks */

 /* three planes - Y Cb, Cr */
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
