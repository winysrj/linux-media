Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57132 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZEPSuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2009 14:50:24 -0400
Date: Sat, 16 May 2009 19:50:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Agustin <gatoguan-os@yahoo.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] dma: fix ipu_idmac.c to not discard the last queued
	buffer
Message-ID: <20090516185009.GA26519@n2100.arm.linux.org.uk>
References: <155119.7889.qm@web32103.mail.mud.yahoo.com> <Pine.LNX.4.64.0905071750050.9460@axis700.grange> <951499.48393.qm@web32102.mail.mud.yahoo.com> <Pine.LNX.4.64.0905120908220.5087@axis700.grange> <155082.98228.qm@web32102.mail.mud.yahoo.com> <e9c3a7c20905121131q3c007e9p56c7b754ecd1466f@mail.gmail.com> <20090516164620.GG20810@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0905162018590.12170@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905162018590.12170@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 16, 2009 at 08:22:18PM +0200, Guennadi Liakhovetski wrote:
> On Sat, 16 May 2009, Russell King - ARM Linux wrote:
> 
> > On Tue, May 12, 2009 at 11:31:14AM -0700, Dan Williams wrote:
> > > On Tue, May 12, 2009 at 5:14 AM, Agustin <gatoguan-os@yahoo.com> wrote:
> > > >
> > > > On Tue, 12 May 2009, Guennadi Liakhovetski wrote:
> > > >
> > > >>
> > > >> This also fixes the case of a single queued buffer, for example, when taking a
> > > >> single frame snapshot with the mx3_camera driver.
> > > >>
> > > >> Reported-by: Agustin
> > > >> Signed-off-by: Guennadi Liakhovetski
> > > >
> > > > Signed-off-by: Agustin Ferrin Pozuelo
> > > 
> > > Applied.
> > 
> > Hopefully with real tags (iow, with email addresses) rather than what's
> > shown above (which is unacceptable.)
> 
> Sure, Dan has done it perfectly:
> 
> http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=commitdiff;h=ad567ffb32f067b30606071eb568cf637fe42185
> 
> as it also was in the patch submission
> 
> http://marc.info/?l=linux-arm-kernel&m=124212146702853&w=2
> 
> and _not_ as it was in the mail that you quote.

Looks like Agustin's mail client is removing the <...> parts from those
tags - look at the next message in the thread.
