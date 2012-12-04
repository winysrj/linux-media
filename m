Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32850 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2LDJYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 04:24:16 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEI001LH25AW040@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 09:26:52 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEI001TW24EBQ70@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 09:24:14 +0000 (GMT)
Message-id: <50BDC13D.2080100@samsung.com>
Date: Tue, 04 Dec 2012 10:24:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8-rc] s5p-fimc driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

the following are just two bug fixes for Exynos FIMC/MIPI-CSIS drivers.
Please pull for 3.8.

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check
(2012-11-28 10:54:46 -0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_s5p_fimc_fixes

for you to fetch changes up to c3f9f35d39a15bbfc038fb53d143337a41cfc488:

  s5p-csis: Correct the event counters logging (2012-12-03 10:17:52 +0100)

----------------------------------------------------------------
Sylwester Nawrocki (2):
      s5p-fimc: Fix horizontal/vertical image flip
      s5p-csis: Correct the event counters logging

 drivers/media/platform/s5p-fimc/fimc-reg.c  |    8 ++++----
 drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--

Regards,
Sylwester
