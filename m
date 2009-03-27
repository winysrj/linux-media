Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53885 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZC0IZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 04:25:59 -0400
Date: Fri, 27 Mar 2009 08:25:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Dave Strauss <Dave.Strauss@zoran.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090327082525.GB20557@n2100.arm.linux.org.uk>
References: <49C89F00.1020402@gmail.com> <49CBF437.7030603@zoran.com> <20090326220713.GC32555@n2100.arm.linux.org.uk> <200903270833.27864.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903270833.27864.hs4233@mail.mn-solutions.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 08:33:27AM +0100, Holger Schurig wrote:
> > Sparse is another tool which can be used while building the
> > kernel to increase the build time checking, but it can be
> > quite noisy, so please only look at stuff which pops up for
> > your specific area.
> 
> To get rid of some of the warnings, you can analyze only the 
> parts of the source that you're working on. You just need sparse 
> in your PATH and issue:
> 
> $ make SUBDIRS=arch/arm/mach-mx2 C=2
> 
> 
> Unfortunately, the arm tree is a bit different to mainline linux, 
> because
> 
> $ make SUBDIRS=arch/arm C=2
> arch/arm/Makefile:31: *** Recursive variable `KBUILD_CFLAGS' 
> references itself (eventually).  Stop.
> make: *** [_module_arch/arm] Error 2

Line 31 is the KBUILD_CFLAGS line of:

ifeq ($(CONFIG_FRAME_POINTER),y)
KBUILD_CFLAGS   +=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
endif

which is _not_ a recursive definition.  Either your make is broken or
you have local changes to that line.
