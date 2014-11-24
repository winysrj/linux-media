Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50250 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaKXJG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:06:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR v3.19] uvcvideo changes
Date: Mon, 24 Nov 2014 11:06:49 +0200
Message-ID: <2578174.1LaTmadn8H@avalon>
In-Reply-To: <20141111085626.3f1201dc@recife.lan>
References: <1524049.TLSF8qZEUD@avalon> <20141111085626.3f1201dc@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 11 November 2014 08:56:26 Mauro Carvalho Chehab wrote:
> Em Fri, 07 Nov 2014 08:16:28 +0200 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 
4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
> >   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next
> 
> It seems that there's something weird with this URL... remotes????

git isn't playing nicely :-/

I've pushed the changes to the uvc/next branch on 
git://linuxtv.org/pinchartl/media.git, up to commit a1bee5f9f606. 
http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/commit/?h=uvc/next 
confirms that everything is in order.

However, running

git request-pull local-linuxtv-master media remotes/media/uvc/next

with the media remote pointing to git://linuxtv.org/pinchartl/media.git 
generates

----------
warn: No match for commit a1bee5f9f606f89ff30171658a82bf532cca7f3d found at 
git://linuxtv.org/pinchartl/media.git
warn: Are you sure you pushed 'remotes/media/uvc/next' there?
The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next

for you to fetch changes up to a1bee5f9f606f89ff30171658a82bf532cca7f3d:

  uvcvideo: Return all buffers to vb2 at stream stop and start failure 
(2014-11-07 08:13:21 +0200)
----------

For some reason git can't find the remote branch (hence the warning) and thus 
generates the URL line incorrectly.

I've tried upgrading from git 2.0.4 to git 2.1.3 but the problem is still 
present. Creating a local branch named uvc/next fixes the problem. I wonder if 
I'm doing something really stupid or if it's a git bug.

Can you pull from

        git://linuxtv.org/pinchartl/media.git uvc/next

? I haven't updated the branch since I've sent the last pull request.

-- 
Regards,

Laurent Pinchart

