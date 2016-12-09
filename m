Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:32805 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933396AbcLIMfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 07:35:21 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, magnus.damm@gmail.com,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v1.5 0/6] R-Car DU: Fix IOMMU operation when connected to VSP
Date: Fri,  9 Dec 2016 13:35:06 +0100
Message-Id: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a slightly updated version of Laurent's series that adds the fix
suggested by Magnus Damm and connects the FCP devices on M3-W to their
IPMMU. It also drops the patches that have already been picked up in the
media tree.

With this series and an assortment of patches from the renesas-drivers tree (
    iommu/ipmmu-vmsa: Remove platform data handling
    iommu/ipmmu-vmsa: Rework interrupt code and use bitmap for context
    iommu/ipmmu-vmsa: Break out utlb parsing code
    iommu/ipmmu-vmsa: Break out domain allocation code
    iommu/ipmmu-vmsa: Add new IOMMU_DOMAIN_DMA ops
    iommu/ipmmu-vmsa: ARM and ARM64 archdata access
    iommu/ipmmu-vmsa: Drop LPAE Kconfig dependency
    iommu/ipmmu-vmsa: Introduce features, break out alias
    iommu/ipmmu-vmsa: Add optional root device feature
    iommu/ipmmu-vmsa: Enable multi context support
    iommu/ipmmu-vmsa: Reuse iommu groups
    iommu/ipmmu-vmsa: Make use of IOMMU_OF_DECLARE()
    iommu/ipmmu-vmsa: Teach xlate() to skip disabled iommus
    iommu/ipmmu-vmsa: IPMMU device is 64-bit bus master
    iommu/ipmmu-vmsa: Write IMCTR twice
    iommu/ipmmu-vmsa: Make IMBUSCTR setup optional
    iommu/ipmmu-vmsa: Allow two bit SL0
    iommu/ipmmu-vmsa: Hook up r8a7795 DT matching code
    iommu/ipmmu-vmsa: Add r8a7796 DT binding
    iommu/ipmmu-vmsa: Increase maximum micro-TLBS to 48
    iommu/ipmmu-vmsa: Hook up r8a7796 DT matching code
    arm64: dts: r8a7795: Add IPMMU device nodes
    arm64: dts: r8a7795: Hook up SYS-DMAC to IPMMU
    arm64: dts: r8a7795: Point FCP devices to IPMMU
    arm64: dts: r8a7795: Connect Ethernet AVB to IPMMU
    arm64: dts: r8a7796: Add IPMMU device nodes
    clk: renesas: r8a7796: Add FCP clocks
    clk: renesas: r8a7796: Add VSP clocks
    clk: renesas: r8a7796: Add DU and LVDS clocks
    drm: rcar-du: Add R8A7796 device support
    arm64: dts: renesas: r8a7795: Remove FCP SoC-specific compatible strings
    arm64: dts: renesas: r8a7796: Add FCPF and FCPV instances
    arm64: dts: renesas: r8a7796: Add VSP instances
    arm64: dts: renesas: r8a7796: Add DU device to DT
    arm64: dts: renesas: r8a7796-salvator-x: Enable DU
), I can enable IPMMU on both the H3 and M3-W Salvator-X boards with no ill
effects on the results of the vsp-tests suite.

CU
Uli


Laurent Pinchart (4):
  v4l: rcar-fcp: Don't get/put module reference
  v4l: rcar-fcp: Add an API to retrieve the FCP device
  v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
  drm: rcar-du: Map memory through the VSP device

Ulrich Hecht (2):
  v4l: vsp1: Provide display list and VB2 queue with FCP device
  arm64: dts: r8a7796: Connect FCP devices to IPMMU

 arch/arm64/boot/dts/renesas/r8a7796.dtsi |  3 ++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    | 74 +++++++++++++++++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h    |  2 +
 drivers/media/platform/rcar-fcp.c        | 17 ++++----
 drivers/media/platform/vsp1/vsp1_dl.c    | 12 ++++--
 drivers/media/platform/vsp1/vsp1_drm.c   | 24 +++++++++++
 drivers/media/platform/vsp1/vsp1_video.c |  6 ++-
 include/media/rcar-fcp.h                 |  5 +++
 include/media/vsp1.h                     |  3 ++
 9 files changed, 127 insertions(+), 19 deletions(-)

-- 
2.7.4

