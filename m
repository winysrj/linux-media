Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18864 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3BULx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 06:53:27 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIK002FUJP1A1O0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 20:53:25 +0900 (KST)
Received: from shaik-linux.sisodomain.com ([107.108.207.106])
 by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIK00DQ4JNSPK40@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 20:53:25 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] [media] fimc-lite: Fix the variable type to avoid possible
 crash
Date: Thu, 21 Feb 2013 17:24:17 +0530
Message-id: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing the variable type to 'int' from 'unsigned int'. Driver
logic expects the variable type to be 'int'.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index f0af075..3c7dd65 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -128,7 +128,7 @@ static const u32 src_pixfmt_map[8][3] = {
 void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
 {
 	enum v4l2_mbus_pixelcode pixelcode = dev->fmt->mbus_code;
-	unsigned int i = ARRAY_SIZE(src_pixfmt_map);
+	int i = ARRAY_SIZE(src_pixfmt_map);
 	u32 cfg;
 
 	while (i-- >= 0) {
@@ -224,7 +224,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 		{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
 	};
 	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
-	unsigned int i = ARRAY_SIZE(pixcode);
+	int i = ARRAY_SIZE(pixcode);
 
 	while (i-- >= 0)
 		if (pixcode[i][0] == dev->fmt->mbus_code)
-- 
1.7.9.5

