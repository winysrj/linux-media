Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 1E7CC189B84
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007n5-Qb
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/59] V4L: sh_mobile_ceu_camera: fix field addresses in interleaved mode
Date: Fri, 29 Jul 2011 12:56:03 +0200
Message-Id: <1311937019-29914-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In interlaced interleaved mode field offset for deinterlacing depends
on the pixel format.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 407b96a..a322f83 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -267,6 +267,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	unsigned long top1, top2;
 	unsigned long bottom1, bottom2;
 	u32 status;
+	bool planar;
 	int ret = 0;
 
 	/*
@@ -314,17 +315,29 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 	phys_addr_top = vb2_dma_contig_plane_paddr(pcdev->active, 0);
 
-	ceu_write(pcdev, top1, phys_addr_top);
-	if (V4L2_FIELD_NONE != pcdev->field) {
-		phys_addr_bottom = phys_addr_top + icd->user_width;
-		ceu_write(pcdev, bottom1, phys_addr_bottom);
-	}
-
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
+		planar = true;
+		break;
+	default:
+		planar = false;
+	}
+
+	ceu_write(pcdev, top1, phys_addr_top);
+	if (V4L2_FIELD_NONE != pcdev->field) {
+		if (planar)
+			phys_addr_bottom = phys_addr_top + icd->user_width;
+		else
+			phys_addr_bottom = phys_addr_top +
+				soc_mbus_bytes_per_line(icd->user_width,
+							icd->current_fmt->host_fmt);
+		ceu_write(pcdev, bottom1, phys_addr_bottom);
+	}
+
+	if (planar) {
 		phys_addr_top += icd->user_width *
 			icd->user_height;
 		ceu_write(pcdev, top2, phys_addr_top);
-- 
1.7.2.5

