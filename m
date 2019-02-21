Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7EEC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 12:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92A6D2086C
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 12:23:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="BUn2D8Wj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbfBUMXR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:23:17 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:34366 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfBUMXR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 07:23:17 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EF0F6255;
        Thu, 21 Feb 2019 13:23:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550751795;
        bh=GKBgYnKnBU11QpI2BE+fe6xrIR7p1f9uyEHoIV/nBXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUn2D8Wj6K1JudmnO/PFHFZ23ddz+Tt2NYJmckvaTQ+LAl8Xodx4T/KtRtokMbFHf
         VCaE+S20cUJLulJUaKq4K1hFez3xJlxBnVdLcb8jMu8HGksahMzL5bjSS1ZI0veAIM
         9KACjgrdnq7ynbteiFFw61glE3ChvbMYLcVISTSA=
Date:   Thu, 21 Feb 2019 14:23:10 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Message-ID: <20190221122310.GM3451@pendragon.ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
 <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
 <20190221100257.GD3451@pendragon.ideasonboard.com>
 <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Brian,

On Thu, Feb 21, 2019 at 12:19:13PM +0000, Brian Starkey wrote:
> On Thu, Feb 21, 2019 at 12:02:57PM +0200, Laurent Pinchart wrote:
> > On Thu, Feb 21, 2019 at 09:50:19AM +0000, Brian Starkey wrote:
> >> On Thu, Feb 21, 2019 at 10:23:17AM +0200, Laurent Pinchart wrote:
> >>> On Mon, Feb 18, 2019 at 12:22:58PM +0000, Brian Starkey wrote:
> >>>> On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> >>>>> Hello,
> >>>>> 
> >>>>> This patch series implements display writeback support for the R-Car
> >>>>> Gen3 platforms in the VSP1 driver.
> >>>>> 
> >>>>> DRM/KMS provides a writeback API through a special type of writeback
> >>>>> connectors. This series takes a different approach by exposing writeback
> >>>>> as a V4L2 device. While there is nothing fundamentally wrong with
> >>>>> writeback connectors, display for R-Car Gen3 platforms relies on the
> >>>>> VSP1 driver behind the scene, which already implements V4L2 support.
> >>>>> Enabling writeback through V4L2 is thus significantly easier in this
> >>>>> case.
> >>>> 
> >>>> How does this look to an application? (I'm entirely ignorant about
> >>>> R-Car). They are interacting with the DRM device, and then need to
> >>>> open and configure a v4l2 device to get the writeback? Can the process
> >>>> which isn't controlling the DRM device independently capture the
> >>>> screen output?
> >>>> 
> >>>> I didn't see any major complication to implementing this as a
> >>>> writeback connector. If you want/need to use the vb2_queue, couldn't
> >>>> you just do that entirely from within the kernel?
> >>>> 
> >>>> Honestly (predictably?), to me it seems like a bad idea to introduce a
> >>>> second, non-compatible interface for display writeback. Any
> >>>> application interested in display writeback (e.g. compositors) will
> >>>> need to implement both in order to support all HW. drm_hwcomposer
> >>>> already supports writeback via DRM writeback connectors.
> >>>> 
> >>>> While I can see the advantages of having writeback exposed via v4l2
> >>>> for streaming use-cases, I think it would be better to have it done in
> >>>> such a way that it works for all writeback connectors, rather than
> >>>> being VSP1-specific. That would allow any application to choose
> >>>> whichever method is most appropriate for their use-case, without
> >>>> limiting themselves to a subset of hardware.
> >>> 
> >>> So I gave writeback connectors a go, and it wasn't very pretty.
> >> 
> >> Sorry you didn't have a good time :-(
> > 
> > No worries. That was to be expected with such young code :-)
> > 
> >>> There writeback support in the DRM core leaks jobs,
> >> 
> >> Is this the cleanup on check fail, or something else?
> > 
> > Yes, that's the problem. I have patches for it that I will post soon.
> > 
> >> One possible pitfall is that you must set the job in the connector
> >> state to NULL after you call drm_writeback_queue_job(). The API there
> >> could easily be changed to pass in the connector_state and clear it in
> >> drm_writeback_queue_job() instead of relying on drivers to do it.
> > 
> > I also have a patch for that :-)
> > 
> >>> and is missing support for
> >>> the equivalent of .prepare_fb()/.cleanup_fb(), which requires per-job
> >>> driver-specific data. I'm working on these issues and will submit
> >>> patches.
> >> 
> >> Hm, yes that didn't occur to me; we don't have a prepare_fb callback.
> >> 
> >>> In the meantime, I need to test my implementation, so I need a command
> >>> line application that will let me exercise the API. I assume you've
> >>> tested your code, haven't you ? :-) Could you tell me how I can test
> >>> writeback ?
> >> 
> >> Indeed, there's igts on the list which I wrote and tested:
> >> 
> >> https://patchwork.kernel.org/patch/10764975/
> > 
> > Will you get these merged ? Pushing everybody to use the writeback
> > connector API without any test is mainline isn't nice, it almost makes
> > me want to go back to V4L2.
> 
> I wasn't trying to be pushy - I only shared my opinion that I didn't
> think it was a good idea to introduce a second display writeback API,
> when we already have one. You're entirely entitled to ignore my
> opinion.

