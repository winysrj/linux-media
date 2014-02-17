Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4724 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaBQJ7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 34/35] solo6x10: check dma_map_sg() return value
Date: Mon, 17 Feb 2014 10:57:49 +0100
Message-Id: <1392631070-41868-35-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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

