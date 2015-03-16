Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:34855 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbbCPIdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 04:33:42 -0400
Received: by webcq43 with SMTP id cq43so32493813web.2
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 01:33:40 -0700 (PDT)
Date: Mon, 16 Mar 2015 09:35:22 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-sh@vger.kernel.org,
	linux-api@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 0/5] Add live source objects to DRM
Message-ID: <20150316083522.GE21993@phenom.ffwll.local>
References: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 15, 2015 at 11:55:35PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> I have a feeling that RFC/PATCH will work better than just RFC, so here's a
> patch set that adds a new object named live source to DRM.
> 
> The need comes from the Renesas R-Car SoCs in which a video processing engine
> (named VSP1) that operates from memory to memory has one output directly
> connected to a plane of the display engine (DU) without going through memory.
> 
> The VSP1 is supported by a V4L2 driver. While it could be argued that it
> should instead be supported directly by the DRM rcar-du driver, this wouldn't
> be a good idea for at least two reasons. First, the R-Car SoCs contain several
> VSP1 instances, of which only a subset have a direct DU connection. The only
> other instances operate solely in memory to memory mode. Then, the VSP1 is a
> video processing engine and not a display engine. Its features are easily
> supported by the V4L2 API, but don't map to the DRM/KMS API. Significant
> changes to DRM/KMS would be required, beyond what is in my opinion an
> acceptable scope for a display API.
> 
> Now that the need to interface two separate devices supported by two different
> drivers in two separate subsystems has been established, we need an API to do
> so. It should be noted that while that API doesn't exist in the mainline
> kernel, the need isn't limited to Renesas SoCs.
> 
> This patch set proposes one possible solution for the problem in the form of a
> new DRM object named live source. Live sources are created by drivers to model
> hardware connections between a plane input and an external source, and are
> attached to planes through the KMS userspace API.
> 
> Patch 1/5 adds live source objects to DRM, with an in-kernel API for drivers
> to register the sources, and a userspace API to enumerate and configure them.
> Configuring a live source sets the width, height and pixel format of the
> video stream. This should ideally be queried directly from the driver that
> supports the live source device, but I've decided not to implement such
> communication between V4L2 and DRM/KMS at the moment to keep the proposal
> simple.
> 
> Patch 2/2 implements connection between live sources and planes. This takes
> different forms depending on whether drivers use the setplane or the atomic
> updates API:
> 
> - For setplane, the fb field can now contain a live source ID in addition to
>   a framebuffer ID. As DRM allocates object IDs from a single ID space, the
>   type can be inferred from the ID. This makes specifying both a framebuffer
>   and a live source impossible, which isn't an issue given that such a
>   configuration would be invalid.
> 
>   The live source is looked up by the DRM core and passed as a pointer to the
>   .update_plane() operation. Unlike framebuffers live sources are not
>   refcounted as they're created statically at driver initialization time.
> 
> - For atomic update, a new SRC_ID property has been added to planes. The live
>   source is looked up from the source ID and stored into the plane state.

What about directly treating live sources as (very) special framebuffers?
A bunch of reasons:
- All the abi fu above gets resolved naturally.
- You have lot of duplication between fb and live source wrt size,
  possible/selected pixel format and other stuff.
- The backing storage of framebuffers is fully opaque anyway ...

I think we still need separate live source objects though for things like
telling userspace what v4l thing it corresponds to, and for getting at the
pixel format. But connecting the live source with the plane could still be
done with a framebuffer and a special flag in the addfb2 ioctl to use
live sources as backing storage ids instead of gem/ttm handles.

That would also give you a good point to enforce pixel format
compatibility: As soon as someone created a framebuffer for a live source
you disallow pixel format changes in the v4l pipeline to make sure things
will fit.

> Patches 3/5 to 5/5 then implement support for live sources in the R-Car DU
> driver.
> 
> Nothing here is set in stone. One point I'm not sure about is whether live
> sources support should be enabled for setplane or only for atomic updates.
> Other parts of the API can certainly be modified as well, and I'm open for
> totally different implementations as well.

Imo this should be irrespective of atomic or not really. And by using
magic framebuffers as the link we'd get that for free.

Cheers, Daniel

> 
> Laurent Pinchart (5):
>   drm: Add live source object
>   drm: Connect live source to plane
>   drm/rcar-du: Add VSP1 support to the planes allocator
>   drm/rcar-du: Add VSP1 live source support
>   drm/rcar-du: Restart the DU group when a plane source changes
> 
>  drivers/gpu/drm/armada/armada_overlay.c     |   2 +-
>  drivers/gpu/drm/drm_atomic.c                |   7 +
>  drivers/gpu/drm/drm_atomic_helper.c         |   4 +
>  drivers/gpu/drm/drm_crtc.c                  | 365 ++++++++++++++++++++++++++--
>  drivers/gpu/drm/drm_fops.c                  |   6 +-
>  drivers/gpu/drm/drm_ioctl.c                 |   3 +
>  drivers/gpu/drm/drm_plane_helper.c          |   1 +
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c    |   4 +-
>  drivers/gpu/drm/exynos/exynos_drm_plane.c   |   3 +-
>  drivers/gpu/drm/exynos/exynos_drm_plane.h   |   3 +-
>  drivers/gpu/drm/i915/intel_display.c        |   4 +-
>  drivers/gpu/drm/i915/intel_sprite.c         |   2 +-
>  drivers/gpu/drm/imx/ipuv3-plane.c           |   3 +-
>  drivers/gpu/drm/nouveau/dispnv04/overlay.c  |   6 +-
>  drivers/gpu/drm/omapdrm/omap_plane.c        |   1 +
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c      |  10 +-
>  drivers/gpu/drm/rcar-du/rcar_du_drv.c       |   6 +-
>  drivers/gpu/drm/rcar-du/rcar_du_drv.h       |   3 +
>  drivers/gpu/drm/rcar-du/rcar_du_group.c     |  21 +-
>  drivers/gpu/drm/rcar-du/rcar_du_group.h     |   2 +
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c       |  62 ++++-
>  drivers/gpu/drm/rcar-du/rcar_du_plane.c     | 196 ++++++++++++---
>  drivers/gpu/drm/rcar-du/rcar_du_plane.h     |  11 +
>  drivers/gpu/drm/rcar-du/rcar_du_regs.h      |   1 +
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   5 +-
>  drivers/gpu/drm/shmobile/shmob_drm_plane.c  |   3 +-
>  drivers/gpu/drm/sti/sti_drm_plane.c         |   3 +-
>  drivers/gpu/drm/sti/sti_hqvdp.c             |   2 +-
>  include/drm/drmP.h                          |   3 +
>  include/drm/drm_atomic_helper.h             |   1 +
>  include/drm/drm_crtc.h                      |  48 ++++
>  include/drm/drm_plane_helper.h              |   1 +
>  include/uapi/drm/drm.h                      |   4 +
>  include/uapi/drm/drm_mode.h                 |  32 +++
>  34 files changed, 728 insertions(+), 100 deletions(-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
