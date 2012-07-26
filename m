Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2GZLUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:20:52 -0400
Received: by wgbdr13 with SMTP id dr13so1708544wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:20:51 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, sakari.ailus@maxwell.research.nokia.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	linux@arm.linux.org.uk, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/4] media: mx2_camera: Mark i.MX25 support as BROKEN.
Date: Thu, 26 Jul 2012 13:20:35 +0200
Message-Id: <1343301637-19676-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
References: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i.MX25 support is known to have been broken for
almost a year.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c0b9233..af9d2d0 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1136,7 +1136,7 @@ config VIDEO_MX2_HOSTSUPPORT
 
 config VIDEO_MX2
 	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
+	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || (ARCH_MX25 && BROKEN))
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_MX2_HOSTSUPPORT
 	---help---
-- 
1.7.9.5

