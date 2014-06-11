Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaFKHdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 03:33:14 -0400
Date: Wed, 11 Jun 2014 10:31:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] davinci: vpif: missing unlocks on error
Message-ID: <20140611073108.GE16443@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently changed some locking around so we need some new unlocks on
the error paths.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Please review this one carefully.  I don't know if the unlock should go
before or after the list_for_each_entry_safe() loop.

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a7ed164..2c08fbd 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -265,6 +265,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 err:
+	spin_unlock_irqrestore(&common->irqlock, flags);
+
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5bb085b..b7b2bdf 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -229,6 +229,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 err:
+	spin_unlock_irqrestore(&common->irqlock, flags);
+
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
