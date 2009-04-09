Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34202 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZDISxl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2009 14:53:41 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange>
	<87iqlgkykd.fsf@free.fr> <87skkkdunm.fsf@free.fr>
	<Pine.LNX.4.64.0904081137310.4722@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 09 Apr 2009 20:53:30 +0200
In-Reply-To: <Pine.LNX.4.64.0904081137310.4722@axis700.grange> (Guennadi Liakhovetski's message of "Wed\, 8 Apr 2009 11\:38\:04 +0200 \(CEST\)")
Message-ID: <87hc0xslp1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Try with the patch-stack I mentioned in the previous mail, will see then.
Euh, which mail ? I can't find a reference to it.

As a preparation for the weekend, my first try revealed that oops. I must admit
I made that test without any involvement of my brain.

Cheers.

--
Robert

[    0.000000] Linux version 2.6.29-next-20090330-mioa701-11198-g160d8ad-dirty (rj@velvet) (gcc version 4.2.0 20070413 (prerelease) (CodeSourcery Sourcery G++ Lite 2007q1-10)) #10 Thu Apr 9 00:00:27 CEST 2009
[    0.000000] CPU: XScale-PXA270 [69054117] revision 7 (ARMv5TE), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: MIO A701
...
[  714.620015] Mioa701: GSM status changed to on
[  771.479136] Unable to handle kernel NULL pointer dereference at virtual address 00000044
[  771.485032] pgd = c3134000
[  771.487939] [00000044] *pgd=a3f76031, *pte=00000000, *ppte=00000000
[  771.490809] Internal error: Oops: 17 [#1]
[  771.493629] Modules linked in: pxa_camera(+) mt9m111 soc_camera videobuf_dma_sg videobuf_core
[  771.499414] CPU: 0    Not tainted  (2.6.29-next-20090330-mioa701-11198-g160d8ad-dirty #10)
[  771.505293] PC is at dev_driver_string+0x10/0x48
[  771.508358] LR is at pxa_camera_probe+0x2c8/0x414 [pxa_camera]
[  771.511393] pc : [<c0153a00>]    lr : [<bf01ccf4>]    psr: 20000013
[  771.511410] sp : c0493db0  ip : c0493dc0  fp : c0493dbc
[  771.517396] r10: c0305940  r9 : c0304380  r8 : 00000000
[  771.520392] r7 : 0632ea00  r6 : 018cba80  r5 : c04370a0  r4 : 02faf080
[  771.523419] r3 : 00000000  r2 : d1b71759  r1 : 0632ea00  r0 : 00000000
[  771.526426] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  771.529443] Control: 0000397f  Table: a3134000  DAC: 00000015
[  771.532425] Process insmod (pid: 3125, stack limit = 0xc0492270)
[  771.535457] Stack: (0xc0493db0 to 0xc0494000)
[  771.538505] 3da0:                                     c0493dfc c0493dc0 bf01ccf4 c01539fc
[  771.544628] 3dc0: 00000000 c0304390 00000021 c0304388 c0493dec c0304388 bf01f360 bf01f360
[  771.550841] 3de0: c0338b84 c031ac80 00000000 c0324ca0 c0493e0c c0493e00 c01581c0 bf01ca38
[  771.557230] 3e00: c0493e2c c0493e10 c0157250 c01581ac c0304388 c03043bc bf01f360 c0157350
[  771.563684] 3e20: c0493e4c c0493e30 c01573e0 c01571b4 c0493e4c 00000000 c0493e50 bf01f360
[  771.570313] 3e40: c0493e74 c0493e50 c0156740 c015735c c38034d8 c3851d10 00000000 bf01f3dc
[  771.577052] 3e60: bf01f360 c0737480 c0493e84 c0493e78 c01570ac c01566f0 c0493eb4 c0493e88
[  771.583879] 3e80: c0156d58 c0157098 bf01e188 bf01f3dc bf01f360 000040a4 bf01f3dc bf01f360
[  771.590777] 3ea0: 00000000 bf01dfb8 c0493edc c0493eb8 c015762c c0156cb8 c0085c60 000040a4
[  771.597815] 3ec0: bf01f3dc c0492000 00000000 bf01dfb8 c0493eec c0493ee0 c0158668 c01575d4
[  771.604931] 3ee0: c0493efc c0493ef0 bf01dfcc c0158608 c0493f7c c0493f00 c00222bc bf01dfc4
[  771.612094] 3f00: c4934c10 c49348c8 c4934806 c042e920 c4935a60 00000015 0000000b 00000000
[  771.619378] 3f20: 00000017 c4934c38 000160bc 00000000 00000000 00000000 00000000 00000000
[  771.626714] 3f40: 00000000 000040a4 bf01f3dc 00012018 00000000 000040a4 bf01f3dc 00012018
[  771.634073] 3f60: 00000000 c0023008 c0492000 00000000 c0493fa4 c0493f80 c005af98 c0022294
[  771.641538] 3f80: c008d528 c008d41c 00000000 000040a4 00000003 00000080 00000000 c0493fa8
[  771.649104] 3fa0: c0022e60 c005af14 00000000 000040a4 00012018 000040a4 00012008 00000001
[  771.656805] 3fc0: 00000000 000040a4 00000003 00000080 beb73f91 00000000 00012008 00000000
[  771.664611] 3fe0: 00008000 beb73d3c 00008e00 400cccc4 60000010 00012018 6e61656c 715f7075
[  771.672480] Backtrace:
[  771.676325] [<c01539f0>] (dev_driver_string+0x0/0x48) from [<bf01ccf4>] (pxa_camera_probe+0x2c8/0x414 [pxa_camera])
[  771.684198] [<bf01ca2c>] (pxa_camera_probe+0x0/0x414 [pxa_camera]) from [<c01581c0>] (platform_drv_probe+0x20/0x24)
[  771.692108] [<c01581a0>] (platform_drv_probe+0x0/0x24) from [<c0157250>] (driver_probe_device+0xa8/0x1a8)
[  771.700003] [<c01571a8>] (driver_probe_device+0x0/0x1a8) from [<c01573e0>] (__driver_attach+0x90/0x94)
[  771.707840]  r7:c0157350 r6:bf01f360 r5:c03043bc r4:c0304388
[  771.711806] [<c0157350>] (__driver_attach+0x0/0x94) from [<c0156740>] (bus_for_each_dev+0x5c/0x88)
[  771.719550]  r6:bf01f360 r5:c0493e50 r4:00000000
[  771.723403] [<c01566e4>] (bus_for_each_dev+0x0/0x88) from [<c01570ac>] (driver_attach+0x20/0x28)
[  771.731042]  r7:c0737480 r6:bf01f360 r5:bf01f3dc r4:00000000
[  771.734893] [<c015708c>] (driver_attach+0x0/0x28) from [<c0156d58>] (bus_add_driver+0xac/0x220)
[  771.742451] [<c0156cac>] (bus_add_driver+0x0/0x220) from [<c015762c>] (driver_register+0x64/0x148)
[  771.749994]  r8:bf01dfb8 r7:00000000 r6:bf01f360 r5:bf01f3dc r4:000040a4
[  771.753844] [<c01575c8>] (driver_register+0x0/0x148) from [<c0158668>] (platform_driver_register+0x6c/0x88)
[  771.761352]  r8:bf01dfb8 r7:00000000 r6:c0492000 r5:bf01f3dc r4:000040a4
[  771.765177] [<c01585fc>] (platform_driver_register+0x0/0x88) from [<bf01dfcc>] (pxa_camera_init+0x14/0x1c [pxa_camera])
[  771.772670] [<bf01dfb8>] (pxa_camera_init+0x0/0x1c [pxa_camera]) from [<c00222bc>] (do_one_initcall+0x34/0x188)
[  771.780187] [<c0022288>] (do_one_initcall+0x0/0x188) from [<c005af98>] (sys_init_module+0x90/0x1a0)
[  771.787608] [<c005af08>] (sys_init_module+0x0/0x1a0) from [<c0022e60>] (ret_fast_syscall+0x0/0x2c)
[  771.794999]  r7:00000080 r6:00000003 r5:000040a4 r4:00000000
[  771.798725] Code: e1a0c00d e92dd800 e24cb004 e1a03000 (e5900044)
[  771.802982] ---[ end trace 2e3e0d6e9a1ff088 ]---
