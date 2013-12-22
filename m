Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45258 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3LVQn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 11:43:29 -0500
Message-ID: <52B716AD.8020507@iki.fi>
Date: Sun, 22 Dec 2013 18:43:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: VIVI driver DEADLOCK reported by lockdep
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!
I started testing locks from my SDR drivers and ended up unexpected 
warnings. Now I have looked quite a lot of things and read carefully 
many times v4l2 framework documentation [1]. V4L2 locking model is not 
very clear for me, but I understand there is 2 mutex, one for 
serializing IOCTLs and one for serializing videobuf2 operations. And top 
of that there is spinlock inside driver for frame-buffers. It hard to 
say very much about those locks which are hidden inside v4l2 - only 
pointer passed from driver. Maybe it is possible to get rid of that by 
using own locks inside driver (passing NULL mutexes to v4l2/vb2 gives 
possibility to use own locking)?

[1] Documentation/video4linux/v4l2-framework.txt

After the MSi3101 SDR driver test failures I decided to test some other 
drivers to see what happens. As I don't have many webcams I decided to 
test vivi and surprise, same error is reported.


I don't know enough v4l2 / vb2 internals to say much about these. But I 
think I don't care to try fix SDR drivers as that same error seems to be 
reported other devices too. Maybe it is some corner case or false 
positive. Anyhow, it could be nice to get rid of it.


joulu 22 18:26:31 localhost.localdomain kernel: vivi-000: V4L2 device 
registered as video0
joulu 22 18:26:31 localhost.localdomain kernel: Video Technology 
Magazine Virtual Video Capture Board ver 0.8.1 successfully loaded.
joulu 22 18:26:31 localhost.localdomain colord[630]: Device added: 
sysfs-/dev/video0
joulu 22 18:26:43 localhost.localdomain chronyd[563]: Selected source 
62.237.86.234
joulu 22 18:26:51 localhost.localdomain kernel: joulu 22 18:26:51 
localhost.localdomain kernel: 
======================================================
joulu 22 18:26:51 localhost.localdomain kernel: [ INFO: possible 
circular locking dependency detected ]
joulu 22 18:26:51 localhost.localdomain kernel: 3.13.0-rc1+ #77 Tainted: 
G         C O
joulu 22 18:26:51 localhost.localdomain kernel: 
-------------------------------------------------------
joulu 22 18:26:51 localhost.localdomain kernel: video_source:sr/32072 is 
trying to acquire lock:
joulu 22 18:26:51 localhost.localdomain kernel: 
(&dev->mutex#2){+.+.+.}, at: [<ffffffffa073fde3>] vb2_fop_mmap+0x33/0x90 
[videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 but task is already 
holding lock:
joulu 22 18:26:51 localhost.localdomain kernel: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 which lock already 
depends on the new lock.
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 the existing dependency 
chain (in reverse order) is:
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 -> #1 
(&mm->mmap_sem){++++++}:
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff81181f3c>] might_fault+0x8c/0xb0
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffffa06c3055>] video_usercopy+0x355/0x4e0 [videodev]
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffffa06c31f5>] video_ioctl2+0x15/0x20 [videodev]
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffffa06bce73>] v4l2_ioctl+0x153/0x240 [videodev]
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff811e0590>] do_vfs_ioctl+0x300/0x520
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff811e0831>] SyS_ioctl+0x81/0xa0
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 -> #0 
(&dev->mutex#2){+.+.+.}:
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810b96b7>] validate_chain.isra.36+0x10d7/0x1130
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff816bf1c7>] mutex_lock_interruptible_nested+0x77/0x460
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffffa073fde3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffffa06bc85a>] v4l2_mmap+0x5a/0xa0 [videodev]
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff8118da7d>] mmap_region+0x3cd/0x5a0
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff8118dfa7>] do_mmap_pgoff+0x357/0x3e0
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff81178280>] vm_mmap_pgoff+0x90/0xc0
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff8118c553>] SyS_mmap_pgoff+0x1d3/0x270
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff810191a2>] SyS_mmap+0x22/0x30
joulu 22 18:26:51 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 other info that might 
help us debug this:
joulu 22 18:26:51 localhost.localdomain kernel:  Possible unsafe locking 
scenario:
joulu 22 18:26:51 localhost.localdomain kernel:        CPU0 
        CPU1
joulu 22 18:26:51 localhost.localdomain kernel:        ---- 
        ----
