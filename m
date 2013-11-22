Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab3KVXFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 18:05:09 -0500
Date: Sat, 23 Nov 2013 01:05:04 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Kristian =?iso-8859-1?Q?H=F8gsberg?= <hoegsberg@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add
 __DRI_IMAGE_FOURCC_SARGB8888
Message-ID: <20131122230504.GK10036@intel.com>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com>
 <20131122102632.GQ27344@phenom.ffwll.local>
 <86d2lsem3m.fsf@miki.keithp.com>
 <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
 <20131122221213.GA3234@tokamak.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131122221213.GA3234@tokamak.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 22, 2013 at 02:12:13PM -0800, Kristian Høgsberg wrote:
> On Fri, Nov 22, 2013 at 05:17:37PM +0100, Daniel Vetter wrote:
> > On Fri, Nov 22, 2013 at 12:01 PM, Keith Packard <keithp@keithp.com> wrote:
> > > Daniel Vetter <daniel@ffwll.ch> writes:
> > >
> > >> Hm, where do we have the canonical source for all these fourcc codes? I'm
> > >> asking since we have our own copy in the kernel as drm_fourcc.h, and that
> > >> one is part of the userspace ABI since we use it to pass around
> > >> framebuffer formats and format lists.
> > >
> > > I think it's the kernel? I really don't know, as the whole notion of
> > > fourcc codes seems crazy to me...
> > >
> > > Feel free to steal this code and stick it in the kernel if you like.
> > 
> > Well, I wasn't ever in favour of using fourcc codes since they're just
> > not standardized at all, highly redundant in some cases and also miss
> > lots of stuff we actually need (like all the rgb formats).
> 
> These drm codes are not fourcc codes in any other way than that
> they're defined by creating a 32 bit value by picking four characters.
> I don't know what PTSD triggers people have from hearing "fourcc", but
> it seems severe.  Forget all that, these codes are DRM specific
> defines that are not inteded to match anything anybody else does.  It
> doesn't matter if these match of conflict with v4l, fourcc.org,
> wikipedia.org or what the amiga did.  They're just tokens that let us
> define succintly what the pixel format of a kms framebuffer is and
> tell the kernel.
> 
> I don't know what else you'd propose?  Pass an X visual in the ioctl?
> An EGL config?  This is our name space, we can add stuff as we need
> (as Keith is doing here). include/uapi/drm/drm_fourcc.h is the
> canonical source for these values and we should add
> DRM_FORMAT_SARGB8888 there to make sure we don't clash.

What is this format anyway? -ENODOCS

If its just an srgb version of ARGB8888, then I wouldn't really want it
in drm_fourcc.h. I expect colorspacy stuff will be handled by various
crtc/plane properties in the kernel so we don't need to encode that
stuff into the fb format.

-- 
Ville Syrjälä
Intel OTC
