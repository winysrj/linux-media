Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39951 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1DMPFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 11:05:13 -0400
Received: by qyk7 with SMTP id 7so2744610qyk.19
        for <linux-media@vger.kernel.org>; Wed, 13 Apr 2011 08:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
Date: Wed, 13 Apr 2011 17:05:12 +0200
Message-ID: <BANLkTikhVBwdyioDAgxPfn=RC-M+EiGV2Q@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: Bastian Hecht <hechtb@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I attached the output without extra kernel lock info, here is the debug output:


[  375.811157] BUG: soft lockup - CPU#0 stuck for 61s! [yavta:2226]
[  375.817474] Kernel panic - not syncing: softlockup: hung tasks
[  375.823364] [<c003250c>] (unwind_backtrace+0x0/0xe4) from
[<c02e11a0>] (panic+0x50/0xd4)
[  375.831512] [<c02e11a0>] (panic+0x50/0xd4) from [<c007e154>]
(softlockup_tick+0x14c/0x170)
[  375.839813] [<c007e154>] (softlockup_tick+0x14c/0x170) from
[<c00592e8>] (update_process_times+0x28/0x48)
[  375.849456] [<c00592e8>] (update_process_times+0x28/0x48) from
[<c006e840>] (tick_sched_timer+0x88/0xbc)
[  375.858978] [<c006e840>] (tick_sched_timer+0x88/0xbc) from
[<c00666c4>] (__run_hrtimer+0x50/0x9c)
[  375.867889] [<c00666c4>] (__run_hrtimer+0x50/0x9c) from
[<c006681c>] (hrtimer_interrupt+0x10c/0x2d8)
[  375.877075] [<c006681c>] (hrtimer_interrupt+0x10c/0x2d8) from
[<c0037438>] (omap2_gp_timer_interrupt+0x20/0x2c)
[  375.887237] [<c0037438>] (omap2_gp_timer_interrupt+0x20/0x2c) from
[<c007e944>] (handle_IRQ_event+0x24/0xe4)
[  375.897125] [<c007e944>] (handle_IRQ_event+0x24/0xe4) from
[<c0080570>] (handle_level_irq+0xac/0x128)
[  375.906402] [<c0080570>] (handle_level_irq+0xac/0x128) from
[<c002d06c>] (asm_do_IRQ+0x6c/0x8c)
[  375.915130] [<c002d06c>] (asm_do_IRQ+0x6c/0x8c) from [<c002da78>]
(__irq_svc+0x38/0xa0)
[  375.923187] Exception stack(0xdea1dc80 to 0xdea1dcc8)
[  375.928253] dc80: 00000001 dea3e840 00000110 0001dbb7 dea1c000
00000002 00000000 dff0cac8
[  375.936492] dca0: 0000000a deab8800 c0461080 00000000 c0773214
dea1dcc8 c0071ba0 c0054614
[  375.944702] dcc0: 60000113 ffffffff
[  375.948211] [<c002da78>] (__irq_svc+0x38/0xa0) from [<c0054614>]
(__do_softirq+0x4c/0x128)
[  375.956512] [<c0054614>] (__do_softirq+0x4c/0x128) from
[<c0054740>] (irq_exit+0x50/0x9c)
[  375.964752] [<c0054740>] (irq_exit+0x50/0x9c) from [<c002d070>]
(asm_do_IRQ+0x70/0x8c)
[  375.972686] [<c002d070>] (asm_do_IRQ+0x70/0x8c) from [<c002da78>]
(__irq_svc+0x38/0xa0)
[  375.980743] Exception stack(0xdea1dd08 to 0xdea1dd50)
[  375.985809] dd00:                   00000001 dea3e840 00000110
0001dbb4 40000013 dff0caa8
[  375.994049] dd20: dff0cac4 dff0cac8 dff0caa8 deab8800 40000013
00000000 c089e5fc dea1dd50
[  376.002258] dd40: c0071ba0 c02e3dc4 20000013 ffffffff
[  376.007354] [<c002da78>] (__irq_svc+0x38/0xa0) from [<c02e3dc4>]
(_raw_spin_unlock_irqrestore+0x40/0x44)
[  376.016906] [<c02e3dc4>] (_raw_spin_unlock_irqrestore+0x40/0x44)
from [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
[omap3_isp])
[  376.029388] [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
[omap3_isp]) from [<bf02128c>] (isp_video_streamon+0x15c/0x214
[omap3_isp])
[  376.042175] [<bf02128c>] (isp_video_streamon+0x15c/0x214
[omap3_isp]) from [<c0216b38>] (__video_do_ioctl+0x1488/0x3bd0)
[  376.053100] [<c0216b38>] (__video_do_ioctl+0x1488/0x3bd0) from
[<c02152b4>] (__video_usercopy+0x2d0/0x414)
[  376.062835] [<c02152b4>] (__video_usercopy+0x2d0/0x414) from
[<c0214708>] (v4l2_unlocked_ioctl+0x38/0x3c)
[  376.072448] [<c0214708>] (v4l2_unlocked_ioctl+0x38/0x3c) from
[<c00b5f1c>] (vfs_ioctl+0x2c/0x6c)
[  376.081268] [<c00b5f1c>] (vfs_ioctl+0x2c/0x6c) from [<c00b6610>]
(do_vfs_ioctl+0x4e4/0x52c)
[  376.089660] [<c00b6610>] (do_vfs_ioctl+0x4e4/0x52c) from
[<c00b668c>] (sys_ioctl+0x34/0x54)
[  376.098052] [<c00b668c>] (sys_ioctl+0x34/0x54) from [<c002df40>]
(ret_fast_syscall+0x0/0x3c)
[  376.106933] ------------[ cut here ]------------
[  376.111572] WARNING: at kernel/lockdep.c:2327 panic+0xb0/0xd4()
[  376.117523] Modules linked in: board_bastix framix omap3_isp iovmm
omap_iommu iommu2 iommu
[  376.125915] [<c003250c>] (unwind_backtrace+0x0/0xe4) from
[<c004f554>] (warn_slowpath_common+0x4c/0x64)
[  376.135375] [<c004f554>] (warn_slowpath_common+0x4c/0x64) from
[<c004f584>] (warn_slowpath_null+0x18/0x1c)
[  376.145080] [<c004f584>] (warn_slowpath_null+0x18/0x1c) from
[<c02e1200>] (panic+0xb0/0xd4)
[  376.153472] [<c02e1200>] (panic+0xb0/0xd4) from [<c007e154>]
(softlockup_tick+0x14c/0x170)
[  376.161804] [<c007e154>] (softlockup_tick+0x14c/0x170) from
[<c00592e8>] (update_process_times+0x28/0x48)
[  376.171417] [<c00592e8>] (update_process_times+0x28/0x48) from
[<c006e840>] (tick_sched_timer+0x88/0xbc)
[  376.180969] [<c006e840>] (tick_sched_timer+0x88/0xbc) from
[<c00666c4>] (__run_hrtimer+0x50/0x9c)
[  376.189880] [<c00666c4>] (__run_hrtimer+0x50/0x9c) from
[<c006681c>] (hrtimer_interrupt+0x10c/0x2d8)
[  376.199066] [<c006681c>] (hrtimer_interrupt+0x10c/0x2d8) from
[<c0037438>] (omap2_gp_timer_interrupt+0x20/0x2c)
[  376.209197] [<c0037438>] (omap2_gp_timer_interrupt+0x20/0x2c) from
[<c007e944>] (handle_IRQ_event+0x24/0xe4)
[  376.219085] [<c007e944>] (handle_IRQ_event+0x24/0xe4) from
[<c0080570>] (handle_level_irq+0xac/0x128)
[  376.228363] [<c0080570>] (handle_level_irq+0xac/0x128) from
[<c002d06c>] (asm_do_IRQ+0x6c/0x8c)
[  376.237121] [<c002d06c>] (asm_do_IRQ+0x6c/0x8c) from [<c002da78>]
(__irq_svc+0x38/0xa0)
[  376.245147] Exception stack(0xdea1dc80 to 0xdea1dcc8)
[  376.250244] dc80: 00000001 dea3e840 00000110 0001dbb7 dea1c000
00000002 00000000 dff0cac8
[  376.258453] dca0: 0000000a deab8800 c0461080 00000000 c0773214
dea1dcc8 c0071ba0 c0054614
[  376.266662] dcc0: 60000113 ffffffff
[  376.270172] [<c002da78>] (__irq_svc+0x38/0xa0) from [<c0054614>]
(__do_softirq+0x4c/0x128)
[  376.278503] [<c0054614>] (__do_softirq+0x4c/0x128) from
[<c0054740>] (irq_exit+0x50/0x9c)
[  376.286712] [<c0054740>] (irq_exit+0x50/0x9c) from [<c002d070>]
(asm_do_IRQ+0x70/0x8c)
[  376.294677] [<c002d070>] (asm_do_IRQ+0x70/0x8c) from [<c002da78>]
(__irq_svc+0x38/0xa0)
[  376.302703] Exception stack(0xdea1dd08 to 0xdea1dd50)
[  376.307800] dd00:                   00000001 dea3e840 00000110
0001dbb4 40000013 dff0caa8
[  376.316009] dd20: dff0cac4 dff0cac8 dff0caa8 deab8800 40000013
00000000 c089e5fc dea1dd50
[  376.324218] dd40: c0071ba0 c02e3dc4 20000013 ffffffff
[  376.329315] [<c002da78>] (__irq_svc+0x38/0xa0) from [<c02e3dc4>]
(_raw_spin_unlock_irqrestore+0x40/0x44)
[  376.338897] [<c02e3dc4>] (_raw_spin_unlock_irqrestore+0x40/0x44)
from [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
[omap3_isp])
[  376.351257] [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
[omap3_isp]) from [<bf02128c>] (isp_video_streamon+0x15c/0x214
[omap3_isp])
[  376.364044] [<bf02128c>] (isp_video_streamon+0x15c/0x214
[omap3_isp]) from [<c0216b38>] (__video_do_ioctl+0x1488/0x3bd0)
[  376.375000] [<c0216b38>] (__video_do_ioctl+0x1488/0x3bd0) from
[<c02152b4>] (__video_usercopy+0x2d0/0x414)
[  376.384704] [<c02152b4>] (__video_usercopy+0x2d0/0x414) from
[<c0214708>] (v4l2_unlocked_ioctl+0x38/0x3c)
[  376.394317] [<c0214708>] (v4l2_unlocked_ioctl+0x38/0x3c) from
[<c00b5f1c>] (vfs_ioctl+0x2c/0x6c)
[  376.403137] [<c00b5f1c>] (vfs_ioctl+0x2c/0x6c) from [<c00b6610>]
(do_vfs_ioctl+0x4e4/0x52c)
[  376.411529] [<c00b6610>] (do_vfs_ioctl+0x4e4/0x52c) from
[<c00b668c>] (sys_ioctl+0x34/0x54)
[  376.419952] [<c00b668c>] (sys_ioctl+0x34/0x54) from [<c002df40>]
(ret_fast_syscall+0x0/0x3c)
[  376.428436] ---[ end trace 1b75b31a2719ed1e ]---


