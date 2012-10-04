Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2JDHYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:36 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:34 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:34 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 00/14] drm: exynos: hdmi: add dt based support for exynos5
 hdmi
Date: Thu, 04 Oct 2012 21:12:38 +0530
Message-id: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set adds the DT based support for Samsung's Exynos5250 in DRM-HDMI.
It includes disabling of hdmi internal interrupt, suppport for platform
variants for hdmi and mixer, support to disable video processor based on
platform type and removal of drm common platform data.

This patchset is based on branch exynos-drm-next at 
git://git.infradead.org/users/kmpark/linux-samsung (linux v3.6-rc4)

v2:
- removed MXR_VER_INVALID
- moved layer update from vsync ISR to mixer_graph_buffer
- stopped enabling vsync interrupt after poweron

Rahul Sharma (9):
  drm: exynos: remove drm hdmi platform data struct
  drm: exynos: hdmi: add support for exynos5 ddc
  drm: exynos: hdmi: add support for exynos5 hdmiphy
  drm: exynos: hdmi: add support for platform variants for mixer
  drm: exynos: hdmi: add support to disable video processor in mixer
  drm: exynos: hdmi: add support for exynos5 mixer
  drm: exynos: hdmi: replace is_v13 with version check in hdmi
  drm: exynos: hdmi: add support for exynos5 hdmi
  drm: exynos: hdmi: remove drm common hdmi platform data struct

Tomasz Stanislawski (5):
  media: s5p-hdmi: add HPD GPIO to platform data
  drm: exynos: hdmi: support for platform variants
  drm: exynos: hdmi: fix interrupt handling
  drm: exynos: hdmi: use s5p-hdmi platform data
  drm: exynos: hdmi: turn off HPD interrupt in HDMI chip

 drivers/gpu/drm/exynos/exynos_ddc.c      |   22 +++-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c |   51 ++++----
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h |    2 +
 drivers/gpu/drm/exynos/exynos_hdmi.c     |  196 +++++++++++++++++++-------
 drivers/gpu/drm/exynos/exynos_hdmiphy.c  |   12 ++-
 drivers/gpu/drm/exynos/exynos_mixer.c    |  227 +++++++++++++++++++++++-------
 drivers/gpu/drm/exynos/regs-mixer.h      |    3 +
 include/drm/exynos_drm.h                 |   27 ----
 include/media/s5p_hdmi.h                 |    2 +
 9 files changed, 378 insertions(+), 164 deletions(-)

