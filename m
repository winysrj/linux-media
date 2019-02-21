Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39B8C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 08:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AAE120818
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 08:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="hA/PV4uK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfBUIXY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:23:24 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:55176 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfBUIXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 03:23:24 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0F817255;
        Thu, 21 Feb 2019 09:23:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550737402;
        bh=79pJL4OzZb76gYTmQX/C8HlRAqgUQkuB7qPlrbJhzn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hA/PV4uKz2vi3VzqEKHNkS3Mfl7OGCYPybnAQFhYs7RTFRtmsOKpqTgWb6jkpOUc/
         ZhGd4OMlzSYHLeH/erJig459zxYojSTf6xPDxbfQBjY0XTkHUIL7U3SoBGPWQldARs
         oD7me1t2wlYVy/QgAVn+KMLMawZcEwwGXlBQ4dQo=
Date:   Thu, 21 Feb 2019 10:23:17 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Message-ID: <20190221082317.GB3451@pendragon.ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Brian,

On Mon, Feb 18, 2019 at 12:22:58PM +0000, Brian Starkey wrote:
> On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> > Hello,
> > 
> > This patch series implements display writeback support for the R-Car
> > Gen3 platforms in the VSP1 driver.
> > 
> > DRM/KMS provides a writeback API through a special type of writeback
> > connectors. This series takes a different approach by exposing writeback
> > as a V4L2 device. While there is nothing fundamentally wrong with
> > writeback connectors, display for R-Car Gen3 platforms relies on the
> > VSP1 driver behind the scene, which already implements V4L2 support.
> > Enabling writeback through V4L2 is thus significantly easier in this
> > case.
> 
> How does this look to an application? (I'm entirely ignorant about
> R-Car). They are interacting with the DRM device, and then need to
> open and configure a v4l2 device to get the writeback? Can the process
> which isn't controlling the DRM device independently capture the
> screen output?
> 
> I didn't see any major complication to implementing this as a
> writeback connector. If you want/need to use the vb2_queue, couldn't
> you just do that entirely from within the kernel?
> 
> Honestly (predictably?), to me it seems like a bad idea to introduce a
> second, non-compatible interface for display writeback. Any
> application interested in display writeback (e.g. compositors) will
> need to implement both in order to support all HW. drm_hwcomposer
> already supports writeback via DRM writeback connectors.
> 
> While I can see the advantages of having writeback exposed via v4l2
> for streaming use-cases, I think it would be better to have it done in
> such a way that it works for all writeback connectors, rather than
> being VSP1-specific. That would allow any application to choose
> whichever method is most appropriate for their use-case, without
> limiting themselves to a subset of hardware.

So I gave writeback connectors a go, and it wasn't very pretty. There
writeback support in the DRM core leaks jobs, and is missing support for
the equivalent of .prepare_fb()/.cleanup_fb(), which requires per-job
driver-specific data. I'm working on these issues and will submit
patches.

In the meantime, I need to test my implementation, so I need a command
line application that will let me exercise the API. I assume you've
tested your code, haven't you ? :-) Could you tell me how I can test
writeback ?

> > The writeback pixel format is restricted to RGB, due to the VSP1
> > outputting RGB to the display and lacking a separate colour space
> > conversion unit for writeback. The resolution can be freely picked by
> > will result in cropping or composing, not scaling.
> > 
> > Writeback requests are queued to the hardware on page flip (atomic
> > flush), and complete at the next vblank. This means that a queued
> > writeback buffer will not be processed until the next page flip, but
> > once it starts being written to by the VSP, it will complete at the next
> > vblank regardless of whether another page flip occurs at that time.
> 
> This sounds the same as mali-dp, and so fits directly with the
> semantics of writeback connectors.
> 
> > The code is based on a merge of the media master branch, the drm-next
> > branch and the R-Car DT next branch. For convenience patches can be
> > found at
> > 
> > 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
> > 
> > Kieran Bingham (2):
> >   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> >   media: vsp1: Provide a writeback video device
> > 
> > Laurent Pinchart (5):
> >   media: vsp1: wpf: Fix partition configuration for display pipelines
> >   media: vsp1: Replace leftover occurrence of fragment with body
> >   media: vsp1: Fix addresses of display-related registers for VSP-DL
> >   media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
> >   media: vsp1: Replace the display list internal flag with a flags field
> > 
> >  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
> >  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
> >  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
> >  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
> >  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
> >  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
> >  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
> >  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
> >  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++----
> >  drivers/media/platform/vsp1/vsp1_video.h |   6 +
> >  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
> >  11 files changed, 378 insertions(+), 75 deletions(-)

-- 
Regards,

Laurent Pinchart
