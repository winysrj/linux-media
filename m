Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:37424
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752301AbdHIBbo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 21:31:44 -0400
From: Jeffrey Mouroux <jeff.mouroux@xilinx.com>
To: <mchehab@kernel.org>, <hansverk@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>,
        <sakari.ailus@linux.intel.com>, <tiffany.lin@mediatek.com>,
        <ricardo.ribalda@gmail.com>, <evgeni.raikhel@intel.com>,
        <nick@shmanahar.org>
CC: <linux-media@vger.kernel.org>,
        Jeffrey Mouroux <jmouroux@xilinx.com>
Subject: [PATCH v1 2/2] media: v4l2-core: Update V4L2 framework with new fourcc codes
Date: Tue, 8 Aug 2017 18:31:18 -0700
Message-ID: <1502242278-14686-3-git-send-email-jmouroux@xilinx.com>
In-Reply-To: <1502242278-14686-1-git-send-email-jmouroux@xilinx.com>
References: <1502242278-14686-1-git-send-email-jmouroux@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New fourcc codes have been added to support additional video
memory layout supported by Xilinx Video IP.  These have been
added to the V4L2 framework with this patch.

Signed-off-by: Jeffrey Mouroux <jmouroux@xilinx.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index cab63bb..d3edb7e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1136,6 +1136,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_RGB32:	descr = "32-bit A/XRGB 8-8-8-8"; break;
 	case V4L2_PIX_FMT_ARGB32:	descr = "32-bit ARGB 8-8-8-8"; break;
 	case V4L2_PIX_FMT_XRGB32:	descr = "32-bit XRGB 8-8-8-8"; break;
+	case V4L2_PIX_FMT_XBGR30:	descr = "32-bit XBGR 2-10-10-10"; break;
 	case V4L2_PIX_FMT_GREY:		descr = "8-bit Greyscale"; break;
 	case V4L2_PIX_FMT_Y4:		descr = "4-bit Greyscale"; break;
 	case V4L2_PIX_FMT_Y6:		descr = "6-bit Greyscale"; break;
@@ -1161,6 +1162,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_YUV411P:	descr = "Planar YUV 4:1:1"; break;
 	case V4L2_PIX_FMT_Y41P:		descr = "YUV 4:1:1 (Packed)"; break;
 	case V4L2_PIX_FMT_YUV444:	descr = "16-bit A/XYUV 4-4-4-4"; break;
+	case V4L2_PIX_FMT_XVUY32:	descr = "32-bit packed XVUY 8-8-8-8"; break;
+	case V4L2_PIX_FMT_AVUY32:	descr = "32-bit packed AVUY 8-8-8-8"; break;
+	case V4L2_PIX_FMT_VUY24:	descr = "24-bit packed VUY 8-8-8"; break;
 	case V4L2_PIX_FMT_YUV555:	descr = "16-bit A/XYUV 1-5-5-5"; break;
 	case V4L2_PIX_FMT_YUV565:	descr = "16-bit YUV 5-6-5"; break;
 	case V4L2_PIX_FMT_YUV32:	descr = "32-bit A/XYUV 8-8-8-8"; break;
@@ -1169,16 +1173,21 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_HI240:	descr = "8-bit Dithered RGB (BTTV)"; break;
 	case V4L2_PIX_FMT_HM12:		descr = "YUV 4:2:0 (16x16 Macroblocks)"; break;
 	case V4L2_PIX_FMT_M420:		descr = "YUV 4:2:0 (M420)"; break;
+	case V4L2_PIX_FMT_XVUY10:	descr = "XVUY 2-10-10-10"; break;
 	case V4L2_PIX_FMT_NV12:		descr = "Y/CbCr 4:2:0"; break;
 	case V4L2_PIX_FMT_NV21:		descr = "Y/CrCb 4:2:0"; break;
 	case V4L2_PIX_FMT_NV16:		descr = "Y/CbCr 4:2:2"; break;
 	case V4L2_PIX_FMT_NV61:		descr = "Y/CrCb 4:2:2"; break;
 	case V4L2_PIX_FMT_NV24:		descr = "Y/CbCr 4:4:4"; break;
 	case V4L2_PIX_FMT_NV42:		descr = "Y/CrCb 4:4:4"; break;
+	case V4L2_PIX_FMT_XV20:		descr = "Y/CrCb 4:2:2 10-bit w/padding"; break;
+	case V4L2_PIX_FMT_XV15:		descr = "Y/CrCb 4:2:0 10-bit w/padding"; break;
 	case V4L2_PIX_FMT_NV12M:	descr = "Y/CbCr 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_NV21M:	descr = "Y/CrCb 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_NV16M:	descr = "Y/CbCr 4:2:2 (N-C)"; break;
 	case V4L2_PIX_FMT_NV61M:	descr = "Y/CrCb 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_XV20M:	descr = "Y/CrCb 4:2:2 (N-C) 10-bit w/padding"; break;
+	case V4L2_PIX_FMT_XV15M:	descr = "Y/CrCb 4:2:0 (N-C) 10-bit w/padding"; break;
 	case V4L2_PIX_FMT_NV12MT:	descr = "Y/CbCr 4:2:0 (64x32 MB, N-C)"; break;
 	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/CbCr 4:2:0 (16x16 MB, N-C)"; break;
 	case V4L2_PIX_FMT_YUV420M:	descr = "Planar YUV 4:2:0 (N-C)"; break;
-- 
1.9.1
