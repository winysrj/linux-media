Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDUSKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 14:10:52 -0400
Date: Tue, 21 Apr 2009 15:10:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Uri Shkolnik <urishk@yahoo.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel
 module
Message-ID: <20090421151045.49724d59@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0904211046580.3753@shell2.speakeasy.net>
References: <142898.44509.qm@web110807.mail.gq1.yahoo.com>
	<Pine.LNX.4.58.0904211046580.3753@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009 10:54:40 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Tue, 21 Apr 2009, Uri Shkolnik wrote:
> > --- On Tue, 4/21/09, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > From: Trent Piepho <xyzzy@speakeasy.org>
> > > Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel module
> > > To: "Uri Shkolnik" <urishk@yahoo.com>
> > > Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>, "LinuxML" <linux-media@vger.kernel.org>
> > > Date: Tuesday, April 21, 2009, 6:17 AM
> > > On Mon, 20 Apr 2009, Uri Shkolnik
> > > wrote:
> > > >
> > > > "better to have the BUS configurable, e. g. just
> > > because you have USB interface, it doesn't mean that you
> > > want siano for USB, instead of using SDIO."
> > > >
> > > > Since the module is using dynamic registration, I
> > > don't find it a problem.
> > > > When the system has both USB and SDIO buses, both USB
> > > and SDIO interface driver will be compiled and linked to the
> > > module. When a Siano based device (or multiple Siano
> > > devices) will be connected, they will be register internally
> > > in the core and activated. Any combination is allow
> > > (multiple SDIO, multiple USB and any mix).
> > >
> > > This is not the way linux drivers normally work. 
> > > Usually there are
> > > multiple modules so that only the ones that need to be
> > > loaded are loaded.
> > > It sounds like you are designing this to be custom compiled
> > > for each
> > > system, but that's not usually they way things work.
> >
> > I think I didn't express myself clearly.
> >
> > Lets say that someone build a kernel X.
> > This kernel has (from all buses) only USB. The Siano module will build with USB interface driver at this system.
> >
> > If the system includes SDIO and OMAP SPI/SPP, the module build will discard the USB interface driver, but the SDIO and the OMAP SPI will be built.

The patch you've provided just merge everything. If you're proposing a newer
model, you should send a patchset with the complete Kbuild refactor. For now,
it is better to postpone this patch until we merge non-kbuild changes.

> Can you name another driver that works this way?  It is considered better
> to build a new module for a different interface.  That way one can decide
> at run time if the interface is needed or not and only load the module if
> needed.  If everything is built into one module then one must decide at
> compile time what interfaces to support.  But it is often the case that
> kernels are compiled on different systems than run them.

This model also sounds different to me from what I've seen so far.

Cheers,
Mauro
