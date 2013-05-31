Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25906 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3EaIyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:54:39 -0400
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
	inki.dae@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com
Subject: [RFC][PATCH 0/2] dma-buf: add importer private data for reimporting
Date: Fri, 31 May 2013 17:54:45 +0900
Message-id: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

importer private data in dma-buf attachment can be used by importer to
reimport same dma-buf.

Seung-Woo Kim (2):
  dma-buf: add importer private data to attachment
  drm/prime: find gem object from the reimported dma-buf

 drivers/base/dma-buf.c                     |   31 ++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/udl/udl_gem.c              |    1 +
 include/linux/dma-buf.h                    |    4 +++
 6 files changed, 52 insertions(+), 5 deletions(-)

-- 
1.7.4.1

