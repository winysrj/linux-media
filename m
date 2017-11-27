Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43565 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdK0LMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 06:12:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Gheorghe, Alexandru" <Alexandru_Gheorghe@mentor.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Eric Anholt <eric@anholt.net>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "sergei.shtylyov@cogentembedded.com"
        <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add support for colorkey alpha blending
Date: Mon, 27 Nov 2017 13:12:57 +0200
Message-ID: <3672804.sDuinxb1Jr@avalon>
In-Reply-To: <ea75fbe96e7248a18032055d384be1c3@SVR-IES-MBX-03.mgc.mentorg.com>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com> <20170508182958.gmi6rrwog4anqxea@phenom.ffwll.local> <ea75fbe96e7248a18032055d384be1c3@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex et all,

On Tuesday, 9 May 2017 10:12:31 EET Gheorghe, Alexandru wrote:
> On Mon, Monday, May 8, 2017 9:29 PM +0200, Daniel Vetter wrote:
> > On Mon, May 08, 2017 at 09:33:37AM -0700, Eric Anholt wrote:
> >> Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com> writes:
> >>> Currently, rcar-du supports colorkeying  only for rcar-gen2 and it
> >>> uses some hw capability of the display unit(DU) which is not available
> >>> on gen3.
> >>> 
> >>> In order to implement colorkeying for gen3 we need to use the
> >>> colorkey capability of the VSPD, hence the need to change both
> >>> drivers rcar-du and vsp1.
> >>> 
> >>> This patchset had been developed and tested on top of
> >>> v4.9/rcar-3.5.1 from
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git
> >> 
> >> A few questions:
> >> 
> >> Are other drivers interested in supporting this property?  VC4 has the
> >> 24-bit RGB colorkey, but I don't see YCBCR support.  Should it be
> >> documented in a generic location?
> 
> As far as I identified  armada, i815, nouveau, rcar-du, vmwgfx drivers have
> this notion of colorkey. There could be other HW which don't have this
> implemented yet.

Among those drivers only armada, nouveau and rcar-du expose the color key 
through DRM properties. The i915 and vmwgfx drivers use custom ioctls. Here is 
what is currently implemented.

- armada

"colorkey" range  0x00000000 0x00ffffff
"colorkey_min" range  0x00000000 0x00ffffff
"colorkey_max" range  0x00000000 0x00ffffff
"colorkey_val" range  0x00000000 0x00ffffff
"colorkey_alpha" range  0x00000000 0x00ffffff
"colorkey_mode" enum "disable", "Y component", "U component", "V component", 
"RGB", "R component", "G component", "B component"

All range properties store a RGB888 or YUV888 triplet.

The min and max properties store the comparison ranges. When a match occurs 
for one of the components, the value and alpha from the val and alpha 
properties replace the pixel. It's not clear which of the alpha "components" 
is used when a match occurs in RGB mode.

The colorkey property is a shortcut that stores identical values in min, max 
and val and 0 in alpha.

- i915

#define I915_SET_COLORKEY_NONE          (1<<0)
#define I915_SET_COLORKEY_DESTINATION   (1<<1)
#define I915_SET_COLORKEY_SOURCE        (1<<2)

struct drm_intel_sprite_colorkey {
        __u32 plane_id;
        __u32 min_value;
        __u32 channel_mask;
        __u32 max_value;
        __u32 flags;
};

- nouveau

"colorkey" range 0x00000000 0x01ffffff

The format isn't documented but it seems from the source code that bits 23:0 
store the color key value (written directly to a register, so possibly in a 
pixel format-dependent format) and bit 24 enables color keying.

- rcar-du

"colorkey" range 0x00000000 0x01ffffff

