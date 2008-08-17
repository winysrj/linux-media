Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7H2J0PS029172
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 22:19:00 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7H2IkcB020788
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 22:18:47 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>, Waffle Head <narflex@gmail.com>,
	hverkuil@xs4all.nl
In-Reply-To: <de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 22:13:24 -0400
Message-Id: <1218939204.3591.25.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	ivtv-devel@ivtvdriver.org
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

On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
> On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:
> > Brandon,
> >
> > I have checked in a fix to defend against the Ooops we both encountered.
> > The fix will also generate a WARN dump and some queue stats when it runs
> > across the cause, but will otherwise try to clean up as best it can to
> > allow further operation.
> >
> > The band-aid fix is the latest change at
> >
> > http://linuxtv.org/hg/~awalls/v4l-dvb
> >
> > Please provide the extra debug that happens if you encounter the warning
> > in your logs.  I have only encountered the problem twice over a several
> > month period, so its hard to get insight into the root cause buffer
> > accounting error at that rate.
> 
> Andy,
> 
> I had an oops today, first one in a few days
> 
> Brandon

Brandon & Jeff,

I have updated my repo at 

http://linuxtv.org/hg/~awalls/v4l-dvb

with 3 changes:

1. Back out the original band aid fix
2. Simplify the queue flush routines (you will not see that oops again)
3. Fix the interrupt handler to obtain a queue lock (prevents queue
corruption)

>From most of the output you provided, it was pretty obvious that q_full
was always claiming to have more buffers that it actually did.  I
hypothesized this could come about at the end of a capture when the
encoder hadn't really stopped transferring buffers yet (after we told it
to stop) and then we try to clear q_full while the interrupt handler is
still trying to add buffers.  This could happen because the interrupt
handler never (ever) properly obtained a lock for manipulating the
queues.  This could have been causing the queue corruption.

Please test.  I need feedback that I haven't introduced a deadlock.

It also appears that the last change requiring the interrupt handler to
obtain a lock, completely mitigates me having to use the "-cache 8192"
option to mplayer for digital captures, and greatly reduces the amount
of cache I need to have mplayer use for analog captures. 


Hans,
(or anyone else with expertise in using spinlocks withing an interrupt
handler),

Could you please provide comments on if I'm doing something wrong with
the way I obtain the spinlock in the interrupt handler?

http://linuxtv.org/hg/~awalls/v4l-dvb/rev/f3ada35200c0

>From reading Bovet and Cesati's _Understanding_the_Linux_Kernel_ and
Corbet, Rubini, and Kroah-Hartman's _Linux_Device_Drivers_ I think I've
got it right.

When the stream queues (q_full, q_io, and q_free) are accessed from the
system call exception handler, I need to do a spin_lock_irqsave() to
disable local CPU interrupts and protect access to the queues by kernel
control paths on other CPU's.  When they stream queues are accessed by
the interrupt handler on any CPU, the interrupt handler is serialized
with respect to itself and need not disable any interrupts and simply
obtain the lock via spin_lock() to protect against access from system
call exceptions.


Regards,
Andy


