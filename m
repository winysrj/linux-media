Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752111AbZIUTTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 15:19:51 -0400
Date: Mon, 21 Sep 2009 21:19:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: What's inside the pxa tree for this merge window
In-Reply-To: <20090918074551.GA26058@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0909212111490.17328@axis700.grange>
References: <f17812d70909100446h17a1903fy74941945dbfc6943@mail.gmail.com>
 <1253256227.4407.7.camel@pc-matejk> <20090918074551.GA26058@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Sep 2009, Russell King - ARM Linux wrote:

> On Fri, Sep 18, 2009 at 08:43:47AM +0200, Matej Kenda wrote:
> > On Thu, 2009-09-10 at 19:46 +0800, Eric Miao wrote:
> > > Here's the preview of request-pull result, please let me know if there
> > > is anything missed, thanks.
> > > 
> > > URL: git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
> > > 
> > > 
> > > Matej Kenda (2):
> > >       [ARM] pxa: add support for the IskraTel XCEP board
> > >       [ARM] pxa: add defconfig for IskraTel XCEP board
> > 
> > Eric, what is the current status of this request? Do I need to repost
> > the patches to included into 2.6.32?
> > 
> > Russell discarded them from his patch system, because they are on your
> > list.
> 
> I discarded them _because_ Eric handled them, which is what I said in the
> comments when I discarded them.

Ok, I did do my best to get patches in the right order in the mainline, 
but it all failed. AFAICS, v4l and sh are already in the mainline with a 
_wrongly_ resolved mefge conflict, which, most likely, breaks the 
sh_mobile_ceu_camera.c driver, and the three PXA platforms, patches for 
which should have been applied before both those trees and still haven't 
been applied are broken until the patches do get in and the later those 
patches get applied the longer the interval with the broken for them 
bisection is going to be.

Thanks
Guennadi
---
Guennadi Liakhovetski
