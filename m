Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63637 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab1DNIdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 04:33:13 -0400
Received: by qwk3 with SMTP id 3so747508qwk.19
        for <linux-media@vger.kernel.org>; Thu, 14 Apr 2011 01:33:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DA60145.5010301@maxwell.research.nokia.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
	<4DA60145.5010301@maxwell.research.nokia.com>
Date: Thu, 14 Apr 2011 10:33:12 +0200
Message-ID: <BANLkTi=EkJxdtsJ1PQOKZOhf3H1o4xobaQ@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: Bastian Hecht <hechtb@googlemail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Sakari,

2011/4/13 Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>:
> Bastian Hecht wrote:
>> Hello people,
>
> Hi Bastian,
>
> I'm cc'ing Laurent.
>
>> I switched to the new DM3730 from IGEP and while it's supposed to be
>> (almost) the same as the 3530 Version the isp deadlocks
>> deterministically after I start capturing the second time with yavta.
>
> Does the capture work the first time w/o issues?

Yes, I can always run yavta once capturing 4 frames (3 skipped, last saved).
It usually deadlocks when running yavta the second time but I had 1
successful 2nd try (out of 20 maybe).


>> All extra locking debug output is enabled in the kernel .config.
>
> I'm not fully certain on what this exactly is that you have below, but
> it looks like your system is staying in interrupt context all the time.
> My guess is that the ISP is producing interrupts that the driver is not
> handling properly, causing the interrupt handler to be called again
> immediately.

Nice! OK, I'd like to fully understand the panic output, maybe you can
help there:
After
[  376.016906] [<c02e3dc4>] (_raw_spin_unlock_irqrestore+0x40/0x44)
from [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
the IRQs get enabled again. Immediately our offending irq wants to get
served but noone is clearing it.
At some time, the timer interrupt triggers the watchdog for a kernel panic.
So the last exception block is the process context that is currently active.
But why are there 2 irq routines displayed? Is the middle one the
hardware handling that causes a software irq to be triggered (upper
block)?

So my next step could be to find the unhandled irq number?

> Do you have the same sensor working on OMAP 3530?

I never had this problem on an OMAP 3530, although I better test it
again with the current setup. I try to get my hands on an 3530 today.

>> I am unsure if this is an ISP thing or a problem in the
>> interrupthandling software.
>
> This has probably something to do with the ISP driver. :-)
>
>> The first block is the watchdog that detects the deadlock. The last
>> block is in the isp-code but how can it hang when trying to UNlock a
>> spinlock? I am unsure about the 2nd block.
>> The assembler code of __irq_svc is located in arch/arm/kernel/entry-armv.S
>> Maybe I should try on linux-arm@lists.arm.linux.org.uk but I thought I
>> give it a shot here first.
>>
>> I use the omap3isp-2.6.35.3-omap3isp branch from Laurent.
>
> Why so old kernel?

I tried a newer version, but there I couldn't get it booting with my
igep. The kernel unpacked and tried to boot but it froze.
I decided to use a version that is officially is supported by the igep team.

Thanks so much for this valuable guess!

Bastian Hecht



