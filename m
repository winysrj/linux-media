Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbZCURge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 13:36:34 -0400
Date: Sat, 21 Mar 2009 14:35:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Hans Werner <HWerner4@gmx.de>, linux-media@vger.kernel.org
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Message-ID: <20090321143556.4169c15d@pedra.chehab.org>
In-Reply-To: <412bdbff0903210505s75e446cfq35768c3878415e48@mail.gmail.com>
References: <200903022218.24259.hverkuil@xs4all.nl>
	<20090304141715.0a1af14d@pedra.chehab.org>
	<20090320204707.227110@gmx.net>
	<20090320192046.15d32407@pedra.chehab.org>
	<412bdbff0903201903g270b4be1nb55e6d881e46efc2@mail.gmail.com>
	<20090321000416.1ce9aaef@pedra.chehab.org>
	<412bdbff0903210505s75e446cfq35768c3878415e48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Mar 2009 08:05:51 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> On Fri, Mar 20, 2009 at 11:04 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > Devin,
> >
> > Please, don't invert the things.
> >
> > I am the one that is trying to defend the need of keeping the backport, while
> > most of you are trying to convince to me to just drop it, since developers will
> > run the bleeding edge -rc.
> >
> > With the argument that developers shouldn't run the bleeding edge kernel, I'd
> > say you should do it. This is the way kernel development is. You shouldn't send
> > something upstream, if your patch doesn't run with the latest -rc. In my case,
> > I have my alpha environment for such tests, separated from the environment I
> > write my code. This allows me to do development on a more stable environment,
> > being sure that it will keep running with the latest kernel.
> >
> > With the respect of using the backported environment for developing, you can do
> > it, if you want. It will be available for all usages. Have you ever seen the
> > approach I'm proposing at my backported tree? I can't see why you couldn't use
> > it for development also.
> 
> Mauro,
> 
> When this thread was started, it was about dropping support for
> kernels < 2.6.22.  However, it has turned into a thread about moving
> to git and dropping support for *all* kernels less than the bleeding
> edge -rc candidate (only supporting them through a backport system for
> testers).  The two are very different things.

> 
> I agree with the general consensus that we should raise the "minimum
> bar" from 2.6.16 to 2.6.22.  And I also believe that we need to ensure
> that we do not want to lose testers by requiring them to run the
> latest kernel release.  However, now we are talking about what the
> *developers* are expected to run.  What has now been proposed is
> changing the build system such that developers must run the latest -rc
> kernel, which I do not believe is a good idea.  It makes it easier for
> the maintainer to merge patches, however at the cost of the other
> developers trying to focus on v4l-dvb development without having to
> worry about whether this week's -rc kernel is going to work in their
> environment.
> 

As I said before, this is not the proper moment for such discussions. People
are still focused on the 2.6.30 merge stuff. We should discuss it by the end of
the merge window, discussing the newly model to be used starting at the 2.6.31 cycle.

It is important to discuss a new model, since the current one has some flaws,
like:
- bug fixes are sometimes postponed, since they depend on the bleeding edge
patches;
- our model is different from the rest of Linux kernel community;
- it is hard to merge patches that needs coordination with changes outside
drivers/media;
- the need of conversion for each -hg patch into -git;
- the need of backport upstream changes at the building system, and keeping
track of such changes.
- the increased volume of patches on v4l/dvb made our development model
incredible complex for submitting work upstream, since it doesn't scale well,
and has caused some hard to solve merge conflicts.

>From my side, I never proposed to drop the backport system, but to improve it,
in a way that people can keep working and testing the subsystem with legacy
kernels, although I've seen several comments on this poll where people are
arguing to just drop all backports.

> It already takes me half an hour to checkout and build the latest
> v4l-dvb tree.  Telling me that now I'm going to have to download and
> build the entire kernel on a weekly basis, as well as deal with
> whatever crap gets broken in my environment, is too much for many
> developers who don't work for a distribution vendor.  For a developer
> working nights and weekends on this stuff, this ends up being a
> significant fraction of my development time.

It seems that you're afraid of the unknown. There are several ways to use -git.
You can even use a spare git clone, where, for example, only drivers/media will
be cloned on your local machine. 

Since we haven't discussed how a new development model would work, it is
pointless to be against something that were not even proposed. And it weren't
proposed yet due to the fact that people didn't have time yet to prepare a
proposal and test it.

Also, due to the need of providing fix packages for linux-next, the current
development kernel and the last stable one, this means that any model we use
will need to work properly on all those cases.

> I just want it to be clear that there are developers who are not
> willing to run the latest -rc kernel just for the luxury of being able
> to contribute to v4l-dvb.

If we review the poll comments, and include some occasional emails about our
development model, we'll have all sorts of different opinions:
- People that want to keep backports as-is;
- People that want to set the baseline to 2.6.22;
- People that want to set a higher line (some even proposed to cut it to support
  just the latest kernel);
- People that want to have a lower baseline (to support embedded, for example);
- People that just want us to use a clone of Linus -git tree;
- People that acked with the poll, without giving any additional comments.

You'll see developers and end users on all the above categories.

My conclusion about the poll is that, whatever development model we choose
(even keeping the current one), some people will be unhappy.

So, instead of just complaining, people should come with bright proposals about
a model that will better fit to our needs.

Cheers,
Mauro
