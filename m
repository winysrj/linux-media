Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44576 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JOJtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 05:49:49 -0400
From: Ritesh Kumar Solanki <r.solanki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
Subject: [PATCH] [media] s5p-csis: Added RAW data format as the supported
 format.
Date: Mon, 15 Oct 2012 15:18:03 +0530
Message-id: <1350294483-7417-1-git-send-email-r.solanki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

csis can support jpeg, yuv and raw data format.

Signed-off-by: Ritesh Kumar Solanki <r.solanki@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 2f73d9e..0205ae4 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -145,6 +145,10 @@ static const struct csis_pix_format s5pcsis_formats[] = {
 		.code = V4L2_MBUS_FMT_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
 		.data_alignment = 32,
+	}, {
+		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.fmt_reg = S5PCSIS_CFG_FMT_RAW10,
+		.data_alignment = 24,
 	},
 };
 
-- 
1.7.2.3

