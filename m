Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4472 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaBOMUe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 07:20:34 -0500
Message-ID: <52FF5B6C.8040303@xs4all.nl>
Date: Sat, 15 Feb 2014 13:19:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [REVIEWv2 PATCH 40/34] solo6x10: check dma_map_sg() return value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dma_map_sg() function can fail, so check for the return value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index ccdf0f3..fa5e8ab 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -479,8 +479,9 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
 	/* may discard all previous data in vbuf->sgl */
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
+	if (!dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
+			DMA_FROM_DEVICE))
+		return -ENOMEM;
 	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
 			     vop_jpeg_offset(vh) - SOLO_JPEG_EXT_ADDR(solo_dev),
 			     frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
@@ -525,8 +526,9 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		& ~(DMA_ALIGN - 1);
 
 	/* may discard all previous data in vbuf->sgl */
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
+	if (!dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
+			DMA_FROM_DEVICE))
+		return -ENOMEM;
 	ret = solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
 			SOLO_MP4E_EXT_ADDR(solo_dev),
 			SOLO_MP4E_EXT_SIZE(solo_dev));
-- 
1.8.4.rc3


