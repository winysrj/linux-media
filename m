Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38503 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdHaO2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 10:28:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com, dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Date: Thu, 31 Aug 2017 17:28:54 +0300
Message-ID: <4559442.sz5HF0f0o4@avalon>
In-Reply-To: <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com> <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl> <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

On Thursday, 24 August 2017 14:14:31 EEST Brian Starkey wrote:
> On Mon, Aug 21, 2017 at 06:36:29PM +0200, Hans Verkuil wrote:
> > On 08/21/2017 06:01 PM, Daniel Vetter wrote:
> >> On Mon, Aug 21, 2017 at 5:52 PM, Brian Starkey wrote:
> >>> Hi all,
> >>> 
> >>> I couldn't find this topic talked about elsewhere, but apologies if
> >>> it's a duplicate - I'll be glad to be steered in the direction of a
> >>> thread.
> >>> 
> >>> We'd like to support DRM format modifiers in v4l2 in order to share
> >>> the description of different (mostly proprietary) buffer formats
> >>> between e.g. a v4l2 device and a DRM device.
> >>> 
> >>> DRM format modifiers are defined in include/uapi/drm/drm_fourcc.h and
> >>> are a vendor-namespaced 64-bit value used to describe various
> >>> vendor-specific buffer layouts. They are combined with a (DRM) FourCC
> >>> code to give a complete description of the data contained in a buffer.
> >>> 
> >>> The same modifier definition is used in the Khronos EGL extension
> >>> EGL_EXT_image_dma_buf_import_modifiers, and is supported in the
> >>> Wayland linux-dmabuf protocol.
> >>> 
> >>> 
> >>> This buffer information could of course be described in the
> >>> vendor-specific part of V4L2_PIX_FMT_*, but this would duplicate the
> >>> information already defined in drm_fourcc.h. Additionally, there
> >>> would be quite a format explosion where a device supports a dozen or
> >>> more formats, all of which can use one or more different
> >>> layouts/compression schemes.
> >>> 
> >>> So, I'm wondering if anyone has views on how/whether this could be
> >>> incorporated?
> >>> 
> >>> I spoke briefly about this to Laurent at LPC last year, and he
> >>> suggested v4l2_control as one approach.
> >>> 
> >>> I also wondered if could be added in v4l2_pix_format_mplane - looks
> >>> like there's 8 bytes left before it exceeds the 200 bytes, or could go
> >>> in the reserved portion of v4l2_plane_pix_format.

We're considering reworking the format ioctls at some point. We don't 
necessarily need to wait until then to implement support for modifiers, but we 
will have an opportunity to integrate them with formats at that point.

> >>> Thanks for any thoughts,
> >> 
> >> One problem is that the modifers sometimes reference the DRM fourcc
> >> codes. v4l has a different (and incompatible set) of fourcc codes,
> >> whereas all the protocols and specs (you can add DRI3.1 for Xorg to
> >> that list btw) use both drm fourcc and drm modifiers.
> >> 
> >> This might or might not make this proposal unworkable, but it's
> >> something I'd at least review carefully.
> >> 
> >> Otherwise I think it'd be great if we could have one namespace for all
> >> modifiers, that's pretty much why we have them. Please also note that
> >> for drm_fourcc.h we don't require an in-kernel user for a new modifier
> >> since a bunch of them might need to be allocated just for
> >> userspace-to-userspace buffer sharing (e.g. in EGL/vk). One example
> >> for this would be compressed surfaces with fast-clearing, which is
> >> planned for i915 (but current hw can't scan it out). And we really
> >> want to have one namespace for everything.
> >
> > Who sets these modifiers? Kernel or userspace? Or can it be set by both?
> > I assume any userspace code that sets/reads this is code specific for that
> > hardware?
> 
> I think normally the modifier would be set by userspace. However it
> might not necessarily be device-specific code. In DRM the intention is
> for userspace to query the set of modifiers which are supported, and
> then use them without necessarily knowing exactly what they mean
> (insofar as that is possible).
> 
> e.g. if I have two devices which support MODIFIER_FOO, I could attempt
> to share a buffer between them which uses MODIFIER_FOO without
> necessarily knowing exactly what it is/does.

Userspace could certainly set modifiers blindly, but the point of modifiers is 
to generate side effects benefitial to the use case at hand (for instance by 
optimizing the memory access pattern). To use them meaningfully userspace 
would need to have at least an idea of the side effects they generate.

> > I think Laurent's suggestion of using a 64 bit V4L2 control for this makes
> > the most sense.
> >
> > Especially if you can assume that whoever sets this knows the hardware.
> >
> > I think this only makes sense if you pass buffers from one HW device to
> > another.
> >
> > Because you cannot expect generic video capture code to be able to
> > interpret all the zillion different combinations of modifiers.
> 
> I don't quite follow this last bit. The control could report the set
> of supported modifiers.
> 
> However, in DRM the API lets you get the supported formats for each
> modifier as-well-as the modifier list itself. I'm not sure how exactly
> to provide that in a control.

-- 
Regards,

Laurent Pinchart
