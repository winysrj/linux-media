Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m298fr8i013715
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 04:41:53 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m298fJK1002589
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 04:41:19 -0400
Received: by fk-out-0910.google.com with SMTP id b27so1317240fka.3
	for <video4linux-list@redhat.com>; Sun, 09 Mar 2008 00:41:19 -0800 (PST)
Message-ID: <47D3A2AA.7040608@claranet.fr>
Date: Sun, 09 Mar 2008 09:41:14 +0100
From: Eric Thomas <ethomas@claranet.fr>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0803081026230.3639@axis700.grange>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
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

Guennadi Liakhovetski wrote:
> On Sat, 8 Mar 2008, Eric Thomas wrote:
> 
>> Eric Thomas wrote:
>>> Hi all,
>>>
>>> My box runs with kernel 2.6.24 + main v4l-dvb tree from HG.
>>> The card is a Haupauge HVR-3000 running in analog mode only. No *dvd* module
>>> loaded.
>>> Since this videobuf-dma-sg patch, I face kernel oops in several
>>> situations.
>>> These problems occur with real tv applications, but traces below come
>>> from the capture_example binary from v4l2-apps/test.
>>>
>>>
>>> capture_example called without any argument, oopses when calling STREAMOFF:
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at virtual address
>>> 00000200
>>> printing eip: c01077e0 *pde = 00000000
>>> Oops: 0000 [#1] PREEMPT
>>> Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common
>>> videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom
>>> btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm
>>> l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0
>>> usb_storage snd_ac97_codec agpgart ac97_bus i2c_nforce2 ati_remote sg
>>> sata_nv uhci_hcd ohci_hcd ehci_hcd
>>>
>>> Pid: 3490, comm: capture_example Tainted: P        (2.6.24 #1)
>>> EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
>>> EIP is at dma_free_coherent+0x30/0xa0
>>> EAX: 00200257 EBX: 00000001 ECX: f7206000 EDX: 00001880
>>> ESI: f7206000 EDI: 00000200 EBP: f78a884c ESP: f70c0d6c
>>>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> Process capture_example (pid: 3490, ti=f70c0000 task=f7881560
>>> task.ti=f70c0000)
>>> Stack: 00200046 00000000 f887672f 00000000 00000000 37206000 f7e3ff68
>>> f886e4b2
>>>        37206000 f98cbbaf f98cb3bb f7e3ff00 f7e3ff84 f7c8ee4c 00200282
>>> f990cc26
>>>        00000000 00000020 f7c8ee4c f8876517 f7c8ee4c f7e3fa80 00000002
>>> f7c8ee00
>>> Call Trace:
>>>  [<f887672f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
>>>  [<f886e4b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
>>>  [<f98cbbaf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
>>>  [<f98cb3bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
>>>  [<f990cc26>] cx88_free_buffer+0x46/0x60 [cx88xx]
>>>  [<f8876517>] videobuf_queue_cancel+0x97/0xc0 [videobuf_core]
>>>  [<f88765ca>] __videobuf_streamoff+0x1a/0x30 [videobuf_core]
>>>  [<f8876638>] videobuf_streamoff+0x18/0x30 [videobuf_core]
>>>  [<f98ed644>] vidioc_streamoff+0x44/0x60 [cx8800]
>>>  [<f98ed600>] vidioc_streamoff+0x0/0x60 [cx8800]
>>>  [<f8855933>] __video_do_ioctl+0xe83/0x3820 [videodev]
>>>  [<c0200e90>] bit_cursor+0x350/0x5a0
>>>  [<c02401ff>] n_tty_receive_buf+0x6ff/0xef0
>>>  [<c024b9a2>] do_con_write+0xaa2/0x19e0
>>>  [<c013fcb5>] find_lock_page+0x95/0xe0
>>>  [<f88587ad>] video_ioctl2+0xbd/0x220 [videodev]
>>>  [<c0118fd3>] release_console_sem+0x1c3/0x210
>>>  [<c0115880>] __wake_up+0x50/0x90
>>>  [<c023ad06>] tty_ldisc_deref+0x36/0x90
>>>  [<c023ccde>] tty_write+0x1be/0x1d0
>>>  [<c016d008>] do_ioctl+0x78/0x90
>>>  [<c016d07c>] vfs_ioctl+0x5c/0x2b0
>>>  [<c023cb20>] tty_write+0x0/0x1d0
>>>  [<c016d30d>] sys_ioctl+0x3d/0x70
>>>  [<c0102ace>] sysenter_past_esp+0x5f/0x85
>>>  =======================
>>> Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff ff
>>> c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 39 d6 73
>>> 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
>>> EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f70c0d6c
>>> ---[ end trace d2e4ad244a27b1e7 ]---
>>>
>>> capture_example called with "-r" (read calls) oopses much earlier and
>>> twice. I can provide traces if useful.
> 
> Do you mean the Oops above is not the first one?

No. Let me explain.

Here are big steps from capture_example:
open_device ();
init_device ();
start_capturing ();
mainloop ();
stop_capturing ();
uninit_device ();
close_device ();

The STREAMOFF ioctl call that made the kernel oops is called during
stop_capturing().

But if instead of using its default mmap method, I force capture_example
to use read() calls, it oops during read(), from read_frame/mainloop.

I simply suggested that the bug was probably not (this) ioctl specific.

Logs from this second capture_example test, with fglrx loaded, but it's
probably harmless.

./capture_example -r
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000200
printing eip: c01077e0 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common 
videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom 
btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm 
l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0 
snd_ac97_codec agpgart usb_storage ac97_bus i2c_nforce2 ati_remote sg 
sata_nv uhci_hcd ohci_hcd ehci_hcd

Pid: 3463, comm: capture_example Tainted: P        (2.6.24 #1)
EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
EIP is at dma_free_coherent+0x30/0xa0
EAX: 00200257 EBX: 00000001 ECX: f71ee000 EDX: 00001880
ESI: f71ee000 EDI: 00000200 EBP: f78a884c ESP: f7f2aedc
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process capture_example (pid: 3463, ti=f7f2a000 task=f7ba3a90 
task.ti=f7f2a000)
Stack: f98a48e0 c015543e f886e72f 0000007b 00000000 371ee000 f7877de8 
f88464b2
        371ee000 f98a4baf f98a43bb f7877d80 f7877e04 f7f0ce4c f98a48e0 
f9a7c876
        f7877d80 f7f0ce4c 00096000 f886fa85 00000800 00000000 00000000 
00096000
Call Trace:
  [<f98a48e0>] __videobuf_copy_to_user+0x0/0x70 [videobuf_dma_sg]
  [<c015543e>] __vunmap+0x5e/0xf0
  [<f886e72f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
  [<f88464b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
  [<f98a4baf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
  [<f98a43bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
  [<f98a48e0>] __videobuf_copy_to_user+0x0/0x70 [videobuf_dma_sg]
  [<f9a7c876>] cx88_free_buffer+0x46/0x60 [cx88xx]
  [<f886fa85>] videobuf_read_one+0xf5/0x3b2 [videobuf_core]
  [<f98bf523>] video_read+0x93/0xa0 [cx8800]
  [<c0161181>] vfs_read+0xa1/0x140
  [<f98bf490>] video_read+0x0/0xa0 [cx8800]
  [<c01615f1>] sys_read+0x41/0x70
  [<c0102b36>] syscall_call+0x7/0xb
  =======================
Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff 
ff c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 
39 d6 73 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f7f2aedc
---[ end trace 9e628bf62a84e8cf ]---
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000200
printing eip: c01077e0 *pde = 00000000
Oops: 0000 [#2] PREEMPT
Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common 
videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom 
btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm 
l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0 
snd_ac97_codec agpgart usb_storage ac97_bus i2c_nforce2 ati_remote sg 
sata_nv uhci_hcd ohci_hcd ehci_hcd

Pid: 3463, comm: capture_example Tainted: P      D (2.6.24 #1)
EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
EIP is at dma_free_coherent+0x30/0xa0
EAX: 00200257 EBX: 00000001 ECX: f71ee000 EDX: 00001880
ESI: f71ee000 EDI: 00000200 EBP: f78a884c ESP: f7f2ad44
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process capture_example (pid: 3463, ti=f7f2a000 task=f7ba3a90 
task.ti=f7f2a000)
Stack: 00000000 00000000 f886e72f c27f0200 00000000 371ee000 f7877de8 
f88464b2
        371ee000 f98a4baf 00200200 f7877d80 f7877e04 f7f0ce4c f7d8e5c0 
f9a7c876
        f7f0ce00 f7f01540 f7f0ce4c f98bf067 f7f01540 00000008 f7f01540 
f7e5982c
Call Trace:
  [<f886e72f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
  [<f88464b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
  [<f98a4baf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
  [<f9a7c876>] cx88_free_buffer+0x46/0x60 [cx88xx]
  [<f98bf067>] video_release+0x57/0x110 [cx8800]
  [<c0161ad3>] __fput+0x93/0x190
  [<c015ed57>] filp_close+0x47/0x80
  [<c011a887>] put_files_struct+0x97/0xb0
  [<c011bc44>] do_exit+0x134/0x7f0
  [<c010350c>] apic_timer_interrupt+0x28/0x30
  [<c011958b>] printk+0x1b/0x20
  [<c0103f1f>] die+0x1ef/0x1f0
  [<c0112876>] do_page_fault+0x346/0x5f0
  [<c0112530>] do_page_fault+0x0/0x5f0
  [<c038427a>] error_code+0x6a/0x70
  [<c01077e0>] dma_free_coherent+0x30/0xa0
  [<f98a48e0>] __videobuf_copy_to_user+0x0/0x70 [videobuf_dma_sg]
  [<c015543e>] __vunmap+0x5e/0xf0
  [<f886e72f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
  [<f88464b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
  [<f98a4baf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
  [<f98a43bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
  [<f98a48e0>] __videobuf_copy_to_user+0x0/0x70 [videobuf_dma_sg]
  [<f9a7c876>] cx88_free_buffer+0x46/0x60 [cx88xx]
  [<f886fa85>] videobuf_read_one+0xf5/0x3b2 [videobuf_core]
  [<f98bf523>] video_read+0x93/0xa0 [cx8800]
  [<c0161181>] vfs_read+0xa1/0x140
  [<f98bf490>] video_read+0x0/0xa0 [cx8800]
  [<c01615f1>] sys_read+0x41/0x70
  [<c0102b36>] syscall_call+0x7/0xb
  =======================
Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff 
ff c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 
39 d6 73 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f7f2ad44
---[ end trace 9e628bf62a84e8cf ]---
Fixing recursive fault but reboot is needed!


> Please
> 
> 1. Try to reproduce Oopses after a clean boot without any propriatory 
> modules loaded, including fglrx
Done. It still oops.

> 2. Reproduce and send us the first Oops

[root@redrum2 ~/v4l-dvb-ad0b1f882ad9/v4l2-apps/test]# ./capture_example
....................................................................................................BUG: 
unable to handle kernel NULL pointer dereference at virtual address 00000200
printing eip: c01077e0 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common 
videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom 
btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm 
l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc snd_intel8x0 agpgart 
usb_storage snd_ac97_codec ac97_bus ati_remote i2c_nforce2 sg sata_nv 
uhci_hcd ohci_hcd ehci_hcd

Pid: 4272, comm: capture_example Not tainted (2.6.24 #1)
EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
EIP is at dma_free_coherent+0x30/0xa0
EAX: 00200257 EBX: 00000001 ECX: f7220000 EDX: 00001880
ESI: f7220000 EDI: 00000200 EBP: f78a884c ESP: f719ad6c
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process capture_example (pid: 4272, ti=f719a000 task=f70ef560 
task.ti=f719a000)
Stack: 00200046 00000000 f887b72f 00000000 00000000 37220000 f7e18ea8 
f88544b2
        37220000 f98bcbaf f98bc3bb f7e18e40 f7e18ec4 f7bfe04c 00200286 
f98fec36
        00000000 00000020 f7bfe04c f887b517 f7bfe04c f7d935c0 00000002 
f7bfe000
Call Trace:
  [<f887b72f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
  [<f88544b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
  [<f98bcbaf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
  [<f98bc3bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
  [<f98fec36>] cx88_free_buffer+0x46/0x60 [cx88xx]
  [<f887b517>] videobuf_queue_cancel+0x97/0xc0 [videobuf_core]
  [<f887b5ca>] __videobuf_streamoff+0x1a/0x30 [videobuf_core]
  [<f887b638>] videobuf_streamoff+0x18/0x30 [videobuf_core]
  [<f98e9644>] vidioc_streamoff+0x44/0x60 [cx8800]
  [<f98e9600>] vidioc_streamoff+0x0/0x60 [cx8800]
  [<f9882933>] __video_do_ioctl+0xe83/0x3820 [videodev]
  [<c0200e90>] bit_cursor+0x350/0x5a0
  [<c013fcb5>] find_lock_page+0x95/0xe0
  [<f98857ad>] video_ioctl2+0xbd/0x220 [videodev]
  [<c023ad06>] tty_ldisc_deref+0x36/0x90
  [<c023ccde>] tty_write+0x1be/0x1d0
  [<c016d008>] do_ioctl+0x78/0x90
  [<c016d07c>] vfs_ioctl+0x5c/0x2b0
  [<c023cb20>] tty_write+0x0/0x1d0
  [<c016d30d>] sys_ioctl+0x3d/0x70
  [<c0102ace>] sysenter_past_esp+0x5f/0x85
  =======================
Code: ce 53 83 ec 10 85 c0 74 06 8b b8 e0 00 00 00 8d 42 ff bb ff ff ff 
ff c1 e8 0b 90 43 d1 e8 75 fb 9c 58 f6 c4 02 74 3d 85 ff 74 06 <8b> 17 
39 d6 73 0f 83 c4 10 89 da 89 f0 5b 5e 5f e9 eb d7 03 00
EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f719ad6c
---[ end trace 9af53c0e82d7b2f3 ]---


> 3. Try reverting the suspected patch and see if your Oopses disappear then
It does.
I've had already narrow the scope to this patch before knocking at the
ML's door.

Mauro has been kind enough to provide me a revert patch against the
current tree. I've tested it and can confirm that it fixes my problems.

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
