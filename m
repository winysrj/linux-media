Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:4770 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbZDBJtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 05:49:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] soc_camera: Fix debug output of supported formats count
Message-Id: <77e3600851e692cb4ee9.1238662505@SCT-Book>
Date: Thu, 02 Apr 2009 10:55:05 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The supported formats count must be set to 0 after debug output
right before the second pass.

diff --git a/linux/drivers/media/video/soc_camera.c b/linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c
+++ b/linux/drivers/media/video/soc_camera.c
@@ -236,11 +236,11 @@ static int soc_camera_init_user_formats(
 		return -ENOMEM;
 
 	icd->num_user_formats = fmts;
-	fmts = 0;
 
 	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
 
 	/* Second pass - actually fill data formats */
+	fmts = 0;
 	for (i = 0; i < icd->num_formats; i++)
 		if (!ici->ops->get_formats) {
 			icd->user_formats[i].host_fmt = icd->formats + i;
