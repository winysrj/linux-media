Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab1EQSfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 14:35:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [RFC] drm: add overlays as first class KMS objects
Date: Tue, 17 May 2011 20:35:42 +0200
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	dri-devel@lists.freedesktop.org, "Clark, Rob" <rob@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <20110425151220.2f5dc17a@jbarnes-desktop> <BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
In-Reply-To: <BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105172035.42566.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel,

On Friday 13 May 2011 18:16:30 Daniel Vetter wrote:
> Hi Jesse,
> 
> Discussion here in Budapest with v4l and embedded graphics folks was
> extremely fruitful. A few quick things to take away - I'll try to dig
> through all
> the stuff I've learned more in-depth later (probably in a blog post or
> two):
> 
> - embedded graphics is insane. The output routing/blending/whatever
>   currently shipping hw can do is crazy and kms as-is is nowhere near up
>   to snuff to support this. We've discussed omap4 and a ti chip targeted at
>   video surveillance as use cases. I'll post block diagrams and
> explanations some when later.
> - we should immediately stop to call anything an overlay. It's a confusing
>   concept that has a different meaning in every subsystem and for every hw
>   manufacturer. More sensible names are dma fifo engines for things that
> slurp in planes and make them available to the display subsystem. Blend
> engines for blocks that take multiple input pipes and overlay/underlay/blend
> them together. Display subsytem/controller for the aggregate thing including
> encoders/resizers/outputs and especially the crazy routing network that
> connects everything.
> 
> Most of the discussion centered around clearing up the confusion and
> reaching a mutual understanding between desktop graphics, embedded
> graphics and v4l people. Two rough ideas emerged though:
> 
> 1) Splitting the crtc object into two objects: crtc with associated output
> mode (pixel clock, encoders/connectors) and dma engines (possibly
> multiple) that feed it. omap 4 has essentially just 4 dma engines that can
> be freely assigned to the available outputs, so a distinction between
> normal crtcs and overlay engines just does not make sense. There's the
> major open question of where to put the various attributes to set up the
> output pipeline. Also some of these attributes might need to be changed
> atomicly together with pageflips on a bunch of dma engines all associated
> with the same crtc on the next vsync, e.g. output position of an overlaid
> video buffer.

I like that idea. Setting attributes atomically will likely be one of the 
biggest challenge. V4L2 shares the same need, but we haven't had time to 
address it yet.

> 2) The above should be good enough to support halfway sane chips like
> omap4. But hw with more insane routing capabilities that can also use v4l
> devices as sources (even video input connectors) media controller might be
> a good fit. Media controller is designed to expose multimedia pipe routing
> across different subsystem. But the first version, still marked
> experimental, only got merged in .39. We discussed a few ideas as how to
> splice media controller into kms but nothing clear emerged. So a possible
> kms integration with media controller is rather far away.

You're probably right, but far away doesn't mean never. Especially when one of 
the media controller developers is interested in the project and could spend 
time on it :-)

I've started working on a prototype implementation that would use the media 
controller API to report the CRTCs, encoders and connectors topology to 
userspace. The learning curve is pretty steep as I'm not familiar with the DRM 
and KMS code, but the code base turned out to be much easier to dive in than 
it seemed a couple of years ago.

-- 
Regards,

Laurent Pinchart
