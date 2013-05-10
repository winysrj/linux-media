Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13839 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3EJQrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 12:47:06 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, inki.dae@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Remove "sysreg" clock handling
Date: Fri, 10 May 2013 18:46:35 +0200
Message-id: <1368204395-12732-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "sysreg" clock is required by multiple subsystems and none of the
other drivers handles this clock explicitly. It is currently assumed
that this clock is always on, left in its default state after system
reset.

Remove handling of this clock from the FIMC-IS driver to avoid breaking
other subsystems.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

This patch should be applied after:
[PATCH] clk: samsung: Add CLK_IGNORE_UNUSED flag for the sysreg clocks
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg18076.html

 drivers/media/platform/exynos4-is/fimc-is.c |    1 -
 drivers/media/platform/exynos4-is/fimc-is.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 47c6363..a094bb6 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -48,7 +48,6 @@ static char *fimc_is_clocks[ISS_CLKS_MAX] = {
 	[ISS_CLK_LITE0]			= "lite0",
 	[ISS_CLK_LITE1]			= "lite1",
 	[ISS_CLK_MPLL]			= "mpll",
-	[ISS_CLK_SYSREG]		= "sysreg",
 	[ISS_CLK_ISP]			= "isp",
 	[ISS_CLK_DRC]			= "drc",
 	[ISS_CLK_FD]			= "fd",
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index f5275a5..606a7c9 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -73,7 +73,6 @@ enum {
 	ISS_CLK_LITE0,
 	ISS_CLK_LITE1,
 	ISS_CLK_MPLL,
-	ISS_CLK_SYSREG,
 	ISS_CLK_ISP,
 	ISS_CLK_DRC,
 	ISS_CLK_FD,
--
1.7.9.5

