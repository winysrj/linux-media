Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1I2K5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 06:57:02 -0400
Date: Thu, 29 Sep 2011 12:57:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] V4L: omap3isp: remove redundant operation
Message-ID: <Pine.LNX.4.64.1109291255590.31659@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial arithmetics clean up.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/omap3isp/ispccdc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 40b141c..65ae267 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1834,7 +1834,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		 * callers to request an output size bigger than the input size
 		 * up to the nearest multiple of 16.
 		 */
-		fmt->width = clamp_t(u32, width, 32, (fmt->width + 15) & ~15);
+		fmt->width = clamp_t(u32, width, 32, fmt->width + 15);
 		fmt->width &= ~15;
 		fmt->height = clamp_t(u32, height, 32, fmt->height);
 		break;
-- 
1.7.2.5

