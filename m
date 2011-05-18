Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1ERHoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 03:44:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
Date: Wed, 18 May 2011 09:44:20 +0200
Cc: javier.martin@vista-silicon.com, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org
References: <384485.52627.qm@web112004.mail.gq1.yahoo.com>
In-Reply-To: <384485.52627.qm@web112004.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180944.20661.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Chris,

On Wednesday 18 May 2011 07:09:44 Chris Rodley wrote:
> 
> Trying out the new patch.. I get this error:
> 
> root@beagle:~# modprobe iommu2
> [   24.691375] omap-iommu omap-iommu.0: isp registered
> root@beagle:~# modprobe omap3_isp
> [   26.923065] Linux video capture interface: v2.00
> [   27.027679] omap3isp omap3isp: Revision 2.0 found
> [   27.032684] omap-iommu omap-iommu.0: isp: version 1.1
> [   27.333648] mt9p031 2-0048: Detected a MT9P031 chip ID 1801
> [   27.427459] kernel BUG at drivers/media/video/omap3isp/isp.c:1494!

What kernel and OMAP3 ISP driver are you using ? The BUG_ON statement is at 
line 1492 in mainline. Bugs in error paths were present in older versions, 
make sure you use the latest one.

> [   27.434082] Unable to handle kernel NULL pointer dereference at virtual
> address 00000000 [   27.442657] pgd = c7724000
> [   27.445526] [00000000] *pgd=87700831, *pte=00000000, *ppte=00000000
> [   27.452178] Internal error: Oops: 817 [#1]
> [   27.456512] last sysfs file:
> /sys/devices/platform/omap3isp/video4linux/v4l-subdev7/dev [   27.464965]
> Modules linked in: mt9p031 omap3_isp(+) v4l2_common videodev iovmm iommu2
> iommu [   27.473815] CPU: 0    Not tainted  (2.6.39 #17)
> [   27.481536] PC is at __bug+0x1c/0x28
> [   27.485321] LR is at __bug+0x18/0x28
> [   27.489105] pc : [<c003dc98>]    lr : [<c003dc94>]    psr: 20000013
> [   27.489105] sp : c76c1e08  ip : 00000000  fp : c050ff48
> [   27.501220] r10: c051bd40  r9 : c050ff48  r8 : c7788000
> [   27.506744] r7 : 00000000  r6 : c7788348  r5 : 00000000  r4 : c7788000
> [   27.513610] r3 : 00000000  r2 : c76c1dfc  r1 : c0473627  r0 : 0000004c
> [   27.520507] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
> user [   27.528045] Control: 10c5387d  Table: 87724019  DAC: 00000015
> [   27.534118] Process modprobe (pid: 269, stack limit = 0xc76c02f0)
> [   27.540557] Stack: (0xc76c1e08 to 0xc76c2000)
> [   27.545166] 1e00:                   00000000 bf0404d4 c7788000 00000000
> c773f800 bf040dd4 [   27.553802] 1e20: 00000000 c7788000 c740c598 00000000
> c778e1a8 c778ef18 c050ff7c c050ff48 [   27.562438] 1e40: c050ff7c bf053a28
> bf053a28 00000000 00000025 0000001c 00000000 c02336fc [   27.571075] 1e60:
> c02336e8 c0232608 00000000 c050ff48 c050ff7c bf053a28 00000000 c0232724
> [   27.579711] 1e80: bf053a28 c76c1e90 c02326c4 c0231888 c740c578 c747d230
> bf053a28 bf053a28 [   27.588348] 1ea0: c763f980 c0540880 00000000 c0231f24
> bf051331 bf051336 00000033 bf053a28 [   27.596984] 1ec0: 00000000 00000001
> bf05b000 00000000 0000001c c0232c4c 00000000 bf053c68 [   27.605621] 1ee0:
> 00000000 00000001 bf05b000 00000000 0000001c c0036510 bf05b000 00000000
> [   27.614257] 1f00: 00000001 00000000 bf053c68 00000000 00000001 c7703ec0
> 00000001 c0094028 [   27.622924] 1f20: bf053c74 00000000 c00919c8 c03a4998
> bf053dbc 00b71148 c765ae00 c88b7000 [   27.631561] 1f40: 00021d91 c88ce794
> c88ce627 c88d62cc c7665000 00014ddc 00017a1c 00000000 [   27.640197] 1f60:
> 00000000 00000023 00000024 00000018 0000001c 0000000f 00000000 c04cab04
> [   27.648834] 1f80: 00000000 00b71008 00b71148 00000000 00000080 c003b124
> c76c0000 00000000 [   27.657470] 1fa0: bec2dc84 c003afa0 00b71008 00b71148
> 4009d000 00021d91 00b71148 0001a6d8 [   27.666107] 1fc0: 00b71008 00b71148
> 00000000 00000080 00b71040 bec2dc84 00000000 bec2dc84 [   27.674743] 1fe0:
> 00b712a8 bec2d984 0000b4ec 40208084 60000010 4009d000 00000a5c 00000000
> [   27.683502] [<c003dc98>] (__bug+0x1c/0x28) from [<bf0404d4>]
> (omap3isp_put+0x30/0x90 [omap3_isp]) [   27.692962] [<bf0404d4>]
> (omap3isp_put+0x30/0x90 [omap3_isp]) from [<bf040dd4>]
> (isp_probe+0x7dc/0x958 [omap3_isp]) [   27.704040] [<bf040dd4>]
> (isp_probe+0x7dc/0x958 [omap3_isp]) from [<c02336fc>]
> (platform_drv_probe+0x14/0x18) [   27.714538] [<c02336fc>]
> (platform_drv_probe+0x14/0x18) from [<c0232608>]
> (driver_probe_device+0xc8/0x184) [   27.724731] [<c0232608>]
> (driver_probe_device+0xc8/0x184) from [<c0232724>]
> (__driver_attach+0x60/0x84) [   27.734649] [<c0232724>]
> (__driver_attach+0x60/0x84) from [<c0231888>] (bus_for_each_dev+0x4c/0x78)
> [   27.744201] [<c0231888>] (bus_for_each_dev+0x4c/0x78) from [<c0231f24>]
> (bus_add_driver+0xac/0x224) [   27.753784] [<c0231f24>]
> (bus_add_driver+0xac/0x224) from [<c0232c4c>] (driver_register+0xa8/0x12c)
> [   27.763336] [<c0232c4c>] (driver_register+0xa8/0x12c) from [<c0036510>]
> (do_one_initcall+0x90/0x160) [   27.773010] [<c0036510>]
> (do_one_initcall+0x90/0x160) from [<c0094028>]
> (sys_init_module+0x16e0/0x1854) [   27.782928] [<c0094028>]
> (sys_init_module+0x16e0/0x1854) from [<c003afa0>]
> (ret_fast_syscall+0x0/0x30) [   27.792755] Code: e59f0010 e1a01003
> eb0d66a1 e3a03000 (e5833000) [   27.799285] ---[ end trace
> e4f3fc044db258d3 ]---

-- 
Regards,

Laurent Pinchart
