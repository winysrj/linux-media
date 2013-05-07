Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50792 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3EGL42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 07:56:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Subject: Re: omap3-isp : panic using previewer from V4L input
Date: Tue, 07 May 2013 13:56:41 +0200
Message-ID: <7361840.3pfFsIn2FS@avalon>
In-Reply-To: <CAGGh5h00H10F7GWgjyhN_5Zn8JNMXRptt4FF+u=NHDdTXFD2MA@mail.gmail.com>
References: <CAGGh5h00H10F7GWgjyhN_5Zn8JNMXRptt4FF+u=NHDdTXFD2MA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

(CC'ed linux-omap)

On Monday 06 May 2013 10:59:07 jean-philippe francois wrote:
> Hi,
> 
> I am trying to use the previewer to debayer pictures coming from the
> filesystem instead of the capture hardware. The media-ctl links are as
> follows :
> 
> preview V4L input -> preview pad 0 (sink), preview pad 1(src)
> ->preview V4L output.
> 
> Input output format is set via media-ctl for the preview element, and
> via the V4L2 api for the V4L2 file descriptors. I am using USERPTR
> buffer allocated via memalign, and the application goes like this :
> 
> REQBUFS 1 buf on on input
> REQBUFS 1 buf on output
> alloc buffers
> QBUF on input
> QBUF on output
> STREAMON on output
> STREAMON on input
> DQBUF on output.
> 
> The board either panics or hangs (though HUNG_TASK_DETECTION and
> SOFT_LOCKUP_DETECTION is set)

Does it happen every time you run the application, including on the first run 
after a cold boot ?

> Please find attached the panic log, and the application code.

(log inlined)

> omap3isp omap3isp: can't find source, failing now
> omap3isp omap3isp: can't find source, failing now

Those are harmless warnings. I have a fix for them, I'll repost it.

> ------------[ cut here ]------------
> Kernel BUG at c019bb1c [verbose debug info unavailable]
> Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
> Modules linked in: omap3_isp ov10630(O)
> CPU: 0    Tainted: G           O  (3.9.0 #3)
> PC is at omap3_l3_app_irq+0x3c/0xbc

L3 APP interconnect timeout errors are not supposed to happen. This is the 
first time I see one. Maybe someone on the linux-omap list will have some 
clues regarding how to debug this.

> LR is at handle_irq_event_percpu+0x28/0x10c
> pc : [<c019bb1c>]    lr : [<c006b354>]    psr: 20000193
> sp : c0507e58  ip : 00060000  fp : 00000000
> r10: cf804dc0  r9 : ffff9e65  r8 : 00200000
> r7 : 00000000  r6 : 00001000  r5 : 00000000  r4 : cf87f3c0
> r3 : 00000000  r2 : 00001000  r1 : cf8ffc80  r0 : 00001000
> Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 8fa80019  DAC: 00000015
> Process swapper (pid: 0, stack limit = 0xc0506230)
> Stack: (0xc0507e58 to 0xc0508000)
> 7e40:                                                      00000002 cf87f3c0
> 7e60:0000001a 00000000 00000000 c006b354 cf804dc0 cf87f3c0 cf804dc0 c0506000
> 7e80:cf87f3c0 c0507f0c 00200000 ffff9e65 c054d640 c006b490 cf804dc0 c0507f80
> 7ea0:ffffffff c006da68 0000001a c006ac44 0000001a c000ebc8 0000000a c0507ed8
> 7ec0:0000001a c0008594 c054d600 c003400c 60000113 c000df00 00000001 c054d600
> 7ee0:00000101 c0506000 00000002 00000000 ffffffff c0507fb4 00200000 ffff9e65
> 7f00:c054d640 00000000 c0526f28 c0507f20 c054d600 c003400c 60000113 ffffffff
> 7f20:cf805c40 c0506000 c0511c98 c0507fb4 80004059 00000035 00000000 ffffffff
> 7f40:c0507fb4 80004059 413fc082 00000000 00000000 c003440c 00000035 c000ebcc
> 7f60:00000025 c0507f80 00000035 c0008594 c0506008 c000ed78 20000013 c000df00
> 7f80:c0547548 c050fb50 00000001 c0506000 c050e0d8 00000000 c04fb954 c0510844
> 7fa0:80004059 413fc082 00000000 00000000 00000000 c0507fc8 c0506008 c000ed78
> 7fc0:20000013 ffffffff c036c958 c04da7a8 ffffffff ffffffff c04da344 00000000
> 7fe0:c04fb958 271ae41c 00000000 10c53c7d c050e028 80008070 00000000 00000000
> [<c019bb1c>] (omap3_l3_app_irq+0x3c/0xbc)
> from [<c006b354>] (handle_irq_event_percpu+0x28/0x10c)
> [<c006b354>] (handle_irq_event_percpu+0x28/0x10c)
> from [<c006b490>] (handle_irq_event+0x58/0x74)
> [<c006b490>] (handle_irq_event+0x58/0x74)
> from [<c006da68>] (handle_level_irq+0xd8/0x110)
> [<c006da68>] (handle_level_irq+0xd8/0x110)
> from [<c006ac44>] (generic_handle_irq+0x20/0x30)
> [<c006ac44>] (generic_handle_irq+0x20/0x30)
> from [<c000ebc8>] (handle_IRQ+0x60/0x84)
> [<c000ebc8>] (handle_IRQ+0x60/0x84)
> from [<c0008594>] (omap3_intc_handle_irq+0x58/0x6c)
> [<c0008594>] (omap3_intc_handle_irq+0x58/0x6c)
> from [<c000df00>] (__irq_svc+0x40/0x70)
> Exception stack(0xc0507ed8 to 0xc0507f20)
> 7ec0:                                                      00000001 c054d600
> 7ee0:00000101 c0506000 00000002 00000000 ffffffff c0507fb4 00200000 ffff9e65
> 7f00:c054d640 00000000 c0526f28 c0507f20 c054d600 c003400c 60000113 ffffffff
> [<c000df00>] (__irq_svc+0x40/0x70)
> from [<c003400c>] (__do_softirq+0x60/0x184)
> [<c003400c>] (__do_softirq+0x60/0x184)
> from [<c003440c>] (irq_exit+0x70/0xc4)
> [<c003440c>] (irq_exit+0x70/0xc4)
> from [<c000ebcc>] (handle_IRQ+0x64/0x84)
> [<c000ebcc>] (handle_IRQ+0x64/0x84)
> from [<c0008594>] (omap3_intc_handle_irq+0x58/0x6c)
> [<c0008594>] (omap3_intc_handle_irq+0x58/0x6c)
> from [<c000df00>] (__irq_svc+0x40/0x70)
> Exception stack(0xc0507f80 to 0xc0507fc8)
> 7f80:c0547548 c050fb50 00000001 c0506000 c050e0d8 00000000 c04fb954 c0510844
> 7fa0:80004059 413fc082 00000000 00000000 00000000 c0507fc8 c0506008 c000ed78
> 7fc0:20000013 ffffffff
> [<c000df00>] (__irq_svc+0x40/0x70) from [<c000ed78>] (cpu_idle+0x60/0x90)
> [<c000ed78>] (cpu_idle+0x60/0x90)
> from [<c04da7a8>] (start_kernel+0x234/0x284)
> Code: e0022006 e0033007 e1920003 0a000002 (e7f001f2)
> ---[ end trace 58d781a6c1166535 ]---
> Kernel panic - not syncing: Fatal exception in interrupt

-- 
Regards,

Laurent Pinchart

