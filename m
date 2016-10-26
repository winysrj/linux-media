Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39367 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754253AbcJZNFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 09:05:24 -0400
Received: by mail-wm0-f65.google.com with SMTP id m83so3556086wmc.6
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 06:05:23 -0700 (PDT)
Date: Wed, 26 Oct 2016 15:05:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/9] drm: Add writeback connector type
Message-ID: <20161026130519.rfdpzpi7ljgdfqx5@phenom.ffwll.local>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-2-git-send-email-brian.starkey@arm.com>
 <20161026110021.bgy4xsfbtiqflqe3@phenom.ffwll.local>
 <20161026124242.GB30071@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026124242.GB30071@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 01:42:42PM +0100, Brian Starkey wrote:
> On Wed, Oct 26, 2016 at 01:00:21PM +0200, Daniel Vetter wrote:
> > On Wed, Oct 26, 2016 at 09:55:00AM +0100, Brian Starkey wrote:
> > > diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
> > > new file mode 100644
> > > index 0000000..5a6e0ad
> > > --- /dev/null
> > > +++ b/drivers/gpu/drm/drm_writeback.c
> > > @@ -0,0 +1,157 @@
> > > +/*
> > > + * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
> > > + * Author: Brian Starkey <brian.starkey@arm.com>
> > > + *
> > > + * This program is free software and is provided to you under the terms of the
> > > + * GNU General Public License version 2 as published by the Free Software
> > > + * Foundation, and any use by you of this program is subject to the terms
> > > + * of such GNU licence.
> > > + */
> > > +
> > > +#include <drm/drm_crtc.h>
> > > +#include <drm/drm_property.h>
> > > +#include <drm/drmP.h>
> > > +
> > > +/**
> > > + * DOC: overview
> > > + *
> > > + * Writeback connectors are used to expose hardware which can write the output
> > > + * from a CRTC to a memory buffer. They are used and act similarly to other
> > > + * types of connectors, with some important differences:
> > > + *  - Writeback connectors don't provide a way to output visually to the user.
> > > + *  - Writeback connectors should always report as "disconnected" (so that
> > > + *    clients which don't understand them will ignore them).
> > > + *  - Writeback connectors don't have EDID.
> > > + *
> > > + * Writeback connectors may only be attached to a CRTC when they have a
> > > + * framebuffer attached, and may only have a framebuffer attached when they are
> > > + * attached to a CRTC. The WRITEBACK_FB_ID property which sets the framebuffer
> > > + * applies only to a single commit (see below), which means that each and every
> > > + * commit which makes use of a writeback connector must set both its CRTC_ID and
> > > + * WRITEBACK_FB_ID. It also means that the connector's CRTC_ID must be
> > > + * explicitly cleared in order to make a subsequent commit which doesn't use
> > > + * writeback.
> > 
> > Hm, this is a bit an ugly fallout from our safety checks, but I guess it's
> > a reasonable requirement for userspace. Writeback is kinda special. Or
> > should we make the ->crtc pointer one-shot too? Of course only for
> > writeback pointers. I think that would make is simpler to use in libraries
> > like igt.
> > 
> 
> I sort-of agree on the ugly fallout sentiment, it took me a bit by
> surprise when some of my commits started failing :-). On the userspace
> side it isn't really any additional effort once you understand the
> requirements though (which you learn quickly by way of -EINVAL).
> 
> I'm actually leaning towards leaving it as-is for two reasons:
>  1) On hardware that actually *does* need a full-modeset for writeback
>     routing changes, a one-shot CRTC would cause problems (need a
>     full-modeset every frame).
>  2) If there's no explicit commit to disable, we have no way to
>     communicate to the driver that it should disable - no-one will
>     ever add the connector_state to the next commit.
> 
> Both of the above *could* be handled with some special casing, but my
> gut feeling is it would be tricky and a bit of a mess.
> 
> The current implementation is reasonably clean, and does seem to have
> removed a few corner cases which would be likely sources of driver
> bugs.

One issue with not auto-disconnecting the writeback connector is that if
the next atomic ioctl does not touch it, nothing bad will happen. But if
it does touch it, then you get an -EINVAL. It's actually worse, since the
driver can choose to add any object to the update for whatever reason it
sees fit, userspace might get badly surprised with this.

Given all that I think my original suggestion to enforce
!state->writeback_fb == !state->crtc was a bit a mistake, and we should
only enforce that !writeback_fb || state->crtc is true, i.e. a set
writeback_fb implies that it must be connected to something. This means
drivers must always check for the existing of the writeback_fb, but I
think they need to do that anyway already.

> > > + * Writeback connectors have several additional properties, which userspace
> > > + * can use to query and control them:
> > > + *
> > > + *  "WRITEBACK_FB_ID":
> > > + *	Write-only object property storing a DRM_MODE_OBJECT_FB: it stores the
> > > + *	framebuffer to be written by the writeback connector. This property is
> > > + *	similar to the FB_ID property on planes, but will always read as zero
> > > + *	and is not preserved across commits.
> > > + *	Userspace must set this property to an output buffer every time it
> > > + *	wishes the buffer to get filled.
> > > + *
> > > + *  "PIXEL_FORMATS":
> > > + *	Immutable blob property to store the supported pixel formats table. The
> > > + *	data is an array of u32 DRM_FORMAT_* fourcc values.
> > > + *	Userspace can use this blob to find out what pixel formats are supported
> > > + *	by the connector's writeback engine.
> > > + *
> > > + *  "PIXEL_FORMATS_SIZE":
> > > + *	Immutable unsigned range property storing the number of entries in the
> > > + *	PIXEL_FORMATS array.
> > 
> > Blob properties already have a size, you don't need to specify it.
> > Gamma tables have a size since they start out with a default of NULL, so
> > userspace has no idea what the size should be.
> > 
> 
> OK, that makes sense. I'll drop it.
> 
> > Docs are missing to clarify when the writeout is complete. Should we wait
> > with merging this until out fences are supported, or should we add a bit
> > of placeholder text here that the writeback will be completed 1 vblank
> > after this atomic commit was committed? I'm leaning towards including the
> > writeout out fences from the start.
> > 
> 
> Docs are missing because without fences I don't think it can be
> defined ;-)
> 
> You think I should squash fences into this commit then? It's getting
> somewhat large, but I'm not spotting any obvious places to split it
> up anymore.

Not necessarily merge them, but definitely have them all before the first
driver patch to use this stuff. So just reordering the series a bit should
be all that's needed.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
