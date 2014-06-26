Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41185 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaFZBHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:32 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so2431445pac.33
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:32 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 21/28] staging: imx-drm: Convert to new ipu_cpmem API
Date: Wed, 25 Jun 2014 18:05:48 -0700
Message-Id: <1403744755-24944-22-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ipu_cpmem_*() calls now take a channel pointer instead of a
pointer into cpmem for that channel.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipuv3-plane.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-plane.c b/drivers/staging/imx-drm/ipuv3-plane.c
index 6f393a1..6ffe1bb 100644
--- a/drivers/staging/imx-drm/ipuv3-plane.c
+++ b/drivers/staging/imx-drm/ipuv3-plane.c
@@ -62,7 +62,6 @@ static inline int calc_bandwidth(int width, int height, unsigned int vref)
 int ipu_plane_set_base(struct ipu_plane *ipu_plane, struct drm_framebuffer *fb,
 		       int x, int y)
 {
-	struct ipu_ch_param __iomem *cpmem;
 	struct drm_gem_cma_object *cma_obj;
 	unsigned long eba;
 
@@ -75,13 +74,12 @@ int ipu_plane_set_base(struct ipu_plane *ipu_plane, struct drm_framebuffer *fb,
 	dev_dbg(ipu_plane->base.dev->dev, "phys = %pad, x = %d, y = %d",
 		&cma_obj->paddr, x, y);
 
-	cpmem = ipu_get_cpmem(ipu_plane->ipu_ch);
-	ipu_cpmem_set_stride(cpmem, fb->pitches[0]);
+	ipu_cpmem_set_stride(ipu_plane->ipu_ch, fb->pitches[0]);
 
 	eba = cma_obj->paddr + fb->offsets[0] +
 	      fb->pitches[0] * y + (fb->bits_per_pixel >> 3) * x;
-	ipu_cpmem_set_buffer(cpmem, 0, eba);
-	ipu_cpmem_set_buffer(cpmem, 1, eba);
+	ipu_cpmem_set_buffer(ipu_plane->ipu_ch, 0, eba);
+	ipu_cpmem_set_buffer(ipu_plane->ipu_ch, 1, eba);
 
 	/* cache offsets for subsequent pageflips */
 	ipu_plane->x = x;
@@ -97,7 +95,6 @@ int ipu_plane_mode_set(struct ipu_plane *ipu_plane, struct drm_crtc *crtc,
 		       uint32_t src_x, uint32_t src_y,
 		       uint32_t src_w, uint32_t src_h)
 {
-	struct ipu_ch_param __iomem *cpmem;
 	struct device *dev = ipu_plane->base.dev->dev;
 	int ret;
 
@@ -175,10 +172,9 @@ int ipu_plane_mode_set(struct ipu_plane *ipu_plane, struct drm_crtc *crtc,
 		return ret;
 	}
 
-	cpmem = ipu_get_cpmem(ipu_plane->ipu_ch);
-	ipu_ch_param_zero(cpmem);
-	ipu_cpmem_set_resolution(cpmem, src_w, src_h);
-	ret = ipu_cpmem_set_fmt(cpmem, fb->pixel_format);
+	ipu_cpmem_zero(ipu_plane->ipu_ch);
+	ipu_cpmem_set_resolution(ipu_plane->ipu_ch, src_w, src_h);
+	ret = ipu_cpmem_set_fmt(ipu_plane->ipu_ch, fb->pixel_format);
 	if (ret < 0) {
 		dev_err(dev, "unsupported pixel format 0x%08x\n",
 			fb->pixel_format);
-- 
1.7.9.5

