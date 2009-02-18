Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZBRCIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 21:08:52 -0500
Date: Tue, 17 Feb 2009 23:08:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090217230815.70c81815@pedra.chehab.org>
In-Reply-To: <200902180118.37354.hverkuil@xs4all.nl>
References: <20090217142327.1678c1a6@hyperion.delvare>
	<20090217210823.379579e1@pedra.chehab.org>
	<200902180118.37354.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 01:18:37 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Wednesday 18 February 2009 01:08:23 Mauro Carvalho Chehab wrote:
> > On Tue, 17 Feb 2009 14:23:27 +0100
> >
> > Jean Delvare <khali@linux-fr.org> wrote:
> > > Hi Mauro,
> > >
> > > These days I am helping Hans Verkuil convert the last users of the
> > > legacy i2c device driver binding model to the new, standard binding
> > > model. It turns out to be a very complex task because the v4l-dvb
> > > repository is supposed to still support kernels as old as 2.6.16, while
> > > the initial support for the new i2c binding model was added in kernel
> > > 2.6.22 (and even that is somewhat different from what is upstream now.)
> > > This forces us to add quirks all around the place, which will surely
> > > result in bugs because the code becomes hard to read, understand and
> > > maintain.
> > >
> > > In fact, without this need for backwards compatibility, I would
> > > probably have been able to convert most of the drivers myself, without
> > > Hans' help, and this would already be all done. But as things stand
> > > today, he has to do most of the work, and our progress is slow.
> > >
> > > So I would like you to consider changing the minimum kernel version
> > > supported by the v4l-dvb repository from 2.6.16 to at least 2.6.22.
> > > Ideal for us would even be 2.6.26, but I would understand that this is
> > > too recent for you. Kernel 2.6.22 is one year and a half old, I
> > > honestly doubt that people fighting to get their brand new TV adapter
> > > to work are using anything older. As a matter of fact, kernel 2.6.22 is
> > > what openSUSE 10.3 has, and this is the oldest openSUSE product that is
> > > still maintained.
> > >
> > > I understand and respect your will to let a large range of users build
> > > the v4l-dvb repository, but at some point the cost for developers seems
> > > to be too high, so there's a balance to be found between users and
> > > developers. At the moment the balance isn't right IMHO.
> >
> > In my case, I use RHEL 5.3 that comes with 2.6.18. I need at least to
> > have compatibility until this version, otherwise it will be harder to me
> > to test things, since most of the time I need to run RHEL 5 kernel.
> >
> > I know that other developers also use RHEL 5 on their environments.
> 
> Why should we have ugly and time consuming workarounds in our repository 
> that hamper progress just to allow you to run RHEL 5? I'm sorry, that's no 
> reason at all. I very much doubt other subsystem maintainers are stuck on 
> 2.6.18.

The role idea of having compatibility code is to allow people to test with
distro kernels. If we decide do exclude one of the major distro, I don't see
why not dropping support for the other distros and older kernels. For
sure removing all backports will make developers happy, but this will reduce the
amount of users that can help with the development, testing the drivers and
providing us patches.

It would be much more easy to me to just drop all -hg trees with all backport
and out-of-tree compilation and stuck with my -git trees, just like other
sybsystem maintainers do, but I _do_ think that our community will suffer a lot
with this. So, let's keep supporting at least the latest kernel version used by
the major distros. So, for now, we should still keep support for 2.6.18.

> And anyway, there is no way you can do proper testing against the new i2c 
> API on that old kernel. The loading and probing of i2c modules is quite 
> different, so that's never representative of what kernels >= 2.6.22 do.

I can assure you that I2C with v4l/dvb drivers work fine with 2.6.18. I use here
with several drivers (uvc, bttv, saa7134, em28xx, ...).

As a normal user, I use skype regularly the latest uvc driver + 2.6.18 on RHEL5.

Of course, while developing, we should always test the drivers against the
latest upstream tree, but this don't reduce the value of allowing normal users
to use the latest drivers with their systems.

Cheers,
Mauro
