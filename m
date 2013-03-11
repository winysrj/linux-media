Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:37153 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3CKKNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 06:13:34 -0400
Received: by mail-we0-f181.google.com with SMTP id t44so3264903wey.12
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 03:13:32 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 11:13:32 +0100
Message-ID: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com>
Subject: omap3isp: iommu register problem.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to make omap3isp work with our DM3730 based board.

When I try to boot the kernel I get the following message:

[    2.064239] omap3isp omap3isp: Revision 15.0 found
[    2.070220] omap_iommu_attach: 1
[    2.073669] omap_iommu_attach: 2
[    2.077056] omap_iommu_attach: 3
[    2.080627] omap_iommu_attach: 4
[    2.084014] omap_iommu_attach: 5
[    2.087432] iommu_enable: 1
[    2.090362] iommu_enable: 2, arch_iommu =   (null)
[    2.095428] omap_iommu_attach: 6
[    2.098815] omap3isp omap3isp: can't get omap iommu: -19
[    2.104431] omap3isp omap3isp: can't attach iommu device: -19
[    2.110504] Unable to handle kernel NULL pointer dereference at
virtual address 00000034
[    2.119018] pgd = c0004000
[    2.121856] [00000034] *pgd=00000000
[    2.125671] Internal error: Oops: 5 [#1] ARM
[    2.130157] Modules linked in:
[    2.133361] CPU: 0    Not tainted  (3.8.0-00002-g07e6459-dirty #741)
[    2.140045] PC is at omap_iommu_save_ctx+0x18/0x24
[    2.145050] LR is at omap3isp_put+0x98/0xd8
[    2.149444] pc : [<c0432cdc>]    lr : [<c03e3654>]    psr: 60000113
[    2.149444] sp : cf831e50  ip : 22222222  fp : c0670184
[    2.161437] r10: 00000010  r9 : 0000bfff  r8 : ffffffed
[    2.166931] r7 : 00000001  r6 : c077b9a8  r5 : cf010530  r4 : cf010000
[    2.173736] r3 : 00000000  r2 : c077bc00  r1 : 00000000  r0 : 00000000
[    2.180572] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    2.188232] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    2.194244] Process swapper (pid: 1, stack limit = 0xcf830230)
[    2.200347] Stack: (0xcf831e50 to 0xcf832000)
[    2.204925] 1e40:                                     cf010000
c03e3654 cf010000 c077b9b8
[    2.213470] 1e60: c077b9a8 c03e3c70 00000000 00000001 00000000
cf010530 cf010000 c0058e84
[    2.222045] 1e80: 00000000 c07606c8 cf8e6a40 00000000 c077b9b8
c077b9b8 c0d16db4 c077b9ec
[    2.230590] 1ea0: c07bba98 c0736360 000000b0 c07606c8 00000000
c02f822c c077b9b8 c02f6f2c
[    2.239166] 1ec0: c077b9b8 c07bba98 c077b9ec 00000000 c0736360
c02f7154 c07bba98 cf831ee8
[    2.247711] 1ee0: c02f70c0 c02f5888 cf81e4a8 cf8de510 00000000
c07bba98 c07ac1d0 cfbed240
[    2.256286] 1f00: 00000000 c02f6004 c066b5c0 c07bba98 00000000
c07606c0 c07bba98 00000000
[    2.264831] 1f20: c07562d8 c02f7748 c07606c0 c07cddc0 00000000
c07562d8 c0736360 c000864c
[    2.273406] 1f40: c06bdb3c c070fd04 00000006 00000006 00000000
c07606c0 c076dcd4 c07cddc0
[    2.281951] 1f60: 00000007 c0736360 000000b0 c07606c8 00000000
c073628c 00000006 00000006
[    2.290527] 1f80: c0736360 cf830000 00000000 c052ecb8 00000000
00000000 00000000 00000000
[    2.299072] 1fa0: 00000000 c052ecc0 00000000 c000e0b0 00000000
00000000 00000000 00000000
[    2.307647] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    2.316223] 1fe0: 00000000 00000000 00000000 00000000 00000013
00000000 60402140 4b080520
[    2.324798] [<c0432cdc>] (omap_iommu_save_ctx+0x18/0x24) from
[<c03e3654>] (omap3isp_put+0x98/0xd8)
[    2.334259] [<c03e3654>] (omap3isp_put+0x98/0xd8) from [<c03e3c70>]
(isp_probe+0x1d0/0xaf0)
[    2.343017] [<c03e3c70>] (isp_probe+0x1d0/0xaf0) from [<c02f822c>]
(platform_drv_probe+0x18/0x1c)
[    2.352325] [<c02f822c>] (platform_drv_probe+0x18/0x1c) from
[<c02f6f2c>] (driver_probe_device+0x80/0x214)
[    2.362426] [<c02f6f2c>] (driver_probe_device+0x80/0x214) from
[<c02f7154>] (__driver_attach+0x94/0x98)
[    2.372283] [<c02f7154>] (__driver_attach+0x94/0x98) from
[<c02f5888>] (bus_for_each_dev+0x60/0x8c)
[    2.381744] [<c02f5888>] (bus_for_each_dev+0x60/0x8c) from
[<c02f6004>] (bus_add_driver+0xa4/0x238)
[    2.391235] [<c02f6004>] (bus_add_driver+0xa4/0x238) from
[<c02f7748>] (driver_register+0x78/0x140)
[    2.400695] [<c02f7748>] (driver_register+0x78/0x140) from
[<c000864c>] (do_one_initcall+0x30/0x170)
[    2.410278] [<c000864c>] (do_one_initcall+0x30/0x170) from
[<c073628c>] (kernel_init_freeable+0xdc/0x1b0)
[    2.420318] [<c073628c>] (kernel_init_freeable+0xdc/0x1b0) from
[<c052ecc0>] (kernel_init+0x8/0xe4)
[    2.429809] [<c052ecc0>] (kernel_init+0x8/0xe4) from [<c000e0b0>]
(ret_from_fork+0x14/0x24)
[    2.438568] Code: e92d4010 e59021d4 e5933000 e5920004 (e5933034)
[    2.445129] ---[ end trace ce0d24c569f5d702 ]---
[    2.450012] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b

This is  due to the following function not being executed at startup:

static int __init omap2_iommu_init(void)
{
	printk("%s\n", __func__);
	return omap_install_iommu_arch(&omap2_iommu_ops);
}
module_init(omap2_iommu_init);

Does anyone know what could be the reason?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
