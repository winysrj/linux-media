Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41417 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3EaMlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:41:03 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN000KAXW8JPU0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:41:02 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] exynos4-is: Prevent NULL pointer dereference when firmware
 isn't loaded
Date: Fri, 31 May 2013 14:40:35 +0200
Message-id: <1370004037-18314-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
References: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the firmware isn't accessed in the driver when the firmware loading
routine has not completed. This fixes a potential kernel crash:

[   96.510000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   96.520000] pgd = ee604000
[   96.520000] [00000000] *pgd=6e947831, *pte=00000000, *ppte=00000000
[   96.530000] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[   96.530000] Modules linked in:
[   96.530000] CPU: 2 PID: 2787 Comm: camera_test Not tainted 3.10.0-rc1-00269-gcdbde37-dirty #2158
[   96.545000] task: ee42e400 ti: edfcc000 task.ti: edfcc000
[   96.545000] PC is at fimc_is_start_firmware+0x14/0x94
[   96.545000] LR is at fimc_isp_subdev_s_power+0x13c/0x1f8
	...
[   96.745000] [<c03e0354>] (fimc_is_start_firmware+0x14/0x94) from [<c03e1cc4>] (fimc_isp_subdev_s_power+0x13c/0x1f8)
[   96.745000] [<c03e1cc4>] (fimc_isp_subdev_s_power+0x13c/0x1f8) from [<c03ed088>] (__subdev_set_power+0x70/0x84)
[   96.745000] [<c03ed088>] (__subdev_set_power+0x70/0x84) from [<c03ed164>] (fimc_pipeline_s_power+0xc8/0x164)
[   96.745000] [<c03ed164>] (fimc_pipeline_s_power+0xc8/0x164) from [<c03ee2b8>] (__fimc_pipeline_open+0x90/0x268)
[   96.745000] [<c03ee2b8>] (__fimc_pipeline_open+0x90/0x268) from [<c03ec5f0>] (fimc_capture_open+0xe4/0x1ec)
[   96.745000] [<c03ec5f0>] (fimc_capture_open+0xe4/0x1ec) from [<c03c5560>] (v4l2_open+0xa8/0xe4)
[   96.745000] [<c03c5560>] (v4l2_open+0xa8/0xe4) from [<c0112900>] (chrdev_open+0x9c/0x158)
[   96.745000] [<c0112900>] (chrdev_open+0x9c/0x158) from [<c010d3e0>] (do_dentry_open+0x1f4/0x27c)
[   96.745000] [<c010d3e0>] (do_dentry_open+0x1f4/0x27c) from [<c010d558>] (finish_open+0x34/0x50)
[   96.745000] [<c010d558>] (finish_open+0x34/0x50) from [<c011bea0>] (do_last+0x59c/0xbcc)
[   96.745000] [<c011bea0>] (do_last+0x59c/0xbcc) from [<c011c580>] (path_openat+0xb0/0x484)
[   96.745000] [<c011c580>] (path_openat+0xb0/0x484) from [<c011ca58>] (do_filp_open+0x30/0x84)
[   96.745000] [<c011ca58>] (do_filp_open+0x30/0x84) from [<c010d060>] (do_sys_open+0xe8/0x170)
[   96.745000] [<c010d060>] (do_sys_open+0xe8/0x170) from [<c000f040>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index a094bb6..140c58f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -325,6 +325,11 @@ int fimc_is_start_firmware(struct fimc_is *is)
 	struct device *dev = &is->pdev->dev;
 	int ret;
 
+	if (is->fw.f_w == NULL) {
+		dev_err(dev, "firmware is not loaded\n");
+		return -EINVAL;
+	}
+
 	memcpy(is->memory.vaddr, is->fw.f_w->data, is->fw.f_w->size);
 	wmb();
 
@@ -940,7 +945,8 @@ static int fimc_is_remove(struct platform_device *pdev)
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 	fimc_is_put_clocks(is);
 	fimc_is_debugfs_remove(is);
-	release_firmware(is->fw.f_w);
+	if (is->fw.f_w)
+		release_firmware(is->fw.f_w);
 	fimc_is_free_cpu_memory(is);
 
 	return 0;
-- 
1.7.9.5

