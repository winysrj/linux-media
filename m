Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51550 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0ASNMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 08:12:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Tue, 19 Jan 2010 14:12:38 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org> <201001191356.48403.laurent.pinchart@ideasonboard.com> <4B55AE9B.2030301@infradead.org>
In-Reply-To: <4B55AE9B.2030301@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191412.38617.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 19 January 2010 14:07:39 Mauro Carvalho Chehab wrote:
> Laurent Pinchart wrote:
> > Hi Mauro,
> >
> > I've started playing with the linuxtv git repositories. I've cloned v4l-
> > dvb.git into git://linuxtv.org/pinchartl/uvcvideo.git using git-menu and
> > now have trouble pushing changes:
> >
> > $ git push -v uvcvideo
> > Pushing to git://linuxtv.org/pinchartl/uvcvideo.git
> > fatal: The remote end hung up unexpectedly
> >
> > What URL should I use to push changes ?
> 
> Push will only work if you use the ssh url. the url is basically the same
> of http, but replacing to ssh:
> 	ssh://linuxtv.org/git/<tree>
> 
> On your case
> 	ssh://linuxtv.org/git/pinchartl/uvcvideo.git

One step further:

$ git push -v uvcvideo
Pushing to ssh://linuxtv.org/git/pinchartl/uvcvideo.git
Permission denied (publickey).
fatal: The remote end hung up unexpectedly

Do I need to upload my public key somewhere ? I already use it with hg push 
(and ssh git-menu) without any issue.

-- 
Cheers,

Laurent Pinchart
