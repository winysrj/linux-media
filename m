Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:16782 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2HIJgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 05:36:37 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@linaro.org,
	inki.dae@samsung.com, daniel.vetter@ffwll.ch, rob@ti.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	jy0922.shim@samsung.com, sw0312.kim@samsung.com,
	dan.j.williams@intel.com
Subject: [PATCH v2 0/2] Enhance DMABUF with reference counting for exporter
 module
Date: Thu, 09 Aug 2012 11:36:20 +0200
Message-id: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
This patchset adds reference counting for an exporter module to DMABUF
framework.  Moreover, it adds setup of an owner field for exporters in DRM
subsystem.

v1: Original
v2:
  - split patch into DMABUF and DRM part
  - allow owner to be NULL

Regards,
Tomasz Stanislawski

Tomasz Stanislawski (2):
  dma-buf: add reference counting for exporter module
  drm: set owner field to for all DMABUF exporters

 Documentation/dma-buf-sharing.txt          |    3 ++-
 drivers/base/dma-buf.c                     |    9 ++++++++-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
 drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
 include/linux/dma-buf.h                    |    2 ++
 8 files changed, 17 insertions(+), 2 deletions(-)

-- 
1.7.9.5

