Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:35309 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZCUFVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 01:21:45 -0400
Date: Fri, 20 Mar 2009 22:21:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Werner <HWerner4@gmx.de>, linux-media@vger.kernel.org
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <20090321000416.1ce9aaef@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0903202217150.28292@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <20090320204707.227110@gmx.net> <20090320192046.15d32407@pedra.chehab.org>
 <412bdbff0903201903g270b4be1nb55e6d881e46efc2@mail.gmail.com>
 <20090321000416.1ce9aaef@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Mar 2009, Mauro Carvalho Chehab wrote:
> On Fri, 20 Mar 2009 22:03:21 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
> > On Fri, Mar 20, 2009 at 6:20 PM, Mauro Carvalho Chehab
> > <mchehab@infradead.org> wrote:
> > > My suggestion is to keep a backporting system, but more targeted at the
> > > end-users. The reasons are the ones explained above. Basically:
> >
> > Ok, so just so we're all on the same page - we're telling all the
> > developers not willing to run a bleeding edge rc kernel to screw off?
> >
> > Got an Nvidia video card?  Go away!
> > The wireless broken in this week's -rc candidate?  Go away!
> > Your distro doesn't yet support the bleeding edge kernel?   Go away!
> > Want to have a stable base on which to work so you can focus on
> > v4l-dvb development?  Go away!
> >
> > I can tell you quite definitely that you're going to lose some
> > developers with this approach.  You better be damn sure that the lives
> > you're making easier are going to significantly outweigh the
> > developers willing to contribute who you are casting aside.
>
> Devin,
>
> Please, don't invert the things.
>
> I am the one that is trying to defend the need of keeping the backport, while
> most of you are trying to convince to me to just drop it, since developers will
> run the bleeding edge -rc.

I don't run bleeding edge rc.  I have one computer.  I need it to work.  I
like to go months without rebooting.

> With the argument that developers shouldn't run the bleeding edge kernel, I'd
> say you should do it. This is the way kernel development is. You shouldn't send
> something upstream, if your patch doesn't run with the latest -rc. In my case,

Isn't developer time better spent working on drivers that the developer has
knownedlge of instead of compiling kernels, rebooting, updating nvidia
drivers, etc?

> I have my alpha environment for such tests, separated from the environment I
> write my code. This allows me to do development on a more stable environment,
> being sure that it will keep running with the latest kernel.

You must have multiple computers then.  Not of all us do.  Or have space.
Or want to use the energy to run them.

> With the respect of using the backported environment for developing, you can do
> it, if you want. It will be available for all usages. Have you ever seen the
> approach I'm proposing at my backported tree? I can't see why you couldn't use
> it for development also.

Because you'll have to port the patches to the git tree.
