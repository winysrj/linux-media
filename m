Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50018 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966146AbeEXVgt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 17:36:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Subject: [PATCH] v4l: vsp1: Fix YCbCr planar formats pitch calculation
Date: Fri, 25 May 2018 00:36:42 +0300
Message-Id: <20180524213642.14584-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

YCbCr planar formats can have different pitch values for the luma and
chroma planes. This isn't taken into account in the driver. Fix it.

Based on a BSP patch from Koji Matsuoka <koji.matsuoka.xm@renesas.com>.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index edb35a5c57ea..917f60f553fc 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -771,6 +771,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
 	const struct vsp1_format_info *fmtinfo;
+	unsigned int chroma_hsub;
 	struct vsp1_rwpf *rpf;
 
 	if (rpf_index >= vsp1->info->rpf_count)
@@ -811,10 +812,18 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 		return -EINVAL;
 	}
 
+	/*
+	 * Only formats with three planes can affect the chroma planes pitch.
+	 * All formats with two planes have a horizontal subsampling value of 2,
+	 * but combine U and V in a single chroma plane, which thus results in
+	 * the luma plane and chroma plane having the same pitch.
+	 */
+	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
+
 	rpf->fmtinfo = fmtinfo;
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
-	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
+	rpf->format.plane_fmt[1].bytesperline = cfg->pitch / chroma_hsub;
 	rpf->alpha = cfg->alpha;
 
 	rpf->mem.addr[0] = cfg->mem[0];
-- 
Regards,

Laurent Pinchart
