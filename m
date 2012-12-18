Return-path: <linux-media-owner@vger.kernel.org>
Received: from server.prisktech.co.nz ([115.188.14.127]:55912 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2LRI3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 03:29:03 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tony Prisk <linux@prisktech.co.nz>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/6] clk: s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
Date: Tue, 18 Dec 2012 21:28:40 +1300
Message-Id: <1355819321-21914-6-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1355819321-21914-1-git-send-email-linux@prisktech.co.nz>
References: <1355819321-21914-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 0531ab7..3ac4da2 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -730,7 +730,7 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
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

