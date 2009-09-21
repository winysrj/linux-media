Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZIUUJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 16:09:40 -0400
Date: Mon, 21 Sep 2009 21:09:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: What's inside the pxa tree for this merge window
Message-ID: <20090921200923.GF30821@n2100.arm.linux.org.uk>
References: <f17812d70909100446h17a1903fy74941945dbfc6943@mail.gmail.com> <1253256227.4407.7.camel@pc-matejk> <20090918074551.GA26058@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0909212111490.17328@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909212111490.17328@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 09:19:46PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 18 Sep 2009, Russell King - ARM Linux wrote:
> 
> > On Fri, Sep 18, 2009 at 08:43:47AM +0200, Matej Kenda wrote:
> > > On Thu, 2009-09-10 at 19:46 +0800, Eric Miao wrote:
> > > > Here's the preview of request-pull result, please let me know if there
> > > > is anything missed, thanks.
> > > > 
> > > > URL: git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
> > > > 
> > > > 
> > > > Matej Kenda (2):
> > > >       [ARM] pxa: add support for the IskraTel XCEP board
> > > >       [ARM] pxa: add defconfig for IskraTel XCEP board
> > > 
> > > Eric, what is the current status of this request? Do I need to repost
> > > the patches to included into 2.6.32?
> > > 
> > > Russell discarded them from his patch system, because they are on your
> > > list.
> > 
> > I discarded them _because_ Eric handled them, which is what I said in the
> > comments when I discarded them.
> 
> Ok, I did do my best to get patches in the right order in the mainline, 
> but it all failed. AFAICS, v4l and sh are already in the mainline with a 
> _wrongly_ resolved mefge conflict, which, most likely, breaks the 
> sh_mobile_ceu_camera.c driver, and the three PXA platforms, patches for 
> which should have been applied before both those trees and still haven't 
> been applied are broken until the patches do get in and the later those 
> patches get applied the longer the interval with the broken for them 
> bisection is going to be.

Meanwhile I have to consider that we have several bug fixes outstanding,
and since I can't send Linus a pull request every day (max once a week)
I have to be very careful about when I send stuff.

So I only get _two_ opportunities during a merge window to send a pull
request.

I'm going to wait until tomorrow before sending my final pull for this
window, which is the penultimate day before the window closes.

Don't blame me for these delays - it's not my choice to impose such
delays.  I'd really like to fix those broken platforms right now.  I
just can't do so without causing additional delays for other issues.
Blame Linus for imposing the "max one pull a week" rule on me.
