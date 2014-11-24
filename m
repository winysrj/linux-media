Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50398 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaKXLOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 06:14:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR v3.19] uvcvideo changes
Date: Mon, 24 Nov 2014 13:14:57 +0200
Message-ID: <16670699.qz3vBaTNrR@avalon>
In-Reply-To: <20141124085923.42579d6c@recife.lan>
References: <1524049.TLSF8qZEUD@avalon> <3359544.inIet0M21q@avalon> <20141124085923.42579d6c@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 24 November 2014 08:59:23 Mauro Carvalho Chehab wrote:
> Em Mon, 24 Nov 2014 12:41:10 +0200 Laurent Pinchart escreveu:
> > On Monday 24 November 2014 08:12:11 Mauro Carvalho Chehab wrote:
> >> Em Mon, 24 Nov 2014 11:06:49 +0200 Laurent Pinchart escreveu:
> >>> On Tuesday 11 November 2014 08:56:26 Mauro Carvalho Chehab wrote:
> >>>> Em Fri, 07 Nov 2014 08:16:28 +0200 Laurent Pinchart escreveu:
> >>>>> Hi Mauro,
> >>>>> 
> >>>>> The following changes since commit
> >>>>> 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
> >>>>>   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
> >>>>> 
> >>>>> are available in the git repository at:
> >>>>>   git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next
> >>>> 
> >>>> It seems that there's something weird with this URL... remotes????
> >>> 
> >>> git isn't playing nicely :-/
> >>> 
> >>> I've pushed the changes to the uvc/next branch on
> >>> git://linuxtv.org/pinchartl/media.git, up to commit a1bee5f9f606.
> >>> http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/commit/?h=uvc/next
> >>> confirms that everything is in order.
> >>> 
> >>> However, running
> >>> 
> >>> git request-pull local-linuxtv-master media remotes/media/uvc/next
> >> 
> >> Seriously? Do you want git to change remotes? I don't think you can
> >> do that. The remotes branches are to track something remote, e. g.
> >> the references there should be already at the remote tree.
> > 
> > I don't want git to change remotes, I want git to react to what is in the
> > remote tree.
> > 
> > For historical reasons my local branch is named uvcvideo/next, while the
> > remote branch is named uvc/next. They both point to the same commit.
> > Before upgrading to git v2.0.4 running
> > 
> > 	git request-pull local-linuxtv-master media remotes/media/uvc/next
> > 
> > would not incorrectly warn that the commit ID isn't available remotely (as
> > it is available) and would produce the git URL
> > 
> > 	git://linuxtv.org/pinchartl/media.git uvc/next
> 
> The right syntax would be to use, instead:
> 	git request-pull git://linuxtv.org/pinchartl/media.git uvcvideo/next

That produces

warn: No match for commit a1bee5f9f606f89ff30171658a82bf532cca7f3d found at 
media
warn: Are you sure you pushed 'uvcvideo/next' there?
The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvcvideo/next

for you to fetch changes up to a1bee5f9f606f89ff30171658a82bf532cca7f3d:

  uvcvideo: Return all buffers to vb2 at stream stop and start failure 
(2014-11-07 08:13:21 +0200)

> >> You should, instead, create a local branch and push it upstream.
> > 
> > I've done that, the problem is that the local and remote branches have
> > different names.
> 
> No problem. Git request-pull would automatically detect the remote branch
> that has the changeset associated with the local branch that you're
> requesting to pull. It probably uses the push config at your .git/config.

It seems like it did before I upgraded to 2.0.4, but not anymore.

> The names I use on my local repository also don't match the ones at the
> public repository.
> 
> > I should of course have read the latest git-request-pull man page and run
> > 
> > 	git request-pull local-linuxtv-master media uvcvideo/next:uvc/next
> > 
> > That works fine.
> 
> Yeah, you could force it, but no need if your .git/config has already a
> push line like the above.

[snip]

-- 
Regards,

Laurent Pinchart

