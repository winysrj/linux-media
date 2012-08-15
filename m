Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2HOKNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 06:13:30 -0400
Date: Wed, 15 Aug 2012 12:13:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	David =?utf-8?q?H=C3=A4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
In-Reply-To: <201208151154.04979.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1208151206030.4024@axis700.grange>
References: <502A4CD1.1020108@redhat.com> <201208141546.19560.hverkuil@xs4all.nl>
 <502A6075.6070606@redhat.com> <201208151154.04979.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 15 Aug 2012, Hans Verkuil wrote:

> On Tue August 14 2012 16:28:05 Mauro Carvalho Chehab wrote:
> > Em 14-08-2012 10:46, Hans Verkuil escreveu:
> > > On Tue August 14 2012 15:04:17 Mauro Carvalho Chehab wrote:
> > 
> > >> A final note: patches from driver maintainers with git trees are generally
> > >> just marked as RFC. Well, I still applied several of them, when they're
> > >> trivial enough and they're seem to be addressing a real bug - helping
> > >> myself to not need to re-review them later.
> > > 
> > > Does that mean that if you are a maintainer with a git tree such as myself
> > > you should make a pull request instead of posting a [PATCH] because otherwise
> > > you mark it as an RFC patch?
> > 
> > Yes, please.
> 
> OK. It would help if you notify all maintainers that you handle in such a manner.
> And perhaps have a list on the wiki as well.
> 
> That way there is no confusion.

I think it goes in line with the common practice:

1. _ALL_ patches have to be posted to mailing lists before appearing in 
any trees to be pushed to Linus. This includes any patches from 
maintainers, something I was asking about for some time now - no ML 
bypassing please! This also means, that you, Mauro, don't have to apply 
any such patches from maintainers with trees, which is exactly what you're 
doing with your RFC attribution.

2. All patches, lying in (sub)maintainer's competence area, have to be 
pushed via their trees, not expecting the upstream maintainer to pick them 
up from patches. This is also what Mauro is imposing now. This is a bit 
less strict, than (1), I think, there can be exceptions, when a single 
patch has to go urgently upstream and the respective (sub)maintainer 
doesn't have an easy way to produce a pull request (e.g., traveling), in 
which case (s)he can just post a patch or, equally, ack someone else's 
patch and ask the upstream maintainer explicitly to apply that patch as an 
exception without waiting for a pull request.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
