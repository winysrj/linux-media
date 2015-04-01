Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbbDANP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 09:15:57 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org, virtio-dev@lists.oasis-open.org
Cc: airlied@gmail.com, airlied@redhat.com, mst@redhat.com,
	Gerd Hoffmann <kraxel@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] break kconfig dependency loop
Date: Wed,  1 Apr 2015 15:15:27 +0200
Message-Id: <1427894130-14228-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After adding virtio-gpu I get this funky kconfig dependency loop.

scripts/kconfig/conf --oldconfig Kconfig
drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:5:  symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:34:     symbol DRM_KMS_FB_HELPER is selected by DRM_VIRTIO_GPU
drivers/gpu/drm/virtio/Kconfig:1:       symbol DRM_VIRTIO_GPU depends on VIRTIO
drivers/virtio/Kconfig:1:       symbol VIRTIO is selected by REMOTEPROC
drivers/remoteproc/Kconfig:4:   symbol REMOTEPROC is selected by OMAP_REMOTEPROC
drivers/remoteproc/Kconfig:12:  symbol OMAP_REMOTEPROC depends on OMAP_IOMMU
drivers/iommu/Kconfig:141:      symbol OMAP_IOMMU is selected by VIDEO_OMAP3
drivers/media/platform/Kconfig:96:      symbol VIDEO_OMAP3 depends on VIDEO_V4L2
drivers/media/v4l2-core/Kconfig:6:      symbol VIDEO_V4L2 depends on I2C
drivers/i2c/Kconfig:7:  symbol I2C is selected by FB_DDC
drivers/video/fbdev/Kconfig:59: symbol FB_DDC is selected by FB_CYBER2000_DDC
drivers/video/fbdev/Kconfig:374:        symbol FB_CYBER2000_DDC depends on FB_CYBER2000
drivers/video/fbdev/Kconfig:362:        symbol FB_CYBER2000 depends on FB

Making VIDEO_OMAP3 depend on OMAP_IOMMU instead of selecting it breaks the
loop, which looks like the best way to handle it to me.  I'm open to better
suggestions though.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d9b872b..fc21734 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -87,8 +87,8 @@ config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
 	depends on HAS_DMA
+	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
-	select OMAP_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 3 camera controller.
-- 
1.8.3.1

