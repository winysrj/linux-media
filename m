Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39283 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2JVKdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 06:33:19 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCA005FUINIB8Q0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Oct 2012 19:33:18 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCA001FRINAG800@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Oct 2012 19:33:17 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-csis: Select S5P_SETUP_MIPIPHY
Date: Mon, 22 Oct 2012 12:33:07 +0200
Message-id: <1350901987-26144-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After commit ccbfd1d49dc0d6a "[media] s5p-csis: Replace phy_enable platform.."
s5p-csis depends now on the commmon MIPI CSIS/MIPI DSIM DPHY control code.
Add select S5P_SETUP_MIPIPHY to make this dependency explicit, until
the code from arch/arm/plat-samsung is moved to drivers/ directory and
converted to a regular phy driver module.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-fimc/Kconfig b/drivers/media/platform/s5p-fimc/Kconfig
index 8f090a8..c16b20d 100644
--- a/drivers/media/platform/s5p-fimc/Kconfig
+++ b/drivers/media/platform/s5p-fimc/Kconfig
@@ -24,6 +24,7 @@ config VIDEO_S5P_FIMC
 config VIDEO_S5P_MIPI_CSIS
 	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
 	depends on REGULATOR
+	select S5P_SETUP_MIPIPHY
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
 	  receiver (MIPI-CSIS) devices.
-- 
1.7.9.5

