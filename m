Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:39243 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbcAEOud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2016 09:50:33 -0500
From: Geliang Tang <geliangtang@163.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] sh_mobile_ceu_camera: use soc_camera_from_vb2q
Date: Tue,  5 Jan 2016 22:49:57 +0800
Message-Id: <ff6bbd963c4d015d3fc465a7983e421a1c61b3b7.1452005318.git.geliangtang@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use soc_camera_from_vb2q() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 90c87f2..b9f369c 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -213,8 +213,7 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = container_of(vq,
-			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
@@ -361,8 +360,7 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = container_of(vb->vb2_queue,
-			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
@@ -413,8 +411,7 @@ error:
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = container_of(vb->vb2_queue,
-			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -444,8 +441,7 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = container_of(vb->vb2_queue,
-			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
@@ -460,7 +456,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 
 static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 {
-	struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct list_head *buf_head, *tmp;
-- 
2.5.0


