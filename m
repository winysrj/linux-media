Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.181.189]:49305 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaEXF2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 01:28:51 -0400
Received: from smtp53.i.mail.ru (smtp53.i.mail.ru [94.100.177.113])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id D5EAF116F2B51
	for <linux-media@vger.kernel.org>; Sat, 24 May 2014 08:57:11 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/2] media: mx2_camera: Change Kconfig dependency
Date: Sat, 24 May 2014 08:56:23 +0400
Message-Id: <1400907383-32590-2-git-send-email-shc_work@mail.ru>
In-Reply-To: <1400907383-32590-1-git-send-email-shc_work@mail.ru>
References: <1400907383-32590-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch change MACH_MX27 dependency to SOC_IMX27 for MX2 camera
driver, since MACH_MX27 symbol is scheduled for removal.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/soc_camera/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 122e03a..fc62897 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -63,7 +63,7 @@ config VIDEO_OMAP1
 
 config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && MACH_MX27
+	depends on VIDEO_DEV && SOC_CAMERA && SOC_IMX27
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
-- 
1.8.5.5

