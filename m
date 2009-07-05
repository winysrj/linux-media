Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbZGEPUC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2009 11:20:02 -0400
Date: Sun, 5 Jul 2009 08:19:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
In-Reply-To: <20090705150134.GB8326@linux-sh.org>
Message-ID: <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org> <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain> <20090705150134.GB8326@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 6 Jul 2009, Paul Mundt wrote:
> >
> > Why not "lock" as well?
> 
> I had that initially, but matroxfb will break if we do that, and
> presently nothing cares about trying to take ->lock that early on.

I really would rather have consistency than some odd rules like that.

In particular - if matroxfb is different and needs its own lock 
initialization because it doesn't use the common allocation routine, then 
please make _that_ consistent too. Rather than have it special-case just 
one lock that it needs to initialize separately, make it clear that since 
it does its own allocations it needs to initialize _everything_ 
separately.

Otherwise anybody grepping for things will always be confused, since 
depending on random factors they'll notice the initializations in one 
place or the other, and then do the wrong thing - exactly like mm_lock was 
not correctly initialized this time around.

In other words: it's actually _better_ to make the matroxfb pain _more_ 
obvious rather than less.

And maybe we can deprecate the driver, throw it out entirely, or have 
somebody actually fix it?

			Linus
