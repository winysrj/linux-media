Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35421 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932305AbcIGIBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 04:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 7 Sep 2016 17:01:06 +0900
Message-ID: <CANqRtoQZP+t541GjBNUsB2enP1Rr1M06UPwcj96PQo0CYWiKvA@mail.gmail.com>
Subject: Re: [PATCH 0/6] R-Car DU: Fix IOMMU operation when connected to VSP
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your help with this. Good to see that the DU driver is
getting closer to work with the IPMMU hardware! Please see below for
some feedback from me.

On Fri, Aug 19, 2016 at 5:39 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Hello,
>
> This patch series fixes the rcar-du-drm driver to support VSP plane sources
> with an IOMMU. It is available for convenience at
>
>         git://linuxtv.org/pinchartl/media.git iommu/devel/du
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
> Patches 1/6 and 2/6 unconstify the state argument to the .prepare_fb() and
> .cleanup_fb() operations, to allow storing the mapped buffer addresses in the
> state. Patches 3/6 and 4/6 then extend the rcar-fcp driver API to expose the
> FCP struct device. Patch 5/6 extends the vsp1 driver API to allow mapping a
> scatter-gather list to the VSP, with the implementation using the FCP devices
> instead when available. Patch 6/6 then use the vsp1 mapping API in the
> rcar-du-drm driver to map and unmap buffers when needed.
>
> The series has been tested on Gen2 (Lager) only as the Gen3 IOMMU is known to
> be broken.

Slight clarification, the R-Car Gen3 family as a whole does not have
broken IPMMU hardware. Early R-Car H3 revisions do require some errata
handling though, but M3-W and later ES versions and MP of H3 will be
fine. Given the early R-Car H3 errata I agree it makes sense to
develop and test this series on R-Car Gen2 though.

> A possible improvement is to modify the GEM object allocation mechanism to use
> non-contiguous memory when the DU driver detects that all the VSP instances it
> is connected to use an IOMMU (possibly through FCP devices).
>
> An issue has been noticed with synchronization between page flip and VSP
> operation. Buffers get unmapped (and possibly freed) before the VSP is done
> reading them. The problem isn't new, but is much more noticeable with IOMMU
> support enabled as any hardware access to unmapped memory generates an IOMMU
> page fault immediately.
>
> The series unfortunately contain a dependency between DRM and V4L2 patches,
> complicating upstream merge. As there's no urgency to merge patch 6/6 due to
> the IOMMU being broken on Gen3 at the moment, I propose merging patches
> 1/6-2/6 and 3/6-5/6 independently for the next kernel release.
>
> I would particularly appreciate feedback on the APIs introduced by patches 4/6
> and 5/6.

The code in general looks fine to me. The APIs introduced by patches
4/6 and 5/6 seem quite straightforward. Is there something I can do to
help with those?

> [1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg06589.html
>
> Laurent Pinchart (6):
>   drm: Don't implement empty prepare_fb()/cleanup_fb()
>   drm: Unconstify state argument to prepare_fb()/cleanup_fb()
>   v4l: rcar-fcp: Don't get/put module reference
>   v4l: rcar-fcp: Add an API to retrieve the FCP device
>   v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
>   drm: rcar-du: Map memory through the VSP device
>
>  drivers/gpu/drm/arc/arcpgu_crtc.c               |  2 -
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c |  4 +-
>  drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c     | 15 -----
>  drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c | 15 -----
>  drivers/gpu/drm/i915/intel_display.c            |  4 +-
>  drivers/gpu/drm/i915/intel_drv.h                |  4 +-
>  drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c       |  4 +-
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c       |  4 +-
>  drivers/gpu/drm/omapdrm/omap_plane.c            |  4 +-
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c           | 74 +++++++++++++++++++++++--
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h           |  2 +
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c     |  4 +-
>  drivers/gpu/drm/tegra/dc.c                      | 17 ------
>  drivers/gpu/drm/vc4/vc4_plane.c                 |  2 -
>  drivers/media/platform/rcar-fcp.c               | 17 +++---
>  drivers/media/platform/vsp1/vsp1_drm.c          | 24 ++++++++
>  include/drm/drm_modeset_helper_vtables.h        |  4 +-
>  include/media/rcar-fcp.h                        |  5 ++
>  include/media/vsp1.h                            |  3 +
>  19 files changed, 126 insertions(+), 82 deletions(-)

So I've spent some time to test this series on R-Car H3. In particular
I've tested the code in renesas-drivers-2016-08-23-v4.8-rc3.

Since I did some early prototyping to enable the DU with IPMMU myself
I noticed that some further changes may be needed. For instance, the
Display List code and VB2 queue both need a struct device from
somewhere. I propose something like the below, using the API from
patch 4/6 in this series:

--- 0001/drivers/media/platform/vsp1/vsp1_dl.c
+++ work/drivers/media/platform/vsp1/vsp1_dl.c 2016-09-01
06:18:17.140607110 +0900
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>

+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_dl.h"

@@ -130,12 +132,12 @@ static int vsp1_dl_body_init(struct vsp1
      size_t extra_size)
 {
  size_t size = num_entries * sizeof(*dlb->entries) + extra_size;
+ struct device *fcp = rcar_fcp_get_device(vsp1->fcp);

  dlb->vsp1 = vsp1;
  dlb->size = size;
-
- dlb->entries = dma_alloc_wc(vsp1->dev, dlb->size, &dlb->dma,
-    GFP_KERNEL);
+ dlb->entries = dma_alloc_wc(fcp ? fcp : vsp1->dev,
+    dlb->size, &dlb->dma, GFP_KERNEL);
  if (!dlb->entries)
  return -ENOMEM;

@@ -147,7 +149,10 @@ static int vsp1_dl_body_init(struct vsp1
  */
 static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
 {
- dma_free_wc(dlb->vsp1->dev, dlb->size, dlb->entries, dlb->dma);
+ struct device *fcp = rcar_fcp_get_device(dlb->vsp1->fcp);
+
+ dma_free_wc(fcp ? fcp : dlb->vsp1->dev,
+    dlb->size, dlb->entries, dlb->dma);
 }

 /**
--- 0001/drivers/media/platform/vsp1/vsp1_video.c
+++ work/drivers/media/platform/vsp1/vsp1_video.c 2016-09-01
06:20:02.940607110 +0900
@@ -27,6 +27,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>

+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
@@ -939,6 +941,7 @@ struct vsp1_video *vsp1_video_create(str
 {
  struct vsp1_video *video;
  const char *direction;
+ struct device *fcp;
  int ret;

  video = devm_kzalloc(vsp1->dev, sizeof(*video), GFP_KERNEL);
@@ -996,7 +999,8 @@ struct vsp1_video *vsp1_video_create(str
  video->queue.ops = &vsp1_video_queue_qops;
  video->queue.mem_ops = &vb2_dma_contig_memops;
  video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
- video->queue.dev = video->vsp1->dev;
+ fcp = rcar_fcp_get_device(vsp1->fcp);
+ video->queue.dev = fcp ? fcp : video->vsp1->dev;
  ret = vb2_queue_init(&video->queue);
  if (ret < 0) {
  dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");

Can you please consider to include or rework the above code in your
next version of this series?

Not sure if R-Car Gen2 is affected or not, but without the above code
I get the following trap during boot on r8a7795 Salvator-X:

ipmmu-vmsa febd0000.mmu: Unhandled faut: status 0x00000101 iova 0x7f09a000

Thanks,

/ magnus
