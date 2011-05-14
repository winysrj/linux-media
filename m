Return-path: <mchehab@gaivota>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41091 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750911Ab1ENBDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 21:03:08 -0400
Date: Fri, 13 May 2011 18:02:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, "Clark, Rob" <rob@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC] drm: add overlays as first class KMS objects
Message-ID: <20110513180256.773ec8aa@jbarnes-desktop>
In-Reply-To: <BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
References: <20110425151220.2f5dc17a@jbarnes-desktop>
	<BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 13 May 2011 18:16:30 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> Hi Jesse,
> 
> Discussion here in Budapest with v4l and embedded graphics folks was
> extremely fruitful. A few quick things to take away - I'll try to dig
> through all
> the stuff I've learned more in-depth later (probably in a blog post or two):
> 
> - embedded graphics is insane. The output routing/blending/whatever
>   currently shipping hw can do is crazy and kms as-is is nowhere near up
>   to snuff to support this. We've discussed omap4 and a ti chip targeted at
>   video surveillance as use cases. I'll post block diagrams and explanations
>   some when later.

Yeah I expected that; even just TVs can have really funky restrictions
about z order and blend capability.

> - we should immediately stop to call anything an overlay. It's a confusing
>   concept that has a different meaning in every subsystem and for every hw
>   manufacturer. More sensible names are dma fifo engines for things that slurp
>   in planes and make them available to the display subsystem. Blend engines
>   for blocks that take multiple input pipes and overlay/underlay/blend them
>   together. Display subsytem/controller for the aggregate thing including
>   encoders/resizers/outputs and especially the crazy routing network that
>   connects everything.

How about just "display plane" then?  Specifically in the context of
display output hardware...

> 1) Splitting the crtc object into two objects: crtc with associated output mode
> (pixel clock, encoders/connectors) and dma engines (possibly multiple) that
> feed it. omap 4 has essentially just 4 dma engines that can be freely assigned
> to the available outputs, so a distinction between normal crtcs and overlay
> engines just does not make sense. There's the major open question of where
> to put the various attributes to set up the output pipeline. Also some of these
> attributes might need to be changed atomicly together with pageflips on
> a bunch of dma engines all associated with the same crtc on the next vsync,
> e.g. output position of an overlaid video buffer.

Yeah, that's a good goal, and pretty much what I had in mind here.
However, breaking the existing interface is a non-starter, so either we
need a new CRTC object altogether, or we preserve the idea of a
"primary" plane (whatever that means for a given platform) that's tied
to each CRTC, which each additional plane described in a separate
structure.  Z order and blend restrictions will have to be communicated
separately I think...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
