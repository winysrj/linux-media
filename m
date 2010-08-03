Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58895 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 2/5] mx2_camera: remove emma limitation for RGB565
Date: Tue,  3 Aug 2010 11:37:53 +0200
Message-Id: <1280828276-483-3-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the current source status the emma has no limitation for any PIXFMT
since the data is parsed raw and unprocessed into the memory.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index c77a673..ae27640 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -897,10 +897,6 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* eMMA can only do RGB565 */
-	if (mx27_camera_emma(pcdev) && pix->pixelformat != V4L2_PIX_FMT_RGB565)
-		return -EINVAL;
-
 	mf.width	= pix->width;
 	mf.height	= pix->height;
 	mf.field	= pix->field;
@@ -944,10 +940,6 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 
 	/* FIXME: implement MX27 limits */
 
-	/* eMMA can only do RGB565 */
-	if (mx27_camera_emma(pcdev) && pixfmt != V4L2_PIX_FMT_RGB565)
-		return -EINVAL;
-
 	/* limit to MX25 hardware capabilities */
 	if (cpu_is_mx25()) {
 		if (xlate->host_fmt->bits_per_sample <= 8)
-- 
1.7.1

