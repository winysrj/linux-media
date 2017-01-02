Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:48008 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbdABIu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 03:50:27 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, randy.li@rock-chips.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH 2/2] [media] v4l: Add 10-bits per channel YUV pixel formats
Date: Mon,  2 Jan 2017 16:50:04 +0800
Message-Id: <1483347004-32593-3-git-send-email-ayaka@soulik.info>
In-Reply-To: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:
	V4L2_PIX_FMT_P010
	V4L2_PIX_FMT_P010M
Currently, none of driver uses those format, but some video device
has been confirmed with could as those format for video output.
The Rockchip's new decoder has supported those format for profile_10
HEVC/AVC video.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 include/uapi/linux/videodev2.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 46e8a2e3..9e03f20 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -551,6 +551,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
 #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
+#define V4L2_PIX_FMT_P010    v4l2_fourcc('P', '0', '1', '0') /* 15  Y/CbCr 4:2:0, 10 bits per channel */
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
@@ -559,6 +560,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
 #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
+#define V4L2_PIX_FMT_P010M   v4l2_fourcc('P', 'M', '1', '0') /* 15  Y/CbCr 4:2:0, 10 bits per channel */
 
 /* three planes - Y Cb, Cr */
 #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
-- 
2.7.4

