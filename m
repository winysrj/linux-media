Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:56170 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZLINV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 08:21:58 -0500
Received: by ywh36 with SMTP id 36so6513681ywh.15
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 05:22:04 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Magnus Damm <magnus.damm@gmail.com>,
	m-karicheri2@ti.com, g.liakhovetski@gmx.de, mchehab@infradead.org
Date: Wed, 09 Dec 2009 22:16:24 +0900
Message-Id: <20091209131624.8044.18187.sendpatchset@rxone.opensource.se>
Subject: [PATCH] sh_mobile_ceu_camera: Remove frame size page alignment
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@opensource.se>

This patch updates the SuperH Mobile CEU driver to
not page align the frame size. Useful in the case of
USERPTR with non-page aligned frame sizes and offsets.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/media/video/sh_mobile_ceu_camera.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- 0010/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2009-12-09 17:54:37.000000000 +0900
@@ -199,14 +199,13 @@ static int sh_mobile_ceu_videobuf_setup(
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
 
-	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
-			   bytes_per_pixel);
+	*size = icd->user_width * icd->user_height * bytes_per_pixel;
 
 	if (0 == *count)
 		*count = 2;
 
 	if (pcdev->video_limit) {
-		while (*size * *count > pcdev->video_limit)
+		while (PAGE_ALIGN(*size) * *count > pcdev->video_limit)
 			(*count)--;
 	}
 
