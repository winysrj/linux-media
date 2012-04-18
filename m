Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2DRH7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 03:59:04 -0400
Date: Wed, 18 Apr 2012 09:59:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: V4L: mt9m032: fix compilation breakage
Message-ID: <Pine.LNX.4.64.1204180930170.30514@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following compilation failure:

linux-2.6/drivers/media/video/mt9m032.c: In function '__mt9m032_get_pad_crop':
linux-2.6/drivers/media/video/mt9m032.c:337: error: implicit declaration of function 'v4l2_subdev_get_try_crop'
linux-2.6/drivers/media/video/mt9m032.c:337: warning: return makes pointer from integer without a cast
linux-2.6/drivers/media/video/mt9m032.c: In function '__mt9m032_get_pad_format':
linux-2.6/drivers/media/video/mt9m032.c:359: error: implicit declaration of function 'v4l2_subdev_get_try_format'
linux-2.6/drivers/media/video/mt9m032.c:359: warning: return makes pointer from integer without a cast
linux-2.6/drivers/media/video/mt9m032.c: In function 'mt9m032_probe':
linux-2.6/drivers/media/video/mt9m032.c:767: error: 'struct v4l2_subdev' has no member named 'entity'
linux-2.6/drivers/media/video/mt9m032.c:826: error: 'struct v4l2_subdev' has no member named 'entity'
linux-2.6/drivers/media/video/mt9m032.c: In function 'mt9m032_remove':
linux-2.6/drivers/media/video/mt9m032.c:842: error: 'struct v4l2_subdev' has no member named 'entity'
make[4]: *** [drivers/media/video/mt9m032.o] Error 1

by adding a dependency on VIDEO_V4L2_SUBDEV_API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2479c5..ce1e7ba 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -492,7 +492,7 @@ config VIDEO_VS6624
 
 config VIDEO_MT9M032
 	tristate "MT9M032 camera sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select VIDEO_APTINA_PLL
 	---help---
 	  This driver supports MT9M032 camera sensors from Aptina, monochrome
-- 
1.7.2.5

