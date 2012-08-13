Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:33324 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab2HMM5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:57:12 -0400
Date: Mon, 13 Aug 2012 13:57:10 +0100
From: Sean Young <sean@mess.org>
To: Partha Guha Roy <partha.guha.roy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Philips saa7134 IR remote problem with linux kernel v2.6.35
Message-ID: <20120813125710.GA30097@pequod.mess.org>
References: <CADTwmX8-yf3iNhrOozQGFnHg=H+rq6rti8AO=uRBzsj+OHEdyQ@mail.gmail.com>
 <20120810094758.GA18223@pequod.mess.org>
 <CADTwmX-odw+=GXuYAo9y3E6=7-TLuW0U5GSU2dnpWYtm4RXGLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADTwmX-odw+=GXuYAo9y3E6=7-TLuW0U5GSU2dnpWYtm4RXGLA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2012 at 11:41:23PM +0600, Partha Guha Roy wrote:
> On Fri, Aug 10, 2012 at 3:47 PM, Sean Young <sean@mess.org> wrote:
> >
> > Are you runnning the lircd user space process for input or relying on
> > the in-kernel decoders?
> 
> For my testing, I booted the vanilla kernel into ubuntu recovery mode
> and just pressed a few keys on the remote. No lircd process was
> running at that point. So, I am guessing that I used the in-kernel
> decoders.

That sounds right.

> > Also what remote are you using (or more
> > specifically, what IR protocol does it use)?
> >
> 
> The remove came with the analog TV card (avermedia pci pure m135a). I
> am not sure what protocol the remote uses. I'd really appreciate it if
> you could let me know how I can find that out.

That's a nec remote. Using ir-keytable (in the ir-keyable package on
Ubuntu) you change the protocol and see what's being sent.

However I guess the problem is that IR edges aren't being reported until
triggered by more IR edges.

> > Can you reproduce the issue on a more contemporary kernel?
> >
> 
> Yes. The buggy behavior is present in Ubuntu 12.04 (IIRC, kernel
> v3.2.*). I also know that the buggy behavior is present at v3.4.x of
> the kernel. I haven't tested more recent kernels.

There is a lot code churn so it would be very helpful to have it 
reproduced on a recent kernel.

Unfortunately your bisect wasn't entirely useful. You ended up at
e40b1127f994a427568319d1be9b9e5ab1f58dd1. Unfortunately that commit
introduced a bug which was not entirely resolved until
9800b5b619cd9a013a6f0c7d5da0dbbc17a5af30. If you do a bisect 
again it would useful to skip anything between those commits.

Also is the issue intermittent or is your last key press *always*
missed? 


Sean
