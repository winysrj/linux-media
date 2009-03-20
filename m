Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCTWVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 18:21:14 -0400
Date: Fri, 20 Mar 2009 19:20:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Werner" <HWerner4@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Message-ID: <20090320192046.15d32407@pedra.chehab.org>
In-Reply-To: <20090320204707.227110@gmx.net>
References: <200903022218.24259.hverkuil@xs4all.nl>
	<20090304141715.0a1af14d@pedra.chehab.org>
	<20090320204707.227110@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Mar 2009 21:47:07 +0100
"Hans Werner" <HWerner4@gmx.de> wrote:

> > That's said, the backport tree is still an experimental work. The scripts
> > require more time to be tested, and the Makefiles need some cleanups.
> 
> Mauro,
> 
> neat, but I still think time spent on backporting work would be better
> spent on cutting-edge development. Two hours here ... two hours there
> ... it all adds up to a significant investment of time.

True. Yet, the more easy for end users to have their devices working on their
environments, the more number of "end tail" contributions we'll have, fixing
issues on specific devices whose the main developers don't have.

> > Beside the fact that we don't need to strip support for legacy kernels,
> > the
> > advantage of using this method is that we can evolute to a new development
> > model. As several developers already required, we should really use the
> > standard -git tree as everybody's else. This will simplify a lot the way
> > we
> > work, and give us more agility to send patches upstream.
> 
> Great! Do you have a plan for how soon a move to the standard git tree
> will happen? The sooner the better IMO.

Let's first finish 2.6.30 merge window. Then, we'll have more time to cleanup
the tree and think on moving to git. Now, everyone is focused on having their
work done for the next tree.

> If I understand correctly you are suggesting that a backporting
> system would continue to exist?
> 
> Why? Surely this would be a heavy ball-and-chain to drag around for 
> eternity. Why not lose the backporting and go for the simplicity and 
> agility you mentioned above?

My suggestion is to keep a backporting system, but more targeted at the
end-users. The reasons are the ones explained above. Basically:

- Allow end-users to test the drivers without requiring immediate
  kernel upgrade to the latest -rc-git tree, on their environments;
- Offer a tree where people can use to generate contributions like adding
  new devices at cards table.

It should also be clear for all that the backported system is not targeted on
offering any kind of implicit or explicit warranty that a driver will work
on a legacy kernel. It is a paper of the distros to provide such kind of
support. Also, to provide such warranty, other files outside linux/media would
need to be patched [1].
 
So, the backport should keep being provided as a best-effort model, just like
what we have right now with all the backports on our tree: we expect it to
work, but it may not work on some environments. No warranties are given.

I intend to write a proposal about it sometime after the merge window, for
people to comment and to contribute with.

[1] Just as an example, the USB video drivers leak memory if you're using
isoc USB transfers on kernels bellow 2.6.29. So, after some stress conditions,
you can eventually run out of memory on legacy kernels. The fix is outside the
linux media scope (it is due to a bug at ehci_hcd scheduler).

Cheers,
Mauro
