Return-path: <linux-media-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:52235 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbBSJrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:47:19 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Ben Dooks <ben.dooks@codethink.co.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	stable@vger.kernel.org
Subject: [PATCH v2] [media] soc-camera: Fix devm_kfree() in soc_of_bind()
Date: Thu, 19 Feb 2015 10:47:16 +0100
Message-Id: <1424339236-11630-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unlike scan_async_group(), soc_of_bind() doesn't allocate its
soc_camera_async_client structure using devm_kzalloc(), but has it
embedded inside the soc_of_info structure.  Hence on failure, it must
free the whole soc_of_info structure, and not just the embedded
soc_camera_async_client structure, as the latter causes a warning, and
may cause slab corruption:

    soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 1 at drivers/base/devres.c:887 devm_kfree+0x30/0x40()
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-shmobile-08386-g37feb0d093cb2d8e #128
    Hardware name: Generic R8A7791 (Flattened Device Tree)
    Backtrace:
    [<c0011e7c>] (dump_backtrace) from [<c0012024>] (show_stack+0x18/0x1c)
     r6:c05a923b r5:00000009 r4:00000000 r3:00204140
    [<c001200c>] (show_stack) from [<c048ed30>] (dump_stack+0x78/0x94)
    [<c048ecb8>] (dump_stack) from [<c002687c>] (warn_slowpath_common+0x8c/0xb8)
     r4:00000000 r3:00000000
    [<c00267f0>] (warn_slowpath_common) from [<c0026980>] (warn_slowpath_null+0x24/0x2c)
     r8:ee7d8214 r7:ed83b810 r6:ed83bc20 r5:fffffffa r4:ed83e510
    [<c002695c>] (warn_slowpath_null) from [<c025e0cc>] (devm_kfree+0x30/0x40)
    [<c025e09c>] (devm_kfree) from [<c032bbf4>] (soc_of_bind.isra.14+0x194/0x1d4)
    [<c032ba60>] (soc_of_bind.isra.14) from [<c032c6b8>] (soc_camera_host_register+0x208/0x31c)
     r9:00000070 r8:ee7e05d0 r7:ee153210 r6:00000000 r5:ee7e0218 r4:ed83bc20
    [<c032c4b0>] (soc_camera_host_register) from [<c032e80c>] (rcar_vin_probe+0x1f4/0x238)
     r8:ee153200 r7:00000008 r6:ee153210 r5:ed83bc10 r4:c066319c r3:000000c0
    [<c032e618>] (rcar_vin_probe) from [<c025c334>] (platform_drv_probe+0x50/0xa0)
     r10:00000000 r9:c0662fa8 r8:00000000 r7:c06a3700 r6:c0662fa8 r5:ee153210
     r4:00000000
    [<c025c2e4>] (platform_drv_probe) from [<c025af08>] (driver_probe_device+0xc4/0x208)
     r6:c06a36f4 r5:00000000 r4:ee153210 r3:c025c2e4
    [<c025ae44>] (driver_probe_device) from [<c025b108>] (__driver_attach+0x70/0x94)
     r9:c066f9c0 r8:c0624a98 r7:c065b790 r6:c0662fa8 r5:ee153244 r4:ee153210
    [<c025b098>] (__driver_attach) from [<c025984c>] (bus_for_each_dev+0x74/0x98)
     r6:c025b098 r5:c0662fa8 r4:00000000 r3:00000001
    [<c02597d8>] (bus_for_each_dev) from [<c025b1dc>] (driver_attach+0x20/0x28)
     r6:ed83c200 r5:00000000 r4:c0662fa8
    [<c025b1bc>] (driver_attach) from [<c025a00c>] (bus_add_driver+0xdc/0x1c4)
    [<c0259f30>] (bus_add_driver) from [<c025b8f4>] (driver_register+0xa4/0xe8)
     r7:c0624a98 r6:00000000 r5:c060b010 r4:c0662fa8
    [<c025b850>] (driver_register) from [<c025ccd0>] (__platform_driver_register+0x50/0x64)
     r5:c060b010 r4:ed8394c0
    [<c025cc80>] (__platform_driver_register) from [<c060b028>] (rcar_vin_driver_init+0x18/0x20)
    [<c060b010>] (rcar_vin_driver_init) from [<c05edde8>] (do_one_initcall+0x108/0x1b8)
    [<c05edce0>] (do_one_initcall) from [<c05edfb4>] (kernel_init_freeable+0x11c/0x1e4)
     r9:c066f9c0 r8:c066f9c0 r7:c062eab0 r6:c06252c4 r5:000000ad r4:00000006
    [<c05ede98>] (kernel_init_freeable) from [<c048c3d0>] (kernel_init+0x10/0xec)
     r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c048c3c0 r4:00000000
    [<c048c3c0>] (kernel_init) from [<c000eba0>] (ret_from_fork+0x14/0x34)
     r4:00000000 r3:ee04e000
    ---[ end trace e3a984cc0335c8a0 ]---
    rcar_vin e6ef1000.video: group probe failed: -6

Fixes: 1ddc6a6caa94e1e1 ("[media] soc_camera: add support for dt binding soc_camera drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Triggered with shmobile-defconfig on r8a7791/koelsch.

v2:
  - Free info instead of removing the call to devm_kfree(), as suggested
    by Sergei
---
 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index cee7b56f84049944..66634b469c9899f0 100644
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

