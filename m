Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:47994 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755387AbdABIuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 03:50:23 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, randy.li@rock-chips.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH 1/2] drm_fourcc: Add new P010 video format
Date: Mon,  2 Jan 2017 16:50:03 +0800
Message-Id: <1483347004-32593-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
per channel video format. Rockchip's vop support this
video format(little endian only) as the input video format.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 include/uapi/drm/drm_fourcc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 9e1bb7f..d2721da 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -119,6 +119,7 @@ extern "C" {
 #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
 #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
+#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
 
 /*
  * 3 plane YCbCr
-- 
2.7.4

