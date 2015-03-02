Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:38614 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbbCBQQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 11:16:30 -0500
Received: by wgha1 with SMTP id a1so34466556wgh.5
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 08:16:29 -0800 (PST)
From: ahaslam@baylibre.com
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: Axel Haslam <ahaslam@baylibre.com>
Subject: [PATCH] [media] soc_camera: fix devm_kfree warning on error path
Date: Mon,  2 Mar 2015 17:16:14 +0100
Message-Id: <1425312974-32477-1-git-send-email-ahaslam@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Axel Haslam <ahaslam@baylibre.com>

Free the original allocated address to take
care of the following warning seen on boot:

WARNING: CPU: 0 PID: 1 at drivers/base/devres.c:887 devm_kfree+0x30/0x40()
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.0.0-rc1-dirty #9
Hardware name: Generic R8A7790 (Flattened Device Tree)
Backtrace:
[<c0011e94>] (dump_backtrace) from [<c001203c>] (show_stack+0x18/0x1c)
 r7:c058ab5d r6:ee0309c0 r5:00000009 r4:00000000
[<c0012024>] (show_stack) from [<c048971c>] (dump_stack+0x78/0x94)
[<c04896a4>] (dump_stack) from [<c0025210>] (warn_slowpath_common+0x88/0xb4)
 r5:00000009 r4:00000000
[<c0025188>] (warn_slowpath_common) from [<c0025314>] (warn_slowpath_null+0x24/0x2c)
 r9:ee148028 r8:ee7dc4b4 r7:ed7e5e10 r6:ed7ee220 r5:fffffffa r4:ee148010
[<c00252f0>] (warn_slowpath_null) from [<c025a074>] (devm_kfree+0x30/0x40)
[<c025a044>] (devm_kfree) from [<c03270ec>] (soc_of_bind.isra.14+0x194/0x1d4)
[<c0326f58>] (soc_of_bind.isra.14) from [<c0327bac>] (soc_camera_host_register+0x208/0x31c)
 r9:0000006a r8:ee7e22c8 r7:ee295a10 r6:00000000 r5:ee7e1f44 r4:ed7ee220
[<c03279a4>] (soc_camera_host_register) from [<c0329d18>] (rcar_vin_probe+0x1f8/0x23c)
 r9:0000006a r8:ee295a00 r7:00000008 r6:ee295a10 r5:ed7ee210 r4:c07db534
[<c0329b20>] (rcar_vin_probe) from [<c0258310>] (platform_drv_probe+0x50/0xa0)
 r10:00000000 r9:c07db27c r8:00000000 r7:c080ae40 r6:c07db27c r5:ee295a10
 r4:ffffffef
[<c02582c0>] (platform_drv_probe) from [<c0256e94>] (driver_probe_device+0xc4/0x208)
 r7:c080ae40 r6:c080ae34 r5:00000000 r4:ee295a10
[<c0256dd0>] (driver_probe_device) from [<c0257094>] (__driver_attach+0x70/0x94)
 r9:c07e7740 r8:00000000 r7:c07d3b60 r6:c07db27c r5:ee295a44 r4:ee295a10
[<c0257024>] (__driver_attach) from [<c02557dc>] (bus_for_each_dev+0x74/0x98)
 r7:c07d3b60 r6:c0257024 r5:c07db27c r4:00000000
[<c0255768>] (bus_for_each_dev) from [<c0257168>] (driver_attach+0x20/0x28)
 r6:ed9af600 r5:00000000 r4:c07db27c
[<c0257148>] (driver_attach) from [<c0255f98>] (bus_add_driver+0xdc/0x1c4)
[<c0255ebc>] (bus_add_driver) from [<c025787c>] (driver_register+0xa4/0xe8)
 r7:c0600410 r6:c0600410 r5:c05e73a4 r4:c07db27c
[<c02577d8>] (driver_register) from [<c0258c58>] (__platform_driver_register+0x50/0x64)
 r5:c05e73a4 r4:ed7e6b00
[<c0258c08>] (__platform_driver_register) from [<c05e73bc>] (rcar_vin_driver_init+0x18/0x20)
[<c05e73a4>] (rcar_vin_driver_init) from [<c05cadec>] (do_one_initcall+0x10c/0x1bc)
[<c05cace0>] (do_one_initcall) from [<c05cafb4>] (kernel_init_freeable+0x118/0x1e0)
 r8:c07e7740 r7:c0608f80 r6:c0600c3c r5:000000ad r4:00000006
[<c05cae9c>] (kernel_init_freeable) from [<c0487018>] (kernel_init+0x14/0xec)
 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0487004 r4:c07e7740
[<c0487004>] (kernel_init) from [<c000eba0>] (ret_from_fork+0x14/0x34)
 r5:c0487004 r4:00000000

Signed-off-by: Axel Haslam <ahaslam@baylibre.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index cee7b56..66634b4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1665,7 +1665,7 @@ eclkreg:
 eaddpdev:
 	platform_device_put(sasc->pdev);
 eallocpdev:
-	devm_kfree(ici->v4l2_dev.dev, sasc);
+	devm_kfree(ici->v4l2_dev.dev, info);
 	dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
 
 	return ret;
-- 
1.9.1

