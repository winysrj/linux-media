Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:44124 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZCXMEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 08:04:48 -0400
Date: Tue, 24 Mar 2009 05:04:45 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Werner <HWerner4@gmx.de>, linux-media@vger.kernel.org
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <20090321143556.4169c15d@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0903231739340.28292@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <20090320204707.227110@gmx.net> <20090320192046.15d32407@pedra.chehab.org>
 <412bdbff0903201903g270b4be1nb55e6d881e46efc2@mail.gmail.com>
 <20090321000416.1ce9aaef@pedra.chehab.org> <412bdbff0903210505s75e446cfq35768c3878415e48@mail.gmail.com>
 <20090321143556.4169c15d@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Mar 2009, Mauro Carvalho Chehab wrote:
> > When this thread was started, it was about dropping support for
> > kernels < 2.6.22.  However, it has turned into a thread about moving
> > to git and dropping support for *all* kernels less than the bleeding
> > edge -rc candidate (only supporting them through a backport system for
> > testers).  The two are very different things.

Yes they are very different things.  I do not like a poll about dropping
the current build system being disguised as a poll about dropping support
for very old kernels.  How about a new poll, "should developers be required
to have multiple systems and spend the majority of their time recompiling
new kernels and testing nvidia and wireless drivers?"

> It is important to discuss a new model, since the current one has some flaws,
> like:

These are problems caused by having a large project with multiple areas of
maintainership and many developers working simulaniously.  Switching to a
full kernel tree and dropping cross kernel building support isn't going to
a help.

> - bug fixes are sometimes postponed, since they depend on the bleeding edge
> patches;

Full kernel source will just make this worse!  Your v4l patch needs some
very recent change to pci core?  With a full tree, the v4l-dvb maintainer
will have to wait until the pci maintainer accepts the patch and puts it
into his tree.  Then the v4l-dvb maintainer will have to pull the pci tree.
That won't just give you the one patch you need, but 100 other patches in
the tree.  Then and only then can any v4l-dvb devlopers work on their patch
that needs the pci fix.

With the current system a v4l-dvb devloper can pick just the pci patch he
needs and put it into his kernel or he can get the pci tree.  Then he's
free to develop a v4l-dvb patch that needs the pci patch.  He can probably
even do his v4l-dvb patch in a compatible manner, so that it can go in the
v4l-dvb tree before the pci patch has even appeared in the pci tree.

> - our model is different from the rest of Linux kernel community;

Their model is worse.  Why make things worse just to help people who choose
not to learn new things?

> - it is hard to merge patches that needs coordination with changes outside
> drivers/media;

It's hard to merge patches that touch multiple areas of maintainership even
if everyone uses full trees.

> - the need of conversion for each -hg patch into -git;

It's done by an automated script.  It allows fixing the large number of
mistakes commited to the v4l-dvb tree.

> - the need of backport upstream changes at the building system, and keeping
> track of such changes.

You will still have patches that touch drivers/media that don't go in via
the v4l-dvb tree.  Just look at any system with a full tree, you'll see
commits that touch that system's files and went in as some system wide
cleanup patch via another maintainer's tree.  So you'll still have to merge
these patches.

> - the increased volume of patches on v4l/dvb made our development model
> incredible complex for submitting work upstream, since it doesn't scale well,
> and has caused some hard to solve merge conflicts.

More patches means more merge conflicts.  Why does have an out of tree
build system have anything to do with it?

> You can even use a spare git clone, where, for example, only drivers/media will
> be cloned on your local machine.

Which is useless.  You can't build or run drivers/media only kernel tree!
