Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52193 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0AIEYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jan 2010 23:24:32 -0500
Subject: Re: Leadtek WinFast PVR2100 linux support
From: Andy Walls <awalls@radix.net>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Cc: dennisharrison@gmail.com, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
In-Reply-To: <1262958952.3054.17.camel@palomino.walls.org>
References: <6e8b29e1001061428k39e3b2a6w825c8b8336f30b3e@mail.gmail.com>
	 <1262826612.3065.30.camel@palomino.walls.org>
	 <829197381001070753s3152f52ai788f675e0a0a3280@mail.gmail.com>
	 <1262958952.3054.17.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 08 Jan 2010 23:24:02 -0500
Message-Id: <1263011042.25440.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-08 at 08:55 -0500, Andy Walls wrote:
> On Thu, 2010-01-07 at 10:53 -0500, Devin Heitmueller wrote:
> > On Wed, Jan 6, 2010 at 8:10 PM, Andy Walls <awalls@radix.net> wrote:
> > >>   I am
> > >> looking to setup a mythtv box in the house - and I am stuck on
> > >> satellite.  The only way I can see to get hd content out of the
> > >> receivers are hdmi and component.  My understanding is that no hdmi
> > >> capture cards work properly under linux (hours of google - is all I
> > >> have to go on for this though).  So that leaves component capture, and
> > >> the leadtek pvr2100 would be the best bang for the buck (I think?).
> > 
> > It is probably worth noting that component capture does not
> > necessarily mean HD component capture.  I suspect this card may very
> > well only capture 480i/480p.
> > 
> > Do you know definitively that it can capture in HD?
> 
> Good point.  I'm pretty sure a CX23418 will only ever be able to capture
> standard resolution using component video in.  Even if I could coax the
> analog front end into an HD resolution configuration (doubtful), the
> MPEG encoding engine is still expecting 720x576 as the max resolution
> (PAL & SECAM).
> 
> But component video for cx18 might still be a project I undertake
> sometime.

And here's my first stab at cx18 component video:

	http://linuxtv.org/hg/~awalls/cx18-pvr2100-component

for both the Leadtek PVR2100 and DVR3100 H.  It was a little easier than
I had thought.

Anyone with one of those boards with the component video hookup, please
give it a test.

Regards,
Andy

