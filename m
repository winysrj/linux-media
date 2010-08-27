Return-path: <mchehab@pedra>
Received: from sh.osrg.net ([192.16.179.4]:45680 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab0H0FBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 01:01:36 -0400
Date: Fri, 27 Aug 2010 14:00:17 +0900
To: u.kleine-koenig@pengutronix.de
Cc: fujita.tomonori@lab.ntt.co.jp, g.liakhovetski@gmx.de,
	mitov@issp.bas.bg, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
	philippe.retornaz@epfl.ch, gregkh@suse.de, jkrzyszt@tis.icnet.pl
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100827044142.GB31863@pengutronix.de>
References: <20100826095311.GA13051@pengutronix.de>
	<20100826185938A.fujita.tomonori@lab.ntt.co.jp>
	<20100827044142.GB31863@pengutronix.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Message-Id: <20100827140005Y.fujita.tomonori@lab.ntt.co.jp>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 27 Aug 2010 06:41:42 +0200
Uwe Kleine-K$(D+S(Bnig <u.kleine-koenig@pengutronix.de> wrote:

> Hello,
> 
> On Thu, Aug 26, 2010 at 07:00:24PM +0900, FUJITA Tomonori wrote:
> > On Thu, 26 Aug 2010 11:53:11 +0200
> > Uwe Kleine-K$(D+S(Bnig <u.kleine-koenig@pengutronix.de> wrote:
> > 
> > > > > We have currently a number of boards broken in the mainline. They must be 
> > > > > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > > > > as I suggested earlier, we need either this or my patch series
> > > > > 
> > > > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > > > > 
> > > > > for 2.6.36.
> > > > 
> > > > Why can't you revert a commit that causes the regression?
> > > > 
> > > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > > responsible for the regression. And the patchset even exnteds the
> > > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > > device. It's not for the API that reserves coherent memory that can be
> > > > used for any device for a single device.
> > > The patch that made the problem obvious for ARM is
> > > 309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
> > > So this went in before v2.6.36-rc1.  One of the "architectures which
> > > similar restrictions" is x86 BTW.
> > > 
> > > And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
> > > addresses a hardware restriction.
> > 
> > How these drivers were able to work without hitting the hardware restriction?
> In my case the machine in question is an ARMv5, the hardware restriction
> is on ARMv6+ only.  You could argue that so the breaking patch for arm
> should only break ARMv6, but I don't think this is sensible from a
> maintainers POV.  We need an API that works independant of the machine
> that runs the code.

Agreed. But insisting that the DMA API needs to be extended wrongly
after rc2 to fix the regression is not sensible too. The related DMA
API wasn't changed in 2.6.36-rc1. The API isn't responsible for the
regression at all.