2011/4/13 Bastian Hecht <hechtb@googlemail.com>:
> Hello people,
>
> I switched to the new DM3730 from IGEP and while it's supposed to be
> (almost) the same as the 3530 Version the isp deadlocks
> deterministically after I start capturing the second time with yavta.
> All extra locking debug output is enabled in the kernel .config.
>
> I am unsure if this is an ISP thing or a problem in the
> interrupthandling software.
> The first block is the watchdog that detects the deadlock. The last
> block is in the isp-code but how can it hang when trying to UNlock a
> spinlock? I am unsure about the 2nd block.
> The assembler code of __irq_svc is located in arch/arm/kernel/entry-armv.S
> Maybe I should try on linux-arm@lists.arm.linux.org.uk but I thought I
> give it a shot here first.
>
> I use the omap3isp-2.6.35.3-omap3isp branch from Laurent.
>
> Any ideas? Thanks for any help,
>
>  Bastian Hecht
>
>
> [  190.059509] BUG: soft lockup - CPU#0 stuck for 61s! [yavta:2224]
> [  190.065704] Kernel panic - not syncing: softlockup: hung tasks
> [  190.071563] [<c0031078>] (unwind_backtrace+0x0/0xe4) from
> [<c02baf24>] (panic+0x50/0xd0)
> [  190.079711] [<c02baf24>] (panic+0x50/0xd0) from [<c00729e4>]
> (softlockup_tick+0x134/0x158)
> [  190.088043] [<c00729e4>] (softlockup_tick+0x134/0x158) from
> [<c005612c>] (update_process_times+0x28/0x48)
> [  190.097656] [<c005612c>] (update_process_times+0x28/0x48) from
> [<c00697bc>] (tick_sched_timer+0x88/0xbc)
> [  190.107177] [<c00697bc>] (tick_sched_timer+0x88/0xbc) from
> [<c0061ff0>] (__run_hrtimer+0x44/0x84)
> [  190.116119] [<c0061ff0>] (__run_hrtimer+0x44/0x84) from
> [<c0062144>] (hrtimer_interrupt+0x114/0x2c8)
> [  190.125305] [<c0062144>] (hrtimer_interrupt+0x114/0x2c8) from
> [<c0035e20>] (omap2_gp_timer_interrupt+0x20/0x2c)
> [  190.135437] [<c0035e20>] (omap2_gp_timer_interrupt+0x20/0x2c) from
> [<c00730e4>] (handle_IRQ_event+0x24/0xe0)
> [  190.145324] [<c00730e4>] (handle_IRQ_event+0x24/0xe0) from
> [<c0074b80>] (handle_level_irq+0x90/0xfc)
> [  190.154510] [<c0074b80>] (handle_level_irq+0x90/0xfc) from
> [<c002c06c>] (asm_do_IRQ+0x6c/0x8c)
> [  190.163177] [<c002c06c>] (asm_do_IRQ+0x6c/0x8c) from [<c002c9f4>]
> (__irq_svc+0x34/0x80)
> [  190.171234] Exception stack(0xda413c98 to 0xda413ce0)
> [  190.176300] 3c80:
>    00000020 c03c20d0
> [  190.184509] 3ca0: 00000000 c0417240 da412000 00000002 00000000
> ded72e84 0000000a dec54640
> [  190.192718] 3cc0: c0417240 00000000 00000002 da413ce0 c0051bd4
> c0051ad8 20000113 ffffffff
> [  190.200958] [<c002c9f4>] (__irq_svc+0x34/0x80) from [<c0051ad8>]
> (__do_softirq+0x3c/0xf8)
> [  190.209167] [<c0051ad8>] (__do_softirq+0x3c/0xf8) from [<c0051bd4>]
> (irq_exit+0x40/0x8c)
> [  190.217315] [<c0051bd4>] (irq_exit+0x40/0x8c) from [<c002c070>]
> (asm_do_IRQ+0x70/0x8c)
> [  190.225280] [<c002c070>] (asm_do_IRQ+0x70/0x8c) from [<c002c9f4>]
> (__irq_svc+0x34/0x80)
> [  190.233306] Exception stack(0xda413d20 to 0xda413d68)
> [  190.238403] 3d20: defc4938 defc48c0 defc4084 ded72e84 ded72e14
> ded72e80 40000013 ded72e84
> [  190.246612] 3d40: ded72e68 dec54640 dedc5a38 00000000 defc40f8
> da413d68 bf01d4cc bf01d4ec
> [  190.254821] 3d60: 60000013 ffffffff
> [  190.258361] [<c002c9f4>] (__irq_svc+0x34/0x80) from [<bf01d4ec>]
> (omap3isp_video_queue_streamon+0x6c/0x7c [omap3_isp])
> [  190.269165] [<bf01d4ec>] (omap3isp_video_queue_streamon+0x6c/0x7c
> [omap3_isp]) from [<bf01f1d4>] (isp_video_streamon+0x150/0x1f8
> [omap3_isp])
> [  190.281951] [<bf01f1d4>] (isp_video_streamon+0x150/0x1f8
> [omap3_isp]) from [<c01fa76c>] (__video_do_ioctl+0x1488/0x3bd0)
> [  190.292877] [<c01fa76c>] (__video_do_ioctl+0x1488/0x3bd0) from
> [<c01f8ee8>] (__video_usercopy+0x2d0/0x414)
> [  190.302581] [<c01f8ee8>] (__video_usercopy+0x2d0/0x414) from
> [<c01f8370>] (v4l2_unlocked_ioctl+0x38/0x3c)
> [  190.312194] [<c01f8370>] (v4l2_unlocked_ioctl+0x38/0x3c) from
> [<c00a6d6c>] (vfs_ioctl+0x2c/0x6c)
> [  190.321044] [<c00a6d6c>] (vfs_ioctl+0x2c/0x6c) from [<c00a7448>]
> (do_vfs_ioctl+0x4cc/0x514)
> [  190.329437] [<c00a7448>] (do_vfs_ioctl+0x4cc/0x514) from
> [<c00a74c4>] (sys_ioctl+0x34/0x54)
> [  190.337829] [<c00a74c4>] (sys_ioctl+0x34/0x54) from [<c002ce40>]
> (ret_fast_syscall+0x0/0x30)
>
