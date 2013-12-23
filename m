Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34335 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3LWRpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 12:45:19 -0500
Received: by mail-oa0-f44.google.com with SMTP id m1so6013641oag.31
        for <linux-media@vger.kernel.org>; Mon, 23 Dec 2013 09:45:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
	<52A1A76A.6070301@epfl.ch>
	<CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
	<52B04D70.8060201@epfl.ch>
	<CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>
Date: Mon, 23 Dec 2013 18:45:19 +0100
Message-ID: <CA+2YH7sF2mGXKWLWa5_LLxXhMf5WOsFODJBZ+Lovz8KP0qyuKA@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: florian.vaussard@epfl.ch
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 18, 2013 at 11:09 AM, Enrico <ebutera@users.berlios.de> wrote:
> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard
> <florian.vaussard@epfl.ch> wrote:
>> So I converted the iommu to DT (patches just sent), used pdata quirks
>> for the isp / mtv9032 data, added a few patches from other people
>> (mainly clk to fix a crash when deferring the omap3isp probe), and a few
>> small hacks. I get a 3.13-rc3 (+ board-removal part from Tony Lindgren)
>> to boot on DT with a working MT9V032 camera. The missing part is the DT
>> binding for the omap3isp, but I guess that we will have to wait a bit
>> more for this.
>>
>> If you want to test, I have a development tree here [1]. Any feedback is
>> welcome.
>>
>> Cheers,
>>
>> Florian
>>
>> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
>
> Thanks Florian,
>
> i will report what i get with my setup.

Uhm it's unrelated to omap3isp but i get a kernel panic in serial_omap_probe:

[    1.575225] console [ttyO2] enabled
[    1.581268] Unhandled fault: external abort on non-linefetch
(0x1028) at 0xfb042050
[    1.589324] Internal error: : 1028 [#1] ARM
[    1.593719] Modules linked in:
[    1.596954] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc3+ #2
[    1.604461] task: de870000 ti: de86c000 task.ti: de86c000
[    1.610137] PC is at serial_omap_probe+0x3a8/0x644
[    1.615203] LR is at trace_hardirqs_on_caller+0x104/0x1dc
[    1.620849] pc : [<c028c0a4>]    lr : [<c006411c>]    psr: 20000153
[    1.620849] sp : de86de30  ip : c06f8784  fp : 00000000
[    1.632934] r10: 00000000  r9 : dea931ad  r8 : c0b7e144
[    1.638397] r7 : dea75c50  r6 : de8e4c00  r5 : de8e4c10  r4 : dea93010
[    1.645263] r3 : fb042000  r2 : fb042050  r1 : 00000014  r0 : 00000000
[    1.652130] Flags: nzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[    1.659912] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    1.665924] Process swapper (pid: 1, stack limit = 0xde86c240)
[    1.672058] Stack: (0xde86de30 to 0xde86e000)
[    1.676635] de20:                                     c053bd40
dea931ad 00000000 00000000
[    1.685241] de40: de8e4c10 00000000 de8e4c10 c0636340 00000000
00000000 c0636340 0000006e
[    1.693847] de60: de86c030 c029414c c0294134 c0b7e618 de8e4c10
c0292c98 de8e4c10 c0636340
[    1.702453] de80: de8e4c44 00000000 c05eb8ac c0292e90 00000000
c0636340 c0292dfc c02912a8
[    1.711029] dea0: de803aa8 de8c8050 c0636340 de9e4900 c0636ec0
c029246c c0559bec c0636340
[    1.719635] dec0: 00000006 c0636340 00000006 c064e500 c064e500
c0293254 00000000 c05fddf8
[    1.728240] dee0: 00000006 c05eb8cc c05fddf8 c00087e4 de870000
c0620438 60000153 c0068fcc
[    1.736816] df00: c064e500 00001480 c0620434 c05f72e0 c05f72b8
c0439170 00000002 de86c000
[    1.745422] df20: c0f9e9f5 c04568d4 0000006e c004be2c c05ab990
00000006 c0f9ea08 00000006
[    1.754028] df40: 60000153 c05fddf8 00000006 c064e500 c064e500
c05d1480 0000006e c05f72e0
[    1.762634] df60: c05f72d4 c05d1c68 00000006 00000006 c05d1480
00000000 c00550a0 052d1144
[    1.771209] df80: 08010820 00000000 c04310f4 00000000 00000000
00000000 00000000 00000000
[    1.779815] dfa0: 00000000 c04310fc 00000000 c000e048 00000000
00000000 00000000 00000000
[    1.788421] dfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    1.796997] dfe0: 00000000 00000000 00000000 00000000 00000013
00000000 41001412 44300082
[    1.805633] [<c028c0a4>] (serial_omap_probe+0x3a8/0x644) from
[<c029414c>] (platform_drv_probe+0x18/0x48)
[    1.815673] [<c029414c>] (platform_drv_probe+0x18/0x48) from
[<c0292c98>] (driver_probe_device+0x114/0x234)
[    1.825927] [<c0292c98>] (driver_probe_device+0x114/0x234) from
[<c0292e90>] (__driver_attach+0x94/0x98)
[    1.835906] [<c0292e90>] (__driver_attach+0x94/0x98) from
[<c02912a8>] (bus_for_each_dev+0x60/0x94)
[    1.845428] [<c02912a8>] (bus_for_each_dev+0x60/0x94) from
[<c029246c>] (bus_add_driver+0x148/0x1f0)
[    1.855010] [<c029246c>] (bus_add_driver+0x148/0x1f0) from
[<c0293254>] (driver_register+0x78/0xf8)
[    1.864532] [<c0293254>] (driver_register+0x78/0xf8) from
[<c05eb8cc>] (serial_omap_init+0x20/0x44)
[    1.874053] [<c05eb8cc>] (serial_omap_init+0x20/0x44) from
[<c00087e4>] (do_one_initcall+0x100/0x150)
[    1.883758] [<c00087e4>] (do_one_initcall+0x100/0x150) from
[<c05d1c68>] (kernel_init_freeable+0x1fc/0x29c)
[    1.894012] [<c05d1c68>] (kernel_init_freeable+0x1fc/0x29c) from
[<c04310fc>] (kernel_init+0x8/0x120)
[    1.903717] [<c04310fc>] (kernel_init+0x8/0x120) from [<c000e048>]
(ret_from_fork+0x14/0x2c)
[    1.912567] Code: e5d42051 e5943024 e3a01014 e0832211 (e5923000)


is it a known bug? something i should check in my config/dts?

Enrico
