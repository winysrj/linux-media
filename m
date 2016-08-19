Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51084 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755125AbcHSIje (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/6] R-Car DU: Fix IOMMU operation when connected to VSP
Date: Fri, 19 Aug 2016 11:39:28 +0300
Message-Id: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series fixes the rcar-du-drm driver to support VSP plane sources
with an IOMMU. It is available for convenience at

	git://linuxtv.org/pinchartl/media.git iommu/devel/du

On R-Car Gen3 the DU has no direct memory access but sources planes through
VSP instances. When an IOMMU is inserted between the VSP and memory, the DU
framebuffers need to be DMA mapped using the VSP device, not the DU device as
currently done. The same situation can also be reproduced on Gen2 hardware by
linking the VSP to the DU in DT [1], effectively disabling direct memory
access by the DU.

The situation is made quite complex by the fact that different planes can be
connected to different DU instances, and thus served by different IOMMUs (or,
in practice on existing hardware, by the same IOMMU but through different
micro-TLBs). We thus can't allocate and map buffers to the right device in a
single dma_alloc_wc() operation as done in the DRM CMA GEM helpers.

However, on such setups, the DU DT node doesn't reference IOMMUs as the DU
does not perform any direct memory access. We can thus keep the GEM object
allocation unchanged, and the DMA addresses that we receive in the DU driver
will be physical addresses. Those buffers then need to be mapped to the VSP
device when they are associated with planes. Fortunately the atomic framework
provides two plane helper operations, .prepare_fb() and .cleanup_fb() that we
can use for this purpose.

The reality is slightly more complex than this on Gen3, as an FCP device
instance sits between VSP instances and memory. It is the FCP devices that are
connected to the IOMMUs, and buffer mapping thus need to be performed using
the FCP devices. This isn't required on Gen2 as the platforms don't have any
FCPs.

Patches 1/6 and 2/6 unconstify the state argument to the .prepare_fb() and
.cleanup_fb() operations, to allow storing the mapped buffer addresses in the
state. Patches 3/6 and 4/6 then extend the rcar-fcp driver API to expose the
FCP struct device. Patch 5/6 extends the vsp1 driver API to allow mapping a
scatter-gather list to the VSP, with the implementation using the FCP devices
instead when available. Patch 6/6 then use the vsp1 mapping API in the
rcar-du-drm driver to map and unmap buffers when needed.

The series has been tested on Gen2 (Lager) only as the Gen3 IOMMU is known to
be broken.

A possible improvement is to modify the GEM object allocation mechanism to use
non-contiguous memory when the DU driver detects that all the VSP instances it
is connected to use an IOMMU (possibly through FCP devices).

An issue has been noticed with synchronization between page flip and VSP
operation. Buffers get unmapped (and possibly freed) before the VSP is done
reading them. The problem isn't new, but is much more noticeable with IOMMU
support enabled as any hardware access to unmapped memory generates an IOMMU
page fault immediately.

The series unfortunately contain a dependency between DRM and V4L2 patches,
complicating upstream merge. As there's no urgency to merge patch 6/6 due to
the IOMMU being broken on Gen3 at the moment, I propose merging patches
1/6-2/6 and 3/6-5/6 independently for the next kernel release.

I would particularly appreciate feedback on the APIs introduced by patches 4/6
and 5/6.

[1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg06589.html

Laurent Pinchart (6):
  drm: Don't implement empty prepare_fb()/cleanup_fb()
  drm: Unconstify state argument to prepare_fb()/cleanup_fb()
  v4l: rcar-fcp: Don't get/put module reference
  v4l: rcar-fcp: Add an API to retrieve the FCP device
  v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
  drm: rcar-du: Map memory through the VSP device

 drivers/gpu/drm/arc/arcpgu_crtc.c               |  2 -
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c |  4 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c     | 15 -----
 drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c | 15 -----
 drivers/gpu/drm/i915/intel_display.c            |  4 +-
 drivers/gpu/drm/i915/intel_drv.h                |  4 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c       |  4 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c       |  4 +-
 drivers/gpu/drm/omapdrm/omap_plane.c            |  4 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c           | 74 +++++++++++++++++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h           |  2 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c     |  4 +-
 drivers/gpu/drm/tegra/dc.c                      | 17 ------
 drivers/gpu/drm/vc4/vc4_plane.c                 |  2 -
 drivers/media/platform/rcar-fcp.c               | 17 +++---
 drivers/media/platform/vsp1/vsp1_drm.c          | 24 ++++++++
 include/drm/drm_modeset_helper_vtables.h        |  4 +-
 include/media/rcar-fcp.h                        |  5 ++
 include/media/vsp1.h                            |  3 +
 19 files changed, 126 insertions(+), 82 deletions(-)

-- 
Regards,

Laurent Pinchart

