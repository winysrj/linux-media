Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2CIHaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 02:30:11 -0500
Received: by iagz16 with SMTP id z16so1867603iag.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 23:30:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2747531.0sXdUv33Rd@avalon>
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com>
	<CAGGh5h3H9qqMxYSuLd67_8tnk8y62R5x7k1bZwfjEKbDRy-GqA@mail.gmail.com>
	<20120308172253.GF1591@valkosipuli.localdomain>
	<2747531.0sXdUv33Rd@avalon>
Date: Fri, 9 Mar 2012 08:30:10 +0100
Message-ID: <CAGGh5h13mOVtWPLGowvtvZM1Ufx2PST3DCokJzspGFcsUo=FiA@mail.gmail.com>
Subject: Re: Lockup on second streamon with omap3-isp
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 9 mars 2012 00:28, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> a écrit :
> On Thursday 08 March 2012 19:22:53 Sakari Ailus wrote:
>> On Wed, Mar 07, 2012 at 03:24:29PM +0100, jean-philippe francois wrote:
>> > Le 6 mars 2012 18:08, jean-philippe francois <jp.francois@cynove.com> a
> écrit :
>> > > Hi,
>> > >
>> > > I have a custom dm3730 board, running a 3.2.0 kernel.
>> > > The board is equipped with an aptina MT9J sensor on
>> > > parallel interface.
>> > >
>> > > Whenever I try to run yavta twice, the second run leads to a
>> > > soft lockup in omap3isp_video_queue_streamon (see below)
>> > >
>> > > What can I do / test  to debug this issue ?
>> >
>> > Examining the offset, The code is stuck in the for_each loop,
>> > but I fail to see why.
>> >
>> > I added list manipulation and spinlock debugging, without detecting any
>> > problem.
>> >
>> > > # get.vga
>> > > Device /dev/video2 opened.
>> > > Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>> > > Video format set: SGRBG8 (47425247) 640x480 (stride 640) buffer size
>> > > 307200
>> > > Video format: SGRBG8 (47425247) 640x480 (stride 640) buffer size 307200
>> > > 3 buffers requested.
>> > > length: 307200 offset: 0
>> > > Buffer 0 mapped at address 0x4023e000.
>> > > length: 307200 offset: 307200
>> > > Buffer 1 mapped at address 0x4034d000.
>> > > length: 307200 offset: 614400
>> > > Buffer 2 mapped at address 0x40444000.
>> > > 0 (0) [-] 4294967295 307200 bytes 100.397705 100.397796 7.817 fps
>> > > 1 (1) [-] 4294967295 307200 bytes 100.495666 100.495788 10.208 fps
>> > > 2 (2) [-] 4294967295 307200 bytes 100.593658 100.593750 10.205 fps
>> > > 3 (0) [-] 4294967295 307200 bytes 100.691619 100.691741 10.208 fps
>> > > 4 (1) [-] 4294967295 307200 bytes 100.789611 100.789703 10.205 fps
>> > > 5 (2) [-] 4294967295 307200 bytes 100.887573 100.887695 10.208 fps
>> > > 6 (0) [-] 4294967295 307200 bytes 100.985565 100.985656 10.205 fps
>> > > 7 (1) [-] 4294967295 307200 bytes 101.083526 101.083709 10.208 fps
>> > > 8 (2) [-] 4294967295 307200 bytes 101.181488 101.181610 10.208 fps
>> > > 9 (0) [-] 4294967295 307200 bytes 101.279480 101.279571 10.205 fps
>> > > Captured 10 frames in 1.009796 seconds (9.902989 fps, 3042198.137254
>> > > B/s).
>> > > 3 buffers released.
>> > > [1]+  Done                       httpd
>> > > # get.vga
>> > > Device /dev/video2 opened.
>> > > Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>> > > Video format set: SGRBG8 (47425247) 640x480 (stride 640) buffer size
>> > > 307200
>> > > Video format: SGRBG8 (47425247) 640x480 (stride 640) buffer size 307200
>> > > 3 buffers requested.
>> > > length: 307200 offset: 0
>> > > Buffer 0 mapped at address 0x40285000.
>> > > length: 307200 offset: 307200
>> > > Buffer 1 mapped at address 0x40314000.
>> > > length: 307200 offset: 614400
>> > > Buffer 2 mapped at address 0x403bb000.
>> > > BUG: soft lockup - CPU#0 stuck for 22s! [yavta:495]
>> > > Modules linked in: ks8851_mll omap3_isp fpgacam(O)
>> > >
>> > > Pid: 495, comm:                yavta
>> > > CPU: 0    Tainted: G           O  (3.2.0 #52)
>> > > PC is at __do_softirq+0x50/0x110
>> > > LR is at __do_softirq+0x38/0x110
>> > > pc : [<c003746c>]    lr : [<c0037454>]    psr: 20000113
>> > > sp : ce8e5c88  ip : cf406140  fp : 00000000
>> > > r10: cee90800  r9 : 0000000a  r8 : ce8e4000
>> > > r7 : 00000002  r6 : 00000000  r5 : 00000000  r4 : 00000025
>> > > r3 : c044e580  r2 : 00000000  r1 : 00000002  r0 : 00000000
>> > > Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> > > Control: 10c5387d  Table: 8e858019  DAC: 00000015
>> > > [<c00123b0>] (unwind_backtrace+0x0/0xec) from [<c00646c4>]
>> > > (watchdog_timer_fn+0xd8/0x128)
>> > > [<c00646c4>] (watchdog_timer_fn+0xd8/0x128) from [<c004e640>]
>> > > (__run_hrtimer+0x68/0xe4)
>> > > [<c004e640>] (__run_hrtimer+0x68/0xe4) from [<c004e8b0>]
>> > > (hrtimer_interrupt+0x11c/0x2a4)
>> > > [<c004e8b0>] (hrtimer_interrupt+0x11c/0x2a4) from [<c0018f44>]
>> > > (omap2_gp_timer_interrupt+0x24/0x34)
>> > > [<c0018f44>] (omap2_gp_timer_interrupt+0x24/0x34) from [<c0064df8>]
>> > > (handle_irq_event_percpu+0x28/0x110)
>> > > [<c0064df8>] (handle_irq_event_percpu+0x28/0x110) from [<c0064f34>]
>> > > (handle_irq_event+0x54/0x74)
>> > > [<c0064f34>] (handle_irq_event+0x54/0x74) from [<c00676f8>]
>> > > (handle_level_irq+0xb4/0x100)
>> > > [<c00676f8>] (handle_level_irq+0xb4/0x100) from [<c0064a28>]
>> > > (generic_handle_irq+0x28/0x30)
>> > > [<c0064a28>] (generic_handle_irq+0x28/0x30) from [<c000e570>]
>> > > (handle_IRQ+0x60/0x84)
>> > > [<c000e570>] (handle_IRQ+0x60/0x84) from [<c000d874>]
>> > > (__irq_svc+0x34/0x98)
>> > > [<c000d874>] (__irq_svc+0x34/0x98) from [<c003746c>]
>> > > (__do_softirq+0x50/0x110) [<c003746c>] (__do_softirq+0x50/0x110) from
>> > > [<c00376f0>]
>> > > (irq_exit+0x48/0x9c)omap3isp_video_queue_streamon
>> > > [<c00376f0>] (irq_exit+0x48/0x9c) from [<c000e574>]
>> > > (handle_IRQ+0x64/0x84)
>> > > [<c000e574>] (handle_IRQ+0x64/0x84) from [<c000d874>]
>> > > (__irq_svc+0x34/0x98)
>> > > [<c000d874>] (__irq_svc+0x34/0x98) from [<bf007864>] (+0x6c/0xa0
>> > > [omap3_isp])
>> As it's __irq_svc(), I'd guess it's stuck executing the ISP interrupt
>> handler. This shouldn't happen.
>>
>> Is the sensor a parallel one?
>>
>> There have been cases where bad hs / vs signals essentially cause the ISP
>> driver to stay in handling interrupts.
>
> Or rather to constantly re-enter the interrupt handler.
>
> Make sure that your sensor stops generating hsync/vsync signals when the
> stream is stopped, and also make sure that the hsync/vsync signals are either
> driven by the sensor or pulled up or low.

Thank you, I will try this and keep you posted.
With this sensor it is possible, but that is not the case for every
sensor out there.
Is this an ISP bug ?

It never happens on first start, ie before ccdc_configure is called
for the first time.
Is there a way to eventually handle this in the driver ?


>
>> > > [<bf007864>] (omap3isp_video_queue_streamon+0x6c/0xa0 [omap3_isp])
>> > > from [<bf0096cc>] (isp_video_streamon+0x178/0x258 [omap3_isp])
>> > > [<bf0096cc>] (isp_video_streamon+0x178/0x258 [omap3_isp]) from
>> > > [<c022cae4>] (__video_do_ioctl+0x1b9c/0x4894)
>> > > [<c022cae4>] (__video_do_ioctl+0x1b9c/0x4894) from [<c022ae08>]
>> > > (video_usercopy+0x1b8/0x298)
>> > > [<c022ae08>] (video_usercopy+0x1b8/0x298) from [<c0229d48>]
>> > > (v4l2_ioctl+0x68/0x114)
>> > > [<c0229d48>] (v4l2_ioctl+0x68/0x114) from [<c00a2514>]
>> > > (vfs_ioctl+0x20/0x3c) [<c00a2514>] (vfs_ioctl+0x20/0x3c) from
>> > > [<c00a2d9c>] (do_vfs_ioctl+0x1ac/0x1c4) [<c00a2d9c>]
>> > > (do_vfs_ioctl+0x1ac/0x1c4) from [<c00a2de8>] (sys_ioctl+0x34/0x54)
>> > > [<c00a2de8>] (sys_ioctl+0x34/0x54) from [<c000dcc0>]
>> > > (ret_fast_syscall+0x0/0x30) Kernel panic - not syncing: softlockup:
>> > > hung tasks
>
> --
> Regards,
>
> Laurent Pinchart
>
