Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:41461 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3EIQL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 12:11:28 -0400
Received: by mail-lb0-f195.google.com with SMTP id 13so795975lba.2
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 09:11:26 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 May 2013 17:11:26 +0100
Message-ID: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
Subject: stk1160: cannot alloc 196608 bytes
From: a b <genericgroupmail@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am seeing occasional issues when using an easycap card on our fedora
17 machine.
We are using gstreamer to record video from the device which is using
the precanned stk1160 driver. Over extended periods i.e. following a
number of video recordings we occasionally see an issue whereby
gstreamer suddenly starts to complain and video capture fails.
I can see various issues flagged under the system logs but ultimately
the only course of action to resolve the issue is to unplug and
re-insert the usb easycap device.
The system resources all appear to be fine, i.e. lots of RAM, disk space etc.

Here are the machine details:

Linux localhost.localdomain 3.7.6-102.fc17.i686 #1 SMP Mon Feb 4
17:52:09 UTC 2013 i686 i686 i386 GNU/Linux

Easycap device:

Bus 002 Device 002: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160
Video Capture Device

Logs:

message log:
May 8 10:00:51 localhost kernel: [675741.708919] stk1160: queue_setup:
buffer count 8, each 829440 bytes
May 8 10:00:51 localhost kernel: [675741.711801] stk1160: setting alternate 5
May 8 10:00:51 localhost kernel: [675741.712947] gst-launch-0.10: page
allocation failure: order:6, mode:0x80d0
May 8 10:00:51 localhost kernel: [675741.712952] Pid: 11623, comm:
gst-launch-0.10 Tainted: P O 3.7.6-102.fc17.i686 #1
May 8 10:00:51 localhost kernel: [675741.712954] Call Trace:
May 8 10:00:51 localhost kernel: [675741.712963] [] warn_alloc_failed+0xad/0xf0
May 8 10:00:51 localhost kernel: [675741.712967] []
__alloc_pages_nodemask+0x55f/0x7d0
May 8 10:00:51 localhost kernel: [675741.712973] []
dma_generic_alloc_coherent+0x8d/0xc0
May 8 10:00:51 localhost kernel: [675741.712976] [] ? dma_set_mask+0x60/0x60
May 8 10:00:51 localhost kernel: [675741.712981] [] hcd_buffer_alloc+0xa6/0x120
May 8 10:00:51 localhost kernel: [675741.712985] [] usb_alloc_coherent+0x22/0x30
May 8 10:00:51 localhost kernel: [675741.712995] []
stk1160_alloc_isoc+0xe7/0x250 [stk1160]
May 8 10:00:51 localhost kernel: [675741.712999] [] ? printk+0x4d/0x4f
May 8 10:00:51 localhost kernel: [675741.713013] []
start_streaming+0x15a/0x270 [stk1160]
May 8 10:00:51 localhost kernel: [675741.713032] []
vb2_streamon+0xdb/0x160 [videobuf2_core]
May 8 10:00:51 localhost kernel: [675741.713040] []
vb2_ioctl_streamon+0x4f/0x60 [videobuf2_core]
May 8 10:00:51 localhost kernel: [675741.713052] []
v4l_streamon+0x1a/0x20 [videodev]
May 8 10:00:51 localhost kernel: [675741.713059] []
__video_do_ioctl+0x254/0x350 [videodev]
May 8 10:00:51 localhost kernel: [675741.713065] [] ?
__copy_to_user_ll+0x65/0x70
May 8 10:00:51 localhost kernel: [675741.713069] [] ? _copy_from_user+0x41/0x60
May 8 10:00:51 localhost kernel: [675741.713076] [] ?
v4l_printk_ioctl+0xb0/0xb0 [videodev]
May 8 10:00:51 localhost kernel: [675741.713083] []
video_usercopy+0x1b8/0x450 [videodev]
May 8 10:00:51 localhost kernel: [675741.713087] [] ? vm_insert_page+0x14b/0x1c0
May 8 10:00:51 localhost kernel: [675741.713094] [] ?
v4l_printk_ioctl+0xb0/0xb0 [videodev]
May 8 10:00:51 localhost kernel: [675741.713098] [] ?
vma_interval_tree_insert+0x72/0x80
May 8 10:00:51 localhost kernel: [675741.713101] [] ? __vma_link_file+0x43/0x70
May 8 10:00:51 localhost kernel: [675741.713104] [] ? vma_link+0x68/0xb0
May 8 10:00:51 localhost kernel: [675741.713112] []
video_ioctl2+0x17/0x20 [videodev]
May 8 10:00:51 localhost kernel: [675741.713119] [] ?
v4l_printk_ioctl+0xb0/0xb0 [videodev]
May 8 10:00:51 localhost kernel: [675741.713132] []
v4l2_ioctl+0xfe/0x140 [videodev]
May 8 10:00:51 localhost kernel: [675741.713149] [] ?
v4l2_open+0x110/0x110 [videodev]
May 8 10:00:51 localhost kernel: [675741.713156] [] do_vfs_ioctl+0x7a/0x590
May 8 10:00:51 localhost kernel: [675741.713160] [] ?
inode_has_perm.isra.31.constprop.62+0x3a/0x50
May 8 10:00:51 localhost kernel: [675741.713164] [] ? file_has_perm+0xa0/0xb0
May 8 10:00:51 localhost kernel: [675741.713168] [] ?
security_mmap_file+0x33/0x70
May 8 10:00:51 localhost kernel: [675741.713172] [] ? vm_mmap_pgoff+0x70/0x90
May 8 10:00:51 localhost kernel: [675741.713175] [] ?
selinux_file_ioctl+0x48/0xe0
May 8 10:00:51 localhost kernel: [675741.713179] [] sys_ioctl+0x6b/0x80
May 8 10:00:51 localhost kernel: [675741.713183] [] sysenter_do_call+0x12/0x28
May 8 10:00:51 localhost kernel: [675741.713185] Mem-Info:
May 8 10:00:51 localhost kernel: [675741.713187] DMA per-cpu:
May 8 10:00:51 localhost kernel: [675741.713189] CPU 0: hi: 0, btch: 1 usd: 0
May 8 10:00:51 localhost kernel: [675741.713191] CPU 1: hi: 0, btch: 1 usd: 0
May 8 10:00:51 localhost kernel: [675741.713197] CPU 2: hi: 0, btch: 1 usd: 0
May 8 10:00:51 localhost kernel: [675741.713205] CPU 3: hi: 0, btch: 1 usd: 0
May 8 10:00:51 localhost kernel: [675741.713213] Normal per-cpu:
May 8 10:00:51 localhost kernel: [675741.713218] CPU 0: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713220] CPU 1: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713222] CPU 2: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713224] CPU 3: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713225] HighMem per-cpu:
May 8 10:00:51 localhost kernel: [675741.713227] CPU 0: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713229] CPU 1: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713231] CPU 2: hi: 186, btch:
31 usd: 30
May 8 10:00:51 localhost kernel: [675741.713233] CPU 3: hi: 186, btch: 31 usd: 0
May 8 10:00:51 localhost kernel: [675741.713237] active_anon:130608
inactive_anon:153248 isolated_anon:0
May 8 10:00:51 localhost kernel: [675741.713237] active_file:247837
inactive_file:251204 isolated_file:0
May 8 10:00:51 localhost kernel: [675741.713237] unevictable:0
dirty:92 writeback:0 unstable:0
May 8 10:00:51 localhost kernel: [675741.713237] free:35376
slab_reclaimable:35470 slab_unreclaimable:9768
May 8 10:00:51 localhost kernel: [675741.713237] mapped:25922
shmem:26962 pagetables:2958 bounce:0
May 8 10:00:51 localhost kernel: [675741.713237] free_cma:0
May 8 10:00:51 localhost kernel: [675741.713246] DMA free:3496kB
min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB
active_file:112kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:3040kB slab_unreclaimable:24kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
May 8 10:00:51 localhost kernel: [675741.713248] lowmem_reserve[]: 0
861 3505 3505
May 8 10:00:51 localhost kernel: [675741.713267] Normal free:130540kB
min:3720kB low:4648kB high:5580kB active_anon:5600kB
inactive_anon:89468kB active_file:200776kB inactive_file:199036kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:881880kB
mlocked:0kB dirty:44kB writeback:0kB mapped:20140kB shmem:17956kB
slab_reclaimable:138840kB slab_unreclaimable:39048kB
kernel_stack:3672kB pagetables:720kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
May 8 10:00:51 localhost kernel: [675741.713282] lowmem_reserve[]: 0 0
21157 21157
May 8 10:00:51 localhost kernel: [675741.713290] HighMem free:7468kB
min:512kB low:3368kB high:6224kB active_anon:516832kB
inactive_anon:523524kB active_file:790460kB inactive_file:805780kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB
present:2708152kB mlocked:0kB dirty:324kB writeback:0kB mapped:83548kB
shmem:89892kB slab_reclaimable:0kB slab_unreclaimable:0kB
kernel_stack:0kB pagetables:11112kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
May 8 10:00:51 localhost kernel: [675741.713293] lowmem_reserve[]: 0 0 0 0
May 8 10:00:51 localhost kernel: [675741.713296] DMA: 6*4kB 2*8kB
6*16kB 7*32kB 7*64kB 7*128kB 7*256kB 0*512kB 0*1024kB 0*2048kB
0*4096kB = 3496kB
May 8 10:00:51 localhost kernel: [675741.713305] Normal: 12034*4kB
8608*8kB 646*16kB 58*32kB 13*64kB 2*128kB 1*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 130536kB
May 8 10:00:51 localhost kernel: [675741.713313] HighMem: 1817*4kB
8*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB
0*4096kB = 7380kB
May 8 10:00:51 localhost kernel: [675741.713321] 528417 total pagecache pages
May 8 10:00:51 localhost kernel: [675741.713323] 2394 pages in swap cache
May 8 10:00:51 localhost kernel: [675741.713325] Swap cache stats: add
51558, delete 49164, find 36725/37426
May 8 10:00:51 localhost kernel: [675741.713327] Free swap = 5530272kB
May 8 10:00:51 localhost kernel: [675741.713328] Total swap = 5701628kB
May 8 10:00:51 localhost kernel: [675741.725405] 908656 pages RAM
May 8 10:00:51 localhost kernel: [675741.725409] 682370 pages HighMem
May 8 10:00:51 localhost kernel: [675741.725410] 11557 pages reserved
May 8 10:00:51 localhost kernel: [675741.725411] 1595644 pages shared
May 8 10:00:51 localhost kernel: [675741.725413] 401326 pages non-shared
May 8 10:00:51 localhost kernel: [675741.725416] stk1160: cannot alloc
196608 bytes for tx[2] buffer
May 8 10:00:51 localhost kernel: [675741.725583] stk1160: buffer
[c8084400/0] aborted
May 8 10:00:51 localhost kernel: [675741.725591] stk1160: buffer
[e93f1800/1] aborted
May 8 10:00:51 localhost kernel: [675741.725592] stk1160: buffer
[e93f1c00/2] aborted
May 8 10:00:51 localhost kernel: [675741.725594] stk1160: buffer
[e93f3000/3] aborted
May 8 10:00:51 localhost kernel: [675741.725595] stk1160: buffer
[eeeb2800/4] aborted
May 8 10:00:51 localhost kernel: [675741.725597] stk1160: buffer
[ee88c800/5] aborted
May 8 10:00:51 localhost kernel: [675741.725598] stk1160: buffer
[eebc8c00/6] aborted
May 8 10:00:51 localhost kernel: [675741.725599] stk1160: buffer
[ed90d400/7] aborted

