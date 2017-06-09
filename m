Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37837 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbdFIPdu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 11:33:50 -0400
To: LMML <linux-media@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC updates for v4.13
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-id: <f7a1b678-9df4-ff65-dd98-a1d52216dd87@samsung.com>
Date: Fri, 09 Jun 2017 17:33:42 +0200
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170609153346epcas1p45c0c91fe7cd98d9b2a93aaf8a3089cda@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

  [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.13/media/next

for you to fetch changes up to b84da96956f6cfea1b48e60be9e6a0d3ba66a6b0:

  s3c-camif: fix arguments position in a function call (2017-06-05 12:09:03 +0200)

----------------------------------------------------------------
Alexandre Courbot (1):
      s5p-jpeg: fix recursive spinlock acquisition

Benjamin Gaignard (1):
      exynos4-is: use devm_of_platform_populate()

Colin Ian King (1):
      s5p-mfc: fix spelling mistake: "destionation" -> "destination"

Gustavo A. R. Silva (1):
      s3c-camif: fix arguments position in a function call

Nicholas Mc Guire (1):
      s5k6aa: set usleep_range() range greater than 0

Thibault Saunier (1):
      exynos-gsc: Use user configured colorspace if provided

 drivers/media/i2c/s5k6aa.c                     |  2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c   |  9 ++++-----
 drivers/media/platform/exynos-gsc/gsc-core.h   |  1 +
 drivers/media/platform/exynos4-is/fimc-is.c    |  7 ++-----
 .../media/platform/s3c-camif/camif-capture.c   |  4 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c    | 12 +++++++++---
 .../media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  2 +-
 .../media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  2 +-
 8 files changed, 21 insertions(+), 18 deletions(-)

--
Thanks, 
Sylwester
