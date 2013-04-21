Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:56905 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3DUTVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:21:08 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, jtp.park@samsung.com,
	t.stanislaws@samsung.com, inki.dae@samsung.com,
	jy0922.shim@samsung.com, sw0312.kim@samsung.com,
	jg1.han@samsung.com, dh09.lee@samsung.com, sbkim73@samsung.com,
	linux@arm.linux.org.uk, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] MAINTAINERS: Add linux-samsung-soc list to all related entries
Date: Sun, 21 Apr 2013 21:20:50 +0200
Message-Id: <1366572050-626-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several entries in MAINTAINERS file related to Samsung SoCs do not point
to linux-samsung-soc mailing list, which is supposed to collect all
Samsung SoC-related threads, to ease following of Samsung SoC-related
work. This leads to a problem with people skipping this mailing list in
their posts, even though they are related to Samsung SoCs.

This patch adds pointers to linux-samsung-soc mailing list to affected
entries of MAINTAINERS file.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c0d68b..07cb8da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1139,6 +1139,7 @@ F:	arch/arm/mach-exynos*/
 ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5pv210/mach-aquila.c
 F:	arch/arm/mach-s5pv210/mach-goni.c
@@ -1150,6 +1151,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Kamil Debski <k.debski@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/media/platform/s5p-g2d/
 
@@ -1158,6 +1160,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-samsung/include/plat/*fimc*
 F:	drivers/media/platform/s5p-fimc/
@@ -1168,6 +1171,7 @@ M:	Kamil Debski <k.debski@samsung.com>
 M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/
@@ -1177,6 +1181,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Tomasz Stanislawski <t.stanislaws@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/media/platform/s5p-tv/
 
@@ -2679,6 +2684,7 @@ M:	Joonyoung Shim <jy0922.shim@samsung.com>
 M:	Seung-Woo Kim <sw0312.kim@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	dri-devel@lists.freedesktop.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
 S:	Supported
 F:	drivers/gpu/drm/exynos
@@ -3142,6 +3148,7 @@ F:	Documentation/extcon/
 EXYNOS DP DRIVER
 M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/exynos/exynos_dp*
 F:	include/video/exynos_dp*
@@ -3151,6 +3158,7 @@ M:	Inki Dae <inki.dae@samsung.com>
 M:	Donghwa Lee <dh09.lee@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-fbdev@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/exynos/exynos_mipi*
 F:	include/video/exynos_mipi*
@@ -6892,12 +6900,14 @@ F:	drivers/platform/x86/samsung-laptop.c
 SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Sangbeom Kim <sbkim73@samsung.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/samsung
 
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/s3c-fb.c
 
@@ -7087,6 +7097,7 @@ F:	drivers/mmc/host/sdhci-pltfm.[ch]
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-mmc@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
-- 
1.8.2.1

