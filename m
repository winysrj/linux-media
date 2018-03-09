Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39413 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932451AbeCIWEP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 17:04:15 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 01/11] media: vsp1: drm: Fix minor grammar error
Date: Fri,  9 Mar 2018 22:03:59 +0000
Message-Id: <2811ffa85a2c4d403fba0a197196bcfd9cfc9e80.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pixel format is 'unsupported'. Fix the small debug message which
incorrectly declares this.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 3c8b1952799d..0459b970e9da 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -363,7 +363,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	 */
 	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
 	if (!fmtinfo) {
-		dev_dbg(vsp1->dev, "Unsupport pixel format %08x for RPF\n",
+		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
 			cfg->pixelformat);
 		return -EINVAL;
 	}
-- 
git-series 0.9.1
