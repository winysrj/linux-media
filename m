Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35295 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab3KVWMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 17:12:19 -0500
Date: Fri, 22 Nov 2013 14:12:13 -0800
From: Kristian =?iso-8859-1?Q?H=F8gsberg?= <hoegsberg@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Keith Packard <keithp@keithp.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add
 __DRI_IMAGE_FOURCC_SARGB8888
Message-ID: <20131122221213.GA3234@tokamak.local>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com>
 <20131122102632.GQ27344@phenom.ffwll.local>
 <86d2lsem3m.fsf@miki.keithp.com>
 <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 22, 2013 at 05:17:37PM +0100, Daniel Vetter wrote:
> On Fri, Nov 22, 2013 at 12:01 PM, Keith Packard <keithp@keithp.com> wrote:
> > Daniel Vetter <daniel@ffwll.ch> writes:
> >
> >> Hm, where do we have the canonical source for all these fourcc codes? I'm
> >> asking since we have our own copy in the kernel as drm_fourcc.h, and that
> >> one is part of the userspace ABI since we use it to pass around
> >> framebuffer formats and format lists.
> >
> > I think it's the kernel? I really don't know, as the whole notion of
> > fourcc codes seems crazy to me...
> >
> > Feel free to steal this code and stick it in the kernel if you like.
> 
> Well, I wasn't ever in favour of using fourcc codes since they're just
> not standardized at all, highly redundant in some cases and also miss
> lots of stuff we actually need (like all the rgb formats).

These drm codes are not fourcc codes in any other way than that
they're defined by creating a 32 bit value by picking four characters.
I don't know what PTSD triggers people have from hearing "fourcc", but
it seems severe.  Forget all that, these codes are DRM specific
defines that are not inteded to match anything anybody else does.  It
doesn't matter if these match of conflict with v4l, fourcc.org,
wikipedia.org or what the amiga did.  They're just tokens that let us
define succintly what the pixel format of a kms framebuffer is and
tell the kernel.

I don't know what else you'd propose?  Pass an X visual in the ioctl?
An EGL config?  This is our name space, we can add stuff as we need
(as Keith is doing here). include/uapi/drm/drm_fourcc.h is the
canonical source for these values and we should add
DRM_FORMAT_SARGB8888 there to make sure we don't clash.

Why are these codes in mesa (and gbm and wl_drm protocol) then?
Because it turns out that once you have an stable and established
namespace for pixel formats (and a kernel userspace header is about as
stable and established as it gets) it makes a lot of sense to reuse
those values.

I already explained to Keith why we use different sets of format codes
in the DRI interface, but it's always fun to slam other peoples code.
Anyway, it's pretty simple, the __DRI_IMAGE_FORMAT_* defines predate
the introduction of drm_fourcc.h.  When we later added suport for
planar YUV __DRIimages, the kernel had picked up drm_fourcc.h after a
long sad bikeshedding flamewar, which included the planar formats we
needed.  At this point we could continue using our custom
__DRI_IMAGE_FORMAT_* defines or we could switch to the tokens that we
had finally converged on.  But don't let me ruin a good old snide remark.

> Cc'ing the heck out of this to get kernel people to hopefully notice.
> Maybe someone takes charge of this ... Otherwise meh.

I don't know what you want to change.  These values are already kernel
ABI, we use them in drmAddFB2, and again, I don't understand what
problem you're seeing.

Kristian

> >> Just afraid to create long-term maintainance madness here with the
> >> kernel's iron thou-shalt-not-break-userspace-ever rule ... Not likely
> >> we'll ever accept srgb for framebuffers though.
> >
> > Would suck to collide with something we do want though.
> 
> Yeah, it'd suck. But given how fourcc works we probably have that
> already, just haven't noticed yet :(
> -Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
