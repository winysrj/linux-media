Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QCQmAS005107
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 07:26:48 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QCQGKx019695
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 07:26:17 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1599134fga.7
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 04:26:16 -0800 (PST)
Message-ID: <47C40563.5000702@claranet.fr>
Date: Tue, 26 Feb 2008 13:26:11 +0100
From: Eric Thomas <ethomas@claranet.fr>
MIME-Version: 1.0
To: video4linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: kernel oops since changeset e3b8fb8cc214
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

Hi all,

My box runs with kernel 2.6.24 + main v4l-dvb tree from HG.
The card is a Haupauge HVR-3000 running in analog mode only. No *dvd* 
module loaded.
Since this videobuf-dma-sg patch, I face kernel oops in several
situations.
These problems occur with real tv applications, but traces below come
from the capture_example binary from v4l2-apps/test.


capture_example called without any argument, oopses when calling STREAMOFF:

BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000200
printing eip: c01077e0 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: cx8800 compat_ioctl32 cx88_alsa cx88xx ir_common 
videobuf_dma_sg wm8775 tuner tda9887 tuner_simple tuner_types tveeprom 
btcx_risc videobuf_core videodev v4l2_common v4l1_compat i2c_dev rfcomm 
l2cap bluetooth it87 hwmon_vid sunrpc binfmt_misc fglrx(P) snd_intel8x0 
usb_storage snd_ac97_codec agpgart ac97_bus i2c_nforce2 ati_remote sg 
sata_nv uhci_hcd ohci_hcd ehci_hcd

Pid: 3490, comm: capture_example Tainted: P        (2.6.24 #1)
EIP: 0060:[<c01077e0>] EFLAGS: 00210206 CPU: 0
EIP is at dma_free_coherent+0x30/0xa0
EAX: 00200257 EBX: 00000001 ECX: f7206000 EDX: 00001880
ESI: f7206000 EDI: 00000200 EBP: f78a884c ESP: f70c0d6c
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process capture_example (pid: 3490, ti=f70c0000 task=f7881560 
task.ti=f70c0000)
Stack: 00200046 00000000 f887672f 00000000 00000000 37206000 f7e3ff68 
f886e4b2
        37206000 f98cbbaf f98cb3bb f7e3ff00 f7e3ff84 f7c8ee4c 00200282 
f990cc26
        00000000 00000020 f7c8ee4c f8876517 f7c8ee4c f7e3fa80 00000002 
f7c8ee00
Call Trace:
  [<f887672f>] videobuf_waiton+0xdf/0x110 [videobuf_core]
  [<f886e4b2>] btcx_riscmem_free+0x42/0x90 [btcx_risc]
  [<f98cbbaf>] videobuf_dma_free+0x4f/0xa0 [videobuf_dma_sg]
  [<f98cb3bb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
  [<f990cc26>] cx88_free_buffer+0x46/0x60 [cx88xx]
  [<f8876517>] videobuf_queue_cancel+0x97/0xc0 [videobuf_core]
  [<f88765ca>] __videobuf_streamoff+0x1a/0x30 [videobuf_core]
  [<f8876638>] videobuf_streamoff+0x18/0x30 [videobuf_core]
  [<f98ed644>] vidioc_streamoff+0x44/0x60 [cx8800]
  [<f98ed600>] vidioc_streamoff+0x0/0x60 [cx8800]
  [<f8855933>] __video_do_ioctl+0xe83/0x3820 [videodev]
  [<c0200e90>] bit_cursor+0x350/0x5a0
  [<c02401ff>] n_tty_receive_buf+0x6ff/0xef0
  [<c024b9a2>] do_con_write+0xaa2/0x19e0
  [<c013fcb5>] find_lock_page+0x95/0xe0
  [<f88587ad>] video_ioctl2+0xbd/0x220 [videodev]
  [<c0118fd3>] release_console_sem+0x1c3/0x210
  [<c0115880>] __wake_up+0x50/0x90
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
EIP: [<c01077e0>] dma_free_coherent+0x30/0xa0 SS:ESP 0068:f70c0d6c
---[ end trace d2e4ad244a27b1e7 ]---

capture_example called with "-r" (read calls) oopses much earlier and
twice. I can provide traces if useful.

I'm not skilled enough to fix it myself, but I can test patches.

Eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
