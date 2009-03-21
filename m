Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:46328 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbZCUMFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 08:05:54 -0400
Received: by gxk4 with SMTP id 4so4003540gxk.13
        for <linux-media@vger.kernel.org>; Sat, 21 Mar 2009 05:05:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090321000416.1ce9aaef@pedra.chehab.org>
References: <200903022218.24259.hverkuil@xs4all.nl>
	 <20090304141715.0a1af14d@pedra.chehab.org>
	 <20090320204707.227110@gmx.net>
	 <20090320192046.15d32407@pedra.chehab.org>
	 <412bdbff0903201903g270b4be1nb55e6d881e46efc2@mail.gmail.com>
	 <20090321000416.1ce9aaef@pedra.chehab.org>
Date: Sat, 21 Mar 2009 08:05:51 -0400
Message-ID: <412bdbff0903210505s75e446cfq35768c3878415e48@mail.gmail.com>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Werner <HWerner4@gmx.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2009 at 11:04 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Devin,
>
> Please, don't invert the things.
>
> I am the one that is trying to defend the need of keeping the backport, while
> most of you are trying to convince to me to just drop it, since developers will
> run the bleeding edge -rc.
>
> With the argument that developers shouldn't run the bleeding edge kernel, I'd
> say you should do it. This is the way kernel development is. You shouldn't send
> something upstream, if your patch doesn't run with the latest -rc. In my case,
> I have my alpha environment for such tests, separated from the environment I
> write my code. This allows me to do development on a more stable environment,
> being sure that it will keep running with the latest kernel.
>
> With the respect of using the backported environment for developing, you can do
> it, if you want. It will be available for all usages. Have you ever seen the
> approach I'm proposing at my backported tree? I can't see why you couldn't use
> it for development also.

Mauro,

When this thread was started, it was about dropping support for
kernels < 2.6.22.  However, it has turned into a thread about moving
to git and dropping support for *all* kernels less than the bleeding
edge -rc candidate (only supporting them through a backport system for
testers).  The two are very different things.

I agree with the general consensus that we should raise the "minimum
bar" from 2.6.16 to 2.6.22.  And I also believe that we need to ensure
that we do not want to lose testers by requiring them to run the
latest kernel release.  However, now we are talking about what the
*developers* are expected to run.  What has now been proposed is
changing the build system such that developers must run the latest -rc
kernel, which I do not believe is a good idea.  It makes it easier for
the maintainer to merge patches, however at the cost of the other
developers trying to focus on v4l-dvb development without having to
worry about whether this week's -rc kernel is going to work in their
environment.

It already takes me half an hour to checkout and build the latest
v4l-dvb tree.  Telling me that now I'm going to have to download and
build the entire kernel on a weekly basis, as well as deal with
whatever crap gets broken in my environment, is too much for many
developers who don't work for a distribution vendor.  For a developer
working nights and weekends on this stuff, this ends up being a
significant fraction of my development time.

I just want it to be clear that there are developers who are not
willing to run the latest -rc kernel just for the luxury of being able
to contribute to v4l-dvb.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
