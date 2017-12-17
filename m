Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50475 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdLQARU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 19:17:20 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH/RFC 0/4] Implement standard color keying properties
Date: Sun, 17 Dec 2017 02:17:20 +0200
Message-Id: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series is an attempt at implementing standard properties for color
keying support in the KMS API.

Before designing the API proposal I've analyzed the KMS drivers that support
color keying in the upstream kernel. Part of the explanation below was
initially posted in a reply to "[PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add
support for colorkey alpha blending" and is copied here to continue the
discussion.

The armada, nouveau and rcar-du drivers expose the color key through DRM
properties. The i915 and vmwgfx drivers use custom ioctls. Here is how they
currently implement color keying.

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

Looking at these drivers we can already see that the hardware implementations
differ quite widely. There are however similarities, and we could express most
of the above features through a set of generic properties similar to the ones
already implemented by the armada driver. This is what the patch series
attempts to do.

- The match range can be set through minimum and maximum properties. Drivers
that support exact match only simply report an error when minimum != maximum.

- The replacement value can be set through a value property. The property
stores both the pixel value (RGB or YUV) and the alpha value Bits that are not
applicable are ignored (for instance RGB/YUV bits when the driver supports
alpha replacement only). If programmable color replacement isn't supported (as
in the R-Car Gen2 example above) the property is omitted.

- The mode can be set through a mode property. Enabling color keying through
one bit in a color property (like done by the nouveau and rcar-du drivers) is 
a hack and I don't think we should carry it forward. A mode property allows
configuring source or destination color keying.

- Part of the mode information could be deduced automatically without a need
to specify it explicitly. For instance RGB/YUV mode can be configured based on
the pixel format of the plane. Similarly, exact match vs. range match can be
configured based on whether the minimum and maximum value differ.

- The modes exposed through the mode property are left as driver-specific in
this RFC, with one "disabled" mode mandatory for all implementations. The
rationale is that a generic userspace should be able to disable color keying,
but that hardware features vary too much to standardize all modes. I'm however
starting to think that we should standardize more modes than "disabled", but I
still need to sleep over this particular issue. Ideas and comments are
welcome.

- Properties that store pixel values store them in a fixed AXYZ16161616 format
where A is the alpha value and XYZ color components that correspond to the
plane pixel format (usually RGB or YUV).

- We need to keep the existing "colorkey" properties implemented by armada, 
nouveau and rcar-du for backward compatibility reasons, but this proposed API 
doesn't require a "colorkey" property. I have reimplemented the existing
"colorkey" in the rcar-du driver as an alias for the new standard properties
to show how it can be done in a driver.


The R-Car Gen3 dual target mode feature doesn't fit in the properties proposed
here. I have no use case for that mode at the moment but I'm fairly certain
that someone will come up with one, at least if not for the R-Car for a
different display engine that provides similarly exotic features. I believe
this can for now be left for implementation through driver-specific
properties.

Alexandru Gheorghe (1):
  v4l: vsp1: Add support for colorkey alpha blending

Laurent Pinchart (3):
  drm: Add colorkey properties
  drm: rcar-du: Use standard colorkey properties
  drm: rcar-du: Add support for color keying on Gen3

 drivers/gpu/drm/drm_atomic.c            |  16 +++++
 drivers/gpu/drm/drm_blend.c             | 108 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c |  60 +++++++++++++-----
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |   2 -
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  17 ++++-
 drivers/media/platform/vsp1/vsp1_drm.c  |   3 +
 drivers/media/platform/vsp1/vsp1_rpf.c  |  10 ++-
 drivers/media/platform/vsp1/vsp1_rwpf.h |   5 ++
 include/drm/drm_blend.h                 |   4 ++
 include/drm/drm_plane.h                 |  28 ++++++++-
 include/media/vsp1.h                    |   5 ++
 11 files changed, 235 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart
