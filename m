Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45772 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZGEPBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 11:01:43 -0400
Date: Mon, 6 Jul 2009 00:01:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add mutex for fb_mmap locking"
Message-ID: <20090705150134.GB8326@linux-sh.org>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org> <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 05, 2009 at 07:56:56AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 5 Jul 2009, Paul Mundt wrote:
> >  			break;
> >  	fb_info->node = i;
> >  	mutex_init(&fb_info->lock);
> > -	mutex_init(&fb_info->mm_lock);
> 
> Why not "lock" as well?
> 
I had that initially, but matroxfb will break if we do that, and
presently nothing cares about trying to take ->lock that early on.

->mm_lock was a special case as the lock/unlock pairs were sprinkled
around well before initialization, while in the ->lock case all of the
lock/unlock pairs are handled internally by the fbmem code (at least a
quick grep does not show any drivers using it on their own).
