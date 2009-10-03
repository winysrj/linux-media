Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60682 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754909AbZJCLP7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 07:15:59 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Mu2aw-0001fB-3A
	for linux-media@vger.kernel.org; Sat, 03 Oct 2009 13:16:10 +0200
Date: Sat, 3 Oct 2009 13:16:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] sh_mobile_ceu_camera: fix cropping for scaling clients
Message-ID: <Pine.LNX.4.64.0910031313190.5857@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a bug in cropping calculation, when the client is also scaling the image.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 65ac474..2f78b4f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1173,8 +1173,8 @@ static int get_scales(struct soc_camera_device *icd,
 	width_in = scale_up(cam->ceu_rect.width, *scale_h);
 	height_in = scale_up(cam->ceu_rect.height, *scale_v);
 
-	*scale_h = calc_generic_scale(cam->ceu_rect.width, icd->user_width);
-	*scale_v = calc_generic_scale(cam->ceu_rect.height, icd->user_height);
+	*scale_h = calc_generic_scale(width_in, icd->user_width);
+	*scale_v = calc_generic_scale(height_in, icd->user_height);
 
 	return 0;
 }
-- 
1.6.2.4