I agree we should aim for a single API. My preference would have been
for V4L2 universally, but now that we have writeback connectors
upstream, the choice has been made, so we should stick to it.

> The tests have been available since the very early versions of the
> writeback series. I don't know what's blocking them from merging, I
> haven't been tracking it very closely.
> 
> If you'd be happy to provide your review and test on them, that may
> help the process along?

Now that I've sent an entirely untested patch series out, this is next
on my list :-)

> > igt test cases are nice to have, but what I need now is a tool to
> > execise the API manually, similar to modetest, with command line
> > parameters to configure the device, and the ability to capture frames to
> > disk using writeback. How did you perform such tests when you developed
> > writeback support ?
> 
> I used a pre-existing internal tool which does exactly that.

Any hope of sharing the sources ?

> I appreciate that we don't have upstream tooling for writeback. As you
> say, it's a young API (well, not by date, but certainly by usage).
> 
> I also do appreciate you taking the time to consider it, identifying
> issues which we did not, and for fixing them. The only way it stops
> being a young API, with bugs and no tooling, is if people adopt it.

If the developers who initially pushed the API upstream without an
open-source test tool could spend a bit of time on this issue, I'm sure
it would help too :-)

> >> And there's support in drm_hwcomposer (though I must admit I haven't
> >> personally run the drm_hwc code):
> >> 
> >> https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer/merge_requests/3
> > 
> > That won't help me much as I don't have an android port for the R-Car
> > boards.
> > 
> >> I'm afraid I haven't really touched any of the writeback code for a
> >> couple of years - Liviu picked that up. He's on holiday until Monday,
> >> but he should be able to help with the status of the igts.
> >> 
> >> Hope that helps,
> >> 
> >>>>> The writeback pixel format is restricted to RGB, due to the VSP1
> >>>>> outputting RGB to the display and lacking a separate colour space
> >>>>> conversion unit for writeback. The resolution can be freely picked by
> >>>>> will result in cropping or composing, not scaling.
> >>>>> 
> >>>>> Writeback requests are queued to the hardware on page flip (atomic
> >>>>> flush), and complete at the next vblank. This means that a queued
> >>>>> writeback buffer will not be processed until the next page flip, but
> >>>>> once it starts being written to by the VSP, it will complete at the next
> >>>>> vblank regardless of whether another page flip occurs at that time.
> >>>> 
> >>>> This sounds the same as mali-dp, and so fits directly with the
> >>>> semantics of writeback connectors.
> >>>> 
> >>>>> The code is based on a merge of the media master branch, the drm-next
> >>>>> branch and the R-Car DT next branch. For convenience patches can be
> >>>>> found at
> >>>>> 
> >>>>> 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
> >>>>> 
> >>>>> Kieran Bingham (2):
> >>>>>   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> >>>>>   media: vsp1: Provide a writeback video device
> >>>>> 
> >>>>> Laurent Pinchart (5):
> >>>>>   media: vsp1: wpf: Fix partition configuration for display pipelines
> >>>>>   media: vsp1: Replace leftover occurrence of fragment with body
> >>>>>   media: vsp1: Fix addresses of display-related registers for VSP-DL
> >>>>>   media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
> >>>>>   media: vsp1: Replace the display list internal flag with a flags field
> >>>>> 
> >>>>>  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
> >>>>>  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
> >>>>>  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
> >>>>>  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
> >>>>>  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
> >>>>>  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++----
> >>>>>  drivers/media/platform/vsp1/vsp1_video.h |   6 +
> >>>>>  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
> >>>>>  11 files changed, 378 insertions(+), 75 deletions(-)

-- 
Regards,

Laurent Pinchart
