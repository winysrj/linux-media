Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab3DYOBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 10:01:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 49DDC40BB3
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 16:00:59 +0200 (CEST)
Date: Thu, 25 Apr 2013 16:00:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: soc-camera: remove unneeded include path
Message-ID: <Pine.LNX.4.64.1304251600230.21045@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera isn't sufficiently broken to include any files from the
drivers/media/i2c/soc_camera directory in its core or host driver files:-)

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 136b7f8..bedb042 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -10,5 +10,3 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
-
-ccflags-y += -I$(srctree)/drivers/media/i2c/soc_camera
-- 
1.7.2.5

