Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:42912 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932616AbdDFGKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 02:10:18 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v4 07/12] Documentation: v4l: Documentation for HEVC v4l2
 definition
Date: Thu, 06 Apr 2017 11:41:40 +0530
Message-id: <1491459105-16641-8-git-send-email-smitha.t@samsung.com>
In-reply-to: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061015epcas1p3488865b9f19fee1a799867106729307f@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2 definition for HEVC compressed format which is also
known as H.265.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 Documentation/media/uapi/v4l/pixfmt-013.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
index 728d7ed..abec039 100644
--- a/Documentation/media/uapi/v4l/pixfmt-013.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
@@ -90,3 +90,8 @@ Compressed Formats
       - ``V4L2_PIX_FMT_VP9``
       - 'VP90'
       - VP9 video elementary stream.
+    * .. _V4L2-PIX-FMT-HEVC:
+
+      - ``V4L2_PIX_FMT_HEVC``
+      - 'HEVC'
+      - HEVC/H.265 video elementary stream.
-- 
2.7.4
