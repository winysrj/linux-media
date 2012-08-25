Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49790 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HYDJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:20 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so586536ghr.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:20 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Josh Wu <josh.wu@atmel.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 6/9] soc-camera: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:09:03 -0300
Message-Id: <1345864146-2207-6-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Josh Wu <josh.wu@atmel.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c      |    3 ++-
 drivers/media/platform/soc_camera/mx2_camera.c     |    3 ++-
 drivers/media/platform/soc_camera/mx3_camera.c     |    3 ++-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6274a91..0fe61d6 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -515,7 +515,8 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 	q->ops = &isi_video_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 
-	return vb2_queue_init(q);
+	vb2_queue_init(q);
+	return 0;
 }
 
 static int isi_camera_set_fmt(struct soc_camera_device *icd,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 256187f..0fc7714 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -981,7 +981,8 @@ static int mx2_camera_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mx2_buffer);
 
-	return vb2_queue_init(q);
+	vb2_queue_init(q);
+	return 0;
 }
 
 #define MX2_BUS_FLAGS	(V4L2_MBUS_MASTER | \
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 16975c6..7e9ea36 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -456,7 +456,8 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
 
-	return vb2_queue_init(q);
+	vb2_queue_init(q);
+	return 0;
 }
 
 /* First part of ipu_csi_init_interface() */
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 0baaf94..ff32659 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2026,7 +2026,8 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
 
-	return vb2_queue_init(q);
+	vb2_queue_init(q);
+	return 0;
 }
 
 static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
-- 
1.7.8.6

