Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30886 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3FYSQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 14:16:00 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY00LJSO2M2550@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:15:58 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MOY00JXTO2LM660@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:15:57 +0100 (BST)
Message-id: <51C9DE5C.4010606@samsung.com>
Date: Tue, 25 Jun 2013 20:15:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] platform/exynos4-is updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This change set includes mostly fixes to the exynos4-is and patches 
to add support for some IPs of the Exynos5 SoC series at this driver. 
If it looks OK and it is too late for 3.11 already, please just queue 
for 3.12.

The following changes since commit 188af63c0af2d7ef395bc94e3efa173f34dae03d:

  Merge branch 'v4l_for_linus' into patchwork (2013-06-25 07:25:09 -0300)

are available in the git repository at:


  git://linuxtv.org/snawrocki/samsung.git for-v3.11-3

for you to fetch changes up to a2700d26f1fc301bf3d2285029d2910eb01ae3b4:

  exynos4-is: Correct colorspace handling at FIMC-LITE (2013-06-25 13:41:59 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (12):
      exynos4-is: Drop drvdata handling in fimc-lite for non-dt platforms
      exynos4-is: Add Exynos5250 SoC support to fimc-lite driver
      exynos4-is: Add support for Exynos5250 MIPI-CSIS
      exynos4-is: Change fimc-is firmware file names
      Documentation: Update driver's directory in video4linux/fimc.txt
      MAINTAINERS: Update S5P/Exynos FIMC driver entry
      exynos4-is: Fix format propagation on FIMC-LITE.n subdevs
      exynos4-is: Set valid initial format at FIMC-LITE
      exynos4-is: Fix format propagation on FIMC-IS-ISP subdev
      exynos4-is: Set valid initial format on FIMC-IS-ISP subdev pads
      exynos4-is: Set valid initial format on FIMC.n subdevs
      exynos4-is: Correct colorspace handling at FIMC-LITE

 .../devicetree/bindings/media/exynos-fimc-lite.txt |    6 +-
 .../bindings/media/samsung-mipi-csis.txt           |    4 +-
 Documentation/video4linux/fimc.txt                 |   21 +--
 MAINTAINERS                                        |   18 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   19 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  112 +++++++++---
 drivers/media/platform/exynos4-is/fimc-isp.h       |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   53 +++++-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h  |   10 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  185 ++++++++++++++------
 drivers/media/platform/exynos4-is/fimc-lite.h      |   27 ++-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   67 +++++--
 include/media/s5p_fimc.h                           |    2 +
 15 files changed, 405 insertions(+), 128 deletions(-)

Thanks,
Sylwester
