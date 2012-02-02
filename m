Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38924 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab2BBTCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 14:02:42 -0500
Received: by eaah12 with SMTP id h12so1175311eaa.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 11:02:40 -0800 (PST)
Message-ID: <4F2ADDCB.4060200@gmail.com>
Date: Thu, 02 Feb 2012 20:02:35 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>
In-Reply-To: <4F2AC7BF.4040006@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 02/02/2012 18:28, Andy Furniss ha scritto:
> Hi.
> 
> I've got an old PIII 256M Ram PC that for years has served as an always
> on TV streamer/recorder and gateway/server box.
> 
> It had 2 PCI dvb cards until now I have a PCTV 290e so replaced one card
> with a USB2 PCI card.
> 
> At first the PCTV worked OK, but now I've been getting a page allocation
> failure. After this happens I can't use the PVTV until I re-plug it. It
> will then work, but the next day I am likely to get the same.
> 
> Free/meminfo (to my untrained eye) seem to show available mem.
> 
> mumudvb: page allocation failure: order:4, mode:0x80d0
> Pid: 15776, comm: mumudvb Not tainted 3.3.0-rc1 #6
> Call Trace:
>  [<c102a43b>] ? printk+0x1b/0x20
>  [<c107c353>] warn_alloc_failed+0xc3/0x130
>  [<c107dab7>] __alloc_pages_nodemask+0x447/0x580
>  [<c1006e58>] dma_generic_alloc_coherent+0x68/0xe0
>  [<c1255b41>] hcd_buffer_alloc+0x101/0x110
>  [<c1006df0>] ? dma_set_mask+0x50/0x50
>  [<c1248e35>] usb_alloc_coherent+0x25/0x30
>  [<d1dab1cc>] em28xx_init_isoc+0x10c/0x360 [em28xx]
>  [<d1dcb0ad>] em28xx_start_feed+0xad/0xe0 [em28xx_dvb]
>  [<d1dcca20>] ? em28xx_mt352_terratec_xs_init+0x120/0x120 [em28xx_dvb]
>  [<d194438c>] dmx_ts_feed_start_filtering+0x4c/0xd0 [dvb_core]
>  [<d1941d3d>] dvb_dmxdev_start_feed+0x9d/0xf0 [dvb_core]
>  [<d1942f19>] dvb_dmxdev_filter_start+0x269/0x380 [dvb_core]
>  [<d1942341>] ? dvb_dmxdev_add_pid+0x51/0xa0 [dvb_core]
>  [<d19432f4>] dvb_demux_do_ioctl+0x164/0x550 [dvb_core]
>  [<c10aca65>] ? path_put+0x15/0x20
>  [<c10b0584>] ? do_last+0x1e4/0x7d0
>  [<c117d497>] ? _copy_from_user+0x37/0x60
>  [<d194131f>] dvb_usercopy+0xef/0x1a0 [dvb_core]
>  [<c10b0f50>] ? do_filp_open+0x30/0x80
>  [<d1941d90>] ? dvb_dmxdev_start_feed+0xf0/0xf0 [dvb_core]
>  [<d1941da2>] dvb_demux_ioctl+0x12/0x20 [dvb_core]
>  [<d1943190>] ? dvb_demux_release+0x160/0x160 [dvb_core]
>  [<c10b2801>] vfs_ioctl+0x31/0x50
>  [<c10b2ada>] do_vfs_ioctl+0xaa/0x500
>  [<c10acdb3>] ? getname_flags+0xc3/0x130
>  [<c10a27c8>] ? fd_install+0x48/0x60
>  [<c10a294b>] ? do_sys_open+0x16b/0x1b0
>  [<c1020000>] ? handle_vm86_fault+0x160/0x910
>  [<c10b2f69>] sys_ioctl+0x39/0x70
>  [<c13679d0>] sysenter_do_call+0x12/0x26
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> Normal per-cpu:
> CPU    0: hi:   90, btch:  15 usd:   0
> active_anon:806 inactive_anon:10372 isolated_anon:0
>  active_file:21713 inactive_file:22283 isolated_file:0
>  unevictable:0 dirty:45 writeback:0 unstable:0
>  free:994 slab_reclaimable:2584 slab_unreclaimable:1960
>  mapped:1002 shmem:12 pagetables:409 bounce:0
> DMA free:1100kB min:124kB low:152kB high:184kB active_anon:52kB
> inactive_anon:72kB active_file:6008kB inactive_file:8136kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15808kB
> mlocked:0kB dirty:4kB writeback:0kB mapped:12kB shmem:0kB
> slab_reclaimable:436kB slab_unreclaimable:16kB kernel_stack:24kB
> pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> all_unreclaimable? no
> lowmem_reserve[]: 0 237 237
> Normal free:2756kB min:1904kB low:2380kB high:2856kB active_anon:3172kB
> inactive_anon:41416kB active_file:80844kB inactive_file:80996kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:242824kB
> mlocked:0kB dirty:176kB writeback:0kB mapped:3996kB shmem:48kB
> slab_reclaimable:9900kB slab_unreclaimable:7824kB kernel_stack:1904kB
> pagetables:1636kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0
> DMA: 277*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
> 0*2048kB 0*4096kB = 1108kB
> Normal: 233*4kB 202*8kB 5*16kB 0*32kB 2*64kB 0*128kB 0*256kB 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 2756kB
> 44485 total pagecache pages
> 476 pages in swap cache
> Swap cache stats: add 1563, delete 1087, find 1624/1719
> Free swap  = 485904kB
> Total swap = 488340kB
> 65264 pages RAM
> 1946 pages reserved
> 49870 pages shared
> 36872 pages non-shared
> unable to allocate 60160 bytes for transfer buffer 0
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Andy,
I'm getting the same problem on a totally different system.
I'm using a set-top-box powered by a Broadcom mipsel SoC with 512 MB RAM.
When I use the Mediaplayer of the box for a few hours (which takes
almost all the RAM available in the system) and then switch back to DTT
TV, sometimes I get this crash:

