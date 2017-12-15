Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25544 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdLOQsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 11:48:25 -0500
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC related updates
Message-id: <5e06c3d6-a3f2-c146-9176-9fc26f5edaa5@samsung.com>
Date: Fri, 15 Dec 2017 17:48:19 +0100
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20171215164822epcas1p48be80ad37f83734d9a4f28aabff6a78d@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 0ca4e3130402caea8731a7b54afde56a6edb17c9:

  media: pxa_camera: rename the soc_camera_ prefix to pxa_camera_ (2017-12-14 12:40:01 -0500)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.16/media/next

for you to fetch changes up to 8d10c3a3fa56badd9d8691b59a88e7f00fdeaa7b:

  s5p-jpeg: Fix off-by-one problem (2017-12-15 17:33:50 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      exynos4-is: properly initialize frame format

Flavio Ceolin (1):
      s5p-jpeg: Fix off-by-one problem

Marek Szyprowski (3):
      exynos-gsc: Drop obsolete capabilities
      exynos4-is: Drop obsolete capabilities
      exynos4-is: Remove dependency on obsolete SoC support

Shuah Khan (2):
      s5p-mfc: Remove firmware buf null check in s5p_mfc_load_firmware()
      s5p-mfc: Fix lock contention - request_firmware() once

Simon Shields (1):
      exynos4-is: Check pipe is valid before calling subdev

Sylwester Nawrocki (1):
      s5p-mfc: Fix encoder menu controls initialization

 drivers/media/platform/exynos-gsc/gsc-m2m.c     |  4 +---
 drivers/media/platform/exynos4-is/Kconfig       |  2 +-
 drivers/media/platform/exynos4-is/fimc-core.c   |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c    | 14 +++++++-------
 drivers/media/platform/exynos4-is/fimc-lite.c   |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c    | 10 +---------
 drivers/media/platform/s5p-jpeg/jpeg-core.c     |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 10 +++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  2 +-
 include/media/drv-intf/exynos-fimc.h            |  3 ++-
 12 files changed, 30 insertions(+), 30 deletions(-)

-- 
Regards,
Sylwester
