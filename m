Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40014 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030874AbaLLRgo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 12:36:44 -0500
Date: Fri, 12 Dec 2014 15:36:38 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEW] au0828-video.c
Message-ID: <20141212153638.6ecb9664@recife.lan>
In-Reply-To: <CAGoCfiywSrq0f-L6a2LOS=ZS7xzfUJym46njesR8TkfoybQ5Pw@mail.gmail.com>
References: <548AC061.3050700@xs4all.nl>
	<20141212104942.0ea3c1d7@recife.lan>
	<548AE5B2.1070306@xs4all.nl>
	<20141212111424.0595125b@recife.lan>
	<548B092F.2090803@osg.samsung.com>
	<548B09A5.80506@xs4all.nl>
	<CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
	<548B1884.6090005@xs4all.nl>
	<CAGoCfiywSrq0f-L6a2LOS=ZS7xzfUJym46njesR8TkfoybQ5Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 12 Dec 2014 11:46:13 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> >> In short, that code cannot be removed.
> >
> > Sure it can. I just tried tvtime and you are right, it blocks the GUI.
> > But the fix is very easy as well. So now I've updated tvtime so that
> > it timeouts and gives the GUI time to update itself.
> 
> That's a nice change to tvtime and I'm sure it will make it more robust.
> 
> > No more need for such an ugly hack in au0828. The au0828 isn't the only
> > driver that can block, others do as well. Admittedly, they aren't very
> > common, but they do exist. So it is much better to fix the application
> > than adding application workarounds in the kernel.
> 
> You're breaking the ABI.  You're making a change to the kernel that
> causes existing applications to stop working.  Sure you can make the
> argument that applications probably never should have expected such
> behavior (even if it's relied on that behavior for 15+ years).  And
> sure, you can make a change to the application in some random git
> repository that avoids the issue, and that change might get sucked in
> to the major distributions over the next couple of years.  That
> doesn't change the fact that you're breaking the ABI and everybody who
> has the existing application that updates their kernel will stop
> working.
> 
> Please don't do this.

I agree. We should not break the ABI, except if we're 100% sure that
all apps that rely on the old behavior got fixed at the distros.

That means that we'll need to keep holding such timeout code for
years, until all distros update to a new tvtime, of course assuming
that this is the only one application with such issue.

With regards to tvtime, I think we need to bump version there and
update it at the distros.

I added myself a few patches today, in order to fix it to work with
vivid driver on webcam mode.

My proposal is to wait for one extra week for people to review it.

As we've discussed on IRC channel, it would be good to add support
for format enumeration on it, but the changes don't seem to be
trivial. I'm not willing to do it, due to my lack of time, but,
if someone steps up for doing that, then we can wait for those
patches before bumping the version.

In anycase, if everything is ok after ~1 week of waiting for
tests, we can bump to version 1.0.5 and I can port the latest
version to Fedora. I dunno who maintains it on other distros.

Regards,
Mauro
