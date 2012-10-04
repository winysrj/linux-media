Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50296 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2JDNOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 09:14:17 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD00JIRE4KAM20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 14:14:44 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBD002WFE3RL3B0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 14:14:15 +0100 (BST)
Message-id: <506D8BA6.5000808@samsung.com>
Date: Thu, 04 Oct 2012 15:14:14 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL FOR v3.7] Exynos/S5P MIPI-CSIS driver updates
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4fc8566367d6e0b460f67373423aa4f6b9cbf3ec:

  ARM: samsung: move platform_data definitions (2012-10-03 18:42:54 +0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_for_mauro_2

for you to fetch changes up to f53db50df38ab6d688ca76326784ce5837448cca:

  s5p-csis: Allow to specify pixel clock's source through platform data (2012-10-03 18:49:26 +0200)

This pull request depends on patch from Arnd Bergman, moving platform
data headers out of arch/arm to include/linux/platform_data. This
commit is already in Linus' tree 

436d42c61c3eef1d02256174c8615046c61a28ad
ARM: samsung: move platform_data definitions

and I have cherry-picked it on top of staging/for_v3.7 branch, before
applying my patches.

The patches touching arch/arm/mach-exynos and arch/arm/plat-samsung
have been already acked by the Samsung maintainer.

The changes here are related mostly to the device tree support for 
the s5p-csis driver.

----------------------------------------------------------------
Sylwester Nawrocki (7):
      ARM: samsung: Remove unused fields from FIMC and CSIS platform data
      ARM: samsung: Change __s5p_mipi_phy_control() function signature
      s5p-csis: Change regulator supply names
      ARM: EXYNOS: Change MIPI-CSIS device regulator supply names
      s5p-csis: Replace phy_enable platform data callback with direct call
      s5p-fimc: Remove unused platform data structure fields
      s5p-csis: Allow to specify pixel clock's source through platform data

 arch/arm/mach-exynos/mach-nuri.c            |    7 ++-----
 arch/arm/mach-exynos/mach-origen.c          |    4 ++--
 arch/arm/mach-exynos/mach-universal_c210.c  |    7 ++-----
 arch/arm/plat-samsung/setup-mipiphy.c       |   20 +++++++-----------
 drivers/media/platform/s5p-fimc/mipi-csis.c |   23 +++++++++++---------
 include/linux/platform_data/mipi-csis.h     |   30 +++++++++++----------------
 include/media/s5p_fimc.h                    |    2 --
 7 files changed, 38 insertions(+), 55 deletions(-)

---

Regards,
Sylwester