usbtunerhelper: page allocation failure: order:4, mode:0x10d0
Call Trace:
[<8055f4e0>] dump_stack+0x8/0x34
[<8008ad00>] warn_alloc_failed+0xc4/0x144
[<8008b8c8>] __alloc_pages_nodemask+0x40c/0x678
[<8008bc30>] __get_free_pages+0x18/0x80
[<8001101c>] mips_dma_alloc_coherent+0x5c/0x114
[<e157ee9c>] em28xx_init_isoc+0x10c/0x3e4 [em28xx]
[<e159a71c>] em28xx_start_feed+0x12c/0x164 [em28xx_dvb]
[<803e4304>] dmx_ts_feed_start_filtering+0x5c/0x134
[<803e0664>] dvb_dmxdev_start_feed+0xd4/0x158
[<803e2c94>] dvb_demux_do_ioctl+0x578/0x654
[<803dfe00>] dvb_usercopy+0x88/0x204
[<800d6ef4>] do_vfs_ioctl+0xa0/0x6c0
[<800d7558>] sys_ioctl+0x44/0xa8
[<8000ecfc>] stack_done+0x20/0x40

Mem-Info:
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
active_anon:17666 inactive_anon:119 isolated_anon:0
 active_file:22491 inactive_file:21039 isolated_file:0
 unevictable:0 dirty:2 writeback:0 unstable:0
 free:3228 slab_reclaimable:1644 slab_unreclaimable:1955
 mapped:1415 shmem:169 pagetables:143 bounce:0
Normal free:12912kB min:2876kB low:3592kB high:4312kB
active_anon:70664kB inactive_anon:476kB active_file:89964kB
inactive_file:84156kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:518144kB mlocked:0kB dirty:8kB writeback:0kB
mapped:5660kB shmem:676kB slab_reclaimable:6576kB
slab_unreclaimable:7820kB kernel_stack:704kB pagetables:572kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 1898*4kB 481*8kB 70*16kB 9*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 12912kB
43708 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
131072 pages RAM
58155 pages reserved
13909 pages shared
56534 pages non-shared
unable to allocate 48128 bytes for transfer buffer 0

I'm trying to reproduce the problem with another em28xx-dvb device to
see if it is not restricted to the PCTV 290e. Before the PCTV 290e, I
was using a different device with a driver based on the dvb-usb
framework, and I never observed similar crashes.

Regards,
Gianluca
