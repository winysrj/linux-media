Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54674 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdFSFZQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 01:25:16 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v5 07/12] Documentation: v4l: Documentation for HEVC v4l2
 definition
Date: Mon, 19 Jun 2017 10:40:50 +0530
Message-id: <1497849055-26583-8-git-send-email-smitha.t@samsung.com>
In-reply-to: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052509epcas1p4841f9c3733280a232d35c8624fe80576@epcas1p4.samsung.com>
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
