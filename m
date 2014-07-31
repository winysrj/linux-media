Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd19416.kasserver.com ([85.13.139.185]:57558 "EHLO
	dd19416.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaGaIak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 04:30:40 -0400
Message-ID: <53D9FE71.5080402@herbrechtsmeier.net>
Date: Thu, 31 Jul 2014 10:29:37 +0200
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
References: <53C4FC99.9050308@herbrechtsmeier.net> <5912662.x67xxWZ5ks@avalon>
In-Reply-To: <5912662.x67xxWZ5ks@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 31.07.2014 01:10, schrieb Laurent Pinchart:
> On Tuesday 15 July 2014 12:04:09 Stefan Herbrechtsmeier wrote:
>> Hi Laurent,
>>
>> I have some problems with the omap3isp driver. At the moment I use a
>> linux-stable 3.14.5 with your fixes for omap3xxx-clocks.dtsi.
>>
>> 1. If I change the clock rate to 24 MHz in my camera driver the whole
>> system freeze at the clk_prepare_enable. The first enable and disable
>> works without any problem. The system freeze during a systemd / udev
>> call of media-ctl.
> I've never seen that before. Where does your sensor get its clock from ? Is it
> connected to the ISP XCLKA or XCLKB output ?
XCLKA

>   What happens if you don't change
> the clock rate to 24 MHz ? What rate is it set to in that case ?
It works if I use a clock rate of 12 MHz or 36 MHz.

I use the following lines during power enable in the driver:
     clk_set_rate(ov5647->clk, 24000000);
     clk_prepare_enable(ov5647->clk);

This works during probe, but the second time I try to power up the 
device the system stall after clk_prepare_enable.

I see the following dump:

[  392.148620] INFO: rcu_preempt self-detected stall on CPU { 0} (t=2100 
jiffies g=1819 c=1818 q=16)
[  392.158142] CPU: 0 PID: 1853 Comm: v4l2-ctl Tainted: G W    
3.14.5-yocto-standard #131
[  392.167144] [<c001518c>] (unwind_backtrace) from [<c00125a0>] 
(show_stack+0x20/0x24)
[  392.175323] [<c00125a0>] (show_stack) from [<c069bdcc>] 
(dump_stack+0x20/0x28)
[  392.182922] [<c069bdcc>] (dump_stack) from [<c0086974>] 
(rcu_check_callbacks+0x210/0x694)
[  392.191558] [<c0086974>] (rcu_check_callbacks) from [<c0045684>] 
(update_process_times+0x4c/0x6c)
[  392.200897] [<c0045684>] (update_process_times) from [<c00906b0>] 
(tick_sched_handle.isra.14+0x58/0x64)
[  392.210784] [<c00906b0>] (tick_sched_handle.isra.14) from 
[<c009070c>] (tick_sched_timer+0x50/0x80)
[  392.220306] [<c009070c>] (tick_sched_timer) from [<c005b8b0>] 
(__run_hrtimer+0x190/0x2d0)
[  392.228912] [<c005b8b0>] (__run_hrtimer) from [<c005c20c>] 
(hrtimer_interrupt+0x118/0x260)
[  392.237640] [<c005c20c>] (hrtimer_interrupt) from [<c0022e34>] 
(omap2_gp_timer_interrupt+0x30/0x40)
[  392.247161] [<c0022e34>] (omap2_gp_timer_interrupt) from [<c007db60>] 
(handle_irq_event_percpu+0xb4/0x2d0)
[  392.257324] [<c007db60>] (handle_irq_event_percpu) from [<c007ddc8>] 
(handle_irq_event+0x4c/0x6c)
[  392.266662] [<c007ddc8>] (handle_irq_event) from [<c0080668>] 
(handle_level_irq+0xe0/0xf8)
[  392.275360] [<c0080668>] (handle_level_irq) from [<c007d314>] 
(generic_handle_irq+0x30/0x40)
[  392.284271] [<c007d314>] (generic_handle_irq) from [<c000f32c>] 
(handle_IRQ+0x70/0x90)
[  392.292602] [<c000f32c>] (handle_IRQ) from [<c00085f4>] 
(omap3_intc_handle_irq+0x68/0x90)
[  392.301208] [<c00085f4>] (omap3_intc_handle_irq) from [<c06a2f44>] 
(__irq_svc+0x44/0x78)
[  392.309722] Exception stack(0xdda299f8 to 0xdda29a40)
[  392.315032] 
99e0:                                                       00000001 
00000110
[  392.323638] 9a00: 00000000 de604600 dda28000 00000202 dda28000 
c0a73800 de554cc0 de554cc8
[  392.332244] 9a20: 0000000a dda29a8c dda299d8 dda29a40 c00724fc 
c003d1b8 60070113 ffffffff
[  392.340881] [<c06a2f44>] (__irq_svc) from [<c003d1b8>] 
(__do_softirq+0xd0/0x370)
[  392.348663] [<c003d1b8>] (__do_softirq) from [<c003d758>] 
(irq_exit+0x94/0x104)
[  392.356353] [<c003d758>] (irq_exit) from [<c000f330>] 
(handle_IRQ+0x74/0x90)
[  392.363769] [<c000f330>] (handle_IRQ) from [<c00085f4>] 
(omap3_intc_handle_irq+0x68/0x90)
[  392.372406] [<c00085f4>] (omap3_intc_handle_irq) from [<c06a2f44>] 
(__irq_svc+0x44/0x78)
[  392.380889] Exception stack(0xdda29ae8 to 0xdda29b30)
[  392.386230] 9ae0:                   00000001 00000110 00000000 
de604600 60070013 c0a5eb08
[  392.394836] 9b00: 60070013 fffffdfd de554cc0 de554cc8 de62b400 
dda29b44 dda29ac8 dda29b30
[  392.403442] 9b20: c00724fc c06a21b8 20070013 ffffffff
[  392.408752] [<c06a2f44>] (__irq_svc) from [<c06a21b8>] 
(_raw_spin_unlock_irqrestore+0x50/0x84)
[  392.417846] [<c06a21b8>] (_raw_spin_unlock_irqrestore) from 
[<c056750c>] (clk_enable_unlock+0xb4/0xc8)
[  392.427642] [<c056750c>] (clk_enable_unlock) from [<c0567bdc>] 
(clk_enable+0x34/0x3c)
[  392.435913] [<c0567bdc>] (clk_enable) from [<bf255f50>] 
(ov5647_set_power.part.2+0x68/0xc4 [ov5647])
[  392.445800] [<bf255f50>] (ov5647_set_power.part.2 [ov5647]) from 
[<bf255568>] (ov5647_set_power+0x24/0x58 [ov5647])
[  392.456787] [<bf255568>] (ov5647_set_power [ov5647]) from 
[<bf255604>] (ov5647_s_power+0x68/0xb4 [ov5647])
[  392.467041] [<bf255604>] (ov5647_s_power [ov5647]) from [<bf18812c>] 
(isp_pipeline_pm_power_one+0x98/0x118 [omap3_isp])
[  392.478454] [<bf18812c>] (isp_pipeline_pm_power_one [omap3_isp]) from 
[<bf188c84>] (isp_pipeline_pm_power.part.2+0x54/0xb4 [omap3_isp])
[  392.491333] [<bf188c84>] (isp_pipeline_pm_power.part.2 [omap3_isp]) 
from [<bf188d04>] (isp_pipeline_pm_power+0x20/0x2c [omap3_isp])
[  392.503845] [<bf188d04>] (isp_pipeline_pm_power [omap3_isp]) from 
[<bf189630>] (omap3isp_pipeline_pm_use+0x60/0x88 [omap3_isp])
[  392.515991] [<bf189630>] (omap3isp_pipeline_pm_use [omap3_isp]) from 
[<bf18c85c>] (isp_video_open+0x74/0x1a8 [omap3_isp])
[  392.527648] [<bf18c85c>] (isp_video_open [omap3_isp]) from 
[<bf1564f8>] (v4l2_open+0x8c/0xd4 [videodev])
[  392.537689] [<bf1564f8>] (v4l2_open [videodev]) from [<c0133064>] 
(chrdev_open+0x14c/0x178)
[  392.546478] [<c0133064>] (chrdev_open) from [<c012d418>] 
(do_dentry_open+0x284/0x298)
[  392.554748] [<c012d418>] (do_dentry_open) from [<c012d854>] 
(finish_open+0x48/0x5c)
[  392.562805] [<c012d854>] (finish_open) from [<c013c170>] 
(do_last.isra.31+0x860/0xac0)
[  392.571136] [<c013c170>] (do_last.isra.31) from [<c013c5f0>] 
(path_openat+0x220/0x5c8)
[  392.579467] [<c013c5f0>] (path_openat) from [<c013d79c>] 
(do_filp_open+0x3c/0x88)
[  392.587371] [<c013d79c>] (do_filp_open) from [<c012e538>] 
(do_sys_open+0x130/0x1d0)
[  392.595428] [<c012e538>] (do_sys_open) from [<c012e608>] 
(SyS_open+0x30/0x34)
[  392.602935] [<c012e608>] (SyS_open) from [<c000e2c0>] 
(ret_fast_syscall+0x0/0x48)