> [35446.681402] WARNING: at /root/hdpvr/v4l/cx18-queue.c:204
> cx18_queue_move+0x207/0x220 [cx18]()
> [35446.681402] Modules linked in: nls_cp437 cifs binfmt_misc
> iptable_filter ip_tables x_tables xfs loop mxl5005s s5h1409
> tuner_simple tuner_types ipv6 cs5345 tuner cx18 dvb_core
> compat_ioctl32 usbhid videodev v4l1_compat hid i2c_algo_bit cx2341x
> v4l2_common tveeprom psmouse i2c_core button ext3 jbd mbcache sd_mod
> ahci iTCO_wdt libata r8169 scsi_mod dock ehci_hcd uhci_hcd usbcore
> raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0
> multipath linear md_mod dm_mirror dm_log dm_snapshot dm_mod thermal
> processor fan fuse [last unloaded: hdpvr]
> [35446.681402] Pid: 14030, comm: java Not tainted 2.6.26-server-sagetv #1
> [35446.681402]
> [35446.681402] Call Trace:
> [35446.681402]  [<ffffffff80238c24>] warn_on_slowpath+0x64/0xa0
> [35446.681402]  [<ffffffffa01efd47>] :cx18:cx18_vapi+0xa7/0x110
> [35446.681402]  [<ffffffff8044901f>] _spin_lock_irqsave+0x1f/0x50
> [35446.681402]  [<ffffffff804493f2>] _spin_unlock_irqrestore+0x12/0x40
> [35446.681402]  [<ffffffff8044901f>] _spin_lock_irqsave+0x1f/0x50
> [35446.681402]  [<ffffffffa01eb617>] :cx18:cx18_queue_move+0x207/0x220
> [35446.681402]  [<ffffffffa01eca58>] :cx18:cx18_release_stream+0x78/0xc0
> [35446.681402]  [<ffffffffa01ecef6>] :cx18:cx18_v4l2_close+0xb6/0x150
> [35446.681402]  [<ffffffff802a88d1>] __fput+0xb1/0x1d0
> [35446.681402]  [<ffffffff802a5404>] filp_close+0x54/0x90
> [35446.681402]  [<ffffffff802a6c1f>] sys_close+0x9f/0x110
> [35446.681402]  [<ffffffff80226c02>] sysenter_do_call+0x1b/0x66
> [35446.681402]
> [35446.681402] ---[ end trace 5fa5ceee62929416 ]---
> [35446.681402] cx18-2: queue_move: driver bug! errant steal attempt
> for to/from_free queue move, dumping queue stats
> [35446.681402] cx18-2: queue_move: thought bytes_available = 196608
> with needed = 196608 and initial destination size = 3866624
> [35446.681402] cx18-2: queue_log: stream 'encoder MPEG'  buffers = 63
> buf_size = 65536  buffers_stolen = 0
> [35446.681402] cx18-2: queue_log: &q_free = ffff81021d7901f8  &q_full
> = ffff81021d790218  &q_io = ffff81021d790238
> [35446.681402] cx18-2: queue_log: q = ffff81021d790218   buffers = 1
> length = 65536  bytesused = 43008
> [35446.681402] cx18-2: queue_log: stream 'encoder MPEG'  buffers = 63
> buf_size = 65536  buffers_stolen = 0
> [35446.681402] cx18-2: queue_log: &q_free = ffff81021d7901f8  &q_full
> = ffff81021d790218  &q_io = ffff81021d790238
> [35446.681402] cx18-2: queue_log: q = ffff81021d7901f8   buffers = 62
> length = 3997696  bytesused = 0
> [35446.681402] cx18-2: queue_log: i = 0  buf->id = 39  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 1  buf->id = 40  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 2  buf->id = 41  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 3  buf->id = 42  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 4  buf->id = 43  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 5  buf->id = 44  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 6  buf->id = 45  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 7  buf->id = 46  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 8  buf->id = 47  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 9  buf->id = 48  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 10  buf->id = 49  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 11  buf->id = 50  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 12  buf->id = 51  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 13  buf->id = 52  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 14  buf->id = 53  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 15  buf->id = 54  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 16  buf->id = 55  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 17  buf->id = 56  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 18  buf->id = 57  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 19  buf->id = 58  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 20  buf->id = 59  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 21  buf->id = 60  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 22  buf->id = 61  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 23  buf->id = 62  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 24  buf->id = 0  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 25  buf->id = 1  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 26  buf->id = 2  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 27  buf->id = 3  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 28  buf->id = 4  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 29  buf->id = 5  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 30  buf->id = 6  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 31  buf->id = 7  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 32  buf->id = 8  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 33  buf->id = 9  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 34  buf->id = 10  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 35  buf->id = 11  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 36  buf->id = 12  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 37  buf->id = 13  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 38  buf->id = 14  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 39  buf->id = 15  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 40  buf->id = 16  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 41  buf->id = 17  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 42  buf->id = 18  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 43  buf->id = 19  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 44  buf->id = 20  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 45  buf->id = 21  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 46  buf->id = 22  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 47  buf->id = 23  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 48  buf->id = 24  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 49  buf->id = 25  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 50  buf->id = 26  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 51  buf->id = 27  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 52  buf->id = 28  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 53  buf->id = 29  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 54  buf->id = 30  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 55  buf->id = 32  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 56  buf->id = 33  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 57  buf->id = 34  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 58  buf->id = 35  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 59  buf->id = 36  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 60  buf->id = 37  buf->bytesused
> = 0  buf->readpos = 0
> [35446.681402] cx18-2: queue_log: i = 61  buf->id = 38  buf->bytesused
> = 0  buf->readpos = 0
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
