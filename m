Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:43091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752185Ab0HNRcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Aug 2010 13:32:53 -0400
Date: Sat, 14 Aug 2010 19:33:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Marin Mitov <mitov@issp.bas.bg>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera
 interface
In-Reply-To: <201008132113.10147.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1008141916170.16329@axis700.grange>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1008131016100.31714@axis700.grange> <201008131211.53101.mitov@issp.bas.bg>
 <201008132113.10147.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 13 Aug 2010, Janusz Krzysztofik wrote:

> Friday 13 August 2010 11:11:52 Marin Mitov napisał(a):
> > On Friday, August 13, 2010 11:52:41 am Guennadi Liakhovetski wrote:
> > > On Fri, 13 Aug 2010, Janusz Krzysztofik wrote:
> > > > Thursday 12 August 2010 23:38:17 Guennadi Liakhovetski napisał(a):
> > > > > 1. We've discussed this dynamic switching a bit on IRC today. The
> > > > > first reaction was - you probably should concentrate on getting the
> > > > > contiguous version to work reliably. I.e., to reserve the memory in
> > > > > the board init code similar, how other contig users currently do it.
> > > >
> > > > I already tried before to find out how I could allocate memory at init
> > > > without reinventing a new videobuf-dma-contig implementation. Since in
> > > > the Documentation/video4linux/videobuf I've read that videobuf does not
> > > > currently play well with drivers that play tricks by allocating DMA
> > > > space at system boot time, I've implemented the alternate sg path.
> > > >
> > > > If it's not quite true what the documentation says and you can give me
> > > > a hint how this could be done, I might try again.
> > >
> > > For an example look at
> > > arch/arm/mach-mx3/mach-pcm037.c::pcm037_camera_alloc_dma().
> 
> Yes, this is the solution that suffers from the already discussed limitation 
> of not being able to remap a memory with different attributes, which affects 
> OMAP1 as well.
> 
> > For preallocating dma-coherent memory for device personal use during device
> > probe() time (when the memory is less fragmented compared to open() time)
> > see also dt3155_alloc_coherent/dt3155_free_coherent in
> > drivers/staging/dt3155v4l/dt3155vfl.c (for x86 arch, I do not know if it
> > works for arm arch)
> 
> With this workaround applied, I get much better results, thank you Marin. 
> However, it seems not bullet proof, since mmap still happens to fail for a 
> reason not quite clear to me:

What exactly does this mean - happens to fail - you mean starting and 
stopping mplayer several times? Can you verify, that you're not leaking 
memory? That you're freeing all allocated DMA memory again? Are you using 
the same parameters to mplayer, right?

As for the work-around - can you not do this in your board late-initcall 
function?

Not sure whether and how one can get this in the mainline. This is in 
principle the same, as in the above dma_declare_coherent_memory() example, 
only open-coded without the ioremap. Maybe we can add a suitable function 
to the dma-alloc API...

Thanks
Guennadi

