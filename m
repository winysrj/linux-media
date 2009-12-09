Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51015 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZLINMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 08:12:46 -0500
Received: by yxe17 with SMTP id 17so5872230yxe.33
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 05:12:53 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Magnus Damm <magnus.damm@gmail.com>,
	m-karicheri2@ti.com, g.liakhovetski@gmx.de, mchehab@infradead.org
Date: Wed, 09 Dec 2009 22:07:12 +0900
Message-Id: <20091209130712.32292.81708.sendpatchset@rxone.opensource.se>
Subject: [PATCH] sh_mobile_ceu_camera: Add physical address alignment checks
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@opensource.se>

Make sure physical addresses are 32-bit aligned in the
SuperH Mobile CEU driver. The lowest two bits of the
address registers are fixed to zero so frame buffers
have to bit 32-bit aligned. The V4L2 mmap() case is
using dma_alloc_coherent() for this driver which will
return aligned addresses, but in the USERPTR case we
must make sure that the user space pointer is valid.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/media/video/sh_mobile_ceu_camera.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- 0001/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2009-12-09 17:16:47.000000000 +0900
@@ -278,9 +278,14 @@ static int sh_mobile_ceu_capture(struct 
 
 	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
 	ceu_write(pcdev, CDAYR, phys_addr_top);
+	if (phys_addr_top & 3)
+		return -EINVAL;
+
 	if (pcdev->is_interlaced) {
 		phys_addr_bottom = phys_addr_top + icd->user_width;
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
+		if (phys_addr_bottom & 3)
+			return -EINVAL;
 	}
 
 	switch (icd->current_fmt->fourcc) {
@@ -288,13 +293,16 @@ static int sh_mobile_ceu_capture(struct 
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		phys_addr_top += icd->user_width *
-			icd->user_height;
+		phys_addr_top += icd->user_width * icd->user_height;
 		ceu_write(pcdev, CDACR, phys_addr_top);
+		if (phys_addr_top & 3)
+			return -EINVAL;
+
 		if (pcdev->is_interlaced) {
-			phys_addr_bottom = phys_addr_top +
-				icd->user_width;
+			phys_addr_bottom = phys_addr_top + icd->user_width;
 			ceu_write(pcdev, CDBCR, phys_addr_bottom);
+			if (phys_addr_bottom & 3)
+				return -EINVAL;
 		}
 	}
 
