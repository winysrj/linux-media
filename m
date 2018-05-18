Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38564 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeERVJX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:09:23 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] m2m-deinterlace: Remove DMA_ENGINE dependency
Date: Fri, 18 May 2018 18:07:47 -0300
Message-Id: <20180518210748.21983-3-ezequiel@collabora.com>
In-Reply-To: <20180518210748.21983-1-ezequiel@collabora.com>
References: <20180518210748.21983-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA engine subsystem provides stubs for drivers
to build with !DMA_ENGINE. Drop the config dependency.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 46a5431cfac7..a8e0f537cfe9 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -249,7 +249,7 @@ config VIDEO_MEDIATEK_VCODEC
 
 config VIDEO_MEM2MEM_DEINTERLACE
 	tristate "Deinterlace support"
-	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
2.16.3