> 
> [ 6067.220000] omap1-camera omap1-camera.0: OMAP1 Camera driver attached to camera 0
> [ 6067.650000] omap1-camera omap1-camera.0: omap1_cam_try_fmt: format 32315659 not found
> [ 6067.680000] omap1-camera omap1-camera.0: omap1_cam_try_fmt: format 32315559 not found
> [ 6068.480000] mplayer: page allocation failure. order:6, mode:0xd0
> [ 6068.500000] Backtrace:
> [ 6068.520000] [<c0028950>] (dump_backtrace+0x0/0x110) from [<c0028ea8>] (dump_stack+0x18/0x1c)
> [ 6068.560000]  r6:00000006 r5:000000d0 r4:c1bcf000
> [ 6068.590000] [<c0028e90>] (dump_stack+0x0/0x1c) from [<c0074e24>] (__alloc_pages_nodemask+0x504/0x560)
> [ 6068.620000] [<c0074920>] (__alloc_pages_nodemask+0x0/0x560) from [<c002ae14>] (__dma_alloc+0x108/0x354)
> [ 6068.660000] [<c002ad0c>] (__dma_alloc+0x0/0x354) from [<c002b0ec>] (dma_alloc_coherent+0x58/0x64)
> [ 6068.700000] [<c002b094>] (dma_alloc_coherent+0x0/0x64) from [<bf000a44>] (__videobuf_mmap_mapper+0x10c/0x374 [videobuf_dma_contig])
> [ 6068.740000]  r7:c16934c0 r6:00000000 r5:c171baec r4:00000000
> [ 6068.770000] [<bf000938>] (__videobuf_mmap_mapper+0x0/0x374 [videobuf_dma_contig]) from [<c01f9a78>] (videobuf_mmap_mapper+0xc4/0x108)
> [ 6068.810000] [<c01f99b4>] (videobuf_mmap_mapper+0x0/0x108) from [<c01fc1ac>] (soc_camera_mmap+0x80/0x140)
> [ 6068.840000]  r5:c1a3b4e0 r4:00000000
> [ 6068.870000] [<c01fc12c>] (soc_camera_mmap+0x0/0x140) from [<c01eeba8>] (v4l2_mmap+0x4c/0x5c)
> [ 6068.900000]  r7:c145c000 r6:000000ff r5:c16934c0 r4:00000000
> [ 6068.930000] [<c01eeb5c>] (v4l2_mmap+0x0/0x5c) from [<c0085de4>] (mmap_region+0x238/0x458)
> [ 6068.970000] [<c0085bac>] (mmap_region+0x0/0x458) from [<c00862c0>] (do_mmap_pgoff+0x2bc/0x320)
> [ 6069.000000] [<c0086004>] (do_mmap_pgoff+0x0/0x320) from [<c00863c0>] (sys_mmap_pgoff+0x9c/0xc8)
> [ 6069.040000] [<c0086324>] (sys_mmap_pgoff+0x0/0xc8) from [<c0024f00>] (ret_fast_syscall+0x0/0x2c)
> [ 6069.200000] Mem-info:
> [ 6069.220000] Normal per-cpu:
> [ 6069.240000] CPU    0: hi:    0, btch:   1 usd:   0
> [ 6069.260000] active_anon:676 inactive_anon:682 isolated_anon:0
> [ 6069.260000]  active_file:422 inactive_file:2348 isolated_file:0
> [ 6069.260000]  unevictable:177 dirty:0 writeback:0 unstable:0
> [ 6069.260000]  free:1166 slab_reclaimable:0 slab_unreclaimable:0
> [ 6069.260000]  mapped:1120 shmem:0 pagetables:121 bounce:0
> [ 6069.350000] Normal free:4664kB min:720kB low:900kB high:1080kB active_anon:2704kB inactive_anon:2728kB active_file:1688kB inactive_file:9392kB unevictable:708kB isolated(anon):0kB isolated(file):0kB present:32512kB mlocked:0kB 
> dirty:0kB writeback:0kB mapped:4480kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:552kB pagetables:484kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [ 6069.460000] lowmem_reserve[]: 0 0
> [ 6069.470000] Normal: 6*4kB 20*8kB 14*16kB 29*32kB 26*64kB 9*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4664kB
> [ 6069.530000] 2960 total pagecache pages
> [ 6069.550000] 8192 pages of RAM
> [ 6069.560000] 1322 free pages
> [ 6069.580000] 1114 reserved pages
> [ 6069.590000] 750 slab pages
> [ 6069.610000] 2476 pages shared
> [ 6069.630000] 0 pages swap cached
> [ 6069.640000] omap1-camera omap1-camera.0: dma_alloc_coherent size 204800 failed
> [ 6069.680000] omap1-camera omap1-camera.0: OMAP1 Camera driver detached from camera 0
> 
> Maybe I should preallocate a few more pages than will be actually used by the 
> driver?
> 
> Anyways, I'm not sure if this piece of code could be accepted for inclusion 
> into the mainline tree, perhaps only under drivers/staging.
> 
> Thanks,
> Janusz
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