> I think you'd be best off using this one:
>
> <URL:http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/omap3isp-next-omap3isp>
>
>> Any ideas? Thanks for any help,
>>
>>  Bastian Hecht
>>
>>
>> [  190.059509] BUG: soft lockup - CPU#0 stuck for 61s! [yavta:2224]
>> [  190.065704] Kernel panic - not syncing: softlockup: hung tasks
>> [  190.071563] [<c0031078>] (unwind_backtrace+0x0/0xe4) from
>> [<c02baf24>] (panic+0x50/0xd0)
>> [  190.079711] [<c02baf24>] (panic+0x50/0xd0) from [<c00729e4>]
>> (softlockup_tick+0x134/0x158)
>> [  190.088043] [<c00729e4>] (softlockup_tick+0x134/0x158) from
>> [<c005612c>] (update_process_times+0x28/0x48)
>> [  190.097656] [<c005612c>] (update_process_times+0x28/0x48) from
>> [<c00697bc>] (tick_sched_timer+0x88/0xbc)
>> [  190.107177] [<c00697bc>] (tick_sched_timer+0x88/0xbc) from
>> [<c0061ff0>] (__run_hrtimer+0x44/0x84)
>> [  190.116119] [<c0061ff0>] (__run_hrtimer+0x44/0x84) from
>> [<c0062144>] (hrtimer_interrupt+0x114/0x2c8)
>> [  190.125305] [<c0062144>] (hrtimer_interrupt+0x114/0x2c8) from
>> [<c0035e20>] (omap2_gp_timer_interrupt+0x20/0x2c)
>> [  190.135437] [<c0035e20>] (omap2_gp_timer_interrupt+0x20/0x2c) from
>> [<c00730e4>] (handle_IRQ_event+0x24/0xe0)
>> [  190.145324] [<c00730e4>] (handle_IRQ_event+0x24/0xe0) from
>> [<c0074b80>] (handle_level_irq+0x90/0xfc)
>> [  190.154510] [<c0074b80>] (handle_level_irq+0x90/0xfc) from
>> [<c002c06c>] (asm_do_IRQ+0x6c/0x8c)
>> [  190.163177] [<c002c06c>] (asm_do_IRQ+0x6c/0x8c) from [<c002c9f4>]
>> (__irq_svc+0x34/0x80)
>> [  190.171234] Exception stack(0xda413c98 to 0xda413ce0)
>> [  190.176300] 3c80:
>>     00000020 c03c20d0
>> [  190.184509] 3ca0: 00000000 c0417240 da412000 00000002 00000000
>> ded72e84 0000000a dec54640
>> [  190.192718] 3cc0: c0417240 00000000 00000002 da413ce0 c0051bd4
>> c0051ad8 20000113 ffffffff
>> [  190.200958] [<c002c9f4>] (__irq_svc+0x34/0x80) from [<c0051ad8>]
>> (__do_softirq+0x3c/0xf8)
>> [  190.209167] [<c0051ad8>] (__do_softirq+0x3c/0xf8) from [<c0051bd4>]
>> (irq_exit+0x40/0x8c)
>> [  190.217315] [<c0051bd4>] (irq_exit+0x40/0x8c) from [<c002c070>]
>> (asm_do_IRQ+0x70/0x8c)
>> [  190.225280] [<c002c070>] (asm_do_IRQ+0x70/0x8c) from [<c002c9f4>]
>> (__irq_svc+0x34/0x80)
>> [  190.233306] Exception stack(0xda413d20 to 0xda413d68)
>> [  190.238403] 3d20: defc4938 defc48c0 defc4084 ded72e84 ded72e14
>> ded72e80 40000013 ded72e84
>> [  190.246612] 3d40: ded72e68 dec54640 dedc5a38 00000000 defc40f8
>> da413d68 bf01d4cc bf01d4ec
>> [  190.254821] 3d60: 60000013 ffffffff
>> [  190.258361] [<c002c9f4>] (__irq_svc+0x34/0x80) from [<bf01d4ec>]
>> (omap3isp_video_queue_streamon+0x6c/0x7c [omap3_isp])
>> [  190.269165] [<bf01d4ec>] (omap3isp_video_queue_streamon+0x6c/0x7c
>> [omap3_isp]) from [<bf01f1d4>] (isp_video_streamon+0x150/0x1f8
>> [omap3_isp])
>> [  190.281951] [<bf01f1d4>] (isp_video_streamon+0x150/0x1f8
>> [omap3_isp]) from [<c01fa76c>] (__video_do_ioctl+0x1488/0x3bd0)
>> [  190.292877] [<c01fa76c>] (__video_do_ioctl+0x1488/0x3bd0) from
>> [<c01f8ee8>] (__video_usercopy+0x2d0/0x414)
>> [  190.302581] [<c01f8ee8>] (__video_usercopy+0x2d0/0x414) from
>> [<c01f8370>] (v4l2_unlocked_ioctl+0x38/0x3c)
>> [  190.312194] [<c01f8370>] (v4l2_unlocked_ioctl+0x38/0x3c) from
>> [<c00a6d6c>] (vfs_ioctl+0x2c/0x6c)
>> [  190.321044] [<c00a6d6c>] (vfs_ioctl+0x2c/0x6c) from [<c00a7448>]
>> (do_vfs_ioctl+0x4cc/0x514)
>> [  190.329437] [<c00a7448>] (do_vfs_ioctl+0x4cc/0x514) from
>> [<c00a74c4>] (sys_ioctl+0x34/0x54)
>> [  190.337829] [<c00a74c4>] (sys_ioctl+0x34/0x54) from [<c002ce40>]
>> (ret_fast_syscall+0x0/0x30)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>