dmesg log:

[675741.704526] stk1160: registers to PAL like standard
[675741.708919] stk1160: queue_setup: buffer count 8, each 829440 bytes
[675741.711801] stk1160: setting alternate 5
[675741.711805] stk1160: allocating urbs...
[675741.712947] gst-launch-0.10: page allocation failure: order:6, mode:0x80d0
[675741.712952] Pid: 11623, comm: gst-launch-0.10 Tainted: P O
3.7.6-102.fc17.i686 #1
[675741.712954] Call Trace:
[675741.712963] [] warn_alloc_failed+0xad/0xf0
[675741.712967] [] __alloc_pages_nodemask+0x55f/0x7d0
[675741.712973] [] dma_generic_alloc_coherent+0x8d/0xc0
[675741.712976] [] ? dma_set_mask+0x60/0x60
[675741.712981] [] hcd_buffer_alloc+0xa6/0x120
[675741.712985] [] usb_alloc_coherent+0x22/0x30
[675741.712995] [] stk1160_alloc_isoc+0xe7/0x250 [stk1160]
[675741.712999] [] ? printk+0x4d/0x4f
[675741.713013] [] start_streaming+0x15a/0x270 [stk1160]
[675741.713032] [] vb2_streamon+0xdb/0x160 [videobuf2_core]
[675741.713040] [] vb2_ioctl_streamon+0x4f/0x60 [videobuf2_core]
[675741.713052] [] v4l_streamon+0x1a/0x20 [videodev]
[675741.713059] [] __video_do_ioctl+0x254/0x350 [videodev]
[675741.713065] [] ? __copy_to_user_ll+0x65/0x70
[675741.713069] [] ? _copy_from_user+0x41/0x60
[675741.713076] [] ? v4l_printk_ioctl+0xb0/0xb0 [videodev]
[675741.713083] [] video_usercopy+0x1b8/0x450 [videodev]
[675741.713087] [] ? vm_insert_page+0x14b/0x1c0
[675741.713094] [] ? v4l_printk_ioctl+0xb0/0xb0 [videodev]
[675741.713098] [] ? vma_interval_tree_insert+0x72/0x80
[675741.713101] [] ? __vma_link_file+0x43/0x70
[675741.713104] [] ? vma_link+0x68/0xb0
[675741.713112] [] video_ioctl2+0x17/0x20 [videodev]
[675741.713119] [] ? v4l_printk_ioctl+0xb0/0xb0 [videodev]
[675741.713132] [] v4l2_ioctl+0xfe/0x140 [videodev]
[675741.713149] [] ? v4l2_open+0x110/0x110 [videodev]
[675741.713156] [] do_vfs_ioctl+0x7a/0x590
[675741.713160] [] ? inode_has_perm.isra.31.constprop.62+0x3a/0x50
[675741.713164] [] ? file_has_perm+0xa0/0xb0
[675741.713168] [] ? security_mmap_file+0x33/0x70
[675741.713172] [] ? vm_mmap_pgoff+0x70/0x90
[675741.713175] [] ? selinux_file_ioctl+0x48/0xe0
[675741.713179] [] sys_ioctl+0x6b/0x80
[675741.713183] [] sysenter_do_call+0x12/0x28
[675741.713185] Mem-Info:
[675741.713187] DMA per-cpu:
[675741.713189] CPU 0: hi: 0, btch: 1 usd: 0
[675741.713191] CPU 1: hi: 0, btch: 1 usd: 0
[675741.713197] CPU 2: hi: 0, btch: 1 usd: 0
[675741.713205] CPU 3: hi: 0, btch: 1 usd: 0
[675741.713213] Normal per-cpu:
[675741.713218] CPU 0: hi: 186, btch: 31 usd: 0
[675741.713220] CPU 1: hi: 186, btch: 31 usd: 0
[675741.713222] CPU 2: hi: 186, btch: 31 usd: 0
[675741.713224] CPU 3: hi: 186, btch: 31 usd: 0
[675741.713225] HighMem per-cpu:
[675741.713227] CPU 0: hi: 186, btch: 31 usd: 0
[675741.713229] CPU 1: hi: 186, btch: 31 usd: 0
[675741.713231] CPU 2: hi: 186, btch: 31 usd: 30
[675741.713233] CPU 3: hi: 186, btch: 31 usd: 0
[675741.713237] active_anon:130608 inactive_anon:153248 isolated_anon:0
[675741.713237] active_file:247837 inactive_file:251204 isolated_file:0
[675741.713237] unevictable:0 dirty:92 writeback:0 unstable:0
[675741.713237] free:35376 slab_reclaimable:35470 slab_unreclaimable:9768
[675741.713237] mapped:25922 shmem:26962 pagetables:2958 bounce:0
[675741.713237] free_cma:0
[675741.713246] DMA free:3496kB min:64kB low:80kB high:96kB
active_anon:0kB inactive_anon:0kB active_file:112kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:3040kB slab_unreclaimable:24kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[675741.713248] lowmem_reserve[]: 0 861 3505 3505
[675741.713267] Normal free:130540kB min:3720kB low:4648kB high:5580kB
active_anon:5600kB inactive_anon:89468kB active_file:200776kB
inactive_file:199036kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:881880kB mlocked:0kB dirty:44kB
writeback:0kB mapped:20140kB shmem:17956kB slab_reclaimable:138840kB
slab_unreclaimable:39048kB kernel_stack:3672kB pagetables:720kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[675741.713282] lowmem_reserve[]: 0 0 21157 21157
[675741.713290] HighMem free:7468kB min:512kB low:3368kB high:6224kB
active_anon:516832kB inactive_anon:523524kB active_file:790460kB
inactive_file:805780kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:2708152kB mlocked:0kB dirty:324kB
writeback:0kB mapped:83548kB shmem:89892kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:11112kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[675741.713293] lowmem_reserve[]: 0 0 0 0
[675741.713296] DMA: 6*4kB 2*8kB 6*16kB 7*32kB 7*64kB 7*128kB 7*256kB
0*512kB 0*1024kB 0*2048kB 0*4096kB = 3496kB
[675741.713305] Normal: 12034*4kB 8608*8kB 646*16kB 58*32kB 13*64kB
2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 130536kB
[675741.713313] HighMem: 1817*4kB 8*8kB 1*16kB 1*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7380kB
[675741.713321] 528417 total pagecache pages
[675741.713323] 2394 pages in swap cache
[675741.713325] Swap cache stats: add 51558, delete 49164, find 36725/37426
[675741.713327] Free swap = 5530272kB
[675741.713328] Total swap = 5701628kB
[675741.725405] 908656 pages RAM
[675741.725409] 682370 pages HighMem
[675741.725410] 11557 pages reserved
[675741.725411] 1595644 pages shared
[675741.725413] 401326 pages non-shared
[675741.725416] stk1160: cannot alloc 196608 bytes for tx[2] buffer
[675741.725419] stk1160: freeing 3 urb buffers...
[675741.725429] stk1160: all urb buffers freed
[675741.725583] stk1160: buffer [c8084400/0] aborted
[675741.725591] stk1160: buffer [e93f1800/1] aborted
[675741.725592] stk1160: buffer [e93f1c00/2] aborted
[675741.725594] stk1160: buffer [e93f3000/3] aborted
[675741.725595] stk1160: buffer [eeeb2800/4] aborted
[675741.725597] stk1160: buffer [ee88c800/5] aborted
[675741.725598] stk1160: buffer [eebc8c00/6] aborted
[675741.725599] stk1160: buffer [ed90d400/7] aborted

I would really appreciate if you could give me some pointers as to
what it may be or any suggestions as to how to workaround it without
having to physically reseat the usb?

Thanks in advance!
