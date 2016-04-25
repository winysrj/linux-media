Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37359 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205AbcDYVga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 17:36:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 13/13] v4l: vsp1: Remove deprecated DRM API
Date: Tue, 26 Apr 2016 00:36:38 +0300
Message-Id: <1461620198-13428-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRM driver has switched to the new API, remove the deprecated macros
and inline wrapper.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c |  6 +++---
 include/media/vsp1.h                   | 28 ++--------------------------
 2 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index fef53ecefe25..14730119687f 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -255,8 +255,8 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
  *
  * Return 0 on success or a negative error code on failure.
  */
-int __vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
-			    const struct vsp1_du_atomic_config *cfg)
+int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
+			  const struct vsp1_du_atomic_config *cfg)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	const struct vsp1_format_info *fmtinfo;
@@ -310,7 +310,7 @@ int __vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__vsp1_du_atomic_update);
+EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
 
 static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 				  struct vsp1_rwpf *rpf, unsigned int bru_input)
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index ea8ad7537057..9322d9775fb7 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -34,32 +34,8 @@ struct vsp1_du_atomic_config {
 };
 
 void vsp1_du_atomic_begin(struct device *dev);
-int __vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
-			    const struct vsp1_du_atomic_config *cfg);
+int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
+			  const struct vsp1_du_atomic_config *cfg);
 void vsp1_du_atomic_flush(struct device *dev);
 
-static inline int vsp1_du_atomic_update_old(struct device *dev,
-	unsigned int rpf, u32 pixelformat, unsigned int pitch,
-	dma_addr_t mem[2], const struct v4l2_rect *src,
-	const struct v4l2_rect *dst)
-{
-	struct vsp1_du_atomic_config cfg = {
-		.pixelformat = pixelformat,
-		.pitch = pitch,
-		.mem[0] = mem[0],
-		.mem[1] = mem[1],
-		.src = *src,
-		.dst = *dst,
-		.alpha = 255,
-		.zpos = 0,
-	};
-
-	return __vsp1_du_atomic_update(dev, rpf, &cfg);
-}
-
-#define _vsp1_du_atomic_update(_1, _2, _3, _4, _5, _6, _7, f, ...) f
-#define vsp1_du_atomic_update(...) \
-	_vsp1_du_atomic_update(__VA_ARGS__, vsp1_du_atomic_update_old, 0, 0, \
-			       0, __vsp1_du_atomic_update)(__VA_ARGS__)
-
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.7.3

