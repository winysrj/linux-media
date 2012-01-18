Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38445 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2ARQec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 11:34:32 -0500
Date: Wed, 18 Jan 2012 10:42:38 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
In-Reply-To: <4F16DCAD.5010700@redhat.com>
Message-ID: <alpine.LNX.2.00.1201181023390.6337@banach.math.auburn.edu>
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <4F16BF4D.4070404@googlemail.com> <4F16C11F.3040108@redhat.com> <4F16C2CA.2090401@googlemail.com> <4F16DCAD.5010700@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 18 Jan 2012, Mauro Carvalho Chehab wrote:

> Em 18-01-2012 11:02, Gregor Jasny escreveu:
> > On 1/18/12 1:54 PM, Mauro Carvalho Chehab wrote:
> >> Em 18-01-2012 10:47, Gregor Jasny escreveu:
> >>> On 1/18/12 1:19 PM, Mauro Carvalho Chehab wrote:
> >>>> It would be nice to write at the INSTALL what dependencies are needed for
> >>>> the autotools to work, or, alternatively, to commit the files generated
> >>>> by the autoreconf -vfi magic spell there [1].
> >>>
> >>> The end user gets a tarball created with "make dist" which contains all the m4 files.
> >>
> >> Ah, ok. It probably makes sense then to add some scripting at the server to do
> >> a daily build, as the tarballs aren't updated very often. They're updated only
> >> at the sub-releases:
> >>     http://linuxtv.org/downloads/v4l-utils/
> > 
> > Judging from the upside-down reports: not the lack of a buildable tarball but the lack of updated distribution packages is a problem. For Ubuntu we have a PPA repository with nightly builds:
> > 
> > https://launchpad.net/~libv4l/+archive/development
> > 
> > Do you have similar infrastructure for Fedora / RedHat, too?
> 
> There are two separate issues here:
> 
> 1) users that just get the distro packages.
> 
> For them, the updated distro packages is the issue.
> 
> For those, it is very good to have v4l-utils properly packaged on Ubuntu.
> Thanks for that!
> 
> Hans is maintaining v4l-utils at Fedora. I don't think he's currently 
> using the -git unstable versions at Fedora Rawhide (the Fedora under 
> development distro). Yet, every time a new release is lauched, he
> updates the packages for Fedora.
> 
> So, I think that this is now properly covered with Fedora and Ubuntu 
> (also Debian?). I think that Suse is also doing something similar.
> 
> 2) users that are testing the neat features that the newest package has.
> 
> This covers most of the 900+ subscribers of the linux-media ML.
> 
> Those users, in general, don't care much about the distro packages. They
> just want to download the latest sources and compile, in order to test
> the drivers/tools, and provide us feedback. We want to make life easier
> for them, as their test is very important for us to detect, in advance,
> when some regression is happened somewhere.
> 
> For those users, it may make sense to have a daily tarball or some
> user-friendly scripting that would allow them to easily clone the
> git tree and use it.
> 
> Regards,
> Mauro

As one of the people who comes under category (2) above, let me add a 
couple of comments, here. 

First, I was unaware of these changes until I found out about them the 
hard way, a few days ago. Namely, I did a "git pull" and added the new 
stuff to my working copy, then could not compile anything. The error I got 
said that config.h is missing. Well, it took me all of about 5 minutes to 
figure out that I had better re-read the Imstall file, which made things 
totally clear. Run autoconf. Been there with other projects, done that. No 
problems. I only saw some mail on the list about the changeover a couple 
of days after that, and had a chuckle.

Second, it is no big deal. Autoconf works quite nicely, so what is the 
problem, exactly? I see not much need for "a daily tarball or some 
user-friendly scripting" to "fix" something which does not appear to be a 
problem. Well, there is a problem, but I do not see it as a serious one. 
The problem is that one's tools have to be up to date. That is up to the 
distro. But it is probably well known that some distros are better at 
keeping up with things like this than are others.

Theodore Kilgore
