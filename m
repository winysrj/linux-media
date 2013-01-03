Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49174 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3ACPp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:45:28 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2001EF3RJLA20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:26 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002B73RD7GA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:26 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Tony Prisk <linux@prisktech.co.nz>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/5] s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
Date: Thu, 03 Jan 2013 16:45:09 +0100
Message-id: <1357227910-28870-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
References: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony Prisk <linux@prisktech.co.nz>

Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 41ddfee..c243220 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -732,7 +732,7 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
 		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
 		clock = clk_get(NULL, clk_name);
-		if (IS_ERR_OR_NULL(clock)) {
+		if (IS_ERR(clock)) {
 			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s",
 				  clk_name);
 			return -ENXIO;
-- 
1.7.9.5

