Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62353 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdAaMR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 07:17:27 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] media: exynos4-is: add flags to dummy Exynos IS i2c adapter
Date: Tue, 31 Jan 2017 13:05:53 +0100
Message-id: <1485864353-9205-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170131120559eucas1p171eea15496e67cce34f964484065a714@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add simple 'functionality' member to dummy Exynos IS i2c adapter to make
i2c core happy and get rid of NULL pointer dereference during Exynos4 IS
probe since v4.10-rc1:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 1 PID: 100 Comm: kworker/1:2 Not tainted 4.10.0-rc6-next-20170131-00054-g39e6e4233de6 #1921
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
Workqueue: events deferred_probe_work_func
task: ef2e0000 task.stack: ef2ec000
PC is at 0x0
LR is at i2c_register_adapter+0x98/0x5cc
...
[<c05040bc>] (i2c_register_adapter) from [<c05379d4>] (fimc_is_i2c_probe+0x84/0xe4)
[<c05379d4>] (fimc_is_i2c_probe) from [<c041b5c8>] (platform_drv_probe+0x50/0xb0)
[<c041b5c8>] (platform_drv_probe) from [<c0419f48>] (driver_probe_device+0x234/0x2dc)
[<c0419f48>] (driver_probe_device) from [<c04184e0>] (bus_for_each_drv+0x44/0x8c)
[<c04184e0>] (bus_for_each_drv) from [<c0419c8c>] (__device_attach+0x9c/0x100)
[<c0419c8c>] (__device_attach) from [<c0419374>] (bus_probe_device+0x84/0x8c)
[<c0419374>] (bus_probe_device) from [<c04178d4>] (device_add+0x380/0x528)
[<c04178d4>] (device_add) from [<c05aceb4>] (of_platform_device_create_pdata+0x70/0xa4)
[<c05aceb4>] (of_platform_device_create_pdata) from [<c05acfd4>] (of_platform_bus_create+0xec/0x320)
[<c05acfd4>] (of_platform_bus_create) from [<c05ad264>] (of_platform_populate+0x5c/0xac)
[<c05ad264>] (of_platform_populate) from [<c0533420>] (fimc_is_probe+0x1c0/0x4cc)
[<c0533420>] (fimc_is_probe) from [<c041b5c8>] (platform_drv_probe+0x50/0xb0)
[<c041b5c8>] (platform_drv_probe) from [<c0419f48>] (driver_probe_device+0x234/0x2dc)
[<c0419f48>] (driver_probe_device) from [<c04184e0>] (bus_for_each_drv+0x44/0x8c)
[<c04184e0>] (bus_for_each_drv) from [<c0419c8c>] (__device_attach+0x9c/0x100)
[<c0419c8c>] (__device_attach) from [<c0419374>] (bus_probe_device+0x84/0x8c)
[<c0419374>] (bus_probe_device) from [<c04197a8>] (deferred_probe_work_func+0x60/0x8c)
[<c04197a8>] (deferred_probe_work_func) from [<c01329a4>] (process_one_work+0x120/0x31c)
[<c01329a4>] (process_one_work) from [<c0132bc8>] (process_scheduled_works+0x28/0x38)
[<c0132bc8>] (process_scheduled_works) from [<c0132ddc>] (worker_thread+0x204/0x4ac)
[<c0132ddc>] (worker_thread) from [<c01381b8>] (kthread+0xfc/0x134)
[<c01381b8>] (kthread) from [<c01078b8>] (ret_from_fork+0x14/0x3c)

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 6bba4ca022be..2f559663e51e 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -28,7 +28,14 @@ struct fimc_is_i2c {
  * is implemented in the FIMC-IS subsystem firmware and the host CPU
  * doesn't access the I2C bus controller.
  */
-static const struct i2c_algorithm fimc_is_i2c_algorithm;
+static u32 is_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm fimc_is_i2c_algorithm = {
+	.functionality	= is_i2c_func,
+};
 
 static int fimc_is_i2c_probe(struct platform_device *pdev)
 {
-- 
1.9.1

