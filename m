Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab0BRPe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 10:34:59 -0500
Date: Thu, 18 Feb 2010 07:34:41 -0800
From: Greg KH <greg@kroah.com>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Emil Meier <emil276me@yahoo.com>,
	Linux media <linux-media@vger.kernel.org>,
	francescolavra@interfree.it, stable@kernel.org
Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
Message-ID: <20100218153441.GB20850@kroah.com>
References: <592995.76165.qm@web37603.mail.mud.yahoo.com>
 <1266483476.1690.50.camel@brian.bconsult.de>
 <20100218144021.GA15415@kroah.com>
 <1266506147.4359.22.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266506147.4359.22.camel@brian.bconsult.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 18, 2010 at 04:15:47PM +0100, Chicken Shack wrote:
> Am Donnerstag, den 18.02.2010, 06:40 -0800 schrieb Greg KH:
> > On Thu, Feb 18, 2010 at 09:57:56AM +0100, Chicken Shack wrote:
> > > For Greg Kroah-Hartman:
> > > 
> > > This one should go into kernel 2.6.32, just to close a gap of kernel
> > > regressions:
> > > 
> > > http://linuxtv.org/hg/v4l-dvb/rev/2dfe2234e7ea
> > 
> > I have no idea what you are asking me to do here.
> > 
> > If you need a patch in the -stable tree, send the git commit id of the
> > patch that is in Linus's tree to the stable@kernel.org email address.
> 
> OK. So this is a bit new and confusing, and it is definitely not my job,
> as there are so-called MAINTAINERS for that, but I will try my best:
> 
> 
> Here is the link:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=691c9ae099b9bcb5c27125af00a4a90120977458
> 
> and this ought to be the commit id:
> 
> commit	691c9ae099b9bcb5c27125af00a4a90120977458
> 
> SOB etc. please see link.

That patch is already queued up for the next 2.6.32-stable kernel
release.  The people involved in that patch should have already gotten
an email saying so.

> > If it is not in Linus's tree, I can not accept it.
> 
> It is there, please see above!
> 
> Instead of doing a steady maintainers job, Mauro Carvalho Chehab prefers
> to play kiddish games by substituting functionable kernel patches with
> his own disfunctionable ones, as you can see here:

I have a 6 year old with better manners, please leave these kinds of
insults at home.  The maintainers already properly notified the stable
team of that patch, as you can see by it already being queued up.

bah,

greg k-h
