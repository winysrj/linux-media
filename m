Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7E5C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 989772070B
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="VpeHHJgU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfBUOPY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:15:24 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42829 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfBUOPY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:15:24 -0500
Received: by mail-ed1-f67.google.com with SMTP id j89so13855674edb.9
        for <linux-media@vger.kernel.org>; Thu, 21 Feb 2019 06:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1+2akAeOBDxt2US2WUvmBIOJ4VmYS9nLVjyC6PsJqK0=;
        b=VpeHHJgUWR4zbM/VgObyCv1i55w4YWDcTPDX3A97BnwLLYG2+hpbKD6dn4f9hvp1of
         vI/rhavha42p983NF1sIUDNaqyUVhQFfnIbh2d/0MGkSCSTMKXgw7nYePCgnqzetTonj
         dJgXZenU5iAHRw0MCEVL9fhSfmdkd87Pqq2N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1+2akAeOBDxt2US2WUvmBIOJ4VmYS9nLVjyC6PsJqK0=;
        b=he/u2bQQR3thpGDz5d6d/MKNMSGZvXggGUdYPJQ8dezMghnjIlFJGcDK2eWOgq/acl
         mkF4dP+bhWJKvRcigi9W6EZrG+805HvUTcsTVJ3KVesnIi5CAvEbQEIvaUTqbyVmgzdZ
         0BQJuMVKRUBtAOM1LSLznTl3es1aDMo0aCQIiKjjzSlW8WASV9U+2gASzwzYJQd7lUAM
         3ZLDQ14HkeUTKrhQnufva0F7Yr/aYv8l7A4HRAKsySUn8qlYNvBC2i3sbjCKs6B6kOj3
         3cR4y65+3pmAh0ixvp/c/vnJWXQDDOd3UbHwE2HMaaAn8MFnUhe5W9DTE0pchFJZSnue
         cLXA==
X-Gm-Message-State: AHQUAuaEhOJwB9yF0XD5sifWa+IS7M0UkJk+t6KWj1cvKpEL09sDtSwu
        apv3W620YCvuQ3h2Z4tW5faRhQ==
X-Google-Smtp-Source: AHgI3IbMq47utvlVU9q60g7mTSppraDVofojTEw2Fc4a2KD3ukdE2yxc3iHBdw7+GO6BLPVCa6fdKA==
X-Received: by 2002:a17:906:a49:: with SMTP id x9mr27161486ejf.186.1550758521445;
        Thu, 21 Feb 2019 06:15:21 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id f1sm4931475ejl.65.2019.02.21.06.15.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 06:15:20 -0800 (PST)
Date:   Thu, 21 Feb 2019 15:15:18 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        nd <nd@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Message-ID: <20190221141518.GR2665@phenom.ffwll.local>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
 <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
 <20190221100257.GD3451@pendragon.ideasonboard.com>
 <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
