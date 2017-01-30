Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34087 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdA3Igm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 03:36:42 -0500
Received: by mail-wj0-f196.google.com with SMTP id ip10so6800511wjb.1
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 00:36:41 -0800 (PST)
Date: Mon, 30 Jan 2017 09:36:37 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, mihail.atanassov@arm.com,
        liviu.dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: DRM Atomic property for color-space conversion
Message-ID: <20170130083637.ygbliqvppqxmomyq@phenom.ffwll.local>
References: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 27, 2017 at 05:23:24PM +0000, Brian Starkey wrote:
> Hi,
> 
> We're looking to enable the per-plane color management hardware in
> Mali-DP with atomic properties, which has sparked some conversation
> around how to handle YCbCr formats.
> 
> As it stands today, it's assumed that a driver will implicitly "do the
> right thing" to display a YCbCr buffer.
> 
> YCbCr data often uses different gamma curves and signal ranges (e.g.
> BT.609, BT.701, BT.2020, studio range, full-range), so its desirable
> to be able to explicitly control the YCbCr to RGB conversion process
> from userspace.
> 
> We're proposing adding a "CSC" (color-space conversion) property to
> control this - primarily per-plane for framebuffer->pipeline CSC, but
> perhaps one per CRTC too for devices which have an RGB pipeline and
> want to output in YUV to the display:
> 
> Name: "CSC"
> Type: ENUM | ATOMIC;
> Enum values (representative):
> "default":
> 	Same behaviour as now. "Some kind" of YCbCr->RGB conversion
> 	for YCbCr buffers, bypass for RGB buffers
> "disable":
> 	Explicitly disable all colorspace conversion (i.e. use an
> 	identity matrix).
> "YCbCr to RGB: BT.709":
> 	Only valid for YCbCr formats. CSC in accordance with BT.709
> 	using [16..235] for (8-bit) luma values, and [16..240] for
> 	8-bit chroma values. For 10-bit formats, the range limits are
> 	multiplied by 4.
> "YCbCr to RGB: BT.709 full-swing":
> 	Only valid for YCbCr formats. CSC in accordance with BT.709,
> 	but using the full range of each channel.

We already have a standardized property for broadcast vs. full range. So
needs to be taken out of this one here to avoid silly interactions. It's
not yet atomic-ified though (i.e. not tracked in drm_connector_state).
It's a bit annoying since it's on the connector, but with sufficient glue
we can fix this.

Your helper should probably take that into account too.

> "YCbCr to RGB: Use CTM":*
> 	Only valid for YCbCr formats. Use the matrix applied via the
> 	plane's CTM property
> "RGB to RGB: Use CTM":*
> 	Only valid for RGB formats. Use the matrix applied via the
> 	plane's CTM property
> "Use CTM":*
> 	Valid for any format. Use the matrix applied via the plane's
> 	CTM property
> ... any other values for BT.601, BT.2020, RGB to YCbCr etc. etc. as
> they are required.
> 
> *This assumes color-management is enabled per-plane. We're currently
> working on patches to add this mostly to be able to use per-plane
> degamma, but it would be analogous to the CRTC color-management code
> and so also be able to expose a per-plane CTM property.
> 
> Our hardware implements the color-space conversion as a 3x3 matrix, so
> we can implement a helper to convert a CSC enum value to a CTM matrix
> for use by any hardware which has a programmable CSC matrix. For any
> other hardware, the driver simply needs to map the enum value to
> whatever selector bits are available.
> 
> It's expected that the "Use CTM" value(s) are *not* the common case,
> and most of the time userspace will use one of the provided "standard"
> enum values. The three different flavours of "Use CTM" allow us to
> support hardware whose CSC hardware can only be used on e.g. YCbCr
> data.
> 
> Drivers can of course filter the enum list to expose whichever subset
> the hardware can support.
> 
> Having thrashed this out a bit on IRC with Ville, I think the above
> approach is flexible enough to support at least Mali-DP and i915,
> without burdening userspace any more than necessary. It also provides
> the "default" behaviour which is backwards compatible, and allows for
> fully custom CSC matrices where that is supported.
> 
> We can obviously implement this as a Mali-DP driver private property,
> but it would be good to come up with something to go into the core if
> possible.

It needs userspace either way :-) And I think the tricky bit here is
interaction with the CTM stuff we already have, i.e. what happens when
userspace sets both this and the CTM? Would our helper need to be able to
merge the explicit CTM with the implicit one here with some matrix
multiplication? If we go with "kernel multiplies them" then we could
simplify things a lot I think, since all we'd need is just "none, BT.709,
BT.601, ..." and none of the special values that define interactions with
the CTM.

Or we just chicken out for now and say you can't have a per-plane CTM if
you expose this :-) Since there's no per-plane CTM userspace yet, this is
probably the simplest option ...
-Daniel

> 
> I'd be happy to hear any feedback,
> 
> Thanks,
> Brian
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
