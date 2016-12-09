Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59424 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933127AbcLIQVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:21:21 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A83FB60097
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 18:21:17 +0200 (EET)
Date: Fri, 9 Dec 2016 18:21:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] Media pipeline and graph walk cleanups and fixes
Message-ID: <20161209162116.GP16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains fixes and cleanups to the media pipeline and
graph walk code.

Please pull.


The following changes since commit 365fe4e0ce218dc5ad10df17b150a366b6015499:

  [media] mn88472: fix chip id check on probe (2016-12-01 12:47:22 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git routing-prepare

for you to fetch changes up to 9860755b60c5164624fbe685f8d95c9bff9469f0:

  davinci: Use a local media device pointer instead (2016-12-09 17:41:35 +0200)

----------------------------------------------------------------
Sakari Ailus (9):
      media: entity: Fix stream count check
      media: entity: Be vocal about failing sanity checks
      media: Rename graph and pipeline structs and functions
      media: entity: Split graph walk iteration into two functions
      media: Use single quotes to quote entity names
      media: entity: Add debug information to graph walk
      omap3isp: Use a local media device pointer instead
      xilinx: Use a local media device pointer instead
      davinci: Use a local media device pointer instead

 Documentation/media/kapi/mc-core.rst               |  18 +--
 drivers/media/media-device.c                       |   8 +-
 drivers/media/media-entity.c                       | 162 ++++++++++++---------
 drivers/media/platform/exynos4-is/fimc-capture.c   |   8 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   8 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  16 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  16 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  16 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  16 +-
 drivers/media/usb/au0828/au0828-core.c             |   4 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |  18 +--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  25 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  32 ++--
 include/media/media-device.h                       |   2 +-
 include/media/media-entity.h                       |  65 ++++-----
 20 files changed, 227 insertions(+), 209 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
