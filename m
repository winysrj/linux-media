Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46990 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2IQKs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:48:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/7] s5p-fimc/mipi-csis drivers cleanup
Date: Mon, 17 Sep 2012 12:48:08 +0200
Message-id: <1347878888-30001-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is a cleanup of s5p-fimc/mipi-csis drivers and changes required
for adding device tree support. It depends on Arnd's platform data headers
cleanup patch:
"ARM: samsung: move platform_data definitions"
git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=d7243bd51b783ffd2

Sylwester Nawrocki (7):
  ARM: samsung: Remove unused fields from FIMC and CSIS platform data
  ARM: samsung: Change __s5p_mipi_phy_control() function signature
  ARM: EXYNOS: Change MIPI-CSIS device regulator supply names
  s5p-csis: Replace phy_enable platform data callback with direct call
  s5p-fimc: Remove unused platform data structure fields
  s5p-csis: Allow to specify pixel clock's source through platform data
  s5p-csis: Change regulator supply names

 arch/arm/mach-exynos/mach-nuri.c           |  7 ++-----
 arch/arm/mach-exynos/mach-origen.c         |  4 ++--
 arch/arm/mach-exynos/mach-universal_c210.c |  7 ++-----
 arch/arm/plat-samsung/setup-mipiphy.c      | 20 +++++++-------------
 drivers/media/video/s5p-fimc/mipi-csis.c   | 23 +++++++++++++----------
 include/linux/platform_data/mipi-csis.h    | 30 ++++++++++++------------------
 include/media/s5p_fimc.h                   |  2 --
 7 files changed, 38 insertions(+), 55 deletions(-)

--
1.7.11.3

