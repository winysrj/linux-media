Return-path: <mchehab@gaivota>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39575 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734Ab1EOAAS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 20:00:18 -0400
Received: by iym10 with SMTP id 10so4107204iym.18
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 17:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110513180256.773ec8aa@jbarnes-desktop>
References: <20110425151220.2f5dc17a@jbarnes-desktop>
	<BANLkTimSrSgxcS2khHvAQPK+-vdfxo7VGg@mail.gmail.com>
	<20110513180256.773ec8aa@jbarnes-desktop>
Date: Sat, 14 May 2011 19:00:16 -0500
Message-ID: <BANLkTimQbGDGx-5qMCokFfudh-YX7x__Lw@mail.gmail.com>
Subject: Re: [RFC] drm: add overlays as first class KMS objects
From: "Clark, Rob" <rob@ti.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, May 13, 2011 at 8:02 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 13 May 2011 18:16:30 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
>> Hi Jesse,
>>
>> Discussion here in Budapest with v4l and embedded graphics folks was
>> extremely fruitful. A few quick things to take away - I'll try to dig
>> through all
>> the stuff I've learned more in-depth later (probably in a blog post or two):

Hi Daniel, thanks for writing this up

>> - embedded graphics is insane. The output routing/blending/whatever
>>   currently shipping hw can do is crazy and kms as-is is nowhere near up
>>   to snuff to support this. We've discussed omap4 and a ti chip targeted at
>>   video surveillance as use cases. I'll post block diagrams and explanations
>>   some when later.
>
> Yeah I expected that; even just TVs can have really funky restrictions
> about z order and blend capability.
>
>> - we should immediately stop to call anything an overlay. It's a confusing
>>   concept that has a different meaning in every subsystem and for every hw
>>   manufacturer. More sensible names are dma fifo engines for things that slurp
>>   in planes and make them available to the display subsystem. Blend engines
>>   for blocks that take multiple input pipes and overlay/underlay/blend them
>>   together. Display subsytem/controller for the aggregate thing including
>>   encoders/resizers/outputs and especially the crazy routing network that
>>   connects everything.
>
> How about just "display plane" then?  Specifically in the context of
> display output hardware...

"display plane" could be a good name.. actually in omap4 case it is a
single dma engine that is multiplexing fetches for however many
attached video pipes.. that is perhaps an implementation detail, but
it makes "display plane" sound nicer as a name


>
>> 1) Splitting the crtc object into two objects: crtc with associated output mode
>> (pixel clock, encoders/connectors) and dma engines (possibly multiple) that
>> feed it. omap 4 has essentially just 4 dma engines that can be freely assigned
>> to the available outputs, so a distinction between normal crtcs and overlay
>> engines just does not make sense. There's the major open question of where
>> to put the various attributes to set up the output pipeline. Also some of these
>> attributes might need to be changed atomicly together with pageflips on
>> a bunch of dma engines all associated with the same crtc on the next vsync,
>> e.g. output position of an overlaid video buffer.
>
> Yeah, that's a good goal, and pretty much what I had in mind here.
> However, breaking the existing interface is a non-starter, so either we
> need a new CRTC object altogether, or we preserve the idea of a
> "primary" plane (whatever that means for a given platform) that's tied
> to each CRTC, which each additional plane described in a separate
> structure.  Z order and blend restrictions will have to be communicated
> separately I think...

In the cases I can think of, you'll always have a primary plane, so
userspace need not explicitly specify it.  But I think you want the
driver to pick which display plane to be automatically hooked between
the primary fb and crtc, or at least this should be the case if some
new bit is set in driver_features to indicate the driver supports
multiple display planes per crtc.

BR,
-R

> Thanks,
> --
> Jesse Barnes, Intel Open Source Technology Center
>
