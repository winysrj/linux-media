Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45722 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129AbcAYKT0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 05:19:26 -0500
Date: Mon, 25 Jan 2016 08:19:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.5] Renesas VSP1 improvements and fixes
Message-ID: <20160125081916.4d48a59a@recife.lan>
In-Reply-To: <10952932.anBPshRnSs@avalon>
References: <3880424.K6feHa190s@avalon>
	<7908253.mS4kyImJeJ@avalon>
	<20160111101137.30d31746@recife.lan>
	<10952932.anBPshRnSs@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 11 Jan 2016 17:12:28 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday 11 January 2016 10:11:37 Mauro Carvalho Chehab wrote:
> > Em Wed, 06 Jan 2016 12:05:34 +0200 Laurent Pinchart escreveu:  
> > > Hi Mauro,
> > > 
> > > I think this one slipped through the cracks, or possibly got buried under
> > > the winter holidays snowstorm :-) Could you tell me what your plans are ?  
> >
> > Actually, I got vacations just after holidays. I'm still on vacations, but
> > I'm doing a short break on my vacations today to handle a few things.  
> 
> Try to make the break very short :-)
> 
> > Unfortunately, it is too late to review this for the 4.5 merge window.
> > So, it should be postponed.  
> 
> I had feared so. It's a bit unfortunate as the series is a dependency for a 
> DRM pull request I want to send for v4.6. That's not a very big deal, but it 
> will mean we will have to provide a stable branch. Could I ask you to merge it 
> early after the merge window closes to give me enough time to deal with the 
> DRM side ?

There are lots of non-trivial conflicts with VSP1 and upstream,
probably because you didn't base it on the media-controller topic
branch.

Please rebase and send a new pull request.

Regards,
Mauro

> 
