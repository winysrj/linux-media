Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:23045 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZFOQNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 12:13:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] soc_camera: Fix debug output of supported formats count
Message-Id: <3125df3f572c37e50daa.1245081096@SCT-Book>
Date: Mon, 15 Jun 2009 17:51:36 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The supported formats count must be set to 0 after debug output
right before the second pass.

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>

diff --git a/linux/drivers/media/video/soc_camera.c b/linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c
+++ b/linux/drivers/media/video/soc_camera.c
@@ -238,11 +238,11 @@ static int soc_camera_init_user_formats(
 		return -ENOMEM;
 
 	icd->num_user_formats = fmts;
-	fmts = 0;
 
 	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
 
 	/* Second pass - actually fill data formats */
+	fmts = 0;
 	for (i = 0; i < icd->num_formats; i++)
 		if (!ici->ops->get_formats) {
 			icd->user_formats[i].host_fmt = icd->formats + i;
