Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1I1LDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 07:03:46 -0400
Date: Wed, 28 Sep 2011 13:03:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2] V4L: mt9p031 and mt9t001 drivers depend on VIDEO_V4L2_SUBDEV_API
In-Reply-To: <Pine.LNX.4.64.1109281257510.30317@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109281301580.30317@axis700.grange>
References: <Pine.LNX.4.64.1109281257510.30317@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch it is possible to select mt9p031 and mt9t001 camera
sensor drivers, but their compilation fails if VIDEO_V4L2_SUBDEV_API is 
not set.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2: better yet depend on VIDEO_V4L2_SUBDEV_API

 drivers/media/video/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index aed5b3d..d2b39e1 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -469,14 +469,14 @@ config VIDEO_OV7670
 
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt9p031 5 Mpixel camera.
 
 config VIDEO_MT9T001
 	tristate "Aptina MT9T001 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.
-- 
1.7.2.5

