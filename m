Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38728 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbcCKRve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 12:51:34 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O3V00ANOYXVPS60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2016 17:51:31 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTPA id <0O3V00AL4YXUPD30@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2016 17:51:31 +0000 (GMT)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Exynos/S5P SoC driver updates
To: LMML <linux-media@vger.kernel.org>
Message-id: <56E3059E.2010903@samsung.com>
Date: Fri, 11 Mar 2016 18:51:26 +0100
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a few minor fixes and some long awaiting clean up
patches for exynos/s5p drivers.

The following changes since commit de08b5a8be0df1eb7c796b0fe6b30cf1d03d14a6:

  [media] v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links (2016-03-05 09:10:01 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.6/media/next

for you to fetch changes up to 95a3dcc2ae09a0b24f48662850ee886f1e1f7ab9:

  s5p-tv: constify mxr_layer_ops structures (2016-03-11 18:06:32 +0100)

----------------------------------------------------------------
Andrzej Pietrasiewicz (1):
      s5p-jpeg: Adjust buffer size for Exynos 4412

Javier Martinez Canillas (1):
      exynos4-is: Put node before s5pcsis_parse_dt() return error

Julia Lawall (1):
      s5p-tv: constify mxr_layer_ops structures

Krzysztof Kozlowski (1):
      exynos4-is: Add missing port parent of_node_put on error paths

Marek Szyprowski (4):
      exynos-gsc: remove non-device-tree init code
      s5p-g2d: remove non-device-tree init code
      s5p-mfc: remove non-device-tree init code
      exynos4-is: remove non-device-tree init code

 drivers/media/platform/exynos-gsc/gsc-core.c    | 33 +++------------
 drivers/media/platform/exynos-gsc/gsc-core.h    |  1 -
 drivers/media/platform/exynos4-is/fimc-core.c   | 50 -----------------------
 drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c   |  6 ++-
 drivers/media/platform/s5p-g2d/g2d.c            | 27 +++---------
 drivers/media/platform/s5p-g2d/g2d.h            |  5 ---
 drivers/media/platform/s5p-jpeg/jpeg-core.c     |  7 +++-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 37 +++--------------
 drivers/media/platform/s5p-tv/mixer.h           |  2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c |  2 +-
 drivers/media/platform/s5p-tv/mixer_video.c     |  2 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c  |  2 +-
 13 files changed, 33 insertions(+), 145 deletions(-)

-- 
Thanks,
Sylwester
