Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:55863 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761457AbZLKIPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 03:15:42 -0500
Received: by gxk4 with SMTP id 4so836207gxk.8
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 00:15:49 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Magnus Damm <magnus.damm@gmail.com>,
	m-karicheri2@ti.com, g.liakhovetski@gmx.de, mchehab@infradead.org
Date: Fri, 11 Dec 2009 17:10:06 +0900
Message-Id: <20091211081006.16358.10589.sendpatchset@rxone.opensource.se>
Subject: [PATCH] sh_mobile_ceu_camera: Add physical address alignment checks V2
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@opensource.se>

Make sure physical addresses are 32-bit aligned in the SuperH
Mobile CEU driver V2. The lowest two bits of the frame address
registers are fixed to zero so frame buffers have to be 32-bit
aligned. The V4L2 mmap() case is using dma_alloc_coherent() for
this driver which will return already aligned addresses, but in
the USERPTR case we must make sure that the user space pointer
is valid.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Tested with a hacked up capture.c on a sh7722 Migo-R board.

 V2 moves the checks to sh_mobile_ceu_videobuf_prepare()

 drivers/media/video/sh_mobile_ceu_camera.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- 0010/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2009-12-11 16:52:19.000000000 +0900
@@ -339,7 +339,7 @@ static int sh_mobile_ceu_videobuf_prepar
 	}
 
 	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
-	if (0 != vb->baddr && vb->bsize < vb->size) {
+	if (0 != vb->baddr && vb->bsize < vb->size && !(vb->width & 3)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -348,6 +348,13 @@ static int sh_mobile_ceu_videobuf_prepar
 		ret = videobuf_iolock(vq, vb, NULL);
 		if (ret)
 			goto fail;
+
+		/* the physical address must be 32-bit aligned (USERPTR) */
+		if (videobuf_to_dma_contig(vb) & 3) {
+			ret = -EINVAL;
+			goto fail;
+		}
+
 		vb->state = VIDEOBUF_PREPARED;
 	}
 
