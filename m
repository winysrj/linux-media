Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57274 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205AbbLPRnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:43:43 -0500
Date: Wed, 16 Dec 2015 15:43:37 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuah.kh@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: Media Controller patches
Message-ID: <20151216154337.58f37568@recife.lan>
In-Reply-To: <20151213091250.00df9420@recife.lan>
References: <20151210183411.3d15a819@recife.lan>
	<20151211190522.4e4d62a0@recife.lan>
	<20151213091250.00df9420@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Dec 2015 09:12:50 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 11 Dec 2015 19:05:22 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > Em Thu, 10 Dec 2015 18:34:11 -0200
> > Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> > 
> > > Hi,
> > > 
> > > I've been working during this week to address the issues pointed during
> > > the Media Controller really long review process. We should avoid taking
> > > so long to review patches in the future, as it is really painful to
> > > go back to the already done work 4/5/7 months after the patchsets
> > > (yes, there are patches here written 7 months ago that were only
> > > very recently reviewed!). Shame on us.
> > > 
> > > Anyway, The reviewed patches are now at the media-controller topic
> > > branch, at the main tree.
> > > 
> > > I took the care of recompiling and automatically doing runtime tests
> > > with KASAN enabled, patch by patch, in order to be sure that the
> > > MC is in a sane state. I also ran kmemleak, and was unable to identify
> > > any troubles associated with the MC next gen rework.
> > > 
> > > So, the media-controller topic branch looks sane to me. It should be
> > > noticed that there are several items on a TODO list to be addressed
> > > before being able to merge this branch back at the master branch.
> > > 
> > > Please notice that patch 22 was removed from this series:
> > > 	Subject: [media] uapi/media.h: Declare interface types for ALSA
> > > 
> > > The idea is that this patch should be part of the patches that Shuah
> > > will submit and that requires review from the ALSA community before
> > > being merged.
> > > 
> > > Javier and me will start tomorrow on working on the pending items.
> > > 
> > > My goal is to have everything needed for Kernel 4.5 merge window
> > > done up to the next week.
> > > 
> > > ---
> > > 
> > > The current TODO list, based on the per-patch review is:
> > 
> > As far as I checked, all issues at the TODO for Kernel 4.5 were
> > already addressed, except for one item:
> > 
> > - Add documentation for the uAPI.
> 
> There are actually 3 other items that were not listed at the TODO:
> 
> - Merge of Sakari patches fixing media graph to work with entities
>   with ID > 64;

Done.

> 
> - Use just one counter for the graph ID range. This patch depends on
>   Sakari series;

Done.

> 
> - Merge of Javier patches that split media devnode register from the
>   media_device internal register. Not actually a requirement for
>   MC next gen, as it fixes an already existing race condition, but it
>   will allow almost for free to have topology_version = 0 as the
>   start version, with seems to be a good thing to drivers where the
>   topology is always static;

Done.

> 
> I reviewed both Sakari and Javier series this weekend with a few
> comments.
> 
> > 
> > I'll address this last item tomorrow.
> 
> Item addressed. I also sent some patches fixing some kernel-doc left overs.
> Now, there are only a few set of functions not documented at
> media-entity.h:
> 
> - the ones that will be touched by Sakari patches;
> - two ancillary functions that will be removed when we unify
>   the object ID numberspace.
> 
> I'll review those remaining items after merging Sakari's series.

Done.

As far as I know, all pending items for Kernel 4.5 merge are
complete. I should be moving the remaining patches from my
experimental tree:
	git://linuxtv.org/mchehab/experimental.git media-controller-rc4

to the media-controller topic branch by the end of this week, if
nothing pops up.

Regards,
Mauro
