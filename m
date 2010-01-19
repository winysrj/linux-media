Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0ASNHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 08:07:48 -0500
Message-ID: <4B55AE9B.2030301@infradead.org>
Date: Tue, 19 Jan 2010 11:07:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001191356.48403.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001191356.48403.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Mauro,
> 
> I've started playing with the linuxtv git repositories. I've cloned v4l-
> dvb.git into git://linuxtv.org/pinchartl/uvcvideo.git using git-menu and now 
> have trouble pushing changes:
> 
> $ git push -v uvcvideo
> Pushing to git://linuxtv.org/pinchartl/uvcvideo.git
> fatal: The remote end hung up unexpectedly
> 
> What URL should I use to push changes ? 
> 
Push will only work if you use the ssh url. the url is basically the same
of http, but replacing to ssh:
	ssh://linuxtv.org/git/<tree>

On your case
	ssh://linuxtv.org/git/pinchartl/uvcvideo.git

Cheers,
Mauro.
