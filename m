Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946062AbcBSMIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 07:08:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH] [media] vsp1_drm.h: add missing prototypes
Date: Fri, 19 Feb 2016 10:08:21 -0200
Message-Id: <18922936dc2817488ebba985c5aaf3498f2ef96d.1455883689.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/vsp1/vsp1_drm.c:47:5: warning: no previous prototype for 'vsp1_du_init' [-Wmissing-prototypes]
 int vsp1_du_init(struct device *dev)
     ^
drivers/media/platform/vsp1/vsp1_drm.c:76:5: warning: no previous prototype for 'vsp1_du_setup_lif' [-Wmissing-prototypes]
 int vsp1_du_setup_lif(struct device *dev, unsigned int width,
     ^
drivers/media/platform/vsp1/vsp1_drm.c:221:6: warning: no previous prototype for 'vsp1_du_atomic_begin' [-Wmissing-prototypes]
 void vsp1_du_atomic_begin(struct device *dev)
      ^
drivers/media/platform/vsp1/vsp1_drm.c:273:5: warning: no previous prototype for 'vsp1_du_atomic_update' [-Wmissing-prototypes]
 int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
     ^
drivers/media/platform/vsp1/vsp1_drm.c:451:6: warning: no previous prototype for 'vsp1_du_atomic_flush' [-Wmissing-prototypes]
 void vsp1_du_atomic_flush(struct device *dev)
      ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/vsp1/vsp1_drm.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 7704038c3add..f68056838319 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -35,4 +35,15 @@ int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
+int vsp1_du_init(struct device *dev);
+int vsp1_du_setup_lif(struct device *dev, unsigned int width,
+		      unsigned int height);
+void vsp1_du_atomic_begin(struct device *dev);
+int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
+			  u32 pixelformat, unsigned int pitch,
+			  dma_addr_t mem[2], const struct v4l2_rect *src,
+			  const struct v4l2_rect *dst);
+void vsp1_du_atomic_flush(struct device *dev);
+
+
 #endif /* __VSP1_DRM_H__ */
-- 
2.5.0

