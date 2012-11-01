Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1643 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab2KAPp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 11:45:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Thu, 1 Nov 2012 16:44:50 +0100
Cc: media-workshop@linuxtv.org,
	"linux-media" <linux-media@vger.kernel.org>
References: <201210221035.56897.hverkuil@xs4all.nl> <20121025152701.0f4145c8@redhat.com>
In-Reply-To: <20121025152701.0f4145c8@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211011644.50882.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu October 25 2012 19:27:01 Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Mon, 22 Oct 2012 10:35:56 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi all,
> > 
> > This is the tentative agenda for the media workshop on November 8, 2012.
> > If you have additional things that you want to discuss, or something is wrong
> > or incomplete in this list, please let me know so I can update the list.
> 
> Thank you for taking care of it.
> 
> > - Explain current merging process (Mauro)
> > - Open floor for discussions on how to improve it (Mauro)
> > - Write down minimum requirements for new V4L2 (and DVB?) drivers, both for
> >   staging and mainline acceptance: which frameworks to use, v4l2-compliance,
> >   etc. (Hans Verkuil)
> > - V4L2 ambiguities (Hans Verkuil)
> > - TSMux device (a mux rather than a demux): Alain Volmat
> > - dmabuf status, esp. with regards to being able to test (Mauro/Samsung)
> > - Device tree support (Guennadi, not known yet whether this topic is needed)
> > - Creating/selecting contexts for hardware that supports this (Samsung, only
> >   if time is available)
> 
> I have an extra theme for discussions there: what should we do with the drivers
> that don't have any MAINTAINERS entry.

I've added this topic to the list.

> It probably makes sense to mark them as "Orphan" (or, at least, have some
> criteria to mark them as such). Perhaps before doing that, we could try
> to see if are there any developer at the community with time and patience
> to handle them.
> 
> This could of course be handled as part of the discussions about how to improve
> the merge process, but I suspect that this could generate enough discussions
> to be handled as a separate theme.

Do we have a 'Maintainer-Light' category? I have a lot of hardware that I can
test. So while I wouldn't like to be marked as 'The Maintainer of driver X'
(since I simply don't have the time for that), I wouldn't mind being marked as
someone who can at least test patches if needed.

> There are some issues by not having a MAINTAINERS entry:
> 	- patches may not flow into the driver maintainer;
> 	- patches will likely be applied without tests/reviews or may
> 	  stay for a long time queued;
> 	- ./scripts/get_maintainer.pl at --no-git-fallback won't return
> 	  any maintainer[1].
> 
> [1] Letting get_maintainer.pl is very time/CPU consuming. Letting it would 
> delay a lot the patch review process, if applied for every patch, with
> unreliable and doubtful results. I don't do it, due to the large volume
> of patches, and because the 'other' results aren't typically the driver
> maintainer.
> 
> An example of this is the results for a patch I just applied
> (changeset 2866aed103b915ca8ba0ff76d5790caea4e62ced):
> 
> 	$ git show --pretty=email|./scripts/get_maintainer.pl
> 	Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:7/7=100%)
> 	Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/7=57%)
> 	Anatolij Gustschin <agust@denx.de> (commit_signer:1/7=14%)
> 	Wei Yongjun <yongjun_wei@trendmicro.com.cn> (commit_signer:1/7=14%)
> 	Hans de Goede <hdegoede@redhat.com> (commit_signer:1/7=14%)
> 	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
> 	linux-kernel@vger.kernel.org (open list)
> 
> According with this driver's copyrights:
> 
>  * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
>  *
>  *  Freescale VIU video driver
>  *
>  *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
>  *	     Porting to 2.6.35 by DENX Software Engineering,
>  *	     Anatolij Gustschin <agust@denx.de>
> 
> The driver author (Hongjun Chen <hong-jun.chen@freescale.com>) was not even
> shown there, and the co-author got only 15% hit, while I got 100% and Hans
> got 57%.
> 
> This happens not only to this driver. In a matter of fact, on most cases where
> no MAINTAINERS entry exist, the driver's author gets a very small hit chance,
> as, on several of those drivers, the author doesn't post anything else but
> the initial patch series.

We probably need to have an entry for all the media drivers, even if it just
points to the linux-media mailinglist as being the 'collective default maintainer'.

A MAINTAINERS entry should probably be required as well for new drivers.

Regards,

	Hans
