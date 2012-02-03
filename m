Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab2BCSr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 13:47:56 -0500
Received: by eaah12 with SMTP id h12so1546231eaa.19
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2012 10:47:54 -0800 (PST)
Message-ID: <4F2C2BD6.1010007@gmail.com>
Date: Fri, 03 Feb 2012 19:47:50 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org> <4F2ADDCB.4060200@gmail.com> <4F2AEA81.90506@ukfsn.org> <4F2B184F.4030709@gmail.com> <4F2BBF3E.1030809@ukfsn.org>
In-Reply-To: <4F2BBF3E.1030809@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 03/02/2012 12:04, Andy Furniss ha scritto:
> Gianluca Gennari wrote:
> 
>>> What kernel are you using?
>>>
>>> I see someone else had problems with>  3.0, I've got a 3.08 built on
>>> this box, I'll try it out when I get a chance to reboot, though it took
>>> a couple of days to show on my current kernel.
>>>
>>> Andy.
>>>
>>
>> Hi Andy,
>> I'm running 3.1.0 but I back-ported a few patches from 3.2.0 to update
>> the PCTV 290e driver to the latest version.
>> In the past months I run 2.6.18/2.6.31/3.0.3 before buying the PCTV
>> 290e, but I never had this problem with the old dvb-usb stick.
> 
> Hi,
> 
> I tried my 3.08 but changed back as I was getting corrupted HD streams.
> 
> Maybe because the config for that kernel was no SMP and no preemption.
> 
> I did do lots of cat /proc/buddyinfo and echo m > /proc/sysrq-trigger
> and it looks like having lots of files open is my problem - but I didn't
> run long enough to provoke a fail.
> 
> It seems even if the above commands show no continuous DMA above 16k
> when you actually try and use it the kernel defrags so it works and the
> output will then show larger chunks available for a while.
> 
> When I had 2xPCI running it was mainly on 2.6.26 and I was also using
> legacy IDE - I wonder if that behaved differently with 00s of open files
> - or maybe it's just that PCIs (remaining one is cx88) just don't ask
> for big 64k DMA buffers.
> 
> 

Hi,
I was able to reproduce the crash with the Terratec Hybrid card after
about 1 day of use (switching between the mediaplayer and the DVB-T tuner):

usbtunerhelper: page allocation failure: order:4, mode:0x10d0
Call Trace:
[<80550be0>] dump_stack+0x8/0x34
[<8008aca0>] warn_alloc_failed+0xc4/0x144
[<8008b868>] __alloc_pages_nodemask+0x40c/0x678
[<8008bbd0>] __get_free_pages+0x18/0x80
[<8001101c>] mips_dma_alloc_coherent+0x5c/0x114
[<e16a7e9c>] em28xx_init_isoc+0x10c/0x3e4 [em28xx]
[<e174b71c>] em28xx_start_feed+0x12c/0x164 [em28xx_dvb]
[<803ce924>] dmx_ts_feed_start_filtering+0x5c/0x134
[<803cac84>] dvb_dmxdev_start_feed+0xd4/0x158
[<803cd2b4>] dvb_demux_do_ioctl+0x578/0x654
[<803ca420>] dvb_usercopy+0x88/0x204
[<800d6e94>] do_vfs_ioctl+0xa0/0x6c0
[<800d74f8>] sys_ioctl+0x44/0xa8
[<8000ecfc>] stack_done+0x20/0x40

Mem-Info:
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
active_anon:16570 inactive_anon:27 isolated_anon:0
 active_file:21560 inactive_file:21546 isolated_file:0
 unevictable:0 dirty:2 writeback:0 unstable:0
 free:3996 slab_reclaimable:2042 slab_unreclaimable:2124
 mapped:2392 shmem:31 pagetables:126 bounce:0
Normal free:15984kB min:2876kB low:3592kB high:4312kB
active_anon:66280kB inactive_anon:108kB active_file:86240kB
inactive_file:86184kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:518144kB mlocked:0kB dirty:8kB writeback:0kB
mapped:9568kB shmem:124kB slab_reclaimable:8168kB
slab_unreclaimable:8496kB kernel_stack:712kB pagetables:504kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 2556*4kB 540*8kB 80*16kB 3*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 15984kB
43141 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
131072 pages RAM
58145 pages reserved
10852 pages shared
59573 pages non-shared
unable to allocate 36096 bytes for transfer buffer 0

free:
             total         used         free       shared      buffers
Mem:        291708       274656        17052            0         7592
-/+ buffers:             267064        24644
Swap:            0            0            0

(the box has 512 MB but about 220 MB are reserved for the framebuffer)

So there is no doubt it's a generic problem (as Devin already pointed
out) and not restricted to the PCTV 290e.

I will now try to reproduce the issue with a dvb-usb driver.

Regards,
Gianluca
