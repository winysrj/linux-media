Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26957C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BBE2085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfCSV5c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:57:32 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:57479 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCSV5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:32 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 5D43CFF804;
        Tue, 19 Mar 2019 21:57:26 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 00/20] drm: Split out the formats API and move it to a common place
Date:   Tue, 19 Mar 2019 22:57:05 +0100
Message-Id: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

DRM comes with an extensive format support to retrieve the various
parameters associated with a given format (such as the subsampling, or the
bits per pixel), as well as some helpers and utilities to ease the driver
development.

v4l2, on the other side, doesn't provide such facilities, leaving each
driver reimplement a subset of the formats parameters for the one supported
by that particular driver. This leads to a lot of duplication and
boilerplate code in the v4l2 drivers.

This series tries to address this by moving the DRM format API into lib and
turning it into a more generic API. In order to do this, we've needed to do
some preliminary changes on the DRM drivers, then moved the API and finally
converted a v4l2 driver to give an example of how such library could be
used.

Let me know what you think,
Maxime

Maxime Ripard (20):
  drm: Remove users of drm_format_num_planes
  drm: Remove users of drm_format_(horz|vert)_chroma_subsampling
  drm/fourcc: Pass the format_info pointer to drm_format_plane_cpp
  drm/fourcc: Pass the format_info pointer to drm_format_plane_width/height
  drm: Replace instances of drm_format_info by drm_get_format_info
  lib: Add video format information library
  drm/fb: Move from drm_format_info to image_format_info
  drm/malidp: Convert to generic image format library
  drm/client: Convert to generic image format library
  drm/exynos: Convert to generic image format library
  drm/i915: Convert to generic image format library
  drm/ipuv3: Convert to generic image format library
  drm/msm: Convert to generic image format library
  drm/omap: Convert to generic image format library
  drm/rockchip: Convert to generic image format library
  drm/tegra: Convert to generic image format library
  drm/fourcc: Remove old DRM format API
  lib: image-formats: Add v4l2 formats support
  lib: image-formats: Add more functions
  media: sun6i: Convert to the image format API

 drivers/gpu/drm/Kconfig                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c              |   4 +-
 drivers/gpu/drm/arm/malidp_drv.c                    |   5 +-
 drivers/gpu/drm/arm/malidp_hw.c                     |   4 +-
 drivers/gpu/drm/arm/malidp_mw.c                     |   2 +-
 drivers/gpu/drm/arm/malidp_planes.c                 |   8 +-
 drivers/gpu/drm/armada/armada_fb.c                  |   3 +-
 drivers/gpu/drm/armada/armada_overlay.c             |   3 +-
 drivers/gpu/drm/armada/armada_plane.c               |   3 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c     |  13 +-
 drivers/gpu/drm/bochs/bochs.h                       |   4 +-
 drivers/gpu/drm/bochs/bochs_hw.c                    |   3 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c               |   4 +-
 drivers/gpu/drm/cirrus/cirrus_main.c                |   4 +-
 drivers/gpu/drm/drm_atomic.c                        |   1 +-
 drivers/gpu/drm/drm_client.c                        |   8 +-
 drivers/gpu/drm/drm_crtc.c                          |   1 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                 |   5 +-
 drivers/gpu/drm/drm_fb_helper.c                     |  15 +-
 drivers/gpu/drm/drm_fourcc.c                        | 318 +-----
 drivers/gpu/drm/drm_framebuffer.c                   |  11 +-
 drivers/gpu/drm/drm_gem_framebuffer_helper.c        |   5 +-
 drivers/gpu/drm/drm_plane.c                         |   1 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c              |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c             |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.h             |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_scaler.c          |   3 +-
 drivers/gpu/drm/gma500/framebuffer.c                |   4 +-
 drivers/gpu/drm/i915/i915_drv.h                     |   6 +-
 drivers/gpu/drm/i915/intel_display.c                |  15 +-
 drivers/gpu/drm/i915/intel_sprite.c                 |   3 +-
 drivers/gpu/drm/imx/ipuv3-plane.c                   |  20 +-
 drivers/gpu/drm/mediatek/mtk_drm_fb.c               |   8 +-
 drivers/gpu/drm/meson/meson_overlay.c               |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c         |  11 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c           |  10 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c           |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c          |  25 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c            |   8 +-
 drivers/gpu/drm/msm/msm_fb.c                        |  18 +-
 drivers/gpu/drm/omapdrm/dss/dispc.c                 |   9 +-
 drivers/gpu/drm/omapdrm/omap_fb.c                   |  15 +-
 drivers/gpu/drm/radeon/radeon_fb.c                  |   4 +-
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c          |  17 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c         |  14 +-
 drivers/gpu/drm/selftests/Makefile                  |   3 +-
 drivers/gpu/drm/selftests/drm_modeset_selftests.h   |   3 +-
 drivers/gpu/drm/selftests/test-drm_format.c         | 280 +----
 drivers/gpu/drm/selftests/test-drm_modeset_common.h |   3 +-
 drivers/gpu/drm/stm/ltdc.c                          |   2 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c               |   7 +-
 drivers/gpu/drm/sun4i/sun4i_frontend.c              |  19 +-
 drivers/gpu/drm/sun4i/sun8i_ui_layer.c              |   2 +-
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c              |   6 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c             |   6 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.h             |   5 +-
 drivers/gpu/drm/tegra/fb.c                          |  14 +-
 drivers/gpu/drm/tegra/plane.c                       |   4 +-
 drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c      |   2 +-
 drivers/gpu/drm/vc4/vc4_plane.c                     |  15 +-
 drivers/gpu/drm/zte/zx_plane.c                      |   6 +-
 drivers/gpu/ipu-v3/ipu-pre.c                        |   3 +-
 drivers/gpu/ipu-v3/ipu-prg.c                        |   3 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c  |  88 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h  |  46 +-
 include/drm/drm_fourcc.h                            | 219 +---
 include/drm/drm_framebuffer.h                       |   3 +-
 include/drm/drm_mode_config.h                       |   4 +-
 include/linux/image-formats.h                       | 253 ++++-
 lib/Kconfig                                         |   7 +-
 lib/Makefile                                        |   3 +-
 lib/image-formats-selftests.c                       | 326 +++++-
 lib/image-formats.c                                 | 869 +++++++++++++-
 73 files changed, 1719 insertions(+), 1126 deletions(-)
 delete mode 100644 drivers/gpu/drm/selftests/test-drm_format.c
 create mode 100644 include/linux/image-formats.h
 create mode 100644 lib/image-formats-selftests.c
 create mode 100644 lib/image-formats.c

base-commit: 98f41dc3b3eeabfc80d5d5eb1c1a6294ff59b4ec
-- 
git-series 0.9.1