joulu 22 18:26:51 localhost.localdomain kernel:   lock(&mm->mmap_sem);
joulu 22 18:26:51 localhost.localdomain kernel: 
        lock(&dev->mutex#2);
joulu 22 18:26:51 localhost.localdomain kernel: 
        lock(&mm->mmap_sem);
joulu 22 18:26:51 localhost.localdomain kernel:   lock(&dev->mutex#2);
joulu 22 18:26:51 localhost.localdomain kernel:
                                                  *** DEADLOCK ***
joulu 22 18:26:51 localhost.localdomain kernel: 1 lock held by 
video_source:sr/32072:
joulu 22 18:26:51 localhost.localdomain kernel:  #0: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
joulu 22 18:26:51 localhost.localdomain kernel:
                                                 stack backtrace:
joulu 22 18:26:51 localhost.localdomain kernel: CPU: 2 PID: 32072 Comm: 
video_source:sr Tainted: G         C O 3.13.0-rc1+ #77
joulu 22 18:26:51 localhost.localdomain kernel: Hardware name: System 
manufacturer System Product Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
joulu 22 18:26:51 localhost.localdomain kernel:  ffffffff824fe950 
ffff880283683b68 ffffffff816b8da9 ffffffff824fe950
joulu 22 18:26:51 localhost.localdomain kernel:  ffff880283683ba8 
ffffffff816b2c9b ffff880283683be0 0000000000000000
joulu 22 18:26:51 localhost.localdomain kernel:  ffff88030637c378 
0000000000000001 ffff88030637bcf0 ffff88030637c378
joulu 22 18:26:51 localhost.localdomain kernel: Call Trace:
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff816b8da9>] 
dump_stack+0x4d/0x66
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff816b2c9b>] 
print_circular_bug+0x200/0x20e
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff810b96b7>] 
validate_chain.isra.36+0x10d7/0x1130
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff810bb3a7>] ? 
__lock_acquire+0x3f7/0xc40
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff810bb386>] 
__lock_acquire+0x3d6/0xc40
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8101c489>] ? 
sched_clock+0x9/0x10
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff810bbca0>] 
lock_acquire+0xb0/0x150
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffffa073fde3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff816bf1c7>] 
mutex_lock_interruptible_nested+0x77/0x460
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffffa073fde3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffffa073fde3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffffa073fde3>] 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffffa06bc85a>] 
v4l2_mmap+0x5a/0xa0 [videodev]
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8118da7d>] 
mmap_region+0x3cd/0x5a0
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8118dfa7>] 
do_mmap_pgoff+0x357/0x3e0
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff81178280>] 
vm_mmap_pgoff+0x90/0xc0
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff8118c553>] 
SyS_mmap_pgoff+0x1d3/0x270
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff810191a2>] 
SyS_mmap+0x22/0x30
joulu 22 18:26:51 localhost.localdomain kernel:  [<ffffffff816ca729>] 
system_call_fastpath+0x16/0x1b



***********************************************
MSi3101 driver
***********************************************


joulu 22 00:30:39 localhost.localdomain kernel: usb 2-2: 
msi3101_queue_setup: nbuffers=32 sizes[0]=8192
joulu 22 00:30:39 localhost.localdomain kernel: joulu 22 00:30:39 
localhost.localdomain kernel: 
======================================================
joulu 22 00:30:39 localhost.localdomain kernel: [ INFO: possible 
circular locking dependency detected ]
joulu 22 00:30:39 localhost.localdomain kernel: 3.13.0-rc1+ #77 Tainted: 
G         C O
joulu 22 00:30:39 localhost.localdomain kernel: 
-------------------------------------------------------
joulu 22 00:30:39 localhost.localdomain kernel: python/19615 is trying 
to acquire lock:
joulu 22 00:30:39 localhost.localdomain kernel: 
(&s->vb_queue_lock){+.+.+.}, at: [<ffffffffa06dade3>] 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 but task is already 
holding lock:
joulu 22 00:30:39 localhost.localdomain kernel: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 which lock already 
depends on the new lock.
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 the existing dependency 
chain (in reverse order) is:
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 -> #1 
(&mm->mmap_sem){++++++}:
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff81181f3c>] might_fault+0x8c/0xb0
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffffa06b3dba>] video_usercopy+0xba/0x4e0 [videodev]
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffffa06b41f5>] video_ioctl2+0x15/0x20 [videodev]
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffffa06ade73>] v4l2_ioctl+0x153/0x240 [videodev]
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff811e0590>] do_vfs_ioctl+0x300/0x520
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff811e0831>] SyS_ioctl+0x81/0xa0
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 -> #0 
(&s->vb_queue_lock){+.+.+.}:
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810b96b7>] validate_chain.isra.36+0x10d7/0x1130
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff816bf1c7>] mutex_lock_interruptible_nested+0x77/0x460
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffffa06dade3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffffa06ad85a>] v4l2_mmap+0x5a/0xa0 [videodev]
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff8118da7d>] mmap_region+0x3cd/0x5a0
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff8118dfa7>] do_mmap_pgoff+0x357/0x3e0
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff81178280>] vm_mmap_pgoff+0x90/0xc0
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff8118c553>] SyS_mmap_pgoff+0x1d3/0x270
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff810191a2>] SyS_mmap+0x22/0x30
joulu 22 00:30:39 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 other info that might 
help us debug this:
joulu 22 00:30:39 localhost.localdomain kernel:  Possible unsafe locking 
scenario:
joulu 22 00:30:39 localhost.localdomain kernel:        CPU0 
        CPU1
