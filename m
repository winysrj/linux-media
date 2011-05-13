Return-path: <mchehab@gaivota>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57096 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1EMQQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 12:16:31 -0400
Received: by vxi39 with SMTP id 39so1943524vxi.19
        for <linux-media@vger.kernel.org>; Fri, 13 May 2011 09:16:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110425151220.2f5dc17a@jbarnes-desktop>
References: <20110425151220.2f5dc17a@jbarnes-desktop>
Date: Fri, 13 May 2011 18:16:30 +0200
Message-ID: <BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
Subject: Re: [RFC] drm: add overlays as first class KMS objects
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, "Clark, Rob" <rob@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Jesse,

Discussion here in Budapest with v4l and embedded graphics folks was
extremely fruitful. A few quick things to take away - I'll try to dig
through all
the stuff I've learned more in-depth later (probably in a blog post or two):

- embedded graphics is insane. The output routing/blending/whatever
  currently shipping hw can do is crazy and kms as-is is nowhere near up
  to snuff to support this. We've discussed omap4 and a ti chip targeted at
  video surveillance as use cases. I'll post block diagrams and explanations
  some when later.
- we should immediately stop to call anything an overlay. It's a confusing
  concept that has a different meaning in every subsystem and for every hw
  manufacturer. More sensible names are dma fifo engines for things that slurp
  in planes and make them available to the display subsystem. Blend engines
  for blocks that take multiple input pipes and overlay/underlay/blend them
  together. Display subsytem/controller for the aggregate thing including
  encoders/resizers/outputs and especially the crazy routing network that
  connects everything.

Most of the discussion centered around clearing up the confusion and
reaching a mutual understanding between desktop graphics, embedded
graphics and v4l people. Two rough ideas emerged though:

1) Splitting the crtc object into two objects: crtc with associated output mode
(pixel clock, encoders/connectors) and dma engines (possibly multiple) that
feed it. omap 4 has essentially just 4 dma engines that can be freely assigned
to the available outputs, so a distinction between normal crtcs and overlay
engines just does not make sense. There's the major open question of where
to put the various attributes to set up the output pipeline. Also some of these
attributes might need to be changed atomicly together with pageflips on
a bunch of dma engines all associated with the same crtc on the next vsync,
e.g. output position of an overlaid video buffer.

2) The above should be good enough to support halfway sane chips like
omap4. But hw with more insane routing capabilities that can also use v4l
devices as sources (even video input connectors) media controller might be
a good fit. Media controller is designed to expose multimedia pipe routing
across different subsystem. But the first version, still marked experimental,
only got merged in .39. We discussed a few ideas as how to splice
media controller into kms but nothing clear emerged. So a possible kms
integration with media
controller is rather far away.

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
