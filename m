Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:37090 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab3ILMng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 08:43:36 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	ismael.luceno@corp.bluecherry.net
Date: Thu, 12 Sep 2013 14:43:34 +0200
MIME-Version: 1.0
Message-ID: <m338pab47d.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] SOLO6x10: Fix video headers on certain hardware.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On certain platforms a sequence of dma_map_sg() and dma_unmap_sg()
discards data previously stored in the buffers. Build video headers
only after the DMA is completed.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index e501287..7a2fd98 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -472,14 +472,11 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	if (vb2_plane_size(vb, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
 		return -EIO;
 
-	sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
-			solo_enc->jpeg_header,
-			solo_enc->jpeg_len);
-
 	frame_size = (vop_jpeg_size(vh) + solo_enc->jpeg_len + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
+	/* may discard all previous data in vbuf->sglist */
 	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
 	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
@@ -488,6 +485,11 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 			     SOLO_JPEG_EXT_SIZE(solo_dev));
 	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
+
+	/* add the header only after dma_unmap_sg() */
+	sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+			    solo_enc->jpeg_header, solo_enc->jpeg_len);
+
 	return ret;
 }
 
@@ -505,12 +507,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 
 	/* If this is a key frame, add extra header */
 	if (!vop_type(vh)) {
-		sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
-				solo_enc->vop,
-				solo_enc->vop_len);
-
 		skip = solo_enc->vop_len;
-
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh) + solo_enc->vop_len);
 	} else {
@@ -524,6 +521,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	frame_size = (vop_mpeg_size(vh) + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
+	/* may discard all previous data in vbuf->sglist */
 	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
 	ret = solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
@@ -531,6 +529,11 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 			SOLO_MP4E_EXT_SIZE(solo_dev));
 	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
+
+	/* add the header only after dma_unmap_sg() */
+	if (!vop_type(vh))
+		sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
+				    solo_enc->vop, solo_enc->vop_len);
 	return ret;
 }
 
