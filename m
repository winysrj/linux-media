Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56983 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753002AbeBSPpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:06 -0500
From: Maciej Purski <m.purski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Purski <m.purski@samsung.com>
Subject: [PATCH 0/8] Use clk bulk API in exynos5433 drivers
Date: Mon, 19 Feb 2018 16:43:58 +0100
Message-id: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <CGME20180219154456eucas1p178a82b3bb643028dc7c99ccca9c6eaca@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

the main goal of this patchset is to simplify clk management code in
exynos5433 drivers by using clk bulk API. In order to achieve that,
patch #1 adds a new function to clk core, which dynamically allocates
clk_bulk_data array and fills its id fields.

Best regards,

Maciej Purski

Maciej Purski (8):
  clk: Add clk_bulk_alloc functions
  media: s5p-jpeg: Use bulk clk API
  drm/exynos/decon: Use clk bulk API
  drm/exynos/dsi: Use clk bulk API
  drm/exynos: mic: Use clk bulk API
  drm/exynos/hdmi: Use clk bulk API
  [media] exynos-gsc: Use clk bulk API
  [media] s5p-mfc: Use clk bulk API

 drivers/clk/clk-bulk.c                          | 16 +++++
 drivers/clk/clk-devres.c                        | 37 +++++++++--
 drivers/gpu/drm/exynos/exynos5433_drm_decon.c   | 50 +++++----------
 drivers/gpu/drm/exynos/exynos_drm_dsi.c         | 68 +++++++++-----------
 drivers/gpu/drm/exynos/exynos_drm_mic.c         | 44 +++++--------
 drivers/gpu/drm/exynos/exynos_hdmi.c            | 85 ++++++++-----------------
 drivers/media/platform/exynos-gsc/gsc-core.c    | 55 ++++++----------
 drivers/media/platform/exynos-gsc/gsc-core.h    |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c     | 45 ++++++-------
 drivers/media/platform/s5p-jpeg/jpeg-core.h     |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 41 +++++-------
 include/linux/clk.h                             | 64 +++++++++++++++++++
 13 files changed, 263 insertions(+), 252 deletions(-)

-- 
2.7.4
