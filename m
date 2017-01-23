Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58838 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbdAWQBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 11:01:07 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OK800W0BPD5OU20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Jan 2017 00:51:05 +0900 (KST)
To: LMML <linux-media@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR v4.11] Samsung SoC related updates
Message-id: <2eec1713-342b-f1b8-7d36-9455ec95004b@samsung.com>
Date: Mon, 23 Jan 2017 16:51:00 +0100
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20170123155103epcas1p404f5c648b21e0a7120ef5e0b6b0ec003@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It's just a few clean up and one fix patch this time.

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.11/media/next

for you to fetch changes up to d922b4028d8176cb8072a391a2f623a51ded52cd:

  exynos4-is: constify v4l2_subdev_* structures (2017-01-23 13:51:50 +0100)

----------------------------------------------------------------
Arvind Yadav (1):
      exynos4-is: fimc-is: Unmap region obtained by of_iomap()

Bhumika Goyal (1):
      exynos4-is: constify v4l2_subdev_* structures

Javier Martinez Canillas (1):
      exynos-gsc: Fix unbalanced pm_runtime_enable() error

Shailendra Verma (2):
      exynos4-is: Clean up file handle in open() error path
      exynos-gsc: Clean up file handle in open() error path

 drivers/media/platform/exynos-gsc/gsc-core.c     | 1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c      | 2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c | 4 ++--
 drivers/media/platform/exynos4-is/fimc-is.c      | 8 ++++++--
 drivers/media/platform/exynos4-is/fimc-m2m.c     | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c    | 8 ++++----
 6 files changed, 15 insertions(+), 10 deletions(-)

-- 
Thanks,
Sylwester
