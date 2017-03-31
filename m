Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36451 "EHLO
        epoutp02.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933011AbdCaJFC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:05:02 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v3 07/11] Documentation: v4l: Documentation for HEVC v4l2
 definition
Date: Fri, 31 Mar 2017 14:36:36 +0530
Message-id: <1490951200-32070-8-git-send-email-smitha.t@samsung.com>
In-reply-to: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
        <CGME20170331090444epcas5p43f44be426728ea22d0b13f64f5cf05bd@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2 definition for HEVC compressed format

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
---
 Documentation/media/uapi/v4l/pixfmt-013.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
index 728d7ed..ff4cac2 100644
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
+      - HEVC video elementary stream.
-- 
2.7.4
