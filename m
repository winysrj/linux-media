Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36334 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbCIGjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 02:39:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 3/4] rcar-vin: Don't implement empty optional clock operations
Date: Mon,  9 Mar 2015 08:39:35 +0200
Message-Id: <1425883176-29859-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock_start and clock_stop operations are now optional, don't
implement empty stubs.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..9351f64 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -977,19 +977,6 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 		icd->devnum);
 }
 
-/* Called with .host_lock held */
-static int rcar_vin_clock_start(struct soc_camera_host *ici)
-{
-	/* VIN does not have "mclk" */
-	return 0;
-}
-
-/* Called with .host_lock held */
-static void rcar_vin_clock_stop(struct soc_camera_host *ici)
-{
-	/* VIN does not have "mclk" */
-}
-
 static void set_coeff(struct rcar_vin_priv *priv, unsigned short xs)
 {
 	int i;
@@ -1803,8 +1790,6 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= rcar_vin_add_device,
 	.remove		= rcar_vin_remove_device,
-	.clock_start	= rcar_vin_clock_start,
-	.clock_stop	= rcar_vin_clock_stop,
 	.get_formats	= rcar_vin_get_formats,
 	.put_formats	= rcar_vin_put_formats,
 	.get_crop	= rcar_vin_get_crop,
-- 
2.0.5

