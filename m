Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab2JYR1I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 13:27:08 -0400
Date: Thu, 25 Oct 2012 15:27:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
Message-ID: <20121025152701.0f4145c8@redhat.com>
In-Reply-To: <201210221035.56897.hverkuil@xs4all.nl>
References: <201210221035.56897.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Mon, 22 Oct 2012 10:35:56 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> This is the tentative agenda for the media workshop on November 8, 2012.
> If you have additional things that you want to discuss, or something is wrong
> or incomplete in this list, please let me know so I can update the list.

Thank you for taking care of it.

> - Explain current merging process (Mauro)
> - Open floor for discussions on how to improve it (Mauro)
> - Write down minimum requirements for new V4L2 (and DVB?) drivers, both for
>   staging and mainline acceptance: which frameworks to use, v4l2-compliance,
>   etc. (Hans Verkuil)
> - V4L2 ambiguities (Hans Verkuil)
> - TSMux device (a mux rather than a demux): Alain Volmat
> - dmabuf status, esp. with regards to being able to test (Mauro/Samsung)
> - Device tree support (Guennadi, not known yet whether this topic is needed)
> - Creating/selecting contexts for hardware that supports this (Samsung, only
>   if time is available)

I have an extra theme for discussions there: what should we do with the drivers
that don't have any MAINTAINERS entry.

It probably makes sense to mark them as "Orphan" (or, at least, have some
criteria to mark them as such). Perhaps before doing that, we could try
to see if are there any developer at the community with time and patience
to handle them.

This could of course be handled as part of the discussions about how to improve
the merge process, but I suspect that this could generate enough discussions
to be handled as a separate theme.

There are some issues by not having a MAINTAINERS entry:
	- patches may not flow into the driver maintainer;
	- patches will likely be applied without tests/reviews or may
	  stay for a long time queued;
	- ./scripts/get_maintainer.pl at --no-git-fallback won't return
	  any maintainer[1].

[1] Letting get_maintainer.pl is very time/CPU consuming. Letting it would 
delay a lot the patch review process, if applied for every patch, with
unreliable and doubtful results. I don't do it, due to the large volume
of patches, and because the 'other' results aren't typically the driver
maintainer.

An example of this is the results for a patch I just applied
(changeset 2866aed103b915ca8ba0ff76d5790caea4e62ced):

	$ git show --pretty=email|./scripts/get_maintainer.pl
	Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:7/7=100%)
	Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/7=57%)
	Anatolij Gustschin <agust@denx.de> (commit_signer:1/7=14%)
	Wei Yongjun <yongjun_wei@trendmicro.com.cn> (commit_signer:1/7=14%)
	Hans de Goede <hdegoede@redhat.com> (commit_signer:1/7=14%)
	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
	linux-kernel@vger.kernel.org (open list)

According with this driver's copyrights:

 * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
 *
 *  Freescale VIU video driver
 *
 *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
 *	     Porting to 2.6.35 by DENX Software Engineering,
 *	     Anatolij Gustschin <agust@denx.de>

The driver author (Hongjun Chen <hong-jun.chen@freescale.com>) was not even
shown there, and the co-author got only 15% hit, while I got 100% and Hans
got 57%.

This happens not only to this driver. In a matter of fact, on most cases where
no MAINTAINERS entry exist, the driver's author gets a very small hit chance,
as, on several of those drivers, the author doesn't post anything else but
the initial patch series.

Regards,
Mauro
