Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43963 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3COQGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 12:06:30 -0400
Received: by mail-qc0-f169.google.com with SMTP id t2so1634648qcq.14
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2013 09:06:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1d63fccd-b2ce-4176-be14-18d5291a486e@zimbra.mdabbs.org>
References: <7d2641de-04e6-47dc-95d8-5fa64d6812d8@zimbra.mdabbs.org>
	<1d63fccd-b2ce-4176-be14-18d5291a486e@zimbra.mdabbs.org>
Date: Fri, 15 Mar 2013 12:06:28 -0400
Message-ID: <CAGoCfixans=6fOCDivGFw1yauOp-J9mrg3G+ENV5B4a7j_FfZQ@mail.gmail.com>
Subject: Re: DVB memory leak?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: moasat@moasat.dyndns.org
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 15, 2013 at 11:19 AM,  <moasat@moasat.dyndns.org> wrote:
> I've been fighting a situation where the kernel appears to be running out of memory over a period of time.  I originally had my low address space reserve set to 4096 and memory compaction on.  I would get this error within a few days of reboot:
>
> Mar 06 19:25:03 [kernel] [168311.801139] DVBRead: page allocation failure: order:4, mode:0xc0d0
> Mar 06 19:25:03 [kernel] [168311.801145] Pid: 15153, comm: DVBRead Tainted: G         C   3.7.10-gentoo #3
> Mar 06 19:25:03 [kernel] [168311.801146] Call Trace:
> Mar 06 19:25:03 [kernel] [168311.801160]  [<ffffffff810e7e3b>] warn_alloc_failed+0xeb/0x130
> Mar 06 19:25:03 [kernel] [168311.801163]  [<ffffffff810eaddd>] ? __alloc_pages_direct_compact+0x1ed/0x200
> Mar 06 19:25:03 [kernel] [168311.801166]  [<ffffffff810eb6ec>] __alloc_pages_nodemask+0x8fc/0x9c0
> Mar 06 19:25:03 [kernel] [168311.801175]  [<ffffffff81598943>] ? usb_start_wait_urb+0xa3/0x160
> Mar 06 19:25:03 [kernel] [168311.801179]  [<ffffffff81121b41>] alloc_pages_current+0xb1/0x120
> Mar 06 19:25:03 [kernel] [168311.801181]  [<ffffffff81597d49>] ? usb_alloc_urb+0x19/0x50
> Mar 06 19:25:03 [kernel] [168311.801184]  [<ffffffff810e6fe9>] __get_free_pages+0x9/0x40
> Mar 06 19:25:03 [kernel] [168311.801187]  [<ffffffff8112752a>] kmalloc_order_trace+0x3a/0xb0
> Mar 06 19:25:03 [kernel] [168311.801193]  [<ffffffffa00c9483>] start_urb_transfer+0x83/0x1c0 [au0828]
> Mar 06 19:25:03 [kernel] [168311.801197]  [<ffffffffa00c9698>] au0828_dvb_start_feed+0xd8/0x100 [au0828]
> Mar 06 19:25:03 [kernel] [168311.801201]  [<ffffffff8160a6ae>] dmx_ts_feed_start_filtering+0x5e/0xf0
> Mar 06 19:25:03 [kernel] [168311.801204]  [<ffffffff81607a7c>] dvb_dmxdev_start_feed.clone.0+0xcc/0x120
> Mar 06 19:25:03 [kernel] [168311.801206]  [<ffffffff816085ec>] dvb_dmxdev_filter_start+0x28c/0x3b0
> Mar 06 19:25:03 [kernel] [168311.801209]  [<ffffffff81608d8a>] dvb_demux_do_ioctl+0x51a/0x6a0
> Mar 06 19:25:03 [kernel] [168311.801211]  [<ffffffff81606e04>] dvb_usercopy+0xa4/0x170
> Mar 06 19:25:03 [kernel] [168311.801214]  [<ffffffff81608870>] ? dvb_demux_open+0x160/0x160
> Mar 06 19:25:03 [kernel] [168311.801217]  [<ffffffff8110ab5b>] ? handle_mm_fault+0x13b/0x210
> Mar 06 19:25:03 [kernel] [168311.801221]  [<ffffffff8113e344>] ? do_filp_open+0x44/0xa0
> Mar 06 19:25:03 [kernel] [168311.801224]  [<ffffffff81607480>] dvb_demux_ioctl+0x10/0x20
> Mar 06 19:25:03 [kernel] [168311.801226]  [<ffffffff81140026>] do_vfs_ioctl+0x96/0x4f0
> Mar 06 19:25:03 [kernel] [168311.801230]  [<ffffffff81332654>] ? inode_has_perm.clone.25.clone.35+0x24/0x30
> Mar 06 19:25:03 [kernel] [168311.801233]  [<ffffffff81334f40>] ? file_has_perm+0x90/0xa0
> Mar 06 19:25:03 [kernel] [168311.801236]  [<ffffffff81140511>] sys_ioctl+0x91/0xa0
> Mar 06 19:25:03 [kernel] [168311.801240]  [<ffffffff818a9b52>] system_call_fastpath+0x16/0x1b
> Mar 06 19:25:03 [kernel] [168311.801242] Mem-Info:
> Mar 06 19:25:03 [kernel] [168311.801243] Node 0 DMA per-cpu:
> Mar 06 19:25:03 [kernel] [168311.801246] CPU    0: hi:    0, btch:   1 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801247] CPU    1: hi:    0, btch:   1 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801249] CPU    2: hi:    0, btch:   1 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801250] CPU    3: hi:    0, btch:   1 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801251] Node 0 DMA32 per-cpu:
> Mar 06 19:25:03 [kernel] [168311.801253] CPU    0: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801255] CPU    1: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801256] CPU    2: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801258] CPU    3: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801259] Node 0 Normal per-cpu:
> Mar 06 19:25:03 [kernel] [168311.801260] CPU    0: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801262] CPU    1: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801264] CPU    2: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801265] CPU    3: hi:  186, btch:  31 usd:   0
> Mar 06 19:25:03 [kernel] [168311.801269] active_anon:139468 inactive_anon:57451 isolated_anon:0
> Mar 06 19:25:03 [kernel] [168311.801269]  active_file:375632 inactive_file:366012 isolated_file:0
> Mar 06 19:25:03 [kernel] [168311.801269]  unevictable:0 dirty:556 writeback:0 unstable:0
> Mar 06 19:25:03 [kernel] [168311.801269]  free:10993 slab_reclaimable:32206 slab_unreclaimable:6181
> Mar 06 19:25:03 [kernel] [168311.801269]  mapped:11149 shmem:256 pagetables:2768 bounce:0
> Mar 06 19:25:03 [kernel] [168311.801269]  free_cma:0
> Mar 06 19:25:03 [kernel] [168311.801272] Node 0 DMA free:15904kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> Mar 06 19:25:03 [kernel] [168311.801277] lowmem_reserve[]: 0 3247 4003 4003
> Mar 06 19:25:03 [kernel] [168311.801285] lowmem_reserve[]: 0 0 756 756
> Mar 06 19:25:03 [kernel] [168311.801292] lowmem_reserve[]: 0 0 0 0
> Mar 06 19:25:03 [kernel] [168311.801295] Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15904kB
> Mar 06 19:25:03 [kernel] [168311.801302] Node 0 DMA32: 3586*4kB 1072*8kB 36*16kB 12*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 24520kB
> Mar 06 19:25:03 [kernel] [168311.801310] Node 0 Normal: 565*4kB 87*8kB 17*16kB 6*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3548kB
> Mar 06 19:25:03 [kernel] [168311.801321] 742832 total pagecache pages
> Mar 06 19:25:03 [kernel] [168311.801322] 894 pages in swap cache
> Mar 06 19:25:03 [kernel] [168311.801324] Swap cache stats: add 36522, delete 35628, find 35755/36229
> Mar 06 19:25:03 [kernel] [168311.801325] Free swap  = 4081580kB
> Mar 06 19:25:03 [kernel] [168311.801326] Total swap = 4200992kB
> Mar 06 19:25:03 [kernel] [168311.813927] 1048560 pages RAM
> Mar 06 19:25:03 [kernel] [168311.813930] 36788 pages reserved
> Mar 06 19:25:03 [kernel] [168311.813931] 1640406 pages shared
> Mar 06 19:25:03 [kernel] [168311.813932] 423361 pages non-shared
>
>
>
>
> I tried upping the reserve to 65536 and removing the page compaction since I saw that in the stack trace and thought it might be a potential problem.  At least it would remove one variable from the problem.  The system ran longer but eventually through this error:
>
> Mar 14 18:55:03 [kernel] [563482.243067] DVBRead: page allocation failure: order:4, mode:0xc0d0
> Mar 14 18:55:03 [kernel] [563482.243072] Pid: 25561, comm: DVBRead Tainted: G         C   3.7.10-gentoo #4
> Mar 14 18:55:03 [kernel] [563482.243074] Call Trace:
> Mar 14 18:55:04 [kernel] [563482.243081]  [<ffffffff810e7e3b>] warn_alloc_failed+0xeb/0x130
> Mar 14 18:55:04 [kernel] [563482.243084]  [<ffffffff810eb421>] ? drain_local_pages+0x11/0x20
> Mar 14 18:55:04 [kernel] [563482.243086]  [<ffffffff810ead4a>] __alloc_pages_nodemask+0x62a/0x880
> Mar 14 18:55:04 [kernel] [563482.243091]  [<ffffffff8111e551>] alloc_pages_current+0xb1/0x120
> Mar 14 18:55:04 [kernel] [563482.243093]  [<ffffffff810e6fe9>] __get_free_pages+0x9/0x40
> Mar 14 18:55:04 [kernel] [563482.243096]  [<ffffffff811240aa>] kmalloc_order_trace+0x3a/0xb0
> Mar 14 18:55:04 [kernel] [563482.243102]  [<ffffffffa00c9483>] start_urb_transfer+0x83/0x1c0 [au0828]
> Mar 14 18:55:04 [kernel] [563482.243105]  [<ffffffffa00c9698>] au0828_dvb_start_feed+0xd8/0x100 [au0828]
> Mar 14 18:55:04 [kernel] [563482.243109]  [<ffffffff816054ee>] dmx_ts_feed_start_filtering+0x5e/0xf0
> Mar 14 18:55:04 [kernel] [563482.243111]  [<ffffffff816028bc>] dvb_dmxdev_start_feed.clone.0+0xcc/0x120
> Mar 14 18:55:04 [kernel] [563482.243114]  [<ffffffff8160342c>] dvb_dmxdev_filter_start+0x28c/0x3b0
> Mar 14 18:55:04 [kernel] [563482.243116]  [<ffffffff81603bca>] dvb_demux_do_ioctl+0x51a/0x6a0
> Mar 14 18:55:04 [kernel] [563482.243118]  [<ffffffff81601c44>] dvb_usercopy+0xa4/0x170
> Mar 14 18:55:04 [kernel] [563482.243121]  [<ffffffff816036b0>] ? dvb_demux_open+0x160/0x160
> Mar 14 18:55:04 [kernel] [563482.243124]  [<ffffffff81107e6b>] ? handle_mm_fault+0x13b/0x210
> Mar 14 18:55:04 [kernel] [563482.243127]  [<ffffffff81139274>] ? do_filp_open+0x44/0xa0
> Mar 14 18:55:04 [kernel] [563482.243129]  [<ffffffff816022c0>] dvb_demux_ioctl+0x10/0x20
> Mar 14 18:55:04 [kernel] [563482.243132]  [<ffffffff8113af56>] do_vfs_ioctl+0x96/0x4f0
> Mar 14 18:55:04 [kernel] [563482.243135]  [<ffffffff8132d494>] ? inode_has_perm.clone.25.clone.35+0x24/0x30
> Mar 14 18:55:04 [kernel] [563482.243138]  [<ffffffff8132fd80>] ? file_has_perm+0x90/0xa0
> Mar 14 18:55:04 [kernel] [563482.243140]  [<ffffffff8113b441>] sys_ioctl+0x91/0xa0
> Mar 14 18:55:04 [kernel] [563482.243144]  [<ffffffff818a4992>] system_call_fastpath+0x16/0x1b
> Mar 14 18:55:04 [kernel] [563482.243146] Mem-Info:
> Mar 14 18:55:04 [kernel] [563482.243147] Node 0 DMA per-cpu:
> Mar 14 18:55:04 [kernel] [563482.243149] CPU    0: hi:    0, btch:   1 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243151] CPU    1: hi:    0, btch:   1 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243152] CPU    2: hi:    0, btch:   1 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243154] CPU    3: hi:    0, btch:   1 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243155] Node 0 DMA32 per-cpu:
> Mar 14 18:55:04 [kernel] [563482.243157] CPU    0: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243159] CPU    1: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243160] CPU    2: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243162] CPU    3: hi:  186, btch:  31 usd: 154
> Mar 14 18:55:04 [kernel] [563482.243163] Node 0 Normal per-cpu:
> Mar 14 18:55:04 [kernel] [563482.243165] CPU    0: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243166] CPU    1: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243167] CPU    2: hi:  186, btch:  31 usd:   0
> Mar 14 18:55:04 [kernel] [563482.243169] CPU    3: hi:  186, btch:  31 usd:  20
> Mar 14 18:55:04 [kernel] [563482.243172] active_anon:210949 inactive_anon:74267 isolated_anon:0
> Mar 14 18:55:04 [kernel] [563482.243172]  active_file:310728 inactive_file:310245 isolated_file:0
> Mar 14 18:55:04 [kernel] [563482.243172]  unevictable:0 dirty:122 writeback:0 unstable:0
> Mar 14 18:55:04 [kernel] [563482.243172]  free:44302 slab_reclaimable:32125 slab_unreclaimable:6209
> Mar 14 18:55:04 [kernel] [563482.243172]  mapped:11324 shmem:2395 pagetables:3151 bounce:0
> Mar 14 18:55:04 [kernel] [563482.243172]  free_cma:0
> Mar 14 18:55:04 [kernel] [563482.243176] Node 0 DMA free:15904kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> Mar 14 18:55:04 [kernel] [563482.243181] lowmem_reserve[]: 0 3247 4003 4003
> Mar 14 18:55:04 [kernel] [563482.243184] Node 0 DMA32 free:151752kB min:6552kB low:8188kB high:9828kB active_anon:738896kB inactive_anon:187464kB active_file:1050596kB inactive_file:1050380kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3325056kB mlocked:0kB dirty:124kB writeback:0kB mapped:28576kB shmem:8816kB slab_reclaimable:103772kB slab_unreclaimable:6500kB kernel_stack:736kB pagetables:5196kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:273 all_unreclaimable? no
> Mar 14 18:55:04 [kernel] [563482.243189] lowmem_reserve[]: 0 0 756 756
> Mar 14 18:55:04 [kernel] [563482.243196] lowmem_reserve[]: 0 0 0 0
> Mar 14 18:55:04 [kernel] [563482.243199] Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15904kB
> Mar 14 18:55:04 [kernel] [563482.243206] Node 0 DMA32: 3140*4kB 13397*8kB 1921*16kB 26*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 151752kB
> Mar 14 18:55:04 [kernel] [563482.243212] Node 0 Normal: 1498*4kB 397*8kB 10*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 9552kB
> Mar 14 18:55:04 [kernel] [563482.243219] 624263 total pagecache pages
> Mar 14 18:55:04 [kernel] [563482.243220] 825 pages in swap cache
> Mar 14 18:55:04 [kernel] [563482.243222] Swap cache stats: add 62462, delete 61637, find 126775/127278
> Mar 14 18:55:04 [kernel] [563482.243223] Free swap  = 3979468kB
> Mar 14 18:55:04 [kernel] [563482.243224] Total swap = 4200992kB
> Mar 14 18:55:04 [kernel] [563482.258396] 1048560 pages RAM
> Mar 14 18:55:04 [kernel] [563482.258399] 36781 pages reserved
> Mar 14 18:55:04 [kernel] [563482.258401] 1675869 pages shared
> Mar 14 18:55:04 [kernel] [563482.258402] 348212 pages non-shared
>
>
> This is really a problem as I don't want to have to keep rebooting the server to keep things running.  I also get no error before hand so I am missing shows.  Myth gets no indication other than a zero-byte file that anything is wrong.

There are probably a couple of different issues here.  It's possible
I've got a leak in the DVB side of the au0828 where we aren't properly
deallocating all the URBs.  Separate from that though, the allocation
failure should be returned up the stack and the application should
note the failure condition.  Either I've got a bug in the driver where
it doesn't get back to userland, or MythTV doesn't actually check the
error condition and report the failure.

I've got some other fixes coming down the pipe for that driver.  Will
take a look over the next couple of weeks and see if I can spot the
leak.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
