Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55735 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZI3MJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 08:09:29 -0400
Date: Wed, 30 Sep 2009 14:09:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kernel list <linux-kernel@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: arm tree in broken state (was Re: What's inside the pxa tree for
	this merge window)
Message-ID: <20090930120920.GH1412@ucw.cz>
References: <f17812d70909100446h17a1903fy74941945dbfc6943@mail.gmail.com> <1253256227.4407.7.camel@pc-matejk> <20090918074551.GA26058@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0909212111490.17328@axis700.grange> <20090921200923.GF30821@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921200923.GF30821@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > > I discarded them _because_ Eric handled them, which is what I said in the
> > > comments when I discarded them.
> > 
> > Ok, I did do my best to get patches in the right order in the mainline, 
> > but it all failed. AFAICS, v4l and sh are already in the mainline with a 
> > _wrongly_ resolved mefge conflict, which, most likely, breaks the 
> > sh_mobile_ceu_camera.c driver, and the three PXA platforms, patches for 
> > which should have been applied before both those trees and still haven't 
> > been applied are broken until the patches do get in and the later those 
> > patches get applied the longer the interval with the broken for them 
> > bisection is going to be.
> 
> Meanwhile I have to consider that we have several bug fixes outstanding,
> and since I can't send Linus a pull request every day (max once a week)
> I have to be very careful about when I send stuff.
> 
> So I only get _two_ opportunities during a merge window to send a pull
> request.

Well, you should certainly try to keep your tree  unbroken, but when
it breaks, fixing it asap should be a priority. I don't know where you
got the 'once a week' rule, but it seems stupid.

> I'm going to wait until tomorrow before sending my final pull for this
> window, which is the penultimate day before the window closes.
> 
> Don't blame me for these delays - it's not my choice to impose such
> delays.  I'd really like to fix those broken platforms right now.  I
> just can't do so without causing additional delays for other issues.
> Blame Linus for imposing the "max one pull a week" rule on me.

Do you have maillist reference? Not even Linus should slow down
development like that.

If Linus really insists on that, perhaps possible solution would be to
make subarch maintainers send pull requests for simple fixes directly
to Linus?

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
