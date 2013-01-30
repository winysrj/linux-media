Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3A3Ljy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 06:39:54 -0500
Date: Wed, 30 Jan 2013 12:39:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Simon Horman <horms@verge.net.au>
Subject: [PATCH] sh-mobile-ceu-camera: fix SHARPNESS control default
Message-ID: <Pine.LNX.4.64.1301301234570.3113@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_SHARPNESS control in the sh-mobile-ceu-camera driver, if off,
turns the CEU low-pass filter on. This is the opposite to the hardware
default and can degrade image quality. Switch default to on to restore the
default unfiltered mode.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This bug breaks RGB and NV12 capture on ecovec, I'll push it for 3.8 and, 
possibly, to stable.

 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index ebbc126..04a7b99 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1064,7 +1064,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 
 		/* Add our control */
 		v4l2_ctrl_new_std(&icd->ctrl_handler, &sh_mobile_ceu_ctrl_ops,
-				  V4L2_CID_SHARPNESS, 0, 1, 1, 0);
+				  V4L2_CID_SHARPNESS, 0, 1, 1, 1);
 		if (icd->ctrl_handler.error)
 			return icd->ctrl_handler.error;
 
-- 
1.7.2.5

