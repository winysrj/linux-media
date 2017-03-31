Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36412 "EHLO
        epoutp02.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755104AbdCaJEp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:04:45 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v3 05/11] [media] videodev2.h: Add v4l2 definition for HEVC
Date: Fri, 31 Mar 2017 14:36:34 +0530
Message-id: <1490951200-32070-6-git-send-email-smitha.t@samsung.com>
In-reply-to: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
        <CGME20170331090438epcas1p4152c9aaa9ea69f30d264bcd532d79e75@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2 definition for HEVC compressed format

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45184a2..38cf5f1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -629,6 +629,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
+#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
2.7.4
