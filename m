Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45103 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3JOPfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:35:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Replace ioread32/iowrite32 I/O accessors with readl/writel
Date: Tue, 15 Oct 2013 17:35:54 +0200
Message-Id: <1381851354-11925-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ioread32() and iowrite32() I/O accessors are not available on all
architectures. Replace them with readl() and writel() to avoid
compilation failures. Although VSP1 devices are only available on
Renesas ARM platforms, allowing the driver to compile on all
architectures is useful to catch compilation-time issues.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

This fix is a candidate for v3.12, as building the kernel with allyesconfig
on architectures without ioread32/iowrite32 support currently fails on
v3.12-rc5.

I'll send a pull request to the media tree shortly along with another v3.12
fix that has previously been posted to the linux-media mailing list.

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index d6c6ecd..7dab256 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -63,12 +63,12 @@ void vsp1_device_put(struct vsp1_device *vsp1);
 
 static inline u32 vsp1_read(struct vsp1_device *vsp1, u32 reg)
 {
-	return ioread32(vsp1->mmio + reg);
+	return readl(vsp1->mmio + reg);
 }
 
 static inline void vsp1_write(struct vsp1_device *vsp1, u32 reg, u32 data)
 {
-	iowrite32(data, vsp1->mmio + reg);
+	writel(data, vsp1->mmio + reg);
 }
 
 #endif /* __VSP1_H__ */
-- 
Laurent Pinchart

