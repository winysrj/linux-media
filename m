Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46818 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2K1TJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:53 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700HZQP81F3B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:52 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:52 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 06/12] s5p-csis: Add support for raw Bayer pixel formats
Date: Wed, 28 Nov 2012 20:09:23 +0100
Message-id: <1354129766-2821-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI CSIS device supports MIPI CSI-2 RAW8, RAW10, RAW12 data
types. Add related media bus pixel format definitions. This
doesn't cover all possible supported media bus pixel formats.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4c961b1..a6791b5 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -220,6 +220,18 @@ static const struct csis_pix_format s5pcsis_formats[] = {
 		.code = V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
 		.data_alignment = 32,
+	}, {
+		.code = V4L2_MBUS_FMT_SGRBG8_1X8,
+		.fmt_reg = S5PCSIS_CFG_FMT_RAW8,
+		.data_alignment = 24,
+	}, {
+		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.fmt_reg = S5PCSIS_CFG_FMT_RAW10,
+		.data_alignment = 24,
+	}, {
+		.code = V4L2_MBUS_FMT_SGRBG12_1X12,
+		.fmt_reg = S5PCSIS_CFG_FMT_RAW12,
+		.data_alignment = 24,
 	}
 };
 
-- 
1.7.9.5

