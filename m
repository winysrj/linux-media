Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56219 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421Ab3GSIAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 04:00:01 -0400
Received: by mail-lb0-f180.google.com with SMTP id o10so3235320lbi.39
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 00:59:59 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?=C2=A0Mauro=20Carvalho=20Chehab?= <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?UTF-8?q?=C2=A0Ismael=20Luceno?=
	<ismael.luceno@corp.bluecherry.net>,
	=?UTF-8?q?=C2=A0Greg=20Kroah-Hartman?= <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 4/4] media/solo6x10: Changes on the vb2-dma-sg API
Date: Fri, 19 Jul 2013 09:58:49 +0200
Message-Id: <1374220729-8304-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct vb2_dma_sg_desc has been replaced with the generic sg_table
to describe the location of the video buffers.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 98e2902..cfa01f1 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -346,7 +346,7 @@ static int enc_get_mpeg_dma(struct solo_dev *solo_dev, dma_addr_t dma,
 /* Build a descriptor queue out of an SG list and send it to the P2M for
  * processing. */
 static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
-			  struct vb2_dma_sg_desc *vbuf, int off, int size,
+			  struct sg_table *vbuf, int off, int size,
 			  unsigned int base, unsigned int base_size)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
@@ -359,7 +359,7 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 
 	solo_enc->desc_count = 1;
 
-	for_each_sg(vbuf->sglist, sg, vbuf->num_pages, i) {
+	for_each_sg(vbuf->sgl, sg, vbuf->nents, i) {
 		struct solo_p2m_desc *desc;
 		dma_addr_t dma;
 		int len;
@@ -434,7 +434,7 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 		struct vb2_buffer *vb, struct vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_size;
 	int ret;
 
@@ -443,7 +443,7 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	if (vb2_plane_size(vb, 0) < vh->jpeg_size + solo_enc->jpeg_len)
 		return -EIO;
 
-	sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+	sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
 			solo_enc->jpeg_header,
 			solo_enc->jpeg_len);
 
@@ -451,12 +451,12 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 		& ~(DMA_ALIGN - 1);
 	vb2_set_plane_payload(vb, 0, vh->jpeg_size + solo_enc->jpeg_len);
 
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
 			DMA_FROM_DEVICE);
 	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
 			frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
 			SOLO_JPEG_EXT_SIZE(solo_dev));
-	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
 			DMA_FROM_DEVICE);
 	return ret;
 }
@@ -465,7 +465,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		struct vb2_buffer *vb, struct vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
 	int ret;
@@ -475,7 +475,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 
 	/* If this is a key frame, add extra header */
 	if (!vh->vop_type) {
-		sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+		sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
 				solo_enc->vop,
 				solo_enc->vop_len);
 
@@ -494,12 +494,12 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	frame_size = (vh->mpeg_size + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
 			DMA_FROM_DEVICE);
 	ret = solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
 			SOLO_MP4E_EXT_ADDR(solo_dev),
 			SOLO_MP4E_EXT_SIZE(solo_dev));
-	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
 			DMA_FROM_DEVICE);
 	return ret;
 }
-- 
1.7.10.4

