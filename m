Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34179 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758718AbcHYJkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:11 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 03/10] v4l: Add sunxi Video Engine pixel format
Date: Thu, 25 Aug 2016 11:39:42 +0200
Message-Id: <1472117989-21455-4-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the allwinner's proprietary pixel format described in
details here: http://linux-sunxi.org/File:Ve_tile_format_v1.pdf

This format is similar to V4L2_PIX_FMT_NV12M but the planes are divided
in tiles of 32x32px.

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 904c44c..96e034d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -627,6 +627,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
 #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
+#define V4L2_PIX_FMT_SUNXI    v4l2_fourcc('S', 'X', 'I', 'Y') /* Sunxi VE's 32x32 tiled NV12 */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-- 
2.7.4

