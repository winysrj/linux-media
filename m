Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53370 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756164AbcIFKfz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:35:55 -0400
To: linux-media@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pxa_camera: allow building it if COMPILE_TEST is set
Message-ID: <e8d8d4e5-9852-3cc0-b287-f15dad7605ce@xs4all.nl>
Date: Tue, 6 Sep 2016 12:35:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow building this driver if COMPILE_TEST is set.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 09ad065..2ebf170 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -93,7 +93,8 @@ config VIDEO_OMAP3_DEBUG

  config VIDEO_PXA27x
  	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && HAS_DMA
+	depends on VIDEO_DEV && HAS_DMA
+	depends on PXA27x || COMPILE_TEST
  	select VIDEOBUF2_DMA_SG
  	select SG_SPLIT
  	---help---
