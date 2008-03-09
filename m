Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m29BWj1G024723
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 07:32:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m29BWDiV031634
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 07:32:13 -0400
Date: Sun, 9 Mar 2008 12:32:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Eric Thomas <ethomas@claranet.fr>
In-Reply-To: <47D3A2AA.7040608@claranet.fr>
Message-ID: <Pine.LNX.4.64.0803091204060.3408@axis700.grange>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
	<47D3A2AA.7040608@claranet.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

On Sun, 9 Mar 2008, Eric Thomas wrote:

> Guennadi Liakhovetski wrote:
> > On Sat, 8 Mar 2008, Eric Thomas wrote:
> > 
> > > Eric Thomas wrote:
> > > > capture_example called without any argument, oopses when calling
> > > > STREAMOFF:
> > > > 
> > > > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > > > 00000200
> > > > printing eip: c01077e0 *pde = 00000000
> > > > Oops: 0000 [#1] PREEMPT
> > > > Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common
> > > > videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom
> > > > btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm
> > > > l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0
> > > > usb_storage snd_ac97_codec agpgart ac97_bus i2c_nforce2 ati_remote sg
> > > > sata_nv uhci_hcd ohci_hcd ehci_hcd
> > > > 
> > > > Pid: 3490, comm: capture_example Tainted: P        (2.6.24 #1)
> > > > EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
> > > > EIP is at dma_free_coherent+0x30/0xa0
> > > > EAX: 00200257 EBX: 00000001 ECX: f7206000 EDX: 00001880
> > > > ESI: f7206000 EDI: 00000200 EBP: f78a884c ESP: f70c0d6c
> > > >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > > > Process capture_example (pid: 3490, ti=f70c0000 task=f7881560
> > > > task.ti=f70c0000)
> > > > Stack: 00200046 00000000 f887672f 00000000 00000000 37206000 f7e3ff68 f886e4b2
> > > >        37206000 f98cbbaf f98cb3bb f7e3ff00 f7e3ff84 f7c8ee4c 00200282 f990cc26
> > > >        00000000 00000020 f7c8ee4c f8876517 f7c8ee4c f7e3fa80 00000002 f7c8ee00
> > > > Call Trace:
> > > >  [<f887672f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
> > > >  [<f886e4b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
> > > >  [<f98cbbaf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
> > > >  [<f98cb3bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
> > > >  [<f990cc26>] cx88_free_buffer+0x46/0x60 [cx88xx]
> > > >  [<f8876517>] videobuf_queue_cancel+0x97/0xc0 [videobuf_core]
> > > >  [<f88765ca>] __videobuf_streamoff+0x1a/0x30 [videobuf_core]
> > > >  [<f8876638>] videobuf_streamoff+0x18/0x30 [videobuf_core]
> > > >  [<f98ed644>] vidioc_streamoff+0x44/0x60 [cx8800]
> > > >  [<f98ed600>] vidioc_streamoff+0x0/0x60 [cx8800]
> > > >  [<f8855933>] __video_do_ioctl+0xe83/0x3820 [videodev]
> > > >  [<c0200e90>] bit_cursor+0x350/0x5a0
> > > >  [<c02401ff>] n_tty_receive_buf+0x6ff/0xef0
> > > >  [<c024b9a2>] do_con_write+0xaa2/0x19e0
> > > >  [<c013fcb5>] find_lock_page+0x95/0xe0
> > > >  [<f88587ad>] video_ioctl2+0xbd/0x220 [videodev]
> > > >  [<c0118fd3>] release_console_sem+0x1c3/0x210
> > > >  [<c0115880>] __wake_up+0x50/0x90
> > > >  [<c023ad06>] tty_ldisc_deref+0x36/0x90
> > > >  [<c023ccde>] tty_write+0x1be/0x1d0
> > > >  [<c016d008>] do_ioctl+0x78/0x90
> > > >  [<c016d07c>] vfs_ioctl+0x5c/0x2b0
> > > >  [<c023cb20>] tty_write+0x0/0x1d0
> > > >  [<c016d30d>] sys_ioctl+0x3d/0x70
> > > >  [<c0102ace>] sysenter_past_esp+0x5f/0x85
> > > >  =======================
> > > > Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff ff
> > > > c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 39 d6 73
> > > > 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
> > > > EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f70c0d6c
> > > > ---[ end trace d2e4ad244a27b1e7 ]---
> > > > 
> > > > capture_example called with "-r" (read calls) oopses much earlier and
> > > > twice. I can provide traces if useful.

Ok, from the Oops above, the bad pointer is pci->dev.dma_mem == 0x200. And 
it is consistently 0x200 in all three dumps, provided by Eric. To me it 
looks like the pci pointer is no longer valid. Mauro, how can this be 
caused by a race with the interrupt handler? Can the problem be, that 
cx88/cx88-video.c::buffer_release() is called from multiple places: as 
cx8800_video_qops.buf_release(), and from video_release(), which is the 
release method in video_fops and radio_fops. In the Oops above it is 
called from cx8800_video_qops.buf_release().

Hm, video_release calls buffer_release() first directly, then it calls 
videobuf_stop -> __videobuf_streamoff -> videobuf_queue_cancel -> 
q->ops->buf_release... Is it good?...

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
