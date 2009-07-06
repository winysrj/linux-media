Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:13988 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbZGFBNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 21:13:24 -0400
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@linux-mips.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
In-Reply-To: <20090705181808.93be24a9.krzysztof.h1@poczta.fm>
References: <1246785112.14240.34.camel@falcon>
	 <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain>
	 <20090705145203.GA8326@linux-sh.org>
	 <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain>
	 <20090705150134.GB8326@linux-sh.org>
	 <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain>
	 <20090705152557.GA10588@linux-sh.org>
	 <20090705181808.93be24a9.krzysztof.h1@poczta.fm>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 09:13:11 +0800
Message-Id: <1246842791.29532.2.camel@falcon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, 2009-07-05 at 18:18 +0200, Krzysztof Helt wrote:
> On Mon, 6 Jul 2009 00:25:57 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > On Sun, Jul 05, 2009 at 08:19:40AM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 6 Jul 2009, Paul Mundt wrote:
> > > > >
> > > > > Why not "lock" as well?
> > > > 
> > > > I had that initially, but matroxfb will break if we do that, and
> > > > presently nothing cares about trying to take ->lock that early on.
> > > 
> > > I really would rather have consistency than some odd rules like that.
> > > 
> > > In particular - if matroxfb is different and needs its own lock 
> > > initialization because it doesn't use the common allocation routine, then 
> > > please make _that_ consistent too. Rather than have it special-case just 
> > > one lock that it needs to initialize separately, make it clear that since 
> > > it does its own allocations it needs to initialize _everything_ 
> > > separately.
> > > 
> > Ok, here is an updated version with an updated matroxfb and the sm501fb
> > change reverted.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > 
> > ---
> > 
> 
> This is incorrect way to fix this as some drivers do not use the framebuffer_alloc() 
> at all. They use global (for a file) fb_info structure. I have done some cleanups to
> the fbdev layer before the 2.6.31 and there should no drivers which uses kmalloc or
> kzalloc to allocate the fb_info (your patch would break these drivers too).
> 
> A root of the whole mm_lock issue is that the fb_mmap() BKL protected two fb_info
> fields which were never protected when set. I changed this by add the mm_lock 
> around these fields but only in drivers which modified this fields AFTER call
> to the register_framebuffer(). Some drivers set these fields using the same
> function before and after the register_framebuffer(). I strongly believe that
> setting these fields before the register_framebuffer() is wrong or redundant for
> these drivers. See my fix for the sisfb driver below. 
> 
> I have tested the patch below. Wu Zhangjin, can you also confirm that this 
> works for you (without your patch)?
> 

This patch also works for me, thanks!

Regards,
Wu Zhangjin

> I will look into the matroxfb and sm501fb drivers now. The same problem is
> already fixed for the mx3fb driver and the patch is sent to Andrew Morton.
> 
> Regards,
> Krzysztof
> 
> 
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> Remove redundant call to the sisfb_get_fix() before sis frambuffer is registered.
> 
> This fixes a problem with uninitialized the fb_info->mm_lock mutex.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
> 
> diff -urp linux-ref/drivers/video/sis/sis_main.c linux-next/drivers/video/sis/sis_main.c
> --- linux-ref/drivers/video/sis/sis_main.c	2009-07-01 18:07:05.000000000 +0200
> +++ linux-next/drivers/video/sis/sis_main.c	2009-07-05 17:20:33.000000000 +0200
> @@ -6367,7 +6367,6 @@ error_3:	vfree(ivideo->bios_abase);
>  		sis_fb_info->fix = ivideo->sisfb_fix;
>  		sis_fb_info->screen_base = ivideo->video_vbase + ivideo->video_offset;
>  		sis_fb_info->fbops = &sisfb_ops;
> -		sisfb_get_fix(&sis_fb_info->fix, -1, sis_fb_info);
>  		sis_fb_info->pseudo_palette = ivideo->pseudo_palette;
>  
>  		fb_alloc_cmap(&sis_fb_info->cmap, 256 , 0);
> 
> 
> 
> ----------------------------------------------------------------------
> Najlepsze OC i AC tylko w Ergo Hestia
> http://link.interia.pl/f222
> 

