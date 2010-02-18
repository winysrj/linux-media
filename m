Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756799Ab0BRPP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 10:15:57 -0500
Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
From: Chicken Shack <chicken.shack@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Emil Meier <emil276me@yahoo.com>,
	Linux media <linux-media@vger.kernel.org>,
	francescolavra@interfree.it, stable@kernel.org
In-Reply-To: <20100218144021.GA15415@kroah.com>
References: <592995.76165.qm@web37603.mail.mud.yahoo.com>
	 <1266483476.1690.50.camel@brian.bconsult.de>
	 <20100218144021.GA15415@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 16:15:47 +0100
Message-ID: <1266506147.4359.22.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 18.02.2010, 06:40 -0800 schrieb Greg KH:
> On Thu, Feb 18, 2010 at 09:57:56AM +0100, Chicken Shack wrote:
> > For Greg Kroah-Hartman:
> > 
> > This one should go into kernel 2.6.32, just to close a gap of kernel
> > regressions:
> > 
> > http://linuxtv.org/hg/v4l-dvb/rev/2dfe2234e7ea
> 
> I have no idea what you are asking me to do here.
> 
> If you need a patch in the -stable tree, send the git commit id of the
> patch that is in Linus's tree to the stable@kernel.org email address.

OK. So this is a bit new and confusing, and it is definitely not my job,
as there are so-called MAINTAINERS for that, but I will try my best:


Here is the link:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=691c9ae099b9bcb5c27125af00a4a90120977458

and this ought to be the commit id:

commit	691c9ae099b9bcb5c27125af00a4a90120977458

SOB etc. please see link.


> If it is not in Linus's tree, I can not accept it.

It is there, please see above!

Instead of doing a steady maintainers job, Mauro Carvalho Chehab prefers
to play kiddish games by substituting functionable kernel patches with
his own disfunctionable ones, as you can see here:

http://www.spinics.net/lists/linux-media/msg15749.html

and here:

http://www.spinics.net/lists/linux-media/msg15761.html

The maintainers job would have been to send the commit ID to
stable@kernel.org, but foolish experiments seem to be more important
than a fix for a stable kernel.

> confused,

> greg k-h

enlightened and delighted,

Chicken Shack :)  :)

stable@kernel.org Cced.....


