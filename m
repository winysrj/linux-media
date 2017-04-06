Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35692 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932507AbdDFGKR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 02:10:17 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v4 05/12] [media] videodev2.h: Add v4l2 definition for HEVC
Date: Thu, 06 Apr 2017 11:41:38 +0530
Message-id: <1491459105-16641-6-git-send-email-smitha.t@samsung.com>
In-reply-to: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061010epcas5p22e8100bbd1456007fb4fff327d1f81c8@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2 definition for HEVC compressed format

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 316be62..03d4765 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -628,6 +628,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
+#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
2.7.4
