Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:16119 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2IENZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 09:25:37 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] s5p-fimc: fimc-lite: Correct Bayer pixel format definitions
Date: Wed, 05 Sep 2012 15:25:07 +0200
Message-id: <1346851508-16705-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace erroneous V4L2_PIX_FMT_* entries with their V4L2_MBUS_FMT_*
counterparts. This enables use of raw Bayer formats on FIMC-LITE.?
subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-lite-reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.c b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
index 09dc71e..a22d7eb 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
@@ -118,9 +118,9 @@ static const u32 src_pixfmt_map[8][3] = {
 	  FLITE_REG_CIGCTRL_YUV422_1P },
 	{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY,
 	  FLITE_REG_CIGCTRL_YUV422_1P },
-	{ V4L2_PIX_FMT_SGRBG8, 0, FLITE_REG_CIGCTRL_RAW8 },
-	{ V4L2_PIX_FMT_SGRBG10, 0, FLITE_REG_CIGCTRL_RAW10 },
-	{ V4L2_PIX_FMT_SGRBG12, 0, FLITE_REG_CIGCTRL_RAW12 },
+	{ V4L2_MBUS_FMT_SGRBG8_1X8, 0, FLITE_REG_CIGCTRL_RAW8 },
+	{ V4L2_MBUS_FMT_SGRBG10_1X10, 0, FLITE_REG_CIGCTRL_RAW10 },
+	{ V4L2_MBUS_FMT_SGRBG12_1X12, 0, FLITE_REG_CIGCTRL_RAW12 },
 	{ V4L2_MBUS_FMT_JPEG_1X8, 0, FLITE_REG_CIGCTRL_USER(1) },
 };
 
-- 
1.7.11.3

