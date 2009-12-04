Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZLDAsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 19:48:11 -0500
Date: Thu, 3 Dec 2009 22:48:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Andy Walls <awalls@radix.net>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
Message-ID: <20091203224809.2ce0b227@pedra>
In-Reply-To: <Pine.LNX.4.64.0912032239550.4328@axis700.grange>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
	<1259709900.3102.3.camel@palomino.walls.org>
	<200912031012.41889.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0912032239550.4328@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 3 Dec 2009 22:42:38 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> On Thu, 3 Dec 2009, Hans Verkuil wrote:
> 
> > On Wednesday 02 December 2009 04:55:00 Andy Walls wrote:
> > > On Tue, 2009-12-01 at 15:59 +0100, Patrick Boettcher wrote:
> > > > Hi all,
> > > >
> > > > I would like to start a discussion which ideally results in either
> > > > changing the SCM of v4l-dvb to git _or_ leaving everything as it is today
> > > > with mercurial.
> > > >
> > > >
> > > > I'm waiting for comments.

GIT.

However, just using what we have in -hg at -git won't give much benefits. We
should really move forward and use a clone of Linus tree.

I intend to work on a way to allow us to move to -git, while preserving our
building system. My target is to do it at the beginning of the next year.

> > >
> > > I only have one requirement: reduce bandwidth usage between the server
> > > and my home.
> > >
> > > The less I have to clone out 65 M of history to start a new series of
> > > patches the better.  I suppose that would include a rebase...

The first clone of the Linus -git tree will be more painful than 65 Mb of downloads
Well, -git supports partial clone, were it discards the old history:

$git help clone
...
       --depth <depth>
              Create a shallow clone with a history truncated to the specified number of revisions. A shallow
              repository has a number of limitations (you cannot clone or fetch from it, nor push from nor into it),
              but is adequate if you are only interested in the recent history of a large project with a long history,
              and would want to send in fixes as patches.
...

I never used it, so I can't tell if this works properly.

However, the big advantage with -git is that, once you have one local clone,
you may do other clones that will use a shared repository of objects.

Here, I use one git full clone of the Linus tree, created with:
	git clone --bare <git repository> master-git-repo.git

Being a bare tree, it will only contain the objects (we generally name bare repos with .git extension).

Then, my -git working dirs are created with:
	git clone -s git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git

This clone is very fast, since it is local and is sharing the bare objects.

I then add, at myclone/.git/config two remote repositories, like:

[remote "linus"]
        URL = /home/myhome/tokernel/bare/linus.git/
        fetch = +refs/tags/*:refs/remotes/linus/*
        fetch = +refs/heads/master:refs/remotes/linus/upstream
        tagopt = --no-tags
[remote "origin"]
        URL = ssh://my.remote.site.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/linux-2.6.git/*
        Push = refs/heads/*:refs/heads/*

This way, every time I want to update from upstream or from my remote repo,
I run a script with something like:

$ (cd linux-2.6.git && git fetch)
$ (cd myclone && git remote update)

And, every time I want to push to my remote repo, i do:
$ git push origin

The advantage of having a bare directory is that I can have several other local git
trees, each completely independent from the bare, and all with all the files checked-out.

If you're doing lots of things at the same time, this is a way safer than using branches.

Btw, git branch work really really well. Also, as git revlog provides a changelog history,
you can do rollbacks if needed.

Ah, with respect to rebase, the better way, IMHO, to rebase your directory is to create
a new branch based on the latest upstream, pull the patches there, and then rebase.
The big advantage is that you'll keep your old work untouched, so, if you do something wrong,
you can simply delete the new branch an do it again.

> > 
> > Unfortunately, one reason for moving to git would be to finally be able to 
> > make changes to the arch directory tree. The fact that that part is 
> > unavailable in v4l-dvb is a big problem when working with SoCs. And these will 
> > become much more important in the near future.
> 
> FWIW, tomorrow (or a day or two later) I'll have to spend time again 
> back-porting arch changes from git to hg, to be able to push my current 
> patches...

My current maintainership live is to do ports/backports between hg and git. This is
very time demanding those days... Moving to git will be really great.




Cheers,
Mauro
