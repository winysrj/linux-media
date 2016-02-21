Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62788 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbcBUTZk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 14:25:40 -0500
Date: Sun, 21 Feb 2016 14:01:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
In-Reply-To: <87d1s72bls.fsf@belgarion.home>
Message-ID: <Pine.LNX.4.64.1602211400050.5959@axis700.grange>
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
 <87io5wwahg.fsf@belgarion.home> <Pine.LNX.4.64.1510272306300.21185@axis700.grange>
 <87twpcj6vj.fsf@belgarion.home> <Pine.LNX.4.64.1510291656580.694@axis700.grange>
 <87d1s72bls.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Feb 2016, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Hi Robert,
> >
> > On Tue, 27 Oct 2015, Robert Jarzmik wrote:
> >
> >> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> >> 
> >> > Hi Robert,
> >> >
> >> > Didn't you tell me, that your dmaengine patch got rejected and therefore 
> >> > these your patches were on hold?
> >> They were reverted, and then revamped into DMA_CTRL_REUSE, upstreamed and
> >> merged, as in the commit 272420214d26 ("dmaengine: Add DMA_CTRL_REUSE"). I'd
> >> 
> >> Of course a pending fix is still underway
> >> (http://www.serverphorums.com/read.php?12,1318680). But that shouldn't stop us
> >> from reviewing to get ready to merge.
> >> 
> >> I want this serie to be ready, so that as soon as Vinod merges the fix, I can
> >> ping you to trigger the merge into your tree, without doing (and waiting)
> >> additional review cycles.
> >
> > Thanks, understand now. As we discussed before, correct me if I am wrong, 
> > this is your hobby project. PXA270 is a legacy platform, nobody except you 
> > is interested in this work. I have nothing against hobby projects and I 
> > want to support them as much as I can, but I hope you'll understand, that 
> > I don't have too much free time, so I cannot handle such projects with a 
> > high priority. I understand your desire to process these patches ASAP, 
> > however, I'd like to try to minimise my work too. So, I can propose the 
> > following: let us wait, until your PXA dmaengine patches are _indeed_ in 
> > the mainline. Then you test your camera patches on top of that tree again, 
> > perform any eventually necessary updates and either let me know, that 
> > either your last version is ok and I can now review it, or submit a new 
> > version, that _works_ on top of then current tree.
> 
> Okay Guennadi, I retested this version on top of v4.5-rc2, still good to
> go. There is a minor conflict in the includes since this submission, and I can
> repost a v6 which solves it.

How did you test it with that patchg #3?? What's a minor conflict? If a 
patch doesn't apply at all or applies with a fuzz, yes, please fix. If 
it's just a few lines off, no need to fix that. But you'll do a v6 anyway, 
I assume.

Thanks
Guennadi

> So please tell me how I should proceed, either repost a rebased v6 or take v5 or
> anything else ...
> 
> Cheers.
> 
> --
> Robert
> 
