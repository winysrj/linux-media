Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0G0UBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 16:01:13 -0400
Date: Tue, 27 Jul 2010 12:51:50 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
Message-ID: <20100727195150.GA2196@kroah.com>
References: <20100726232546.GA21225@redhat.com> <4C4F0244.2070803@redhat.com> <20100727160955.GA7528@kroah.com> <20100727182404.GE9465@redhat.com> <4C4F348C.3040703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F348C.3040703@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 04:33:32PM -0300, Mauro Carvalho Chehab wrote:
> Em 27-07-2010 15:24, Jarod Wilson escreveu:
> > On Tue, Jul 27, 2010 at 09:09:56AM -0700, Greg KH wrote:
> >> On Tue, Jul 27, 2010 at 12:59:00PM -0300, Mauro Carvalho Chehab wrote:
> >>> Em 26-07-2010 20:25, Jarod Wilson escreveu:
> >>
> >> Hm, Jarod, you forgot to cc: the staging maintainer, so I missed these
> >> :)
> > 
> > D'oh, sorry, yeah, realized that about 10 minutes after I sent everything.
> > Figured I'd ping you if you hadn't said anything about 'em in a day or
> > three.
> > 
> >>> Greg,
> >>>
> >>> It is probably simpler to merge those files via my tree, as they depend
> >>> on some changes scheduled for 2.6.36.
> >>>
> >>> Would it be ok for you if I merge them from my tree?
> >>
> >> No objection from me for them to go through your tree.
> 
> Ok, thanks. I'll merge the patches on my tree.
> 
> >>
> >> Do you want me to handle the cleanup and other fixes after they go into
> >> the tree, or do you want to also handle them as well (either is fine
> >> with me.)
> > 
> > Note that I've got a git tree I've been maintaining the lirc drivers in
> > for a while, so whomever is ultimately the gateway, I can also stage
> > cleanups there -- I'll certainly be pushing any cleanups I do on the lirc
> > drivers there prior to sending along for upstream, or else I'm liable to
> > lose track of them... :)
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-lirc.git
> > 
> 
> Well, maybe the easiest way would be if I handle the first merge, to be sure that
> they'll reach linux-next and 2.6.36 at the right time, avoiding conflicts with some
> core changes. After the merge, Jerod can handle it via his own tree.

Well, Jerod needs to send me the patches for inclusion in linux-next and
Linus's tree from his tree as I will need to coordinate them after the
initial merge from Mauro happens.

thanks,

greg k-h
