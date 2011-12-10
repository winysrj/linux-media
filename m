Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:39193 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181Ab1LJIJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 03:09:06 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Alex Gershgorin <alexg@meprolight.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sat, 10 Dec 2011 10:02:54 +0200
Subject: RE: OMAP3ISP boot problem
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2C89899243@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8989923C@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2C8989923C@MEP-EXCH.meprolight.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I have problem in booting the Kernel.
Here the problematic part of the boot message.
As I understand it happens when isp_probe calling and it calls isp->iommu_dev = omap_find_iommu_device("isp");

[    1.976715] Linux media interface: v0.10
[    1.981781] Linux video capture interface: v2.00
[    1.989257] omap3isp omap3isp: Revision 2.0 found
[    1.998138] Unable to handle kernel NULL pointer dereference at virtual address 00000050
[    2.006683] pgd = c0004000
[    2.010009] [00000050] *pgd=00000000
[    2.013793] Internal error: Oops: 5 [#1]
[    2.017913] Modules linked in:
[    2.021148] CPU: 0    Tainted: G        W     (3.2.0-rc4-00002-g2d47fa7-dirty #1304)
[    2.029296] PC is at klist_next+0x10/0xc4
[    2.033508] LR is at next_device+0x8/0x14
[    2.037750] pc : [<c03c032c>]    lr : [<c0251e5c>]    psr: 60000013
[    2.037750] sp : c7425eb0  ip : c05e080c  fp : 00000000
[    2.049804] r10: c04b2367  r9 : c058b4f8  r8 : 000003ff
[    2.055297] r7 : 0000000e  r6 : 00000000  r5 : c031827c  r4 : c7425ed0
[    2.062164] r3 : c031827c  r2 : 00000000  r1 : c7425ed0  r0 : 00000024
[    2.069000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    2.076690] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    2.082733] Process swapper (pid: 1, stack limit = 0xc74242f0)
[    2.088867] Stack: (0xc7425eb0 to 0xc7426000)
[    2.093444] 5ea0:                                     c031827c c04ae343 c031827c c05d7650
[    2.102050] 5ec0: 0000000e c0251e5c c031827c c0251ec8 00000024 00000000 c76e8000 000074e0
[    2.110656] 5ee0: c058b4f0 c030462c 00000000 c01181e4 c058b4f8 c0055f04 00000000 c76e8508
[    2.119232] 5f00: c74976c0 00000000 c05d4fe4 c058b4f8 c058b52c c05d4fe4 c05d4fe4 00000000
[    2.127838] 5f20: 00000000 00000000 00000000 c0252784 c0252770 c02515e4 00000000 c058b4f8
[    2.136444] 5f40: c058b52c c05d4fe4 00000000 c0251708 c05d4fe4 c02516a0 00000000 c0250e20
[    2.145050] 5f60: c7420058 c7481490 c05d4fe4 c76c9140 c05c45d0 c0250768 c04ae33e 00000000
[    2.153656] 5f80: c7423340 c05d4fe4 c056e4cc c000dbfc 00000000 00000000 00000000 c0251d20
[    2.162231] 5fa0: c0583210 c056e4cc c000dbfc 00000000 00000000 c000857c c0582dd0 00003539
[    2.170837] 5fc0: 00000000 c0000000 00000013 c0583210 c0582dd0 c000dbfc 00000013 00000000
[    2.179443] 5fe0: 00000000 c0553204 c7423340 00000000 c0553194 c000dbfc bf0285ff fb000400
[    2.188049] [<c03c032c>] (klist_next+0x10/0xc4) from [<c0251e5c>] (next_device+0x8/0x14)
[    2.196563] [<c0251e5c>] (next_device+0x8/0x14) from [<c0251ec8>] (driver_find_device+0x60/0x78)
[    2.205841] [<c0251ec8>] (driver_find_device+0x60/0x78) from [<c030462c>] (isp_probe+0x238/0xa5c)
[    2.215179] [<c030462c>] (isp_probe+0x238/0xa5c) from [<c0252784>] (platform_drv_probe+0x14/0x18)
[    2.224517] [<c0252784>] (platform_drv_probe+0x14/0x18) from [<c02515e4>] (driver_probe_device+0xc8/0x184)
[    2.234680] [<c02515e4>] (driver_probe_device+0xc8/0x184) from [<c0251708>] (__driver_attach+0x68/0x8c)
[    2.244567] [<c0251708>] (__driver_attach+0x68/0x8c) from [<c0250e20>] (bus_for_each_dev+0x48/0x74)
[    2.254058] [<c0250e20>] (bus_for_each_dev+0x48/0x74) from [<c0250768>] (bus_add_driver+0xa0/0x21c)
[    2.263580] [<c0250768>] (bus_add_driver+0xa0/0x21c) from [<c0251d20>] (driver_register+0xa4/0x130)
[    2.273101] [<c0251d20>] (driver_register+0xa4/0x130) from [<c000857c>] (do_one_initcall+0x98/0x16c)
[    2.282714] [<c000857c>] (do_one_initcall+0x98/0x16c) from [<c0553204>] (kernel_init+0x70/0x118)
[    2.291992] [<c0553204>] (kernel_init+0x70/0x118) from [<c000dbfc>] (kernel_thread_exit+0x0/0x8)
[    2.301208] Code: e92d40f8 e1a04000 e5900000 e5946004 (e590702c)
[    2.307708] ---[ end trace 1b75b31a2719ed1e ]---
[    2.312652] Kernel panic - not syncing: Attempted to kill init!

I will appreciate any help.

Thanks
Alex Gershgorin