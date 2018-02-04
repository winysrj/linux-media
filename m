Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49753 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeBDN1A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 08:27:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@s-opensource.com, arnd@arndb.de
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
Date: Sun, 04 Feb 2018 15:27:24 +0200
Message-ID: <2251976.ODMGCFTTdz@avalon>
In-Reply-To: <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
References: <1515925303-5160-1-git-send-email-jasmin@anw.at> <1778442.ouJt2D3mk7@avalon> <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

On Sunday, 4 February 2018 12:37:08 EET Jasmin J. wrote:
> Hi Laurent!
> 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> THX!
> Don't forget the "Acked-by: Arnd Bergmann <arnd@arndb.de>" (see Patchwork:
> https://patchwork.linuxtv.org/patch/46464 ).

Sure.

> > and taken into my tree for v4.17.
> 
> When will this merged to the media-tree trunk?
> In another month or earlier?

As Hans explained, the v4.16 merge window is open. It should close in a week, 
and I'll then send a pull request to Mauro.

> This issue was overlooked when merging the change from Arnd in the first
> place. This broke the Kernel build for older Kernels more than two months
> ago! I fixed that in my holidays expecting this gets merged soon and now
> the build is still broken because of this problem.

I had missed this patch as I wasn't CC'ed, until you pinged me directly. 
Please try to CC me when submitting uvcvideo patches in the future, otherwise 
there's a high chance I won't see them.

> In the past Mauro merged those simple fixes soon and now it seems nobody
> cares about building for older Kernels (it's broken for more than two months
> now!). I mostly try to fix such issues in a short time frame (even on
> vacation), but then it gets lost ... . Sorry, but this is frustrating!
> 
> We don't talk about a nice to have fix but a essential fix to get the media
> build system working again. Such patches need to get merged as early as
> possible in my opinion, especially when someone else sent already an
> "Acked-by" (THX to Arnd).
> 
> I could have made this as a patch in the Build system also, but this would
> be the wrong place, but then Hans would have merged it already and I could
> look into the other build problems.

Strictly speaking, building the media subsystem on older kernels is a job of 
the media build system. In general I would thus ask for the fix to be merged 
in media-build.git. In this specific case, as the mainline code uses both u64 
and ktime_t types, I'm fine with merging your patch to use explicit conversion 
functions in mainline even if the two types are now equivalent. However, as 
this doesn't fix a bug in the mainline kernel, I don't think this patch is a 
candidate for stable releases, and should thus get merged in v4.17. It can 
also be included in media-build.git in order to build kernels that currently 
fail.

-- 
Regards,

Laurent Pinchart
