Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15074 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3HBPuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 11:50:13 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQW00H71UN63X20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Aug 2013 16:50:11 +0100 (BST)
Message-id: <51FBD533.6000703@samsung.com>
Date: Fri, 02 Aug 2013 17:50:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: 'Arun Kumar K' <arun.kk@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
Subject: [GIT PULL FOR 3.11] Exynos/S5P fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Here are couple critical/regression fixes for the exynos/s5p drivers.
Please pull for v3.11.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.11-fixes-1

for you to fetch changes up to 31de1930009b91cd5f0319fb1485549914e2b153:

  exynos4-is: Fix entity unregistration on error path (2013-07-29 22:04:39 +0200)

----------------------------------------------------------------
Arun Kumar K (2):
      exynos4-is: Fix fimc-lite bayer formats
      exynos-gsc: Register v4l2 device

Sachin Kamat (1):
      s5p-g2d: Fix registration failure

Sylwester Nawrocki (1):
      exynos4-is: Fix entity unregistration on error path

 drivers/media/platform/exynos-gsc/gsc-core.c  |    9 ++++++++-
 drivers/media/platform/exynos-gsc/gsc-core.h  |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |    1 +
 drivers/media/platform/exynos4-is/fimc-lite.c |    4 ++--
 drivers/media/platform/exynos4-is/media-dev.c |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c          |    1 +
 6 files changed, 14 insertions(+), 4 deletions(-)

--
Thanks,
Sylwester
