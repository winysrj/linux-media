Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911Ab2ECWWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 18:22:37 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so2478171dad.5
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 15:22:36 -0700 (PDT)
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 4/6] media/video: add I2C dependencies
Date: Thu,  3 May 2012 16:22:25 -0600
Message-Id: <1336083747-3142-5-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Davinci VIDEO_VPFE_CAPTURE depends on I2C, so reflect that
in Kconfig to avoid build failures in random configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/video/davinci/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 60a456e..9337b56 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -40,6 +40,7 @@ config VIDEO_VPSS_SYSTEM
 config VIDEO_VPFE_CAPTURE
 	tristate "VPFE Video Capture Driver"
 	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	  Support for DMx/AMx VPFE based frame grabber. This is the
-- 
1.7.5.4

