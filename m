Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:26211 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbDDMvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2015 08:51:02 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 03/14] clkdev: get rid of redundant clk_add_alias() prototype in linux/clk.h
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
	<E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk>
Date: Sat, 04 Apr 2015 14:43:22 +0200
In-Reply-To: <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk> (Russell King's
	message of "Fri, 03 Apr 2015 18:12:37 +0100")
Message-ID: <87lhi8rrmd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King <rmk+kernel@arm.linux.org.uk> writes:

> clk_add_alias() is provided by clkdev, and is not part of the clk API.
> Howver, it is prototyped in two locations: linux/clkdev.h and
> linux/clk.h.  This is a mess.  Get rid of the redundant and unnecessary
> version in linux/clk.h.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>

Actually, this serie fixes a regression I've seen in linux-next, and which was
triggering the Oops in [1] on lubbock. With your serie, the kernel boots fine.

Cheers.

--
Robert

[1] Oops without this serie on linux-next (20150213, commit b8acf73)
[    0.223403] Unable to handle kernel paging request at virtual address 32617878
[    0.231047] pgd = c0004000
[    0.233810] [32617878] *pgd=00000000
[    0.237486] Internal error: Oops: f5 [#1] ARM
[    0.241881] Modules linked in:
[    0.245051] CPU: 0 PID: 1 Comm: swapper Tainted: G        W       3.19.0-next-20150213-09795-g3bd95ad-dirty #433
[    0.255288] Hardware name: Intel DBPXA250 Development Platform (aka Lubbock)
[    0.262412] task: c3e46000 ti: c3e48000 task.ti: c3e48000
[    0.267903] PC is at __clk_get_hw+0x8/0x10
[    0.272150] LR is at clk_get_sys+0xd0/0x120
[    0.276437] pc : [<c0249018>]    lr : [<c0248f30>]    psr: a0000053
[    0.276437] sp : c3e49e10  ip : 00000000  fp : c3e67480
[    0.288009] r10: 00000003  r9 : 00000001  r8 : c0807cc4
[    0.293310] r7 : c3e755c0  r6 : c0390d0e  r5 : 00000001  r4 : c3e67480
[    0.299919] r3 : 32617870  r2 : 00000000  r1 : c0390d0e  r0 : c3e75440
[    0.306527] Flags: NzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    0.313996] Control: 0000397f  Table: a0004000  DAC: 00000017
[    0.319809] Process swapper (pid: 1, stack limit = 0xc3e48190)
[    0.325710] Stack: (0xc3e49e10 to 0xc3e4a000)
[    0.330177] 9e00:                                     c07f64c8 c3e75920 c07f64c8 c07f6a98
[    0.338502] 9e20: c07f64b8 c07f64c8 00000131 c07f6aac 00000000 c00182e0 c03b6378 c3e79690
[    0.346822] 9e40: c3e7afa0 00000001 00000000 ffffffed c07f64c8 c07f313c 00000000 c040a318
[    0.355141] 9e60: 00000000 c041f738 00000000 c01e7a40 c07f64c8 c07f64fc c07f313c c01e6614
[    0.363466] 9e80: 00000000 c07f64c8 c07f64fc c07f313c c01e676c c01e67d4 00000000 c3e49ea8
[    0.371793] 9ea0: c07f313c c01e5030 c3e4534c c3e72870 c07f313c c07f313c c3e72ae0 00000000
[    0.380119] 9ec0: c0802ff0 c01e5e74 c0390df8 c0390df8 00000070 c07f313c c07f1898 c07f1898
[    0.388440] 9ee0: c080ce60 c01e6df8 00000000 00000000 c07f1898 c040a338 c3e75800 c000882c
[    0.396761] 9f00: c3ffcaaa c03bb7ee 00000000 c03e2ab0 00000000 00000000 c03e2ac0 c3e49f30
[    0.405082] 9f20: 00000086 c3ffcb56 c3ffcb56 c0030450 60000053 c03e2b70 c03e27e0 00000086
[    0.413396] 9f40: 00000004 00000004 00000000 00000004 00000004 c041f724 c0423ec0 c080ce60
[    0.421719] 9f60: 00000086 c0404588 c041f738 c0404d3c 00000004 00000004 c0404588 c3e46000
[    0.430028] 9f80: c001cb88 c3e03c14 00000000 c02f7d20 00000000 00000000 00000000 00000000
[    0.438341] 9fa0: 00000000 c02f7d28 00000000 c000e718 00000000 00000000 00000000 00000000
[    0.446642] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    0.454950] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    0.463318] [<c0249018>] (__clk_get_hw) from [<c0248f30>] (clk_get_sys+0xd0/0x120)
[    0.471122] [<c0248f30>] (clk_get_sys) from [<c00182e0>] (sa1111_probe+0x68/0x4c4)
[    0.478902] [<c00182e0>] (sa1111_probe) from [<c01e7a40>] (platform_drv_probe+0x30/0x78)
[    0.487155] [<c01e7a40>] (platform_drv_probe) from [<c01e6614>] (driver_probe_device+0xac/0x204)
[    0.496089] [<c01e6614>] (driver_probe_device) from [<c01e67d4>] (__driver_attach+0x68/0x8c)
[    0.504669] [<c01e67d4>] (__driver_attach) from [<c01e5030>] (bus_for_each_dev+0x50/0x88)
[    0.512986] [<c01e5030>] (bus_for_each_dev) from [<c01e5e74>] (bus_add_driver+0xc8/0x1c8)
[    0.521311] [<c01e5e74>] (bus_add_driver) from [<c01e6df8>] (driver_register+0x9c/0xe0)
[    0.529499] [<c01e6df8>] (driver_register) from [<c040a338>] (sa1111_init+0x20/0x30)
[    0.537393] [<c040a338>] (sa1111_init) from [<c000882c>] (do_one_initcall+0xf8/0x1cc)
[    0.545362] [<c000882c>] (do_one_initcall) from [<c0404d3c>] (kernel_init_freeable+0xe8/0x1b0)
[    0.554171] [<c0404d3c>] (kernel_init_freeable) from [<c02f7d28>] (kernel_init+0x8/0xe4)
[    0.562444] [<c02f7d28>] (kernel_init) from [<c000e718>] (ret_from_fork+0x14/0x3c)
[    0.570149] Code: 15930000 e12fff1e e3500000 15903000 (15930008) 
[    0.576450] ---[ end trace cb88537fdc8fa201 ]---
[    0.581232] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
