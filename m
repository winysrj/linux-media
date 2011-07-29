Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id A799918B054
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007oy-JP
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 41/59] V4L: mt9m111: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:41 +0200
Message-Id: <1311937019-29914-42-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index c2fe5c9..d7a0773 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -363,21 +363,6 @@ static int mt9m111_reset(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long flags = SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
-static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
-{
-	return 0;
-}
-
 static int mt9m111_make_rect(struct mt9m111 *mt9m111,
 			     struct v4l2_rect *rect)
 {
@@ -698,8 +683,6 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 };
 
 static struct soc_camera_ops mt9m111_ops = {
-	.query_bus_param	= mt9m111_query_bus_param,
-	.set_bus_param		= mt9m111_set_bus_param,
 	.controls		= mt9m111_controls,
 	.num_controls		= ARRAY_SIZE(mt9m111_controls),
 };
-- 
1.7.2.5

