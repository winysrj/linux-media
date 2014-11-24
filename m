Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56392 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaKXKMR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 05:12:17 -0500
Date: Mon, 24 Nov 2014 08:12:11 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR v3.19] uvcvideo changes
Message-ID: <20141124081211.46d546d3@recife.lan>
In-Reply-To: <2578174.1LaTmadn8H@avalon>
References: <1524049.TLSF8qZEUD@avalon>
	<20141111085626.3f1201dc@recife.lan>
	<2578174.1LaTmadn8H@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Nov 2014 11:06:49 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday 11 November 2014 08:56:26 Mauro Carvalho Chehab wrote:
> > Em Fri, 07 Nov 2014 08:16:28 +0200 Laurent Pinchart escreveu:
> > > Hi Mauro,
> > > 
> > > The following changes since commit 
> 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
> > >   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
> > > 
> > > are available in the git repository at:
> > >   git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next
> > 
> > It seems that there's something weird with this URL... remotes????
> 
> git isn't playing nicely :-/
> 
> I've pushed the changes to the uvc/next branch on 
> git://linuxtv.org/pinchartl/media.git, up to commit a1bee5f9f606. 
> http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/commit/?h=uvc/next 
> confirms that everything is in order.
> 
> However, running
> 
> git request-pull local-linuxtv-master media remotes/media/uvc/next

Seriously? Do you want git to change remotes? I don't think you can
do that. The remotes branches are to track something remote, e. g.
the references there should be already at the remote tree.

You should, instead, create a local branch and push it upstream.

> 
> with the media remote pointing to git://linuxtv.org/pinchartl/media.git 
> generates
> 
> ----------
> warn: No match for commit a1bee5f9f606f89ff30171658a82bf532cca7f3d found at 
> git://linuxtv.org/pinchartl/media.git
> warn: Are you sure you pushed 'remotes/media/uvc/next' there?
> The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
> 
>   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next
> 
> for you to fetch changes up to a1bee5f9f606f89ff30171658a82bf532cca7f3d:
> 
>   uvcvideo: Return all buffers to vb2 at stream stop and start failure 
> (2014-11-07 08:13:21 +0200)
> ----------
> 
> For some reason git can't find the remote branch (hence the warning) and thus 
> generates the URL line incorrectly.
> 
> I've tried upgrading from git 2.0.4 to git 2.1.3 but the problem is still 
> present. Creating a local branch named uvc/next fixes the problem. 

Yes, that's the right thing to do. Only modify local branches.

Git considers that the branches under remotes/* will be handled by
it. If you ever do a "git remote update". You'll see that git will override
all references that are on a remote branch and you'll loose your work!

I think that even git revlog won't help you to recover the missing heads,
as it won't track branches under remotes/*.

> I wonder if 
> I'm doing something really stupid or if it's a git bug.

Well, git is right. You should not use remotes/foo for the branches
you're modifying. Such namespace is reserved for git to be able to
track the upstream branches.

> 
> Can you pull from
> 
>         git://linuxtv.org/pinchartl/media.git uvc/next

Sure, I'll do it along this week.
> 
> ? I haven't updated the branch since I've sent the last pull request.
> 

Regards,
Mauro

