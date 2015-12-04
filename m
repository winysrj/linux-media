Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbbLDWU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 17:20:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] exynos4-is: make VIDEO_SAMSUNG_EXYNOS4_IS tristate
Date: Fri, 04 Dec 2015 23:20:09 +0100
Message-ID: <2086080.9y3TX8CFJu@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With CONFIG_V4L2=m and VIDEO_SAMSUNG_EXYNOS4_IS=y, we can select the
individual drivers as built-in code when that should not be possible:

drivers/built-in.o: In function `s5pcsis_set_fmt':
policy.c:(.text+0x13afdc): undefined reference to `v4l_bound_align_image'
drivers/built-in.o: In function `s5pcsis_probe':
policy.c:(.text+0x13b440): undefined reference to `v4l2_of_parse_endpoint'
policy.c:(.text+0x13b72c): undefined reference to `v4l2_subdev_init'

Changing VIDEO_SAMSUNG_EXYNOS4_IS to tristate means that the dependency
from CONFIG_V4L2 propates to the individual Kconfig symbols and they
can only be built as loadable modules if V4L2 or any other of the
dependencies itself is a module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 40423c6c5324..57d42c6172c5 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -1,6 +1,6 @@
 
 config VIDEO_SAMSUNG_EXYNOS4_IS
-	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
+	tristate "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on OF && COMMON_CLK