X-Operating-System: Linux phenom 4.19.0-1-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 21, 2019 at 12:19:13PM +0000, Brian Starkey wrote:
> Hi Laurent,
> 
> On Thu, Feb 21, 2019 at 12:02:57PM +0200, Laurent Pinchart wrote:
> > Hi Brian,
> > 
> > On Thu, Feb 21, 2019 at 09:50:19AM +0000, Brian Starkey wrote:
> > > On Thu, Feb 21, 2019 at 10:23:17AM +0200, Laurent Pinchart wrote:
> > > > On Mon, Feb 18, 2019 at 12:22:58PM +0000, Brian Starkey wrote:
> > > >> On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> > > >>> Hello,
> > > >>> 
> > > >>> This patch series implements display writeback support for the R-Car
> > > >>> Gen3 platforms in the VSP1 driver.
> > > >>> 
> > > >>> DRM/KMS provides a writeback API through a special type of writeback
> > > >>> connectors. This series takes a different approach by exposing writeback
> > > >>> as a V4L2 device. While there is nothing fundamentally wrong with
> > > >>> writeback connectors, display for R-Car Gen3 platforms relies on the
> > > >>> VSP1 driver behind the scene, which already implements V4L2 support.
> > > >>> Enabling writeback through V4L2 is thus significantly easier in this
> > > >>> case.
> > > >> 
> > > >> How does this look to an application? (I'm entirely ignorant about
> > > >> R-Car). They are interacting with the DRM device, and then need to
> > > >> open and configure a v4l2 device to get the writeback? Can the process
> > > >> which isn't controlling the DRM device independently capture the
> > > >> screen output?
> > > >> 
> > > >> I didn't see any major complication to implementing this as a
> > > >> writeback connector. If you want/need to use the vb2_queue, couldn't
> > > >> you just do that entirely from within the kernel?
> > > >> 
> > > >> Honestly (predictably?), to me it seems like a bad idea to introduce a
> > > >> second, non-compatible interface for display writeback. Any
> > > >> application interested in display writeback (e.g. compositors) will
> > > >> need to implement both in order to support all HW. drm_hwcomposer
> > > >> already supports writeback via DRM writeback connectors.
> > > >> 
> > > >> While I can see the advantages of having writeback exposed via v4l2
> > > >> for streaming use-cases, I think it would be better to have it done in
> > > >> such a way that it works for all writeback connectors, rather than
> > > >> being VSP1-specific. That would allow any application to choose
> > > >> whichever method is most appropriate for their use-case, without
> > > >> limiting themselves to a subset of hardware.
> > > > 
> > > > So I gave writeback connectors a go, and it wasn't very pretty.
> > > 
> > > Sorry you didn't have a good time :-(
> > 
> > No worries. That was to be expected with such young code :-)
> > 
> > > > There writeback support in the DRM core leaks jobs,
> > > 
> > > Is this the cleanup on check fail, or something else?
> > 
> > Yes, that's the problem. I have patches for it that I will post soon.
> > 
> > > One possible pitfall is that you must set the job in the connector
> > > state to NULL after you call drm_writeback_queue_job(). The API there
> > > could easily be changed to pass in the connector_state and clear it in
> > > drm_writeback_queue_job() instead of relying on drivers to do it.
> > 
> > I also have a patch for that :-)
> > 
> > > > and is missing support for
> > > > the equivalent of .prepare_fb()/.cleanup_fb(), which requires per-job
> > > > driver-specific data. I'm working on these issues and will submit
> > > > patches.
> > > 
> > > Hm, yes that didn't occur to me; we don't have a prepare_fb callback.
> > > 
> > > > In the meantime, I need to test my implementation, so I need a command
> > > > line application that will let me exercise the API. I assume you've
> > > > tested your code, haven't you ? :-) Could you tell me how I can test
> > > > writeback ?
> > > 
> > > Indeed, there's igts on the list which I wrote and tested:
> > > 
> > > https://patchwork.kernel.org/patch/10764975/
> > 
> > Will you get these merged ? Pushing everybody to use the writeback
> > connector API without any test is mainline isn't nice, it almost makes
> > me want to go back to V4L2.
> 
> I wasn't trying to be pushy - I only shared my opinion that I didn't
> think it was a good idea to introduce a second display writeback API,
> when we already have one. You're entirely entitled to ignore my
> opinion.
> 
> The tests have been available since the very early versions of the
> writeback series. I don't know what's blocking them from merging, I
> haven't been tracking it very closely.
> 
> If you'd be happy to provide your review and test on them, that may
> help the process along?
> 
> > 
> > igt test cases are nice to have, but what I need now is a tool to
> > execise the API manually, similar to modetest, with command line
> > parameters to configure the device, and the ability to capture frames to
> > disk using writeback. How did you perform such tests when you developed
> > writeback support ?
> > 
> 
> I used a pre-existing internal tool which does exactly that.
> 
> I appreciate that we don't have upstream tooling for writeback. As you
> say, it's a young API (well, not by date, but certainly by usage).
> 
> I also do appreciate you taking the time to consider it, identifying
> issues which we did not, and for fixing them. The only way it stops
> being a young API, with bugs and no tooling, is if people adopt it.

Mentioned on irc already to Laurent, but here for completeness: igt has
pretty decent support for combining that into one utility. We support
piles of standard stuff like --interactive-debug already, plus you can add
whatever additional things you need and feel like. There's quite a few
such igt tests/tools combinations already.
-Daniel

> 
> Thanks,
> -Brian
> 
> > > And there's support in drm_hwcomposer (though I must admit I haven't
> > > personally run the drm_hwc code):
> > > 
> > > https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer/merge_requests/3
> > 
> > That won't help me much as I don't have an android port for the R-Car
> > boards.
> > 
> > > I'm afraid I haven't really touched any of the writeback code for a
> > > couple of years - Liviu picked that up. He's on holiday until Monday,
> > > but he should be able to help with the status of the igts.
> > > 
> > > Hope that helps,
> > > 
> > > >>> The writeback pixel format is restricted to RGB, due to the VSP1
> > > >>> outputting RGB to the display and lacking a separate colour space
> > > >>> conversion unit for writeback. The resolution can be freely picked by
> > > >>> will result in cropping or composing, not scaling.
> > > >>> 
> > > >>> Writeback requests are queued to the hardware on page flip (atomic
> > > >>> flush), and complete at the next vblank. This means that a queued
> > > >>> writeback buffer will not be processed until the next page flip, but
> > > >>> once it starts being written to by the VSP, it will complete at the next
> > > >>> vblank regardless of whether another page flip occurs at that time.
> > > >> 
> > > >> This sounds the same as mali-dp, and so fits directly with the
> > > >> semantics of writeback connectors.
> > > >> 
> > > >>> The code is based on a merge of the media master branch, the drm-next
> > > >>> branch and the R-Car DT next branch. For convenience patches can be
> > > >>> found at
> > > >>> 
> > > >>> 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
> > > >>> 
> > > >>> Kieran Bingham (2):
> > > >>>   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> > > >>>   media: vsp1: Provide a writeback video device
> > > >>> 
> > > >>> Laurent Pinchart (5):
> > > >>>   media: vsp1: wpf: Fix partition configuration for display pipelines
> > > >>>   media: vsp1: Replace leftover occurrence of fragment with body
> > > >>>   media: vsp1: Fix addresses of display-related registers for VSP-DL
> > > >>>   media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
> > > >>>   media: vsp1: Replace the display list internal flag with a flags field
> > > >>> 
> > > >>>  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
> > > >>>  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
> > > >>>  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
> > > >>>  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
> > > >>>  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
> > > >>>  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
> > > >>>  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
> > > >>>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
> > > >>>  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++----
> > > >>>  drivers/media/platform/vsp1/vsp1_video.h |   6 +
> > > >>>  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
> > > >>>  11 files changed, 378 insertions(+), 75 deletions(-)
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
