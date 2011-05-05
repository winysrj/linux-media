Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:38645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1EEVJT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 17:09:19 -0400
Date: Thu, 5 May 2011 13:35:45 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix cx88 remote control input
Message-ID: <20110505203545.GA13006@kroah.com>
References: <1302267045.1749.38.camel@gagarin>
 <4DBEFD02.70906@redhat.com>
 <1304407514.1739.22.camel@gagarin>
 <D7FAB30A-E204-47B9-A7A0-E3BF50EE7FBD@wilsonet.com>
 <4DC1B41D.9090200@redhat.com>
 <20110504203613.GA1091@kroah.com>
 <4DC20A86.7010509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC20A86.7010509@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, May 04, 2011 at 11:25:10PM -0300, Mauro Carvalho Chehab wrote:
> Em 04-05-2011 17:36, Greg KH escreveu:
> > Yes, as long as .39 is working properly.  We take patches in -stable for
> > stuff like this at times, it just needs to be specified exactly like you
> > did above.
> 
> OK.
> 
> > Want me to take this patch as-is for .38-stable?
> 
> Yes, please. I'm forwarding you bellow with the proper authorship/SOB/ack.
> 
> This patch fixes RC for 64 bits kernels. The extra fix for 32 bits kernels,
> (solves a calculus overflow), were sent today to -next. I generally wait 
> for a couple days before asking Linus to pull from it.

Now queued up.

thanks,

greg k-h
