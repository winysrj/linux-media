Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37890 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbbLKVF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 16:05:28 -0500
Date: Fri, 11 Dec 2015 19:05:22 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuah.kh@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: Media Controller patches
Message-ID: <20151211190522.4e4d62a0@recife.lan>
In-Reply-To: <20151210183411.3d15a819@recife.lan>
References: <20151210183411.3d15a819@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Dec 2015 18:34:11 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi,
> 
> I've been working during this week to address the issues pointed during
> the Media Controller really long review process. We should avoid taking
> so long to review patches in the future, as it is really painful to
> go back to the already done work 4/5/7 months after the patchsets
> (yes, there are patches here written 7 months ago that were only
> very recently reviewed!). Shame on us.
> 
> Anyway, The reviewed patches are now at the media-controller topic
> branch, at the main tree.
> 
> I took the care of recompiling and automatically doing runtime tests
> with KASAN enabled, patch by patch, in order to be sure that the
> MC is in a sane state. I also ran kmemleak, and was unable to identify
> any troubles associated with the MC next gen rework.
> 
> So, the media-controller topic branch looks sane to me. It should be
> noticed that there are several items on a TODO list to be addressed
> before being able to merge this branch back at the master branch.
> 
> Please notice that patch 22 was removed from this series:
> 	Subject: [media] uapi/media.h: Declare interface types for ALSA
> 
> The idea is that this patch should be part of the patches that Shuah
> will submit and that requires review from the ALSA community before
> being merged.
> 
> Javier and me will start tomorrow on working on the pending items.
> 
> My goal is to have everything needed for Kernel 4.5 merge window
> done up to the next week.
> 
> ---
> 
> The current TODO list, based on the per-patch review is:

As far as I checked, all issues at the TODO for Kernel 4.5 were
already addressed, except for one item:

- Add documentation for the uAPI.

I'll address this last item tomorrow.

The patches that addressed the TODO list were sent already to the ML,
on a few independent patch series.

They're all (including the Javier ones) applied on my experimental
tree at branch media-controller-rc3:
	git://linuxtv.org/mchehab/experimental.git media-controller-rc3

The userspace testing tool was also modified for the MC next gen,
at the branch mc-next-gen-v2:
	git://linuxtv.org/mchehab/experimental-v4l-utils.git mc-next-gen-v2



Please let me know if something else got missed ASAP, as I'll be 
addressing any missing stuff during this weekend.

My goal is to merge those patches at the main development branch
this Monday.

NOTE:
====

The TODO list are hosted at: https://etherpad.fr

	The original one is on the above site, at: /p/mc-v2-todo
	And we added a new version on the same site, at: /p/mc-v2-todo-v2

Things that got postponed to other Kernel versions:
===================================================

1) Sakari: Rethink about media-entity.h name;
2) Laurent: do a non-hacking version of the pad/subdev switch logic (waiting for Laurent's comment on this one);
3) Should address on a later series the changes to remove MEDIA_ENT_T_SUBDEV_UNKNOWN;
4) Laurent: All exported API functions need kerneldoc. (most are. There are a few less used that needs documentation, like the __foo functions);
5) Laurent: remove major/minor fields from entities

6) Remove unused fields from media_entity (major, minor, num_links, num_backlinks, num_pads)
7) dynamic entity/interface/link creation and removal;
8) SETUP_LINK_V2 with dynamic support;
9) dynamic pad creation and removal (needed?);
10) multiple function per entity support;
11) indirect interface links support;
12) MC properties API.

Userspace TODO:
==============

1) Create a library with v2 API;
2) Use the v2 API library on qv4l2/libdvbv5/xawtv/libv4l;

Regards,
Mauro
