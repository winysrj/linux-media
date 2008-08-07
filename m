Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m770xuu0027765
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 20:59:56 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m770xiph007780
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 20:59:45 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 20:55:21 -0400
Message-Id: <1218070521.2689.15.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 2008-08-06 at 06:57 -0400, Brandon Jenkins wrote:
> On Tue, Aug 5, 2008 at 9:29 PM, Andy Walls <awalls@radix.net> wrote:
> > On Tue, 2008-08-05 at 21:04 -0400, Brandon Jenkins wrote:
> >> Hi All
> >>
> >> I am running kernel 2.6.26 on  Ubuntu 8.04. Any thoughts?
> >
> > I ran into a similar Oops in the same function on 23 July.  I had it at
> > a lower priority since no one had complained about it and it seems rare.
> >
> > I'll try and get to it before Saturday morning.  If anyone wants to
> > submit a patch before then, I'll review it ASAP after receipt.
> >
> > Regards,
> > Andy
> >
> >> Thanks in advance
> >>
> >> Brandon
> >>

> >> [35037.080852] Code: 74 22 31 c9 0f 1f 80 00 00 00 00 48 89 c8 48 03
> >> 47 28 8b 10 0f ca 89 10 8d 41 04 48 83 c1 04 39 47 30 77 e7 f3 c3 0f
> >> 1f 44 00 00 <4c> 8b 0e 49 89 d2 49 8b 41 08 49 8b 11 48 89 42 08 48 89
> >> 10 49
> >> [35037.080976] RIP  [<ffffffffa01e4180>] :cx18:cx18_queue_move_buf+0x0/0xa0
> >> [35037.080992]  RSP <ffff810217c4be50>
> >> [35037.081000] CR2: 0000000000000000
> >> [35037.081192] ---[ end trace 10100555b3a0d104 ]---
> >> [35037.090147] note: java[15894] exited with preempt_count 1
> >>
> >> --
> >> video4linux-list mailing list
> >> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>
> >
> >
> Here's another one. Is there something I could do to lessen the issue
> while a patch is being worked? Rebuild the kernel without preempting?


Nope.  The problem I have has to do with per stream queue and buffer
accounting being slightly but you'll only notice when it's being freed.

I suspect you have the same problem, but I can't tell for sure as you
system is compiling the code differently than mine.

Could you please send the output of

$ cd v4l-dvb
$ objdump -D v4l/cx18-queue.o

from the offending build to me.  That way I can see the assembled
machine code and verify where in the function the NULL dereference is
happening.

If you have the exact same problem as me, I can give you a "band-aid"
patch which will lessen the problem in short order.  It'll be a band aid
because it won't fix the accounting problem though.  I need to do more
extensive test and debug to find out where the accounting of buffers is
getting screwed up.

Regards,
Andy

> Thanks in advance,
> 
> Brandon
> 
> [37769.189579] cx18-0: Cannot find buffer 68 for stream encoder MPEG
> [37769.189579] cx18-0: Could not find buf 68 for stream encoder MPEG
> [37985.181190] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000000
> [37985.181190] IP: [<ffffffffa01e2180>] :cx18:cx18_queue_move_buf+0x0/0xa0
> [37985.181190] PGD 214969067 PUD 214884067 PMD 0
> [37985.181190] Oops: 0000 [1] PREEMPT SMP
> [37985.181190] CPU 3
> [37985.181190] Modules linked in: binfmt_misc iptable_filter ip_tables
> x_tables xfs loop mxl5005s ipv6 s5h1409 tuner_simple tuner_types
> cs5345 tuner usbhid cx18 dvb_core hid compat_ioctl32 videodev
> v4l1_compat i2c_algo_bit cx2341x v4l2_common tveeprom psmouse i2c_core
> button ext3 jbd mbcache sd_mod ahci iTCO_wdt libata r8169 scsi_mod
> dock ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor async_memcpy
> async_tx xor raid1 raid0 multipath linear md_mod dm_mirror dm_log
> dm_snapshot dm_mod thermal processor fan fuse
> [37985.181190] Pid: 493, comm: java Not tainted 2.6.26-server-sagetv #1
> [37985.181190] RIP: 0010:[<ffffffffa01e2180>]  [<ffffffffa01e2180>]
> :cx18:cx18_queue_move_buf+0x0/0xa0
> [37985.181190] RSP: 0018:ffff810197ec9e50  EFLAGS: 00010046
> [37985.181190] RAX: 00000000000e0000 RBX: 0000000000000000 RCX: 0000000000000001
> [37985.181190] RDX: ffff81021d0181f8 RSI: 0000000000000000 RDI: ffff81021d018188
> [37985.181190] RBP: ffff81021d0181f8 R08: 0000000000000000 R09: 000000000004c308
> [37985.181190] R10: 000000000004c307 R11: ffff810001025a70 R12: 0000000000000001
> [37985.181190] R13: 0000000000310000 R14: 0000000000000000 R15: ffff81021d018188
> [37985.181190] FS:  0000000000000000(0000) GS:ffff81021fc06980(0063)
> knlGS:00000000c74f2b90
> [37985.181190] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [37985.181190] CR2: 0000000000000000 CR3: 000000021405e000 CR4: 00000000000006a0
> [37985.181190] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [37985.181190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [37985.181190] Process java (pid: 493, threadinfo ffff810197ec8000,
> task ffff8101fe97dfa0)
> [37985.181190] Stack:  ffffffffa01e22c2 ffff8100000e0000
> ffff81021d0181b0 0000000000000292
> [37985.181190]  000000011d0181f8 ffff8102000e0000 ffff81021d018188
> ffff81021d018000
> [37985.181190]  ffff81021d018188 ffff81021d018128 ffff81021fc92300
> 0000000000000000
> [37985.181190] Call Trace:
> [37985.181190]  [<ffffffffa01e22c2>] ? :cx18:cx18_queue_move+0xa2/0x160
> [37985.181190]  [<ffffffffa01e38d8>] ? :cx18:cx18_release_stream+0x78/0xc0
> [37985.181190]  [<ffffffffa01e3d76>] ? :cx18:cx18_v4l2_close+0xb6/0x150
> [37985.181190]  [<ffffffff802a88d1>] ? __fput+0xb1/0x1d0
> [37985.181190]  [<ffffffff802a5404>] ? filp_close+0x54/0x90
> [37985.181190]  [<ffffffff802a6c1f>] ? sys_close+0x9f/0x110
> [37985.181190]  [<ffffffff80226c02>] ? sysenter_do_call+0x1b/0x66
> [37985.181190]
> [37985.181190]
> [37985.181190] Code: 74 22 31 c9 0f 1f 80 00 00 00 00 48 89 c8 48 03
> 47 28 8b 10 0f ca 89 10 8d 41 04 48 83 c1 04 39 47 30 77 e7 f3 c3 0f
> 1f 44 00 00 <4c> 8b 0e 49 89 d2 49 8b 41 08 49 8b 11 48 89 42 08 48 89
> 10 49
> [37985.181190] RIP  [<ffffffffa01e2180>] :cx18:cx18_queue_move_buf+0x0/0xa0
> [37985.181190]  RSP <ffff810197ec9e50>
> [37985.181190] CR2: 0000000000000000
> [37985.181190] ---[ end trace cbfa59d18c547596 ]---


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
