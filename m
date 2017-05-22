Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43272 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934188AbdEVOeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:34:18 -0400
Subject: Re: [PATCH v3 0/5] R-Car DU: Fix IOMMU operation when connected to
 VSP
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <3ed12a08-b1b5-cfd3-c10f-df1baa99b744@ideasonboard.com>
Date: Mon, 22 May 2017 15:34:13 +0100
MIME-Version: 1.0
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I would like this series to go in the same pull-request to the DRM tree as the
previous series you acked.

Again, the series touches both V4L2, and DRM, to provide another fix up the
Rcar-DU driver.

I have reviewed and tested the whole series

Would it be possible to get your Acked-by: again please?

--
Regards

Kieran Bingham



On 22/05/17 15:19, Kieran Bingham wrote:
> Hello,
> 
> This patch series fixes the rcar-du-drm driver to support VSP plane sources
> with an IOMMU. It is available for convenience at
> 
>   git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git vsp-du/iommu-fcp
> 
> On R-Car Gen3 the DU has no direct memory access but sources planes through
> VSP instances. When an IOMMU is inserted between the VSP and memory, the DU
> framebuffers need to be DMA mapped using the VSP device, not the DU device as
> currently done. The same situation can also be reproduced on Gen2 hardware by
> linking the VSP to the DU in DT [1], effectively disabling direct memory
> access by the DU.
> 
> The situation is made quite complex by the fact that different planes can be
> connected to different DU instances, and thus served by different IOMMUs (or,
> in practice on existing hardware, by the same IOMMU but through different
> micro-TLBs). We thus can't allocate and map buffers to the right device in a
> single dma_alloc_wc() operation as done in the DRM CMA GEM helpers.
> 
> However, on such setups, the DU DT node doesn't reference IOMMUs as the DU
> does not perform any direct memory access. We can thus keep the GEM object
> allocation unchanged, and the DMA addresses that we receive in the DU driver
> will be physical addresses. Those buffers then need to be mapped to the VSP
> device when they are associated with planes. Fortunately the atomic framework
> provides two plane helper operations, .prepare_fb() and .cleanup_fb() that we
> can use for this purpose.
> 
> The reality is slightly more complex than this on Gen3, as an FCP device
> instance sits between VSP instances and memory. It is the FCP devices that are
> connected to the IOMMUs, and buffer mapping thus need to be performed using
> the FCP devices. This isn't required on Gen2 as the platforms don't have any
> FCPs.
> 
> Patches 1/5 and 2/5 extend the rcar-fcp driver API to expose the FCP struct
> device. Patch 3/5 then updates the vsp1 driver to map the display lists and
> video buffers through the FCP when it exists. This alone fixes VSP operation
> with an IOMMU on R-Car Gen3 systems.
> 
> Moving on to addressing the DU issue, patch 4/5 extends the vsp1 driver API to
> allow mapping a scatter-gather list to the VSP, with the implementation using
> the FCP devices instead when available. Patch 5/5 finally uses the vsp1
> mapping API in the rcar-du-drm driver to map and unmap buffers when needed.
> 
> The series has been tested on the H2 Lager board and M3-W Salvator-X boards.
> The IOMMU is known not to work properly on the H3 ES1.1, so the H3 Salvator-X
> board hasn't been tested. In all cases both the DU and VSP operation has been
> tested, and tests were run with and without linking the DU and VSP devices to
> the IOMMU in DT.
> 
> For H2, the patches were tested on top of v4.12-rc1 with a set of out-of-tree
> patches to link the VSP and DU to the IOMMUs and to enable VSP+DU combined
> similar to R-Car Gen3, and an additional DMA mapping API patch [2] that fixes
> IOMMU operation on ARM32, currently broken in v4.12-rc1. For M3-W, they were
> were tested on top of renesas-drivers-2017-05-16-v4.12-rc1 with a set of
> out-of-tree patches to add FCP, VSP, DU and IPMMU instances to the M3-W DT, as
> well as a hack for the IPMMU driver to whitelist all bus master devices.
> 
> All tests passed successfully. The issue previously noticed on H3 with
> synchronization between page flip and VSP operation that was caused by buffers
> getting unmapped (and possibly freed) before the VSP was done reading them is
> now gone thanks to the VSP+DU flicker fix that should be merged in v4.13 and
> is available in renesas-drivers-2017-05-16-v4.12-rc1.
> 
> A possible improvement is to modify the GEM object allocation mechanism to use
> non-contiguous memory when the DU driver detects that all the VSP instances it
> is connected to use an IOMMU (possibly through FCP devices).
> 
> [1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg06589.html
> [2] https://www.spinics.net/lists/arm-kernel/msg581410.html
> 
> Laurent Pinchart (4):
>   v4l: rcar-fcp: Don't get/put module reference
>   v4l: rcar-fcp: Add an API to retrieve the FCP device
>   v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
>   drm: rcar-du: Map memory through the VSP device
> 
> Magnus Damm (1):
>   v4l: vsp1: Map the DL and video buffers through the proper bus master
> 
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c    | 74 ++++++++++++++++++++++---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h    |  2 +-
>  drivers/media/platform/rcar-fcp.c        | 17 ++----
>  drivers/media/platform/vsp1/vsp1.h       |  1 +-
>  drivers/media/platform/vsp1/vsp1_dl.c    |  4 +-
>  drivers/media/platform/vsp1/vsp1_drm.c   | 24 ++++++++-
>  drivers/media/platform/vsp1/vsp1_drv.c   |  9 +++-
>  drivers/media/platform/vsp1/vsp1_video.c |  2 +-
>  include/media/rcar-fcp.h                 |  5 ++-
>  include/media/vsp1.h                     |  3 +-
>  10 files changed, 123 insertions(+), 18 deletions(-)
> 
> base-commit: f2c61f98e0b5f8b53b8fb860e5dcdd661bde7d0b
> 