joulu 22 00:30:39 localhost.localdomain kernel:        ---- 
        ----
joulu 22 00:30:39 localhost.localdomain kernel:   lock(&mm->mmap_sem);
joulu 22 00:30:39 localhost.localdomain kernel: 
        lock(&s->vb_queue_lock);
joulu 22 00:30:39 localhost.localdomain kernel: 
        lock(&mm->mmap_sem);
joulu 22 00:30:39 localhost.localdomain kernel:   lock(&s->vb_queue_lock);
joulu 22 00:30:39 localhost.localdomain kernel:
                                                  *** DEADLOCK ***
joulu 22 00:30:39 localhost.localdomain kernel: 1 lock held by python/19615:
joulu 22 00:30:39 localhost.localdomain kernel:  #0: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
joulu 22 00:30:39 localhost.localdomain kernel:
                                                 stack backtrace:
joulu 22 00:30:39 localhost.localdomain kernel: CPU: 2 PID: 19615 Comm: 
python Tainted: G         C O 3.13.0-rc1+ #77
joulu 22 00:30:39 localhost.localdomain kernel: Hardware name: System 
manufacturer System Product Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
joulu 22 00:30:39 localhost.localdomain kernel:  ffffffff825038c0 
ffff8802028ffb68 ffffffff816b8da9 ffffffff825038c0
joulu 22 00:30:39 localhost.localdomain kernel:  ffff8802028ffba8 
ffffffff816b2c9b ffff8802028ffbe0 0000000000000000
joulu 22 00:30:39 localhost.localdomain kernel:  ffff880202bcec18 
0000000000000001 ffff880202bce590 ffff880202bcec18
joulu 22 00:30:39 localhost.localdomain kernel: Call Trace:
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff816b8da9>] 
dump_stack+0x4d/0x66
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff816b2c9b>] 
print_circular_bug+0x200/0x20e
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff810b96b7>] 
validate_chain.isra.36+0x10d7/0x1130
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff810bb3a7>] ? 
__lock_acquire+0x3f7/0xc40
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff810bb386>] 
__lock_acquire+0x3d6/0xc40
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff81182706>] ? 
__do_fault+0x236/0x510
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8101c489>] ? 
sched_clock+0x9/0x10
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff810bbca0>] 
lock_acquire+0xb0/0x150
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffffa06dade3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff816bf1c7>] 
mutex_lock_interruptible_nested+0x77/0x460
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffffa06dade3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffffa06dade3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffffa06dade3>] 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffffa06ad85a>] 
v4l2_mmap+0x5a/0xa0 [videodev]
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8118da7d>] 
mmap_region+0x3cd/0x5a0
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8118dfa7>] 
do_mmap_pgoff+0x357/0x3e0
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff81178280>] 
vm_mmap_pgoff+0x90/0xc0
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff8118c553>] 
SyS_mmap_pgoff+0x1d3/0x270
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff810191a2>] 
SyS_mmap+0x22/0x30
joulu 22 00:30:39 localhost.localdomain kernel:  [<ffffffff816ca729>] 
system_call_fastpath+0x16/0x1b
joulu 22 00:30:39 localhost.localdomain kernel: usb 2-2: 
msi3101_start_streaming:
joulu 22 00:30:39 localhost.localdomain kernel: usb 2-2: 
msi3101_set_usb_adc: div_r_out=4 f_vco=0



-- 
http://palosaari.fi/