Bits 23:0 store the color key value in RGB888 (regardless of the pixel format 
of the plane) and bit 24 enables color keying. This supports Gen2 hardware 
only, where the only available more is  exact match. The pixel then becomes 
fully transparent (the hardware doesn't support custom target alpha values).

On Gen3 hardware color keying can be performed in exact RGB match, exact Y 
match or range Y match (only the max value is programmable, the min value is 
always 0). Furthermore in exact match modes the hardware can operate with a 
single match value, in which case it can then override the full ARGB or AYUV 
pixel, or double match value, in which case it can then override the alpha 
component only, but with two distinct match values each associated with a 
target alpha.

- vmwgfx

struct drm_vmw_control_stream_arg {
        __u32 stream_id;
        __u32 enabled;

        __u32 flags;
        __u32 color_key;

        __u32 handle;
        __u32 offset;
        __s32 format;
        __u32 size;
        __u32 width;
        __u32 height;
        __u32 pitch[3];

        __u32 pad64;
        struct drm_vmw_rect src;
        struct drm_vmw_rect dst;
};

The color_key field isn't documented, but the following (unused) macros hint 
that it could store an RGB888, with the color key feature enabled through the 
flags field.

#define SVGA_VIDEO_FLAG_COLORKEY        0x0001
#define SVGA_VIDEO_COLORKEY_MASK             0x00ffffff

> >> Does your colorkey end up forcing alpha to 1 for the plane when it's
> >> not matched?
> 
> I think this  behavior is HW dependent, on R-CAR Gen3, the alpha for pixel
> that don't match is not touch.
> 
> > I think generic color-key for plane compositioning would be nice, but I'm
> > not sure that's possible due to differences in how the key works.
> 
> I'm thinking of starting from the drivers that do have this property and see
> if there is any common ground for a generic color-key property/ies

Looking at the 5 drivers we have in mainline that support color keying one way 
or another, we can already see that the hardware implementations differ quite 
widely. There are however similarities, and we could express most of the above 
features through a set of generic properties similar to the ones already 
implemented by the armada driver.

- The match range could be set through minimum and maximum properties. Drivers 
that support exact match only would report an error with minimum != maximum.

- The replacement value could be set through a value property. The property 
could store both the pixel value (RGB or YUV) and the alpha value, or we could 
separate those in two properties. With a single property bits that are not 
applicable would be ignored (for instance RGB/YUV bits when the driver 
supports alpha replacement only). If programmable color replacement isn't 
supported (as in the R-Car Gen2 example above) the property could be omitted.

- The mode could be set through a mode property. Enabling color keying through 
one bit in a color property (like done by the nouveau and rcar-du drivers) is 
a hack and I don't think we should carry it forward. A mode property would 
also allow configuring source or destination color keying.

- Part of the mode information could be deduced automatically without a need 
to specify it explicitly. For instance RGB/YUV mode can be configured based on 
the pixel format of the plane. Similarly, exact match vs. range match can be 
configured based on whether the minimum and maximum value differ.

- Properties that store pixel values could either contain a value in a fixed 
format (e.g. RGB888) or in a format that varies depending on the pixel format 
(e.g. encoded in the same pixel format as the plane). I have a preference for 
the former but I'm open for discussions.

- We need to keep the existing "colorkey" properties implemented by armada, 
nouveau and rcar-du for backward compatibility reasons, but this proposed API 
doesn't require a "colorkey" property. We could however decide to standardize 
a "colorkey" property as a shortcut similar to what the armada driver does.


Some of the R-Car Gen3 hardware features wouldn't be supported by the above 
proposal. Selecting exact match vs. range match should be fine, with atomic 
commit returning an error if minimum != 0 && minimum != maximum. The dual 
target mode, however, can't really fit the properties proposed here. I don't 
have a use case for that mode at the moment but I'm fairly certain that 
someone will come up with one, at least if not for the R-Car for a different 
display engine that provides similarly exotic features.

We could also decide to standardize the color keying properties in a way that 
would balance complexity vs. hardware features support, and let drivers that 
need exotic features implement additional properties.

Ideas and comments are welcome, I'd like to start working on this fairly soon.

-- 
Regards,

Laurent Pinchart
