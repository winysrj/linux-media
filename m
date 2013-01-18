Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:64322 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3ARRHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 12:07:48 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT005VOZKY8200@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 02:07:46 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGT008MLZKPCN80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 02:07:46 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, dh09.lee@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-csis: Fix clock handling on error path in probe()
Date: Fri, 18 Jan 2013 18:07:32 +0100
Message-id: <1358528852-13858-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move e_clkput label after the clk_disable() call so a not acquired clock
is not attempted to be disabled. This fixes runtime warnings like:

 s5p-mipi-csis 11880000.csis: failed to get clock: sclk_csis
 ------------[ cut here ]------------
 WARNING: at drivers/clk/clk.c:478 clk_disable+0x24/0x34()
 Modules linked in:
 [<c001603c>] (unwind_backtrace+0x0/0x13c) from [<c0022060>] (warn_slowpath_common+0x54/0x64)
 [<c0022060>] (warn_slowpath_common+0x54/0x64) from [<c002208c>] (warn_slowpath_null+0x1c/0x24)
 [<c002208c>] (warn_slowpath_null+0x1c/0x24) from [<c033f868>] (clk_disable+0x24/0x34)
 [<c033f868>] (clk_disable+0x24/0x34) from [<c02feff8>] (s5pcsis_probe+0x25c/0x4c8)
 [<c02feff8>] (s5pcsis_probe+0x25c/0x4c8) from [<c0268e34>] (platform_drv_probe+0x18/0x1c)
 [<c0268e34>] (platform_drv_probe+0x18/0x1c) from [<c0267700>] (driver_probe_device+0xa4/0x368)
 [<c0267700>] (driver_probe_device+0xa4/0x368) from [<c0267a50>] (__driver_attach+0x8c/0x90)
 [<c0267a50>] (__driver_attach+0x8c/0x90) from [<c0265c94>] (bus_for_each_dev+0x60/0x8c)
 [<c0265c94>] (bus_for_each_dev+0x60/0x8c) from [<c02665e8>] (bus_add_driver+0x20c/0x2d4)
 [<c02665e8>] (bus_add_driver+0x20c/0x2d4) from [<c0268064>] (driver_register+0x78/0x194)
 [<c0268064>] (driver_register+0x78/0x194) from [<c0008668>] (do_one_initcall+0x34/0x188)
 [<c0008668>] (do_one_initcall+0x34/0x188) from [<c03de57c>] (kernel_init+0x180/0x2f0)
 [<c03de57c>] (kernel_init+0x180/0x2f0) from [<c000f0d8>] (ret_from_fork+0x14/0x3c)
 ---[ end trace 0c5a55345c42530b ]---

Cc: stable@vger.kernel.org  # 3.4
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 357ef2a..1dc52a0 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -873,8 +873,8 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)

 e_regput:
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
-e_clkput:
 	clk_disable(state->clock[CSIS_CLK_MUX]);
+e_clkput:
 	s5pcsis_clk_put(state);
 	return ret;
 }
--
1.7.9.5

