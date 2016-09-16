Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32008 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbcIPGPR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 02:15:17 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()
Date: Fri, 16 Sep 2016 08:14:33 +0200
Message-id: <1474006490-13283-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20160916061511eucas1p21e71e28d5f12ef94694ccbdec8379774@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_mfc_alloc_memdev() function lacks proper releasing of allocated device
in case of reserved memory initialization failure. This results in NULL pointer
dereference:
[    2.828457] Unable to handle kernel NULL pointer dereference at virtual address 00000001
[    2.835089] pgd = c0004000
[    2.837752] [00000001] *pgd=00000000
[    2.844696] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    2.848680] Modules linked in:
[    2.851722] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.8.0-rc6-00002-gafa1b97 #878
[    2.859357] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[    2.865433] task: ef080000 task.stack: ef06c000
[    2.869952] PC is at strcmp+0x0/0x30
[    2.873508] LR is at platform_match+0x84/0xac
[    2.877847] pc : [<c032621c>]    lr : [<c03f65e8>]    psr: 20000013
[    2.877847] sp : ef06dea0  ip : 00000000  fp : 00000000
[    2.889303] r10: 00000000  r9 : c0b34848  r8 : c0b1e968
[    2.894511] r7 : 00000000  r6 : 00000001  r5 : c086e7fc  r4 : eeb8e010
[    2.901021] r3 : 0000006d  r2 : 00000000  r1 : c086e7fc  r0 : 00000001
[    2.907533] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    2.914649] Control: 10c5387d  Table: 4000404a  DAC: 00000051
[    2.920378] Process swapper/0 (pid: 1, stack limit = 0xef06c210)
[    2.926367] Stack: (0xef06dea0 to 0xef06e000)
[    2.930711] dea0: eeb8e010 c0c2d91c c03f4a6c c03f4a8c 00000000 c0c2d91c c03f4a6c c03f2fc8
[    2.938870] dec0: ef003274 ef10c4c0 c0c2d91c ef10cc80 c0c21270 c03f3fa4 c09c1be8 c0c2d91c
[    2.947028] dee0: 00000006 c0c2d91c 00000006 c0b3483c c0c47000 c03f5314 c0c2d908 c0b5fed8
[    2.955188] df00: 00000006 c010178c 60000013 c0a4ef14 00000000 c06feaa0 ef080000 60000013
[    2.963347] df20: 00000000 c0c095c8 efffca76 c0816b8c 000000d5 c0134098 c0b34848 c09d6cdc
[    2.971506] df40: c0a4de70 00000000 00000006 00000006 c0c09568 efffca40 c0b5fed8 00000006
[    2.979665] df60: c0b3483c c0c47000 000000d5 c0b34848 c0b005a4 c0b00d84 00000006 00000006
[    2.987824] df80: 00000000 c0b005a4 00000000 c06fb4d8 00000000 00000000 00000000 00000000
[    2.995983] dfa0: 00000000 c06fb4e0 00000000 c01079b8 00000000 00000000 00000000 00000000
[    3.004142] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    3.012302] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 ffffffff ffffffff
[    3.020469] [<c032621c>] (strcmp) from [<c03f65e8>] (platform_match+0x84/0xac)
[    3.027672] [<c03f65e8>] (platform_match) from [<c03f4a8c>] (__driver_attach+0x20/0xb0)
[    3.035654] [<c03f4a8c>] (__driver_attach) from [<c03f2fc8>] (bus_for_each_dev+0x54/0x88)
[    3.043812] [<c03f2fc8>] (bus_for_each_dev) from [<c03f3fa4>] (bus_add_driver+0xe8/0x1f4)
[    3.051971] [<c03f3fa4>] (bus_add_driver) from [<c03f5314>] (driver_register+0x78/0xf4)
[    3.059958] [<c03f5314>] (driver_register) from [<c010178c>] (do_one_initcall+0x3c/0x16c)
[    3.068123] [<c010178c>] (do_one_initcall) from [<c0b00d84>] (kernel_init_freeable+0x120/0x1ec)
[    3.076802] [<c0b00d84>] (kernel_init_freeable) from [<c06fb4e0>] (kernel_init+0x8/0x118)
[    3.084958] [<c06fb4e0>] (kernel_init) from [<c01079b8>] (ret_from_fork+0x14/0x3c)
[    3.092506] Code: 1afffffb e12fff1e e1a03000 eafffff7 (e4d03001)
[    3.098618] ---[ end trace 511bf9d750810709 ]---
[    3.103207] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

This patch fixes this issue.

Fixes: c79667dd93b084fe412bcfe7fbf0ba43f7dec520 ("media: s5p-mfc: replace custom
	reserved memory handling code with generic one")
CC: stable@vger.kernel.org  # v4.7+
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e3f104f..9e88c2f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1073,6 +1073,7 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 							 idx);
 		if (ret == 0)
 			return child;
+		device_del(child);
 	}
 
 	put_device(child);
-- 
1.9.1

