Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11599 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3LCSYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 13:24:38 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8000F7TT1G740@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:24:37 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MX8009DTTT1PB70@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:24:37 +0000 (GMT)
Message-id: <529E21E4.1040708@samsung.com>
Date: Tue, 03 Dec 2013 19:24:36 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] git://linuxtv.org/snawrocki/samsung.git
 v3.14-exynos4-is-fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

  [media] media: marvell-ccic: use devm to release clk (2013-11-29 14:46:47 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.14-exynos4-is-fixes

for you to fetch changes up to 1844e95580fb02609e5b2ee4a614f03c5ccb5be0:

  exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-02 22:57:01 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      exynos4-is: Cleanup a define in mipi-csis driver

Roel Kluin (1):
      exynos4-is: fimc-lite: Index out of bounds if no pixelcode found

Sylwester Nawrocki (1):
      exynos4-is: Simplify fimc-is hardware polling helpers

 drivers/media/platform/exynos4-is/fimc-is-regs.c  |   36 ++++-----------------
 drivers/media/platform/exynos4-is/fimc-is-regs.h  |    1 -
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    4 +--
 drivers/media/platform/exynos4-is/mipi-csis.c     |    2 +-
 4 files changed, 9 insertions(+), 34 deletions(-)
