Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59456 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbeAEJn4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 04:43:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Osipenko <digetx@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: tegra-vde: select DMA_SHARED_BUFFER
Date: Fri,  5 Jan 2018 10:43:27 +0100
Message-Id: <20180105094343.2813148-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_DMA_SHARED_BUFFER we run into a link error for the
dma_buf_* APIs:

ERROR: "dma_buf_map_attachment" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
ERROR: "dma_buf_attach" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
ERROR: "dma_buf_get" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
ERROR: "dma_buf_put" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
ERROR: "dma_buf_detach" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
ERROR: "dma_buf_unmap_attachment" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/tegra-vde/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/tegra-vde/Kconfig b/drivers/staging/media/tegra-vde/Kconfig
index ec3ddddebdaa..5c4914674468 100644
--- a/drivers/staging/media/tegra-vde/Kconfig
+++ b/drivers/staging/media/tegra-vde/Kconfig
@@ -1,6 +1,7 @@
 config TEGRA_VDE
 	tristate "NVIDIA Tegra Video Decoder Engine driver"
 	depends on ARCH_TEGRA || COMPILE_TEST
+	select DMA_SHARED_BUFFER
 	select SRAM
 	help
 	    Say Y here to enable support for the NVIDIA Tegra video decoder
-- 
2.9.0
