Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab0H0GOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 02:14:22 -0400
Date: Fri, 27 Aug 2010 08:13:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: g.liakhovetski@gmx.de, mitov@issp.bas.bg,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
	linux-sh@vger.kernel.org, philippe.retornaz@epfl.ch,
	gregkh@suse.de, jkrzyszt@tis.icnet.pl
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Message-ID: <20100827061355.GA938@pengutronix.de>
References: <20100827044142.GB31863@pengutronix.de> <20100827140005Y.fujita.tomonori@lab.ntt.co.jp> <20100827051907.GA17521@pengutronix.de> <20100827145712Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100827145712Z.fujita.tomonori@lab.ntt.co.jp>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On Fri, Aug 27, 2010 at 02:57:59PM +0900, FUJITA Tomonori wrote:
> On Fri, 27 Aug 2010 07:19:07 +0200
> Uwe Kleine-K�nig <u.kleine-koenig@pengutronix.de> wrote:
> 
> > Hey,
> > 
> > On Fri, Aug 27, 2010 at 02:00:17PM +0900, FUJITA Tomonori wrote:
> > > On Fri, 27 Aug 2010 06:41:42 +0200
> > > Uwe Kleine-K�nig <u.kleine-koenig@pengutronix.de> wrote:
> > > > On Thu, Aug 26, 2010 at 07:00:24PM +0900, FUJITA Tomonori wrote:
> > > > > On Thu, 26 Aug 2010 11:53:11 +0200
> > > > > Uwe Kleine-K�nig <u.kleine-koenig@pengutronix.de> wrote:
> > > > > 
> > > > > > > > We have currently a number of boards broken in the mainline. They must be 
> > > > > > > > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > > > > > > > as I suggested earlier, we need either this or my patch series
> > > > > > > > 
> > > > > > > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > > > > > > > 
> > > > > > > > for 2.6.36.
> > > > > > > 
> > > > > > > Why can't you revert a commit that causes the regression?
> > > > > > > 
> > > > > > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > > > > > responsible for the regression. And the patchset even exnteds the
> > > > > > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > > > > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > > > > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > > > > > device. It's not for the API that reserves coherent memory that can be
> > > > > > > used for any device for a single device.
> > > > > > The patch that made the problem obvious for ARM is
> > > > > > 309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
> > > > > > So this went in before v2.6.36-rc1.  One of the "architectures which
> > > > > > similar restrictions" is x86 BTW.
> > > > > > 
> > > > > > And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
> > > > > > addresses a hardware restriction.
> > > > > 
> > > > > How these drivers were able to work without hitting the hardware restriction?
> > > > In my case the machine in question is an ARMv5, the hardware restriction
> > > > is on ARMv6+ only.  You could argue that so the breaking patch for arm
> > > > should only break ARMv6, but I don't think this is sensible from a
> > > > maintainers POV.  We need an API that works independant of the machine
> > > > that runs the code.
> > > 
> > > Agreed. But insisting that the DMA API needs to be extended wrongly
> > > after rc2 to fix the regression is not sensible too. The related DMA
> > > API wasn't changed in 2.6.36-rc1. The API isn't responsible for the
> > > regression at all.
> > I think this isn't about "responsiblity".  Someone in arm-land found
> > that the way dma memory allocation worked for some time doesn't work
> > anymore on new generation chips.  As pointing out this problem was
> > expected to find some matches it was merged in the merge window.  One
> > such match is the current usage of the DMA API that doesn't currently
> > offer a way to do it right, so it needs a patch, no?
> 
> No, I don't think so. We are talking about a regression, right?
> 
> On new generation chips, something often doesn't work (which have
> worked on old chips for some time). It's not a regresiion. I don't
> think that it's sensible to make large change (especially after rc1)
> to fix such issue. If you say that the DMA API doesn't work on new
> chips and proposes a patch for the next merge window, it's sensible, I
> suppose.
> 
> Btw, the patch isn't a fix for the DMA API. It tries to extend the DMA
> API (and IMO in the wrong way). In addition, the patch might break the
> current code. I really don't think that applying such patch after rc1
> is senseble.
So you suggest to revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 or at
least restrict it to ARMv6+ and fix the problem during the next merge
window?  Russell?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-K�nig            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
