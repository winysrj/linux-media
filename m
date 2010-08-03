Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58892 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 4/5] mx2_camera: add rising edge for pixclock
Date: Tue,  3 Aug 2010 11:37:55 +0200
Message-Id: <1280828276-483-5-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index cf9a604..7f27492 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -785,6 +785,8 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
+	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
+		csicr1 |= CSICR1_REDGE;
 	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
 		csicr1 |= CSICR1_INV_PCLK;
 	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
-- 
1.7.1

