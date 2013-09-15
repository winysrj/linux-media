Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130Ab3IOQz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 12:55:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi3101: correct max videobuf2 alloc
Date: Sun, 15 Sep 2013 19:54:38 +0300
Message-Id: <1379264078-22951-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was too small buffers requested in worst case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 7715c85..4c3bf77 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1131,7 +1131,13 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	/* Absolute min and max number of buffers available for mmap() */
 	*nbuffers = 32;
 	*nplanes = 1;
-	sizes[0] = PAGE_ALIGN(3 * 3072); /* 3 * 768 * 4 */
+	/*
+	 *   3, wMaxPacketSize 3x 1024 bytes
+	 * 504, max IQ sample pairs per 1024 frame
+	 *   2, two samples, I and Q
+	 *   4, 32-bit float
+	 */
+	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 4); /* = 12096 */
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
 	return 0;
-- 
1.7.11.7

