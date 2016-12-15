Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35507 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757884AbcLOOFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 09:05:37 -0500
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org, kgene@kernel.org,
        krzk@kernel.org, javier@osg.samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] media: s5p-cec: Remove references to non-existent PLAT_S5P symbol
Date: Thu, 15 Dec 2016 15:03:24 +0100
Message-Id: <20161215140324.28986-2-clabbe.montjoie@gmail.com>
In-Reply-To: <20161215140324.28986-1-clabbe.montjoie@gmail.com>
References: <20161215140324.28986-1-clabbe.montjoie@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P.
This patch remove the last occurrence of this symbol.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/staging/media/s5p-cec/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/s5p-cec/Kconfig b/drivers/staging/media/s5p-cec/Kconfig
index 0315fd7..cba4f8a 100644
--- a/drivers/staging/media/s5p-cec/Kconfig
+++ b/drivers/staging/media/s5p-cec/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_SAMSUNG_S5P_CEC
        tristate "Samsung S5P CEC driver"
-       depends on VIDEO_DEV && MEDIA_CEC && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+       depends on VIDEO_DEV && MEDIA_CEC && (ARCH_EXYNOS || COMPILE_TEST)
        ---help---
          This is a driver for Samsung S5P HDMI CEC interface. It uses the
          generic CEC framework interface.
-- 
2.10.2

